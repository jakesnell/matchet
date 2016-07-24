local _ = require 'moses'
local matchet = require 'matchet'

function tests.priorityqueue()
   local pq = matchet.PriorityQueue()

   local vals = { }
   _.each(_.shuffle(_.range(1, 100)), function(i, v)
      vals[i] = math.random()
      pq:insert(i, vals[i])
   end)
   tester:eq(pq:size(), 100)

   -- find correct order of items to be popped
   local inds = _.reverse(select(2, torch.sort(torch.Tensor(vals))):totable())

   local popresult = { }
   local peekresult = { }
   for i=1,100 do
      _.push(peekresult, pq:peek())
      _.push(popresult, pq:pop())
   end
   tester:eq(pq:isempty(), true)
   tester:eq(peekresult, inds)
   tester:eq(popresult, inds)
end
