local argcheck = require 'argcheck'
local tds = require 'tds'

local matchet = require 'matchet.env'

matchet.unique = argcheck{
   {name='x',
    type='torch.*Tensor',
    doc='contiguous tensor for which to find unique values',
    check=function(x) return x:isContiguous() end},
   call = function(x)
      local counts = matchet.uniquecount(x)
      local ret = torch.Tensor(#counts):typeAs(x)
      local i = 1
      for k,v in pairs(counts) do
         ret[i] = k
         i = i + 1
      end
      ret = torch.sort(ret)
      return ret
   end
}

matchet.uniquecount = argcheck{
   {name='x',
    type='torch.*Tensor',
    doc='contiguous tensor for which to find unique values',
    check=function(x) return x:isContiguous() end},
   call = function(x)
      local counts = tds.Hash()
      local xdata = torch.data(x)
      local ind
      for i=0,x:nElement()-1 do
         ind = tonumber(xdata[i])
         counts[ind] = (counts[ind] or 0) + 1
      end
      return counts
   end
}
