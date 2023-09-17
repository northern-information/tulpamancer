-- graphics

function graphics()
  scan = {}
  scan.png = '/home/we/dust/code/tulpamancer/scan.png'
  scan.x = 0
  scan.y = 0
  scan.on = true
  scan_clock_id = clock.run(scan_clock)
  redraw_clock_id = clock.run(redraw_clock)
  screen.aa(0)
  screen.font_face(1)
  screen.font_size(8)
end

function graphics_redraw()
  screen.clear()
  if scan.on then
    draw_scan()
  end
  draw_data()
  screen.update()
end

function draw_scan()
  screen.blend_mode('add')
  screen.display_png(scan.png, scan.x, scan.y)
  screen.blend_mode('over')
end

function draw_data()
  screen.level(15)
  screen.move(1, 7)
  screen.text('TULPAMANCER::::::::::::::::')
  if tulpa_exists then
    screen.move(1, 15)
    screen.text('Today\'s tulpa is: ')
    screen.move(1, 28)
    for i = 1, #tulpa_binary do
      if i == tulpa_pointer then
        screen.level(15)
      else
        screen.level(5)
      end
      screen.font_size(12)
      screen.font_face(3)
      screen.text(tulpa_binary:sub(i, i))
      screen.font_face(1)
      screen.font_size(8)
    end
    screen.level(15)
    screen.move(1, 36)
    screen.text(playback and 'K2: playing step ' .. tulpa_pointer or 'K2: paused')
    screen.move(1, 43)
    screen.text('E1: ' .. params:get('clock_tempo') .. ' bpm')
    screen.move(1, 50)
    screen.text('E2: ' .. params:get('midi_note') .. ' MIDI Note')
    screen.move(1, 57)
    screen.text('E3: ' .. params:get('midi_velocity') .. ' MIDI Velocity')
    screen.move(1, 64)
    screen.text('Device: ' .. device.name)
  else
    screen.move(1, 15)
    screen.text('TULPA NOT FOUND.')
    screen.move(1, 22)
    screen.text('CONNECT NORNS TO INTERNET.')
    screen.move(1, 29)
    screen.text('AUTOMATICALLY RETRYING...')
  end
end
