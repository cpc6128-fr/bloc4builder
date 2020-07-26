--**************************
--** bloc4builder ver 2   **
--** Romand Philippe 2020 **
--**************************

local postostring=function(pos)
  local position=tostring(math.floor(pos.x)) .."/".. tostring(math.floor(pos.y)) .."/".. tostring(math.floor(pos.z))
  return position
end

--position du magasin extraction
local postonumber=function(position)
  local list=string.split(position,"/")
  local pos={x=tonumber(list[1]),y=tonumber(list[2]),z=tonumber(list[3])}
  return pos
end

--interrupteur de commande pour le group switch
--recherche group switch et modifie le nom
--
-- ON : switch>0 <51 = name_on / OFF : switch>50 <101 = name   see code for example
-- 11=lt / l=lock 0 or 1 / t=type 0:passe partout 1:on/off 2:bp 3:bp or on/off 4:other

bloc4builder.switch_on=function(pos,swap,switch)
    node=minetest.get_node(pos)

  if swap~=nil then
    minetest.swap_node(pos, {name=swap,param2=node.param2})
  end
--find node in area
  local node_pos=minetest.find_nodes_in_area({x=pos.x-2,y=pos.y-2,z=pos.z-2},{x=pos.x+2,y=pos.y+2,z=pos.z+2}, {"group:switch"})
  if node_pos then
for nb_node=1,#node_pos do
    local node_content=minetest.get_node(node_pos[nb_node])
    local nname=node_content.name
    local tmp_group=minetest.get_item_group(nname, "switch")
    local protect,protect_lvl=0,1
    local switch_lock,switch_lvl=0,1
    if switch~=nil then
      if switch>9 then
        switch_lock=1
        switch_lvl=switch-10
      else
        switch_lvl=switch
      end
    end
    if math.floor(tmp_group/10)==1 then
      protect_lvl=tmp_group-10
      protect=1
    else
      protect_lvl=tmp_group
    end
    if switch_lvl==0 and protect_lvl~=3 then protect_lvl=0 end  --passe partout    
    if protect_lvl==3 and switch_lvl<3 then switch_lvl=3 end --bp or on/off
    if  protect_lvl==switch_lvl and switch_lock>=protect then
      if string.find(nname,"_on")==nil then
        nname=nname.."_on"
        minetest.set_node(node_pos[nb_node], {name=nname,param2=node_content.param2})
      end
    end
end
  end       
end
--
bloc4builder.switch_off=function(pos,swap,switch)
  node=minetest.get_node(pos)

  if swap~=nil then
    minetest.swap_node(pos, {name=swap,param2=node.param2})
  end
local node_pos=minetest.find_nodes_in_area({x=pos.x-2,y=pos.y-2,z=pos.z-2},{x=pos.x+2,y=pos.y+2,z=pos.z+2}, {"group:switch"})
  if node_pos then
for nb_node=1,#node_pos do
    local node_content=minetest.get_node(node_pos[nb_node])
    local nname=node_content.name
    local tmp_group=minetest.get_item_group(nname, "switch")
    local protect,protect_lvl=0,1
    local switch_lock,switch_lvl=0,1
    if switch~=nil then
      if switch>9 then
        switch_lock=1
        switch_lvl=switch-10
      else
        switch_lvl=switch
      end
    end
    if math.floor(tmp_group/10)==6 then
      protect_lvl=tmp_group-60
      protect=1
    else
      protect_lvl=tmp_group-50
    end
    if switch_lvl==0 and protect_lvl~=3 then protect_lvl=0 end  --passe partout   
    if protect_lvl==3 and switch_lvl<3 then switch_lvl=3 end --bp or on/off
    if  protect_lvl ==switch_lvl and switch_lock>=protect then
      if string.find(nname,"_on")~=nil then
        nname=string.gsub(nname,"_on","")
        minetest.set_node(node_pos[nb_node], {name=nname,param2=node_content.param2})
      end
    end
