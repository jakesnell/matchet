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

dependencies = { 'torch >= 7.0', 'moses', 'argcheck' }

build = {
    type = 'builtin',
    modules = {
        ['matchet.init'] = 'matchet/init.lua',
    }
}
