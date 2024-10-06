local function log_message(message)
    vim.cmd('echom("' .. message .. '")')
end

-- Create a new autocommand group
local texkasten_group = vim.api.nvim_create_augroup('TexkastenGroup', {clear = true})

local function main(datadir)
    log_message("using datadir " .. datadir)
end

local function setup(datadir)
    main(datadir)
    vim.api.nvim_create_autocmd({'BufEnter'}, {
        group = texkasten_group,
        pattern = '*/' .. datadir .. '*.tex',  -- Matches .tex files in the texkasten directory
        once = true,
        callback = function()
            log_message("Entered a .tex file in the texkasten directory! Buffer : " .. vim.api.nvim_buf_get_name(0))
            -- You can add more actions here, such as setting options or running commands
        end,
    })
end

return { setup = setup }