end
  end      
end

--** password **

local function password_check(pos,node,player,state,switch)
  local meta = minetest.get_meta(pos)
  local channel=meta:get_string("channel")

  if channel=="" then
    channel="No channel:NoPlayer"
    meta:set_string("channel",channel)
    meta:set_string("code","")
  end

  local position=postostring(pos)
  local name=player:get_player_name()
  local owner=string.split(channel,":")
  local code=meta:get_string("code")

  if name==owner[2] then
    local tool = player:get_wielded_item():get_name()
    if tool == "spacengine:tool" then
      minetest.show_formspec(name, "switch_setup#"..position.."#".. state .."#".. tostring(switch).."#"..name, "size[8, 4]label[0, 0;PASSWORD]field[1,1;5,1;oldcode;oldcode;"..code.."]field[1,2;5,1;newcode;newcode;"..code.."]button_exit[2,3;2,1;submit;submit]field[1,4;3,1;channel;;"..owner[1].."]")
      return
    else
      if string.find(state,"_off")==nil then
        bloc4builder.switch_on(pos,state,switch)
      else
        bloc4builder.switch_off(pos,state,switch)
      end
      return
    end
  else
    if code ~= "" then
      --position interrupteur
      minetest.show_formspec(player:get_player_name(), "switch_unlock#"..position.."#".. state .."#".. tostring(switch), "size[8, 4]" .."label[0, 0;PASSWORD]" .."field[1,1;5,1;code;code;]button_exit[2,3;2,1;unlock;submit]")
      return
    else
      if string.find(state,"_off")==nil then
        bloc4builder.switch_on(pos,state,switch)
      else
        bloc4builder.switch_off(pos,state,switch)
      end
    end
  end


end

minetest.register_on_player_receive_fields(function(player, formname, fields)

  if string.find(formname,"switch_")~=nil then
    local split=string.split(formname,"#")
    local switchpos=postonumber(split[2])
    local meta = minetest.get_meta(switchpos)
    if fields.newcode==nil then fields.newcode="" end
    if fields.oldcode==nil then fields.oldcode="" end

    if string.find(formname, "setup") then
      if fields.submit then
        meta:set_string("channel",fields.channel..":"..split[5])
        if fields.oldcode == meta:get_string("code") then
          meta:set_string("code", fields.newcode)
        else
          minetest.chat_send_player(split[5],"INVALID PASSWORD")
        end
      end
    end

    if string.find(formname, "unlock") then
      if fields.code == meta:get_string("code") then
        if string.find(split[3],"_off")==nil then
          bloc4builder.switch_on(switchpos,split[3],tonumber(split[4]))
        else
          bloc4builder.switch_off(switchpos,split[3],tonumber(split[4]))
        end
      end
    end
  end
end)

--** passerelle d'embarquement **

