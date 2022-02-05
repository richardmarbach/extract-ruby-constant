local ts = require("nvim-treesitter.ts_utils")

local function find_next_module_constant()
	local node = ts.get_node_at_cursor()
	while node ~= nil and not vim.tbl_contains({ "constant", "class", "module" }, node:type()) do
		node = node:parent()
	end

	return node
end

local function get_parent_class_or_module(node)
	node = node:parent()
	while node and not vim.tbl_contains({ "class", "module" }, node:type()) do
		node = node:parent()
	end
	return node
end

local function get_constant_name(node)
	if node:type() == "constant" then
		return ts.get_node_text(node)[1]
	end
	return ts.get_node_text(node:child(1))[1]
end

local function get_full_constant_name()
	local names = {}
	local node = find_next_module_constant()
	if not node then
		return
	end

	while node do
		table.insert(names, get_constant_name(node))
		node = get_parent_class_or_module(node)
	end

	names = vim.fn.reverse(names)
	return table.concat(names, "::")
end

function _G.get_full_constant_name()
	return get_full_constant_name()
end

function _G.yank_full_constant_name()
	local name = get_full_constant_name()
	vim.fn.setreg("0", name)
	vim.fn.setreg('"', name)
end

vim.cmd("nnoremap <leader>r :so %<cr>")
vim.cmd("nnoremap <leader>t :lua yank_full_constant_name()<cr>")
