--[[
More Blocks: circular saw

Copyright © 2011-2019 Hugo Locurcio, Sokomine and contributors.
Licensed under the zlib license. See LICENSE.md for more information.

modif 202007 by CPC6128

--]]

local F = minetest.formspec_escape

blocsaw = {}

blocsaw.known_stairs = setmetatable({}, {
	__newindex = function(k, v)
		local modname = minetest.get_current_modname()
		print(("WARNING: mod %s tried to add node %s to the circular saw"
				.. " manually."):format(modname, v))
	end,
})

-- This is populated by stairsplus:register_all:
blocsaw.known_nodes = {}

-- How many microblocks does this shape at the output inventory cost:
-- It may cause slight loss, but no gain.
blocsaw.cost_in_microblocks = {
	1, 1, 1, 1, 4, 4, 4, 2,
	2, 2, 2, 2, 6, 6, 4, 7,
	4, 4, 4, 4, 6, 6, 6, 2,
	1, 2, 2, 6, 4, 2, 7, 5,
	4, 2, 6, 7, 3, 7, 7, 4,
	8, 3, 2, 6, 2, 1, 3, 4,
	8, 3, 2, 6, 2, 1, 3, 4
}
--fuse
blocsaw.names = {
	{"micro", "_1"},
	{"panel", "_1"},
	{"slab", "_1"},
	{"box", "_stairslim"},
	{"box", "_colroundtop"},
	{"box", "_colsqutop"},
	{"mesh", "_mid"},
	{"mesh", "_fuse1"},

	{"micro", ""},
	{"panel", ""},
	{"slab", ""},
	{"stair", "_half"},
	{"box", "_colround"},
	{"box", "_colsqu"},
	{"mesh", "_arche"},
	{"mesh", "_fuse2"},

	{"micro", "_15"},
	{"box", "_midslim"},
	{"box", "_tslim"},
	{"box", "_tslim2"},--_2
	{"box", "_midfat"},--_quarter
	{"box", "_tfat"},
	{"box", "_tfat2"},--_three_quarter
	{"mesh", "_fuse3"},

	{"slab", "_two_sides"},
	{"slab", "_three_sides"},
	{"slab", "_three_sides_u"},
	{"stair", ""},
	{"stair", "_alt"},
	{"stair", "_alt_1"},
	{"stair", "_inner"},
	{"stair", "_outer"},

	{"slope", ""},
	{"slope", "_half"},
	{"slope", "_half_raised"},
	{"slope", "_inner"},
	{"slope", "_inner_half"},
	{"slope", "_inner_half_raised"},
	{"slope", "_inner_cut"},
	{"slope", "_inner_cut_half"},

	{"slope", "_inner_cut_half_raised"},
	{"slope", "_outer"},
	{"slope", "_outer_half"},
	{"slope", "_outer_half_raised"},
	{"slope", "_outer_cut"},
	{"slope", "_outer_cut_half"},
	{"slope", "_outer_cut_half_raised"},
	{"slope", "_cut"},

	{"mesh", "_fuse4"},
	{"mesh", "_fuse5"},
	{"mesh", "_fuse6"},
	{"mesh", "_fuse7"},
	{"mesh", "_fuse8"},
	{"mesh", "_fuse9"},
	{"mesh", "_fusea"},
	{"mesh", "_fuseb"}
}

function blocsaw:get_cost(inv, stackname)
	for i, item in pairs(inv:get_list("output")) do
		if item:get_name() == stackname then
			return blocsaw.cost_in_microblocks[i]
		end
	end
end

function blocsaw:get_output_inv(modname, material, amount, max)
	if (not max or max < 1 or max > 99) then max = 99 end

	local list = {}
	local pos = #list

	-- If there is nothing inside, display empty inventory:
	if amount < 1 then
		return list
	end

	for i = 1, #blocsaw.names do
		local t = blocsaw.names[i]
		local cost = blocsaw.cost_in_microblocks[i]
		local balance = math.min(math.floor(amount/cost), max)
		local nodename = modname .. ":" .. t[1] .. "_" .. material .. t[2]
		if  minetest.registered_nodes[nodename] then
			pos = pos + 1
			list[pos] = nodename .. " " .. balance
		end
	end
	return list
end


