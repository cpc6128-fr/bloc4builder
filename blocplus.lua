--[[
More Blocks: registrations

Copyright © 2011-2019 Hugo Locurcio and contributors.
Licensed under the zlib license. See LICENSE.md for more information.

modif 202007 by CPC6128

--]]

local descriptions = {
	["micro"] = "Microblock",
	["slab"] = "Slab",
	["slope"] = "Slope",
	["panel"] = "Panel",
	["stair"] = "Stairs",
  ["box"] = "Fuselage",
  ["mesh"] = "Fuselage",
}

local function prepare_groups(groups)
	local result = {}
	if groups then
		for k, v in pairs(groups) do
			if k ~= "wood" and k ~= "stone" then
				result[k] = v
			end
		end
	end

  result.not_in_creative_inventory = 1

	return result
end

bloc4builder.register_single = function(category, alternate, info, modname, subname, fields , recipeitem)
	local desc_base = descriptions[category]
	local def = {}

	-- copy fields to def
	for k, v in pairs(fields) do
		def[k] = v
	end

  if category=="slope" or category=="mesh" then
    def.drawtype = "mesh"
    def.mesh = info.mesh
    def.collision_box=info.collision_box
    def.selection_box=info.selection_box
    def.description = desc_base.." "..subname
  else
    def.drawtype = "nodebox"
    --def.node_box =  info.node_box
    def.node_box = {
				type = "fixed",
				fixed = info,
			}
    def.description = desc_base.." "..subname
  end

	def.paramtype = "light"
	def.paramtype2 = def.paramtype2 or "facedir"

	-- This makes node rotation work on placement
	def.place_param2 = nil

	-- Darken light sources slightly to make up for their smaller visual size
	def.light_source = math.max(0, (def.light_source or 0) - 1)

	def.on_place = minetest.rotate_node
	def.groups = prepare_groups(fields.groups)

	
  
		if category == "stair" and alternate == "" then
			def.groups.stair = 1
		end

	if fields.drop and not (type(fields.drop) == "table") then
		def.drop = modname.. ":" .. category .. "_" .. fields.drop .. alternate
	end

	minetest.register_node(":" ..modname.. ":" .. category .. "_" .. subname .. alternate, def)

  --stairsplus.register_recipes(category, alternate, modname, subname, recipeitem)

end

-- stair
local function register_stair(modname, subname, fields , nodename)
  local defs=bloc4builder.defs["stair"]
	for alternate, def in pairs(defs) do
		bloc4builder.register_single("stair", alternate, def, modname, subname, fields , nodename)
	end

	blocsaw.known_nodes[nodename] = {modname, subname}

end

-- slab
local function register_slab(modname, subname, fields , nodename)
  local defs=bloc4builder.defs["slab"]
	for alternate, def in pairs(defs) do
		bloc4builder.register_single("slab", alternate, def, modname, subname, fields , nodename)
	end

	blocsaw.known_nodes[nodename] = {modname, subname}

end

-- slope
local function register_slope(modname, subname, fields , nodename)
  local defs=bloc4builder.defs["slope"]
	for alternate, def in pairs(defs) do
		bloc4builder.register_single("slope", alternate, def, modname, subname, fields , nodename)
	end

	blocsaw.known_nodes[nodename] = {modname, subname}

end

-- panel
local function register_panel(modname, subname, fields , nodename)
  local defs=bloc4builder.defs["panel"]
	for alternate, def in pairs(defs) do
		bloc4builder.register_single("panel", alternate, def, modname, subname, fields , nodename)
	end

	blocsaw.known_nodes[nodename] = {modname, subname}

end

-- micro
local function register_micro(modname, subname, fields , nodename)
  local defs=bloc4builder.defs["micro"]
	for alternate, def in pairs(defs) do
		bloc4builder.register_single("micro", alternate, def, modname, subname, fields , nodename)
	end

	blocsaw.known_nodes[nodename] = {modname, subname}

end

-- box
local function register_box(modname, subname, fields , nodename)
  local defs=bloc4builder.defs["box"]
	for alternate, def in pairs(defs) do
		bloc4builder.register_single("box", alternate, def, modname, subname, fields , nodename)
	end

	blocsaw.known_nodes[nodename] = {modname, subname}

end

-- mesh
local function register_mesh(modname, subname, fields , nodename)
  local defs=bloc4builder.defs["mesh"]
	for alternate, def in pairs(defs) do
		bloc4builder.register_single("mesh", alternate, def, modname, subname, fields , nodename)
	end

	blocsaw.known_nodes[nodename] = {modname, subname}

end

--moreblocks
function bloc4builder.register_moreblocks(modname, subname, fields, nodename)
	register_stair(modname, subname, fields , nodename)
	register_slab(modname, subname, fields , nodename)
	register_slope(modname, subname, fields , nodename)
	register_panel(modname, subname, fields , nodename)
	register_micro(modname, subname, fields , nodename)
end

--bloc4builder
function bloc4builder.register_b4b(modname, subname, fields, nodename)
	register_box(modname, subname, fields , nodename)
  register_mesh(modname, subname, fields , nodename)
end





