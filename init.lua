local keymaps = {
    ['n'] = {
        -- normal mode
        ['<C-h>'] = { ':wincmd h<CR>', "Window to the left" },
        ['<C-j>'] = { ':wincmd j<CR>', "Window on the bottom" },
        ['<C-k>'] = { ':wincmd k<CR>', "Window on the top" },
        ['<C-l>'] = { ':wincmd l<CR>', "Window on the right" },
        ['L'] = { ':bNext<CR>', 'Next buffer' },
        ['H'] = { ':bprev<CR>', 'Previous buffer' },
        ['<leader>w'] = { ':w<CR>', 'Save current buffer' },
        ['<leader>c'] = { ':Bdelete<CR>', 'Delete current buffer' },
        ['<leader>e'] = { ':Neotree toggle<CR>', 'Toggle NeoTree' },
        ['<leader>V'] = { ':vsplit<CR>', 'Split vertically' },
        ['<leader>H'] = { ':split<CR>', 'Split horizontally' },
        ['<leader>lr'] = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename symbol' },
        ['<leader>la'] = { '<cmd>lua vim.lsp.buf.code_action()<CR>', 'Code actions' },
        ['<leader>ld'] = { '<cmd>lua vim.diagnostic.open_float()<CR>', 'Open diagnostics float' },
        ['<leader>gd'] = { '<cmd>lua vim.lsp.buf.definition()<CR>', 'Definition' },
        ['<leader>gr'] = { '<cmd>lua require("telescope.builtin").lsp_references()<CR>', 'References' },
        ['<leader>gt'] = { '<cmd>lua require("telescope.builtin").diagnostics()<CR>', 'Diagnostics' },
        ['<leader>ff'] = { ':Telescope find_files<CR>', 'Files' },
        ['<leader>fb'] = { ':Telescope buffers<CR>', 'Buffers' },
        ['<leader>fm'] = { ':Telescope marks<CR>', 'Marks' },
        ['<leader>fw'] = { ':Telescope live_grep<CR>', 'String' },
        ['<leader>fs'] = { ':Telescope grep_string<CR>', 'String' },
        ['<leader>ss'] = { ':set spell!<CR>', 'Toggle spelling' },
    },
    ['v'] = {
        -- visual mode
    },
    ['i'] = {
        -- insert mode
    }
}

local configs = {
    ['onedark'] = {
        style = 'darker',
        transparent = true,
    },
    ['lsp'] = {
        ['sumneko_lua'] = {
            settings = {
                Lua = {
                    runtime = {
                        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                        version = 'LuaJIT',
                    },
                    diagnostics = {
                        -- Get the language server to recognize the `vim` global
                        globals = { 'vim' },
                    },
                    workspace = {
                        -- Make the server aware of Neovim runtime files
                        library = vim.api.nvim_get_runtime_file("", true),
                    },
                    -- Do not send telemetry data containing a randomized but unique identifier
                    telemetry = {
                        enable = false,
                    },
                    hint = {
                        enable = true,
                    }
                },
            },
        },
        ['rust_analyzer'] = {
            settings = {
                ['rust-analyzer'] = {
                    imports = {
                        granularity = {
                            group = 'module',
                        },
                        prefix = 'self',
                    },
                    cargo = {
                        buildScripts = {
                            enable = true,
                        },
                        -- target = 'x86_64-unknown-linux-gnu',
                        -- target = 'x86_64-unknown-linux-musl',
                        -- target = 'x86_64-pc-windows-gnu',
                        -- target = 'x86_64-apple-darwin',
                        -- target = 'aarch64-apple-darwin',
                    },
                    diagnostics = {
                        disabled = {
                            'inactive-code',
                            'unresolved-proc-macro',
                            'unlinked-file',
                            'macro-error'
                        },
                    },
                    procMacro = {
                        enable = true
                    },
                    checkOnSave = {
                        commnd = 'clippy',
                    },
                },
            }
        }
    },
    ['lualine'] = {
        options = {
            icons_enabled = true,
            theme = 'onedark',
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            disabled_filetypes = {
                statusline = { 'neo-tree' },
                winbar = { 'neo-tree' },
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = true,
            refresh = {
                statusline = 1000,
                tabline = 1000,
                winbar = 1000,
            }
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { 'require("lsp-status").status()' },
            lualine_x = { 'filename', 'encoding', 'fileformat', 'filetype' },
            lualine_y = { 'progress' },
            lualine_z = { 'location' }
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = { 'location' },
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {},
        winbar = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = {},
            lualine_y = {},
            lualine_z = {}
        },
        inactive_winbar = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = {},
            lualine_y = {},
            lualine_z = {}
        },
        extensions = {}
    },
    ['neo-tree'] = {
        close_if_last_window = true,
        enable_diagnostics = false,
        source_selector = {
            winbar = true,
            content_layout = 'center',
            tab_labels = {},
        },
        default_component_configs = {
            indent = {
                padding = 0,
            },
        },
        window = {
            width = 30,
            mappings = {
                ['o'] = 'open',
            },
        },
        filesystem = {
            follow_current_file = true,
            hijack_netrw_behavior = 'open_current',
            use_libuv_file_watcher = true,
        },
        event_handlers = {
            {
                event = 'neo_tree_buffer_enter',
                handler = function(_)
                    vim.opt_local.signcolumn = 'auto'
                end
            },
        },
    },
    ['which-key'] = {
        plugins = {
            spelling = {
                enabled = true,
                suggestions = 20,
            }
        }
    },
}

require('settings')
require('plugins')
require('keymap').setup(keymaps)
require('setup').setup(configs)
