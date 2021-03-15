--**************************
--** bloc4builder ver 2   **
--** Romand Philippe 2020 **
--**************************
local fields_player={}

bloc4builder.init_formspec=function(pos)
  local meta = minetest.get_meta(pos)
  meta:set_string("channel","No channel")
  meta:set_string("formspec","size[8, 4]button_exit[2,3;2,1;submit;submit]field[1,1;3,1;channel;channel;No channel]")
end

bloc4builder.change_formspec=function(pos,fields,sender)
  local name=sender:get_player_name()
  local meta = minetest.get_meta(pos)

  if fields.channel==nil then fields.channel="No channel" end

  if fields.submit then
    meta:set_string("channel",fields.channel)
    meta:set_string("formspec","size[8, 4]button_exit[2,3;2,1;submit;submit]field[1,1;3,1;channel;channel;".. fields.channel .."]")
  end
end

local check_dig=function(pos,player)
  local meta = minetest.get_meta(pos)
  local channel=meta:get_string("channel")

  --si channel non inititialiser
  if channel=="" then
    channel="No channel:noplayer"
    meta:set_string("channel",channel)
    meta:set_string("code","")
  end

  local name=player:get_player_name()
  local owner=string.split(channel,":")

  if owner[2]~=name then return false end
  return true
end

--interrupteur de commande pour le group switch
--recherche group switch et modifie le nom
--
-- 111 = 3 bp / 2 keypad / 1 on_switch

local function change_node(node_content,nname,npos,state)

  if  state==1 and string.find(nname,"_on")==nil then
    nname=nname.."_on"
    minetest.set_node(npos, {name=nname,param2=node_content.param2})
  elseif state==0 and string.find(nname,"_on")~=nil then
    nname=string.gsub(nname,"_on","")
    minetest.set_node(npos, {name=nname,param2=node_content.param2})
  end

end

local function change_switch(pos,src_chan,found,radius)

  if radius==nil then radius=5 end

    if found == nil then
      found=minetest.find_nodes_in_area({x=pos.x-radius,y=pos.y-radius,z=pos.z-radius},{x=pos.x+radius,y=pos.y+radius,z=pos.z+radius},{"group:switch"})
    end

    if found then
      for i=1,#found do
        local node_switch=minetest.get_node(found[i])
        local nodename=node_switch.name
        local group=minetest.get_item_group(nodename,"switch")

        if group==1 then
          local nod_met=minetest.get_meta(found[i])
          local tmp=nod_met:get_string("channel")
          if tmp=="" then tmp="No channel" end
          local dst_chan=string.split(tmp,":")
          if src_chan==dst_chan[1] then
            if minetest.registered_nodes[nodename].on_switch then
              minetest.registered_nodes[nodename].on_switch(found[i],node_switch)
            end
          end
        end
        
      end
    end

end

--**

bloc4builder.switch_on=function(pos,swap,switch,state,radius)
  node=minetest.get_node(pos)

  if radius==nil then radius=2 end

  if swap~=nil then
    minetest.swap_node(pos, {name=swap,param2=node.param2})
  end

  -- recherche tout group switch
  local node_pos=minetest.find_nodes_in_area({x=pos.x-radius,y=pos.y-radius,z=pos.z-radius},{x=pos.x+radius,y=pos.y+radius,z=pos.z+radius}, {"group:switch","group:door"})

  if node_pos then
    for nb_node=1,#node_pos do
      local node_content=minetest.get_node(node_pos[nb_node])
      local nname=node_content.name
      local group_switch=minetest.get_item_group(nname, "switch")
      local group_door=minetest.get_item_group(nname, "door")

      if group_switch>0 then
        if math.floor(group_switch/100)==1 then
          if switch==3 then --bp
            change_node(node_content,nname,node_pos[nb_node],state)
            group_switch=100
          end
          group_switch=group_switch-100
        end
        if math.floor(group_switch/10)==1 then
          if switch==2 then --keypad
            change_node(node_content,nname,node_pos[nb_node],state)
            group_switch=10
          end
          group_switch=group_switch-10
        end
        if group_switch==1 then
          if switch==1 then --on_switch
          if node_pos then
            change_switch(pos,state,node_pos)
          end
          end
        end
      end

      if group_door>0 then
        local level=minetest.get_item_group(nname, "level")
        if level==0 then
          doors.door_toggle(node_pos[nb_node], node_content, nil)
        end
      end

    end
  end

end

