local _ = require 'moses'
local argcheck = require 'argcheck'

require 'torchzlib'

local matchet = require 'matchet.env'

matchet.union = argcheck{
   {name='x', type='table', doc='base table'},
   {name='y', type='table', doc='table to augment x with'},
   call = function(x, y)
      for k,v in pairs(y) do
         x[k] = v
      end
      return x
   end
}

require 'matchet.iter'
require 'matchet.data'
require 'matchet.priorityqueue'
require 'matchet.seg'

return matchet
