local keymap = vim.keymap

--
-- Normal mode
-- 
    keymap.set("n", "gd", vim.lsp.buf.definition)

    -- C++ debugging
    keymap.set("n", "<F5>", function() require("dap").continue() end)
    keymap.set("n", "<leader>b", function() require("dap").toggle_breakpoint() end)

    -- Horizontal and vertical splitting
    keymap.set("n", "<leader>-", "<cmd>split<CR>", { silent = true })
    keymap.set("n", "<leader>|", "<cmd>vsplit<CR>", { silent = true })

    -- Moving around split windows
    keymap.set("n", "<C-h>", "<C-w>h")
    keymap.set("n", "<C-j>", "<C-w>j")
    keymap.set("n", "<C-k>", "<C-w>k")
    keymap.set("n", "<C-l>", "<C-w>l")
--
-- Insert mode
--
    -- Shift+Tab allows for tab retraction
    keymap.set("i", "<S-Tab>", "<C-d>") 

    -- Swaps back to normal mode 
    keymap.set("i", "kj", "<Esc>")