--**************
--** password **
--**************
--switch=-1 --> for door : swap node et set node hidden
local function password_check(pos,node,player,swap,switch,state,sound,hidden)

  if hidden==nil then hidden="" end
  if sound==nil then sound="" end

  local meta = minetest.get_meta(pos)
  local channel=meta:get_string("channel")
  local name=player:get_player_name()

  --si channel non initialiser / default=No channel:NoPlayer
  if channel=="" then
    channel="No channel:noplayer" --..name
    meta:set_string("channel",channel)
    meta:set_string("code","")
  end

  local position=minetest.pos_to_string(pos)
  local owner=string.split(channel,":")
  local code=meta:get_string("code")
  local tool = player:get_wielded_item():get_name()

  --player est owner
  if name==owner[2] then
    --parametrage avec le spacengine tool
    if tool == "spacengine:tool" then
      fields_player[name]="switch_setup#"..position.."#".. swap .."#".. tostring(switch).."#"..state.."#"..name
      return minetest.show_formspec(name, "switch_setup", "size[8, 4]label[0, 0;PASSWORD]field[1,1;5,1;oldcode;oldcode;".. code .."]field[1,2;5,1;newcode;newcode;".. code .."]button_exit[2,3;2,1;submit;submit]field[1,4;3,1;channel;;".. owner[1] .."]")

    else

      if sound~="" then
        minetest.sound_play(sound, {pos = pos, gain = 1.5,max_hear_distance = 4})
      end

      if switch==-1 then
        --option special porte 1 side
        minetest.swap_node({x=pos.x,y=pos.y,z=pos.z},{name=swap,param2=node.param2})
        minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name=hidden,param2=node.param2})

      elseif switch==1 then
        bloc4builder.switch_on(pos,swap,switch,state,6)
      elseif switch>1 then
        --if string.find(swap,"_off")~=nil then
          bloc4builder.switch_on(pos,swap,switch,state)
        --else
          --bloc4builder.switch_on(pos,swap,switch,state)
        --end

        return
      end
    end

  --player n'est pas owner
  else

    --si code present
    if code ~= "" then
      fields_player[name]="switch_unlock#"..position.."#".. swap .."#".. tostring(switch) .."#"..state.."#".. code .."#".. sound .."#".. hidden
      return minetest.show_formspec(name, "switch_unlock", "size[8, 4]" .."label[0, 0;PASSWORD]" .."field[1,1;5,1;code;code;]button_exit[2,3;2,1;unlock;submit]")

    else

      if sound~="" then
        minetest.sound_play(sound, {pos = pos, gain = 1.5,max_hear_distance = 4})
      end

      if switch==-1 then
        --option special porte 1 side
        minetest.swap_node({x=pos.x,y=pos.y,z=pos.z},{name=swap,param2=node.param2})
        minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name=hidden,param2=node.param2})

      elseif switch>1 then

        if string.find(swap,"_off")==nil then
          bloc4builder.switch_on(pos,swap,switch,state)
        else
          bloc4builder.switch_on(pos,swap,switch,state)
        end

        return
      end
    end
  end


end

minetest.register_on_player_receive_fields(function(player, formname, fields)

  if string.find(formname,"switch_")~=nil then
    local name=player:get_player_name()

    local split=string.split(fields_player[name],"#")
    local switchpos=minetest.string_to_pos(split[2])
    local meta = minetest.get_meta(switchpos)

    if fields.newcode==nil then fields.newcode="" end
    if fields.oldcode==nil then fields.oldcode="" end

    if fields.quit then
      fields_player[name]=nil
    end

    if string.find(formname, "setup") then
      if fields.submit then
        meta:set_string("channel",fields.channel..":"..split[6])
        if fields.oldcode == meta:get_string("code") then
          meta:set_string("code", fields.newcode)
        else
          minetest.chat_send_player(split[6],"INVALID PASSWORD")
        end
      end
    end

    if string.find(formname, "unlock") then

      if fields.code == meta:get_string("code") then

        if tonumber(split[4])==-1 then
          --option special porte 1 side
          local node=minetest.get_node(switchpos)
          minetest.swap_node({x=switchpos.x,y=switchpos.y,z=switchpos.z},{name=split[3],param2=node.param2})
          minetest.set_node({x=switchpos.x,y=switchpos.y+1,z=switchpos.z},{name=split[8],param2=node.param2})

        else

          if split[7]~="" then
            minetest.sound_play(split[6], {pos = pos, gain = 1.5,max_hear_distance = 4})
          end

          if string.find(split[3],"_off")==nil then
            bloc4builder.switch_on(switchpos,split[3],split[4],split[5])
          else
            bloc4builder.switch_on(switchpos,split[3],split[4],split[5])
          end
          return

        end

      end
    end
    return
  end

end)