-- Reset empty circular_saw after last full block has been taken out
-- (or the circular_saw has been placed the first time)
-- Note: max_offered is not reset:
function blocsaw:reset(pos)
	local meta = minetest.get_meta(pos)
	local inv  = meta:get_inventory()
	local owned_by = meta:get_string("owner")

	if owned_by and owned_by ~= "" then
		owned_by = (" (%s)"):format("owned by @1", meta:get_string("owner"))
	else
		owned_by = ""
	end

	inv:set_list("input",  {})
	inv:set_list("micro",  {})
	inv:set_list("output", {})

	meta:set_int("anz", 0)
	meta:set_string("infotext", "Circular Saw is empty" .. owned_by)
end


-- Player has taken something out of the box or placed something inside
-- that amounts to count microblocks:
function blocsaw:update_inventory(pos, amount)
	local meta          = minetest.get_meta(pos)
	local inv           = meta:get_inventory()

	amount = meta:get_int("anz") + amount

	-- The material is recycled automatically.
	inv:set_list("recycle",  {})

	if amount < 1 then -- If the last block is taken out.
		self:reset(pos)
		return
	end

	local stack = inv:get_stack("input",  1)
	-- At least one "normal" block is necessary to see what kind of stairs are requested.
	if stack:is_empty() then
		-- Any microblocks not taken out yet are now lost.
		-- (covers material loss in the machine)
		self:reset(pos)
		return

	end
	local node_name = stack:get_name() or ""
	local node_def = stack:get_definition()
	local name_parts = blocsaw.known_nodes[node_name] or ""
	local modname  = name_parts[1] or ""
	local material = name_parts[2] or ""
	local owned_by = meta:get_string("owner")

	if owned_by and owned_by ~= "" then
		owned_by = (" (%s)"):format("owned by @1", meta:get_string("owner"))
	else
		owned_by = ""
	end

	inv:set_list("input", { -- Display as many full blocks as possible:
		node_name.. " " .. math.floor(amount / 8)
	})
  -- The stairnodes made of default nodes use moreblocks namespace, other mods keep own:
	if modname == "default" then
		modname = "moreblocks"
	end
	-- print("circular_saw set to " .. modname .. " : "
	--	.. material .. " with " .. (amount) .. " microblocks.")

	-- 0-7 microblocks may remain left-over:
	inv:set_list("micro", {
		modname .. ":micro_" .. material .. " " .. (amount % 8)
	})
	-- Display:
	inv:set_list("output",
		self:get_output_inv(modname, material, amount,
				meta:get_int("max_offered")))
	-- Store how many microblocks are available:
	meta:set_int("anz", amount)

	meta:set_string("infotext",
		"Circular Saw is working on @1"
			 .. owned_by
	)
end


-- The amount of items offered per shape can be configured:
function blocsaw.on_receive_fields(pos, formname, fields, sender)
	local meta = minetest.get_meta(pos)
	local max = tonumber(fields.max_offered)
	if max and max > 0 then
		meta:set_string("max_offered",  max)
		-- Update to show the correct number of items:
		blocsaw:update_inventory(pos, 0)
	end
end


-- Moving the inventory of the circular_saw around is not allowed because it
-- is a fictional inventory. Moving inventory around would be rather
-- impractical and make things more difficult to calculate:
function blocsaw.allow_metadata_inventory_move(
		pos, from_list, from_index, to_list, to_index, count, player)
	return 0
end


-- Only input- and recycle-slot are intended as input slots:
function blocsaw.allow_metadata_inventory_put(
		pos, listname, index, stack, player)
	-- The player is not allowed to put something in there:
	if listname == "output" or listname == "micro" then
		return 0
	end

	local meta = minetest.get_meta(pos)
	local inv  = meta:get_inventory()
	local stackname = stack:get_name()
	local count = stack:get_count()

	-- Only allow those items that are offered in the output inventory to be recycled:
	if listname == "recycle" then
		if not inv:contains_item("output", stackname) then
			return 0
		end
		local stackmax = stack:get_stack_max()
		local instack = inv:get_stack("input", 1)
		local microstack = inv:get_stack("micro", 1)
		local incount = instack:get_count()
		local incost = (incount * 8) + microstack:get_count()
		local maxcost = (stackmax * 8) + 7
		local cost = blocsaw:get_cost(inv, stackname)
		if (incost + cost) > maxcost then
			return math.max((maxcost - incost) / cost, 0)
		end
		return count
	end

	-- Only accept certain blocks as input which are known to be craftable into stairs:
	if listname == "input" then
		if not inv:is_empty("input") then
			if inv:get_stack("input", index):get_name() ~= stackname then
				return 0
			end
		end
		if not inv:is_empty("micro") then
			local microstackname = inv:get_stack("micro", 1):get_name():gsub("^.+:micro_", "", 1)
			local cutstackname = stackname:gsub("^.+:", "", 1)
			if microstackname ~= cutstackname then
				return 0
			end
		end
		for name, t in pairs(blocsaw.known_nodes) do
			if name == stackname and inv:room_for_item("input", stack) then
				return count
			end
		end
		return 0
	end
