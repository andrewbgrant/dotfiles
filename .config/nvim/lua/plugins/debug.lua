--- Starts the Go test under the cursor in the debugger.
local function debug_go_test()
	require("dap-go").debug_test()
end

--- Repeats the most recently debugged Go test.
local function debug_last_go_test()
	require("dap-go").debug_last_test()
end

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- UI for debugging
			{
				"rcarriga/nvim-dap-ui",
				dependencies = { "nvim-neotest/nvim-nio" },
				opts = {},
				config = function(_, opts)
					local dap = require("dap")
					local dapui = require("dapui")
					dapui.setup(opts)

					-- Auto open/close UI when debugging starts/stops
					dap.listeners.after.event_initialized["dapui_config"] = function()
						dapui.open()
					end
					dap.listeners.before.event_terminated["dapui_config"] = function()
						dapui.close()
					end
					dap.listeners.before.event_exited["dapui_config"] = function()
						dapui.close()
					end
				end,
			},

			-- Python debugging
			{
				"mfussenegger/nvim-dap-python",
				ft = "python",
				config = function()
					-- Use the python from your uv global environment
					require("dap-python").setup("/Users/andrewgrant/.uv_global/bin/python")
				end,
			},
			{
				"leoluz/nvim-dap-go",
				ft = "go",
				opts = {
					delve = {
						path = vim.fn.expand("~/go/bin/dlv"),
					},
				},
				keys = {
					{ "<leader>dg", debug_go_test, desc = "Debug Go Test" },
					{ "<leader>dG", debug_last_go_test, desc = "Debug Last Go Test" },
				},
			},
			{
				"mxsdev/nvim-dap-vscode-js",
				dependencies = {
					{
						"microsoft/vscode-js-debug",
						version = "1.x",
						build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
					},
				},
			},
		},

		keys = {
			-- Basic debugging controls
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Conditional Breakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Continue",
			},
			{
				"<leader>ds",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
			},
			{
				"<leader>do",
				function()
					require("dap").step_out()
				end,
				desc = "Step Out",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.open()
				end,
				desc = "Open REPL",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},

			-- UI controls
			{
				"<leader>du",
				function()
					require("dapui").toggle()
				end,
				desc = "Toggle Debug UI",
			},
			{
				"<leader>de",
				function()
					require("dapui").eval()
				end,
				mode = { "n", "v" },
				desc = "Evaluate Expression",
			},
		},

		config = function()
			local dap = require("dap")

			-- Debug icons
			vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "", numhl = "" })

			require("dap-vscode-js").setup({
				debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
				adapters = { "pwa-node" },
			})

			-- JavaScript/TypeScript configurations
			dap.configurations.javascript = {
				{
					name = "Launch npm run dev",
					type = "pwa-node",
					request = "launch",
					runtimeExecutable = "npm",
					runtimeArgs = { "run", "dev" },
					cwd = "${workspaceFolder}",
					sourceMaps = true,
					console = "integratedTerminal",
					skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
				},
				{
					name = "Attach to Node.js process",
					type = "pwa-node",
					request = "attach",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
					sourceMaps = true,
					skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
				},
			}

			dap.configurations.typescript = dap.configurations.javascript
		end,
	},
}
