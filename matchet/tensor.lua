local argcheck = require 'argcheck'
local tds = require 'tds'

local matchet = require 'matchet.env'

matchet.unique = argcheck{
   {name='x',
    type='torch.*Tensor',
    doc='contiguous tensor for which to find unique values',
    check=function(x) return x:isContiguous() end},
   call = function(x)
      local vals = tds.Hash()
      local xdata = torch.data(x)
      for i=0,x:nElement()-1 do
         vals[tonumber(xdata[i])] = true
      end

      local ret = torch.Tensor(#vals):typeAs(x)
      local i = 1
      for k,v in pairs(vals) do
         ret[i] = k
         i = i + 1
      end
      ret = torch.sort(ret)
      return ret
   end
}