end

-- Taking is allowed from all slots (even the internal microblock slot).
-- Putting something in is slightly more complicated than taking anything
-- because we have to make sure it is of a suitable material:
function blocsaw.on_metadata_inventory_put(
		pos, listname, index, stack, player)
	-- We need to find out if the circular_saw is already set to a
	-- specific material or not:
	local meta = minetest.get_meta(pos)
	local inv  = meta:get_inventory()
	local stackname = stack:get_name()
	local count = stack:get_count()

	-- Putting something into the input slot is only possible if that had
	-- been empty before or did contain something of the same material:
	if listname == "input" then
		-- Each new block is worth 8 microblocks:
		blocsaw:update_inventory(pos, 8 * count)
	elseif listname == "recycle" then
		-- Lets look which shape this represents:
		local cost = blocsaw:get_cost(inv, stackname)
		local input_stack = inv:get_stack("input", 1)
		-- check if this would not exceed input itemstack max_stacks
		if input_stack:get_count() + ((cost * count) / 8) <= input_stack:get_stack_max() then
			blocsaw:update_inventory(pos, cost * count)
		end
	end
end

function blocsaw.allow_metadata_inventory_take(pos, listname, index, stack, player)
	local meta          = minetest.get_meta(pos)
	local inv           = meta:get_inventory()
	local input_stack = inv:get_stack(listname,  index)
	local player_inv = player:get_inventory()
	if not player_inv:room_for_item("main", input_stack) then
		return 0
	else return stack:get_count()
	end
end

function blocsaw.on_metadata_inventory_take(
		pos, listname, index, stack, player)

	-- Prevent (inbuilt) swapping between inventories with different blocks
	-- corrupting player inventory or Saw with 'unknown' items.
	local meta          = minetest.get_meta(pos)
	local inv           = meta:get_inventory()
	local input_stack = inv:get_stack(listname,  index)
	if not input_stack:is_empty() and input_stack:get_name()~=stack:get_name() then
		local player_inv = player:get_inventory()
		if player_inv:room_for_item("main", input_stack) then
			player_inv:add_item("main", input_stack)
		end

		blocsaw:reset(pos)
		return
	end

	-- If it is one of the offered stairs: find out how many
	-- microblocks have to be subtracted:
	if listname == "output" then
		-- We do know how much each block at each position costs:
		local cost = blocsaw.cost_in_microblocks[index]
				* stack:get_count()

		blocsaw:update_inventory(pos, -cost)
	elseif listname == "micro" then
		-- Each microblock costs 1 microblock:
		blocsaw:update_inventory(pos, -stack:get_count())
	elseif listname == "input" then
		-- Each normal (= full) block taken costs 8 microblocks:
		blocsaw:update_inventory(pos, 8 * -stack:get_count())
	end
	-- The recycle field plays no role here since it is processed immediately.
end

