local init_formspec=function(pos)
  local meta = minetest.get_meta(pos)
  meta:set_string("channel","No channel")
  meta:set_string("formspec","size[8, 4]button_exit[2,3;2,1;submit;submit]field[1,1;3,1;channel;channel;No channel]")
end

local change_formspec=function(pos,fields,sender)
  local name=sender:get_player_name()
  local meta = minetest.get_meta(pos)

  if fields.channel==nil then fields.channel="No channel" end

  if fields.submit then
    meta:set_string("channel",fields.channel)
    meta:set_string("formspec","size[8, 4]button_exit[2,3;2,1;submit;submit]field[1,1;3,1;channel;channel;".. fields.channel .."]")
  end
end


--*******************
--**signal bicolor **
--*******************
minetest.register_node("bloc4builder:rail_signal", {
  groups = { cracky = 1,switch=1111},
	tiles = {
		"b4b_signal_side.png",
		"b4b_signal_side.png",
		"b4b_signal_side.png",
		"b4b_signal_side.png",
		"b4b_signal_side.png",
		"b4b_signal_green.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
  paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
      {-0.3125, -0.4375, -0.125, 0.3125, 0.4375, 0.125},
			{-0.25, -0.5, -0.125, 0.25, -0.4375, 0.125},
			{-0.25, 0.4375, -0.125, 0.25, 0.5, 0.125},
		}
	},
  on_construct=function(pos)
    init_formspec(pos)
  end,
  on_receive_fields = function(pos,formname,fields,sender)
    change_formspec(pos,fields,sender)
  end,
  on_punch = function(pos, node)
    minetest.swap_node(pos, {name="bloc4builder:rail_signal_on",param2=node.param2})
  end,
  mesecons = {effector = {
    action_on = function(pos, node)
      minetest.swap_node(pos, {name="bloc4builder:rail_signal_on",param2=node.param2})
    end,
  }},
  on_switch = function(pos, node)
    minetest.swap_node(pos, {name="bloc4builder:rail_signal_on",param2=node.param2})
  end,
  light_source = 6
})

minetest.register_node("bloc4builder:rail_signal_on", {
  groups = { cracky = 1, switch=1111},
	tiles = {
		"b4b_signal_side.png",
		"b4b_signal_side.png",
		"b4b_signal_side.png",
		"b4b_signal_side.png",
		"b4b_signal_side.png",
		"b4b_signal_red.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
  paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.4375, -0.125, 0.3125, 0.4375, 0.125}, -- NodeBox1
			{-0.25, -0.5, -0.125, 0.25, -0.4375, 0.125}, -- NodeBox2
			{-0.25, 0.4375, -0.125, 0.25, 0.5, 0.125}, -- NodeBox3
		}
	},
  on_receive_fields = function(pos,formname,fields,sender)
    change_formspec(pos,fields,sender)
  end,
  on_punch = function(pos, node)
    minetest.swap_node(pos, {name="bloc4builder:rail_signal",param2=node.param2})
  end,
  mesecons = {effector = {
    action_on = function(pos, node)
      minetest.swap_node(pos, {name="bloc4builder:rail_signal",param2=node.param2})
    end,
  }},
  on_switch = function(pos, node)
    minetest.swap_node(pos, {name="bloc4builder:rail_signal",param2=node.param2})
  end,
  light_source = 6,
  drop="bloc4builder:rail_signal"
})

--********************
--**signal direction**
--********************
minetest.register_node("bloc4builder:rail_signal_flag", {
  groups = { cracky = 1,switch=1001},
	tiles = {
		"b4b_signal_bottom.png",
		"b4b_signal_bottom.png",
		"b4b_signal_bottom.png",
		"b4b_signal_bottom.png",
		"b4b_signal_right.png",
		"b4b_signal_left.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
  paramtype2 = "facedir",
  sunlight_propagates = true,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, 0.5, 0.5, 0.0625},
		}
	},
  on_construct=function(pos)
    init_formspec(pos)
  end,
  on_receive_fields = function(pos,formname,fields,sender)
    change_formspec(pos,fields,sender)
  end,
  on_punch = function(pos, node)
    local dir=node.param2+2
    if dir>3 then dir=dir-4 end
    minetest.swap_node(pos, {name="bloc4builder:rail_signal_flag",param2=dir})
  end,
  mesecons = {effector = {
    action_on = function(pos, node)
    local dir=node.param2+2
    if dir>3 then dir=dir-4 end
    minetest.swap_node(pos, {name="bloc4builder:rail_signal_flag",param2=dir})
    end,
  }},
  on_switch = function(pos, node)
    local dir=node.param2+2
    if dir>3 then dir=dir-4 end
    minetest.swap_node(pos, {name="bloc4builder:rail_signal_flag",param2=dir})
  end,
})

