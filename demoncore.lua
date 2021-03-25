-- demoncore
--
-- a really simple noise script
-- but with a mind of its own
-- -----------------------------
--
-- enc2 to scroll for more .....
--
-- norns controls
--
-- Page 1 -  Core  (Noise)
-- ------------------------
-- enc1 - Distance    (volume)
-- enc2 - Criticality   (density)
-- enc3 - Blocks      (mix)
-- key2 - Menu Page 2
-- key3 - Alive / Sleeping (rnd)
--
-- -- Page 2 - Sheild (LP Filter)
-- -------------------------------
-- enc1 - Distance   (volume)    
-- enc2 - Thickness (frequency) 
-- enc3 - Density   (amount)    
-- key2 - Menu Page 3
-- key3 - Alive / Sleeping (rnd)
--
-- -- Page 3 - Lab (Reverb)
-- ---------------------------
-- enc1 - Distance   (volume)
-- enc2 - Temp      (room size)
-- enc3 - Graphite  (damping)
-- key2 - Menu Page 1
-- key3 - Alive / Sleeping (rnd)
--
-- --------------------------
-- Author  : kevin lindley
-- Version : 1.2.0
-- Date    : 2021-03-24
-- --------------------------
--
-- K3 to start ....

engine.name = "DemonCore"

menu_page = 1
alive = true

function key(n,z)
  redraw()
  screen.update()
  print(engine.show_commands)
  if z == 1 then
    if n == 2 then
      menu_page = menu_page + 1
    end
    if n == 3 then
      alive = not alive
      if alive == true then
        counter:start()
      else
        counter:stop()
      end
    end
  end
  if menu_page > 3 then
    menu_page = 1
  end
end

function init()
  screen.aa(0)
  
  -- Set some initial values
  density = 1
  volume = 95
  drywet = 1
  resf = 20000
  resamount = 50
  revroom = 70
  revdamp = 20

  -- Give the engine some initial values to chew on
  engine.amp(volume/100)
  engine.density(density * density * 25)
  engine.mix(drywet/100)
  engine.resf(resf)
  engine.resamount(resamount/100)
  engine.room(revroom/100)
  engine.damp(revdamp/100)

  -- Counter is used to randomise 
  counter = metro.init()
  counter.time = 0.1
  counter.count = -1
  counter.event = randparams
  counter:start()
  
end


-- Used to randomise all the parameters when the K2 is pressed
-- and the script is "Alive"
--
function randparams()
  
  mrand = math.random(-100,100)
  resf= util.clamp(resf + mrand,0,20000)
  engine.resf(resf)
  
  mrand = math.random(-1,1)
  density = util.clamp(density + mrand,0,31)
  engine.density(density * density * 25)
  
  mrand = math.random(-2,2)
  resamount = util.clamp(resamount + mrand,0,100)
  engine.resamount(resamount/100)
     
  mrand = math.random(-1,1)
  volume = util.clamp(volume - mrand,1,100)
  engine.amp(volume/100)
  
  mrand = math.random(-2,2)
  drywet = util.clamp(drywet + mrand,0,100)
  engine.mix(drywet/100)
  
  mrand = math.random(-2,2)
  revroom = util.clamp(revroom + mrand,1,100)
  engine.room(revroom/100)
  
  mrand = math.random(-2,2)
  revdamp = util.clamp(revdamp + mrand,0,100)
  engine.damp(revdamp/100)

  redraw()
end

