local _ = require 'moses'
local classic = require 'classic'
local tds = require 'tds'

local matchet = require 'matchet.env'

local PriorityQueue = classic.class('PriorityQueue')

--[[
   Utilities to index into a binary tree
]]--

local function parent(loc)
   return math.floor(loc / 2)
end

local function lchild(loc)
   return 2 * loc
end

local function rchild(loc)
   return 2 * loc + 1
end

--[[
   Priority Queue implementation
]]--

function PriorityQueue:_init()
   self.pq = tds.Vec()
   self.keys = tds.Vec()
end

function PriorityQueue:size()
   return #self.pq
end

function PriorityQueue:isempty()
   return self:size() == 0
end

function PriorityQueue:_push(k, v)
   -- add element to end
   self.keys[#self.keys+1] = k
   self.pq[#self.pq+1] = v
end

function PriorityQueue:_remove()
   -- remove last element
   self.pq:remove()
   self.keys:remove()
end

function PriorityQueue:_swap(loc1, loc2)
   -- swap priorities
   local temp = self.pq[loc1]
   self.pq[loc1] = self.pq[loc2]
   self.pq[loc2] = temp

   -- swap keys
   temp = self.keys[loc1]
   self.keys[loc1] = self.keys[loc2]
   self.keys[loc2] = temp
end

function PriorityQueue:_swim(loc)
   while (loc > 1 and self.pq[parent(loc)] < self.pq[loc]) do
      self:_swap(loc, parent(loc))
      loc = parent(loc)
   end
end

function PriorityQueue:_sink(loc)
   while(lchild(loc) <= self:size()) do
      -- find larger of children
      local childloc = lchild(loc)
      if rchild(loc) <= self:size() and 
            self.pq[rchild(loc)] > self.pq[lchild(loc)] then
         childloc = rchild(loc)
      end

      if self.pq[loc] >= self.pq[childloc] then
         -- heap property satisfied
         break
      else
         self:_swap(loc, childloc)
         loc = childloc
      end
   end
end

function PriorityQueue:insert(k, v)
   self:_push(k, v)
   self:_swim(self:size())
end

function PriorityQueue:peek()
   if self:isempty() then
      error('cannot peek an empty queue')
   else
      return self.keys[1]
   end
end

function PriorityQueue:pop()
   if self:isempty() then
      error('cannot pop from empty queue')
   end

   -- get item from root of heap
   local ret = self.keys[1]

   -- swap last with root and shrink size
   self:_swap(1, self:size())
   self:_remove()

   -- sink
   self:_sink(1)

   return ret
end

matchet.PriorityQueue = PriorityQueue