--******************
--** PORTE et SAS **
--******************

--** passerelle d'embarquement **
minetest.register_node("bloc4builder:passerelle", {
	description = "passerelle",
  drawtype = "nodebox",
	tiles ={"b4b_passerel_top.png","b4b_passerel_top.png","b4b_passerel_side.png"},
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
  light_source = 12,
	sounds = default.node_sound_metal_defaults(),
})

--*********
--** hub **
--*********
minetest.register_node("bloc4builder:hub", {
	description = "hub embarquement",
  drawtype = "nodebox",
	tiles ={"b4b_hub.png","b4b_shiping.png","b4b_hub_side.png"},
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
      minetest.remove_node(pos1)
      minetest.remove_node({x=pos1.x,y=pos1.y+1,z=pos1.z})
    else
      cpt=8
    end
    cpt=cpt+1
    until cpt>8

  end,
	groups = {cracky=3,switch=10,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_metal_defaults(),
})

minetest.register_node("bloc4builder:hub_on", {
	description = "hub embarquement",
  drawtype = "nodebox",
	tiles ={"b4b_hub_active.png","b4b_shiping.png","b4b_hub_side.png"},
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
      cpt=8
    end
    cpt=cpt+1
    until cpt>8
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
      minetest.remove_node(pos1)
      minetest.remove_node({x=pos1.x,y=pos1.y+1,z=pos1.z})
    else
      cpt=8
    end
    cpt=cpt+1
    until cpt>8
  end,
	groups = {switch=10,not_in_creative_inventory=1},
	sounds = default.node_sound_metal_defaults(),
  drop="bloc4builder:hub"
})

--***********
--** sas 1 **
--***********
minetest.register_node("bloc4builder:sas1", {
	description = "SAS 1",
  inventory_image = "b4b_sas1_inv.png",
  drawtype = "mesh",
  mesh = "door_1.obj",
	tiles = {{ name = "b4b_sas1.png", backface_culling = true }},
	groups = {cracky=3,not_in_creative_inventory=bloc4builder.creative_enable},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	use_texture_alpha = true,
	walkable = true,
	is_ground_content = false,
	buildable_to = false,
	selection_box = { type = "fixed", fixed = { -0.5,-0.5,0.4375,0.5,1.5,0.5} },
	collision_box = { type = "fixed", fixed = { -0.5,-0.5,0.4375,0.5,1.5,0.5} },
	sounds = default.node_sound_stone_defaults(),
  on_rightclick = function(pos, node)
    minetest.set_node(pos, {name="bloc4builder:sas1_on",param2=node.param2})
    minetest.sound_play("sas1_open", {pos = pos, gain = 1.5,
			max_hear_distance = 4})
  end,
  on_construct=function(pos)
    local node=minetest.get_node(pos)
    minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z}, {name="doors:hidden",param2=node.param2})
  end,
  after_dig_node = function(pos, node, meta, digger)
		minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
  end,
	sounds = default.node_sound_metal_defaults(),
  on_rotate = function(pos, node, user, mode, new_param2)
		return false
  end
})

minetest.register_node("bloc4builder:sas1_on", {
	tiles = {{ name = "b4b_sas1.png", backface_culling = true }},
	groups = {cracky=3,not_in_creative_inventory=1},
	drop = 'bloc4builder:sas1',
	drawtype = "mesh",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	use_texture_alpha = true,
	walkable = false,
	is_ground_content = false,
	buildable_to = false,
	selection_box = { type = "fixed", fixed = { -0.5,-0.5,0.4375,0.5,1.5,0.5} },
	mesh = "door_1_open.obj",
	sounds = default.node_sound_stone_defaults(),
  on_construct=function(pos)
    minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
    minetest.get_node_timer(pos):start(3)
  end,
  on_rightclick = function(pos, node)
    minetest.get_node_timer(pos):stop()
    minetest.set_node(pos, {name="bloc4builder:sas1",param2=node.param2})
    minetest.sound_play("sas1_open", {pos = pos, gain = 1.5,
			max_hear_distance = 4})
  end,
  on_timer = function(pos,elapsed)
    local node=minetest.get_node(pos)
    minetest.set_node(pos, {name="bloc4builder:sas1",param2=node.param2})
  end,
  after_dig_node = function(pos, node, meta, digger)
		minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
  end,
})

