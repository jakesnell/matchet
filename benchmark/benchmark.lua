local matchet = require 'matchet'

-- benchmark priority queue
local n = 2000000

local pq = matchet.PriorityQueue()
t = torch.Timer()
for i=1,n do
   pq:insert(math.random())
end
while not pq:isempty() do
   pq:peek()
   pq:pop()
end
print(string.format('pq with %d items took %0.2fs seconds', n, t:time().real))
