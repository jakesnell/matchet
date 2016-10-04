local moses = require 'moses'
local matchet = require 'matchet'

local tests = { }

function tests.priorityqueuePriorityqueue(tester)
   local pq = matchet.PriorityQueue()

   local vals = { }
   moses.each(moses.shuffle(moses.range(1, 100)), function(i, _)
      vals[i] = math.random()
      pq:insert(i, vals[i])
   end)
   tester:eq(pq:size(), 100)

   -- find correct order of items to be popped
   local inds = moses.reverse(select(2, torch.sort(torch.Tensor(vals))):totable())

   local popresult = { }
   local peekresult = { }
   for _=1,100 do
      moses.push(peekresult, pq:peek())
      moses.push(popresult, pq:pop())
   end
   tester:eq(pq:isempty(), true)
   tester:eq(peekresult, inds)
   tester:eq(popresult, inds)
end

return tests
