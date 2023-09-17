-- hid

function enc(e, d)
  if e == 1 then
    params:set('clock_tempo', params:get('clock_tempo') + d)
  end
  if e == 2 then 
    params:set('midi_note', params:get('midi_note') + d)
  end 
  if e == 3 then
    params:set('midi_velocity', params:get('midi_velocity') + d)
  end 
end

function key(k, z)
  if z == 0 then return end
  if k == 2 then
    playback = not playback
    if playback then
      device:start()
    else
      device:stop()
    end
  end
  if k == 3 then 
    scan.on = not scan.on
  end
end
