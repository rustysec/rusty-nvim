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
    local lsp_servers = { 'rust_analyzer', 'lua_ls', 'tsserver', 'omnisharp', 'gopls' }

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
        devicons = { enable = true },
        mappings = {
                ['l'] = actions.edit,
                ['<CR>'] = actions.edit,
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
        theme = "dark",    -- default, based on vim.o.background, alternatives: "light", "dark"
        contrast = "high", -- default, alternatives: "medium", "high"
    })

    vim.cmd("colorscheme leaf")
end

local function setup_cinnamon()
    require('cinnamon').setup({
        -- KEYMAPS:
        default_keymaps = true,    -- Create default keymaps.
        extra_keymaps = true,      -- Create extra keymaps.
        extended_keymaps = false,  -- Create extended keymaps.
        override_keymaps = true,   -- The plugin keymaps will override any existing keymaps.
        -- OPTIONS:
        always_scroll = false,     -- Scroll the cursor even when the window hasn't scrolled.
        centered = true,           -- Keep cursor centered in window when using window scrolling.
        disabled = false,          -- Disables the plugin.
        default_delay = 7,         -- The default delay (in ms) between each line when scrolling.
        hide_cursor = false,       -- Hide the cursor while scrolling. Requires enabling termguicolors!
        horizontal_scroll = false, -- Enable smooth horizontal scrolling when view shifts left or right.
        max_length = -1,           -- Maximum length (in ms) of a command. The line delay will be
        -- re-calculated. Setting to -1 will disable this option.
        scroll_limit = 150,        -- Max number of lines moved before scrolling is skipped. Setting
        -- to -1 will disable this option.
    })
end

local function setup_dressing()
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

local function setup_dirbuf()
    require("dirbuf").setup({
        hash_padding = 2,
        show_hidden = true,
        sort_order = "default",
        write_cmd = "DirbufSync",
    })
end

local function setup_catppuccin()
    require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = {
            -- :h background
            light = "latte",
            dark = "mocha",
        },
        transparent_background = false,
        show_end_of_buffer = false, -- show the '~' characters after the end of buffers
        term_colors = false,
        dim_inactive = {
            enabled = false,
            shade = "dark",
            percentage = 0.15,
        },
        no_italic = false, -- Force no italic
        no_bold = false,   -- Force no bold
        styles = {
            comments = { "italic" },
            conditionals = { "italic" },
            loops = {},
            functions = {},
            keywords = {},
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators = {},
        },
        color_overrides = {},
        custom_highlights = {},
        integrations = {
            cmp = true,
            gitsigns = true,
            nvimtree = true,
            telescope = true,
            notify = false,
            mini = false,
            -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
    })

    vim.cmd.colorscheme 'catppuccin'
end

local function setup_tokyonight()
    require("tokyonight").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        style = "night",        -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
        light_style = "day",    -- The theme is used when the background is set to light
        transparent = true,     -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
        styles = {
            -- Style to be applied to different syntax groups
            -- Value is any valid attr-list value for `:help nvim_set_hl`
            comments = { italic = true },
            keywords = { italic = true },
            functions = {},
            variables = {},
            -- Background styles. Can be "dark", "transparent" or "normal"
            sidebars = "dark",            -- style for sidebars, see below
            floats = "dark",              -- style for floating windows
        },
        sidebars = { "qf", "help" },      -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
        day_brightness = 0.3,             -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
        hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
        dim_inactive = false,             -- dims inactive windows
        lualine_bold = false,             -- When `true`, section headers in the lualine theme will be bold
        --- You can override specific color groups to use other groups or a hex color
        --- function will be called with a ColorScheme table
        ---@param colors ColorScheme
        on_colors = function(colors)
        end,
        --- You can override specific highlights to use other groups or a hex color
        --- function will be called with a Highlights and ColorScheme table
        ---@param highlights Highlights
        ---@param colors ColorScheme
        on_highlights = function(highlights, colors)
        end,
    })

    vim.cmd.colorscheme 'tokyonight'

    vim.cmd([[ hi! link lualine_c_inactive Comment ]])
end

