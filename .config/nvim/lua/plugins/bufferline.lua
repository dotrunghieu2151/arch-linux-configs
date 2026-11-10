return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	opts = {
		options = {
			mode = "tabs",
			separator_style = "thick",
			hover = {
				enabled = true,
				delay = 200,
				reveal = { "close" },
			},
			numbers = "ordinal",
			diagnostics = "nvim_lsp",
			diagnostics_indicator = function(count, level, diagnostics_dict, context)
				local s = ""
				if diagnostics_dict["error"] then
					s = diagnostics_dict["error"] .. "❗"
				end
				return s
			end,
		},
	},
}
