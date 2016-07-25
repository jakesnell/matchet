local _ = require 'moses'
local matchet = require 'matchet'

function tests.set()
   local Set = matchet.Set

   local s = Set{1, 2, 2, 3}

   -- basic assertions
   tester:eq(s:size(), 3)
   tester:eq(tostring(s), 'Set{1,2,3}')
   tester:eq(s == Set{1, 2, 3}, true)

   -- copy
   local s2 = s:copy()
   s2:remove(2)
   tester:eq(s2 == Set{1,3}, true)
   tester:eq(s == Set{1,2,3}, true)

   -- union
   tester:eq(s + Set{4, 7, 10} == Set{1, 2, 3, 4, 7, 10}, true)

   -- intersection
   tester:eq(Set{1, 3, 4, 5} * Set{3, 4, 9, 11} == Set{3, 4}, true)

   -- insertion
   s:insert(8)
   tester:eq(s == Set{1,2,3,8}, true)
   tester:eq(s:size(), 4)

   -- removal
   s:remove(2)
   tester:eq(s == Set{1,3,8}, true)
   tester:eq(s:size(), 3)

   -- set difference
   tester:eq(Set{1, 3, 4, 5} - Set{3, 5, 9, 11} == Set{1, 4}, true)

   -- iteration
   local scopy = Set()
   for k in s:items() do
      scopy:insert(k)
   end
   tester:eq(s == scopy, true)

   -- totable
   tester:eq(Set{1, 5, 4, 3, 5}:totable(), {1, 3, 4, 5})
end
