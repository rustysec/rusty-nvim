return require('packer').startup(function(use)
    use { 'kyazdani42/nvim-web-devicons' }
    use { 'wbthomason/packer.nvim' }
    use { 'navarasu/onedark.nvim' }
    use { 'daschw/leaf.nvim' }
    use { 'tpope/vim-repeat' }
    use { 'ggandor/lightspeed.nvim' }
    use { 'nvim-lua/plenary.nvim' }
    use { 'nvim-lua/lsp-status.nvim' }
    use { 'williamboman/mason.nvim' }
    use { 'williamboman/mason-lspconfig.nvim' }
    use { 'neovim/nvim-lspconfig' }
    use { 'lvimuser/lsp-inlayhints.nvim' }
    use { 'hrsh7th/cmp-nvim-lsp' }
    use { 'hrsh7th/cmp-path' }
    use { 'hrsh7th/cmp-buffer' }
    use { 'hrsh7th/nvim-cmp' }
    use { 'hrsh7th/cmp-nvim-lsp-signature-help' }
    use { 'L3MON4D3/LuaSnip' }
    use { 'saadparwaiz1/cmp_luasnip' }
    use { 'lewis6991/gitsigns.nvim' }
    use { 'stevearc/dressing.nvim' }
    use { 'nvim-treesitter/nvim-treesitter' }
    use { 'folke/which-key.nvim' }
    use { 'RRethy/vim-illuminate' }
    use { 'numToStr/Comment.nvim' }
    use { 'lukas-reineke/indent-blankline.nvim' }
    -- use { 'tamago324/lir.nvim' }
    -- use { 'tamago324/lir-git-status.nvim' }
    use { 'elkowar/yuck.vim' }
    -- use { 'elihunter173/dirbuf.nvim' }
    use { 'catppuccin/nvim', as = 'catppuccin' }
    use { 'folke/tokyonight.nvim' }
    use { 'folke/zen-mode.nvim' }
    use { 'folke/twilight.nvim' }
    use { 'declancm/cinnamon.nvim' }
    use { 'nvim-treesitter/playground' }
    use { 'beauwilliams/focus.nvim' }
    use { 'famiu/bufdelete.nvim' }
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = {
            { 'nvim-lua/plenary.nvim' }
        }
    }
    use {
        'nvim-lualine/lualine.nvim',
        requires = {
            'kyazdani42/nvim-web-devicons', opt = true
        }
    }
    use {
        'kylechui/nvim-surround',
        tag = '*',
        config = function()
            require('nvim-surround').setup()
        end
    }
end)
