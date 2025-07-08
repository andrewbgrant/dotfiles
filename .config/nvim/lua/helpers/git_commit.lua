local M = {}

function M.commit_selected()
    -- Get visual selection
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local lines = vim.fn.getline(start_pos[2], end_pos[2])
    if #lines == 0 then return end
    -- Trim first and last line if selection is partial
    lines[1] = string.sub(lines[1], start_pos[3])
    lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
    local msg = table.concat(lines, "\n")
    -- Write to temp file
    local tmpfile = vim.fn.tempname()
    local f = io.open(tmpfile, "w")
    if f then
        f:write(msg)
        f:close()
    else
        vim.notify("Failed to open temp file for commit message", vim.log.levels.ERROR)
        return
    end
    -- Use Fugitive to commit with this message
    vim.cmd("G commit -F " .. tmpfile)
end

vim.api.nvim_create_user_command("CommitSelected", M.commit_selected, { range = true })

return M
