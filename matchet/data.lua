local matchet = require 'matchet.env'

matchet.loadz = function(filename, path)
   local x = torch.load(filename)
   if path then
      x = x[path]
   end
   return matchet.deepmap(x, function(v)
      if torch.typename(v) == 'torch.CompressedTensor' then
         return v:decompress()
      else
         return v
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
