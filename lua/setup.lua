local M = {}

local function setup_inlay_hints()
    require('lsp-inlayhints').setup()
    vim.api.nvim_create_augroup('LspAttach_inlayhints', {})
    vim.api.nvim_create_autocmd('LspAttach', {
        group = 'LspAttach_inlayhints',
        callback = function(args)
            if not (args.data and args.data.client_id) then
                return
            end

            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            require('lsp-inlayhints').on_attach(client, bufnr, true)
        end,
    })
end

local function setup_yank_highlight()
    vim.api.nvim_create_augroup('YankHighlight', { clear = true })
    vim.api.nvim_create_autocmd('TextYankPost', {
        desc = 'Highlight yanked text',
        group = 'YankHighlight',
        pattern = '*',
        command = 'silent! lua vim.highlight.on_yank()',
    })
end

local function setup_auto_format()
    vim.api.nvim_create_augroup('auto_format', { clear = true })
    vim.api.nvim_create_autocmd('BufWritePre', {
        desc = 'Auto Format on save',
        group = 'auto_format',
        pattern = {
            '*.rs',
            '*.json',
            '*.toml',
            '*.go',
            '*.lua',
            '.js',
            '.ts',
        },
        command = 'silent! lua vim.lsp.buf.format({ async = false })',
    })
end

local function setup_completion()
    local cmp = require('cmp')
    cmp.setup({
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            end,
        },
        sources = {
            { name = 'nvim_lsp' },
            { name = 'cmp-buffer' },
            { name = 'luasnip' },
            { name = 'nvim_lsp_signature_help' },
            { name = 'cmp-path' },
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
    })
end

local function setup_lsp(configs)
    local lsp_servers = { 'rust_analyzer', 'sumneko_lua', 'tsserver' }

    require('mason-lspconfig').setup({
        ensure_installed = lsp_servers
    })

    local lsp_status = require('lsp-status')
    lsp_status.register_progress()

    local capabilities = vim.tbl_deep_extend(
        'force',
        lsp_status.capabilities,
        require('cmp_nvim_lsp').default_capabilities()
    )

    for _, lsp_server in pairs(lsp_servers) do
        local conf = configs.lsp[lsp_server] or {}
        conf.on_attach = lsp_status.on_attach
        conf.capabilities = capabilities
        require('lspconfig')[lsp_server].setup(conf)
    end

end

local function setup_which_key(config)
    local wk = require('which-key')

    wk.setup(config)

    wk.register({
        ['<leader>g'] = {
            name = 'Goto...',
        },
        ['<leader>f'] = {
            name = 'Find...',
        },
        ['<leader>l'] = {
            name = 'LSP...',
        },
    })
end

function M.setup(configs)
    require('mason').setup()
    require('onedark').setup(configs.onedark)
    require('onedark').load()
    require('lightspeed').setup(configs.lightspeed or {})
    require('neo-tree').setup(configs["neo-tree"] or {})
    require('lualine').setup(configs.lualine)
    require('gitsigns').setup()
    require('Comment').setup()
    require("indent_blankline").setup()
    require('illuminate').configure()

    setup_completion()
    setup_lsp(configs)
    setup_inlay_hints()
    setup_yank_highlight()
    setup_auto_format()
    setup_which_key(configs['which-key'])
end

return M
