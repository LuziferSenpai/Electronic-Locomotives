require "config"

local m = "__Electronic_Locomotives__"
local utd = util.table.deepcopy

Senpais.Functions.Create.Electronic_Locomotive = function( mp, n, h, w, s, c, g, su, o, st, ig, t )
	local i =
	{
		{ icon = m .. "/graphics/diesel-locomotive-base.png", icon_size = 32 },
		{ icon = m .. "/graphics/diesel-locomotive-mask.png", icon_size = 32, tint = util.color( c ) }
	}
	local te = utd( data.raw["locomotive"]["locomotive"] )
	te.name = n
	te.icon = nil
	te.icons = i
	te.minable.result = n
	te.max_health = h
	te.weight = w
	te.max_speed = s
	te.max_power = mp
	te.burner =
	{
		fuel_category = "electronic",
		effictivity = 1,
		fuel_inventory_size = 1
	}

	for _, l in pairs( te.pictures.layers ) do
		if l.apply_runtime_tint == true then
			for i = 1, 8 do
				l.filenames[i] = m .. "/graphics/mask-" .. i .. ".png"
			end
			for i = 1, 16 do
				l.hr_version.filenames[i] = m .. "/graphics/hr-mask-" .. i .. ".png"
			end
			break
		end
	end

	te.color = util.color( c )
	
	if g ~= nil then
		te.equipment_grid = g
	end

	local ti = utd( data.raw["item-with-entity-data"]["locomotive"] )
	ti.name = n
	ti.icon = nil
	ti.icons = i
	ti.subgroup = su
	ti.order = o
	ti.place_result = n
	ti.stack_size = st

	local tr = utd( data.raw["recipe"]["locomotive"] )
	tr.name = n
	tr.ingredients = ig
	tr.result = n

	data:extend{ te, ti, tr }

	table.insert( data.raw["technology"][t].effects, { type = "unlock-recipe", recipe = n } )
end

Senpais.Functions.Create.Grid = function( n, w, h, c )
	local g = utd( data.raw["equipment-grid"]["large-equipment-grid"] )
	g.name = n
	g.width = w
	g.height = h
	g.equipment_categories = c

	data:extend{ g }
end

local a = "Senpais-Power-Provider"

local ae = utd( data.raw["electric-energy-interface"]["electric-energy-interface"] )
ae.name = a
ae.icon = m .. "/graphics/" .. a .. "-i.png"
ae.minable.result = a
ae.enable_gui = false
ae.allow_copy_paste = false
ae.energy_source =
{
	type = "electric",
	buffer_capacity = "200MJ",
	usage_priority = "primary-input",
	input_flow_limit = "5000kW",
	output_flow_limit = "0W"
}
ae.energy_production = "0kW"
ae.energy_usage = "0kW"
ae.picture =
{
	filename = m .. "/graphics/" .. a.. "-e.png",
	priority = "extra-high",
	width = 124,
	height = 103,
	shift = { 0.6875, -0.203125 }
}
ae.charge_animation =
{
	filename = m .. "/graphics/" .. a .. "-charge.png",
	width = 138,
	height = 135,
	line_length = 8,
	frame_count = 24,
	shift = { 0.46875, -0.640625 },
	animation_speed = 0.5
}
ae.gui_mode = "none"

local ai = utd( data.raw["item"]["accumulator"] )
ai.name = a
ai.icon = m .. "/graphics/" .. a .. "-i.png"
ai.order = "e[accumulator]-d[" .. a .. "]"
ai.place_result = a

local ar = utd( data.raw["recipe"]["accumulator"] )
ar.name = "Senpais-Power-Provider"
ar.ingredients = { { "accumulator", 5 }, { "battery", 10 }, { "electronic-circuit", 20 } }
ar.result = "Senpais-Power-Provider"

local tech = utd( data.raw["technology"]["railway"] )
tech.name = "Senpais-Electric-Train"
tech.icon = m .. "/graphics/tech.png"
tech.icon_size = 128
tech.effects = { { type = "unlock-recipe", recipe = a } }
tech.prerequisites = { "railway", "electric-engine", "battery", "electric-energy-distribution-2" }
tech.unit = 
{
	count = 300,
	ingredients =
	{
		{ "automation-science-pack", 2 },
		{ "logistic-science-pack", 2 },
		{ "chemical-science-pack", 1 }
	},
	time = 50
}
tech.order = "s-e-t"

local tech2 = utd( tech )
tech2.name = "Senpais-Electric-Train-2"
tech2.effects = {}
tech2.prerequisites = { "Senpais-Electric-Train" }
tech2.unit.count = 600
tech2.upgrade = true
table.insert( tech2.unit.ingredients, { "production-science-pack", 1 } )

