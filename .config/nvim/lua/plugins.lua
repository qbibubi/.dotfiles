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

require("lazy").setup({
    { -- Colorscheme
        "blazkowolf/gruber-darker.nvim",
        config = function() vim.cmd.colorscheme "gruber-darker" end,
    },

    { -- LSP config
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "clangd", "asm_lsp", "rust_analyzer" }
            })
            vim.lsp.enable("clangd")
            vim.lsp.enable("asm_lsp")
            vim.lsp.enable("rust_analyzer")
        end
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = { "L3MON4D3/LuaSnip", "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local cmp = require('cmp')
            cmp.setup({
                snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({ { name = 'nvim_lsp' } })
            })
        end
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = { "c", "cpp", "asm", "lua", "vim", "vimdoc", "rust" },
            highlight = { enable = true },
        },
        config = function(_, opts)
            local status, configs = pcall(require, "nvim-treesitter.configs")
            if status then
                configs.setup(opts)
            else
                require("nvim-treesitter").setup(opts)
            end
        end
    },

    {
        "mfussenegger/nvim-dap",
        dependencies = { "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio" },
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup()
            dap.adapters.lldb = {
                type = 'executable',
                command = '/usr/bin/lldb-dap', -- Change to lldb-vscode if using an older LLVM
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

    { -- Nvim tree
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

    { -- Telescope
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
                    path_diplay = { "truncate" },
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
})