--*********************
--** sas 2  password **
--*********************
minetest.register_node("bloc4builder:sas2", {
	description = "SAS 2",
  inventory_image = "b4b_sas2_inv.png",
  drawtype = "mesh",
  mesh = "door_2.obj",
	tiles = {{ name = "b4b_sas2.png", backface_culling = true }},
	groups = {cracky=3,not_in_creative_inventory=bloc4builder.creative_enable},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	use_texture_alpha = true,
	walkable = true,
	is_ground_content = false,
	buildable_to = false,
	selection_box = { type = "fixed", fixed = { -0.5,-0.5,0.4375,0.5,1.5,0.5} },
	collision_box = { type = "fixed", fixed = { -0.5,-0.5,0.4375,0.5,1.5,0.5} },
	sounds = default.node_sound_stone_defaults(),
  on_construct=function(pos)
    local node=minetest.get_node(pos)
    minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="doors:hidden",param2=node.param2})
    local meta = minetest.get_meta(pos)
    if meta:get_string("channel")=="" then
      meta:set_string("channel","No channel:noplayer")
      meta:set_string("code", "")
    end
  end,
  on_rightclick = function(pos, node, player)
    password_check(pos,node,player,"bloc4builder:sas2_on",-1,1,"sas2_open","air")
  end,
  can_dig = function(pos,player)
    if check_dig(pos,player) then return true end
    return false
   end,
  after_dig_node = function(pos, node, meta, digger)
		minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
  end,
  after_place_node=function(pos,placer)
    if placer and placer:is_player() then
    local meta = minetest.get_meta(pos)
    local owner=placer:get_player_name()
    meta:set_string("channel","No channel:"..owner)
    end
	end,
})

minetest.register_node("bloc4builder:sas2_on", {
	tiles = {{ name = "b4b_sas2.png", backface_culling = true }},
	groups = {cracky=3,not_in_creative_inventory=1},
	drop = 'bloc4builder:sas2',
	drawtype = "mesh",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	use_texture_alpha = true,
	walkable = false,
	is_ground_content = false,
	buildable_to = false,
	selection_box = { type = "fixed", fixed = { -0.5,-0.5,0.4375,0.5,1.5,0.5} },
	mesh = "door_2_open.obj",
	sounds = default.node_sound_stone_defaults(),
  on_construct=function(pos)
    minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
  end,
  on_rightclick = function(pos, node, player)
    password_check(pos,node,player,"bloc4builder:sas2",-1,0,"sas2_open","doors:hidden")
  end,
  can_dig = function(pos,player)
    if check_dig(pos,player) then return true end
    return false
   end,
  after_dig_node = function(pos, node, meta, digger)
		minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
  end,
})

--******************
--** sas 3 CLOSED **
--******************
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
	tiles = {"b4b_air.png"},
	collision_box = {
		type = "fixed",
		fixed = {-0.1,-0.5,-0.1,0.1,0.5,0.1},
	},
})

minetest.register_node("bloc4builder:door", {
	description = "Space Station Interal Door single",
  inventory_image = "b4b_sas_inv.png",
	tiles = {{ name = "b4b_sas.png", backface_culling = true }},
	groups = {cracky=3, switch=110,not_in_creative_inventory=bloc4builder.creative_enable},
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
  on_construct=function(pos)
    local node=minetest.get_node(pos)
    minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="bloc4builder:sas_hidden_mid",param2=node.param2})
  end,
  after_dig_node = function(pos, node, meta, digger)
		minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
  end,
  on_rightclick = function(pos, node, player, item, _)
    minetest.chat_send_player(player:get_player_name(),"DOOR CLOSED")
	end,
})

minetest.register_node("bloc4builder:door_on", {
	description = "Space Station Interal Door",
	tiles = {{ name = "b4b_sas.png", backface_culling = true }},
	groups = {cracky=3, switch=110,not_in_creative_inventory=1},
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
  on_rightclick = function(pos, node, player, item, _)
    minetest.chat_send_player(player:get_player_name(),"DOOR OPEN")
	end,
})

--*********************
--** glass door shop **
--*********************
local function open_door_shop(pos)
  minetest.sound_play("door_shop", {pos = pos, gain = 0.8,
    max_hear_distance = 4})

  local found_door=minetest.find_node_near(pos,1,"bloc4builder:door_shop")
  if found_door then
    local other_node=minetest.get_node(found_door)
    minetest.remove_node({x = found_door.x, y = found_door.y + 1, z = found_door.z})
    minetest.swap_node(found_door, {name="bloc4builder:door_shop_on",param2=other_node.param2})
  end
end

