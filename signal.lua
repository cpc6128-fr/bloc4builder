
--*******************
--**signal bicolor **
--*******************
minetest.register_node("bloc4builder:rail_signal", {
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
  groups = { cracky = 1,switch=111},
  on_construct=function(pos)
    bloc4builder.init_formspec(pos)
  end,
  on_receive_fields = function(pos,formname,fields,sender)
    bloc4builder.change_formspec(pos,fields,sender)
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
  groups = { cracky = 1, switch=111},
  on_receive_fields = function(pos,formname,fields,sender)
    bloc4builder.change_formspec(pos,fields,sender)
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
  groups = { cracky = 1,switch=1},
  on_construct=function(pos)
    bloc4builder.init_formspec(pos)
  end,
  on_receive_fields = function(pos,formname,fields,sender)
    bloc4builder.change_formspec(pos,fields,sender)
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
  groups = { cracky = 1, switch=1},
  light_source = 10,
  on_construct=function(pos)
    bloc4builder.init_formspec(pos)
  end,
  on_receive_fields = function(pos,formname,fields,sender)
    bloc4builder.change_formspec(pos,fields,sender)
  end,
  on_punch = function (pos, node)
    tricolor_swap(pos, node)
  end,
  on_switch= function(pos,node)
    tricolor_swap(pos, node)
  end
})

minetest.register_node("bloc4builder:tricolor_2", {
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
  groups = { cracky = 1, switch=1},
  light_source = 10,
  on_receive_fields = function(pos,formname,fields,sender)
    bloc4builder.change_formspec(pos,fields,sender)
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
  groups = { cracky = 1, switch=1},
  light_source = 10,
  on_receive_fields = function(pos,formname,fields,sender)
    bloc4builder.change_formspec(pos,fields,sender)
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
  groups = { cracky = 1, switch=1},
  light_source = 10,
  on_receive_fields = function(pos,formname,fields,sender)
    bloc4builder.change_formspec(pos,fields,sender)
  end,
  on_punch = function (pos, node)
    tricolor_swap(pos, node)
  end,
  on_switch= function(pos,node)
    tricolor_swap(pos, node)
  end,
  drop="bloc4builder:tricolor_1"
})
