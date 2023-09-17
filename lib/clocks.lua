-- clocks

function redraw_clock()
  while true do
    clock.sleep(1/15)
    redraw()
  end
end

function scan_clock()
  while true do
    clock.sleep(1/3)
    scan.x = math.random((-1024 + 128), 0)
    scan.y = math.random((-512 + 64), 0)
  end
end

function tulpa_clock()
  while true do
    clock.sleep(3)
    get_tulpa()
  end
end

function music_clock()
  while true do
    clock.sync(1/24)
    counter = util.wrap(counter + 1, 1, 24)
    device:clock()
    if playback and counter == 1 then
      play_tulpa()
    end
  end
end

function clocks_cleanup()
  clock.cancel(redraw_clock_id)
  clock.cancel(tulpa_clock_id)
  clock.cancel(music_clock_id)
  clock.cancel(scan_clock_id)
end
