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
TulpamancerVice = include('lib/tulpamancervice')

function init_params()
    params:add{ type = 'number', id = 'midi_note', name = 'midi note', min = 1, max = 127, default = 60 }
    params:add{ type = 'number', id = 'midi_velocity', name = 'midi velocity', min = 1, max = 127, default = 60 }
    params:add{ type = 'number', id = 'midi_channel', name = 'midi channel', min = 1, max = 127, default = 1 }
end

function init()
  init_params()
  device = midi.connect(1)
  first_boot = true
  tulpa_pointer = 1
  TulpamancerVice:get_tulpa(first_boot)
  first_boot = false
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
  tulpa_pointer = util.wrap(tulpa_pointer + 1, 1, #TulpamancerVice.tulpa_binary)
  if TulpamancerVice.tulpa_binary:sub(tulpa_pointer, tulpa_pointer) == '1' then
    if is_monophonic_midi_device then
      device:note_off(params:get('midi_note'))
    end
    device:note_on(params:get('midi_note'), params:get('midi_velocity'), params:get('midi_channel'))
  end
end

function redraw()
  graphics_redraw()
end

function cleanup()
  clocks_cleanup()
end
