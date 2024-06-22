local modName = "__Electronic_Locomotives__"
local util = require(modName .. "/prototypes/util")
local name = "electronic-heavy-provider"
local heavyProviderEntity = util.copy(data.raw["electric-energy-interface"]["electric-energy-interface"])
local heavyProviderItem = util.copy(data.raw["item"]["accumulator"])
local heavyProviderRecipe = util.copy(data.raw["recipe"]["accumulator"])

heavyProviderEntity.name = name
heavyProviderEntity.icon = modName .. "/graphics/" .. name .. "-icon.png"
heavyProviderEntity.icon_size = 32
heavyProviderEntity.icon_mipmap = nil
heavyProviderEntity.icons = nil
heavyProviderEntity.subgroup = nil
heavyProviderEntity.minable.result = name
heavyProviderEntity.enable_gui = false
heavyProviderEntity.gui_mode = "none"
heavyProviderEntity.allow_copy_paste = false
heavyProviderEntity.energy_source = {
    type = "electric",
    buffer_capacity = "10GJ",
    usage_priority = "primary-input",
    input_flow_limit = "500MW",
    output_flow_limit = "0MW"
}
heavyProviderEntity.energy_production = "0kW"
heavyProviderEntity.energy_usage = "0kW"
heavyProviderEntity.picture = {
    filename = modName .. "/graphics/" .. name .. "-entity.png",
    priority = "extra-high",
    width = 124,
    height = 103,
    shift = { 0.6875, -0.203125 }
}
heavyProviderEntity.charge_animation = {
    filename = modName .. "/graphics/" .. name .. "-charge.png",
    width = 138,
    height = 135,
    line_length = 8,
    frame_count = 24,
    shift = { 0.46875, -0.640625 },
    animation_speed = 0.5
}
heavyProviderEntity.discharge_animation = {
    filename = modName .. "/graphics/" .. name .. "discharge.png",
    width = 147,
    height = 128,
    line_length = 8,
    frame_count = 24,
    shift = { 0.390625, -0.53125 },
    animation_speed = 0.5
}
heavyProviderEntity.fast_replaceable_group = "electronic-provider"
heavyProviderEntity.is_electronic = true

heavyProviderItem.name = name
heavyProviderItem.icon = modName .. "/graphics/" .. name .. "-icon.png"
heavyProviderItem.icon_size = 32
heavyProviderItem.icon_mipmap = nil
heavyProviderItem.order = "e[accumulator]-ab[" .. name .. "]"
heavyProviderItem.place_result = name

heavyProviderRecipe.name = name
heavyProviderRecipe.ingredients = {
    { "electronic-standard-provider", 5 },
    { "battery",                      50 },
    { "processing-unit",              10 }
}
heavyProviderRecipe.result = name

return { heavyProviderEntity, heavyProviderItem, heavyProviderRecipe }
