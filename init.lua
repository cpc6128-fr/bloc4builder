--***********************************************
--** BLOC4BUILDER by Philippe Romand 2019/2020 **
--***********************************************
-- License WTFPL TODO list des licenses
-- Do files
bloc4builder={}

bloc4builder.creative_enable=1

dofile(minetest.get_modpath("bloc4builder") .. "/blocsaw.lua")
dofile(minetest.get_modpath("bloc4builder") .. "/defs.lua")
dofile(minetest.get_modpath("bloc4builder") .. "/blocplus.lua")
dofile(minetest.get_modpath("bloc4builder") .. "/nodes.lua")
dofile(minetest.get_modpath("bloc4builder") .. "/switch.lua")
dofile(minetest.get_modpath("bloc4builder") .. "/flyer.lua")
dofile(minetest.get_modpath("bloc4builder") .. "/signal.lua")
dofile(minetest.get_modpath("bloc4builder") .. "/door.lua")

--the builder node
local items = {
"mur_02 99",
"pavement01 99",
"pavement02 99",
"pavement03 99",
"pierre_02 99",
"pierre_doree 99",
"granit 50",
"granit_broken 99",
"marble 50",
"road_separator 50",
"road_warning 25",
"road_fleche 25",
"road_neutre 99",
"cloison 25",
"army 50",
"red 50",
"green 50",
"blue 50",
"yellow 50",
"orange 50",
"purple 50",
"black 50",
"white 50",
"rainbow 50",
"tanker 50",
"tole_a 50",
"tole_b 50",
"tole_c 50",
"containerb4b 50",
"metal_floor 50",
"electro 50",
"electro2 50",
"motif 50",
"climatiser 25",
"mur_station1 25",
"mur_station2 25",
"beton 75",
"concrete 75",
"connect 25",
"connect2 25",
"connect_short 25",
"connect2_short 25",
"connect_x 25",
"street_lamp 15",
"metal_x_connect 15",
"metal_z_connect 15",
"metal_i_connect 15",
"support_metal_i 15",
"support_metal 15",
"ladder 5",
"light_on 20",
"photovoltaic 10",
"rack 5",
"pont_levis 2",
"hub 1",
"sas1 1",
"sas2 1",
"sas4 1",
"door 1",
"door_shop 2",
"trapdoor_metal 1",
"ridodefer 1",
"garage 5",
"keypad 5",
"switch2 10",
"lift 15",
"lamp 4",
"glass_chained 25",
"building_glass 25",
"guardrail_glass 25",
"guardrail_glass_angle 12",
"girophare 1",
"astroport_light 10",
"ic 2",
"tricolor_1 4",
"rail_signal_flag 2",
"rail_signal 2",
}

local money="default:steel_ingot 10"

if minetest.get_modpath("currency") then
  money="currency:minegeld_10"
end

local b4b_formspec = 
	"size[9,9]" ..
  "button_exit[0,3;2,1;exit;exit]"..
  "item_image_button[0.5,1;1,1;"..money..";price;]"..
	"list[current_player;main;0,4.85;8,1;]" ..
	"list[current_player;main;0,6.08;8,3;8]"..
  "textlist[2,1;5,3;b4b;"
local b4b_showitem="item_image_button[7,1;2,2;"..money..";buy;]"

for i=1,#items do
  if i<#items then
    b4b_formspec = b4b_formspec..items[i]..","
  else
    b4b_formspec = b4b_formspec..items[i].."]"
  end
end

minetest.register_node("bloc4builder:builder", {
	description = "bloc4builder Node Builder",
	tiles = {
		"b4b_builder_side.png",
		"b4b_builder_side.png",
		"b4b_builder_side.png",
		"b4b_builder_side.png",
		"b4b_builder_back.png",
		"b4b_builder_front.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky=1, oddly_breakable_by_hand=1},
  on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", b4b_formspec)
		meta:set_string("infotext", "Bloc4Builder Dealer")
	end,
  on_receive_fields=function(pos,formname,fields,sender)

    if fields.b4b then --choix item
      local showitem=string.split(fields.b4b,":")
      local nb=tonumber(showitem[2])
      local meta = minetest.get_meta(pos)
      b4b_showitem="item_image_button[7,1;2,2;bloc4builder:".. items[nb] ..";buy:".. nb ..";]"
      meta:set_string("formspec", b4b_formspec..b4b_showitem)
    end

    if string.find(dump(fields),"buy:")~=nil then --achat bloc
      for k, v in pairs(fields) do
        trade = tostring(k)
      end
      local showitem=string.split(trade,":")
      local nb=tonumber(showitem[2])
      local stack="bloc4builder:"..items[nb]
      local inv = sender:get_inventory()
      local name=sender:get_player_name()

      if inv:contains_item("main",money) then --si money presente
        inv:remove_item("main", money)
        inv:add_item("main",stack)
      end
    end
  end
})

minetest.register_craft({
    output = "bloc4builder:builder",
    recipe = {
        {"group:stone", "group:stone", "group:stone"},
        {"default:steel_ingot", "default:wood", "default:steel_ingot"}
    }
})

if not minetest.get_modpath("spacengine") then
minetest.register_craftitem( ":spacengine:tool", {
	description = "tools spacengine",
	inventory_image = "b4b_clef.png",
})

minetest.register_craft({
    output = "spacengine:tool",
    recipe = {
        {"default:mese_crystal", "", ""},
        {"", "default:steel_ingot", ""},
        {"", "", "default:steel_ingot"}
    }
})
end

--replace old node
dofile(minetest.get_modpath("bloc4builder") .. "/patch.lua")
