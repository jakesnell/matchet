local _ = require 'moses'
local argcheck = require 'argcheck'

local matchet = { }

matchet.deepmap = function(x, fn)
   if type(x) == 'table' then
      _.each(x, function(k, v) x[k] = matchet.deepmap(v, fn) end)
      return x
   else
      return fn(x)
   end
end

return matchet
