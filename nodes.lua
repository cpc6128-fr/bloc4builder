--**************************
--** bloc4builder ver 2   **
--** Romand Philippe 2020 **
--**************************
-- Register nodes

local function sound_lift(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "lift", gain = 0.4}
	table.dug = table.dug or
			{name = "default_hard_footstep", gain = 1.0}
	default.node_sound_defaults(table)
	return table
end

minetest.register_node("bloc4builder:floor", {
	description = "sol industriel",
	tiles ={"floor.png"},
	groups = {cracky=3},
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
	tiles ={"grille.png"},
    paramtype = "light",
	is_ground_content = false,
	groups = {cracky=3},
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
		"structure_metal_oblique.png^[transformR90",
		"structure_metal_oblique.png",
		"structure_metal_oblique.png",
		"structure_metal_oblique.png^[transformR90",
		"structure_metal_oblique.png",
		"structure_metal_oblique.png^[transformR90"
	},
	drawtype = "nodebox",
 paramtype = "light",
	is_ground_content = false,
paramtype2 = "facedir",
	groups = {cracky=3},
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
	tiles = { "streets_support.png" },
	groups = { cracky = 1 },
	drawtype = "glasslike_framed",
	climbable = true,
	sunlight_propagates = true,
	paramtype = "light",
	collision_box = {
		type = "fixed",
		fixed = {
			{ -0.15, -0.5, -0.15, 0.15, 0.5, 0.15 },
		},
	},
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
	tiles = {"streets_support.png"},
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
	light_source = light,
	groups = {cracky=1},
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
    tiles = {"poutre.png^[transformR90", "poutre.png", "poutre.png^[transformR180", "poutre.png", "poutre.png", "poutre.png^[transformR180"},
  paramtype = "light",
	is_ground_content = false,
paramtype2 = "facedir",
	groups = {cracky=3},
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

--
minetest.register_node("bloc4builder:light_up", {
	description = "Light",
	drawtype = "nodebox",
	tiles ={"neon_light.png"},
	inventory_image = "neon_light.png",
	wield_image = "neon_light.png",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = false,
	light_source = LIGHT_MAX-1,
	node_box = {
		type = "fixed",
    fixed = {-0.5,-0.5,-0.5,0.5,-0.4375,0.5},
		},
	groups = {choppy=2,dig_immediate=3},
	sounds = default.node_sound_defaults(),
  on_place = minetest.rotate_node,
  on_rightclick = function(pos, node, player)
    minetest.swap_node(pos,{name="bloc4builder:light_off",param2=node.param2})
  end

})

minetest.register_node("bloc4builder:light_off", {
	description = "Light off",
	drawtype = "nodebox",
	tiles ={"neon_light_off.png"},
	inventory_image = "neon_light_off.png",
	wield_image = "neon_light.png",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = false,
	node_box = {
		type = "fixed",
    fixed = {-0.5,-0.5,-0.5,0.5,-0.4375,0.5},
		},
	groups = {choppy=2,dig_immediate=3,not_in_creative_inventory=1},
  drop="bloc4builder:light_up",
	sounds = default.node_sound_defaults(),
  on_rightclick = function(pos, node, player)
    minetest.swap_node(pos,{name="bloc4builder:light_up",param2=node.param2})
  end
})

minetest.register_node("bloc4builder:lift", {
	description = "lift",
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
	tiles = {"bloc4builder_air.png"},
	paramtype = "light",
	groups = {cracky=3,wall=1},
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
	tiles = {"bloc_black.png"},
	paramtype = "light",
	groups = {cracky=3,wall=1},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("bloc4builder:purple", {
	description = "metal purple",
	drawtype = "normal",
	tiles = {"bloc_purple.png"},
	paramtype = "light",
	groups = {cracky=3,wall=1},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("bloc4builder:red", {
	description = "metal red",
	drawtype = "normal",
	tiles = {"bloc_red.png"},
	paramtype = "light",
	groups = {cracky=3,wall=1},
	sounds = default.node_sound_metal_defaults(),
})
minetest.register_node("bloc4builder:blue", {
	description = "metal blue",
	drawtype = "normal",
	tiles = {"bloc_blue.png"},
	paramtype = "light",
	groups = {cracky=3,wall=1},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("bloc4builder:yellow", {
	description = "metal yellow",
	drawtype = "normal",
	tiles = {"bloc_yellow.png"},
	paramtype = "light",
	groups = {cracky=3,wall=1},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("bloc4builder:orange", {
	description = "metal orange",
	drawtype = "normal",
	tiles = {"bloc_orange.png"},
	paramtype = "light",
	groups = {cracky=3,wall=1},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("bloc4builder:green", {
	description = "metal green",
	drawtype = "normal",
	tiles = {"bloc_green.png"},
	paramtype = "light",
	groups = {cracky=3,wall=1},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("bloc4builder:white", {
	description = "metal white",
	drawtype = "normal",
	tiles = {"bloc_white.png"},
	paramtype = "light",
	groups = {cracky=3,wall=1},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("bloc4builder:army", {
	description = "metal army",
	drawtype = "normal",
	tiles = {"army.png"},
	paramtype = "light",
	groups = {cracky=3,wall=1},
	sounds = default.node_sound_metal_defaults(),
})

-- road

minetest.register_node("bloc4builder:road_separator", {
	drawtype = "normal",
	paramtype = "light",
	paramtype2 = "facedir",
	description = "road ligne",
	tiles = {"asphalt_ligne.png",
		 "asphalt_oblique2.png",
		 "asphalt.png",
		 "asphalt.png",
		 "asphalt.png",	
		 "asphalt.png"},
	groups = {crumbly=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:road_warning", {
	drawtype = "normal",
	paramtype = "light",
	paramtype2 = "facedir",
	description = "road warning",
	tiles = {"asphalt_pieton.png",
		 "asphalt_coin.png",
		 "asphalt_bordure.png",
		 "asphalt_bordure.png",
		 "asphalt_bordure.png",	
		 "asphalt_bordure.png"},
	groups = {crumbly=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:road_fleche", {
	drawtype = "normal",
	paramtype = "light",
	paramtype2 = "facedir",
	description = "road fleche",
	tiles = {"asphalt_fleche_up.png",
		 "asphalt.png",
		 "asphalt_fleche_right.png^[transformR270",
		 "asphalt_fleche_left.png^[transformR90",
		 "asphalt.png",	
		 "asphalt.png"},
	groups = {crumbly=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:road_neutre", {
	description = "road neutre",
	drawtype = "normal",
	tiles = {"asphalt.png"},
	paramtype = "light",
	drop = "bloc4builder:road_neutre",
	groups = {crumbly=3},
	sounds = default.node_sound_stone_defaults(),
})

--!! issue du mod street !!

minetest.register_node("bloc4builder:fence_chainlink", {
	description = "Chainlink Fence",
	paramtype = "light",
	drawtype = "nodebox",
	tiles = { "fence.png" },
	sunlight_propagates = true,
	groups = { cracky=2, wall = 1 },
	node_box = {
		type = "connected",
		fixed = { { -1 / 32, -0.5, -1 / 32, 1 / 32, 0.5, 1 / 32 } },
		connect_front = { { 0, -0.5, -0.5, 0, 0.5, 0 } }, -- z-
		connect_back = { { 0, -0.5, 0, 0, 0.5, 0.5 } }, -- z+
		connect_left = { { -0.5, -0.5, 0, 0, 0.5, 0 } }, -- x-
		connect_right = { { 0, -0.5, 0, 0.5, 0.5, 0 } }, -- x+
	},
	selection_box = {
		type = "connected",
		fixed = { { -1 / 16, -0.5, -1 / 16, 1 / 16, 0.5, 1 / 16 } },
		connect_front = { { 0, -0.5, -0.5, 0, 0.5, 0 } }, -- z-
		connect_back = { { 0, -0.5, 0, 0, 0.5, 0.5 } }, -- z+
		connect_left = { { -0.5, -0.5, 0, 0, 0.5, 0 } }, -- x-
		connect_right = { { 0, -0.5, 0, 0.5, 0.5, 0 } }, -- x+
	},
	connects_to = { "group:wall", "group:stone", "group:wood", "group:tree", "group:concrete" },
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
  tiles = {"cloison_up.png","cloison_up.png",
		"cloison_full.png"
	},
	sunlight_propagates = true,
	groups = { cracky = 1, level = 2, wall = 1 },
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
	connects_to = { "group:wall", "group:stone", "group:wood", "group:tree", "group:concrete" },
	sound = default.node_sound_stone_defaults()
})

--fake solar panel...or not fake ?
if minetest.get_modpath("spacengine") then
  minetest.register_node("bloc4builder:photovoltaic", {
    description = "Photovoltaic Panel",
    tiles = {"solar.png",
      "shiping.png",
      "solar_side.png"},
    paramtype = "light",
    is_ground_content = false,
    drawtype = "nodebox",
    node_box = {
      type = "fixed",
      fixed = {
        {-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
      },
    },
    groups = {dig_immediate = 3, spacengine=3},
    sounds = default.node_sound_glass_defaults(),
    after_place_node=function(pos,placer)
      spacengine.construct_node(pos,placer,"Solar panel" , "*¨100¨0¨25¨^solar¨^battery¨10¨0¨0¨0",3)
    end,
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
      spacengine.rightclick(pos,node,player,"power",false)
    end,
    can_dig=spacengine.can_dig,
   })
else
  minetest.register_node("bloc4builder:photovoltaic", {
    description = "Photovoltaic Panel",
    tiles = {"solar.png",
      "shiping.png",
      "solar_side.png"},
    paramtype = "light",
    is_ground_content = false,
    drawtype = "nodebox",
    node_box = {
      type = "fixed",
      fixed = {
        {-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
      },
    },
    groups = {dig_immediate = 3},
    sounds = default.node_sound_glass_defaults(),
  })
end
--

minetest.register_node("bloc4builder:glass", {
	description = "Glass Panel",
	tiles = {"building_glass.png"},
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
	groups = {dig_immediate = 3},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("bloc4builder:glass_angle", {
	description = "Glass Panel",
	tiles = {"building_glass.png"},
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
	groups = {dig_immediate = 3},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("bloc4builder:glass_chained", {
	description = "Chainlink smokglass",
	paramtype = "light",
	drawtype = "nodebox",
	tiles = { "smok.png" },
	sunlight_propagates = true,
	groups = { cracky = 2, wall = 1 },
  use_texture_alpha = true,
	node_box = {
		type = "connected",
		fixed = { { -1 / 32, -0.5, -1 / 32, 1 / 32, 0.5, 1 / 32 } },
		connect_front = {{-1/32, -1/2, -1/2, 1/32, 1/2, -1/32}},
			connect_left = {{-1/2, -1/2, -1/32, -1/32, 1/2, 1/32}},
			connect_back = {{-1/32, -1/2, 1/32, 1/32, 1/2, 1/2}},
			connect_right = {{1/32, -1/2, -1/32, 1/2, 1/2, 1/32}},
	},
	connects_to = { "group:wall", "group:stone", "group:wood", "group:concrete","group:pane" },
	sound = default.node_sound_stone_defaults()
})

-- concrete

minetest.register_node('bloc4builder:concrete', {
    description = 'Concrete color',
    tiles = { 'concrete_cpc_32.png' },
    groups = { cracky = 2, ud_param2_colorable = 1, wall=1},
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
    tiles = { 'concrete.png' },
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
	tiles = { "concrete_cpc_32.png" },
	sunlight_propagates = true,
	groups = { cracky = 1, level = 2, wall = 1, ud_param2_colorable = 1 },
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
	connects_to = { "group:wall", "group:stone", "group:wood", "group:tree", "group:concrete","group:pane" },
	sound = default.node_sound_stone_defaults()
})

minetest.register_node("bloc4builder:connect2", {
	description = "Concrete connect2",
	paramtype = "light",
	drawtype = "nodebox",
	tiles = { "concrete_cpc_32.png" },
	sunlight_propagates = true,
	groups = { cracky = 1, level = 2, wall = 1, ud_param2_colorable = 1 },
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
	connects_to = { "group:wall", "group:stone", "group:wood", "group:tree", "group:concrete","group:pane" },
	sound = default.node_sound_stone_defaults()
})

minetest.register_node("bloc4builder:concrete_wall", {
	description = "Concrete Wall bottom",
	paramtype = "light",
	drawtype = "nodebox",
	tiles = {  "concrete_cpc_32.png"  },
	sunlight_propagates = true,
	groups = { cracky = 1, level = 2, wall = 1 , ud_param2_colorable = 1},
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
	connects_to = { "group:wall", "group:stone", "group:wood", "group:tree", "group:concrete","group:pane" },
	sound = default.node_sound_stone_defaults()
})

minetest.register_node("bloc4builder:concrete_wall_top", {
	description = "Concrete Wall top",
	paramtype = "light",
	drawtype = "nodebox",
	tiles = { "concrete_cpc_32.png" },
	sunlight_propagates = true,
	node_box = {
		type = "connected",
		fixed = { -0.15, -0.5, -0.15, 0.15, 0.5, 0.15 },
		connect_front = { -0.15, -0.5, -0.5, 0.15, 0.5, 0.15 }, -- z-
		connect_back = { -0.15, -0.5, -0.15, 0.15, 0.5, 0.5 }, -- z+
		connect_left = { -0.5, -0.5, -0.15, 0.15, 0.5, 0.15 }, -- x-
		connect_right = { -0.15, -0.5, -0.15, 0.5, 0.5, 0.15 }, -- x+
	},
	groups = { cracky = 1, level = 2, wall = 1, ud_param2_colorable = 1 },
	paramtype2 = "color",
   palette = "unifieddyes_palette_extended.png",
   place_param2 = 240,
   on_construct = unifieddyes.on_construct,
   after_place_node = unifieddyes.recolor_on_place,
   after_dig_node = unifieddyes.after_dig_node,
	connects_to = { "group:wall", "group:stone", "group:wood", "group:tree", "group:concrete","group:pane" },
	sound = default.node_sound_stone_defaults()
})

minetest.register_node("bloc4builder:connect_short", {
	description = "Concrete connect short",
	paramtype = "light",
	drawtype = "nodebox",
	tiles = { "concrete_cpc_32.png" },
	sunlight_propagates = true,
	groups = { cracky = 1, level = 2, wall = 1, ud_param2_colorable = 1 },
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
	connects_to = { "group:wall", "group:stone", "group:wood", "group:tree", "group:concrete","group:pane" },
	sound = default.node_sound_stone_defaults()
})

minetest.register_node("bloc4builder:connect2_short", {
	description = "Concrete connect2 short",
	paramtype = "light",
	drawtype = "nodebox",
	tiles = { "concrete_cpc_32.png" },
	sunlight_propagates = true,
	groups = { cracky = 1, level = 2, wall = 1, ud_param2_colorable = 1 },
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
	connects_to = { "group:wall", "group:stone", "group:wood", "group:tree", "group:concrete","group:pane" },
	sound = default.node_sound_stone_defaults()
})

minetest.register_node("bloc4builder:connect_x", {
	description = "Concrete connect x",
	paramtype = "light",
	drawtype = "nodebox",
	tiles = { "concrete_cpc_32.png" },
	sunlight_propagates = true,
	groups = { cracky = 1, level = 2, wall = 1, ud_param2_colorable = 1 },
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
	connects_to = { "group:wall", "group:stone", "group:wood", "group:tree", "group:concrete","group:pane" },
	sound = default.node_sound_stone_defaults()
})

minetest.register_node("bloc4builder:street_lamp", {
	description = "street pole lamp",
	paramtype = "light",
	drawtype = "nodebox",
	tiles = { "concrete_cpc_32.png" },
	sunlight_propagates = true,
	node_box = {
		type = "connected",
		fixed = { -0.1, -0.5, -0.1, 0.1, 0.5, 0.1 },
		connect_front = {{ -0.05, 0.3, -0.5, 0.05, 0.4, -0.1 },{ -0.05, 0.2, -0.5, 0.05, 0.3, -0.4 },{ -0.05, 0.1, -0.4, 0.05, 0.2, -0.3 },{ -0.05, 0, -0.3, 0.05, 0.1, -0.2 },{ -0.05, -0.2, -0.2, 0.05, 0, -0.1 }}, -- z-
		connect_back = {{ -0.05, 0.3, 0.1, 0.05, 0.4, 0.5 },{ -0.05, 0.2, 0.4, 0.05, 0.3, 0.5 },{ -0.05, 0.1, 0.3, 0.05, 0.2, 0.4 },{ -0.05, 0, 0.2, 0.05, 0.1, 0.3 },{ -0.05, -0.2, 0.1, 0.05, 0, 0.2 }}, -- z+
		connect_left = {{ -0.5, 0.3, -0.05, -0.1, 0.4, 0.05 },{ -0.5, 0.2, -0.05, -0.4, 0.3, 0.05 },{ -0.4, 0.1, -0.05, -0.3, 0.2, 0.05 },{ -0.3, 0, -0.05, -0.2, 0.1, 0.05 },{ -0.2, -0.2, -0.05, -0.1, 0, 0.05 }}, -- x-
		connect_right = {{ 0.1, 0.3, -0.05, 0.5, 0.4, 0.05 },{ 0.4, 0.2, -0.05, 0.5, 0.3, 0.05 },{ 0.3, 0.1, -0.05, 0.4, 0.2, 0.05 },{ 0.2, 0, -0.05, 0.3, 0.1, 0.05 },{ 0.1, -0.2, -0.05, 0.2, 0, 0.05 }} -- x+
	},
	groups = { cracky = 1, level = 2, wall = 1, ud_param2_colorable = 1 },
	paramtype2 = "color",
   palette = "unifieddyes_palette_extended.png",
   place_param2 = 240,
   on_construct = unifieddyes.on_construct,
   after_place_node = unifieddyes.recolor_on_place,
   after_dig_node = unifieddyes.after_dig_node,
	connects_to = { "group:wall", "group:concrete" },
	sound = default.node_sound_stone_defaults()
})

--mur invisible

minetest.register_node("bloc4builder:event_off", {
	description = "invisible wall",
	drawtype = "glasslike",
	tiles = {"bloc4builder_air.png"},
	paramtype = "light",
    use_texture_alpha = true,
	is_ground_content = false,
    groups = {cracky=3},
	sunlight_propagates = true,
	walkable = true,
	floodable = false,
})

--bloc decor

minetest.register_node("bloc4builder:containerb4b", {
	description = "container",
	tiles ={"containerb4b.png"},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:pierre_02", {
	description = "pierre 02",
	tiles ={"dalle.png"},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:pavement01", {
	description = "pavement 01",
	tiles ={"pavement01.png"},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:pavement02", {
	description = "pavement 02",
	tiles ={"pavement02.png"},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:pavement03", {
	description = "pavement 03",
	tiles ={"pavement03.png"},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:mur_station1", {
	description = "mur station",
	tiles ={"mur_station.png", "mur_station_inv.png", "mur_station_neutre.png", "mur_station_neutre.png",  "mur_station_neutre.png", "mur_station_neutre.png"},
	groups = {cracky=3},
  paramtype2 = "facedir",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:mur_station2", {
	description = "mur station",
	tiles ={"mur_station_neutre.png", "mur_station_neutre.png", "mur_station_bar.png", "mur_station_bar.png", "mur_station_bar.png", "mur_station_bar.png"},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:pierre_doree", {
	description = "pierre doree",
	tiles ={"pierre_dore.png"},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:metal_floor", {
	description = "metal floor",
	tiles ={"grille2.png","grille2.png","tanker2.png","tanker2.png","tanker2.png","tanker2.png"},
	groups = {cracky=3},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("bloc4builder:tole_a", {
	description = "tole a",
	tiles ={"tole_a.png"},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:tanker", {
	description = "tanker",
	tiles ={"tanker1.png"},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:mur_02", {
	description = "mur 02",
	tiles ={"mur02.png"},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:beton", {
	description = "beton",
	tiles ={"beton.png"},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:granit", {
	description = "granit",
	tiles ={"granit.png"},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:granit_broken", {
	description = "granit_broken",
	tiles ={"granit_broken.png"},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:marble", {
	description = "marble",
	tiles ={"marble.png"},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:tole_b", {
	description = "tole_b",
	tiles ={"tole_b.png"},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:tole_c", {
	description = "tole_c",
	tiles ={"tole_c.png"},
	groups = {cracky=3},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("bloc4builder:panneaux", {
	description = "panneaux",
	tiles ={"plaque.png","plaque.png","vitre.png","porte_maintenance2.png","rack3.png",{
			image = "rack_anim.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 1.5
			},},},
	groups = {cracky=3},
paramtype2 = "facedir",
light_source = 3,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bloc4builder:climatiser", {
	description = "climatiser",
	tiles ={"shiping.png","shiping.png","pmid.png","pmid.png","pmid.png","pmid.png"},
  paramtype2 = "facedir",
	groups = {cracky=3},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("bloc4builder:motif", {
	description = "motif",
	tiles ={"motif03.png","motif03.png","motif01.png","motif01.png","motif02.png","motif02.png"},
  paramtype2 = "facedir",
	groups = {cracky=3},
	sounds = default.node_sound_metal_defaults(),
})

local mesewire_rules =
    {
    {x = 1, y = 0, z = 0},
    {x =-1, y = 0, z = 0},
    {x = 0, y = 1, z = 0},
    {x = 0, y =-1, z = 0},
    {x = 0, y = 0, z = 1},
    {x = 0, y = 0, z =-1},
    }

local def_on={}
def_on.description = "girophare"
def_on.tiles ={"shiping.png","shiping.png",
{image = "girophare_a_on.png",backface_culling = false,animation = {type = "vertical_frames",aspect_w = 32,aspect_h = 32, length = 0.5},},
{image = "girophare_a_on.png",backface_culling = false,animation = {type = "vertical_frames",aspect_w = 32,aspect_h = 32, length = 0.5},},
{image = "girophare_b_on.png",backface_culling = false,animation = {type = "vertical_frames",aspect_w = 32,aspect_h = 32, length = 0.5},},
{image = "girophare_b_on.png",backface_culling = false,animation = {type = "vertical_frames",aspect_w = 32,aspect_h = 32, length = 0.5},},
}
def_on.drawtype = "nodebox"
def_on.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.49, -0.5, 0.5, 0.49, 0.5},
		}
	}
def_on.use_texture_alpha = true
def_on.light_source = 10

def_on.sounds = default.node_sound_stone_defaults()


local def_off={}
def_off.description = "girophare"
def_off.tiles ={"shiping.png","shiping.png","girophare_off.png"}
def_off.drawtype = "nodebox"
def_off.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.49, -0.5, 0.5, 0.49, 0.5},
		}
	}
def_off.use_texture_alpha = true
def_off.sounds = default.node_sound_stone_defaults()

--compatible mesecon

if minetest.get_modpath("mesecons") then

def_on.groups = {cracky=3, switch=53, not_in_creative_inventory=1,mesecon_effector_on = 1}
def_on.mesecons = {effector = {
		action_off = function (pos, node)
			minetest.swap_node(pos, {name = "bloc4builder:girophare"})
		end,
		rules = mesewire_rules,
	}}
def_on.on_blast = mesecon.on_blastnode  

def_off.groups = {cracky=3, switch=3, mesecon_receptor_off = 1, mesecon_effector_off = 1,not_in_creative_inventory=1}
def_off.mesecons = {effector = {
		action_on = function (pos, node)
			minetest.swap_node(pos, {name = "bloc4builder:girophare_on"})
		end,
		rules = mesewire_rules,
	}}
def_off.on_blast = mesecon.on_blastnode

  minetest.register_node("bloc4builder:electro", {
    description = "circuit electro",
    drawtype = "nodebox",
    tiles ={"cable_angle1.png", "cable_angle1.png^[transformR90", "cable_bord1.png", "cable_bord1.png", "cable_droit1.png", "cable_middle1.png"},
    paramtype2 = "facedir",
    groups = {cracky=3},
    sounds = default.node_sound_metal_defaults(),
    mesecons = {conductor = {
                    state = "off",
                    onstate = "bloc4builder:electro_on",
                    rules = mesewire_rules
            }},
  })

minetest.register_node("bloc4builder:electro_on", {
    description = "circuit electro",
    drawtype = "nodebox",
    tiles ={"cable_angle1.png", "cable_angle1.png^[transformR90", "cable_bord1.png", "cable_bord1.png", "cable_droit1.png", "cable_middle1.png"},
    paramtype2 = "facedir",
    groups = {cracky=3,not_in_creative_inventory=1},
    sounds = default.node_sound_metal_defaults(),
    mesecons = {conductor = {
                state = "on",
                offstate = "bloc4builder:electro",
                rules = mesewire_rules
            }},
    })

  minetest.register_node("bloc4builder:electro2", {
    description = "circuit electro2",
    drawtype = "nodebox",
    tiles ={"porte_maintenance3.png", "porte_maintenance.png", "cable_droit1.png^[transformR90", "cable_droit1.png^[transformR90", "cable_coffret1.png", "cable_coffret1.png"},
    paramtype2 = "facedir",
    groups = {cracky=3},
    sounds = default.node_sound_metal_defaults(),
    mesecons = {conductor = {
                    state = "off",
                    onstate = "bloc4builder:electro2_on",
                    rules = mesewire_rules
            }},
  })

  minetest.register_node("bloc4builder:electro2_on", {
    description = "circuit electro2",
    drawtype = "nodebox",
    tiles ={"porte_maintenance3.png", "porte_maintenance.png", "cable_droit1.png^[transformR90", "cable_droit1.png^[transformR90", "cable_coffret1.png", "cable_coffret1.png"},
    paramtype2 = "facedir",
    groups = {cracky=3,not_in_creative_inventory=1},
    sounds = default.node_sound_metal_defaults(),
    mesecons = {conductor = {
                state = "on",
                offstate = "bloc4builder:electro2",
                rules = mesewire_rules
            }},
    })

else
def_on.groups = {cracky=3,switch=53, not_in_creative_inventory=1}
def_off.groups = {cracky=3,switch=3, not_in_creative_inventory=1}

  minetest.register_node("bloc4builder:electro", {
    description = "circuit electro",
    tiles ={"cable_angle1.png", "cable_angle1.png^[transformR90", "cable_bord1.png", "cable_bord1.png", "cable_droit1.png", "cable_middle1.png"},
    paramtype2 = "facedir",
    groups = {cracky=3},
    sounds = default.node_sound_metal_defaults(),
  })

  minetest.register_node("bloc4builder:electro2", {
    description = "circuit electro2",
    tiles ={"porte_maintenance3.png", "porte_maintenance.png", "cable_droit1.png^[transformR90", "cable_droit1.png^[transformR90", "cable_coffret1.png", "cable_coffret1.png"},
    paramtype2 = "facedir",
    groups = {cracky=3},
    sounds = default.node_sound_metal_defaults(),
  })
end

minetest.register_node("bloc4builder:girophare_on", def_on)
minetest.register_node("bloc4builder:girophare", def_off)

minetest.register_node("bloc4builder:astroport_light", {
	description = "Astroport light",
    drawtype = "nodebox",
    tiles = {"astroport_light_2.png","astroport_light_2.png",{image = "astroport_light_1.png",backface_culling = false,animation = {type = "vertical_frames",aspect_w = 16,aspect_h = 16, length = 1.75},},
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
	groups = {cracky=2},
	sounds = default.node_sound_metal_defaults(),
})

--moreblocks
local mb_mod=minetest.get_modpath("moreblocks")

--BLOCPLUS  
  local bloc = {"floor", "grille", "road_neutre","concrete_dir", "poutre", "tole_b", "tole_c", "tole_a", "tanker", "marble", "granit", "beton", "mur_station2", "panneaux", "climatiser", "black", "purple", "green", "red", "yellow", "blue", "orange" , "white" , "army" , "containerb4b", "pierre_02", "pierre_doree", "pavement02", "mur_02"}

  for _, subname in pairs(bloc) do
    local modname = "bloc4builder"
    local nodename = modname .. ":" .. subname
    local fields = table.copy(minetest.registered_nodes[nodename])

    if #fields.tiles > 1 and fields.drawtype and fields.drawtype:find("glass") then
      fields.tiles = {fields.tiles[1]}
      fields.paramtype2 = nil
    end

    bloc4builder.register_b4b(modname, subname, fields, nodename)
    bloc4builder.register_moreblocks(modname, subname, fields, nodename)
  end

--SCIFI
if minetest.get_modpath("scifi_nodes") then
  local scifi = {
"glass",
"super_white",
"ultra_white",
"blue",
"holes",
"white2",
"engine",
"wall",
"white",
"stripes2top",
"rough",
"lighttop",
"red",
"green",
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
"black_detail",
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
"greentubes",
"grey",
"greybolts",
"greybars",
"greydots",
"greygreenbar",
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
"screen3",
"doomlight",
"bluwllight",
"bluegrid",
"fan",
"ppllght",
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

  for _, subname in pairs(scifi) do
    local modname = "scifi_nodes"
    local nodename = modname .. ":" .. subname
    local fields = table.copy(minetest.registered_nodes[nodename])

    if #fields.tiles > 1 and fields.drawtype and fields.drawtype:find("glass") then
      fields.tiles = {fields.tiles[1]}
      fields.paramtype2 = nil
    end

    bloc4builder.register_b4b(modname, subname, fields, nodename)

    if not mb_mod then
      bloc4builder.register_moreblocks(modname, subname, fields, nodename)
    end
  end

end

if minetest.get_modpath("abriglass") then
  local blocglass = {"clear_glass", "stained_glass_black", "stained_glass_cyan", "stained_glass_magenta", "stained_glass_orange", "stained_glass_yellow", "stained_glass_purple", "glass_light_green", "glass_light_blue", "glass_light_red"}

  for _, subname in pairs(blocglass) do
    local modname = "abriglass"
    local nodename = modname .. ":" .. subname
    local fields = table.copy(minetest.registered_nodes[nodename])

    if #fields.tiles > 1 and fields.drawtype and fields.drawtype:find("glass") then
      fields.tiles = {fields.tiles[1]}
      fields.paramtype2 = nil
    end

    bloc4builder.register_b4b(modname, subname, fields, nodename)

    if not mb_mod then
      bloc4builder.register_moreblocks(modname, subname, fields, nodename)
    end
  end

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
	"meselamp",
	"glass",
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
	"obsidian",
	"obsidian_block",
	"obsidianbrick",
	"obsidian_glass",
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

    bloc4builder.register_b4b("moreblocks", subname, fields, nodename)
if not mb_mod then
    bloc4builder.register_moreblocks("moreblocks", subname, fields, nodename)
    minetest.register_alias_force("stairs:stair_" .. subname, "moreblocks:stair_" .. subname)
    minetest.register_alias_force("stairs:stair_outer_" .. subname, "moreblocks:stair_" .. subname .. "_outer")
    minetest.register_alias_force("stairs:stair_inner_" .. subname, "moreblocks:stair_" .. subname .. "_inner")
    minetest.register_alias_force("stairs:slab_"  .. subname, "moreblocks:slab_"  .. subname)
  end
end
