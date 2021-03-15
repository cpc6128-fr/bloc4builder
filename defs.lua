--[[
More Blocks: registrations

Copyright © 2011-2019 Hugo Locurcio and contributors.
Licensed under the zlib license. See LICENSE.md for more information.

modif 202007 by CPC6128
box
mesh

--]]
local arche_box = {
	type = "fixed",
	fixed = {{-0.5, -0.5, -0.5, 0.5, -0.375, 0.5}, -- NodeBox1
			{-0.375, -0.375, -0.5, -0.25, 0.15, 0.5}, -- NodeBox2
			{-0.5, -0.375, -0.5, -0.375, 0.5, 0.5}, -- NodeBox3
			{-0.25, -0.375, -0.5, 0.15, -0.25, 0.5}, -- NodeBox4
}
}

local fuse1_box={
	type = "fixed",
	fixed = {{-0.5, -0.5, 0, -0.4375, 0.5, 0.5}, -- NodeBox1
			{-0.5, -0.5, 0.4375, 0, 0.5, 0.5}, -- NodeBox2
			{-0.4375, -0.5, 0.1875, -0.1875, 0.5, 0.4375}, -- NodeBox3
}
}

local fuse2_box={
	type = "fixed",
	fixed = {{-0.5, -0.5, -0.5, 0, 0.5, 0.5}, -- NodeBox1
			{0, -0.5, 0, 0.5, 0.5, 0.5}, -- NodeBox2
{0, -0.5, -0.25, 0.25, 0.5, 0}
}
}

local fuse3_box={
	type = "fixed",
	fixed = {{-0.5, -0.5, 0, -0.375, 0.5, 0.125}, -- NodeBox1
			{-0.375, -0.5, 0.125, -0.25, 0.5, 0.25}, -- NodeBox2
{-0.25, -0.5, 0.25, -0.125, 0.5, 0.375},
{-0.125, -0.5, 0.375, 0, 0.5, 0.5}
}
}


local angledglass={
		type = "fixed",
		fixed = {
			{0.375, -0.5, 0.375, 0.5, 0.5, 0.5},
			{-0.5, -0.5, -0.5, -0.375, 0.5, -0.375},
			{-0.4375, -0.5, -0.4375, -0.3125, 0.5, -0.3125},
			{0.3125, -0.5, 0.3125, 0.4375, 0.5, 0.4375},
			{0.25, -0.5, 0.25, 0.375, 0.5, 0.375},
			{-0.375, -0.5, -0.375, -0.25, 0.5, -0.25},
			{0.1875, -0.5, 0.1875, 0.3125, 0.5, 0.3125},
			{-0.3125, -0.5, -0.3125, -0.1875, 0.5, -0.1875},
			{0.125, -0.5, 0.125, 0.25, 0.5, 0.25},
			{-0.25, -0.5, -0.25, -0.125, 0.5, -0.125},
			{0.0625, -0.5, 0.0625, 0.1875, 0.5, 0.1875},
			{-0.1875, -0.5, -0.1875, -0.0625, 0.5, -0.0625},
			{0, -0.5, 0, 0.125, 0.5, 0.125},
			{-0.125, -0.5, -0.125, 0, 0.5, 0},
			{-0.0625, -0.5, -0.0625, 0.0625, 0.5, 0.0625},
		}
	}

local box_slope = {
	type = "fixed",
	fixed = {
		{-0.5,  -0.5,  -0.5, 0.5, -0.25, 0.5},
		{-0.5, -0.25, -0.25, 0.5,     0, 0.5},
		{-0.5,     0,     0, 0.5,  0.25, 0.5},
		{-0.5,  0.25,  0.25, 0.5,   0.5, 0.5}
	}
}

local box_slope_half = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5,   -0.5,  0.5, -0.375, 0.5},
		{-0.5, -0.375, -0.25, 0.5, -0.25,  0.5},
		{-0.5, -0.25,  0,    0.5, -0.125, 0.5},
		{-0.5, -0.125, 0.25, 0.5,  0,     0.5},
	}
}

local box_slope_half_raised = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5,   -0.5,  0.5, 0.125, 0.5},
		{-0.5, 0.125, -0.25, 0.5, 0.25,  0.5},
		{-0.5, 0.25,  0,    0.5, 0.375, 0.5},
		{-0.5, 0.375, 0.25, 0.5,  0.5,     0.5},
	}
}

--==============================================================

