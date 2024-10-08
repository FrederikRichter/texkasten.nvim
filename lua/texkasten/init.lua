local function log_message(message)
    vim.cmd('echom("' .. message .. '")')
end
local script_path = debug.getinfo(1).source:sub(2)
local script_dir = script_path:match("(.*/)")
--log_message(script_dir)

local log = require("texkasten.log")
local tag_helper = require("texkasten.tags")
local zettel_helper = require("texkasten.zettel")

local M = {}

function M.setup(opts)
    opts = opts or {}
    
    -- check if datadir is set
    if opts.datadir == nil then
        error("No datadir (str) set when calling setup")
    end

    log("Datadir: " .. opts.datadir)

    vim.api.nvim_create_user_command('TKGetTags', function(bufnr)
        print(vim.inspect(tag_helper.parse_tags(bufnr)))
    end, { nargs = "?", desc = "Get tags, needs a buffer number (defaults to 0 -> current)"})
end

return M
