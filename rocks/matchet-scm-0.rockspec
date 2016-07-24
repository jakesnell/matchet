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
        ['matchet.seg'] = 'matchet/seg.lua'
    }
}
