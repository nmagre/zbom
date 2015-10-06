local map = ...
local game = map:get_game()

---------------------------------------------
-- Dungeon 8: Interloper Sanctum (Floor 1) --
---------------------------------------------

function map:on_started(destination)
  if not game:get_value("b1180") then chest_compass:set_enabled(false) end
  if not game:get_value("b1185") then chest_key_1:set_enabled(false) end
  if not game:get_value("b1183") then
    miniboss_shadow_link:set_enabled(false)
    chest_item:set_enabled(false)
  end
  if not game:get_value("b1190") then boss_zirna:set_enabled(false) end
  if not game:get_value("b1191") then boss_belahim:set_enabled(false) end
  if not game:get_value("b1190") and not game:get_value("b1191") then
    boss_heart:set_enabled(false)
  end
  dark_mirror:set_enabled(false)
end

for enemy in map:get_entities("wizzrobe_room6") do
  enemy.on_dead = function()
    if not map:has_entities("wizzrobe_room6") and not game:get_value("b1180") then
      chest_compass:set_enabled(true)
      sol.audio.play_sound("chest_appears")
    end
  end
end

for enemy in map:get_entities("wizzrobe_room7") do
  enemy.on_dead = function()
    if not map:has_entities("wizzrobe_room7") and not game:get_value("b1185") then
      chest_key_1:set_enabled(true)
      sol.audio.play_sound("chest_appears")
    end
  end
end

function sensor_miniboss:on_activated()
  if miniboss_shadow_link ~= nil then
    map:close_doors("door_boss")
    miniboss_shadow_link:set_enabled(true)
    sol.audio.play_music("boss")
  end
end
if miniboss_shadow_link ~= nil then
  function miniboss_shadow_link:on_dead()
    game:set_value("b1131", true)
    map:open_doors("door_boss") -- door out of boss chamber
    map:open_doors("room11_shutter") -- door down to basement
    sol.audio.play_sound("boss_killed")
    chest_item:set_enabled(true)
    sol.audio.play_sound("chest_appears")
    sol.audio.play_music("temple_sanctum")
  end
end

function sensor_boss:on_activated()
  if boss_zirna ~= nil and game:get_value("dungeon_8_explored_1b_complete") then
    boss_zirna:set_enabled(true)
    sol.audio.play_music("boss")
    map:close_doors("door_boss")
  end
end
if boss_zirna ~= nil then
  function boss_zirna:on_dead()
    sol.timer.start(self:get_map(), 5000, function()
      game:start_dialog("belahim.0.speech_1", function()
        boss_belahim:set_enabled(true)
      end)
    end)
  end
end
if boss_belahim ~= nil then
  function boss_belahim:on_dead()
    sol.audio.play_sound("boss_killed")
    boss_heart:set_enabled(true)
    sol.timer.start(1000, function()
      sol.audio.play_music("temple_sanctum")
      dark_mirror:fade_in(100, function()
        -- dialog to explain the dark mirror and fate of the dark tribe (by Ordona?)
        bed_zelda:fade_out(100, function()
          -- dialog about Zelda disappearing and returning to Hyrule Castle
          map:get_hero():teleport("84", "from_sanctum")  -- Teleport hero outside of Sanctum.
        end)
      end)
      map:open_doors("door_boss")
    end)
  end
end