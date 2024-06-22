local modName = "__Electronic_Locomotives__"
local flibTable = require("__flib__/table")
local standardProvider = require(modName .. "/prototypes/standard-provider")
local heavyProvider = require(modName .. "/prototypes/heavy-provider")
local standardLocomotive = require(modName .. "/prototypes/standard-locomotive")
local cargoLocomotive = require(modName .. "/prototypes/cargo-locomotive")
local electronicTechnology = require(modName .. "/prototypes/electronic-technology")
local brakingForceTechnology = require(modName .. "/prototypes/braking-force")
local fuel = require(modName .. "/prototypes/fuel")

data:extend(flibTable.array_merge({
    {
        {
            type = "fuel-category",
            name = "electronic"
        }
    },
    standardProvider,
    heavyProvider,
    standardLocomotive,
    cargoLocomotive,
    electronicTechnology,
    brakingForceTechnology,
    fuel
}))