minetest.register_node("bloc4builder:passerelle", {
	description = "passerelle",
  drawtype = "nodebox",
	tiles ={"passerel.png"},
  node_box = {
		type = "fixed",
    fixed = {
{-0.5,-0.5,-0.5,0.5,-0.4375,0.5},
{-0.5,-0.4375,-0.5,-0.4375,0.5,0.5},
{0.4375,-0.4375,-0.5,0.5,0.5,0.5},
--{-0.5,0.4375,-0.5,0.5,0.5,0.5},
},
		},
  selection_box = {
		type = "fixed",
        fixed = {
{-0.5,-0.5,-0.5,0.5,-0.4375,0.5},
{-0.5,-0.4375,-0.5,-0.4375,0.5,0.5},
{0.4375,-0.4375,-0.5,0.5,0.5,0.5},
--{-0.5,0.4375,-0.5,0.5,0.5,0.5},
},
    },
  paramtype = "light",
  paramtype2 = "facedir",
  use_texture_alpha = true,
	--is_ground_content = false,
	groups = {not_in_creative_inventory=1},
	sounds = default.node_sound_metal_defaults(),
})
--** hub **
minetest.register_node("bloc4builder:hub", {
	description = "hub embarquement",
  drawtype = "nodebox",
	tiles ={"hub.png","asphalt.png","hub_side.png"},
  paramtype = "light",
  paramtype2 = "facedir",
	is_ground_content = false,
  on_construct=function(pos)
    local node=minetest.get_node(pos)
    local dir=node.param2
    local cpt=1
    local x,z=0,0
    local pos1={x=pos.x,y=pos.y+1,z=pos.z}
    repeat
    if dir==0 then pos1.z=pos1.z+1 end
    if dir==1 then pos1.x=pos1.x+1 end
    if dir==2 then pos1.z=pos1.z-1 end
    if dir==3 then pos1.x=pos1.x-1 end
    local test=minetest.get_node(pos1)
    if test.name=="bloc4builder:passerelle" then
      local pos_air=minetest.find_node_near(pos, 1, {"air";"vacuum:vacuum"})
      local node_air="air"
      if pos_air then
        local tmp=minetest.get_node(pos_air)
        node_air=tmp.name
      end
      minetest.set_node(pos1, {name=node_air})
      minetest.set_node({x=pos1.x,y=pos1.y+1,z=pos1.z}, {name=node_air})
    else
      cpt=10
    end
    cpt=cpt+1
    until cpt>10
  end,
	groups = {cracky=3,switch=1},
	sounds = default.node_sound_metal_defaults(),
})
--
minetest.register_node("bloc4builder:hub_on", {
	description = "hub embarquement",
  drawtype = "nodebox",
	tiles ={"hub_active.png","asphalt.png","hub_side.png"},
  paramtype = "light",
  paramtype2 = "facedir",
  on_construct=function(pos)
    local node=minetest.get_node(pos)
    local dir=node.param2
    local cpt=1
    local x,z=0,0
    local pos1={x=pos.x,y=pos.y+1,z=pos.z}
    repeat
    if dir==0 then pos1.z=pos1.z+1 end
    if dir==1 then pos1.x=pos1.x+1 end
    if dir==2 then pos1.z=pos1.z-1 end
    if dir==3 then pos1.x=pos1.x-1 end
    local testdown=minetest.get_node(pos1)
    local testup=minetest.get_node({x=pos1.x,y=pos1.y+1,z=pos1.z})
    local err=0
    if testdown.name=="air" or testdown.name=="vacuum:vacuum" then err=err+1 end
    if testup.name=="air" or testup.name=="vacuum:vacuum" then err=err+1 end
    if err==2 then
      minetest.set_node(pos1, {name="bloc4builder:passerelle",param2=node.param2})
      minetest.set_node({x=pos1.x,y=pos1.y+1,z=pos1.z}, {name="bloc4builder:passerelle",param2=node.param2+20})
    else
      cpt=10
    end
    cpt=cpt+1
    until cpt>10
  end,
  on_destruct=function(pos)
    local node=minetest.get_node(pos)
    local dir=node.param2
    local cpt=1
    local x,z=0,0
    local pos1={x=pos.x,y=pos.y+1,z=pos.z}
    repeat
    if dir==0 then pos1.z=pos1.z+1 end
    if dir==1 then pos1.x=pos1.x+1 end
    if dir==2 then pos1.z=pos1.z-1 end
    if dir==3 then pos1.x=pos1.x-1 end
    local test=minetest.get_node(pos1)
    if test.name=="bloc4builder:passerelle" then
      local pos_air=minetest.find_node_near(pos, 1, {"air","vacuum:vacuum"})
      local node_air="air"
      if pos_air then
        local tmp=minetest.get_node(pos_air)
        node_air=tmp.name
      end
      minetest.set_node(pos1, {name=node_air})
      minetest.set_node({x=pos1.x,y=pos1.y+1,z=pos1.z}, {name=node_air})
    else
      cpt=10
    end
    cpt=cpt+1
    until cpt>10
  end,
	--is_ground_content = false,
	groups = {switch=51,not_in_creative_inventory=1},
	sounds = default.node_sound_metal_defaults(),
})

