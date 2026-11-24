-- Reads plugin specs in lua/plugins/*.lua and
-- load them in order specified by priority

local M = {}

-- Read plugin specs from lua/plugins/
function M.read_specs(dir)
  local pattern = dir or vim.fn.stdpath('config') .. '/lua/plugins/*.lua'
  local spec_files = vim.fn.glob(pattern, false, true)
  local specs = {}

  for _, file in ipairs(spec_files) do
    local spec = dofile(file)
    assert(
      type(spec) == "table" and type(spec.src) == "string",
      file .. " must return a table with a string `src`"
    )
    spec.file_name = vim.fn.fnamemodify(file, ":t")
    table.insert(specs, spec)
  end
  return specs
end

function M.setup()
  local specs = M.read_specs()

  table.sort(specs, function(a, b)
    local priority_a = a.priority or 9999
    local priority_b = b.priority or 9999
    if (priority_a == priority_b) then
      return a.file_name < b.file_name
    end
    return priority_a < priority_b
  end)

  local packs = {}
  for _, spec in ipairs(specs) do
    packs[#packs + 1] = { src = spec.src, name = spec.name, version = spec.version}
  end
  vim.pack.add(packs, { confirm = false })

  for _, spec in ipairs(specs) do
    if (type(spec.config) == 'function') then
      local ok, err = pcall(spec.config)
      if not ok then
        vim.notify(
            "Failed to call config on plugin: " .. spec.file_name .. " error: " .. err,
            vim.log.levels.ERROR
        )
      end
    end
  end
end

return M
