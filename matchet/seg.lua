-- utilities for segmentation
local _ = require 'moses'
local argcheck = require 'argcheck'

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
               minind = math.min(tonumber(left), tonumber(right))
               maxind = math.max(tonumber(left), tonumber(right))
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
               minind = math.min(tonumber(top), tonumber(bottom))
               maxind = math.max(tonumber(top), tonumber(bottom))
               if not neighbors[minind] then
                  neighbors[minind] = { }
               end
               neighbors[minind][maxind] = true
            end
         end
      end

      local ret = { }
      _.each(neighbors, function(i, v)
         k = _.sort(_.keys(v))
         _.each(k, function(j, n)
            local row = torch.LongTensor(1, 2)
            row[{1,1}] = i
            row[{1,2}] = n
            _.push(ret, row)
         end)
      end)
      return torch.cat(ret, 1)
   end
}
