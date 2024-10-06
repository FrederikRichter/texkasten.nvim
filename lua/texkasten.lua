-- Create a new autocommand group
local texkasten_group = vim.api.nvim_create_augroup('TexkastenGroup', {clear = true})

local function main(datadir)
    print("using datadir " .. datadir)
end

local function setup(datadir)
    main(datadir)
    vim.api.nvim_create_autocmd({'BufEnter', 'BufRead', 'BufNewFile'}, {
        group = texkasten_group,
        pattern = '*/' .. datadir .. '*.tex',  -- Matches .tex files in the texkasten directory
        once = true,
        callback = function()
            print("Entered a .tex file in the texkasten directory!")
            -- You can add more actions here, such as setting options or running commands
        end,
    })
end

return { setup = setup }
