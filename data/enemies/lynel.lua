local enemy = ...

-- Lynel

local shooting = false
local shoot_timer

function enemy:on_created()
  self:set_life(6)
  self:set_damage(4)
  self:create_sprite("enemies/lynel")
  self:set_size(32, 32)
  self:set_origin(16, 27)
  self:set_attack_consequence("boomerang", "protected")
  self:set_attack_consequence("arrow", "protected")
  self:set_attack_consequence("fire", "protected")
end

function enemy:shoot()
  self:stop_movement()
  self:get_sprite():set_animation("immobilized")
  shoot_timer = sol.timer.start(self, 100, function()
    local rock = self:create_enemy{
      breed = "lynel_fire",
      direction = d
    }
    sol.timer.start(self, 2000, function()
      shoot_timer = nil
      self:restart()
    end)
  end)
end

function enemy:on_restarted()
  local m = sol.movement.create("path_finding")
  m:set_speed(32)
  m:start(self)

  if math.random(4) == 1 then
    self:shoot()
  end
end

function enemy:on_movement_changed(movement)
  local direction4 = movement:get_direction4()
  local sprite = self:get_sprite()
  sprite:set_direction(direction4)
end

function enemy:on_hurt()
  self:shoot()
end