local function closed_door_shop(pos)
  minetest.sound_play("door_shop", {pos = pos, gain = 0.8,
    max_hear_distance = 4})

  local found_door=minetest.find_node_near(pos,1,"bloc4builder:door_shop_on")
  if found_door then
    local other_node=minetest.get_node(found_door)
    minetest.set_node({x=found_door.x, y=found_door.y+1, z=found_door.z}, {name="bloc4builder:sas_hidden_mid", param2=other_node.param2})
    minetest.swap_node(found_door, {name="bloc4builder:door_shop",param2=other_node.param2})
  end
end

minetest.register_node("bloc4builder:door_shop", {
	description = "door shop",
  inventory_image = "b4b_door_shop_inv.png",
	tiles = {{ name = "b4b_door_shop.png", backface_culling = true }},
	groups = {cracky=3, switch=1,not_in_creative_inventory=bloc4builder.creative_enable},
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
  on_construct=function(pos)
    local meta = minetest.get_meta(pos)
    meta:set_string("channel","No channel")
    local node=minetest.get_node(pos)
    minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="bloc4builder:sas_hidden_mid",param2=node.param2})
  end,
  after_dig_node = function(pos, node, meta, digger)
		minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
  end,
  on_rightclick = function(pos, node)
    minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
    minetest.swap_node(pos, {name="bloc4builder:door_shop_on",param2=node.param2})
    open_door_shop(pos)
  end,
  on_switch = function(pos, node)
    minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
    minetest.swap_node(pos, {name="bloc4builder:door_shop_on",param2=node.param2})
  end,
  mesecons = {effector = {
    action_on = function(pos, node)
      minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
      minetest.swap_node(pos, {name="bloc4builder:door_shop_on",param2=node.param2})
      open_door_shop(pos)
    end,
  }},
})

minetest.register_node("bloc4builder:door_shop_on", {
	description = "door shop",
	tiles = {{ name = "b4b_door_shop.png", backface_culling = true }},
	groups = {cracky=3, switch=1,not_in_creative_inventory=1},
	drop = 'bloc4builder:door_shop',
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
  on_rightclick = function(pos, node)
    minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="bloc4builder:sas_hidden_mid",param2=node.param2})
    minetest.swap_node(pos, {name="bloc4builder:door_shop",param2=node.param2})
    closed_door_shop(pos)

  end,
  on_switch = function(pos, node)
    minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="bloc4builder:sas_hidden_mid",param2=node.param2})
    minetest.swap_node(pos, {name="bloc4builder:door_shop",param2=node.param2})
  end,
  mesecons = {effector = {
    action_off = function(pos, node)
      minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="bloc4builder:sas_hidden_mid",param2=node.param2})
      minetest.swap_node(pos, {name="bloc4builder:door_shop",param2=node.param2})
      closed_door_shop(pos)
    end,
  }},
})
--** trapdoor **
doors.register_trapdoor("bloc4builder:trapdoor_metal", {
	description = "Steel Trapdoor",
	inventory_image = "b4b_trapmetal.png",
	wield_image = "b4b_trapmetal.png",
	tile_front = "b4b_trapmetal.png",
	tile_side = "doors_trapdoor_steel_side.png",
	protected = false,
	sounds = default.node_sound_metal_defaults(),
	sound_open = "doors_steel_door_open",
	sound_close = "doors_steel_door_close",
	groups = {cracky = 1, level = 2, door = 1,not_in_creative_inventory=bloc4builder.creative_enable},
})

