return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			astro = { "prettier" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			cpp = { "clang-format" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	},
}
