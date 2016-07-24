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
      for i=1,x:size(1) do
         for j=1,x:size(2)-1 do
            local cur = xdata[(i-1)*rstride+(j-1)*cstride]

            -- check left-right pairs
            local right = xdata[(i-1)*rstride+(j)*cstride]

            if cur ~= right then
               minind = math.min(tonumber(cur), tonumber(right))
               maxind = math.max(tonumber(cur), tonumber(right))
               if not neighbors[minind] then
                  neighbors[minind] = { }
               end
               neighbors[minind][maxind] = true
            end
         end
      end

      for i=1,x:size(1)-1 do
         for j=1,x:size(2) do
            local cur = xdata[(i-1)*rstride+(j-1)*cstride]
            -- check top-bottom pairs
            local bottom = xdata[(i)*rstride+(j-1)*cstride]

            if cur ~= bottom then
               minind = math.min(tonumber(cur), tonumber(bottom))
               maxind = math.max(tonumber(cur), tonumber(bottom))
               if not neighbors[minind] then
                  neighbors[minind] = { }
               end
               neighbors[minind][maxind] = true
            end
         end
      end

      local ret = { }
      _.each(neighbors, function(i, v)
         _.each(v, function(j)
            local row = torch.LongTensor(1, 2)
            row[{1,1}] = i
            row[{1,2}] = j
            _.push(ret, row)
         end)
      end)
      return torch.cat(ret, 1)
   end
}
