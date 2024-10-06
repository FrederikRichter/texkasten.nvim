local ts_utils = require('nvim-treesitter.ts_utils')

local function log_message(message)
    vim.cmd('echom("' .. message .. '")')
end

-- Create a new autocommand group
local texkasten_group = vim.api.nvim_create_augroup('TexkastenGroup', {clear = true})

local function main(datadir)
    log_message("using datadir " .. datadir)
end

-- Function to get words from label definitions
local function extract_label_definition_words(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local parser = vim.treesitter.get_parser(bufnr, 'latex')
  local tree = parser:parse()[1]

  local root = tree:root()

  -- Define a function to recursively find the label_definition node
  local function find_label_definition(node)
    if node:type() == 'label_definition' then
      return node
    end
    for child in node:iter_children() do
      local result = find_label_definition(child)
      if result then
        return result
      end
    end
    return nil
  end

  local label_definition_node = find_label_definition(root)
  if not label_definition_node then
    print("No label_definition found")
    return
  end

  -- Define a function to extract words from the label_definition node
  local function extract_words(node)
    local words = {}
    if node:type() == 'word' then
      table.insert(words, ts_utils.get_node_text(node, bufnr)[1])
    end
    for child in node:iter_children() do
      local child_words = extract_words(child)
      for _, word in ipairs(child_words) do
        table.insert(words, word)
      end
    end
    return words
  end

  local words = extract_words(label_definition_node)
  for _, word in ipairs(words) do
    print(word)
  end
end




local function setup(datadir)
    main(datadir)

    vim.api.nvim_create_autocmd({'BufEnter'}, {
        group = texkasten_group,
        pattern = '*/' .. datadir .. '*.tex',  -- Matches .tex files in the texkasten directory
        once = true,
        callback = function()
            log_message("Entered a .tex file in the texkasten directory! Buffer: " .. vim.api.nvim_buf_get_name(0))
            extract_label_definition_words()
        end,
    })
end

return { setup = setup }
