local function log_message(message)
    vim.cmd('echom("' .. message .. '")')
end

return log_message
