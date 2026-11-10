return {
	"mfussenegger/nvim-dap",
	event = "VeryLazy",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"jay-babu/mason-nvim-dap.nvim",
		"theHamsta/nvim-dap-virtual-text",
	},
	config = function()
		local mason_dap = require("mason-nvim-dap")
		local dap = require("dap")
		local ui = require("dapui")
		local dap_virtual_text = require("nvim-dap-virtual-text")
		local keymap = vim.keymap

		-- Dap Virtual Text
		dap_virtual_text.setup()

		mason_dap.setup({
			ensure_installed = { "js", "codelldb", "cppdbg" },
			automatic_installation = true,
			event = "VeryLazy",
			handlers = {
				function(config)
					require("mason-nvim-dap").default_setup(config)
				end,
			},
		})
		dap.set_log_level("TRACE")
		-- Define custom icons for nvim-dap signs
		vim.fn.sign_define("DapBreakpoint", { text = "🐞", texthl = "DapBreakpoint", linehl = "", numhl = "" })
		vim.fn.sign_define(
			"DapBreakpointCondition",
			{ text = "ﳁ", texthl = "DapBreakpoint", linehl = "", numhl = "" }
		)
		vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint", linehl = "", numhl = "" })
		vim.fn.sign_define(
			"DapStopped",
			{ text = "👉", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" }
		)
		vim.fn.sign_define(
			"DapBreakpointRejected",
			{ text = "", texthl = "DapBreakpointRejected", linehl = "", numhl = "" }
		)
		-- Dap UI

		ui.setup()

		dap.listeners.before.attach.dapui_config = function()
			ui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			ui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			ui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			ui.close()
		end

		-- Key maps
		keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
		keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
		keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
		keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })
		keymap.set("n", "<leader>du", dap.step_out, { desc = "Step out" })
		keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
		keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run last" })
		keymap.set("n", "<leader>dq", function()
			dap.terminate()
			ui.close()
			dap_virtual_text.toggle()
		end, { desc = "Terminate" })
		keymap.set("n", "<leader>db", dap.list_breakpoints, { desc = "list_breakpoints" })
		keymap.set("n", "<leader>de", function()
			dap.set_exception_breakpoints({ "all" })
		end, { desc = "Set Exception breakpoints" })
	end,
}
