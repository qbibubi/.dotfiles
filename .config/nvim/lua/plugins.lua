local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ 
        "git", 
        "clone", 
        "--filter=blob:none", 
        "https://github.com/folke/lazy.nvim.git", 
        "--branch=stable", 
        lazypath 
    })
end

vim.opt.rtp:prepend(lazypath)

vim.diagnostic.config({
    virtual_text = {
        prefix = '?',
        spacing = 8,
    },
    underline = true,
    severity_sort = true,
    signs = true,
})

local function find_root(fname, markers)
    return vim.fs.root(fname, markers)
end

local servers = {
    clangd = {
        cmd = { "clangd" },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        single_file_support = true,
    },
    pyright = {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        single_file_support = true,
    },
    ruff = {
        cmd = { "ruff", "server" },
        filetypes = { "python" },
        single_file_support = true,
    },
    lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        single_file_support = true,
    },
    rust_analyzer = {
        cmd = { "rust-analyzer" },
        filetypes = { "rust" },
        single_file_support = true,
    },
    bashls = {
        cmd = { "bash-language-server", "start" },
        filetypes = { "sh" },
        single_file_support = true,
    },
    asm_lsp = {
        cmd = { "asm-lsp" },
        filetypes = { "asm", "nasm", "gas" },
    },
    neocmake = {
        cmd = { "neocmakelsp", "--stdio" },
        filetypes = { "cmake" },
        single_file_support = true,
    },
    autotools_ls = {
        cmd = { "autotools-language-server" },
        filetypes = { "config", "automake", "make" },
    },
    lemminx = {
        cmd = { "lemminx" },
        filetypes = { "xml" },
    },
}

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        for name, config in pairs(servers) do
            vim.lsp.config(name, config)
            vim.lsp.enable(name)
        end
    end
})

vim.o.completeopt = 'menu,menuone,noinsert'

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
            vim.lsp.completion.enable(true, client.id)
        end
    end
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.c", "*.cpp", "*.h", "*.hpp" },
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.py" },
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

require("lazy").setup({
    -- {
    --     "blazkowolf/gruber-darker.nvim",
    --     config = function() vim.cmd.colorscheme "gruber-darker" end,
    -- },
    {
        "nuvic/flexoki-nvim",
        config = function()
          vim.cmd.colorscheme = "nuvic/flexoki-nvim"
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }),
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = { "c", "cpp", "asm", "lua", "vim", "vimdoc", "rust", "python" },
            highlight = { enable = true },
        },
    },

    {
        "mfussenegger/nvim-dap",
        dependencies = { "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio" },
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup()
            dap.adapters.lldb = {
                type = 'executable',
                command = '/usr/bin/lldb-dap',
                name = 'lldb'
            }
            dap.configurations.cpp = {
                {
                    name = 'Launch',
                    type = 'lldb',
                    request = 'launch',
                    program = function() return vim.fn.input('Path: ', vim.fn.getcwd() .. '/', 'file') end,
                    cwd = '${workspaceRoot}',
                    stopOnEntry = false,
                },
            }
            dap.configurations.c = dap.configurations.cpp
            dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
            dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
        end
    },

    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            require("nvim-tree").setup({
                view = { width = 30 },
                renderer = { group_empty = true },
                filters = { dotfiles = false },
            })

            vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            telescope.setup({
                defaults = {
                    path_display = { "truncate" },
                    mappings = {
                        i = {
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-j>"] = actions.move_selection_next,
                        },
                    },
                },
            })

            telescope.load_extension("fzf")

            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
            vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
        end,
    },

    {
        "andweeb/presence.nvim",
        config = function()
            require("presence").setup({
                auto_update         = true,
                neovim_image_text   = "The One True Text Editor",
                main_image          = "neovim",
                log_level           = nil,
                debounce_timeout    = 10,
                enable_line_number  = false,
                blacklist           = {},
                buttons             = true,
                file_assets         = {},
                show_time           = true,

                editing_text        = "Editing %s",
                file_explorer_text  = "Browsing %s",
                git_commit_text     = "Committing changes",
                plugin_manager_text = "Managing plugins",
                reading_text        = "Reading %s",
                workspace_text      = "Working on %s",
                line_number_text    = "Line %s out of %s",
            })
        end,
    },
})