--** sas door **
minetest.register_node("bloc4builder:sas_closed_up", {
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = true,
	pointable = false,
	diggable = false,
	buildable_to = false,
	floodable = false,
	drop = "",
	groups = {not_in_creative_inventory = 1},
	tiles = {"sas_open.png","sas_open.png","sas_open.png","sas_open.png","sas_closed_up_inv.png","sas_closed_up.png"},
	node_box = {
		type = "fixed",
		fixed = {-0.5,-0.5,0.4375,0.5,0.5,0.5},
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.5,-0.5,0.4375,0.5,0.5,0.5},
	},
  use_texture_alpha = true,
})

minetest.register_node("bloc4builder:sas_closed_down", {
	description = "sas door",
  inventory_image = "sas.png",
  drawtype = "nodebox",
	tiles ={"sas_open.png","sas_open.png","sas_open.png","sas_open.png","sas_closed_down_inv.png","sas_closed_down.png"},
  node_box = {
		type = "fixed",
    fixed = {-0.5,-0.5,0.4375,0.5,0.5,0.5},
		},
  selection_box = {
		type = "fixed",
        fixed = {
			{-0.5,-0.5,0.4375,0.5,1.5,0.5},
		},
    },
  paramtype = "light",
  paramtype2 = "facedir",
  use_texture_alpha = true,
	is_ground_content = false,
  on_rightclick = function(pos, node)
    minetest.set_node(pos, {name="bloc4builder:sas_on",param2=node.param2})
    minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z}, {name="bloc4builder:sas_on",param2=node.param2})
  end,
  after_place_node = function(pos, placer, itemstack, pointed_thing)
    local node=minetest.get_node(pos)
    minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z}, {name="bloc4builder:sas_closed_up",param2=node.param2})
  end,
  after_dig_node = function(pos, node, meta, digger)
		minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
  end,
	groups = {cracky=3},
	sounds = default.node_sound_metal_defaults(),
  on_rotate = function(pos, node, user, mode, new_param2)
		return false
  end
})
--
minetest.register_node("bloc4builder:sas_on", {
  drawtype = "nodebox",
	tiles ={"sas_open.png"},
  node_box = {
		type = "fixed",
    fixed = {0.4375,-0.5,0.4375,0.5,0.5,0.5},
		},
  selection_box = {
		type = "fixed",
        fixed = {
			{0.4375,-0.5,0.4375,0.5,0.5,0.5},
		},
    },
  paramtype = "light",
  paramtype2 = "facedir",
	is_ground_content = false,
  on_construct=function(pos)
    minetest.get_node_timer(pos):start(3)
  end,
  on_rightclick = function(pos, node)
    minetest.set_node(pos, {name="bloc4builder:sas_closed_down",param2=node.param2})
    --TODO test si node au dessus ou au dessous
    minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="bloc4builder:sas_closed_up",param2=node.param2})
  end,
  on_timer = function(pos,elapsed)
    local node=minetest.get_node(pos)
    minetest.set_node(pos, {name="bloc4builder:sas_closed_down",param2=node.param2})
    minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="bloc4builder:sas_closed_up",param2=node.param2})
  end,
	groups = {not_in_creative_inventory=1},
	sounds = default.node_sound_metal_defaults(),
})

--** trapdoor **
doors.register_trapdoor("bloc4builder:trapdoor_metal", {
	description = "Steel Trapdoor",
	inventory_image = "trapmetal.png",
	wield_image = "trapmetal.png",
	tile_front = "trapmetal.png",
	tile_side = "doors_trapdoor_steel_side.png",
	protected = false,
	sounds = default.node_sound_metal_defaults(),
	sound_open = "doors_steel_door_open",
	sound_close = "doors_steel_door_close",
	groups = {cracky = 1, level = 2, door = 1},
})

