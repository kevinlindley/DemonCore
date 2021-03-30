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
-- enc1 - Volume
-- enc2 - Criticality   (density)
-- enc3 - Mix   
-- key2 - Menu Page 2
-- key3 - Alive / Sleeping (rnd)
--
-- -- Page 2 - Shield (LP Filter)
-- -------------------------------
-- enc1 - Volume    
-- enc2 - Frequency 
-- enc3 - Cutoff    
-- key2 - Menu Page 3
-- key3 - Alive / Sleeping (rnd)
--
-- -- Page 3 - Lab (Reverb)
-- ---------------------------
-- enc1 - Volume
-- enc2 - Room Size
-- enc3 - Damping
-- key2 - Menu Page 1
-- key3 - Alive / Sleeping (rnd)
--
-- --------------------------
-- Author  : Kevin Lindley
-- Version : 1.4.0
-- Date    : 2021-03-30
-- --------------------------
--
-- K3 to start ....

engine.name = "DemonCore"

menu_page = 1
alive = true

function key(n,z)
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
  redraw()
  screen.update()
end

function densitychanged(x)
  engine.density(x * x * 25)
  redraw()
end

function roomchanged(x)
  engine.room(x/100)
  redraw()
end

function volumechanged(x)
  engine.amp(x/100)
  redraw()
end

function dampchanged(x)
  engine.damp(x/100)
  redraw()
end

function mixchanged(x)
  engine.mix(x/100)
  redraw()
end

function cutoffchanged(x)
  engine.resf(x)
  redraw()
end

function resamountchanged(x)
  engine.resamount(x/100)
  redraw()
end

function setup_parameters()
  params:add_separator()
  params:add_number("volume","volume",0,100,50)
  params:set_action("volume", function(x) volumechanged(x) end)
  params:add_number("density","density",0,31,1)
  params:set_action("density", function(x) densitychanged(x) end)
  params:add_number("mix","mix",0,100,50)
  params:set_action("mix", function(x) mixchanged(x) end)
  params:add_number("cutoff","cutoff",0,20000,8000)
  params:set_action("cutoff", function(x) cutoffchanged(x) end)
  params:add_number("resamount","resamount",0,100,50)
  params:set_action("resamount", function(x) resamountchanged(x) end)
  params:add_number("room","room",0,100,70)
  params:set_action("room", function(x) roomchanged(x) end)
  params:add_number("damp","damp",0,100,20)
  params:set_action("damp", function(x) dampchanged(x) end)
  params:bang()
end

function init()
  screen.aa(0)
  setup_parameters()
  -- Counter is used to randomise 
  counter = metro.init()
  counter.time = 0.25
  counter.count = -1
  counter.event = randparams
  counter:start()
end

-- Used to randomise all the parameters when the K2 is pressed
-- and the script is "Alive"
--
function randparams()
  params:set("density",  params:get("density")   + math.random(-1,1))
  params:set("cutoff",   params:get("cutoff")   + math.random(-1,1))
  params:set("resamount",params:get("resamount") + math.random(-2,2))
  params:set("volume",   params:get("volume")    + math.random(-1,1))
  params:set("room",     params:get("room")      + math.random(-2,2))
  params:set("mix",      params:get("mix")       + math.random(-2,2))
  params:set("damp",     params:get("damp")      + math.random(-2,2))
  params:set("cutoff",   params:get("cutoff")    + math.random(-2,2))  
  params:bang()
  redraw()
end

-- Standard Encoder function
-- menu_page used to switch between modes of the buttons
function enc(n,d)
  if (menu_page == 1) then
    -- Amplitude
    if (n == 1) then params:set("volume",params:get("volume") + d) end
    -- Density
    if (n == 2) then params:set("density",params:get("density") + d) end
    -- Dry / Wet Mix for Reverb
    if (n == 3) then params:set("mix",params:get("mix") + d) end
  end
  if (menu_page == 2) then
    -- Amplitude
    if (n == 1) then params:set("volume",params:get("volume") + d) end
    -- Cut-off Frequency
    if (n == 2) then params:set("cutoff",params:get("cutoff") + d*10) end
    -- Resonant Amount
    if (n == 3) then params:set("resamount",params:get("resamount") + d) end
  end
  if (menu_page == 3) then
    -- Amplitude
    if (n == 1) then params:set("volume",params:get("volume") + d) end
    -- Reverb Room Size
    if (n == 2) then params:set("room",params:get("room") + d) end
    -- Reverb Damping
    if (n == 3) then params:set("damp",params:get("damp") + d) end
  end
  params:bang()
  redraw()
end

-- A bit of animation to brighten things up
--
function redraw()
  screen.clear()
  screen.blend_mode(0)
  screen.display_png("/home/we/dust/code/demoncore/assets/core.png", 0, 0)
  screen.blend_mode(5)
  if params:get("density")&16 == 16 then
    screen.display_png("/home/we/dust/code/demoncore/assets/glow5.png", 0, 0)
  end 
  if params:get("density")&8 == 8 then
    screen.display_png("/home/we/dust/code/demoncore/assets/glow4.png", 0, 0)
  end 
  if params:get("density")&4 == 4 then
    screen.display_png("/home/we/dust/code/demoncore/assets/glow3.png", 0, 0)
  end 
  if params:get("density")&2 == 2 then
    screen.display_png("/home/we/dust/code/demoncore/assets/glow2.png", 0, 0)
  end 
  if params:get("density")&1 == 1 then
    screen.display_png("/home/we/dust/code/demoncore/assets/glow1.png", 0, 0)
  end 
  screen.blend_mode(0)
  
  screen.level(1)
  
  if (menu_page == 1) then
    screen.move(4,8)
    screen.text("K2 Page 1 - Core")    
    screen.move(4,18)
    screen.text("E1 Volume: ")
    screen.move(60,18)
    screen.text(params:get("volume"))
    screen.move(4,26)
    screen.text("E2 Criticality: ")
    screen.move(60,26)
    screen.text(params:get("density"))
    screen.move(4,34)
    screen.text("E3 Mix:")
    screen.move(60,34)
    screen.text(params:get("mix"))
  end
  
  if (menu_page == 2) then
    screen.move(4,8)
    screen.text("K2 Page 2 - Sheilding")
    screen.move(4,18)
    screen.text("E1 Volume: ")
    screen.move(60,18)
    screen.text(params:get("volume"))
    screen.move(4,26) 
    screen.text("E2 Cutoff: ")
    screen.move(60,26)
    screen.text(params:get("cutoff"))
    screen.move(4,34)
    screen.text("E3 Density: ")
    screen.move(60,34)
    screen.text(params:get("resamount"))
  end 
  
  if (menu_page == 3) then
    screen.move(4,8)
    screen.text("K2 Page 3 - Laboratory")
    screen.move(4,18)
    screen.text("E1 Volume: ")
    screen.move(60,18)
    screen.text(params:get("volume"))
    screen.move(4,26) 
    screen.text("E2 Size: ")
    screen.move(60,26)
    screen.text(params:get("room"))
    screen.move(4,34)
    screen.text("E3 Damping: ")
    screen.move(60,34)
    screen.text(params:get("damp"))
  end  
  
  screen.move(20,56)
  if (alive == true) then
    screen.text("K3 Alive")
  else
    screen.text("K3 Sleeping")
  end
  screen.update()
end  