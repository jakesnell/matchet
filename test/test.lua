local tester = torch.Tester()

local function bindtests(tests)
   local suite = torch.TestSuite()
   for k,v in pairs(tests) do
      suite[k] = function() return v(tester) end
   end
   return suite
end

local function addtests(testfiles)
   for _,v in ipairs(testfiles) do
      tester:add(bindtests(require(v)))
   end
end

addtests({
   'test.iter',
   'test.priorityqueue',
   'test.set',
   'test.tensor',
   'test.seg'
})

tester:run()
