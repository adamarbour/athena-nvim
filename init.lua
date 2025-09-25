require('nixCatsUtils').setup {
  non_nix_value = true,
}

-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('nixCatsUtils.lazyCat').setup(nixCats.pawsible { 'allPlugins', 'start', 'lazy.nvim' }, {
}, lazyOptions)
