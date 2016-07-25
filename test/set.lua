local _ = require 'moses'
local matchet = require 'matchet'

function tests.set()
   local Set = matchet.Set

   local s = Set{1, 2, 2, 3}

   -- basic assertions
   tester:eq(s:size(), 3)
   tester:eq(tostring(s), 'Set{1,2,3}')
   tester:eq(s == Set{1, 2, 3}, true)

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
end