--*****************
--**feux tricolor**
--*****************
local function tricolor_swap(pos, node)
  if node.name == "bloc4builder:tricolor_1" then
    minetest.swap_node(pos, {name = "bloc4builder:tricolor_2", param2 = node.param2})
  elseif node.name == "bloc4builder:tricolor_2" then
    minetest.swap_node(pos, {name = "bloc4builder:tricolor_3", param2 = node.param2})
  elseif node.name == "bloc4builder:tricolor_3" then
    minetest.swap_node(pos, {name = "bloc4builder:tricolor_4", param2 = node.param2})
  elseif node.name == "bloc4builder:tricolor_4" then
    minetest.swap_node(pos, {name = "bloc4builder:tricolor_1", param2 = node.param2})
  end
end

minetest.register_node("bloc4builder:tricolor_1", {
  groups = { cracky = 1, switch=1001},
	tiles = {
		"b4b_tricolor_side.png",
		"b4b_tricolor_side.png",
		"b4b_tricolor_side.png",
		"b4b_tricolor_side.png",
		"b4b_tricolor_side.png",
		"b4b_tricolor_1.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
  paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.375, -0.1875, 0.25, 0.375, 0.1875}, -- NodeBox1
			{-0.1875, 0.375, -0.1875, 0.1875, 0.4375, 0.1875}, -- NodeBox2
			{-0.1875, -0.4375, -0.1875, 0.1875, -0.375, 0.1875}, -- NodeBox3
			{-0.125, 0.4375, -0.1875, 0.125, 0.5, 0.1875}, -- NodeBox4
			{-0.125, -0.5, -0.1875, 0.125, -0.4375, 0.1875}, -- NodeBox5
		},
	},
  light_source = 10,
  on_construct=function(pos)
    init_formspec(pos)
  end,
  on_receive_fields = function(pos,formname,fields,sender)
    change_formspec(pos,fields,sender)
  end,
  on_punch = function (pos, node)
    tricolor_swap(pos, node)
  end,
  on_switch= function(pos,node)
    tricolor_swap(pos, node)
  end
})

minetest.register_node("bloc4builder:tricolor_2", {
  groups = { cracky = 1, switch=1001},
	tiles = {
		"b4b_tricolor_side.png",
		"b4b_tricolor_side.png",
		"b4b_tricolor_side.png",
		"b4b_tricolor_side.png",
		"b4b_tricolor_side.png",
		"b4b_tricolor_2.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
  paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.375, -0.1875, 0.25, 0.375, 0.1875}, -- NodeBox1
			{-0.1875, 0.375, -0.1875, 0.1875, 0.4375, 0.1875}, -- NodeBox2
			{-0.1875, -0.4375, -0.1875, 0.1875, -0.375, 0.1875}, -- NodeBox3
			{-0.125, 0.4375, -0.1875, 0.125, 0.5, 0.1875}, -- NodeBox4
			{-0.125, -0.5, -0.1875, 0.125, -0.4375, 0.1875}, -- NodeBox5
		},
	},
  light_source = 10,
  on_receive_fields = function(pos,formname,fields,sender)
    change_formspec(pos,fields,sender)
  end,
  on_punch = function (pos, node)
    tricolor_swap(pos, node)
  end,
  on_switch= function(pos,node)
    tricolor_swap(pos, node)
  end,
  drop="bloc4builder:tricolor_1"
})

