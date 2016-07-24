local matchet = require 'matchet'

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
