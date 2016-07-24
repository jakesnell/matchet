local matchet = require 'matchet.env'

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
