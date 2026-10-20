local TulpamancerVice = {}

TulpamancerVice.tulpa_api = 'https://www.nyse.com/publicdocs/nyse/US_Equities_Volumes.csv'
TulpamancerVice.tulpa_path = _path.data .. 'tulpamancer/tulpa.txt'
TulpamancerVice.tulpa_exists = false -- meaning: a valid tulpa is loaded
TulpamancerVice.tulpa_binary = ''
TulpamancerVice.fetched_on = nil

local function shell_quote(s)
  return "'" .. (s:gsub("'", "'\\''")) .. "'"
end

local function parse_volume(path)
  local file = io.open(path, 'rb')
  if not file then return nil end
  file:read('*line') -- headers
  local data = file:read('*line')
  file:close()
  if not data then return nil end

  -- sum the quoted numbers in the first data row
  local volume = 0
  local count = 0
  for value in string.gmatch(data, ",\"([^\"]+)\"") do
    local x = tonumber((string.gsub(value, ",", "")))
    if not x then return nil end
    volume = volume + x
    count = count + 1
  end
  if count == 0 then return nil end

  return math.floor(volume)
end

function TulpamancerVice:get_tulpa(force_refresh, tulpa_api)
  -- fetches a fresh tulpa once a day, on force_refresh, or when tulpa.txt is deleted
  -- on failure it keeps the last good tulpa and the next call retries

  local today = os.date('%Y-%m-%d')
  if not force_refresh
    and self.tulpa_exists
    and self.fetched_on == today
    and util.file_exists(self.tulpa_path) then
    return self.tulpa_binary, self.tulpa_exists
  end

  util.make_dir(self.tulpa_path:match('(.*/)'))
  local ok = os.execute('curl -sf ' .. shell_quote(tulpa_api or self.tulpa_api)
    .. ' -o ' .. shell_quote(self.tulpa_path))
  local volume = ok and parse_volume(self.tulpa_path)

  if not volume then
    os.remove(self.tulpa_path)
    return self.tulpa_binary, self.tulpa_exists
  end

  self.tulpa_binary = self.number_to_bitstring(volume, 16)
  self.tulpa_exists = true
  self.fetched_on = today

  return self.tulpa_binary, self.tulpa_exists
end

function TulpamancerVice.number_to_bitstring(n, digits)
  digits = digits or math.max(1, select(2, math.frexp(n)))
  local t = {}
  for b = digits, 1, -1 do
      t[b] = math.fmod(n, 2)
      n = math.floor((n - t[b]) / 2)
  end
  return table.concat(t)
end

return TulpamancerVice
