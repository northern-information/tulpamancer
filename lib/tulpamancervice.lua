TulpamancerVice = {}

TulpamancerVice.tulpa_api = 'https://www.nyse.com/publicdocs/nyse/US_Equities_Volumes.csv'
TulpamancerVice.tulpa_path = '/home/we/dust/code/tulpamancer/tulpa.txt'
TulpamancerVice.tulpa_exists = false
TulpamancerVice.tulpa_binary = ''

function TulpamancerVice:get_tulpa(first_boot, tulpa_api)
  -- automatically retries in case the tulpa.txt gets deleted
  -- first_boot also gets a fresh tulpa each day

  local tulpa_api = tulpa_api or self.tulpa_api
  local first_boot = first_boot or false

  if util.file_exists(self.tulpa_path) and not first_boot then
    self.tulpa_exists = true
  else
    print("curling")
    self.tulpa_exists = false
    os.execute('curl -s ' .. tulpa_api .. ' > ' .. self.tulpa_path)
    local file = io.open(self.tulpa_path, 'rb')
    local headers = file:read '*line'
    local data = file:read '*line'
    file:close()

    -- parse and sum csv
    local volume = 0
    local value = 0
    for value in string.gmatch(data, ",\"([^\"]+)\"") do
      local x = string.gsub(value, ",", "")
      volume = volume + tonumber(x)
    end

    volume = math.floor(volume)
    self.tulpa_binary = self.number_to_bitstring(volume, 16)
    self.tulpa_exists = true
  end
  return self.tulpa_binary, self.tulpa_exists
end

function TulpamancerVice:number_to_bitstring(n, digits)
  digits = digits or math.max(1, select(2, math.frexp(n)))
  local t = {}
  local b = 0
  for b = digits, 1, -1 do
      t[b] = math.fmod(n, 2)
      n = math.floor((n - t[b]) / 2)
  end
  return table.concat(t)
end

return TulpamancerVice
