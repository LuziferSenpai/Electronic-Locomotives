local util = require("__Electronic_Locomotives__/prototypes/util")
local name = "electronic-cargo-locomotive"
local color = "#a61a1a"
local cargoLocomotiveEntity = util.copy(data.raw["locomotive"]["locomotive"])
local cargoLocomotiveItem = util.copy(data.raw["item-with-entity-data"]["locomotive"])
local cargoLocomotiveRecipe = util.copy(data.raw["recipe"]["locomotive"])

cargoLocomotiveEntity.name = name
cargoLocomotiveEntity.icon = nil
cargoLocomotiveEntity.icon_size = nil
cargoLocomotiveEntity.icon_mipmaps = nil
cargoLocomotiveEntity.icons = util.standardElectronicIcons(color)
cargoLocomotiveEntity.minable.result = name
cargoLocomotiveEntity.max_health = 2000
cargoLocomotiveEntity.weight = 5000
cargoLocomotiveEntity.max_speed = 3
cargoLocomotiveEntity.max_power = "3MW"
cargoLocomotiveEntity.reversing_power_modifier = 1.2
cargoLocomotiveEntity.braking_force = 20
cargoLocomotiveEntity.color = util.color(color)
cargoLocomotiveEntity.is_electronic = true

cargoLocomotiveItem.name = name
cargoLocomotiveItem.icon = nil
cargoLocomotiveItem.icon_size = nil
cargoLocomotiveItem.icon_mipmaps = nil
cargoLocomotiveItem.icons = util.standardElectronicIcons(color)
cargoLocomotiveItem.order = "a[train-system]-fab[" .. name .. "]"
cargoLocomotiveItem.place_result = name

cargoLocomotiveRecipe.name = name
cargoLocomotiveRecipe.ingredients = {
    { "electronic-standard-locomotive", 1 },
    { "battery",                        20 },
    { "electric-engine-unit",           20 }
}
cargoLocomotiveRecipe.result = name

return { cargoLocomotiveEntity, cargoLocomotiveItem, cargoLocomotiveRecipe }