function blocsaw.on_construct(pos)
	local meta = minetest.get_meta(pos)
	local fancy_inv = default.gui_bg..default.gui_bg_img..default.gui_slots
	meta:set_string(
		"formspec", "size[11,11]"..fancy_inv..
		"label[0,0;" ..F("Input\nmaterial").. "]" ..
		"list[current_name;input;1.5,0;1,1;]" ..
		"label[0,1;" ..F("Left-over").. "]" ..
		"list[current_name;micro;1.5,1;1,1;]" ..
		"label[0,2;" ..F("Recycle\noutput").. "]" ..
		"list[current_name;recycle;1.5,2;1,1;]" ..
		"field[0.3,3.5;1,1;max_offered;" ..F("Max").. ":;${max_offered}]" ..
		"button[1,3.2;1,1;Set;" ..F("Set").. "]" ..
		"list[current_name;output;2.8,0;8,7;]" ..
		"list[current_player;main;1.5,7.25;8,4;]" ..
		"listring[current_name;output]" ..
		"listring[current_player;main]" ..
		"listring[current_name;input]" ..
		"listring[current_player;main]" ..
		"listring[current_name;micro]" ..
		"listring[current_player;main]" ..
		"listring[current_name;recycle]" ..
		"listring[current_player;main]"
	)

	meta:set_int("anz", 0) -- No microblocks inside yet.
	meta:set_string("max_offered", 8) -- How many items of this kind are offered by default?
	meta:set_string("infotext", "Circular Saw is empty")

	local inv = meta:get_inventory()
	inv:set_size("input", 1)    -- Input slot for full blocks of material x.
	inv:set_size("micro", 1)    -- Storage for 1-7 surplus microblocks.
	inv:set_size("recycle", 1)  -- Surplus partial blocks can be placed here.
	inv:set_size("output", 7*8) -- 6x8 versions of stair-parts of material x.

	blocsaw:reset(pos)
end


function blocsaw.can_dig(pos,player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	if not inv:is_empty("input") or
	   not inv:is_empty("micro") or
	   not inv:is_empty("recycle") then
		return false
	end
	-- Can be dug by anyone when empty, not only by the owner:
	return true
end

minetest.register_node("bloc4builder:circular_saw",  {
	description = "Circular Saw",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4, -0.5, -0.4, -0.25, 0.25, -0.25}, -- Leg
			{0.25, -0.5, 0.25, 0.4, 0.25, 0.4}, -- Leg
			{-0.4, -0.5, 0.25, -0.25, 0.25, 0.4}, -- Leg
			{0.25, -0.5, -0.4, 0.4, 0.25, -0.25}, -- Leg
			{-0.5, 0.25, -0.5, 0.5, 0.375, 0.5}, -- Tabletop
			{-0.01, 0.4375, -0.125, 0.01, 0.5, 0.125}, -- Saw blade (top)
			{-0.01, 0.375, -0.1875, 0.01, 0.4375, 0.1875}, -- Saw blade (bottom)
			{-0.25, -0.0625, -0.25, 0.25, 0.25, 0.25}, -- Motor case
		},
	},
	tiles = {"moreblocks_circular_saw_top.png",
		"moreblocks_circular_saw_bottom.png",
		"moreblocks_circular_saw_side.png"},
	paramtype = "light",
	sunlight_propagates = true,
	paramtype2 = "facedir",
	groups = {choppy = 2,oddly_breakable_by_hand = 2},
	sounds = default.node_sound_wood_defaults(),
	on_construct = blocsaw.on_construct,
	can_dig = blocsaw.can_dig,
	-- Set the owner of this circular saw.
	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		local owner = placer and placer:get_player_name() or ""
		local owned_by = owner

		if owner ~= "" then
			owned_by = "owned by ".. owner
		end

		meta:set_string("owner",  owner)
		meta:set_string("infotext", "Circular Saw is empty" .. owned_by)
	end,

	-- The amount of items offered per shape can be configured:
	on_receive_fields = blocsaw.on_receive_fields,
	allow_metadata_inventory_move = blocsaw.allow_metadata_inventory_move,
	-- Only input- and recycle-slot are intended as input slots:
	allow_metadata_inventory_put = blocsaw.allow_metadata_inventory_put,
	allow_metadata_inventory_take = blocsaw.allow_metadata_inventory_take,
	-- Taking is allowed from all slots (even the internal microblock slot). Moving is forbidden.
	-- Putting something in is slightly more complicated than taking anything because we have to make sure it is of a suitable material:
	on_metadata_inventory_put = blocsaw.on_metadata_inventory_put,
	on_metadata_inventory_take = blocsaw.on_metadata_inventory_take,
})

minetest.register_craft({
		output = "bloc4builder:circular_saw",
		recipe = {
			{ "",  "default:copper_ingot",  "" },
			{ "group:stone",  "group:stone",  "group:stone"},
			{ "group:stone",  "",  "group:stone"},
		}
	})
