local map = ...
local game = map:get_game()

-----------------------------------------------------------------
-- Outside World E3 (North Castle) - Enemy Hoarde, Heart Piece --
-----------------------------------------------------------------

local function random_walk(npc)
  local m = sol.movement.create("random_path")
  m:set_speed(32)
  m:start(npc)
  npc:get_sprite():set_animation("walking")
end

function map:on_started(destination)
  random_walk(npc_oracle)

  for enemy in map:get_entities("enemy") do
    enemy:set_enabled(false)
  end
  to_level2_1:set_enabled(false)
  to_level2_2:set_enabled(false)
  if not game:get_value("b1732") then chest_heart_piece:set_enabled(false) end
end

function sensor_enemy_hoard:on_activated()
  for enemy in map:get_entities("enemy") do
    enemy:set_enabled(true)
  end
end

for enemy in map:get_entities("enemy_wave1") do
  enemy.on_dead = function()
    if not map:has_entities("enemy_wave1") then
      ladder1_1:set_enabled(true)
      ladder1_2:set_enabled(true)
      ladder1_3:set_enabled(true)
      to_level2_1:set_enabled(true)
    end
  end
end

for enemy in map:get_entities("enemy_wave2") do
  enemy.on_dead = function()
    if not map:has_entities("enemy_wave2") then
      ladder2_1:set_enabled(true)
      ladder2_2:set_enabled(true)
      ladder2_3:set_enabled(true)
      to_level2_2:set_enabled(true)
    end
  end
end

for enemy in map:get_entities("enemy_wave3") do
  enemy.on_dead = function()
    if not map:has_entities("enemy_wave3") then block_1:set_enabled(false) end
  end
end

for enemy in map:get_entities("enemy_wave4") do
  enemy.on_dead = function()
    if not map:has_entities("enemy_wave4") then
      block_2:set_enabled(false)
      chest_heart_piece:set_enabled(true)
    end
  end
end

function npc_oracle:on_interaction()
  game:start_dialog("oracle_3.0.north_castle")
end