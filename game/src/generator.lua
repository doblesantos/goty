-- generator.lua
-- Generador de plataformas con:
--  - Tríos (b1A,b1B,b1C) contiguos
--  - Bloques sueltos (b1S)
--  - Capa de "suelo" en las últimas N filas (ground)
--  - Despeje (clearance) por encima del suelo
--  - Hueco horizontal mínimo (min_gap)
--  - Hueco vertical mínimo (min_vgap_rows)
--  - Patrón vertical opcional: 2 filas vacías + 1 con plataformas (use_vertical_pattern)

local M = {}

-- RNG simple con semilla configurable
local function init_rng(seed)
  if seed == nil then seed = os.time() end
  math.randomseed(seed)
  for _ = 1, 4 do math.random() end
end

-- Matriz rows x cols llena con ' '
local function make_empty(rows, cols)
  local g = {}
  for i = 1, rows do
    g[i] = {}
    for j = 1, cols do
      g[i][j] = ' '
    end
  end
  return g
end

-- Pinta el suelo en las últimas ground_rows filas
local function paint_ground(grid, rows, cols, ground_rows, ground_tile)
  if ground_rows <= 0 then return end
  local start_row = math.max(1, rows - ground_rows + 1)
  for i = start_row, rows do
    for j = 1, cols do
      grid[i][j] = ground_tile
    end
  end
end

-- ¿rango horizontal [j, j+len-1] libre en fila i?
local function is_free_range(grid, i, j, len, cols)
  if j < 1 or j + len - 1 > cols then return false end
  for x = j, j + len - 1 do
    if grid[i][x] ~= ' ' then return false end
  end
  return true
end

-- Rellena con espacios un rango (para crear "gap")
local function fill_with_spaces(grid, i, j, len, cols)
  if j < 1 then return end
  local last = math.min(cols, j + len - 1)
  for x = j, last do
    grid[i][x] = ' '
  end
end

-- Garantiza un hueco vertical mínimo entre bloques en la MISMA columna.
local function ensure_vertical_clearance(grid, vgap)
  if vgap <= 0 then return end
  local rows = #grid
  local cols = #grid[1]
  for j = 1, cols do
    local lastSolidRow = nil
    for i = 1, rows do
      local solid = (grid[i][j] ~= ' ')
      if solid then
        if lastSolidRow ~= nil then
          local gap = i - lastSolidRow - 1
          if gap < vgap then
            local need = vgap - gap
            local k = lastSolidRow + 1
            while need > 0 and k < i do
              grid[k][j] = ' '
              need = need - 1
              k = k + 1
            end
          end
        end
        lastSolidRow = i
      end
    end
  end
end

-- Coloca estructuras en una fila i
local function populate_row(grid, i, cols, p_trio, p_single, min_gap)
  local j = 1
  while j <= cols do
    if math.random() < p_trio and is_free_range(grid, i, j, 3, cols) then
      grid[i][j]     = 'b1A'
      grid[i][j + 1] = 'b1B'
      grid[i][j + 2] = 'b1C'
      if min_gap > 0 then
        fill_with_spaces(grid, i, j + 3, min_gap, cols)
        j = j + 3 + min_gap
      else
        j = j + 3
      end
    elseif math.random() < p_single and grid[i][j] == ' ' then
      grid[i][j] = 'b1S'
      if min_gap > 0 then
        fill_with_spaces(grid, i, j + 1, min_gap, cols)
        j = j + 1 + min_gap
      else
        j = j + 1
      end
    else
      j = j + 1
    end
  end
end

-- Generador principal
function M.generate(opts)
  opts = opts or {}
  local rows       = opts.rows or 7
  local cols       = opts.cols or 30
  local p_trio     = opts.p_trio or 0.10
  local p_single   = opts.p_single or 0.10
  local min_gap    = opts.min_gap or 0
  local ground_rows  = opts.ground_rows or 0
  local ground_tile  = opts.ground_tile or 'b1G'
  local clearance    = opts.clearance_from_ground or 0
  local min_vgap_rows = opts.min_vgap_rows or 0
  local use_vertical_pattern = (opts.use_vertical_pattern ~= false) -- por defecto TRUE
  local seed       = opts.seed

  if clearance < 0 then clearance = 0 end
  init_rng(seed)

  local grid = make_empty(rows, cols)

  -- Suelo
  if ground_rows > 0 then
    if ground_rows >= rows then
      paint_ground(grid, rows, cols, rows, ground_tile)
      return grid
    else
      paint_ground(grid, rows, cols, ground_rows, ground_tile)
    end
  end

  -- Última fila donde colocar plataformas (por encima del suelo + clearance)
  local last_platform_row = rows - ground_rows - clearance
  if last_platform_row < 1 then
    return grid
  end

  if use_vertical_pattern then
    -- Patrón: 2 filas vacías + 1 con plataformas
    local rowCycle = 3
    for i = 1, last_platform_row do
      local posInCycle = (i - 1) % rowCycle
      -- Si NO hay suelo, evita terminar con 2 vacías al final:
      local nearBottomNoGround = (ground_rows == 0) and (i > last_platform_row - 2)
      if (posInCycle < 2) and (not nearBottomNoGround) then
        -- forzar fila vacía
        for j = 1, cols do grid[i][j] = ' ' end
      else
        populate_row(grid, i, cols, p_trio, p_single, min_gap)
      end
    end
  else
    -- Sin patrón: se pueden poblar todas las filas elegibles
    for i = 1, last_platform_row do
      populate_row(grid, i, cols, p_trio, p_single, min_gap)
    end
  end

  -- Hueco vertical mínimo
  ensure_vertical_clearance(grid, min_vgap_rows)

  return grid
end

-- Impresión amigable en consola
function M.print(grid)
  local rows = #grid
  local cols = #grid[1]
  for i = 1, rows do
    local parts = {}
    for j = 1, cols do
      local cell = grid[i][j]
      parts[#parts + 1] = string.format("%-4s", cell)
    end
    print(table.concat(parts, ""))
  end
end

return M