minetest.register_node("bloc4builder:tricolor_3", {
  groups = { cracky = 1, switch=1001},
	tiles = {
		"b4b_tricolor_side.png",
		"b4b_tricolor_side.png",
		"b4b_tricolor_side.png",
		"b4b_tricolor_side.png",
		"b4b_tricolor_side.png",
		"b4b_tricolor_3.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
  paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.375, -0.1875, 0.25, 0.375, 0.1875}, -- NodeBox1
			{-0.1875, 0.375, -0.1875, 0.1875, 0.4375, 0.1875}, -- NodeBox2
			{-0.1875, -0.4375, -0.1875, 0.1875, -0.375, 0.1875}, -- NodeBox3
			{-0.125, 0.4375, -0.1875, 0.125, 0.5, 0.1875}, -- NodeBox4
			{-0.125, -0.5, -0.1875, 0.125, -0.4375, 0.1875}, -- NodeBox5
		},
	},
  light_source = 10,
  on_receive_fields = function(pos,formname,fields,sender)
    change_formspec(pos,fields,sender)
  end,
  on_punch = function (pos, node)
    tricolor_swap(pos, node)
  end,
  on_switch= function(pos,node)
    tricolor_swap(pos, node)
  end,
  drop="bloc4builder:tricolor_1"
})

minetest.register_node("bloc4builder:tricolor_4", {
  groups = { cracky = 1, switch=1001},
	tiles = {
		"b4b_tricolor_side.png",
		"b4b_tricolor_side.png",
		"b4b_tricolor_side.png",
		"b4b_tricolor_side.png",
		"b4b_tricolor_side.png",
		"b4b_tricolor_4.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
  paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.375, -0.1875, 0.25, 0.375, 0.1875}, -- NodeBox1
			{-0.1875, 0.375, -0.1875, 0.1875, 0.4375, 0.1875}, -- NodeBox2
			{-0.1875, -0.4375, -0.1875, 0.1875, -0.375, 0.1875}, -- NodeBox3
			{-0.125, 0.4375, -0.1875, 0.125, 0.5, 0.1875}, -- NodeBox4
			{-0.125, -0.5, -0.1875, 0.125, -0.4375, 0.1875}, -- NodeBox5
		},
	},
  light_source = 10,
  on_receive_fields = function(pos,formname,fields,sender)
    change_formspec(pos,fields,sender)
  end,
  on_punch = function (pos, node)
    tricolor_swap(pos, node)
  end,
  on_switch= function(pos,node)
    tricolor_swap(pos, node)
  end,
  drop="bloc4builder:tricolor_1"
})

--***************
--** GIROPHARE **
--***************
local mesewire_rules =
    {
    {x = 1, y = 0, z = 0},
    {x =-1, y = 0, z = 0},
    {x = 0, y = 1, z = 0},
    {x = 0, y =-1, z = 0},
    {x = 0, y = 0, z = 1},
    {x = 0, y = 0, z =-1},
    }

--commun on
local def_on={
description = "girophare",
tiles ={"b4b_shiping.png","b4b_shiping.png",
{image = "b4b_girophare_a_on.png",backface_culling = false,animation = {type = "vertical_frames",aspect_w = 32,aspect_h = 32, length = 0.5},},
{image = "b4b_girophare_a_on.png",backface_culling = false,animation = {type = "vertical_frames",aspect_w = 32,aspect_h = 32, length = 0.5},},
{image = "b4b_girophare_b_on.png",backface_culling = false,animation = {type = "vertical_frames",aspect_w = 32,aspect_h = 32, length = 0.5},},
{image = "b4b_girophare_b_on.png",backface_culling = false,animation = {type = "vertical_frames",aspect_w = 32,aspect_h = 32, length = 0.5},},
},
drawtype = "nodebox",
node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.49, -0.5, 0.5, 0.49, 0.5},
		}
	},
use_texture_alpha = true,
light_source = 10,
on_switch=function(pos,node)
  minetest.swap_node(pos, {name = "bloc4builder:girophare"})
  bloc4builder.stop_sound(pos)
end,
on_receive_fields = function(pos,formname,fields,sender)
  bloc4builder.change_formspec(pos,fields,sender)
end,
on_destruct=function(pos)
  minetest.swap_node(pos, {name = "bloc4builder:girophare"})
  bloc4builder.stop_sound(pos)
