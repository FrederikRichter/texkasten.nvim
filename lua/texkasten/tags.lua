local ts_utils = require('nvim-treesitter.ts_utils')
local query = require('vim.treesitter.query')

local M = {}
function M.parse_tags(opts)
    print(opts.args)
    local bufnr = tonumber(opts.args) or vim.api.nvim_get_current_buf()
    local parser = vim.treesitter.get_parser(bufnr)
    local tree = parser:parse()[1]
    local root = tree:root()

    -- Define a specific query to find label definitions
    local query_string = [[
        (label_definition
            (curly_group_text
                (text
                    (word)@labels
                )
            )
        )
    ]]

    -- Parse and compile the query
    local parsed_query = vim.treesitter.query.parse('latex', query_string)
    tags = {}
    
    -- Execute the query
    for id, node, metadata in parsed_query:iter_captures(root, bufnr) do
        --local name = parsed_query.captures[id] -- name of the capture in the query
        --print("Captured: ", name)
        
        -- Get and print the text of the captured node
        local captured_text = vim.treesitter.get_node_text(node, bufnr)
        --print("Captured text: ", captured_text)

        table.insert(tags, captured_text)
    end
    return tags
end

return M
