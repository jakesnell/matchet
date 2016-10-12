local c = require 'trepl.colorize'

local classic = require 'classic'
require 'classic.torch'

local autograd = require 'autograd'
local autoutil = require 'autograd.util'

local matchet = require 'matchet.env'

local Model = classic.class('Model')

function Model:_init(opt, components)
   self.opt = autoutil.deepCopy(opt)
   self.components = components
   self.outputs = { }

   self:build()
end

function Model:build()
   self.f = { }
   self.params = { }
   for k,component in pairs(self.components) do
      local f, params = autograd.functionalize(component)
      self.f[k] = f
      self.params[k] = params
   end
end

function Model:functionalize(params)
   params = params or self.params

   local ret = { }

   for k,_ in pairs(self.components) do
      if params[k] then
         ret[k] = function(...) return self.f[k](params[k], ...) end
      else
         ret[k] = function(...) return self.f[k](...) end
      end
   end

   return ret
end

function Model:expose(name, fn)
   -- it is common to have a local function of the form fn(params, ...)
   -- that we want to expose to the outside world as self:fn(...)
   if self[name] then
      error(string.format('field %s already exists!', name))
   else
      self[name] = function(self, ...)
         return fn(self.params, ...)
      end
   end
end

function Model:exposeGrad(name, lossfn)
   if self[name] then
      error(string.format('field %s already exists!', name))
   else
      local grad = autograd.grad(lossfn)
      self.grad = function(self, ...) return grad(...) end
   end
end

function Model:setDefaultOpts(defaults)
   for k,v in pairs(defaults) do
      if not self.opt[k] then
         local msg = ' This is a misspecified opt. Assuming opt.%s = '
         msg = string.format(msg, k) .. tostring(v)
         print(c.cyan '==>' .. msg)
         self.opt[k] = v
      end
   end
end

function Model:registerOutput(outputField, fn)
   if self.outputs[outputField] then
      error(string.format('output %s already exists!', outputField))
   else
      self.outputs[outputField] = fn
   end
end

function Model:collectOutputs(knowns, outputFields)
   local ret = { }
   for _,field in ipairs(outputFields) do
      ret[field] = self.outputs[field](knowns)
   end
   return ret
end

function Model:training()
   -- TODO
end

function Model:evaluate()
   -- TODO
end

function Model:unwrap(output)
   local ret = { }
   for k,v in pairs(output) do
      if type(v) == 'table' and v.value then
         ret[k] = v.value
      else
         ret[k] = v
      end
   end
   return ret
end

function Model:clearState()
   for _,component in pairs(self.components) do
      component:clearState()
   end
end

local function standardizeType(typeName)
   if typeName == 'torch.FloatTensor' then typeName = 'float' end
   if typeName == 'torch.DoubleTensor' then typeName = 'double' end
   if typeName == 'torch.CudaTensor' then typeName = 'cuda' end
   return typeName
end

function Model:getCastType(x)
   if type(x) == 'table' then
      -- is a sample, cast according to the appropriate input field
      return self:typeFromSample(x)
   else
      assert(type(x) == 'string')
      -- x is a string such as 'float' or 'torch.FloatTensor'
      return x
   end
end

function Model:cast(x)
   local castType = standardizeType(self:getCastType(x))
   self.params = autoutil.cast(self.params, castType)
   for _,component in pairs(self.components) do
      component[castType](component)
   end
end

function Model:__write(file)
   self:cast('float')
   self:clearState()
   file:writeObject(self.opt)
   file:writeObject(self.components)
end

function Model:__read(file)
   self.opt = file:readObject()
   self.components = file:readObject()
   self.outputs = { }

   self:build()
end

matchet.Model = Model