local tech3 = utd( tech2 )
tech3.name = "Senpais-Electric-Train-3"
tech3.effects = {}
tech3.prerequisites = { "Senpais-Electric-Train-2" }
tech3.unit.count = 600
tech3.localised_description = { "Electronic-Locomotives.Description", 1.2, 1.05 }

local tech4 = utd( tech3 )
tech4.name = "Senpais-Electric-Train-4"
tech4.effects = {}
tech4.prerequisites = { "Senpais-Electric-Train-3" }
tech4.unit.count = 700
tech4.localised_description = { "Electronic-Locomotives.Description", 1.8, 1.15 }
table.insert( tech4.unit.ingredients, { "utility-science-pack", 1 } )

local tech5 = utd( tech4 )
tech5.name = "Senpais-Electric-Train-5"
tech5.effects = {}
tech5.prerequisites = { "Senpais-Electric-Train-4" }
tech5.unit.count = 800
tech5.localised_description = { "Electronic-Locomotives.Description", 2.5, 1.15 }

local tech6 = utd( tech5 )
tech6.name = "Senpais-Electric-Train-6"
tech6.effects = {}
tech6.prerequisites = { "Senpais-Electric-Train-5" }
tech6.unit.count = 1000
tech6.localised_description = { "Electronic-Locomotives.Description", 3.5, 1.75 }
table.insert( tech6.unit.ingredients, { "space-science-pack", 1 } )

local fi =
{
	type = "item",
	icon = "__base__/graphics/icons/mip/coal.png",
	icon_size = 64,
	fuel_category = "electronic",
	fuel_value = "10MJ",
	subgroup = "raw-resource",
    order = "z[energy]",
    stack_size = 1,
    enabled = false
}

local fi_1 = utd( fi )
fi_1.name = "electronic-fuel-01"

local fi_2 = utd( fi )
fi_2.name = "electronic-fuel-02"
fi_2.fuel_acceleration_multiplier = 1.2
fi_2.fuel_top_speed_multiplier = 1.05

local fi_3 = utd( fi )
fi_3.name = "electronic-fuel-03"
fi_3.fuel_acceleration_multiplier = 1.8
fi_3.fuel_top_speed_multiplier = 1.15

local fi_4 = utd( fi )
fi_4.name = "electronic-fuel-04"
fi_4.fuel_acceleration_multiplier = 2.5
fi_4.fuel_top_speed_multiplier = 1.15

local fi_5 = utd( fi )
fi_5.name = "electronic-fuel-05"
fi_5.fuel_acceleration_multiplier = 3.5
fi_5.fuel_top_speed_multiplier = 1.75

data:extend{
	ae, ai, ar,
	tech, tech2, tech3, tech4, tech5, tech6,
	{ type = "fuel-category", name = "electronic" },
	fi_1, fi_2, fi_3, fi_4, fi_5
}

Senpais.Functions.Create.Electronic_Locomotive
(
	"600kW",
	"Senpais-Electric-Train",
	1000,
	2000,
	1.2,
	"#53bb90",
	nil,
	"transport",
	"a[train-system]-faa[Senpais-Electric-Train]",
	5,
	{ { "locomotive", 1 }, { "battery", 10 }, { "electric-engine-unit", 20 } },
	"Senpais-Electric-Train"
)

Senpais.Functions.Create.Electronic_Locomotive
(
	"3000kW",
	"Senpais-Electric-Train-Heavy",
	2000,
	5000,
	1.2,
	"#a61a1a",
	nil,
	"transport",
	"a[train-system]-fab[Senpais-Electric-Train-Heavy]",
	5,
	{ { "Senpais-Electric-Train", 1 }, { "battery", 20 }, { "electric-engine-unit", 20 } },
	"Senpais-Electric-Train-2"
)

if not data.raw["technology"]["braking-force-8"] then
	local bf8 = utd( data.raw["technology"]["braking-force-7"] )
	bf8.name = "braking-force-8"
	bf8.effects = { { type = "train-braking-force-bonus", modifier = 0.30 } }
	bf8.prerequisites = { "braking-force-7" }
	bf8.unit.count = 800

	data:extend{ bf8 }
end
if not data.raw["technology"]["braking-force-9"] then
	local bf9 = utd( data.raw["technology"]["braking-force-7"] )
	bf9.name = "braking-force-9"
	bf9.effects = { { type = "train-braking-force-bonus", modifier = 0.50 } }
	bf9.prerequisites = { "braking-force-8" }
	bf9.unit.count = 1000

	data:extend{ bf9 }
end