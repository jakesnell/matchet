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

function Set:contains(k)
   if self.s[k] then
      return true
   else
      return false
   end
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
      if not other:contains(k) then
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

function Set:__sub(other)
   -- set difference
   local ret = self:copy()

   for k,v in pairs(other.s) do
      ret:remove(k)
   end

   return ret
end

function Set:__mul(other)
   -- set intersection
   local ret = Set()
   for k,v in pairs(self.s) do
      if other:contains(k) then
         ret:insert(k)
      end
   end
   return ret
end

function Set:__tostring()
   local keys = { }
   for k,v in pairs(self.s) do
      _.push(keys, k)
   end

   return 'Set{' .. _.join(_.sort(keys), ',') .. '}'
end

matchet.Set = Set