end,
sounds = default.node_sound_stone_defaults()
}

--commun off
local def_off={
description = "girophare",
tiles ={"b4b_shiping.png","b4b_shiping.png","b4b_girophare_off.png"},
drawtype = "nodebox",
node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.49, -0.5, 0.5, 0.49, 0.5},
		}
	},
use_texture_alpha = true,
on_construct=function(pos)
  local nod_met = minetest.get_meta(pos)
	nod_met:set_int("sound",-1)
  nod_met:set_string("sound_name","alarm2")
  init_formspec(pos)
end,
on_receive_fields = function(pos,formname,fields,sender)
  change_formspec(pos,fields,sender)
end,
on_switch=function(pos,node)
  minetest.swap_node(pos, {name = "bloc4builder:girophare_on"})
  bloc4builder.start_sound(pos,"alarm2")
end,
sounds = default.node_sound_stone_defaults()
}
--compatible mesecon

if minetest.get_modpath("mesecons") then
  --mesecon on
  def_on.groups = {cracky=3, switch=1011, not_in_creative_inventory=1,mesecon_effector_on = 1}
  def_on.mesecons = {effector = {
		action_off = function (pos, node)
			minetest.swap_node(pos, {name = "bloc4builder:girophare"})
      bloc4builder.stop_sound(pos)
		end,
		rules = mesewire_rules,
	}}
  --mesecon off
  def_on.on_blast = mesecon.on_blastnode  
  def_off.groups = {cracky=3, switch=1011, mesecon_receptor_off = 1, mesecon_effector_off = 1, not_in_creative_inventory=bloc4builder.creative_enable}
  def_off.mesecons = {effector = {
		action_on = function (pos, node)
			minetest.swap_node(pos, {name = "bloc4builder:girophare_on"})
      bloc4builder.start_sound(pos,"alarm2")
		end,
		rules = mesewire_rules,
	}}
  def_off.on_blast = mesecon.on_blastnode

  minetest.register_node("bloc4builder:electro", {
    description = "circuit electro",
    drawtype = "nodebox",
    tiles ={"b4b_cable_angle1.png", "b4b_cable_angle1.png^[transformR90", "b4b_cable_bord1.png", "b4b_cable_bord1.png", "b4b_cable_droit1.png", "b4b_cable_middle1.png"},
    paramtype2 = "facedir",
    groups = {cracky=3, wall = 1, flammable=2,not_in_creative_inventory=bloc4builder.creative_enable},
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
    tiles ={"b4b_cable_angle1.png", "b4b_cable_angle1.png^[transformR90", "b4b_cable_bord1.png", "b4b_cable_bord1.png", "b4b_cable_droit1.png", "b4b_cable_middle1.png"},
    paramtype2 = "facedir",
    groups = {cracky=3, wall = 1, flammable=2, not_in_creative_inventory=1},
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
    tiles ={"b4b_porte_maintenance3.png", "b4b_porte_maintenance.png", "b4b_cable_droit1.png^[transformR90", "b4b_cable_droit1.png^[transformR90", "b4b_cable_coffret1.png", "b4b_cable_coffret1.png"},
    paramtype2 = "facedir",
    groups = {cracky=3, wall = 1, flammable=2,not_in_creative_inventory=bloc4builder.creative_enable},
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
    tiles ={"b4b_porte_maintenance3.png", "b4b_porte_maintenance.png", "b4b_cable_droit1.png^[transformR90", "b4b_cable_droit1.png^[transformR90", "b4b_cable_coffret1.png", "b4b_cable_coffret1.png"},
    paramtype2 = "facedir",
    groups = {cracky=3, wall = 1, flammable=2, not_in_creative_inventory=1},
    sounds = default.node_sound_metal_defaults(),
    mesecons = {conductor = {
                state = "on",
                offstate = "bloc4builder:electro2",
                rules = mesewire_rules
              }},
    })

  minetest.register_node("bloc4builder:switch2mesecons_off", {
    groups = {cracky=1,oddly_breakable_by_hand=1, switch=1001 },
    description = "transmit switch to mesecons",
    tiles = {
      "b4b_switch_off.png"
    },
    inventory_image = "b4b_switch_off.png",
    wield_image = "b4b_switch_off.png",
    drawtype = "nodebox",
    node_box = {
      type = "fixed",
      fixed = {
        {-0.5, -0.5, -0.5, 0.5, -0.495, 0.5},
      },
    },
    paramtype = "light",
    paramtype2 = "facedir",
    sounds = default.node_sound_metal_defaults(),
    on_construct=function(pos)
      local nod_met = minetest.get_meta(pos)
      init_formspec(pos)
    end,
    on_receive_fields = function(pos,formname,fields,sender)
      change_formspec(pos,fields,sender)
    end,
    on_switch=function(pos,node)
      if(mesecon.flipstate(pos, node) == "on") then
        mesecon.receptor_on(pos)
      else
        mesecon.receptor_off(pos)
      end
    end,
    sounds = default.node_sound_glass_defaults(),
    on_place = minetest.rotate_node,
    __mesecon_basename = "bloc4builder:switch2mesecons",
    __mesecon_state = "off",
    mesecons = {receptor = { state = mesecon.state.off }}
  })

  minetest.register_node("bloc4builder:switch2mesecons_on", {
    groups = {cracky=1, oddly_breakable_by_hand=1, switch=1001, not_in_creative_inventory=1},
    description = "transmit switch to mesecons",
    tiles = {
      "b4b_switch_on.png"
    },
    inventory_image = "b4b_switch_on.png",
    wield_image = "b4b_switch_on.png",
    drawtype = "nodebox",
    node_box = {
      type = "fixed",
      fixed = {
        {-0.5, -0.5, -0.5, 0.5, -0.495, 0.5},
      },
    },
    paramtype = "light",
    paramtype2 = "facedir",
    sounds = default.node_sound_metal_defaults(),
    drop="bloc4builder:switch2mesecons_off",
    on_construct=function(pos)
      local nod_met = minetest.get_meta(pos)
      init_formspec(pos)
    end,
    on_receive_fields = function(pos,formname,fields,sender)
      change_formspec(pos,fields,sender)
    end,
    on_switch=function(pos,node)
      if(mesecon.flipstate(pos, node) == "on") then
        mesecon.receptor_on(pos)
      else
        mesecon.receptor_off(pos)
      end
    end,
    sounds = default.node_sound_glass_defaults(),
    __mesecon_basename = "bloc4builder:switch2mesecons",
    __mesecon_state = "on",
    mesecons = {receptor = { state = mesecon.state.on }},
    on_blast = mesecon.on_blastnode
  })

  minetest.register_craft({
    output = "bloc4builder:switch2mesecons_off",
    recipe = {
        {"", "default:gold_ingot", ""},
        {"", "bloc4builder:ic", ""},
        {"", "group:mesecon_conductor_craftable", ""}
    }
})

