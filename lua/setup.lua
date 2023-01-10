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
    vim.cmd('hi! link LspInlayHint Comment')
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
            '*.js',
            '*.ts',
            '*.cs',
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
    local lsp_servers = { 'rust_analyzer', 'sumneko_lua', 'tsserver', 'omnisharp', 'gopls' }

    require('mason-lspconfig').setup({
        ensure_installed = lsp_servers
    })

    local lsp_status = require('lsp-status')

    lsp_status.config({
        status_symbol = '[LSP]',
        select_symbol = function(cursor_pos, symbol)
            if symbol.valueRange then
                local value_range = {
                    ["start"] = {
                        character = 0,
                        line = vim.fn.byte2line(symbol.valueRange[1])
                    },
                    ["end"] = {
                        character = 0,
                        line = vim.fn.byte2line(symbol.valueRange[2])
                    }
                }

                return require("lsp-status.util").in_range(cursor_pos, value_range)
            end
        end
    })

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
        ['<leader>v'] = {
            name = 'Git...',
        },
    })
end

local function setup_lir()
    local actions = require 'lir.actions'
    local mark_actions = require 'lir.mark.actions'
    local clipboard_actions = require 'lir.clipboard.actions'

    require 'lir'.setup {
        show_hidden_files = false,
        devicons_enable = true,
        mappings = {
            ['l']     = actions.edit,
            ['<CR>']  = actions.edit,
            ['<C-h>'] = actions.split,
            ['<C-v>'] = actions.vsplit,
            ['<C-t>'] = actions.tabedit,

            ['h'] = actions.up,
            ['q'] = actions.quit,

            ['K'] = actions.mkdir,
            ['N'] = actions.newfile,
            ['R'] = actions.rename,
            ['@'] = actions.cd,
            ['Y'] = actions.yank_path,
            ['.'] = actions.toggle_show_hidden,
            ['D'] = actions.delete,

            ['J'] = function()
                mark_actions.toggle_mark("n")
                vim.cmd('normal! j')
            end,
            ['yy'] = clipboard_actions.copy,
            ['dd'] = clipboard_actions.cut,
            ['p'] = clipboard_actions.paste,
        },
        float = {
            winblend = 0,
            curdir_window = {
                enable = false,
                highlight_dirname = false
            },

            -- -- You can define a function that returns a table to be passed as the third
            -- -- argument of nvim_open_win().
            -- win_opts = function()
            --   local width = math.floor(vim.o.columns * 0.8)
            --   local height = math.floor(vim.o.lines * 0.8)
            --   return {
            --     border = {
            --       "+", "─", "+", "│", "+", "─", "+", "│",
            --     },
            --     width = width,
            --     height = height,
            --     row = 1,
            --     col = math.floor((vim.o.columns - width) / 2),
            --   }
            -- end,
        },
        hide_cursor = true,
        on_init = function()
            -- use visual mode
            vim.api.nvim_buf_set_keymap(
                0,
                "x",
                "J",
                ':<C-u>lua require"lir.mark.actions".toggle_mark("v")<CR>',
                { noremap = true, silent = true }
            )

            -- echo cwd
            vim.api.nvim_echo({ { vim.fn.expand("%:p"), "Normal" } }, false, {})
        end,
    }

    require('lir.git_status').setup()

end

local function setup_leaf()
    local colors = require("leaf.colors").setup()

    require("leaf").setup({
        underlineStyle = "undercurl",
        commentStyle = "NONE",
        functionStyle = "NONE",
        keywordStyle = "italic",
        statementStyle = "bold",
        typeStyle = "NONE",
        variablebuiltinStyle = "italic",
        transparent = true,
        colors = {
            bg_normal = "NONE",
        },
        overrides = {
            TelescopeBorder = { link = "Normal" },
            WinSeparator = { link = "Comment" },
            FloatTitle = { link = "Warning" },
            FloatBoarder = { link = "Warning" },
            Float = { fg = colors.fg_normal, bg = "NONE", },
            lualine_c_normal = { link = "CursorLine" },
        },
        theme = "dark", -- default, based on vim.o.background, alternatives: "light", "dark"
        contrast = "high", -- default, alternatives: "medium", "high"
    })

    vim.cmd("colorscheme leaf")
