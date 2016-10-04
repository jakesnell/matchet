local matchet = require 'matchet'

local tests = { }

function tests.iterDeepmap(tester)
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

return tests
