local matchet = require 'matchet.env'

local tnt = require 'torchnet'

local AutogradEngine, Engine = torch.class('AutogradEngine', 'tnt.Engine', tnt)

function AutogradEngine:__init()
   Engine.__init(self, {
      "onStart", "onStartEpoch",
      "onSample", "onForward", "onBackward",
      "onEndEpoch", "onUpdate", "onEnd"
   })
end

function AutogradEngine:train(opt)
   opt.maxepoch = opt.maxepoch or 1000

   local state = {
      model = opt.model,
      iterator = opt.iterator,
      optimMethod = opt.optimMethod,
      optimState = opt.optimState,
      maxepoch = opt.maxepoch,
      valengine = opt.valengine,
      valdata = opt.valdata,
      outputFields = opt.outputFields,
      sample = {},
      epoch = 0, -- epoch done so far
      t = 0, -- samples seen so far
      batch = 0, -- samples seen in current epoch
      epochsize = 0, -- number of batches in epoch
      training = true,
      stop = false
   }

   self.hooks("onStart", state)
   while state.epoch < state.maxepoch and not state.stop do
      state.model:training()

      if torch.typename(state.iterator) == 'tnt.ParallelDatasetIterator' then
         state.epochsize = state.iterator:execSingle('size')
      else
         state.epochsize = state.iterator:exec('size')
      end
      self.hooks("onStartEpoch", state)
      for sample in state.iterator() do
         state.sample = sample
         self.hooks("onSample", state)

         state.model:cast(sample)

         local optimfn = state.optimMethod(function(params, optimSample)
            return state.model:grad(params, optimSample, state.outputFields)
         end, state.optimState, state.model.params)

         local _, _, output = optimfn(sample)
         state.output = output
         self.hooks("onForward", state)
         self.hooks("onBackward", state)

         state.t = state.t + 1
         state.batch = state.batch + 1
         self.hooks("onUpdate", state)
      end
      state.epoch = state.epoch + 1
      state.batch = 0
      self.hooks("onEndEpoch", state)
   end
   self.hooks("onEnd", state)
end

function AutogradEngine:test(opt)
   local state = {
      model = opt.model,
      iterator = opt.iterator,
      outputFields = opt.outputFields,
      sample = {},
      t = 0, -- samples seen so far
      batch = 0, -- same as t
      epochsize = 0, -- number of batches in epoch
      training = false
   }

   self.hooks("onStart", state)
   state.model:evaluate()

   if torch.typename(state.iterator) == 'tnt.ParallelDatasetIterator' then
      state.epochsize = state.iterator:execSingle('size')
   else
      state.epochsize = state.iterator:exec('size')
   end
   for sample in state.iterator() do
      state.sample = sample
      self.hooks("onSample", state)
      state.model:cast(sample)
      local _, output = state.model:loss(sample, state.outputFields)
      state.output = output
      self.hooks("onForward", state)
      state.t = state.t + 1
      state.batch = state.batch + 1
   end
   self.hooks("onEnd", state)
end

matchet.AutogradEngine = AutogradEngine.new
