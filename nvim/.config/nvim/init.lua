vim.filetype.add({ extension = { mdx = "markdown" } })
vim.filetype.add({ extension = { ino = "cpp" } })

require("config.lazy")

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8

vim.opt.signcolumn = "yes"
vim.opt.splitright = true

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = -1

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus"

vim.opt.wrap = true
vim.opt.linebreak = true

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.tex",
	callback = function(ev)
		vim.system({ "unshare", "-rn", "tectonic", "--only-cached", "--keep-intermediates", ev.file }, {}, function(out)
			if out.code ~= 0 then
				vim.schedule(function()
					vim.notify(out.stderr, vim.log.levels.ERROR)
				end)
			end
		end)
	end,
})

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

local repl = nil
vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		repl = vim.bo.channel
	end,
})

vim.keymap.set("n", "<leader>rr", function()
	vim.fn.chansend(repl, vim.api.nvim_get_current_line() .. "\n")
	vim.cmd("normal! j")
end)

vim.keymap.set("x", "<leader>rr", function()
	local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
	vim.fn.chansend(repl, table.concat(lines, "\n") .. "\n")
	vim.api.nvim_input("<Esc>")
end)

local repl_cmd = { r = "R --quiet", python = "python3 -q" }

vim.keymap.set("n", "<leader>sr", function()
	local cmd = repl_cmd[vim.bo.filetype]
	if cmd then
		vim.cmd("vsplit | term " .. cmd)
		vim.cmd("wincmd p")
	end
end)

vim.keymap.set("n", "<leader>c", function()
	vim.fn.chansend(repl, vim.keycode("<C-l>"))
end)

vim.keymap.set("n", "<leader>rt", function()
	local first = vim.fn.search("^# %%", "bcnW")
	local last = vim.fn.search("^# %%", "nW")
	local lines = vim.api.nvim_buf_get_lines(0, first, last - 1, false)
	vim.fn.chansend(repl, table.concat(lines, "\n") .. "\n")
end)

vim.keymap.set("n", "<leader>re", function()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	vim.fn.chansend(repl, table.concat(lines, "\n") .. "\n")
end)

vim.keymap.set("n", "<leader>st", function()
	vim.api.nvim_put({ "# %%", "", "" }, "l", true, true)
end)