else
  def_on.groups = {cracky=3,switch=1011, not_in_creative_inventory=1}
  def_off.groups = {cracky=3,switch=1011,not_in_creative_inventory=bloc4builder.creative_enable}

  minetest.register_node("bloc4builder:electro", {
    description = "circuit electro",
    tiles ={"b4b_cable_angle1.png", "b4b_cable_angle1.png^[transformR90", "b4b_cable_bord1.png", "b4b_cable_bord1.png", "b4b_cable_droit1.png", "b4b_cable_middle1.png"},
    paramtype2 = "facedir",
    groups = {cracky=3,not_in_creative_inventory=bloc4builder.creative_enable},
    sounds = default.node_sound_metal_defaults(),
  })

  minetest.register_node("bloc4builder:electro2", {
    description = "circuit electro2",
    tiles ={"b4b_porte_maintenance3.png", "b4b_porte_maintenance.png", "b4b_cable_droit1.png^[transformR90", "b4b_cable_droit1.png^[transformR90", "b4b_cable_coffret1.png", "b4b_cable_coffret1.png"},
    paramtype2 = "facedir",
    groups = {cracky=3,not_in_creative_inventory=bloc4builder.creative_enable},
    sounds = default.node_sound_metal_defaults(),
  })
end

minetest.register_node("bloc4builder:girophare_on", def_on)
minetest.register_node("bloc4builder:girophare", def_off)

