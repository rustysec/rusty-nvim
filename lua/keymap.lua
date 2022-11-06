local module = {}

function module.setup(maps)
    local wk = require('which-key')

    for mode, map in pairs(maps) do
        for key, cmd in pairs(map) do
            -- vim.api.nvim_set_keymap(mode, key, cmd, { noremap = true, silent = true })
            wk.register({
                [key] = {
                    cmd[1],
                    cmd[2],
                    mode = mode,
                }
            })
        end
    end
end

return module
