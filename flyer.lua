--idea from pandorabox server : beacon mod

--idea from floating anchor mod
minetest.register_node("bloc4builder:scafolding", {
	description = "scafolding",
  drawtype = "allfaces_optional",
	tiles ={"b4b_scafolding.png"},
  paramtype = "light",
  sunlight_propagates = true,
	is_ground_content = false,
  climbable = true,
  walkable = false,
  light_source = 10,
	groups = {cracky = 3, oddly_breakable_by_hand = 3, dig_immediate = 3},
--
on_use=function(itemstack,player,pointed_thing)
	-- Figure out where to put the anchor
	local place_position = player:getpos()
  local dir=player:get_look_horizontal()
 
  if dir<1.05 or dir>5.24 then
    place_position.z = place_position.z + 1
  end
  if dir>1.92 and dir<4.19 then
    place_position.z = place_position.z - 1
  end
  if dir>0.52 and dir<2.62 then
    place_position.x = place_position.x - 1
  end
  if dir>3.67 and dir<5.76 then
    place_position.x = place_position.x + 1
  end

  dir=player:get_look_vertical()
  place_position.y = math.ceil(place_position.y)

  if dir>0.79 then
    place_position.y = place_position.y -2
  elseif dir>0.44 and dir<0.8 then
    place_position.y = place_position.y -1
  end

  --check protection before placing

  if minetest.is_protected(place_position,player:get_player_name()) then return end

	local node_to_check = minetest.get_node(place_position)
  --remove scafolding
  if node_to_check.name == "bloc4builder:scafolding" then
    minetest.remove_node(place_position)
    itemstack:add_item("bloc4builder:scafolding 1")
  else

    -- Place the floating anchor in the world
    if node_to_check.name == "air" or node_to_check.name=="vacuum:vacuum" then
      minetest.set_node(place_position, { name = "bloc4builder:scafolding" })
      -- Take an item from the player's stack & return the new stack with 1 fewer items in it
      itemstack:take_item(1)
    end
  end

	return itemstack
end,
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "bloc4builder:scafolding 6",
	recipe = {
		{"default:steel_ingot", "default:torch", "default:steel_ingot"},
		{"default:steel_ingot", "dye:green", "default:steel_ingot"},
		{"default:steel_ingot", "default:torch", "default:steel_ingot"},
	}
})

local flyer_priv_cache = {} -- playername -> {priv=}
local flyer_timer = 0
local singleplayer_flyer_priv=false

minetest.register_globalstep(function(dtime)
	-- Update timer
	flyer_timer = flyer_timer + dtime
	if (flyer_timer > 2) then
		flyer_timer = 0

		-- List all connected player
		local players = minetest.get_connected_players()
		for _,player in ipairs(players) do

			-- Get player infos
			local pos = player:get_pos()
			local name = player:get_player_name()
			local privs = flyer_priv_cache[name]
			if not privs then
				privs = minetest.get_player_privs(name)
			end

			local player_has_privs = privs.fly
			local player_is_admin = privs.privs

--jouer en singleplayer
      if singleplayer_flyer_priv==false and name=="singleplayer" then
        player_is_admin=false
      end
--
			-- Find beacons in radius
			green_beacon_near = minetest.find_node_near(pos, 7, {"bloc4builder:passerelle"})

			-- Revoke privs if not found
			if player_has_privs and not green_beacon_near and not player_is_admin then
				privs = minetest.get_player_privs(name)
				privs.fly = nil			-- revoke priv
				minetest.set_player_privs(name, privs)
				minetest.chat_send_player(name, "Far from the HUB, you lost the ability to fly.")
			end
			
			-- Grant privs if found
			if green_beacon_near and not player_has_privs and not player_is_admin then 
				privs = minetest.get_player_privs(name)
				privs.fly = true
				minetest.set_player_privs(name, privs)
				minetest.chat_send_player(name, "Proximity of a HUB grant you the ability you to fly.")
			end

			flyer_priv_cache[name] = privs
		
		end
	end
end)
