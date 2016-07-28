local argcheck = require 'argcheck'
local tds = require 'tds'

local matchet = require 'matchet.env'

matchet.contingency = argcheck{
   {name='x', type='torch.*Tensor',
    doc='first matrix to compute contingency of',
    check=function(x) return x:isContiguous() end},
   {name='y', type='torch.*Tensor',
    doc='second matrix to compute contingency of',
    check=function(y) return y:isContiguous() end},
   call = function(x, y)
      assert(x:isSameSizeAs(y))
      local xunique = matchet.unique(x)
      assert(xunique:min() >= 1)
      local n = xunique:max()

      local yunique = matchet.unique(y)
      assert(yunique:min() >= 1)
      local m = yunique:max()

      local ret = torch.zeros(n, m):long()
      local retdata = torch.data(ret)
      local rowstride = ret:stride(1)
      local colstride = ret:stride(2)

      local xdata = torch.data(x)
      local ydata = torch.data(y)
      local r, c
      local ind
      for i=0,x:nElement()-1 do
         ind = (xdata[i] - 1) * rowstride + (ydata[i] - 1) * colstride
         retdata[ind] = retdata[ind] + 1
      end
      return ret
   end
}

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
