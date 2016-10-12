package = 'matchet'
version = 'scm-0'

source = {
   url = 'git://github.com/jakesnell/matchet.git',
   branch = 'master'
}


description = {
   summary = 'Utilities for blazing trails in Torch',
   homepage = 'https://github.com/jakesnell/matchet',
   license = 'MIT'
}

dependencies = {
   'torch >= 7.0',
   'argcheck',
   'autograd',
   'classic',
   'logroll',
   'moses',
   'tds',
   'torchnet',
   'torchzlib',
   'uuid'
}

build = {
   type = 'builtin',
   modules = {
      ['matchet.env'] = 'matchet/env.lua',
      ['matchet.init'] = 'matchet/init.lua',
      ['matchet.uuid'] = 'matchet/uuid.lua',
      ['matchet.log'] = 'matchet/log.lua',
      ['matchet.iter'] = 'matchet/iter.lua',
      ['matchet.data'] = 'matchet/data.lua',
      ['matchet.priorityqueue'] = 'matchet/priorityqueue.lua',
      ['matchet.set'] = 'matchet/set.lua',
      ['matchet.tensor'] = 'matchet/tensor.lua',
      ['matchet.seg'] = 'matchet/seg.lua',
      ['matchet.autogradengine'] = 'matchet/autogradengine.lua',
      ['matchet.model'] = 'matchet/model.lua',
      ['matchet.vectormeter'] = 'matchet/vectormeter.lua'
   }
}
