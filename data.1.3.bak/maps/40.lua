local map = ...
local game = map:get_game()

-------------------------------------------
-- Outside World F9 (Hyrule Castle Town) --
-------------------------------------------

function map:on_started(destination)
  -- Opening doors
  local entrance_names = {
    "office", "collector"
  }
  for _, entrance_name in ipairs(entrance_names) do
    local sensor = map:get_entity(entrance_name .. "_door_sensor")
    local tile = map:get_entity(entrance_name .. "_door")
    sensor.on_activated_repeat = function()
      if hero:get_direction() == 1 and tile:is_enabled() and game:get_time_of_day() == "day" then
	tile:set_enabled(false)
	sol.audio.play_sound("door_open")
      end
    end
  end
  -- Activate any night-specific dynamic tiles
  if game:get_time_of_day() == "night" then
    for entity in map:get_entities("night_") do
      entity:set_enabled(true)
    end
  end
end

function sensor_bridge_1:on_activated()
  local x,y,l = map:get_hero():get_position()
  if map:get_hero():get_direction() == 1 then --North
    map:get_hero():set_position(x,y,1)
  end
end
function sensor_bridge_2:on_activated()
  local x,y,l = map:get_hero():get_position()
  if map:get_hero():get_direction() == 3 then --South
    map:get_hero():set_position(x,y,1)
  end
end

function ocarina_wind_to_north:on_interaction()
  if game:has_item("ocarina") then
    game:start_dialog("warp.to_D7", function(answer)
      if answer == 1 then
        sol.audio.play_sound("ocarina_wind")
        map:get_entity("hero"):teleport(51, "ocarina_warp", "fade")
      end
    end)
  end
end
function ocarina_wind_to_east:on_interaction()
  if game:has_item("ocarina") then
    game:start_dialog("warp.to_H6", function(answer)
      if answer == 1 then
        sol.audio.play_sound("ocarina_wind")
        map:get_entity("hero"):teleport(66, "ocarina_warp", "fade")
      end
    end)
  end
end
function ocarina_wind_to_south:on_interaction()
  if game:has_item("ocarina") then
    game:start_dialog("warp.to_F14", function(answer)
      if answer == 1 then
        sol.audio.play_sound("ocarina_wind")
        map:get_entity("hero"):teleport(11, "ocarina_warp", "fade")
      end
    end)
  end
end
function ocarina_wind_to_west:on_interaction()
  if game:has_item("ocarina") then
    game:start_dialog("warp.to_B8", function(answer)
      if answer == 1 then
        sol.audio.play_sound("ocarina_wind")
        map:get_entity("hero"):teleport(72, "ocarina_warp", "fade")
      end
    end)
  end
end