--** rideaux de fer **
minetest.register_node("bloc4builder:ridodefer", {
	description = "rideaux de fer",
	drawtype = "nodebox",
	tiles = {"garage.png^[transformR90"},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, 0.5, 1.5, 0.0625},
        },
	},
	selection_box = {
		type = "fixed",
        fixed = {
			{-0.5, -0.5, -0.0625, 0.5, 1.5, 0.0625},
		},
    },
	on_construct=function(pos)
    local node_content=minetest.get_node(pos)
    minetest.set_node({x = pos.x, y = pos.y + 1, z=pos.z}, {name="doors:hidden",param2=node_content.param2})
    local pos1={x=pos.x-1,y=pos.y,z=pos.z-1}
    local pos2={x=pos.x+1,y=pos.y,z=pos.z+1}
    local node_pos=minetest.find_nodes_in_area(pos1, pos2, {"bloc4builder:ridodefer_on"})
    if node_pos then
      for i=1,#node_pos do
        node_content=minetest.get_node(node_pos[i])
        minetest.set_node(node_pos[i], {name="bloc4builder:ridodefer",param2=node_content.param2})
      end
    end
  end,
  after_dig_node = function(pos, node, meta, digger)
		minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
  end,
	groups = {choppy=3,switch=13},
	sounds = default.node_sound_wood_defaults(),
  on_rotate = function(pos, node, user, mode, new_param2)
		return false
  end
})
--
minetest.register_node("bloc4builder:ridodefer_on", {
	description = "rideaux de fer",
	drawtype = "nodebox",
	tiles = {"garage.png^[transformR90"},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 1.4375, -0.0625, 0.5, 1.5, 0.0625},
		},
	},
	selection_box = {
		type = "fixed",
        fixed = {
			{-0.5, 1.4375, -0.0625, 0.5, 1.5, 0.0625},
		},
    },
	on_construct=function(pos)
    local node_content=minetest.get_node(pos)
    minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
    local pos1={x=pos.x-1,y=pos.y,z=pos.z-1}
    local pos2={x=pos.x+1,y=pos.y,z=pos.z+1}
    local node_pos=minetest.find_nodes_in_area(pos1, pos2, {"bloc4builder:ridodefer"})
    if node_pos then
      for i=1,#node_pos do
        node_content=minetest.get_node(node_pos[i])
        minetest.set_node(node_pos[i], {name="bloc4builder:ridodefer_on",param2=node_content.param2})
      end
    end
  end,
	drop = "bloc4builder:ridodefer",
  after_dig_node = function(pos, node, meta, digger)
		minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
  end,
	groups = {not_in_creative_inventory=1,switch=63},
	sounds = default.node_sound_wood_defaults(),
  on_rotate = function(pos, node, user, mode, new_param2)
		return false
  end
})

--porte de garage
minetest.register_node("bloc4builder:garage", {
	description="porte garage",
	tiles = {"sol_metal.png"},
	is_ground_content = true,
	groups = {cracky=3,switch=11},
	sounds = default.node_sound_stone_defaults(),
  on_construct=function(pos)
    local pos1={x=pos.x-1,y=pos.y-1,z=pos.z-1}
    local pos2={x=pos.x+1,y=pos.y+1,z=pos.z+1}
    local node_pos=minetest.find_nodes_in_area(pos1, pos2, {"bloc4builder:garage_on"})
    if node_pos then
      for i=1,#node_pos do
        local node_content=minetest.get_node(node_pos[i])
        minetest.set_node(node_pos[i], {name="bloc4builder:garage"})
      end
    end
  end,
})
--
minetest.register_node("bloc4builder:garage_on", {
	drawtype = "airlike",
	pointable = false,
	walkable = false,
	diggable = false,
	sunlight_propagates = true,
	paramtype = "light",
	drop = "bloc4builder:garage",
	groups = { not_in_creative_inventory=1,switch=61},
	on_construct=function(pos)
    local pos1={x=pos.x-1,y=pos.y-1,z=pos.z-1}
    local pos2={x=pos.x+1,y=pos.y+1,z=pos.z+1}
    local node_pos=minetest.find_nodes_in_area(pos1, pos2, {"bloc4builder:garage"})
    if node_pos then
      for i=1,#node_pos do
        local node_content=minetest.get_node(node_pos[i])
        minetest.set_node(node_pos[i], {name="bloc4builder:garage_on"})
      end
    end
  end,
})

