local keymaps = {
    ['n'] = {
        -- normal mode
        ['<C-h>'] = { ':wincmd h<CR>', "Window to the left" },
        ['<C-j>'] = { ':wincmd j<CR>', "Window on the bottom" },
        ['<C-k>'] = { ':wincmd k<CR>', "Window on the top" },
        ['<C-l>'] = { ':wincmd l<CR>', "Window on the right" },
        ['<C-Left>'] = { ':wincmd h<CR>', "Window to the left" },
        ['<C-Down>'] = { ':wincmd j<CR>', "Window on the bottom" },
        ['<C-Up>'] = { ':wincmd k<CR>', "Window on the top" },
        ['<C-Right>'] = { ':wincmd l<CR>', "Window on the right" },
        ['L'] = { ':bnext<CR>', 'Next buffer' },
        ['H'] = { ':bprev<CR>', 'Previous buffer' },
        ['<leader>w'] = { ':w<CR>', 'Save current buffer' },
        ['<leader>c'] = { ':Bdelete<CR>', 'Delete current buffer' },
        -- ['<leader>E'] = { ':Neotree toggle<CR>', 'Toggle NeoTree' },
        ['<leader>e'] = { ':lua require"lir.float".toggle()<CR>', 'Lir float' },
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
        ['<leader>sh'] = { '<cmd>lua require("which-key").show("z=")<CR>', 'Spelling suggestions' },
        ['<leader>vr'] = { ':Gitsigns reset_hunk<CR>', 'Git reset hunk' },
        ['<leader>vp'] = { ':Gitsigns preview_hunk_inline<CR>', 'Git preview hunk inline' },
        ['<leader>vP'] = { ':Gitsigns preview_hunk<CR>', 'Git preview hunk' },
        ['<leader>vn'] = { ':Gitsigns next_hunk<CR>', 'Git next hunk' },
        ['<leader>vl'] = { ':Gitsigns prev_hunk<CR>', 'Git previous hunk' },
        ['<leader>vb'] = { ':Gitsigns blame_line<CR>', 'Git blame line' },
    },
    ['v'] = {
        -- visual mode
    },
    ['i'] = {
        -- insert mode
    }
}

local user_config = {}

local status, plugin = pcall(require, 'user_config')
if status then
    user_config = plugin
end

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
                        target = user_config.cargo_target or nil
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
        },
        ['omnisharp'] = {
            cmd = { "dotnet", "/home/russ/.local/share/nvim/mason/packages/omnisharp/OmniSharp.dll" },

            -- Enables support for reading code style, naming convention and analyzer
            -- settings from .editorconfig.
            enable_editorconfig_support = true,

            -- If true, MSBuild project system will only load projects for files that
            -- were opened in the editor. This setting is useful for big C# codebases
            -- and allows for faster initialization of code navigation features only
            -- for projects that are relevant to code that is being edited. With this
            -- setting enabled OmniSharp may load fewer projects and may thus display
            -- incomplete reference lists for symbols.
            enable_ms_build_load_projects_on_demand = true,

            -- Enables support for roslyn analyzers, code fixes and rulesets.
            enable_roslyn_analyzers = true,

            -- Specifies whether 'using' directives should be grouped and sorted during
            -- document formatting.
            organize_imports_on_format = true,

            -- Enables support for showing unimported types and unimported extension
            -- methods in completion lists. When committed, the appropriate using
            -- directive will be added at the top of the current file. This option can
            -- have a negative impact on initial completion responsiveness,
            -- particularly for the first few completion sessions after opening a
            -- solution.
            enable_import_completion = true,

            -- Specifies whether to include preview versions of the .NET SDK when
            -- determining which version to use for project loading.
            sdk_include_prereleases = true,

            -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
            -- true
            analyze_open_documents_only = false,
        }
    },
    ['lualine'] = {
        options = {
            icons_enabled = true,
            theme = 'leaf',
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            disabled_filetypes = {
                statusline = { 'neo-tree' },
                winbar = { 'neo-tree' },
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = true,
            refresh = {
                statusline = 1000,
                -- tabline = 1000,
                winbar = 1000,
            }
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { 'require("lsp-status").status()' },
            lualine_x = { { 'filename', path = 1 }, 'encoding', 'fileformat', 'bo:filetype' },
            lualine_y = { 'progress' },
            lualine_z = { 'location' }
        },
        inactive_sections = {},
        tabline = {},
        winbar = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { { 'filename', path = 1 }, 'diagnostics' },
            lualine_x = {},
            lualine_y = {},
            lualine_z = {}
        },
        inactive_winbar = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { { 'filename', path = 1 }, 'diagnostics' },
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
        },
    },
}

-- Set up packer before anything
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

if packer_bootstrap then
    require('packer').sync()
end

-- Configure neovim!
require('settings')
require('plugins')
require('keymap').setup(keymaps)
require('setup').setup(configs)