local function setup_zen_mode()
    require("zen-mode").setup {
        window = {
            backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
            -- height and width can be:
            -- * an absolute number of cells when > 1
            -- * a percentage of the width / height of the editor when <= 1
            -- * a function that returns the width or the height
            width = 0.65, -- width of the Zen window
            height = 1,   -- height of the Zen window
            -- by default, no options are changed for the Zen window
            -- uncomment any of the options below, or add other vim.wo options you want to apply
            options = {
                -- signcolumn = "no", -- disable signcolumn
                -- number = false, -- disable number column
                -- relativenumber = false, -- disable relative numbers
                -- cursorline = false, -- disable cursorline
                -- cursorcolumn = false, -- disable cursor column
                -- foldcolumn = "0", -- disable fold column
                -- list = false, -- disable whitespace characters
            },
        },
        plugins = {
            -- disable some global vim options (vim.o...)
            -- comment the lines to not apply the options
            options = {
                enabled = true,
                ruler = false,              -- disables the ruler text in the cmd line area
                showcmd = false,            -- disables the command in the last line of the screen
            },
            twilight = { enabled = false }, -- enable to start Twilight when zen mode opens
            gitsigns = { enabled = false }, -- disables git signs
            tmux = { enabled = false },     -- disables the tmux statusline
            -- this will change the font size on kitty when in zen mode
            -- to make this work, you need to set the following kitty options:
            -- - allow_remote_control socket-only
            -- - listen_on unix:/tmp/kitty
            kitty = {
                enabled = false,
                font = "+4", -- font size increment
            },
            -- this will change the font size on alacritty when in zen mode
            -- requires  Alacritty Version 0.10.0 or higher
            -- uses `alacritty msg` subcommand to change font size
            alacritty = {
                enabled = false,
                font = "14", -- font size
            },
        },
        -- callback where you can add custom code when the Zen window opens
        on_open = function(win)
        end,
        -- callback where you can add custom code when the Zen window closes
        on_close = function()
        end,
    }
end

local function setup_twilight()
    require("twilight").setup {
        dimming = {
            alpha = 0.50, -- amount of dimming
            -- we try to get the foreground from the highlight groups or fallback color
            color = { "Normal", "#ffffff" },
            term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
            inactive = false,    -- when true, other windows will be fully dimmed (unless they contain the same buffer)
        },
        context = 15,            -- amount of lines we will try to show around the current line
        treesitter = true,       -- use treesitter when available for the filetype
        -- treesitter is used to automatically expand the visible text,
        -- but you can further control the types of nodes that should always be fully expanded
        expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
            "body",
            "function",
            "method",
            "table",
            "if_statement",
        },
        exclude = {}, -- exclude these filetypes
    }
end

local function setup_telescope()
    require('telescope').setup {
        defaults = {
            -- Default configuration for telescope goes here:
            -- config_key = value,
            mappings = {
                i = {
                    -- map actions.which_key to <C-h> (default: <C-/>)
                    -- actions.which_key shows the mappings for your picker,
                    -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                        ["<C-x>"] = require("telescope.actions").delete_buffer,
                        ["<C-d>"] = require("telescope.actions").select_horizontal
                }
            }
        },
        pickers = {
            -- Default configuration for builtin pickers goes here:
            -- picker_name = {
            --   picker_config_key = value,
            --   ...
            -- }
            -- Now the picker_config_key will be applied every time you call this
            -- builtin picker
        },
        extensions = {
            -- Your extension configuration goes here:
            -- extension_name = {
            --   extension_config_key = value,
            -- }
            -- please take a look at the readme of the extension you want to configure
        }
    }
end

function M.setup(configs)
    require('mason').setup()
    require('onedark').setup(configs.onedark)
    require('lightspeed').setup(configs.lightspeed or {})
    require('lualine').setup(configs.lualine)
    require('gitsigns').setup()
    require('Comment').setup()
    require("indent_blankline").setup()
    require('illuminate').configure()
    require('focus').setup()

    setup_dressing()
    setup_completion()
    setup_lsp(configs)
    setup_inlay_hints()
    setup_yank_highlight()
    setup_auto_format()
    setup_cinnamon()
    setup_which_key(configs['which-key'])
    setup_dirbuf()
    setup_tokyonight()
    setup_zen_mode()
    setup_twilight()
    setup_telescope()
end

return M