--** rideaux de fer **
minetest.register_node("bloc4builder:ridodefer", {
	description = "rideaux de fer",
	drawtype = "nodebox",
	tiles = {"b4b_garage.png^[transformR90"},
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
	groups = {choppy=3,switch=110,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_wood_defaults(),
  on_rotate = function(pos, node, user, mode, new_param2)
		return false
  end,
  on_rightclick = function(pos, node, player, item, _)
    minetest.chat_send_player(player:get_player_name(),"DOOR CLOSED")
	end
})

minetest.register_node("bloc4builder:ridodefer_on", {
	description = "rideaux de fer",
	drawtype = "nodebox",
	tiles = {"b4b_garage.png^[transformR90"},
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
	groups = {not_in_creative_inventory=1,switch=110},
	sounds = default.node_sound_wood_defaults(),
  on_rotate = function(pos, node, user, mode, new_param2)
		return false
  end
})

--** porte de garage **
minetest.register_node("bloc4builder:garage", {
	description="porte garage",
	tiles = {"b4b_sol_metal.png"},
	is_ground_content = true,
	groups = {cracky=3,switch=10,not_in_creative_inventory=1},
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
  end
})

minetest.register_node("bloc4builder:garage_on", {
	drawtype = "airlike",
  tiles = {"b4b_air.png"},
  use_texture_alpha = true,
	pointable = false,
	walkable = false,
	diggable = false,
	sunlight_propagates = true,
	paramtype = "light",
	drop = "bloc4builder:garage",
	groups = { not_in_creative_inventory=1,switch=10},
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

--****************
--** pont levis **
--****************
minetest.register_node("bloc4builder:pont_levis", {
	description = "pont_levis",
	drawtype = "nodebox",
	tiles = {"b4b_pont_levis.png"},
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
	groups = {choppy=3,not_in_creative_inventory=bloc4builder.creative_enable},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("bloc4builder:pont_levis_closed", {
	description = "pont_levis",
	drawtype = "nodebox",
	tiles = {"b4b_pont_levis.png"},
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

--*********************************
--** switch keypad with password **
--*********************************
minetest.register_node("bloc4builder:keypad", {
	description = "Keypad",
	tiles = {
    "b4b_code_off.png"
	},
	inventory_image = "b4b_code_off.png",
	wield_image = "b4b_code_off.png",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.4375, 0.5, 0.5, 0.5},
		},
    },
	paramtype = "light",
	paramtype2 = "facedir",
  sunlight_propagates = true,
	groups = {cracky=1, oddly_breakable_by_hand=1,not_in_creative_inventory=bloc4builder.creative_enable},
  on_construct=function(pos)
    local meta = minetest.get_meta(pos)
    meta:set_string("channel","No channel:noplayer")
    meta:set_string("code", "")
  end,
  after_place_node=function(pos,placer)
    if placer and placer:is_player() then
      local meta = minetest.get_meta(pos)
      local owner=placer:get_player_name()
      meta:set_string("channel","No channel:"..owner)
    end
	end,
	on_rightclick = function(pos, node, player, item, _)
    password_check(pos,node,player,"bloc4builder:keypad_on",2,1,"alarm_opening")
	end,
  can_dig = function(pos,player)
    if check_dig(pos,player) then return true end
    return false
   end,
	sounds = default.node_sound_glass_defaults()
})

minetest.register_node("bloc4builder:keypad_on", {
	sunlight_propagates = true,
	tiles = {
		"b4b_code_on.png"
	},
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.4375, 0.5, 0.5, 0.5},
		},
    },
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 5,
	groups = {cracky=1, oddly_breakable_by_hand=1, not_in_creative_inventory=1},
  on_construct=function(pos)
    local meta = minetest.get_meta(pos)
    meta:set_string("channel","No channel:noplayer")
    meta:set_string("code", "")
  end,
	on_rightclick = function(pos, node, player)
    password_check(pos,node,player,"bloc4builder:keypad",2,0)
	end,
  on_destruct = function (pos)
    bloc4builder.switch_on(pos,"bloc4builder:keypad",2,0)
	end,
  can_dig = function(pos,player)
    if check_dig(pos,player) then return true end
    return false
   end,
  drop="bloc4builder:keypad",
	sounds = default.node_sound_glass_defaults()
})

--***************************
--** switch poussoir 3 sec **
--***************************
minetest.register_node("bloc4builder:switch2", {
	description = "Wall impulse switch",
	tiles = {
		"b4b_bp0.png"
	},
	inventory_image = "b4b_bp0.png",
	wield_image = "b4b_bp0.png",
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
	groups = {cracky=1, oddly_breakable_by_hand=1,not_in_creative_inventory=bloc4builder.creative_enable},
  on_rightclick = function(pos,node, player)
    bloc4builder.switch_on(pos,"bloc4builder:switch2_on",3,1)
    minetest.get_node_timer(pos):start(3)
	end,
	sounds = default.node_sound_glass_defaults()
})

minetest.register_node("bloc4builder:switch2_on", {
	description = "Wall impulse switch",
	tiles = {"b4b_invisible.png","b4b_invisible.png","b4b_invisible.png","b4b_invisible.png","b4b_invisible.png",
		{
			image = "b4b_bp_animated.png",
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
    bloc4builder.switch_on(pos,"bloc4builder:switch2",3,0)
	end,
  on_destruct = function (pos)
    bloc4builder.switch_on(pos,"bloc4builder:switch2",3,0)
	end,
  on_timer = function(pos,elapsed)
    minetest.get_node_timer(pos):stop()
    bloc4builder.switch_on(pos,"bloc4builder:switch2",3,0)
  end,
  drop="bloc4builder:switch2",
	sounds = default.node_sound_glass_defaults()
})

--********************
--** REMOTE CONTROL **
--********************
minetest.register_craftitem('bloc4builder:remote_ctrl', {
  description = 'Remote control for Keypad',
  drawtype = "plantlike",
  paramtype = "light",
  tiles = {'b4b_remote_ctrl.png'},
  inventory_image = 'b4b_remote_ctrl.png',
  stack_max=1,
  groups = {dig_immediate = 3},
  sounds = default.node_sound_stone_defaults(),
  on_use = function(itemstack, user, pointed_thing)
    local nplayer = user:get_player_name()
    local code = itemstack:get_metadata()
    local pos=user:get_pos()
    local list_node=minetest.find_nodes_in_area({x=pos.x-6,y=pos.y-6,z=pos.z-6},{x=pos.x+6,y=pos.y+6,z=pos.z+6},{"bloc4builder:keypad","bloc4builder:keypad_on"})

    for i=1,#list_node do
      dst=minetest.get_node(list_node[i]) 
      dst_met=minetest.get_meta(list_node[i])
      local cha_dst=dst_met:get_string("channel")

      if cha_dst=="" then cha_dst="No channel:noplayer" end

      local cha_spl=string.split(cha_dst,":")

      if nplayer==cha_spl[2] or cha_spl[2]=="noplayer" then
        if dst_met:get_string("code")==code then
          if dst.name=="bloc4builder:keypad" then
            bloc4builder.switch_on(list_node[i],"bloc4builder:keypad_on",2,1)
          else
            bloc4builder.switch_on(list_node[i],"bloc4builder:keypad",2,0)
          end
        end
      end

    end

  end,
  on_place=function(itemstack,placer,pointed_thing)
    local nplayer = placer:get_player_name()
    if pointed_thing.type == "node" then
      node=minetest.get_node(pointed_thing.under)
      if node.name=="bloc4builder:keypad_on" or node.name=="bloc4builder:keypad" then
        nod_met=minetest.get_meta(pointed_thing.under)
        local cha_dst=nod_met:get_string("channel")

        if cha_dst=="" then cha_dst="No channel:noplayer" end

        local cha_spl=string.split(cha_dst,":")

        if nplayer==cha_spl[2] or cha_spl[2]=="noplayer" then
          local code=nod_met:get_string("code")
          itemstack:set_metadata(code)
          minetest.chat_send_player(nplayer,"CODE ACQUIRED : "..code)
          return itemstack
        end
      end
    end
    minetest.chat_send_player(nplayer,"No code or Keypad")
    return
  end
})

minetest.register_craft({
  output = 'bloc4builder:remote_ctrl',
  recipe = {
    {'','default:mese_crystal_fragment',''},
    {'','default:skeleton_key',''},
    {'','default:obsidian_shard',''},
  }
})

--**************
--** Automate **
--**************
local function ic_fields(pos,fields,sender)
  local name=sender:get_player_name()
  local meta = minetest.get_meta(pos)
  local ic=meta:get_string("ic")
  local radius=meta:get_string("radius")

  if ic=="" then ic="OFF" end
  if radius=="" then radius="5" end

  if fields.channel==nil then fields.channel="No channel" end

  if fields.radius then
    radius=fields.radius
    meta:set_string("radius",radius)
  end

  if fields.ic then
    if fields.ic=="OFF" then
      fields.ic="ON"
    else
      fields.ic="OFF"
    end
    meta:set_string("ic",fields.ic)
    meta:set_string("formspec","size[8, 4]button_exit[2,3;2,1;submit;submit]label[6,0;option]button[6,1;2,1;ic;".. fields.ic .."]field[1,1;3,1;channel;channel;".. fields.channel .."]field[1,2;1,1;radius;radius;".. radius .."]")
  end

  if fields.ic==nil then fields.ic=ic end

  if fields.submit then
    local new_node=minetest.get_node(pos)
    if fields.ic=="OFF" then
      minetest.swap_node(pos, {name="bloc4builder:ic",param2=new_node.param2})
    else
      minetest.swap_node(pos, {name="bloc4builder:ic_mese",param2=new_node.param2})
    end
    meta:set_string("channel",fields.channel)
    meta:set_string("formspec","size[8, 4]button_exit[2,3;2,1;submit;submit]label[6,0;option]button[6,1;2,1;ic;".. fields.ic .."]field[1,1;3,1;channel;channel;".. fields.channel .."]field[1,2;1,1;radius;radius;".. radius .."]")
  end
end

--basic operation

minetest.register_node("bloc4builder:ic", {
	description = "IC switch",
	tiles = {
		"b4b_ic.png"
	},
	inventory_image = "b4b_ic.png",
	wield_image = "b4b_ic.png",
	drawtype = "nodebox",
node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.495, 0.5},
		},
    },
	paramtype = "light",
	paramtype2 = "facedir",
  sunlight_propagates = true,
	groups = {cracky=1, oddly_breakable_by_hand=1,not_in_creative_inventory=bloc4builder.creative_enable},
  on_construct=function(pos)
    local meta = minetest.get_meta(pos)
    meta:set_string("channel","No channel")
    meta:set_string("ic","OFF")
    meta:set_string("radius","5")
    meta:set_string("formspec","size[8, 4]button_exit[2,3;2,1;submit;submit]label[6,0;option]button[6,1;2,1;ic;OFF]field[1,1;3,1;channel;channel;No channel]field[1,2;1,1;radius;radius;5]")
  end,
  on_receive_fields = function(pos,formname,fields,sender)
    ic_fields(pos,fields,sender)
  end,
  on_punch = function(pos,node, player)
    local meta = minetest.get_meta(pos)
    local src_chan=meta:get_string("channel")

    local radius=meta:get_string("radius")
    if radius=="" then radius="5" end

    change_switch(pos,src_chan,nil,tonumber(radius))
	end,

  mesecons = {effector = {
    action_on = function (pos, node)
      local meta = minetest.get_meta(pos)
      local src_chan=meta:get_string("channel")

      local radius=meta:get_string("radius")
      if radius=="" then radius="5" end

      change_switch(pos, src_chan,nil,tonumber(radius))
    end
  }},
	sounds = default.node_sound_glass_defaults()
})