local box_slope_inner = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5, -0.5, 0.5, -0.25, 0.5},
		{-0.5, -0.5, -0.25, 0.5, 0, 0.5},
		{-0.5, -0.5, -0.5, 0.25, 0, 0.5},
		{-0.5, 0, -0.5, 0, 0.25, 0.5},
		{-0.5, 0, 0, 0.5, 0.25, 0.5},
		{-0.5, 0.25, 0.25, 0.5, 0.5, 0.5},
		{-0.5, 0.25, -0.5, -0.25, 0.5, 0.5},
	}
}

local box_slope_inner_half = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5, -0.5, 0.5, -0.375, 0.5},
		{-0.5, -0.375, -0.25, 0.5, -0.25, 0.5},
		{-0.5, -0.375, -0.5, 0.25, -0.25, 0.5},
		{-0.5, -0.25, -0.5, 0, -0.125, 0.5},
		{-0.5, -0.25, 0, 0.5, -0.125, 0.5},
		{-0.5, -0.125, 0.25, 0.5, 0, 0.5},
		{-0.5, -0.125, -0.5, -0.25, 0, 0.5},
	}
}

local box_slope_inner_half_raised = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5, -0.5, 0.5, 0.125, 0.5},
		{-0.5, 0.125, -0.25, 0.5, 0.25, 0.5},
		{-0.5, 0.125, -0.5, 0.25, 0.25, 0.5},
		{-0.5, 0.25, -0.5, 0, 0.375, 0.5},
		{-0.5, 0.25, 0, 0.5, 0.375, 0.5},
		{-0.5, 0.375, 0.25, 0.5, 0.5, 0.5},
		{-0.5, 0.375, -0.5, -0.25, 0.5, 0.5},
	}
}

--==============================================================

local box_slope_outer = {
	type = "fixed",
	fixed = {
		{-0.5,  -0.5,  -0.5,   0.5, -0.25, 0.5},
		{-0.5, -0.25, -0.25,  0.25,     0, 0.5},
		{-0.5,     0,     0,     0,  0.25, 0.5},
		{-0.5,  0.25,  0.25, -0.25,   0.5, 0.5}
	}
}

local box_slope_outer_half = {
	type = "fixed",
	fixed = {
		{-0.5,  -0.5,  -0.5,   0.5, -0.375, 0.5},
		{-0.5, -0.375, -0.25,  0.25, -0.25, 0.5},
		{-0.5,  -0.25,     0,     0, -0.125, 0.5},
		{-0.5,  -0.125,  0.25, -0.25, 0, 0.5}
	}
}

local box_slope_outer_half_raised = {
	type = "fixed",
	fixed = {
		{-0.5,  -0.5,  -0.5,   0.5, 0.125, 0.5},
		{-0.5, 0.125, -0.25,  0.25, 0.25, 0.5},
		{-0.5,  0.25,     0,     0, 0.375, 0.5},
		{-0.5,  0.375,  0.25, -0.25, 0.5, 0.5}
	}
}