minetest.register_craft({
	output = 'bloc4builder:garage 4',
	recipe = {
		{"default:steel_ingot", "dye:white", "default:steel_ingot"},
		{"default:steel_ingot", "group:mesecon_conductor_craftable", "default:steel_ingot"},
		{"default:steel_ingot", "", "default:steel_ingot"},
	}
})

-- porte !! issue du mod moon ou spacestation... !!

minetest.register_node("bloc4builder:sas_hidden_mid", {
	drawtype = "glasslike",
	paramtype = "light",
  use_texture_alpha = true,
	sunlight_propagates = true,
	walkable = true,
	pointable = false,
	diggable = false,
	buildable_to = false,
	floodable = false,
	drop = "",
	groups = {not_in_creative_inventory = 1},
	on_blast = function() end,
	tiles = {"bloc4builder_air.png"},
	collision_box = {
		type = "fixed",
		fixed = {-0.1,-0.5,-0.1,0.1,0.5,0.1},
	},
})

minetest.register_node("bloc4builder:door", {
	description = "Space Station Interal Door single",
  inventory_image = "spacestation_door.png",
	tiles = {{ name = "spacestation_door2.png", backface_culling = true }},
	groups = {cracky=3, switch=3},
	drop = 'bloc4builder:door',
	drawtype = "mesh",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	use_texture_alpha = true,
	walkable = true,
	is_ground_content = false,
	buildable_to = false,
	selection_box = { type = "fixed", fixed = { -1/2,-1/2,-1/16,1/2,3/2,1/16} },
	collision_box = { type = "fixed", fixed = { -1/2,-1/2,-1/16,1/2,3/2,1/16} },
	mesh = "door_c.obj",
	sounds = default.node_sound_stone_defaults(),
  after_place_node = function(pos, placer, itemstack, pointed_thing)
    local node=minetest.get_node(pos)
    minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="bloc4builder:sas_hidden_mid",param2=node.param2})
  end,
  after_dig_node = function(pos, node, meta, digger)
		minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
  end,
})
--
minetest.register_node("bloc4builder:door_on", {
	description = "Space Station Interal Door",
	tiles = {{ name = "spacestation_door2.png", backface_culling = true }},
	groups = {cracky=3, switch=53,not_in_creative_inventory=1},
	drop = 'bloc4builder:door',
	drawtype = "mesh",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	use_texture_alpha = true,
	walkable = false,
	is_ground_content = false,
	buildable_to = false,
	selection_box = { type = "fixed", fixed = { -1/2,-1/2,-1/16,1/2,3/2,1/16} },
	mesh = "door_c_open.obj",
	sounds = default.node_sound_stone_defaults(),
  on_construct=function(pos)
    minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
  end,
})

-- pont levis

