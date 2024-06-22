local modName = "__Electronic_Locomotives__"
local util = require(modName .. "/prototypes/util")
local name = "electronic-standard-provider"
local standardProviderEntity = util.copy(data.raw["electric-energy-interface"]["electric-energy-interface"])
local standardProviderItem = util.copy(data.raw["item"]["accumulator"])
local standardProviderRecipe = util.copy(data.raw["recipe"]["accumulator"])

standardProviderEntity.name = name
standardProviderEntity.icon = modName .. "/graphics/" .. name .. "-icon.png"
standardProviderEntity.icon_size = 32
standardProviderEntity.icon_mipmap = nil
standardProviderEntity.icons = nil
standardProviderEntity.subgroup = nil
standardProviderEntity.minable.result = name
standardProviderEntity.enable_gui = false
standardProviderEntity.gui_mode = "none"
standardProviderEntity.allow_copy_paste = false
standardProviderEntity.energy_source = {
    type = "electric",
    buffer_capacity = "200MJ",
    usage_priority = "primary-input",
    input_flow_limit = "5MW",
    output_flow_limit = "0MW"
}
standardProviderEntity.energy_production = "0kW"
standardProviderEntity.energy_usage = "0kW"
standardProviderEntity.picture = {
    filename = modName .. "/graphics/" .. name .. "-entity.png",
    priority = "extra-high",
    width = 124,
    height = 103,
    shift = { 0.6875, -0.203125 }
}
standardProviderEntity.charge_animation = {
    filename = modName .. "/graphics/" .. name .. "-charge.png",
    width = 138,
    height = 135,
    line_length = 8,
    frame_count = 24,
    shift = { 0.46875, -0.640625 },
    animation_speed = 0.5
}
standardProviderEntity.discharge_animation = {
    filename = modName .. "/graphics/" .. name .. "discharge.png",
    width = 147,
    height = 128,
    line_length = 8,
    frame_count = 24,
    shift = { 0.390625, -0.53125 },
    animation_speed = 0.5
}
standardProviderEntity.fast_replaceable_group = "electronic-provider"
standardProviderEntity.next_upgrade = "electronic-heavy-provider"
standardProviderEntity.is_electronic = true

standardProviderItem.name = name
standardProviderItem.icon = modName .. "/graphics/" .. name .. "-icon.png"
standardProviderItem.icon_size = 32
standardProviderItem.icon_mipmap = nil
standardProviderItem.order = "e[accumulator]-aa[" .. name .. "]"
standardProviderItem.place_result = name

standardProviderRecipe.name = name
standardProviderRecipe.ingredients = {
    { "accumulator",        5 },
    { "battery",            10 },
    { "electronic-circuit", 20 }
}
standardProviderRecipe.result = name

return { standardProviderEntity, standardProviderItem, standardProviderRecipe }
