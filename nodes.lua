--**************************
--** bloc4builder ver 2   **
--** Romand Philippe 2020 **
--**************************

--** SOUND **

local function sound_lift(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "lift", gain = 0.4}
	table.dug = table.dug or
			{name = "default_hard_footstep", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

function bloc4builder.start_sound(pos, soundname)
	local nod_met = minetest.get_meta(pos)
	local soundactive = nod_met:get_int("sound")

  if soundname==nil then
    soundname=nod_met:get_string("sound_name")
  end

  if soundactive> -1  then
    minetest.after(0, function(soundactive)
      minetest.sound_stop(soundactive)
    end,soundactive)
    nod_met:set_int("sound", -1)
    return
  end

  soundactive = minetest.sound_play(soundname, {
    pos = pos,
    max_hear_distance = 15,
    loop = true
  })
  nod_met:set_int("sound", soundactive+1)

end

function bloc4builder.stop_sound(pos)
	local nod_met = minetest.get_meta(pos)
	local soundactive = nod_met:get_int("sound")

	if soundactive> -1  then
    minetest.after(0, function(soundactive)
      minetest.sound_stop(soundactive)
    end,soundactive-1)
    nod_met:set_int("sound", -1)
    end

end

local colors_assign={
["dye:white"]=0,
["dye:red"]=1,
["dye:green"]=2,
["dye:blue"]=3,
["dye:magenta"]=4,
["dye:orange"]=5,
["dye:yellow"]=6,
["dye:black"]=7
}

function bloc4builder.change_color(pos,node,player)
  local plname=player:get_player_name()

  if minetest.is_protected(pos, plname) then return end

  local name = player:get_wielded_item():get_name()

  if minetest.registered_items[name].groups.dye ~= nil then
    local color = colors_assign[name] or 0

    if color ~= false then
        local node = minetest.get_node(pos)
        local new_facedir=node.param2 % 32
        node.param2 = (color*32)+new_facedir
        minetest.set_node(pos, node)
--TODO remove itemstack dye:color
    end
  end

end

-- Register nodes

minetest.register_node("bloc4builder:floor", {
	description = "sol industriel",
	tiles ={"b4b_floor.png"},
	groups = {cracky=2, wall = 1},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "bloc4builder:floor 4",
	recipe = {
		{ "default:steel_ingot", "dye:dark_grey", "default:steel_ingot" },
		{ "dye:dark_grey", "default:steel_ingot", "dye:dark_grey" }
	}
})

minetest.register_node("bloc4builder:grille", {
	description = "grille",
    drawtype = "allfaces_optional",
	tiles ={"b4b_grille.png"},
    paramtype = "light",
	is_ground_content = false,
	groups = {cracky=2, wall = 1},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "bloc4builder:grille 4",
	recipe = {
		{ "default:steel_ingot", "", "default:steel_ingot" },
		{ "dye:dark_grey", "", "dye:dark_grey" },
    {"default:steel_ingot","","default:steel_ingot"}
	}
})

minetest.register_node("bloc4builder:structure_oblique", {
description = "structure_oblique",
	tiles = {
		"b4b_structure_metal_oblique.png^[transformR90",
		"b4b_structure_metal_oblique.png",
		"b4b_structure_metal_oblique.png",
		"b4b_structure_metal_oblique.png^[transformR90",
		"b4b_structure_metal_oblique.png",
		"b4b_structure_metal_oblique.png^[transformR90"
	},
	drawtype = "nodebox",
 paramtype = "light",
	is_ground_content = false,
paramtype2 = "facedir",
	groups = {cracky=2, wall = 1},
    sounds = default.node_sound_metal_defaults(),
	})
  
minetest.register_craft({
	output = "bloc4builder:structure_oblique 4",
	recipe = {
		{ "default:steel_ingot", "", "" },
		{ "dye:dark_grey", "default:steel_ingot", "dye:dark_grey" },
    {"","","default:steel_ingot"}
	}
})

minetest.register_node("bloc4builder:steel_support", {
	description = "Steel support",
	tiles = { "b4b_streets_support.png" },
	groups = { cracky = 2, wall = 1},
	drawtype = "glasslike_framed",
	climbable = true,
	sunlight_propagates = true,
	paramtype = "light",
  sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "bloc4builder:steel_support 5",
	recipe = {
		{ "default:steel_ingot", "", "default:steel_ingot" },
		{ "", "default:steel_ingot", "" },
		{ "default:steel_ingot", "", "default:steel_ingot" }
	}
})

minetest.register_node("bloc4builder:steel_support_slope", {
	description = "steel_support Slope",
	sunlight_propagates = false,
	drawtype = "mesh",
	mesh = "slope.obj",
	tiles = {"b4b_streets_support.png"},
		selection_box = {
			type = "fixed",
	fixed = {
		{-0.5,  -0.5,  -0.5, 0.5, -0.25, 0.5},
		{-0.5, -0.25, -0.25, 0.5,     0, 0.5},
		{-0.5,     0,     0, 0.5,  0.25, 0.5},
		{-0.5,  0.25,  0.25, 0.5,   0.5, 0.5}
	}
		},
		collision_box = {
			type = "fixed",
	fixed = {
		{-0.5,  -0.5,  -0.5, 0.5, -0.25, 0.5},
		{-0.5, -0.25, -0.25, 0.5,     0, 0.5},
		{-0.5,     0,     0, 0.5,  0.25, 0.5},
		{-0.5,  0.25,  0.25, 0.5,   0.5, 0.5}
	}
		},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky=2, wall = 1},
	on_place = minetest.rotate_node
})

minetest.register_craft({
	output = "bloc4builder:steel_support_slope 6",
	recipe = {
		{ "", "", "default:steel_support" },
		{ "", "default:steel_support", "" },
		{ "default:steel_support", "", "" }
	}
})

