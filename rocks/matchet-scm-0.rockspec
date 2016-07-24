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
   'classic',
   'moses',
   'torchzlib'
}

build = {
   type = 'builtin',
   modules = {
      ['matchet.env'] = 'matchet/env.lua',
      ['matchet.init'] = 'matchet/init.lua',
      ['matchet.iter'] = 'matchet/iter.lua',
      ['matchet.data'] = 'matchet/data.lua',
      ['matchet.priorityqueue'] = 'matchet/priorityqueue.lua',
      ['matchet.tensor'] = 'matchet/tensor.lua',
      ['matchet.seg'] = 'matchet/seg.lua'
   }
}
