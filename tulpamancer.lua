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
include('lib/tulpamancervice')

params:add{ type = 'number', id = 'midi_note', name = 'midi_note', min = 1, max = 127, default = 60 }
params:add{ type = 'number', id = 'midi_velocity', name = 'midi_velocity', min = 1, max = 127, default = 60 }

device = midi.connect(1)

function init()
  first_boot = true
  tulpa_pointer = 1
  tulpa_binary, tulpa_exists = TulpamancerVice:get_tulpa(first_boot)
  tulpa_clock_id = clock.run(tulpa_clock)
  counter = 0
  is_monophonic_midi_device = true
  music_clock_id = clock.run(music_clock)
  scan_on = true
  graphics()
  playback = true
  device:start()
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
