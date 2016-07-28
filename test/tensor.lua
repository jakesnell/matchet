local matchet = require 'matchet'

function tests.unique()
   local x = torch.LongTensor({{1, 2, 2, 3},
                               {5, 5, 9, 5}})

   tester:eq(matchet.unique(x), torch.LongTensor({1, 2, 3, 5, 9}))
end

function tests.uniquecount()
   local x = torch.LongTensor({{1, 1, 2, 2},
                               {2, 5, 5, 7},
                               {9, 4, 4, 4}})
   local v = matchet.uniquecount(x)

   tester:eq(#v, 6)
   tester:eq(v[1], 2)
   tester:eq(v[2], 3)
   tester:eq(v[4], 3)
   tester:eq(v[5], 2)
   tester:eq(v[7], 1)
   tester:eq(v[9], 1)
end
