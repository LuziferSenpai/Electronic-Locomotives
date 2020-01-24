require "defines"

local MODNAME = "__Electronic_Locomotives__"
local table_deepcopy = util.table.deepcopy
local temp01 = "Electronic-Energy-Provider"
local temp02 = MODNAME .. "/graphics/" .. temp01 .. "-i.png"

local provider01_entity = table_deepcopy( data.raw["electric-energy-interface"]["electric-energy-interface"] )
provider01_entity.name = temp01
provider01_entity.icon = temp02
provider01_entity.icon_size = 32
provider01_entity.icon_mipmap = nil
provider01_entity.icons = nil
provider01_entity.subgroup = nil
provider01_entity.minable.result = temp01
provider01_entity.enable_gui = false
provider01_entity.gui_mode = "none"
provider01_entity.allow_copy_paste = false
provider01_entity.energy_source =
{
	type = "electric",
	buffer_capacity = "200MJ",
	usage_priority = "primary-input",
	input_flow_limit = "5MW",
	output_flow_limit = "0kW"
}
provider01_entity.energy_production = "0kW"
provider01_entity.energy_usage = "0kW"
provider01_entity.picture =
{
	filename = MODNAME .. "/graphics/" .. temp01 .. "-e.png",
	priority = "extra-high",
	width = 124,
	height = 103,
	shift = { 0.6875, -0.203125 }
}
provider01_entity.charge_animation =
{
	filename = MODNAME .. "/graphics/" .. temp01 .. "-charge.png",
	width = 138,
	height = 135,
	line_length = 8,
	frame_count = 24,
	shift = { 0.46875, -0.640625 },
	animation_speed = 0.5
}
provider01_entity.discharge_animation =
{
	filename = MODNAME .. "/graphics/" .. temp01 .. "discharge.png",
	width = 147,
	height = 128,
	line_length = 8,
	frame_count = 24,
	shift = { 0.390625, -0.53125 },
	animation_speed = 0.5
}
provider01_entity.fast_replaceable_group = "electronic-provider"
provider01_entity.next_upgrade = "Electronic-Energy-Provider-2"

local provider01_item = table_deepcopy( data.raw["item"]["accumulator"] )
provider01_item.name = temp01
provider01_item.icon = temp02
provider01_item.icon_size = 32
provider01_item.icon_mipmap = nil
provider01_item.order = "e[accumulator]-aa[" .. temp01 .. "]"
provider01_item.place_result = temp01

local provider01_recipe = table_deepcopy( data.raw["recipe"]["accumulator"] )
provider01_recipe.name = temp01
provider01_recipe.ingredients =
{
	{ "accumulator", 5 },
	{ "battery", 10 },
	{ "electronic-circuit", 20 }
}
provider01_recipe.result = temp01

temp01 = "Electronic-Energy-Provider-2"
temp02 = MODNAME .. "/graphics/" .. temp01 .. "-i.png"

local provider02_entity = table_deepcopy( provider01_entity )
provider02_entity.name = temp01
provider02_entity.icon = temp02
provider02_entity.icon_size = 32
provider02_entity.icon_mipmap = nil
provider02_entity.minable.result = temp01
provider02_entity.energy_source =
{
	type = "electric",
	buffer_capacity = "10GJ",
	usage_priority = "primary-input",
	input_flow_limit = "500MW",
	output_flow_limit = "0kW"
}

provider02_entity.picture.filename = MODNAME .. "/graphics/" .. temp01 .. "-e.png"
provider02_entity.charge_animation.filename = MODNAME .. "/graphics/" .. temp01 .. "-charge.png"
provider02_entity.discharge_animation.filename = MODNAME .. "/graphics/" .. temp01 .. "-discharge.png"
provider02_entity.next_upgrade = nil

local provider02_item = table_deepcopy( provider01_item )
provider02_item.name = temp01
provider02_item.icon = temp02
provider02_item.icon_size = 32
provider02_item.icon_mipmap = nil
provider02_item.order = "e[accumulator]-ab[" .. temp01 .. "]"
provider02_item.place_result = temp01

local provider02_recipe = table_deepcopy( provider01_recipe )
provider02_recipe.name = temp01
provider02_recipe.ingredients =
{
	{ provider01_item.name, 10 },
	{ "battery", 50 },
	{ "processing-unit", 10 }
}
provider02_recipe.result = temp01

local electronic_fuel =
{
	type = "item",
	icon = "__base__/graphics/icons/coal.png",
    icon_size = 64,
    icon_mipmaps = 4,
	fuel_category = "electronic",
	fuel_value = "10MJ",
	subgroup = "raw-resource",
	order = "z[energy]",
	stack_size = 1,
	enabled = false
}

temp02 = "electronic-fuel"

local electronic_fuel01 = table_deepcopy( electronic_fuel )
electronic_fuel01.name = temp02 .. "-01"

local electronic_fuel02 = table_deepcopy( electronic_fuel )
electronic_fuel02.name = temp02 .. "-02"
electronic_fuel02.fuel_acceleration_multiplier = 1.2
electronic_fuel02.fuel_top_speed_multiplier = 1.05

local electronic_fuel03 = table_deepcopy( electronic_fuel )
electronic_fuel03.name = temp02 .. "-03"
electronic_fuel03.fuel_acceleration_multiplier = 1.8
electronic_fuel03.fuel_top_speed_multiplier = 1.15

local electronic_fuel04 = table_deepcopy( electronic_fuel )
electronic_fuel04.name = temp02 .. "-04"
electronic_fuel04.fuel_acceleration_multiplier = 2.5
electronic_fuel04.fuel_top_speed_multiplier = 1.15

