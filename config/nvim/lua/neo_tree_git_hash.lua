-- neo-tree git hash toggle & filter
--
-- Commands:
--   :NeoTreeGitHash              Toggle git commit hash display
--   :NeoTreeGitFilter <hash>     Filter tree to files changed in <hash>
--   :NeoTreeGitFilter            Filter by hash under cursor (requires :NeoTreeGitHash ON)
--
-- Setup (dein hook_add):
--
--   lua << EOF
--   local git_hash = require("neo_tree_git_hash")
--   git_hash.setup()
--   require("neo-tree").setup({
--     filesystem = {
--       components = {
--         git_hash = git_hash.component,
--       },
--     },
--     renderers = {
--       file = {
--         { "indent" },
--         { "icon" },
--         {
--           "container",
--           content = {
--             { "name", zindex = 10 },
--             { "symlink_target", zindex = 10 },
--             { "clipboard", zindex = 10 },
--             { "modified", zindex = 20, align = "right" },
--             { "diagnostics", zindex = 20, align = "right" },
--             { "git_status", zindex = 10, align = "right" },
--             { "git_hash", zindex = 10, align = "right" },
--           },
--         },
--       },
--     },
--   })
--   EOF

local M = {}

-- git hash display state
local hash_enabled = false
local hash_cache = {}

-- git filter state
local filter_files = nil -- set of absolute paths, or nil when inactive
local filter_autocmd_id = nil

---------------------------------------------------------------------------
-- Git helpers
---------------------------------------------------------------------------

local function git_root()
  local result = vim.trim(vim.fn.system("git rev-parse --show-toplevel"))
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return result
end

---@param filepath string
---@return string
local function fetch_git_info(filepath)
  if hash_cache[filepath] ~= nil then
    return hash_cache[filepath]
  end

  local cmd = string.format(
    "git log -1 --format='%%h (%%an %%ai)' -- %s",
    vim.fn.shellescape(filepath)
  )
  local result = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    hash_cache[filepath] = ""
    return ""
  end

  result = vim.trim(result)
  hash_cache[filepath] = result
  return result
end

---@param revspec string  commit hash or range (e.g. "abc123" or "abc123..HEAD")
---@return table<string, true>|nil
local function get_commit_files(revspec)
  local root = git_root()
  if not root then
    return nil
  end

  local range = revspec
  if not revspec:find("%.%.") then
    range = revspec .. "^.." .. revspec
  end
  local lines = vim.fn.systemlist(string.format(
    "git -c core.quotePath=false diff --name-only %s",
    vim.fn.shellescape(range)
  ))
  if vim.v.shell_error ~= 0 then
    return nil
  end

  local files = {}
  for _, f in ipairs(lines) do
    if f ~= "" then
      files[root .. "/" .. f] = true
    end
  end
  return files
end

---------------------------------------------------------------------------
-- Git hash display (component)
---------------------------------------------------------------------------

---@param tree table NuiTree
local function prefetch_tree(tree)
  local function walk(node_list)
    for _, node in ipairs(node_list) do
      if node.type == "file" and node.path then
        fetch_git_info(node.path)
      end
      if node:has_children() then
        walk(tree:get_nodes(node:get_id()))
      end
    end
  end
  walk(tree:get_nodes())
end

---@param config table
---@param node table
---@param _state table
---@return table
function M.component(config, node, _state)
  if not hash_enabled or node.type ~= "file" then
    return {}
  end

  local path = node.path or node:get_id()
  local info = fetch_git_info(path)

  if info == "" then
    return {}
  end

  return {
    text = " " .. info,
    highlight = config.highlight or "Comment",
  }
end

function M.toggle()
  hash_enabled = not hash_enabled
  hash_cache = {}

  vim.notify("NeoTreeGitHash: " .. (hash_enabled and "ON" or "OFF"), vim.log.levels.INFO)

  local manager = require("neo-tree.sources.manager")
  local renderer = require("neo-tree.ui.renderer")
  for _, source_name in ipairs({ "filesystem", "buffers", "git_status" }) do
    local ok, state = pcall(manager.get_state, source_name)
    if ok and state and state.tree then
      if hash_enabled then
        prefetch_tree(state.tree)
      end
      renderer.redraw(state)
    end
  end