minetest.register_node("bloc4builder:pont_levis", {
	description = "pont_levis",
	drawtype = "nodebox",
	tiles = {"pont_levis.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 1.5}, -- NodeBox1
        },
	},
	selection_box = {
		type = "fixed",
        fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 1.5},
		},
    },
	on_rightclick = function(pos, node)
		minetest.set_node(pos, {name = "bloc4builder:pont_levis_closed", param2 = node.param2})
        local pos1={x=pos.x-3,y=pos.y,z=pos.z-3}
        local pos2={x=pos.x+3,y=pos.y,z=pos.z+3}
        local list_coordo=minetest.find_nodes_in_area_under_air(pos1,pos2, "bloc4builder:pont_levis")
        local count=table.getn(list_coordo)
        if count>0 then
           for i=1,count do
               local node = minetest.get_node(list_coordo[i])
               minetest.set_node(list_coordo[i], {name = "bloc4builder:pont_levis_closed", param2 = node.param2})
           end
        end
	end,
	groups = {choppy=3},
	sounds = default.node_sound_wood_defaults(),
})
--
minetest.register_node("bloc4builder:pont_levis_closed", {
	description = "pont_levis",
	drawtype = "nodebox",
	tiles = {"pont_levis.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	node_box = {
		type = "fixed",
		fixed = {

			{-0.5, -0.5, -0.5, 0.5, 1.5, -0.4375},
		},
	},
	selection_box = {
		type = "fixed",
        fixed = {
			{-0.5, -0.5, -0.5, 0.5, 1.5, -0.4375},
		},
    },
	on_rightclick = function(pos, node)
		minetest.set_node(pos, {name = "bloc4builder:pont_levis", param2 = node.param2})
        local pos1={x=pos.x-3,y=pos.y,z=pos.z-3}
        local pos2={x=pos.x+3,y=pos.y,z=pos.z+3}
        local list_coordo=minetest.find_nodes_in_area_under_air(pos1,pos2, "bloc4builder:pont_levis_closed")
        local count=table.getn(list_coordo)
        if count>0 then
           for i=1,count do
               local node = minetest.get_node(list_coordo[i])
               minetest.set_node(list_coordo[i], {name = "bloc4builder:pont_levis", param2 = node.param2})
           end
        end
	end,
	drop = "bloc4builder:pont_levis",
	groups = {choppy=3, not_in_creative_inventory=1},
	sounds = default.node_sound_wood_defaults(),
})

--************
--** switch **
--************


--** switch keypad with password **

minetest.register_node("bloc4builder:switch_off", {
	description = "Keypad",
	tiles = {
    "code_off.png"
	},
	inventory_image = "code_off.png",
	wield_image = "code_off.png",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.4, 0.5, 0.5, 0.5},
		},
    },
	paramtype = "light",
	paramtype2 = "facedir",
  sunlight_propagates = true,
	groups = {cracky=1, oddly_breakable_by_hand=1},
  after_place_node=function(pos,placer)
		local meta = minetest.get_meta(pos)
    local owner=placer:get_player_name() or "NoPlayer"
    local channel="No channel:".. owner
    meta:set_string("channel",channel)
    meta:set_string("code", "")
	end,
	on_rightclick = function(pos, node, player, item, _)
    password_check(pos,node,player,"bloc4builder:switch_on",10)
	end,
  can_dig = function(pos,player)
    local meta = minetest.get_meta(pos)
    local channel=meta:get_string("channel")

    if channel=="" then
      channel="No channel:NoPlayer"
      meta:set_string("channel",channel)
      meta:set_string("code","")
    end

    local name=player:get_player_name()
    local owner=string.split(channel,":")

    if owner[2]~=name then return false end
    return true
   end,
	sounds = default.node_sound_glass_defaults()
})

minetest.register_node("bloc4builder:switch_on", {
	description = "Keypad",
	sunlight_propagates = true,
	tiles = {
		"code_on.png"
	},
	inventory_image = "code_on.png",
	wield_image = "code_on.png",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.4, 0.5, 0.5, 0.5},
		},
    },
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 5,
	groups = {cracky=1, oddly_breakable_by_hand=1, not_in_creative_inventory=1},
	on_rightclick = function(pos, node, player)
    bloc4builder.switch_off(pos,"bloc4builder:switch_off",10)
	end,
  on_destruct = function (pos)
    bloc4builder.switch_off(pos,"bloc4builder:switch_off",10)
	end,
  can_dig = function(pos, player)
     local meta = minetest.get_meta(pos)
    local channel=meta:get_string("channel")

    if channel=="" then
      channel="No channel:NoPlayer"
      meta:set_string("channel",channel)
      meta:set_string("code","")
    end

    local name=player:get_player_name()
    local owner=string.split(channel,":")

    if owner[2]~=name then return false end
    return true
   end,
  drop="bloc4builder:switch_off",
	sounds = default.node_sound_glass_defaults()
})