--mesecon off

minetest.register_node("bloc4builder:ic_mese", {
	tiles = {
		"b4b_ic_mese.png"
	},
	drawtype = "nodebox",
node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.495, 0.5},
		},
    },
	paramtype = "light",
	paramtype2 = "facedir",
  sunlight_propagates = true,
	groups = {cracky=1, oddly_breakable_by_hand=1,not_in_creative_inventory=bloc4builder.creative_enable},
  on_receive_fields = function(pos,formname,fields,sender)
    ic_fields(pos,fields,sender)
  end,
  on_punch = function(pos,node, player)
    minetest.swap_node(pos, {name="bloc4builder:ic_mese_on",param2=node.param2})
    local meta = minetest.get_meta(pos)
    local src_chan=meta:get_string("channel")

    local radius=meta:get_string("radius")
    if radius=="" then radius="5" end

    change_switch(pos, src_chan,nil,tonumber(radius))
	end,

  mesecons = {effector = {
    action_on = function (pos, node)
      minetest.swap_node(pos, {name="bloc4builder:ic_mese_on",param2=node.param2})
      local meta = minetest.get_meta(pos)
      local src_chan=meta:get_string("channel")

      local radius=meta:get_string("radius")
      if radius=="" then radius="5" end

      change_switch(pos, src_chan,nil,tonumber(radius))
    end
  }},
  drop="bloc4builder:ic",
	sounds = default.node_sound_glass_defaults()
})

