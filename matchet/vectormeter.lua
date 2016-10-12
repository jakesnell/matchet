local tnt = require 'torchnet'

local VectorMeter = torch.class('tnt.VectorMeter', 'tnt.Meter', tnt)

function VectorMeter:__init()
   self:reset()
end

function VectorMeter:reset()
   self.v = torch.Tensor()
end

function VectorMeter:add(value)
   if self.v:nElement() == 0 then
      self.v = value:clone()
   else
      self.v = torch.cat({ self.v, value }, 1)
   end
end

function VectorMeter:value()
   return self.v:mean()
end
