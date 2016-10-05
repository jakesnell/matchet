-- utilities for segmentation
local moses = require 'moses'
local argcheck = require 'argcheck'
local tds = require 'tds'

local matchet = require 'matchet.env'

matchet.neighborpairs = argcheck{
   {name='x', type='torch.LongTensor', doc='contiguous 2D tensor of superpixels',
    check=function(x) return x:dim() == 2 and x:isContiguous() end},
   call = function(x)
      local neighbors = { }
      local rstride = x:stride(1)
      local cstride = x:stride(2)
      local xdata = torch.data(x)

      -- check left-right pairs
      for i=1,x:size(1) do
         for j=1,x:size(2)-1 do
            local left = xdata[(i-1)*rstride+(j-1)*cstride]
            local right = xdata[(i-1)*rstride+(j)*cstride]

            if left ~= right then
               local minind = math.min(tonumber(left), tonumber(right))
               local maxind = math.max(tonumber(left), tonumber(right))
               if not neighbors[minind] then
                  neighbors[minind] = { }
               end
               neighbors[minind][maxind] = true
            end
         end
      end

      -- check top-bottom pairs
      for i=1,x:size(1)-1 do
         for j=1,x:size(2) do
            local top = xdata[(i-1)*rstride+(j-1)*cstride]
            local bottom = xdata[(i)*rstride+(j-1)*cstride]

            if top ~= bottom then
               local minind = math.min(tonumber(top), tonumber(bottom))
               local maxind = math.max(tonumber(top), tonumber(bottom))
               if not neighbors[minind] then
                  neighbors[minind] = { }
               end
               neighbors[minind][maxind] = true
            end
         end
      end

      local ret = { }
      moses.each(neighbors, function(i, v)
         local k = moses.sort(moses.keys(v))
         moses.each(k, function(_, n)
            local row = torch.LongTensor(1, 2)
            row[{1,1}] = i
            row[{1,2}] = n
            moses.push(ret, row)
         end)
      end)
      return torch.cat(ret, 1)
   end
}

matchet.spintersection = function(spmats)
   local rval = spmats[1]:clone()
   local flatrval = rval:view(-1):contiguous()
   local npixels = spmats[1]:nElement()

   -- check that the spmats are all the same size
   for i=2,#spmats do
      assert(spmats[i]:isSameSizeAs(spmats[1]))
   end

   -- flatten
   local flatspmat = moses.map(spmats, function(_,v)
      return v:view(1, -1)
   end)
   flatspmat = torch.cat(flatspmat, 1):contiguous()
   local nmats = flatspmat:size(1)
   local flatspmat_data = torch.data(flatspmat)

   local maxind = 0

   local function accumulate(tree, pixelind)
      -- walk through the tree according to indseq
      -- if a value already present, return that, otherwise
      -- write val + 1 to the entry.
      local ind
      for startind=1,nmats-1 do
         ind = tonumber(flatspmat_data[(startind-1)*npixels + pixelind-1])
         if not tree[ind] then
            tree[ind] = tds.Hash()
         end
         tree = tree[ind]
      end

      ind = tonumber(flatspmat_data[(nmats-1)*npixels + pixelind-1])
      if not tree[ind] then
         tree[ind] = maxind + 1
         maxind = maxind + 1
         return tree[ind]
      else
         return tree[ind]
      end
   end

   local flatrval_data = torch.data(flatrval)

   local inds = tds.Hash()
   for j=1,npixels do
      flatrval_data[j-1] = accumulate(inds, j)
   end

   return rval
end

matchet.spcounts = function(spmat)
   local ret = torch.zeros(spmat:max()):long():contiguous()
   local flatspmat = spmat:view(-1):contiguous()

   local flatspmat_data = torch.data(flatspmat)
   local ret_data = torch.data(ret)

   for i=1,flatspmat:size(1) do
      ret_data[flatspmat_data[i-1]-1] = ret_data[flatspmat_data[i-1]-1] + 1
   end
   return ret
end