-- Standard Encoder function
-- menu_page used to switch between modes of the buttons
function enc(n,d)
  if menu_page == 1 then
    -- Amplitude
    if n == 1 then
      volume = util.clamp(volume + d,1,100)
      engine.amp(volume/100)
    end
    -- Density
    if n == 2 then
      density = util.clamp(density + d,0,31)
      engine.density(density * density * 25)
    end
    -- Dry / Wet Mix for Reverb
    if n == 3 then
      drywet = util.clamp(drywet + d,0,100)
      engine.mix(drywet/100)
    end
  end
  if menu_page == 2 then
    -- Amplitude
    if n == 1 then
      volume = util.clamp(volume + d,1,100)
      engine.amp(volume/100)
    end 
    -- Cut-off Frequency
    if n == 2 then
      resf = util.clamp(resf + d*resf/20,0,20000)
      engine.resf(resf)
    end 
    -- Resonant Amount
    if n == 3 then
      resamount = util.clamp(resamount + d,0,100)
      engine.resamount(resamount/100)
    end 
  end
  if menu_page == 3 then
    -- Amplitude
    if n == 1 then
      volume = util.clamp(volume + d,1,100)
      engine.amp(volume/100)
    end 
    -- Reverb Room Size
    if n == 2 then
      revroom = util.clamp(revroom + d,1,100)
      engine.room(revroom/100)
    end
    -- Reverb Damping
    if n == 3 then
      revdamp = util.clamp(revdamp + d,0,100)
      engine.damp(revdamp/100)
    end 
  end
  redraw()
end

-- A bit of animation to brighten things up
--
function redraw()
  screen.clear()
  screen.blend_mode(0)
  screen.display_png("/home/we/dust/code/demoncore/assets/core.png", 0, 0)
  screen.blend_mode(5)
  if density&16 == 16 then
    screen.display_png("/home/we/dust/code/demoncore/assets/glow5.png", 0, 0)
  end 
  if density&8 == 8 then
    screen.display_png("/home/we/dust/code/demoncore/assets/glow4.png", 0, 0)
  end 
  if density&4 == 4 then
    screen.display_png("/home/we/dust/code/demoncore/assets/glow3.png", 0, 0)
  end 
  if density&2 == 2 then
    screen.display_png("/home/we/dust/code/demoncore/assets/glow2.png", 0, 0)
  end 
  if density&1 == 1 then
    screen.display_png("/home/we/dust/code/demoncore/assets/glow1.png", 0, 0)
  end 
  screen.blend_mode(0)
  
  screen.level(1)
  
  if menu_page == 1 then
    screen.move(4,8)
    screen.text("K2 Page 1 - Core")    
    screen.move(4,18)
    screen.text("E1 Distance: ")
    screen.move(60,18)
    screen.text(101 - volume .. "\"")
    screen.move(4,26)
    screen.text("E2 Criticality: ")
    screen.move(60,26)
    screen.text(density)
    screen.move(4,34)
    screen.text("E3 Blocks:")
    screen.move(60,34)
    screen.text(drywet)
  end
  
  if menu_page == 2 then
    screen.move(4,8)
    screen.text("K2 Page 2 - Sheilding")
    screen.move(4,18)
    screen.text("E1 Distance: ")
    screen.move(60,18)
    screen.text(101 - volume .. "\"")
    screen.move(4,26) 
    screen.text("E2 Thickness: ")
    screen.move(60,26)
    screen.text(201 - math.floor(resf)/100)
    screen.move(4,34)
    screen.text("E3 Density: ")
    screen.move(60,34)
    screen.text(resamount)
  end 
  
  if menu_page == 3 then
    screen.move(4,8)
    screen.text("K2 Page 3 - Laboratory")
    screen.move(4,18)
    screen.text("E1 Distance: ")
    screen.move(60,18)
    screen.text(101 - volume .. "\"")
    screen.move(4,26) 
    screen.text("E2 Temp: ")
    screen.move(60,26)
    screen.text(32 + revroom/2 .. "F" )
    screen.move(4,34)
    screen.text("E3 Graphite: ")
    screen.move(60,34)
    screen.text(revdamp)
  end  
  
  screen.move(20,56)
  if alive == true then
    screen.text("K3 Alive")
  else
    screen.text("K3 Sleeping")
  end
  screen.update()
end  