bloc4builder.defs = {
--***
["box1"]={
    --colone ronde
    ["_colroundtop"] =
        {
        {-0.125, -0.5, -0.25, 0.125, 0.5, 0.25}, -- NodeBox1
        {-0.1875, -0.5, -0.1875, -0.125, 0.5, 0.1875}, -- NodeBox2
        {0.125, -0.5, -0.1875, 0.1875, 0.5, 0.1875}, -- NodeBox3
        {-0.25, -0.5, -0.125, -0.1875, 0.5, 0.125}, -- NodeBox4
        {0.1875, -0.5, -0.125, 0.25, 0.5, 0.125}, -- NodeBox5
        },
    --colone ronde bas
		["_colround"] =
			{
			{-0.125, -0.25, -0.25, 0.125, 0.5, 0.25}, -- NodeBox1
			{-0.1875, -0.25, -0.1875, -0.125, 0.5, 0.1875}, -- NodeBox2
			{0.125, -0.25, -0.1875, 0.1875, 0.5, 0.1875}, -- NodeBox3
			{-0.25, -0.25, -0.125, -0.1875, 0.5, 0.125}, -- NodeBox4
			{0.1875, -0.25, -0.125, 0.25, 0.5, 0.125}, -- NodeBox5
			{-0.3125, -0.375, -0.3125, 0.3125, -0.25, 0.3125}, -- NodeBox6
			{-0.375, -0.5, -0.375, 0.375, -0.375, 0.375}, -- NodeBox12
			},
    --colone carre
		["_colsqutop"] ={-0.25, -0.5, -0.25, 0.25, 0.5, 0.25},
    --colone carre bas
		["_colsqu"] =
      {
      {-0.25, -0.25, -0.25, 0.25, 0.5, 0.25},
      {-0.5, -0.5, -0.5, 0.5, -0.375, 0.5},
      {-0.375, -0.375, -0.375, 0.375, -0.25, 0.375},
      },
    --3/slim _15
    ["_stairslim"] =
			{
      {-0.5, -0.5, -0.5, 0, -0.4375, 0.5},
      {0, -0.5, 0, 0.5, -0.4375, 0.5},
      },
    --middle demi
		["_midfat"] = {-0.5, -0.5, -0.25, 0.5, 0.5, 0.25},
    --t fat
		["_tfat"] =
      {
      {-0.5, -0.5, -0.5, 0, 0.5, 0.5},
      {0, -0.5, -0.25, 0.5, 0.5, 0.25},
      },
  },
["box2"]={
    --middle slim
		["_midslim"] = {-0.5, -0.5, -0.03125, 0.5, 0.5, 0.03125},
    --t slim
		["_tslim"] =
			{
      {-0.5, -0.5, -0.5, -0.4375, 0.5, 0.5},
      {-0.4375, -0.5, -0.03125, 0.5, 0.5, 0.03125},
      },
    --t slim
    ["_tslim2"] =
      {
      {-0.5, -0.5, -0.03125, 0.5, 0.5, 0.03125},
      {-0.03125, -0.5, -0.5, 0.03125, 0.5, -0.03125},
      },
    --t fat2
		["_tfat2"] =
      {
      {-0.5, -0.5, -0.25, 0.5, 0.5, 0.25},
      {-0.25, -0.5, -0.5, 0.25, 0.5, -0.25},
      },
},
--***
["mesh1"]={
    ["_fuse1"] = {
			mesh = "coin_oblique.obj",
			collision_box = fuse1_box,
			selection_box = fuse1_box,
		},
		["_fuse2"] = {
			mesh = "bloc_coin.obj",
			collision_box = fuse2_box,
			selection_box = fuse2_box,
		},
    ["_arche"] = {
			mesh = "arc.obj",
			collision_box = arche_box,
			selection_box = arche_box,
		}
},
--***
["mesh2"]={
		["_fuse3"] = {
			mesh = "cloison_oblique_demi.obj",
			collision_box = fuse3_box,
			selection_box = fuse3_box,
		},
		["_mid"] = {
			mesh = "cloison_oblique.obj",
			collision_box = angledglass,
			selection_box = angledglass,
		},
		["_fuse4"] = {
			mesh = "fuselage_01.obj",
			collision_box = {
        type = "fixed",
        fixed = {
          {-0.5, -0.5, -0.5, 0.5, 0, -0.25},
          {-0.5, 0, -0.25, 0.5, 0.5, 0}
        }
      },
			selection_box = {
        type = "fixed",
        fixed = {
          {-0.5, -0.5, -0.5, 0.5, 0, -0.25},
          {-0.5, 0, -0.25, 0.5, 0.5, 0}
        }
      },
		},
		["_fuse5"] = {
			mesh = "fuselage_02.obj",
			collision_box = {
        type = "fixed",
        fixed = {
          {-0.5, -0.5, -0.5, -0.25, 0, -0.25},
          {-0.25, -0.5, -0.25, 0, 0, 0},
          {0, -0.5, 0, 0.25, 0, 0.25},
          {0.25, -0.5, 0.25, 0.5, 0, 0.5},
          {-0.5, 0, -0.25, -0.25, 0.5, 0},
          {-0.25, 0, 0, 0, 0.5, 0.25},
          {0, 0, 0.25, 0.25, 0.5, 0.5}
        }
      },
			selection_box = {
        type = "fixed",
        fixed = {
          {-0.5, -0.5, -0.5, -0.25, 0, -0.25},
          {-0.25, -0.5, -0.25, 0, 0, 0},
          {0, -0.5, 0, 0.25, 0, 0.25},
          {0.25, -0.5, 0.25, 0.5, 0, 0.5},
          {-0.5, 0, -0.25, -0.25, 0.5, 0},
          {-0.25, 0, 0, 0, 0.5, 0.25},
          {0, 0, 0.25, 0.25, 0.5, 0.5}
        }
      },
		},
		["_fuse6"] = {
			mesh = "fuselage_03.obj",
			collision_box = {
        type = "fixed",
        fixed = {{-0.5, -0.5, 0, 0, 0, 0.5},{-0.5, 0, 0.4, -0.4, 0.5, 0.5}}
      },
			selection_box = {
        type = "fixed",
        fixed = {{-0.5, -0.5, 0, 0, 0, 0.5},{-0.5, 0, 0.4, -0.4, 0.5, 0.5}}
      },
    },
		["_fuse7"] = {
			mesh = "fuselage_04.obj",
			collision_box = {
        type = "fixed",
        fixed = {{-0.5, -0.5, 0, 0, 0, 0.5}}
      },
			selection_box = {
        type = "fixed",
        fixed = {{-0.5, -0.5, 0, 0, 0, 0.5}}
      },
		},
		["_fuse8"] = {
			mesh = "fuselage_05.obj",
			collision_box = {
        type = "fixed",
        fixed = {
          {-0.5, -0.5, -0.5, -0.25, 0, -0.25},
          {-0.25, -0.5, -0.25, 0, 0, 0},
          {0, -0.5, 0, 0.25, 0, 0.25},
          {0.25, -0.5, 0.25, 0.5, 0, 0.5},
          {-0.5, 0, -0.25, -0.25, 0.5, 0},
          {-0.25, 0, 0, 0, 0.5, 0.25},
          {0, 0, 0.25, 0.25, 0.5, 0.5}
        }
      },
			selection_box = {
        type = "fixed",
        fixed = {
          {-0.5, -0.5, -0.5, -0.25, 0, -0.25},
          {-0.25, -0.5, -0.25, 0, 0, 0},
          {0, -0.5, 0, 0.25, 0, 0.25},
          {0.25, -0.5, 0.25, 0.5, 0, 0.5},
          {-0.5, 0, -0.25, -0.25, 0.5, 0},
          {-0.25, 0, 0, 0, 0.5, 0.25},
          {0, 0, 0.25, 0.25, 0.5, 0.5}
        }
      },
		},
		["_fuse9"] = {
			mesh = "fuselage_07.obj",
			collision_box = {
        type = "fixed",
        fixed = {
          {-0.5, -0.5, -0.5, 0, 0, 0.5},
          {0, -0.5, 0, 0.5, 0, 0.5}
        }
      },
      selection_box = {
        type = "fixed",
        fixed = {
          {-0.5, -0.5, -0.5, 0, 0, 0.5},
          {0, -0.5, 0, 0.5, 0, 0.5}
        }
      },
		},
		["_fusea"] = {
			mesh = "arc_cloison.obj",
			collision_box = arche_box,
			selection_box = arche_box,
		},
		["_fuseb"] = {
			mesh = "coupole.obj",
			collision_box = {
        type = "fixed",
        fixed = {
          {-0.5, 0, 0.25, -0.25, 0.5, 0.5},
          {-0.25, 0, 0, 0, 0.5, 0.25},
          {0, 0, -0.25, 0.25, 0.5, 0},
          {0.25, 0, -0.5, 0.5, 0.5, -0.25},
          {-0.25, -0.25, 0.25, 0, 0, 0.5},
          {0, -0.25, 0, 0.25, 0, 0.25},
          {0.25, -0.25, -0.25, 0.5, 0, 0},
          {0, -0.5, 0, 0.5, -0.25, 0.5}
        }
      },
			selection_box = {
        type = "fixed",
        fixed = {
          {-0.5, 0, 0.25, -0.25, 0.5, 0.5},
          {-0.25, 0, 0, 0, 0.5, 0.25},
          {0, 0, -0.25, 0.25, 0.5, 0},
          {0.25, 0, -0.5, 0.5, 0.5, -0.25},
          {-0.25, -0.25, 0.25, 0, 0, 0.5},
          {0, -0.25, 0, 0.25, 0, 0.25},
          {0.25, -0.25, -0.25, 0.5, 0, 0},
          {0, -0.5, 0, 0.5, -0.25, 0.5}
        }
      },
		}
  },
--***
	["micro"] = {
		[""] ={-0.5, -0.5, 0, 0, 0, 0.5},
		["_1"] ={-0.5, -0.5, 0, 0, -0.4375, 0.5},
    --full
		["_15"] ={-0.5, -0.5, 0, 0, 0.5, 0.5},
  },
--***
	["panel"] = {
		[""] ={-0.5, -0.5, 0, 0.5, 0, 0.5},
		["_1"] ={-0.5, -0.5, 0, 0.5, -0.4375, 0.5},
	},
--***
	["slab"] = {
		[""] ={-0.5, -0.5, -0.5, 0.5, (8/16)-0.5, 0.5},
		["_1"] ={-0.5, -0.5, -0.5, 0.5, (1/16)-0.5, 0.5},
		["_two_sides"] =
      {
      { -0.5, -0.5, -0.5, 0.5, -7/16, 7/16 },
      { -0.5, -0.5, 7/16, 0.5, 0.5, 0.5 }
      },
		["_three_sides"] =
      {
      { -7/16, -0.5, -0.5, 0.5, -7/16, 7/16 },
      { -7/16, -0.5, 7/16, 0.5, 0.5, 0.5 },
      { -0.5, -0.5, -0.5, -7/16, 0.5, 0.5 }
      },
		["_three_sides_u"] =
      {
      { -0.5, -0.5, -0.5, 0.5, 0.5, -7/16 },
      { -0.5, -0.5, -7/16, 0.5, -7/16, 7/16 },
      { -0.5, -0.5, 7/16, 0.5, 0.5, 0.5 }
      },
  },
--***
	["slope"] = {
		[""] = {
			mesh = "slope.obj",
			collision_box = box_slope,
			selection_box = box_slope,

		},
		["_half"] = {
			mesh = "slope_half.obj",
			collision_box = box_slope_half,
			selection_box = box_slope_half,
		},
		["_half_raised"] = {
			mesh = "slope_half_raised.obj",
			collision_box = box_slope_half_raised,
			selection_box = box_slope_half_raised,
		},

		--==============================================================

		["_inner"] = {
			mesh = "slope_inner.obj",
			collision_box = box_slope_inner,
			selection_box = box_slope_inner,
		},
		["_inner_half"] = {
			mesh = "slope_inner_half.obj",
			collision_box = box_slope_inner_half,
			selection_box = box_slope_inner_half,
		},
		["_inner_half_raised"] = {
			mesh = "slope_inner_half_raised.obj",
			collision_box = box_slope_inner_half_raised,
			selection_box = box_slope_inner_half_raised,
		},

		--==============================================================

		["_inner_cut"] = {
			mesh = "slope_inner_cut.obj",
			collision_box = box_slope_inner,
			selection_box = box_slope_inner,
		},
		["_inner_cut_half"] = {
			mesh = "slope_inner_cut_half.obj",
			collision_box = box_slope_inner_half,
			selection_box = box_slope_inner_half,
		},
		["_inner_cut_half_raised"] = {
			mesh = "slope_inner_cut_half_raised.obj",
			collision_box = box_slope_inner_half_raised,
			selection_box = box_slope_inner_half_raised,
		},

		--==============================================================

		["_outer"] = {
			mesh = "slope_outer.obj",
			collision_box = box_slope_outer,
			selection_box = box_slope_outer,
		},
		["_outer_half"] = {
			mesh = "slope_outer_half.obj",
			collision_box = box_slope_outer_half,
			selection_box = box_slope_outer_half,
		},
		["_outer_half_raised"] = {
			mesh = "slope_outer_half_raised.obj",
			collision_box = box_slope_outer_half_raised,
			selection_box = box_slope_outer_half_raised,
		},

		--==============================================================

		["_outer_cut"] = {
			mesh = "slope_outer_cut.obj",
			collision_box = box_slope_outer,
			selection_box = box_slope_outer,
		},
		["_outer_cut_half"] = {
			mesh = "slope_outer_cut_half.obj",
			collision_box = box_slope_outer_half,
			selection_box = box_slope_outer_half,
		},
		["_outer_cut_half_raised"] = {
			mesh = "slope_outer_cut_half_raised.obj",
			collision_box = box_slope_outer_half_raised,
			selection_box = box_slope_outer_half_raised,
		},
		["_cut"] = {
			mesh = "slope_cut.obj",
			collision_box = box_slope_outer,
			selection_box = box_slope_outer,
		},
		
	},
--***
	["stair"] = {
    --norm
		[""] =
      {
      {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
      {-0.5, 0, 0, 0.5, 0.5, 0.5},
      },
    --demi
		["_half"] =
      {
      {-0.5, -0.5, -0.5, 0, 0, 0.5},
      {-0.5, 0, 0, 0, 0.5, 0.5},
      },
		["_inner"] =
      {
      {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
      {-0.5, 0, 0, 0.5, 0.5, 0.5},
      {-0.5, 0, -0.5, 0, 0.5, 0},
      },
		["_outer"] =
      {
      {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
      {-0.5, 0, 0, 0, 0.5, 0.5},
      },
    --demi alt
		["_alt"] =
      {
      {-0.5, -0.5, -0.5, 0.5, 0, 0},
      {-0.5, 0, 0, 0.5, 0.5, 0.5},
      },
    --slim alt
		["_alt_1"] =
      {
      {-0.5, -0.0625, -0.5, 0.5, 0, 0},
      {-0.5, 0.4375, 0, 0.5, 0.5, 0.5},
      },
    },
}
