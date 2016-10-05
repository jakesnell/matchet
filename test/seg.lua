local matchet = require 'matchet'

local tests = { }

function tests.segNeighborpairs(tester)
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

function tests.segSpintersection(tester)
   local x = torch.LongTensor({{1, 1, 1, 2, 2},
                               {1, 1, 2, 2, 3},
                               {1, 2, 2, 4, 4},
                               {5, 5, 5, 5, 5}})
   local y = torch.LongTensor({{1, 1, 1, 1, 1},
                               {1, 1, 1, 1, 1},
                               {2, 2, 2, 2, 2},
                               {2, 2, 2, 2, 2}})
   local z = torch.LongTensor({{1, 1, 2, 2, 3},
                               {1, 1, 2, 2, 3},
                               {1, 1, 2, 2, 3},
                               {1, 1, 2, 2, 3}})
   tester:eq(matchet.spintersection({x}), x)

   -- {x, y}
   -- 1 => 11, 2 => 21, 3 => 31, 4 => 12, 5 => 22, 6 => 42, 7 => 52
   tester:eq(matchet.spintersection({x, y}),
             torch.LongTensor({{1, 1, 1, 2, 2},
                               {1, 1, 2, 2, 3},
                               {4, 5, 5, 6, 6},
                               {7, 7, 7, 7, 7}}))

   -- {x, y, z}
   -- 1 => 111, 2 => 112, 3 => 212, 4 => 213, 5 => 313, 6 => 121, 7 => 221
   -- 8 => 222, 9 => 422, 10 => 423, 11 => 521, 12 => 522, 13 => 523
   tester:eq(matchet.spintersection({x, y, z}),
             torch.LongTensor({{1, 1, 2, 3, 4},
                               {1, 1, 3, 3, 5},
                               {6, 7, 8, 9, 10},
                               {11, 11, 12, 12, 13}}))
end

return tests
