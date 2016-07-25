local matchet = require 'matchet'

tester = torch.Tester()
tests = torch.TestSuite()

require 'test.iter'
require 'test.priorityqueue'
require 'test.set'
require 'test.tensor'
require 'test.seg'

tester:add(tests):run()
