-- Every night,
--   the kingdom crumbles.
-- And our MIDI pattern,
--   is conjured anew.
--
-- Share your tulpa today at:
-- https://l.llllllll.co/tulpamancer

include('lib/clocks')
include('lib/graphics')
include('lib/hid')

params:add{ type = 'number', id = 'midi_note', name = 'midi_note', min = 1, max = 127, default = 60 }
params:add{ type = 'number', id = 'midi_velocity', name = 'midi_velocity', min = 1, max = 127, default = 60 }

device = midi.connect(1)

function init()
  first_boot = true
  tulpa_api = 'https://www.nyse.com/publicdocs/nyse/US_Equities_Volumes.csv'
  tulpa_path = '/home/we/dust/code/tulpamancer/tulpa.txt'
  tulpa_exists = false
  tulpa_binary = ''
  tulpa_pointer = 1
  get_tulpa()
  tulpa_clock_id = clock.run(tulpa_clock)
  counter = 0
  is_monophonic_midi_device = true
  music_clock_id = clock.run(music_clock)
  scan_on = true
  graphics()
  playback = true
  device:start()
end

function get_tulpa()
  -- automatically retries in case the tulpa.txt gets deleted
  -- first_boot also gets a fresh tulpa each day
  if util.file_exists(tulpa_path) and not first_boot then
    tulpa_exists = true
  else
    first_boot = false
    tulpa_exists = false
    os.execute('curl -s ' .. tulpa_api .. ' > ' .. tulpa_path)
    local file = io.open(tulpa_path, 'rb')
    local headers = file:read '*line'
    local data = file:read '*line'
    file.close()
    
    -- parse and sum csv
    local volume = 0
    local value = 0
    for value in string.gmatch(data, ",\"([^\"]+)\"") do
      local x = string.gsub(value, ",", "")
      volume = volume + tonumber(x)
    end

    volume = math.floor(volume)
    tulpa_binary = number_to_bitstring(volume, 16)
  end
end

function number_to_bitstring(n, digits)
  digits = digits or math.max(1, select(2, math.frexp(n)))
  local t = {}
  local b = 0
  for b = digits, 1, -1 do
      t[b] = math.fmod(n, 2)
      n = math.floor((n - t[b]) / 2)
  end
  return table.concat(t)
end

function play_tulpa()
  tulpa_pointer = util.wrap(tulpa_pointer + 1, 1, #tulpa_binary)
  if tulpa_binary:sub(tulpa_pointer, tulpa_pointer) == '1' then
    if is_monophonic_midi_device then
      device:note_off(params:get('midi_note'))
    end
    device:note_on(params:get('midi_note'), params:get('midi_velocity'))
  end
end

function redraw()
  graphics_redraw()
end

function cleanup()
  clocks_cleanup()
end
