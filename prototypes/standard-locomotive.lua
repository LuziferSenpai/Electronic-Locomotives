local util = require("__Electronic_Locomotives__/prototypes/util")
local name = "electronic-standard-locomotive"
local color = "#53bb90"
local standardLocomotiveEntity = util.copy(data.raw["locomotive"]["locomotive"])
local standardLocomotiveItem = util.copy(data.raw["item-with-entity-data"]["locomotive"])
local standardLocomotiveRecipe = util.copy(data.raw["recipe"]["locomotive"])

standardLocomotiveEntity.name = name
standardLocomotiveEntity.icon = nil
standardLocomotiveEntity.icon_size = nil
standardLocomotiveEntity.icon_mipmaps = nil
standardLocomotiveEntity.icons = util.standardElectronicIcons(color)
standardLocomotiveEntity.minable.result = name
standardLocomotiveEntity.color = util.color(color)
standardLocomotiveEntity.is_electronic = true

standardLocomotiveItem.name = name
standardLocomotiveItem.icon = nil
standardLocomotiveItem.icon_size = nil
standardLocomotiveItem.icon_mipmaps = nil
standardLocomotiveItem.icons = util.standardElectronicIcons(color)
standardLocomotiveItem.order = "a[train-system]-faa[" .. name .. "]"
standardLocomotiveItem.place_result = name

standardLocomotiveRecipe.name = name
standardLocomotiveRecipe.ingredients = {
    { "locomotive",           1 },
    { "battery",              10 },
    { "electric-engine-unit", 20 }
}
standardLocomotiveRecipe.result = name

return { standardLocomotiveEntity, standardLocomotiveItem, standardLocomotiveRecipe }
