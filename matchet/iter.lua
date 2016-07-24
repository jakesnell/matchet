-- utilities for iteration
local _ = require 'moses'
local matchet = require 'matchet.env'

matchet.deepmap = function(x, fn)
   if type(x) == 'table' and not torch.isTensor(x) then
      _.each(x, function(k, v) x[k] = matchet.deepmap(v, fn) end)
      return x
   else
      return fn(x)
   end
end

return iter
