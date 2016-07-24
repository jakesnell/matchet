local matchet = require 'matchet'

function tests.unique()
   local x = torch.LongTensor({{1, 2, 2, 3},
                               {5, 5, 9, 5}})

   tester:eq(matchet.unique(x), torch.LongTensor({1, 2, 3, 5, 9}))
end
