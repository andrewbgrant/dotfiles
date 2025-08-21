local user = vim.env.USER or "User"

local local_host = "localhost" -- "100.91.131.3"

return {
	{
		"zbirenbaum/copilot.lua",
		lazy = true,
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			copilot_model = "gpt-4o-copilot",
			panel = { enabled = false },
			suggestion = {
				enabled = false,
				keymap = {
					accept = false,
				},
			},
			filetypes = {
				markdown = true,
				help = true,
			},
		},
	},

	{
		"CopilotC-Nvim/CopilotChat.nvim",
		lazy = true,
		build = "make tiktoken",
		dependencies = { { "zbirenbaum/copilot.lua" }, { "nvim-lua/plenary.nvim", branch = "master" } },
		branch = "main",
		opts = {
			model = "gpt-4.1",
			user = user:sub(1, 1):upper() .. user:sub(2),
			question_header = " " .. user .. " ",
			answer_header = " Copilot ",
			auto_insert_mode = false,
			debug = false,
			auto_follow_cursor = false,
			window = {
				width = 0.4,
			},
			sticky = {
				"@buffers",
			},

			prompts = {
				Doc = {
					prompt = "> #buffer \n Please add high quality documentation to the code. Add tickmarks around all parameters and variables to prevent escape characters and to ensure lsps properly format them. ",
				},
				Fix = {
					prompt = "> #buffer \n There is a problem in the selected code. Rewrite the code to show it with the bug fixed. If a line diagnostic is provided then display the diagnostic to the user.",
				},
				ReviewStaged = {
					prompt = "> #buffers >#gitdiff:staged \n Review the following files and staged changes to improve readability, maintainability, and performance while ensuring its functionality remains the same. Apply best practices, optimize for efficiency. Make sure to adhere to standards and use descriptive variable names. Suggest any design patterns that could be better used here.",
				},
				Refactor = {
					prompt = "> #buffer \n Refactor the following file to improve readability, maintainability, and performance while ensuring its functionality remains the same. Apply best practices, optimize for efficiency. Make sure to adhere to standards and use descriptive variable names. Additionally, suggest any potential improvements that were not implemented but could be valuable in the future.",
				},

				RefactorAll = {
					prompt = "> #buffers \n Refactor the following files to improve readability, maintainability, and performance while ensuring its functionality remains the same. Apply best practices, optimize for efficiency. Make sure to adhere to standards and use descriptive variable names. Additionally, suggest any potential improvements that were not implemented but could be valuable in the future.",
				},
				Performance = {
					prompt = "> #buffers \n Refactor the following files to improve performance. Apply best practices, optimize for efficiency. Make sure to adhere to standards and use descriptive variable names.",
				},
			},
		},
		keys = {
			{ "<leader>cm", "<cmd>CopilotChatModels<cr>", mode = { "n", "v" }, desc = "Change CopilotChat Model" },
			{ "<leader>cc", "<cmd>CopilotChatToggle<cr>", mode = { "n", "v" }, desc = "Toggle Chat Window" },
			{
				"<leader>cq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						local mode = vim.fn.mode()
						local selection_type = (mode == "v" or mode == "V" or mode == "\22")
								and require("CopilotChat.select").visual
							or require("CopilotChat.select").buffer
						require("CopilotChat").ask(input, { selection = selection_type })
					end
				end,
				mode = { "n", "v" },
				desc = "CopilotChat - Quick chat",
			},
			{ "<leader>ca", "<cmd>CopilotChatPrompts<cr>", mode = { "n", "v" }, desc = "Prompts" },
			-- {
			-- 	"<leader>ca",
			-- 	function()
			-- 		local actions = require("CopilotChatPrompts")
			-- 		require("CopilotChat.integrations.snacks").pick(actions.prompt_actions())
			-- 	end,
			-- 	mode = { "n", "v" },
			-- 	desc = "CopilotChat - Prompt actions",
			-- },
		},
	},
}