--mesecon on

minetest.register_node("bloc4builder:ic_mese_on", {
	tiles = {
		"b4b_ic_mese_on.png"
	},
	drawtype = "nodebox",
node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.495, 0.5},
		},
    },
	paramtype = "light",
	paramtype2 = "facedir",
  sunlight_propagates = true,
	groups = {cracky=1, oddly_breakable_by_hand=1,not_in_creative_inventory=bloc4builder.creative_enable},
  on_receive_fields = function(pos,formname,fields,sender)
    ic_fields(pos,fields,sender)
  end,
  on_punch = function(pos,node, player)
    minetest.swap_node(pos, {name="bloc4builder:ic_mese",param2=node.param2})
    local meta = minetest.get_meta(pos)
    local src_chan=meta:get_string("channel")

    local radius=meta:get_string("radius")
    if radius=="" then radius="5" end

    change_switch(pos, src_chan,nil,tonumber(radius))
	end,

  mesecons = {effector = {
    action_off = function (pos, node)
      minetest.swap_node(pos, {name="bloc4builder:ic_mese",param2=node.param2})
      local meta = minetest.get_meta(pos)
      local src_chan=meta:get_string("channel")

      local radius=meta:get_string("radius")
      if radius=="" then radius="5" end

      change_switch(pos, src_chan,nil,tonumber(radius))
    end
  }},
  drop="bloc4builder:ic",
	sounds = default.node_sound_glass_defaults()
})
--]]