end

function setup_cinnamon()
    require('cinnamon').setup({
        -- KEYMAPS:
        default_keymaps = true, -- Create default keymaps.
        extra_keymaps = true, -- Create extra keymaps.
        extended_keymaps = false, -- Create extended keymaps.
        override_keymaps = true, -- The plugin keymaps will override any existing keymaps.

        -- OPTIONS:
        always_scroll = false, -- Scroll the cursor even when the window hasn't scrolled.
        centered = true, -- Keep cursor centered in window when using window scrolling.
        disabled = false, -- Disables the plugin.
        default_delay = 7, -- The default delay (in ms) between each line when scrolling.
        hide_cursor = false, -- Hide the cursor while scrolling. Requires enabling termguicolors!
        horizontal_scroll = true, -- Enable smooth horizontal scrolling when view shifts left or right.
        max_length = -1, -- Maximum length (in ms) of a command. The line delay will be
        -- re-calculated. Setting to -1 will disable this option.
        scroll_limit = 150, -- Max number of lines moved before scrolling is skipped. Setting
        -- to -1 will disable this option.
    })
end

function setup_dressing()
    require("dressing").setup({
        input = {
            default_prompt = "➤ ",
            win_options = { winhighlight = "Normal:Comment,NormalNC:Comment" },
        },
        select = {
            backend = { "telescope", "builtin" },
            builtin = { win_options = { winhighlight = "Normal:Normal,NormalNC:Normal" } },
        },
    })
end

function M.setup(configs)
    require('mason').setup()
    require('onedark').setup(configs.onedark)
    require('lightspeed').setup(configs.lightspeed or {})
    -- require('neo-tree').setup(configs["neo-tree"] or {})
    require('lualine').setup(configs.lualine)
    require('gitsigns').setup()
    require('Comment').setup()
    require("indent_blankline").setup()
    require('illuminate').configure()
    require('focus').setup()

    setup_dressing()
    setup_leaf()
    setup_lir()
    setup_completion()
    setup_lsp(configs)
    setup_inlay_hints()
    setup_yank_highlight()
    setup_auto_format()
    setup_cinnamon()
    setup_which_key(configs['which-key'])

    vim.cmd([[ hi! link lualine_c_inactive Comment ]])
    vim.cmd([[ hi! link lualine_c_normal CursorLine ]])

    vim.cmd([[ hi! link lualine_x_filetype_DevIconDefault_normal CursorLine ]])
    vim.cmd([[ hi! link lualine_x_filetype_DevIconDefault_command CursorLine ]])
    vim.cmd([[ hi! link lualine_x_filetype_DevIconDefault_insert CursorLine ]])
    vim.cmd([[ hi! link lualine_x_filetype_DevIconDefault_replace CursorLine ]])
    vim.cmd([[ hi! link lualine_x_filetype_DevIconRs_normal CursorLine ]])
    vim.cmd([[ hi! link lualine_x_filetype_DevIconRs_command CursorLine ]])
    vim.cmd([[ hi! link lualine_x_filetype_DevIconRs_insert CursorLine ]])
    vim.cmd([[ hi! link lualine_x_filetype_DevIconRs_replace CursorLine ]])

    vim.cmd([[ hi! link lualine_y_filetype_DevIconDefault_normal CursorLine ]])
    vim.cmd([[ hi! link lualine_y_filetype_DevIconDefault_command CursorLine ]])
    vim.cmd([[ hi! link lualine_y_filetype_DevIconRs_normal CursorLine ]])
    vim.cmd([[ hi! link lualine_y_filetype_DevIconRs_command CursorLine ]])
end

return M
