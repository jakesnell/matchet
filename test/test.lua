local _ = require 'moses'
local argcheck = require 'argcheck'
local matchet = require 'matchet'

local tester = torch.Tester()

local tests = torch.TestSuite()

function tests.deepmap()
   local x = {
      a = {1, 2, 3},
      b = {
         c = {
            d = 4,
            e = 5
         },
         f = 6
      }
   }

   local target = {
      a = {3, 4, 5},
      b = {
         c = {
            d = 6,
            e = 7
         },
         f = 8
      }
   }

   local result = matchet.deepmap(x, function(v) return v + 2 end)
   tester:eq(result, target)
end

function tests.neighborpairs()
   local x = torch.LongTensor({{1, 1, 1, 2, 2},
                               {1, 1, 2, 2, 3},
                               {1, 2, 2, 4, 4},
                               {5, 5, 5, 5, 5}})
   local target = torch.LongTensor({{1, 2},
                                    {1, 5},
                                    {2, 3},
                                    {2, 4},
                                    {2, 5},
                                    {3, 4},
                                    {4, 5}})

   tester:eq(matchet.neighborpairs(x), target)
end

function tests.priorityqueue()
   local pq = matchet.PriorityQueue()
   local v = { }
   _.each(_.shuffle(_.range(1, 100)), function(i, v)
      pq:insert(v)
   end)
   tester:eq(pq:size(), 100)

   local popresult = { }
   local peekresult = { }
   for i=1,100 do
      _.push(peekresult, pq:peek())
      _.push(popresult, pq:pop())
   end
   tester:eq(peekresult, _.reverse(_.range(1, 100)))
   tester:eq(popresult, _.reverse(_.range(1, 100)))
end

tester:add(tests):run()
