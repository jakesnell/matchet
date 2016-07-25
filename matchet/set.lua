local _ = require 'moses'
local classic = require 'classic'
local tds = require 'tds'

local matchet = require 'matchet.env'

local Set = classic.class('Set')

--[[
   Set implementation
]]--

function Set:_init(...)
   self.s = tds.Hash()
   local args = ... or {}

   for k,v in pairs(args) do
      self:insert(v)
   end
end

function Set:insert(v)
   self.s[v] = true
end

function Set:remove(v)
   self.s[v] = nil
end

function Set:size()
   return #self.s
end

function Set:copy()
   local ret = Set()
   for k,v in pairs(self.s) do
      ret:insert(k)
   end
   return ret
end

function Set:__eq(other)
   return self:_onesidedeq(other) and other:_onesidedeq(self)
end

function Set:_onesidedeq(other)
   for k,v in pairs(self.s) do
      if not other.s[k] then
         return false
      end
   end
   return true
end

function Set:__add(other)
   -- set union
   local ret = self:copy()

   for k,v in pairs(other.s) do
      ret:insert(k)
   end

   return ret
end

function Set:__tostring()
   local keys = { }
   for k, v in pairs(self.s) do
      _.push(keys, k)
   end

   return 'Set{' .. _.join(_.sort(keys), ',') .. '}'
end

matchet.Set = Set
