vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use { 'wbthomason/packer.nvim' }
    use { 'navarasu/onedark.nvim' }
    use { 'tpope/vim-repeat' }
    use { 'ggandor/lightspeed.nvim' }
    use { 'nvim-lua/plenary.nvim' }
    use { 'nvim-lua/lsp-status.nvim' }
    use { "williamboman/mason.nvim" }
    use { 'neovim/nvim-lspconfig' }
    use { 'lvimuser/lsp-inlayhints.nvim' }
    use { 'hrsh7th/cmp-nvim-lsp' }
    use { 'hrsh7th/cmp-buffer' }
    use { 'hrsh7th/nvim-cmp' }
    use { 'hrsh7th/cmp-nvim-lsp-signature-help' }
    use { 'L3MON4D3/LuaSnip' }
    use { 'saadparwaiz1/cmp_luasnip' }
    use { 'lewis6991/gitsigns.nvim' }
    use { 'stevearc/dressing.nvim' }
    use { 'nvim-treesitter/nvim-treesitter' }
    use { 'folke/which-key.nvim' }
    use {
        'famiu/bufdelete.nvim',
        module = 'bufdelete',
        cmd = { 'Bdelete', 'Bwipeout' }
    }
    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        }
    }
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or                            , branch = '0.1.x',
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
