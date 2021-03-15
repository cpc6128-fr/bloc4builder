doors.register("door_submarine", {
		tiles = {"b4b_submarine_door.png"},
		description = "Submarine Door",
		inventory_image = "b4b_submarine_door_inv.png",
		groups = {cracky=3},
		sounds = default.node_sound_metal_defaults(),
		sound_open = "doors_steel_door_open",
		sound_close = "doors_steel_door_close",
		recipe = {
			{"default:steel_ingot", "default:obsidian_glass"},
			{"default:steel_ingot", "default:copper_ingot"},
			{"default:steel_ingot", "default:steel_ingot"},
		},
})