end

---------------------------------------------------------------------------
-- Git filter
---------------------------------------------------------------------------

--- Remove tree nodes not related to filter_files.
---@param tree table NuiTree
---@param nodes table
---@param ancestor_dirs table<string, true>
local function apply_filter(tree, nodes, ancestor_dirs)
  for i = #nodes, 1, -1 do
    local node = nodes[i]
    if node.type == "file" then
      if not filter_files[node.path] then
        tree:remove_node(node:get_id())
      end
    elseif node.type == "directory" then
      if ancestor_dirs[node.path] then
        local children = tree:get_nodes(node:get_id())
        if #children > 0 then
          apply_filter(tree, children, ancestor_dirs)
        end
      else
        tree:remove_node(node:get_id())
      end
    end
  end
end

--- Extract a git hash from the current neo-tree line.
--- Matches the format produced by the git_hash component: "abc1234f (Author ...)"
---@return string|nil
local function extract_hash_from_line()
  local line = vim.api.nvim_get_current_line()
  local hash = line:match("(%x%x%x%x%x%x%x+) %(")
  return hash
end

local function clear_filter()
  filter_files = nil
  if filter_autocmd_id then
    pcall(vim.api.nvim_del_autocmd, filter_autocmd_id)
    filter_autocmd_id = nil
  end
end

---@param hash string|nil  commit hash, or nil to extract from cursor line
function M.filter(hash)
  if not hash or hash == "" then
    hash = extract_hash_from_line()
    if not hash then
      vim.notify("NeoTreeGitFilter: no hash found on current line", vim.log.levels.WARN)
      return
    end
  end

  local files = get_commit_files(hash)
  if not files or next(files) == nil then
    vim.notify("NeoTreeGitFilter: no files found for " .. hash, vim.log.levels.WARN)
    return
  end

  clear_filter()
  filter_files = files

  local manager = require("neo-tree.sources.manager")
  local renderer = require("neo-tree.ui.renderer")
  local ok, state = pcall(manager.get_state, "filesystem")
  if not ok or not state or not state.tree then
    vim.notify("NeoTreeGitFilter: neo-tree filesystem not open", vim.log.levels.WARN)
    filter_files = nil
    return
  end

  -- Compute ancestor directories that must be expanded (including root)
  local ancestors_set = { [state.path] = true }
  for file_path, _ in pairs(files) do
    local dir = vim.fn.fnamemodify(file_path, ":h")
    while not ancestors_set[dir] and #dir > #state.path do
      ancestors_set[dir] = true
      dir = vim.fn.fnamemodify(dir, ":h")
    end
  end
  state.force_open_folders = vim.tbl_keys(ancestors_set)

  -- Re-scan tree with forced folders open, then apply filter in callback
  local filesystem = require("neo-tree.sources.filesystem")
  filesystem.navigate(state, state.path, nil, function()
    if not filter_files then
      return
    end
    apply_filter(state.tree, state.tree:get_nodes(), ancestors_set)
    renderer.redraw(state)
  end)

  -- Auto-clear filter when the neo-tree window closes
  if state.winid and vim.api.nvim_win_is_valid(state.winid) then
    filter_autocmd_id = vim.api.nvim_create_autocmd("WinClosed", {
      pattern = tostring(state.winid),
      once = true,
      callback = function()
        clear_filter()
      end,
    })
  end

  vim.notify("NeoTreeGitFilter: " .. hash .. " (" .. vim.tbl_count(files) .. " files)", vim.log.levels.INFO)
end

---------------------------------------------------------------------------
-- Setup
---------------------------------------------------------------------------

function M.setup()
  vim.api.nvim_create_user_command("NeoTreeGitHash", function()
    M.toggle()
  end, { desc = "Toggle git commit hash display in neo-tree" })

  vim.api.nvim_create_user_command("NeoTreeGitFilter", function(opts)
    M.filter(opts.args ~= "" and opts.args or nil)
  end, {
    nargs = "?",
    desc = "Filter neo-tree to files changed in a git commit",
  })
end

return M