minetest.register_node("bloc4builder:poutre", {
	description = "poutre",
  drawtype = "nodebox",
  tiles = {"b4b_poutre.png^[transformR90", "b4b_poutre.png", "b4b_poutre.png^[transformR180", "b4b_poutre.png", "b4b_poutre.png", "b4b_poutre.png^[transformR180"},
	is_ground_content = false,
  paramtype2 = "facedir",
	groups = {cracky=2, wall = 1},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_craft({
	output = "bloc4builder:poutre 4",
	recipe = {
		{ "default:steel_ingot", "", "default:steel_ingot" },
		{ "dye:orange", "default:steel_ingot", "dye:orange" },
    {"default:steel_ingot","","default:steel_ingot"}
	}
})

-- lamp
minetest.register_node("bloc4builder:lamp", {
	description = "Lamp",
	tiles = {"b4b_lamp.png"},
	groups = {cracky = 3, oddly_breakable_by_hand = 3,not_in_creative_inventory=bloc4builder.creative_enable},
	use_texture_alpha = true,
	sunlight_propagates = true,
	paramtype = "light",
	drawtype = "plantlike",
  light_source = 14,
	sounds = default.node_sound_glass_defaults(),
})

--light
minetest.register_node("bloc4builder:light_on", {
	description = "Light",
	drawtype = "nodebox",
	tiles ={"b4b_neon_light.png"},
	inventory_image = "b4b_neon_light.png",
	wield_image = "b4b_neon_light.png",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = false,
	light_source = LIGHT_MAX-1,
	node_box = {
		type = "fixed",
    fixed = {-0.5,-0.5,-0.5,0.5,-0.4375,0.5},
		},
	groups = {snappy=2,oddly_breakable_by_hand = 2,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_defaults(),
  on_place = minetest.rotate_node,
  on_rightclick = function(pos, node, player)
    minetest.swap_node(pos,{name="bloc4builder:light",param2=node.param2})
  end

})

minetest.register_node("bloc4builder:light", {
	drawtype = "nodebox",
	tiles ={"b4b_neon_light_off.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = false,
	node_box = {
		type = "fixed",
    fixed = {-0.5,-0.5,-0.5,0.5,-0.4375,0.5},
		},
	groups = {snappy=2,oddly_breakable_by_hand = 2,not_in_creative_inventory=1},
  drop="bloc4builder:light_on",
	sounds = default.node_sound_defaults(),
  on_rightclick = function(pos, node, player)
    minetest.swap_node(pos,{name="bloc4builder:light_on",param2=node.param2})
  end
})

minetest.register_node("bloc4builder:lift", {
	description = "lift",
  inventory_image = "b4b_lift.png",
  drawtype = "nodebox",
  node_box = {
		type = "fixed",
    fixed = {
              {-0.5,-0.5,-0.5,-0.4,0.5,-0.4},
              {-0.5,-0.5,0.4,-0.4,0.5,0.5},
              {0.4,-0.5,-0.5,0.5,0.5,-0.4},
              {0.4,-0.5,0.4,0.5,0.5,0.5}
    }
		},
	tiles = {"b4b_air.png"},
	paramtype = "light",
	groups = {cracky=3,wall=1,not_in_creative_inventory=bloc4builder.creative_enable},
  walkable = false,
	climbable = true,
  use_texture_alpha = true,
  sunlight_propagates = true,
	sounds = sound_lift(),
})

-- bloc de couleur pour vaisseaux

minetest.register_node("bloc4builder:black", {
	description = "metal noir",
	drawtype = "normal",
	tiles = {"b4b_bloc_black.png"},
	groups = {cracky=2,wall=1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("bloc4builder:purple", {
	description = "metal purple",
	drawtype = "normal",
	tiles = {"b4b_bloc_purple.png"},
	groups = {cracky=2,wall=1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("bloc4builder:red", {
	description = "metal red",
	drawtype = "normal",
	tiles = {"b4b_bloc_red.png"},
	groups = {cracky=2,wall=1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_metal_defaults(),
})
minetest.register_node("bloc4builder:blue", {
	description = "metal blue",
	drawtype = "normal",
	tiles = {"b4b_bloc_blue.png"},
	groups = {cracky=2,wall=1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("bloc4builder:yellow", {
	description = "metal yellow",
	drawtype = "normal",
	tiles = {"b4b_bloc_yellow.png"},
	groups = {cracky=2,wall=1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("bloc4builder:orange", {
	description = "metal orange",
	drawtype = "normal",
	tiles = {"b4b_bloc_orange.png"},
	groups = {cracky=2,wall=1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("bloc4builder:green", {
	description = "metal green",
	drawtype = "normal",
	tiles = {"b4b_bloc_green.png"},
	groups = {cracky=2,wall=1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("bloc4builder:army", {
	description = "metal army",
	drawtype = "normal",
	tiles = {"b4b_army.png"},
	groups = {cracky=2,wall=1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_metal_defaults(),
})

--Other color

minetest.register_node("bloc4builder:white", {
	description = "metal white",
	drawtype = "normal",
	tiles = {"b4b_bloc_white.png"},
	groups = {cracky=2,wall=1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_metal_defaults(),
  paramtype2 = 'colorfacedir',
  palette="b4b_palette_4.png",
  on_punch= bloc4builder.change_color,
})


minetest.register_node("bloc4builder:rainbow", {
	description = "metal arc en ciel",
	drawtype = "normal",
	tiles = {"b4b_bloc.png"},
	groups = {cracky=2,wall=1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_metal_defaults(),
  paramtype2 = 'colorfacedir',
  palette="b4b_palette_2.png",
  on_punch= bloc4builder.change_color,
})

-- road

minetest.register_node("bloc4builder:road_separator", {
	drawtype = "normal",
	paramtype2 = "facedir",
	description = "road ligne",
	tiles = {"b4b_road_ligne.png",
		 "b4b_road_oblique.png",
		 "b4b_road.png",
		 "b4b_road.png",
		 "b4b_road.png",	
		 "b4b_road.png"},
	groups = {crumbly=3,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:road_warning", {
	drawtype = "normal",
	paramtype2 = "facedir",
	description = "road warning",
	tiles = {"b4b_road_pieton.png",
		 "b4b_road_coin.png",
		 "b4b_road_bordure.png",
		 "b4b_road_bordure.png",
		 "b4b_road_bordure.png",	
		 "b4b_road_bordure.png"},
	groups = {crumbly=3,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:road_fleche", {
	drawtype = "normal",
	paramtype2 = "facedir",
	description = "road fleche",
	tiles = {"b4b_road_fleche_up.png",
		 "b4b_road.png",
		 "b4b_road_fleche_right.png^[transformR270",
		 "b4b_road_fleche_left.png^[transformR90",
		 "b4b_road.png",	
		 "b4b_road.png"},
	groups = {crumbly=3,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:road_neutre", {
	description = "road neutre",
	drawtype = "normal",
	tiles = {"b4b_road.png"},
	groups = {crumbly=3,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_stone_defaults(),
})

--!! issue du mod streets !!

minetest.register_node("bloc4builder:fence_chainlink", {
	description = "Chainlink Fence",
	paramtype = "light",
	drawtype = "nodebox",
	tiles = { "b4b_fence.png" },
	sunlight_propagates = true,
	groups = { cracky=2, wall = 1 },
	node_box = {
		type = "connected",
		fixed = { { -1 / 32, -0.5, -1 / 32, 1 / 32, 0.5, 1 / 32 } },
		connect_front = { { -0.01, -0.5, -0.5, 0.01, 0.5, 0 } }, -- z-
		connect_back = { { -0.01, -0.5, 0, 0.01, 0.5, 0.5 } }, -- z+
		connect_left = { { -0.5, -0.5, -0.01, 0, 0.5, 0.01 } }, -- x-
		connect_right = { { 0, -0.5, -0.01, 0.5, 0.5, 0.01 } }, -- x+
	},
	connects_to = { "group:wall", "group:stone", "group:wood" },
})

minetest.register_craft({
	output = "bloc4builder:fence_chainlink 10",
	recipe = {
		{ "", "dye:dark_green", "" },
		{ "default:steel_ingot", "default:stick", "default:steel_ingot" },
		{ "default:steel_ingot", "default:stick", "default:steel_ingot" }
	}
})


minetest.register_node("bloc4builder:cloison", {
	description = "Cloison",
	paramtype = "light",
	drawtype = "nodebox",
  tiles = {"b4b_cloison_up.png","b4b_cloison_up.png",
		"b4b_cloison_full.png"
	},
	sunlight_propagates = true,
	groups = { cracky = 1, level = 2, wall = 1 ,not_in_creative_inventory=1},
	node_box = {
		type = "connected",
		fixed = {
			{ -0.0625, -0.5, -0.0625, 0.0625, 0.5, 0.0625 }
		},
		connect_front = {
			{ -0.0625, 0.4375, -0.5, 0.0625, 0.5, 0.0625 },
      { -0.02, -0.4375, -0.5, 0.02, 0.4375, 0.0625 },
      { -0.0625, -0.5, -0.5, 0.0625, -0.4375, 0.0625 }
		}, -- z-
		connect_back = {
      { -0.0625, 0.4375, -0.0625, 0.0625, 0.5, 0.5 },
			{ -0.02, -0.4375, -0.0625, 0.02, 0.4375, 0.5 },
      { -0.0625, -0.5, -0.0625, 0.0625, -0.4375, 0.5 }
		}, -- z+
		connect_left = {
      { -0.5, 0.4375, -0.0625, 0.0625, 0.5, 0.0625 },
			{ -0.5, -0.4375, -0.02, 0.0625, 0.4375, 0.02 },
      { -0.5, -0.5, -0.0625, 0.0625, -0.4375, 0.0625 }
		}, -- x-
		connect_right = {
      { -0.0625, 0.4375, -0.0625, 0.5, 0.5, 0.0625 },
			{ -0.0625, -0.4375, -0.02, 0.5, 0.4375, 0.02 },
      { -0.0625, -0.5, -0.0625, 0.5, -0.4375, 0.0625 },
		}, -- x+
	},
	connects_to = { "group:stone", "group:wood", "group:wall" },
	sounds= default.node_sound_stone_defaults()
})

--fake solar panel...or not fake ?
if minetest.get_modpath("spacengine") then
  minetest.register_node("bloc4builder:photovoltaic", {
    description = "Photovoltaic Panel",
    tiles = {"b4b_solar.png",
      "b4b_shiping.png",
      "b4b_solar_side.png"},
    paramtype = "light",
    is_ground_content = false,
    drawtype = "nodebox",
    node_box = {
      type = "fixed",
      fixed = {
        {-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
      },
    },
    groups = {cracky=333, spacengine=3,not_in_creative_inventory=bloc4builder.creative_enable},
    sounds = default.node_sound_glass_defaults(),
    on_construct=function(pos)
      spacengine.construct_node(pos,"Solar panel" , "4¨100¨0¨25¨^solar¨^battery¨10¨0¨0¨0",3)
    end,
    after_place_node=function(pos,placer)
      spacengine.placer_node(pos,placer)
    end,
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
      spacengine.rightclick(pos,node,player,true)
    end,
    can_dig=spacengine.can_dig,
   })
else
  minetest.register_node("bloc4builder:photovoltaic", {
    description = "Photovoltaic Panel",
    tiles = {"b4b_solar.png",
      "b4b_shiping.png",
      "b4b_solar_side.png"},
    paramtype = "light",
    is_ground_content = false,
    drawtype = "nodebox",
    node_box = {
      type = "fixed",
      fixed = {
        {-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
      },
    },
    groups = {dig_immediate = 3,not_in_creative_inventory=bloc4builder.creative_enable},
    sounds = default.node_sound_glass_defaults(),
  })
end
--
-- glass
minetest.register_node("bloc4builder:building_glass", {
	description = "Building Glass",
	tiles = {"b4b_glass.png"},
	groups = {cracky = 3, oddly_breakable_by_hand = 3,not_in_creative_inventory=bloc4builder.creative_enable},
	use_texture_alpha = true,
	sunlight_propagates = true,
	paramtype = "light",
	drawtype = "glasslike",
	sounds = default.node_sound_glass_defaults(),
})

--guardrail_glass
minetest.register_node("bloc4builder:guardrail_glass", {
	description = "Glass Panel",
	tiles = {"b4b_building_glass.png"},
	paramtype = "light",
  paramtype2 = "facedir",
  use_texture_alpha = true,
	is_ground_content = false,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.4375, 0.5, 0.5, 0.5},
		},
	},
	groups = {dig_immediate = 3,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("bloc4builder:guardrail_glass_angle", {
	description = "Glass Panel",
	tiles = {"b4b_building_glass.png"},
	paramtype = "light",
  paramtype2 = "facedir",
  use_texture_alpha = true,
	is_ground_content = false,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.4375, 0.5, 0.5, 0.5},
      {0.4375, -0.5, -0.5, 0.5, 0.5, 0.4375},
		},
	},
	groups = {dig_immediate = 3,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("bloc4builder:glass_chained", {
	description = "Chainlink smokglass",
	paramtype = "light",
	drawtype = "nodebox",
	tiles = { "b4b_smok.png" },
	sunlight_propagates = true,
	groups = { cracky = 2, wall = 1 ,not_in_creative_inventory=bloc4builder.creative_enable},
  use_texture_alpha = true,
	node_box = {
		type = "connected",
		fixed = { { -1 / 32, -0.5, -1 / 32, 1 / 32, 0.5, 1 / 32 } },
		connect_front = {{-1/32, -1/2, -1/2, 1/32, 1/2, -1/32}},
			connect_left = {{-1/2, -1/2, -1/32, -1/32, 1/2, 1/32}},
			connect_back = {{-1/32, -1/2, 1/32, 1/32, 1/2, 1/2}},
			connect_right = {{1/32, -1/2, -1/32, 1/2, 1/2, 1/32}},
	},
	connects_to = { "group:wall", "group:stone", "group:wood", "group:pane" },
	sounds= default.node_sound_stone_defaults()
})

-- concrete

minetest.register_node('bloc4builder:concrete', {
    description = 'Concrete color',
    tiles = { 'b4b_concrete_cpc_32.png' },
    groups = { cracky = 2, ud_param2_colorable = 1, wall=1,not_in_creative_inventory=bloc4builder.creative_enable},
    is_ground_content = false,
    sounds = default.node_sound_stone_defaults(),
    paramtype2 = 'color',
    palette = "unifieddyes_palette_extended.png",
    place_param2 = 240,
    drop = 'bloc4builder:concrete',
    on_construct = unifieddyes.on_construct,
	after_place_node = unifieddyes.recolor_on_place,
	after_dig_node = unifieddyes.after_dig_node,
})


minetest.register_node('bloc4builder:concrete_dir', {
    description = 'Concrete',
    tiles = { 'b4b_concrete.png' },
    groups = { cracky = 2 ,wall=1},
    is_ground_content = false,
    sounds = default.node_sound_stone_defaults(),
})


minetest.register_craft({
	output = "bloc4builder:concrete_dir 5",
	recipe = {
		{ "default:gravel", "default:stone", "default:gravel" },
		{ "default:stone", "dye:grey", "default:stone" },
		{ "default:gravel", "default:stone", "default:gravel" },
	}
})

minetest.register_node("bloc4builder:connect", {
	description = "Concrete connect",
	paramtype = "light",
	drawtype = "nodebox",
	tiles = { "b4b_concrete_cpc_32.png" },
	sunlight_propagates = true,
	groups = { cracky = 1, level = 2, wall = 1, ud_param2_colorable = 1 ,not_in_creative_inventory=bloc4builder.creative_enable},
	node_box = {
		type = "connected",
		fixed = { -0.15, -0.5, -0.15, 0.15, 0.5, 0.15 },
		connect_front = { -0.15, 0.15, -0.5, 0.15, 0.5, 0.15 }, -- z-
		connect_back = { -0.15, 0.15, -0.15, 0.15, 0.5, 0.5 }, -- z+
		connect_left = { -0.5, 0.15, -0.15, -0.15, 0.5, 0.15 }, -- x-
		connect_right = { 0.15, 0.15, -0.15, 0.5, 0.5, 0.15 }, -- x+
	},
	paramtype2 = "color",
   palette = "unifieddyes_palette_extended.png",
   place_param2 = 240,
   on_construct = unifieddyes.on_construct,
   after_place_node = unifieddyes.recolor_on_place,
   after_dig_node = unifieddyes.after_dig_node,
	connects_to = { "group:wall", "group:stone", "group:wood", "group:pane" },
	sounds= default.node_sound_stone_defaults()
})

minetest.register_node("bloc4builder:connect2", {
	description = "Concrete connect2",
	paramtype = "light",
	drawtype = "nodebox",
	tiles = { "b4b_concrete_cpc_32.png" },
	sunlight_propagates = true,
	groups = { cracky = 1, level = 2, wall = 1, ud_param2_colorable = 1 ,not_in_creative_inventory=bloc4builder.creative_enable},
	node_box = {
		type = "connected",
		fixed = { -0.15, 0.15, -0.15, 0.15, 0.5, 0.15 },
		connect_front = { -0.15, 0.15, -0.5, 0.15, 0.5, 0.15 }, -- z-
		connect_back = { -0.15, 0.15, -0.15, 0.15, 0.5, 0.5 }, -- z+
		connect_left = { -0.5, 0.15, -0.15, -0.15, 0.5, 0.15 }, -- x-
		connect_right = { 0.15, 0.15, -0.15, 0.5, 0.5, 0.15 }, -- x+
	},
	paramtype2 = "color",
   palette = "unifieddyes_palette_extended.png",
   place_param2 = 240,
   on_construct = unifieddyes.on_construct,
   after_place_node = unifieddyes.recolor_on_place,
   after_dig_node = unifieddyes.after_dig_node,
	connects_to = { "group:wall", "group:stone", "group:wood", "group:pane" },
	sounds= default.node_sound_stone_defaults()
})

minetest.register_node("bloc4builder:concrete_wall", {
	description = "Concrete Wall bottom",
	paramtype = "light",
	drawtype = "nodebox",
	tiles = {  "b4b_concrete_cpc_32.png"  },
	sunlight_propagates = true,
	groups = { cracky = 1, level = 2, wall = 1 , ud_param2_colorable = 1,not_in_creative_inventory=bloc4builder.creative_enable},
	node_box = {
		type = "connected",
		fixed = { { -0.5, -0.5, -0.5, 0.5, -0.3, 0.5 }, { -0.15, -0.5, -0.15, 0.15, 0.5, 0.15 } },
		connect_front = {  { -0.15, -0.5, -0.5, 0.15, 0.5, 0.15 } }, -- z-
		connect_back = {  { -0.15, -0.5, -0.15, 0.15, 0.5, 0.5 } }, -- z+
		connect_left = {  { -0.5, -0.5, -0.15, 0.15, 0.5, 0.15 } }, -- x-
		connect_right = {  { -0.15, -0.5, -0.15, 0.5, 0.5, 0.15 } }, -- x+
	},
	paramtype2 = "color",
   palette = "unifieddyes_palette_extended.png",
   place_param2 = 240,
   on_construct = unifieddyes.on_construct,
   after_place_node = unifieddyes.recolor_on_place,
   after_dig_node = unifieddyes.after_dig_node,
	connects_to = { "group:wall", "group:stone", "group:wood", "group:pane" },
	sounds= default.node_sound_stone_defaults()
})

minetest.register_node("bloc4builder:concrete_wall_top", {
	description = "Concrete Wall top",
	paramtype = "light",
	drawtype = "nodebox",
	tiles = { "b4b_concrete_cpc_32.png" },
	sunlight_propagates = true,
	node_box = {
		type = "connected",
		fixed = { -0.15, -0.5, -0.15, 0.15, 0.5, 0.15 },
		connect_front = { -0.15, -0.5, -0.5, 0.15, 0.5, 0.15 }, -- z-
		connect_back = { -0.15, -0.5, -0.15, 0.15, 0.5, 0.5 }, -- z+
		connect_left = { -0.5, -0.5, -0.15, 0.15, 0.5, 0.15 }, -- x-
		connect_right = { -0.15, -0.5, -0.15, 0.5, 0.5, 0.15 }, -- x+
	},
	groups = { cracky = 1, level = 2, wall = 1, ud_param2_colorable = 1 ,not_in_creative_inventory=bloc4builder.creative_enable},
	paramtype2 = "color",
   palette = "unifieddyes_palette_extended.png",
   place_param2 = 240,
   on_construct = unifieddyes.on_construct,
   after_place_node = unifieddyes.recolor_on_place,
   after_dig_node = unifieddyes.after_dig_node,
	connects_to = { "group:wall", "group:stone", "group:wood", "group:pane" },
	sounds= default.node_sound_stone_defaults()
})

minetest.register_node("bloc4builder:connect_short", {
	description = "Concrete connect short",
	paramtype = "light",
	drawtype = "nodebox",
	tiles = { "b4b_concrete_cpc_32.png" },
	sunlight_propagates = true,
	groups = { cracky = 1, level = 2, wall = 1, ud_param2_colorable = 1 ,not_in_creative_inventory=bloc4builder.creative_enable},
	node_box = {
		type = "connected",
		fixed = { -0.15, -0.5, -0.15, 0.15, 0.15, 0.15 },
		connect_front = { -0.15, -0.15, -0.5, 0.15, 0.15, 0.15 }, -- z-
		connect_back = { -0.15, -0.15, -0.15, 0.15, 0.15, 0.5 }, -- z+
		connect_left = { -0.5, -0.15, -0.15, -0.15, 0.15, 0.15 }, -- x-
		connect_right = { 0.15, -0.15, -0.15, 0.5, 0.15, 0.15 }, -- x+
	},
	paramtype2 = "color",
   palette = "unifieddyes_palette_extended.png",
   place_param2 = 240,
   on_construct = unifieddyes.on_construct,
   after_place_node = unifieddyes.recolor_on_place,
   after_dig_node = unifieddyes.after_dig_node,
	connects_to = { "group:wall", "group:stone", "group:wood", "group:pane" },
	sounds= default.node_sound_stone_defaults()
})

minetest.register_node("bloc4builder:connect2_short", {
	description = "Concrete connect2 short",
	paramtype = "light",
	drawtype = "nodebox",
	tiles = { "b4b_concrete_cpc_32.png" },
	sunlight_propagates = true,
	groups = { cracky = 1, level = 2, wall = 1, ud_param2_colorable = 1 ,not_in_creative_inventory=bloc4builder.creative_enable},
	node_box = {
		type = "connected",
		fixed = { -0.15, -0.15, -0.15, 0.15, 0.15, 0.15 },
		connect_front = { -0.15, -0.15, -0.5, 0.15, 0.15, 0.15 }, -- z-
		connect_back = { -0.15, -0.15, -0.15, 0.15, 0.15, 0.5 }, -- z+
		connect_left = { -0.5, -0.15, -0.15, -0.15, 0.15, 0.15 }, -- x-
		connect_right = { 0.15, -0.15, -0.15, 0.5, 0.15, 0.15 }, -- x+
	},
	paramtype2 = "color",
   palette = "unifieddyes_palette_extended.png",
   place_param2 = 240,
   on_construct = unifieddyes.on_construct,
   after_place_node = unifieddyes.recolor_on_place,
   after_dig_node = unifieddyes.after_dig_node,
	connects_to = { "group:wall", "group:stone", "group:wood", "group:pane" },
	sounds= default.node_sound_stone_defaults()
})

minetest.register_node("bloc4builder:connect_x", {
	description = "Concrete connect x",
	paramtype = "light",
	drawtype = "nodebox",
	tiles = { "b4b_concrete_cpc_32.png" },
	sunlight_propagates = true,
	groups = { cracky = 1, level = 2, wall = 1, ud_param2_colorable = 1 ,not_in_creative_inventory=bloc4builder.creative_enable},
	node_box = {
		type = "connected",
		fixed = { -0.15, -0.5, -0.15, 0.15, 0.5, 0.15 },
		connect_front = { -0.15, -0.15, -0.5, 0.15, 0.15, 0.15 }, -- z-
		connect_back = { -0.15, -0.15, -0.15, 0.15, 0.15, 0.5 }, -- z+
		connect_left = { -0.5, -0.15, -0.15, -0.15, 0.15, 0.15 }, -- x-
		connect_right = { 0.15, -0.15, -0.15, 0.5, 0.15, 0.15 }, -- x+
	},
	paramtype2 = "color",
   palette = "unifieddyes_palette_extended.png",
   place_param2 = 240,
   on_construct = unifieddyes.on_construct,
   after_place_node = unifieddyes.recolor_on_place,
   after_dig_node = unifieddyes.after_dig_node,
	connects_to = { "group:wall", "group:stone", "group:wood", "group:pane" },
	sounds= default.node_sound_stone_defaults()
})

minetest.register_node("bloc4builder:street_lamp", {
	description = "street pole lamp",
	paramtype = "light",
	drawtype = "nodebox",
	tiles = { "b4b_concrete_cpc_32.png" },
	sunlight_propagates = true,
	node_box = {
		type = "connected",
		fixed = { -0.1, -0.5, -0.1, 0.1, 0.5, 0.1 },
		connect_front = {{ -0.05, 0.3, -0.5, 0.05, 0.4, -0.1 },{ -0.05, 0.2, -0.5, 0.05, 0.3, -0.4 },{ -0.05, 0.1, -0.4, 0.05, 0.2, -0.3 },{ -0.05, 0, -0.3, 0.05, 0.1, -0.2 },{ -0.05, -0.2, -0.2, 0.05, 0, -0.1 }}, -- z-
		connect_back = {{ -0.05, 0.3, 0.1, 0.05, 0.4, 0.5 },{ -0.05, 0.2, 0.4, 0.05, 0.3, 0.5 },{ -0.05, 0.1, 0.3, 0.05, 0.2, 0.4 },{ -0.05, 0, 0.2, 0.05, 0.1, 0.3 },{ -0.05, -0.2, 0.1, 0.05, 0, 0.2 }}, -- z+
		connect_left = {{ -0.5, 0.3, -0.05, -0.1, 0.4, 0.05 },{ -0.5, 0.2, -0.05, -0.4, 0.3, 0.05 },{ -0.4, 0.1, -0.05, -0.3, 0.2, 0.05 },{ -0.3, 0, -0.05, -0.2, 0.1, 0.05 },{ -0.2, -0.2, -0.05, -0.1, 0, 0.05 }}, -- x-
		connect_right = {{ 0.1, 0.3, -0.05, 0.5, 0.4, 0.05 },{ 0.4, 0.2, -0.05, 0.5, 0.3, 0.05 },{ 0.3, 0.1, -0.05, 0.4, 0.2, 0.05 },{ 0.2, 0, -0.05, 0.3, 0.1, 0.05 },{ 0.1, -0.2, -0.05, 0.2, 0, 0.05 }} -- x+
	},
	groups = { cracky = 1, level = 2, wall = 1, ud_param2_colorable = 1 ,not_in_creative_inventory=bloc4builder.creative_enable},
	paramtype2 = "color",
   palette = "unifieddyes_palette_extended.png",
   place_param2 = 240,
   on_construct = unifieddyes.on_construct,
   after_place_node = unifieddyes.recolor_on_place,
   after_dig_node = unifieddyes.after_dig_node,
	connects_to = { "group:wall" },
	sounds= default.node_sound_stone_defaults()
})
--
minetest.register_node("bloc4builder:metal_x_connect", {
	description = "X metal connect",
	paramtype = "light",
	drawtype = "nodebox",
	tiles = { "b4b_bloc_white.png" },
	sunlight_propagates = true,
	groups = { cracky = 1, level = 2, ud_param2_colorable = 1 ,not_in_creative_inventory=bloc4builder.creative_enable},
	node_box = {
		type = "connected",
		fixed = {-0.0625, -0.5, -0.0625, 0.0625, 0.5, 0.0625},
		connect_front = {
			{-0.0625, 0.3125, -0.1875, 0.0625, 0.5, -0.0625}, -- av1
			{-0.0625, 0.1875, -0.3125, 0.0625, 0.375, -0.125}, -- av2
			{-0.0625, 0.0625, -0.4375, 0.0625, 0.25, -0.25}, -- av3
			{-0.0625, -0.125, -0.375, 0.0625, 0.125, -0.5}, -- av4
			{-0.0625, -0.25, -0.4375, 0.0625, -0.0625, -0.25}, -- av5
			{-0.0625, -0.375, -0.3125, 0.0625, -0.1875, -0.125}, -- av6
			{-0.0625, -0.5, -0.1875, 0.0625, -0.3125, -0.0625}, -- av7
    }, -- z-
		connect_back = {
			{-0.0625, 0.3125, 0.0625, 0.0625, 0.5, 0.1875}, -- av1
			{-0.0625, 0.1875, 0.125, 0.0625, 0.375, 0.3125}, -- av2
			{-0.0625, 0.0625, 0.25, 0.0625, 0.25, 0.4375}, -- av3
			{-0.0625, -0.125, 0.375, 0.0625, 0.125, 0.5}, -- av4
			{-0.0625, -0.25, 0.25, 0.0625, -0.0625, 0.4375}, -- av5
			{-0.0625, -0.375, 0.125, 0.0625, -0.1875, 0.3125}, -- av6
			{-0.0625, -0.5, 0.0625, 0.0625, -0.3125, 0.1875}, -- av7
    }, -- z+
		connect_left = {
			{-0.1875, 0.3125, -0.0625,-0.0625, 0.5, 0.0625}, -- r1
			{-0.3125, 0.1875, -0.0625, -0.125, 0.375, 0.0625}, -- r2
			{-0.4375, 0.0625, -0.0625, -0.25, 0.25, 0.0625}, -- r3
			{-0.5, -0.125, -0.0625, -0.375, 0.125, 0.0625}, -- r4
			{-0.4375, -0.25, -0.0625, -0.25, -0.0625, 0.0625}, -- r5
			{-0.3125, -0.375, -0.0625, -0.125, -0.1875, 0.0625}, -- r6
			{-0.1875, -0.5, -0.0625, -0.0625, -0.3125, 0.0625}, -- r7
    }, -- x-
		connect_right = {
			{0.0625, 0.3125, -0.0625, 0.1875, 0.5, 0.0625}, -- r1
			{0.125, 0.1875, -0.0625, 0.3125, 0.375, 0.0625}, -- r2
			{0.25, 0.0625, -0.0625, 0.4375, 0.25, 0.0625}, -- r3
			{0.375, -0.125, -0.0625, 0.5, 0.125, 0.0625}, -- r4
			{0.25, -0.25, -0.0625, 0.4375, -0.0625, 0.0625}, -- r5
			{0.125, -0.375, -0.0625, 0.3125, -0.1875, 0.0625}, -- r6
			{0.0625, -0.5, -0.0625, 0.1875, -0.3125, 0.0625}, -- r7
    }, -- x+
	},
	paramtype2 = "color",
   palette = "unifieddyes_palette_extended.png",
   place_param2 = 240,
   on_construct = unifieddyes.on_construct,
   after_place_node = unifieddyes.recolor_on_place,
   after_dig_node = unifieddyes.after_dig_node,
	connects_to = { "bloc4builder:metal_x_connect" },
	sounds= default.node_sound_metal_defaults()
})
--
minetest.register_node("bloc4builder:metal_z_connect", {
	description = "Z metal connect",
	paramtype = "light",
	drawtype = "nodebox",
	tiles = { "b4b_bloc_white.png" },
	sunlight_propagates = true,
	groups = { cracky = 1, level = 2, ud_param2_colorable = 1 ,not_in_creative_inventory=bloc4builder.creative_enable},
	node_box = {
		type = "connected",
		fixed = {-0.0625, -0.5, -0.0625, 0.0625, 0.5, 0.0625},
		connect_front = {{-0.0625, 0.4375, -0.5, 0.0625, 0.5, -0.0625}, -- av_h
			{-0.0625, -0.5, -0.5, 0.0625, -0.4375, -0.0625}, -- av_b
      {-0.0625, 0.3125, -0.1875, 0.0625, 0.4375, -0.0625}, -- av1
			{-0.0625, 0.1875, -0.3125, 0.0625, 0.3125, -0.1875}, -- av2
			{-0.0625, 0.0625, -0.4375, 0.0625, 0.1875, -0.3125}, -- av3
      {-0.0625, -0.0625, -0.5, 0.0625, 0.0625, -0.4375}, -- av8
    }, -- z-
		connect_back = {{-0.0625, 0.4375, 0.0625, 0.0625, 0.5, 0.5}, -- ar_h
			{-0.0625, -0.5, 0.0625, 0.0625, -0.4375, 0.5}, -- ar_b
			{-0.0625, -0.0625, 0.4375, 0.0625, 0.0625, 0.5}, -- ar4
			{-0.0625, -0.1875, 0.3125, 0.0625, -0.0625, 0.4375}, -- ar5
			{-0.0625, -0.3125, 0.1875, 0.0625, -0.1875, 0.3125}, -- ar6
			{-0.0625, -0.4375, 0.0625, 0.0625, -0.3125, 0.1875}, -- ar7
    }, -- z+
		connect_left = {{-0.5, 0.4375, -0.0625, -0.0625, 0.5, 0.0625}, -- l_h
			{-0.5, -0.5, -0.0625, -0.0625, -0.4375, 0.0625}, -- l_b
			{-0.1875, 0.3125, -0.0625, -0.0625, 0.5, 0.0625}, -- r1
			{-0.3125, 0.1875, -0.0625, -0.1875, 0.3125, 0.0625}, -- r2
			{-0.4375, 0.0625, -0.0625, -0.3125, 0.1875, 0.0625}, -- r3
      {-0.5, -0.0625, -0.0625, -0.4375, 0.0625, 0.0625}, -- r8
    }, -- x-
		connect_right = {{0.0625, 0.4375, -0.0625, 0.5, 0.5, 0.0625}, -- r_h
			{0.0625, -0.5, -0.0625, 0.5, -0.4375, 0.0625}, -- r_b
			{0.4375, -0.0625, -0.0625, 0.5, 0.0625, 0.0625}, -- r4
			{0.3125, -0.1875, -0.0625, 0.4375, -0.0625, 0.0625}, -- r5
			{0.1875, -0.3125, -0.0625, 0.3125, -0.1875, 0.0625}, -- r6
			{0.0625, -0.4375, -0.0625, 0.1875, -0.3125, 0.0625}, -- r7
    }, -- x+
	},
	paramtype2 = "color",
   palette = "unifieddyes_palette_extended.png",
   place_param2 = 240,
   on_construct = unifieddyes.on_construct,
   after_place_node = unifieddyes.recolor_on_place,
   after_dig_node = unifieddyes.after_dig_node,
	connects_to = { "bloc4builder:metal_z_connect" },
	sounds= default.node_sound_metal_defaults()
})

minetest.register_node("bloc4builder:metal_i_connect", {
	description = "I metal connect",
	paramtype = "light",
	drawtype = "nodebox",
	tiles = { "b4b_bloc_white.png" },
	sunlight_propagates = true,
	groups = { cracky = 1, level = 2, ud_param2_colorable = 1 ,not_in_creative_inventory=bloc4builder.creative_enable},
	node_box = {
		type = "connected",
		fixed = {-0.0625, 0.375, -0.0625, 0.0625, 0.5, 0.0625},
		connect_front = {{-0.0625, 0.375, -0.5, 0.0625, 0.5, -0.0625}, -- av_h
    }, -- z-
		connect_back = {{-0.0625, 0.375, 0.0625, 0.0625, 0.5, 0.5}, -- ar_h
    }, -- z+
		connect_left = {{-0.5, 0.375, -0.0625, -0.0625, 0.5, 0.0625}, -- l_h
    }, -- x-
		connect_right = {{0.0625, 0.375, -0.0625, 0.5, 0.5, 0.0625}, -- r_h
    }, -- x+
	},
	paramtype2 = "color",
   palette = "unifieddyes_palette_extended.png",
   place_param2 = 240,
   on_construct = unifieddyes.on_construct,
   after_place_node = unifieddyes.recolor_on_place,
   after_dig_node = unifieddyes.after_dig_node,
	connects_to = { "bloc4builder:metal_i_connect" },
	sounds= default.node_sound_metal_defaults()
})

minetest.register_node("bloc4builder:support_metal_i", {
	description = "Support I metal",
	paramtype = "light",
	drawtype = "nodebox",
	tiles = { "b4b_sol_metal.png" },
	sunlight_propagates = true,
	groups = { cracky = 1, not_in_creative_inventory=bloc4builder.creative_enable},
	node_box = {
		type = "fixed",
		fixed ={-1, -0.5, -0.0625, 0, -0.4375, 0.0625},
	},
	paramtype2 = "facedir",
	sounds= default.node_sound_metal_defaults()
})

minetest.register_node("bloc4builder:support_metal_i_mid", {
		description = "Support I metal mid",
		tiles = {"b4b_sol_metal.png"},
		drawtype = "nodebox",
		paramtype = "light",
    paramtype2 = "facedir",
		groups = {cracky = 2},
		node_box = {
			type = "fixed",
			fixed = {
			{-0.9375, -1.0625, -0.0625, -0.0625, -0.9375, 0.0625}, -- NodeBox2
			}
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.9375, -1.0625, -0.0625, -0.0625, -0.9375, 0.0625}
		}
	})

minetest.register_node("bloc4builder:support_metal", {
	description = "Support T metal",
	paramtype = "light",
	drawtype = "nodebox",
	tiles = { "b4b_bloc_white.png" },
	sunlight_propagates = true,
	groups = { cracky = 1, ud_param2_colorable = 1 ,not_in_creative_inventory=bloc4builder.creative_enable},
	node_box = {
		type = "fixed",
		fixed = {
      {-0.0625, -0.5, -0.0625, 0.0625, 0.4375, 0.0625},
      {-0.5,0.4375,-0.5,0.5,0.5,0.5},
      }
	},
	paramtype2 = "color",
   palette = "unifieddyes_palette_extended.png",
   place_param2 = 240,
   on_construct = unifieddyes.on_construct,
   after_place_node = unifieddyes.recolor_on_place,
   after_dig_node = unifieddyes.after_dig_node,
	sounds= default.node_sound_metal_defaults()
})

--ladder
minetest.register_node("bloc4builder:ladder", {
	description = "Ladder",
	paramtype = "light",
	drawtype = "nodebox",
	tiles = { "b4b_sol.png" },
	sunlight_propagates = true,
	groups = { cracky = 1, not_in_creative_inventory=bloc4builder.creative_enable},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, 0.3125, -0.3125, 0.5, 0.375}, -- NodeBox1
			{0.3125, -0.5, 0.3125, 0.375, 0.5, 0.375}, -- NodeBox2
			{-0.3125, -0.375, 0.3125, 0.3125, -0.3125, 0.375}, -- NodeBox3
			{-0.3125, -0.125, 0.3125, 0.3125, -0.0625, 0.375}, -- NodeBox4
			{-0.3125, 0.125, 0.3125, 0.3125, 0.1875, 0.375}, -- NodeBox5
			{-0.3125, 0.375, 0.3125, 0.3125, 0.4375, 0.375}, -- NodeBox6
			{-0.375, 0.375, 0.375, -0.3125, 0.4375, 0.5}, -- NodeBox7
			{0.3125, 0.375, 0.375, 0.375, 0.4375, 0.5}, -- NodeBox8
		}
	},
	paramtype2 = 'colorfacedir',
  palette="b4b_palette_3.png",
  on_punch= bloc4builder.change_color,
  drop="bloc4builder:ladder",
	sounds= default.node_sound_metal_defaults(),
  climbable = true
})

--bloc decor

minetest.register_node("bloc4builder:containerb4b", {
	description = "container",
	tiles ={"b4b_containerb4b.png"},
	groups = {cracky=2, wall = 1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:pierre_02", {
	description = "pierre 02",
	tiles ={"b4b_dalle.png"},
	groups = {cracky=3, stone=1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:pavement01", {
	description = "pavement 01",
	tiles ={"b4b_pavement01.png"},
	groups = {cracky=3, stone=1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:pavement02", {
	description = "pavement 02",
	tiles ={"b4b_pavement02.png"},
	groups = {cracky=3, stone=1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:pavement03", {
	description = "pavement 03",
	tiles ={"b4b_pavement03.png"},
	groups = {cracky=3, stone=1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:mur_station1", {
	description = "mur station",
	tiles ={"b4b_mur_station.png", "b4b_mur_station_inv.png", "b4b_mur_station_neutre.png", "b4b_mur_station_neutre.png",  "b4b_mur_station_neutre.png", "b4b_mur_station_neutre.png"},
	groups = {cracky=3, wall = 1,not_in_creative_inventory=bloc4builder.creative_enable},
  paramtype2 = "facedir",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:mur_station2", {
	description = "mur station",
	tiles ={"b4b_mur_station_neutre.png", "b4b_mur_station_neutre.png", "b4b_mur_station_bar.png", "b4b_mur_station_bar.png", "b4b_mur_station_bar.png", "b4b_mur_station_bar.png"},
	groups = {cracky=3, wall = 1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:pierre_doree", {
	description = "pierre doree",
	tiles ={"b4b_pierre_dore.png"},
	groups = {cracky=3, stone=1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:metal_floor", {
	description = "metal floor",
	tiles ={"b4b_grille2.png","b4b_grille2.png","b4b_tanker2.png","b4b_tanker2.png","b4b_tanker2.png","b4b_tanker2.png"},
	groups = {cracky=2, wall = 1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("bloc4builder:tole_a", {
	description = "tole a",
	tiles ={"b4b_tole_a.png"},
	groups = {cracky=2, wall = 1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:tanker", {
	description = "tanker",
	tiles ={"b4b_tanker1.png"},
	groups = {cracky=2, wall = 1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:mur_02", {
	description = "mur 02",
	tiles ={"b4b_mur02.png"},
	groups = {cracky=3, stone=1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:beton", {
	description = "beton",
	tiles ={"b4b_beton.png"},
	groups = {cracky=2, wall = 1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:granit", {
	description = "granit",
	tiles ={"b4b_granit.png"},
	groups = {cracky=3, stone=1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:granit_broken", {
	description = "granit_broken",
	tiles ={"b4b_granit_broken.png"},
	groups = {cracky=3, stone=1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:marble", {
	description = "marble",
	tiles ={"b4b_marble.png"},
	groups = {cracky=3, stone=1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:tole_b", {
	description = "tole_b",
	tiles ={"b4b_tole_b.png"},
	groups = {cracky=2, wall = 1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:tole_c", {
	description = "tole_c",
	tiles ={"b4b_tole_c.png"},
	groups = {cracky=2, wall = 1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("bloc4builder:rack", {
	description = "panneaux",
	tiles ={"b4b_plaque.png","b4b_plaque.png","b4b_vitre.png","b4b_porte_maintenance2.png","b4b_rack3.png",{
			image = "b4b_rack_anim.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 1.5
			},},},
	groups = {cracky=3, flammable=2,not_in_creative_inventory=bloc4builder.creative_enable},
paramtype2 = "facedir",
light_source = 3,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:climatiser", {
	description = "climatiser",
	tiles ={"b4b_shiping.png", "b4b_shiping.png", "b4b_pmid.png","b4b_pmid.png","b4b_pmid.png","b4b_pmid.png"},
  paramtype2 = "facedir",
	groups = {cracky=3, wall = 1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_metal_defaults(),
})

--[[
minetest.register_node("bloc4builder:scifi_wall", {
	description = "climatiser",
	tiles ={"b4b_scifi_wall32.png", "b4b_scifi_wall32.png", "b4b_scifi_wall32_inv.png", "b4b_scifi_wall32_inv.png", "b4b_scifi_wall32_inv.png", "b4b_scifi_wall32_inv.png"},
	groups = {cracky=3, wall = 1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_metal_defaults(),
  paramtype2 = 'colorfacedir',
  palette="b4b_palette_2.png",
  on_punch= change_color,
})
--]]

minetest.register_node("bloc4builder:motif", {
	description = "motif",
	tiles ={"b4b_motif03.png","b4b_motif03.png","b4b_motif01.png","b4b_motif01.png","b4b_motif02.png","b4b_motif02.png"},
  paramtype2 = "facedir",
	groups = {cracky=3, wall = 1,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("bloc4builder:astroport_light", {
	description = "Astroport light",
    drawtype = "nodebox",
    tiles = {"b4b_astroport_light_2.png","b4b_astroport_light_2.png",{image = "b4b_astroport_light_1.png",backface_culling = false,animation = {type = "vertical_frames",aspect_w = 16,aspect_h = 16, length = 1.75},},
	},
  node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, -0.375, 0, -0.375}, -- NodeBox1
			{0.375, -0.5, -0.5, 0.5, 0, -0.375}, -- NodeBox2
			{-0.5, -0.5, 0.375, -0.375, 0, 0.5}, -- NodeBox3
			{0.375, -0.5, 0.375, 0.5, 0, 0.5}, -- NodeBox4
			{-0.0625, -0.5, -0.0625, 0.0625, 1.5, 0.0625}, -- NodeBox5
		}
	},
  paramtype = "light",
	is_ground_content = false,
  light_source = LIGHT_MAX-1,
	groups = {snappy=2,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_metal_defaults(),
})

local function register_fuselage(modname,list,option)

  for _, subname in pairs(list) do
    local calcul=option
    local nodename = modname .. ":" .. subname
    local fields = table.copy(minetest.registered_nodes[nodename])

    if #fields.tiles > 1 and fields.drawtype and fields.drawtype:find("glass") then
      fields.tiles = {fields.tiles[1]}
      fields.paramtype2 = nil
    end

    if calcul>10 then 
      bloc4builder.register_b4b_lite(modname, subname, fields, nodename)
      calcul=calcul-100
    end

    if calcul>1 then
      bloc4builder.register_b4b_full(modname, subname, fields, nodename)
      calcul=calcul-10
    end

    if calcul>0 then
      bloc4builder.register_moreblocks(modname, subname, fields, nodename)
    end

  end
end

--moreblocks
local mb_mod=minetest.get_modpath("moreblocks")

--BLOC+ option = b4b lite,b4b full,moreblock

--bloc4builder 
local bloc = {"floor", "grille", "road_neutre","concrete_dir", "poutre", "tole_b", "tole_c", "tole_a", "tanker", "marble", "granit", "beton", "mur_station2", "climatiser", "black", "purple", "green", "red", "yellow", "blue", "orange" , "white" , "rainbow" , "army" , "containerb4b", "pierre_02", "pierre_doree", "pavement02", "mur_02" , "building_glass"}

register_fuselage("bloc4builder",bloc,111)


bloc = {"pavement01", "pavement03"}
register_fuselage("bloc4builder",bloc,1)

--SCIFI
if minetest.get_modpath("scifi_nodes") then
  bloc = {
"glass",
"blue",
"holes",
"white2",
"wall",
"white",
"stripes2top",
"rough",
"lighttop",
"vent2",
"stripes",
"rust",
"mesh",
"black",
"blackoct",
"blackpipe",
"blacktile",
"blacktile2",
"blackvent",
"bluebars",
"bluemetal",
"bluetile",
"greytile",
"mesh2",
"white",
"pipe",
"pipeside",
"tile",
"whiteoct",
"whitetile",
"green_square",
"red_square",
"grey_square",
"blue_square",
"black_mesh",
"dent",
"greenmetal",
"greenmetal2",
"greenlights",
"greenlights2",
"greenbar",
"green2",
"grey",
"greybolts",
"greybars",
"greydots",
"octofloor",
"octofloor2",
"doomwall1",
"doomwall2",
"doomwall3",
"doomwall4",
"doomwall41",
"doomwall42",
"doomwall43",
"doomwall431",
"doomwall44",
"blackdmg",
"blackdmgstripe",
"doomengine",
"monitorwall",
"bluegrid",
"pplwll",
"pplwll2",
"pplwll3",
"pplwll4",
"pplblk",
"purple",
"rock",
"rock2",
"blackvnt",
"blackplate"
 }

  local option=110

  if not mb_mod then
    option=option+1
  end

  register_fuselage("scifi_nodes",bloc,option)

  bloc = {
    "super_white",
    "ultra_white",
    "engine",
    "fan",
    "ppllght",
    "screen3",
    "doomlight",
    "bluwllight",
    "greygreenbar",
    "greentubes",
    "black_detail",
    "red",
    "green"
  }

  local option=100

  if not mb_mod then
    option=option+1
  end

  register_fuselage("scifi_nodes",bloc,option)

end

--abriglass
if minetest.get_modpath("abriglass") then
  bloc = {"clear_glass", "stained_glass_black", "stained_glass_cyan", "stained_glass_magenta", "stained_glass_orange", "stained_glass_yellow", "stained_glass_purple", "glass_light_green", "glass_light_blue", "glass_light_red"}

  local option=110

  if not mb_mod then
    option=option+1
  end

  register_fuselage("abriglass",bloc,option)

end

--default

local default={
  "stone",
	"stone_block",
	"cobble",
	"mossycobble",
	"brick",
	"sandstone",
	"steelblock",
	"goldblock",
	"copperblock",
	"bronzeblock",
	"diamondblock",
	"tinblock",
	"desert_stone",
	"desert_stone_block",
	"desert_cobble",
	"obsidian",
	"obsidian_block",
	"obsidianbrick",
	"stonebrick",
	"desert_stonebrick",
	"sandstonebrick",
	"silver_sandstone",
	"silver_sandstone_brick",
	"silver_sandstone_block",
	"desert_sandstone",
	"desert_sandstone_brick",
	"desert_sandstone_block",
	"sandstone_block",
	"coral_skeleton",
}

for _, subname in pairs(default) do
    local modname = "default"
    local nodename = modname .. ":" .. subname
    local fields = table.copy(minetest.registered_nodes[nodename])

    if #fields.tiles > 1 and fields.drawtype and fields.drawtype:find("glass") then
      fields.tiles = {fields.tiles[1]}
      fields.paramtype2 = nil
    end

bloc4builder.register_b4b_lite("moreblocks", subname, fields, nodename)

  if not mb_mod then
    bloc4builder.register_moreblocks("moreblocks", subname, fields, nodename)
    minetest.register_alias_force("stairs:stair_" .. subname, "moreblocks:stair_" .. subname)
    minetest.register_alias_force("stairs:stair_outer_" .. subname, "moreblocks:stair_" .. subname .. "_outer")
    minetest.register_alias_force("stairs:stair_inner_" .. subname, "moreblocks:stair_" .. subname .. "_inner")
    minetest.register_alias_force("stairs:slab_"  .. subname, "moreblocks:slab_"  .. subname)
  end
end

default={
  "tree",
	"wood",
	"jungletree",
	"junglewood",
	"pine_tree",
	"pine_wood",
	"acacia_tree",
	"acacia_wood",
	"aspen_tree",
	"aspen_wood",
  "obsidian_glass",
  "meselamp",
	"glass"
}

for _, subname in pairs(default) do
    local modname = "default"
    local nodename = modname .. ":" .. subname
    local fields = table.copy(minetest.registered_nodes[nodename])

    if #fields.tiles > 1 and fields.drawtype and fields.drawtype:find("glass") then
      fields.tiles = {fields.tiles[1]}
      fields.paramtype2 = nil
    end

bloc4builder.register_b4b_lite("moreblocks", subname, fields, nodename)
bloc4builder.register_b4b_full("moreblocks", subname, fields, nodename)

  if not mb_mod then
    bloc4builder.register_moreblocks("moreblocks", subname, fields, nodename)
    minetest.register_alias_force("stairs:stair_" .. subname, "moreblocks:stair_" .. subname)
    minetest.register_alias_force("stairs:stair_outer_" .. subname, "moreblocks:stair_" .. subname .. "_outer")
    minetest.register_alias_force("stairs:stair_inner_" .. subname, "moreblocks:stair_" .. subname .. "_inner")
    minetest.register_alias_force("stairs:slab_"  .. subname, "moreblocks:slab_"  .. subname)
  end

end

--wool
if minetest.get_modpath("wool") then
	local dyes = {"white", "grey", "black", "red", "yellow", "green", "cyan",
	              "blue", "magenta", "orange", "violet", "brown", "pink",
	              "dark_grey", "dark_green"}

  for _, subname in pairs(dyes) do
    local modname = "wool"
    local nodename = modname .. ":" .. subname
    local fields = table.copy(minetest.registered_nodes[nodename])

    if #fields.tiles > 1 and fields.drawtype and fields.drawtype:find("glass") then
      fields.tiles = {fields.tiles[1]}
      fields.paramtype2 = nil
    end

    -- Prevent dye+cut wool recipy from creating a full wool block.
    fields.groups.wool = nil

bloc4builder.register_b4b_lite(modname, subname, fields, nodename)
bloc4builder.register_b4b_full(modname, subname, fields, nodename)


    if not mb_mod then
      bloc4builder.register_moreblocks(modname, subname, fields, nodename)
    end
  end
end

--technic
	bloc = {"granite", "marble_bricks","marble" , "marble_column"}

  local option=100

  if not mb_mod then
    option=option+1
  end

  register_fuselage("technic",bloc,option)

--[[
minetest.register_node("bloc4builder:tron_green", {
	description = "TRON green",
	drawtype = "nodebox",
	tiles ={"b4b_tron_green.png"},
	paramtype = "light",
	sunlight_propagates = true,
	light_source = LIGHT_MAX-1,
	groups = {snappy=2,oddly_breakable_by_hand = 2,not_in_creative_inventory=bloc4builder.creative_enable},
	--sounds = default.node_sound_defaults(),
})

minetest.register_node("bloc4builder:tron_blue", {
	description = "TRON blue",
	drawtype = "nodebox",
	tiles ={"b4b_tron_blue.png"},
	paramtype = "light",
	sunlight_propagates = true,
	light_source = LIGHT_MAX-1,
	groups = {snappy=2,oddly_breakable_by_hand = 2,not_in_creative_inventory=bloc4builder.creative_enable},
	--sounds = default.node_sound_defaults(),
})

minetest.register_node("bloc4builder:tron_orange", {
	description = "TRON orange",
	drawtype = "nodebox",
	tiles ={"b4b_tron_orange.png"},
	paramtype = "light",
	sunlight_propagates = true,
	light_source = LIGHT_MAX-1,
	groups = {snappy=2,oddly_breakable_by_hand = 2,not_in_creative_inventory=bloc4builder.creative_enable},
	--sounds = default.node_sound_defaults(),
})

minetest.register_node("bloc4builder:tron_red", {
	description = "TRON red",
	drawtype = "nodebox",
	tiles ={"b4b_tron_red.png"},
	paramtype = "light",
	sunlight_propagates = true,
	light_source = LIGHT_MAX-1,
	groups = {snappy=2,oddly_breakable_by_hand = 2,not_in_creative_inventory=bloc4builder.creative_enable},
	--sounds = default.node_sound_defaults(),
})
--]]
