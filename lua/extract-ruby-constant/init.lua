local ts = require("nvim-treesitter.ts_utils")
local query = vim.treesitter.query

local M = {}

local function find_next_module_constant()
  local node = ts.get_node_at_cursor()

  if node:type() == "constant" and node:parent() and node:parent():type() == "assignment" then
    return node
  end

  while node ~= nil and not vim.tbl_contains({ "class", "module" }, node:type()) do
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
    return query.get_node_text(node)[1]
  end
  return query.get_node_text(node:child(1))[1]
end

local function get_full_constant_name()
  local node = find_next_module_constant()
  if not node then
    return
  end

  local names = {}
  while node do
    table.insert(names, get_constant_name(node))
    node = get_parent_class_or_module(node)
  end

  names = vim.fn.reverse(names)
  return table.concat(names, "::")
end

function M.extract()
  return get_full_constant_name()
end

function M.yank()
  local name = M.extract()
  vim.fn.setreg(vim.v.register, name)
  vim.fn.setreg("0", name)
end

return M
