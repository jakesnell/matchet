local matchet = require 'matchet.env'

local uuid = require 'uuid'
require 'socket'
uuid.seed()

matchet.uuid = function()
   return uuid()
end