local electronic_fuel05 = table_deepcopy( electronic_fuel )
electronic_fuel05.name = temp02 .. "-05"
electronic_fuel05.fuel_acceleration_multiplier = 3.5
electronic_fuel05.fuel_top_speed_multiplier = 1.75

temp02 = "Electronic-Locomotives"

local technology01 = table_deepcopy( data.raw["technology"]["railway"] )
technology01.name = temp02
technology01.icon = MODNAME .. "/graphics/tech.png"
technology01.icon_size = 128
technology01.icon_mipmap = nil
technology01.effects = { { type = "unlock-recipe", recipe = provider01_recipe.name } }
technology01.prerequisites = { "railway", "electric-engine", "battery", "electric-energy-distribution-2" }
technology01.unit =
{
	count = 300,
	ingredients =
	{
		{ "automation-science-pack", 2 },
		{ "logistic-science-pack", 2 },
		{ "chemical-science-pack", 1 }
	},
	time = 60
}
technology01.order = "s-e-l"

local technology02 = table_deepcopy( technology01 )
technology02.name = temp02 .. "-2"
technology02.effects = {}
technology02.prerequisites = { temp02 }
technology02.unit.count = 600
technology02.upgrade = true

table.insert( technology02.unit.ingredients, { "production-science-pack", 1 } )

local technology03 = table_deepcopy( technology02 )
technology03.name = temp02 .. "-3"
technology03.effects = {}
technology03.prerequisites = { technology02.name }
technology03.unit.count = 700
technology03.localised_description = { "Electronic.Description", 1.2, 1.05 }

local technology04 = table_deepcopy( technology03 )
technology04.name = temp02 .. "-4"
technology04.prerequisites = { technology03.name }
technology04.unit.count = 800
technology04.localised_description = { "Electronic.Description", 1.8, 1.15 }

table.insert( technology04.unit.ingredients, { "utility-science-pack", 1 } )

local technology05 = table_deepcopy( technology04 )
technology05.name = temp02 .. "-5"
technology05.prerequisites = { technology04.name }
technology05.unit.count = 800
technology05.localised_description = { "Electronic.Description", 2.5, 1.15 }

local technology06 = table_deepcopy( technology05 )
technology06.name = temp02 .. "-6"
technology06.prerequisites = { technology05.name }
technology06.unit.count = 1200
technology06.localised_description = { "Electronic.Description", 3.5, 1.75 }

table.insert( technology06.unit.ingredients, { "space-science-pack", 1 } )

local technology07 = table_deepcopy( technology06 )
technology07.name = temp02 .. "-7"
technology07.effects = { { type = "unlock-recipe", recipe = provider02_recipe.name } }
technology07.prerequisites = { technology06.name }
technology07.unit.count = 4000
technology07.localised_description = nil

local braking_force_8 = table_deepcopy( data.raw["technology"]["braking-force-7"] )
braking_force_8.name = "braking-force-8"
braking_force_8.effects[1].modifier = 0.30
braking_force_8.prerequisites = { "braking-force-7" }
braking_force_8.unit.count = 800

local braking_force_9 = table_deepcopy( data.raw["technology"]["braking-force-7"] )
braking_force_9.name = "braking-force-9"
braking_force_9.effects[1].modifier = 0.50
braking_force_9.prerequisites = { "braking-force-8" }
braking_force_9.unit.count = 1000

data:extend
{
	{ type = "fuel-category", name = "electronic" },
	provider01_entity, provider01_item, provider01_recipe,
	provider02_entity, provider02_item, provider02_recipe,
	electronic_fuel01, electronic_fuel02, electronic_fuel03, electronic_fuel04, electronic_fuel05,
	technology01, technology02, technology03, technology04, technology05, technology06, technology07,
	braking_force_8, braking_force_9
}

Senpais.Functions.Create.Electronic_Locomotive
(
	"Electronic-Standard-Locomotive",
	1000,
	2000,
	1.2,
	"600kW",
	"#53bb90",
	nil,
	"transport",
	"a[train-system]-faa[Electronic-Standard-Locomotive]",
	5,
	{ { "locomotive", 1 }, { "battery", 10 }, { "electric-engine-unit", 20 } },
	temp02
)

Senpais.Functions.Create.Electronic_Locomotive
(
	"Electronic-Cargo-Locomotive",
	2000,
	5000,
	1.4,
	"3MW",
	"#a61a1a",
	nil,
	"transport",
	"a[train-system]-fab[Electronic-Cargo-Locomotive]",
	5,
	{ { "Electronic-Standard-Locomotive", 1 }, { "battery", 20 }, { "electric-engine-unit", 20 } },
	temp02 .. "-2"
)

local style = data.raw["gui-style"].default

style["SenpaisFlowCenter/Left8"] =
{
    type = "horizontal_flow_style",
    horizontally_stretchable = "on",
    vertical_align = "center",
    horizontal_align = "left",
    horizontal_spacing = 8
}

style["SenpaisFlowCenter/Left4"] =
{
    type = "horizontal_flow_style",
    horizontally_stretchable = "on",
    vertical_align = "center",
    horizontal_align = "left",
    horizontal_spacing = 4
}

style["SenpaisLine4"] =
{
    type = "line_style",
    top_margin = 4,
    bottom_margin = 4
}

style["SenpaisToolButton20"] =
{
    type = "button_style",
    parent = "tool_button",
    size = 20,
    padding = 0
}