local _ = require 'moses'
local argcheck = require 'argcheck'

require 'torchzlib'

local matchet = { }

matchet.deepmap = function(x, fn)
   if type(x) == 'table' and not torch.isTensor(x) then
      _.each(x, function(k, v) x[k] = matchet.deepmap(v, fn) end)
      return x
   else
      return fn(x)
   end
end

matchet.loadz = function(filename)
   local x = torch.load(filename)
   return matchet.deepmap(x, function(v)
      if torch.typename(v) == 'torch.CompressedTensor' then
         return v:decompress()
      end
   end)
end

matchet.savez = function(filename, x)
   torch.save(filename, matchet.deepmap(x, function(v)
      if torch.isTensor(v) then
         return torch.CompressedTensor(v)
      else
         return v
      end
   end))
end

return matchet