--** switch on/off **

minetest.register_node("bloc4builder:switch1_off", {
	description = "Wall switch",
	tiles = {
		"switch1_off.png"
	},
	inventory_image = "switch1_off.png",
	wield_image = "switch1_off.png",
	drawtype = "nodebox",
node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.495, 0.5, 0.5, 0.5},
		},
    },
	paramtype = "light",
	paramtype2 = "facedir",
  sunlight_propagates = true,
	groups = {cracky=1, oddly_breakable_by_hand=1},
  on_rightclick = function(pos, node, player)    
    bloc4builder.switch_on(pos,"bloc4builder:switch1_on",1)
	end,
	sounds = default.node_sound_glass_defaults()
})

minetest.register_node("bloc4builder:switch1_on", {
	description = "Wall switch",
	tiles = {
		"switch1_on.png"
	},
	drawtype = "nodebox",
node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.495, 0.5, 0.5, 0.5},
		},
    },
	paramtype = "light",
	paramtype2 = "facedir",
  sunlight_propagates = true,
	groups = {cracky=1, oddly_breakable_by_hand=1, not_in_creative_inventory=1},
  on_rightclick = function(pos, node, player)    
    bloc4builder.switch_off(pos,"bloc4builder:switch1_off",1)
	end,
  on_destruct = function (pos)
    bloc4builder.switch_off(pos,"bloc4builder:switch1_off",1)
	end,
  drop="bloc4builder:switch1_off",
	sounds = default.node_sound_glass_defaults()
})

--** switch poussoir 3 sec **

minetest.register_node("bloc4builder:switch2_off", {
	description = "Wall impulse switch",
	tiles = {
		"bp0.png"
	},
	inventory_image = "bp0.png",
	wield_image = "bp0.png",
	drawtype = "nodebox",
node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.495, 0.5, 0.5, 0.5},
		},
    },
	paramtype = "light",
	paramtype2 = "facedir",
  sunlight_propagates = true,
  use_texture_alpha = true,
	groups = {cracky=1, oddly_breakable_by_hand=1},
  on_rightclick = function(pos,node, player)
    bloc4builder.switch_on(pos,"bloc4builder:switch2_on",2)
    minetest.get_node_timer(pos):start(3)
	end,
	sounds = default.node_sound_glass_defaults()
})

minetest.register_node("bloc4builder:switch2_on", {
	description = "Wall impulse switch",
	tiles = {"invisible.png","invisible.png","invisible.png","invisible.png","invisible.png",
		{
			image = "bp_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 32,
				aspect_h = 32,
				length = 1
			},}
	},
	drawtype = "nodebox",
node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.495, 0.5, 0.5, 0.5},
		},
    },
	paramtype = "light",
	paramtype2 = "facedir",
  sunlight_propagates = true,
	groups = {cracky=1, oddly_breakable_by_hand=1, not_in_creative_inventory=1},
  on_construct=function(pos)
    minetest.get_node_timer(pos):start(3)
  end,
  on_rightclick = function(pos, node, player, item, _)    
    bloc4builder.switch_off(pos,"bloc4builder:switch2_off",2)
	end,
  on_destruct = function (pos)
    bloc4builder.switch_off(pos,"bloc4builder:switch2_off",2)
	end,
  on_timer = function(pos,elapsed)
    minetest.get_node_timer(pos):stop()
    bloc4builder.switch_off(pos,"bloc4builder:switch2_off",2)
  end,
  drop="bloc4builder:switch2_off",
	sounds = default.node_sound_glass_defaults()
})
