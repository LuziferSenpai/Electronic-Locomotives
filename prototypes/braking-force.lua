local modName = "__Electronic_Locomotives__"
local util = require(modName .. "/prototypes/util")
local brakingForceTechnologyRaw = data.raw["technology"]["braking-force-7"]
local brakingForceTechnology = {}

for i = 8, 11 do
    local tempBrakingForceTechnology = util.copy(brakingForceTechnologyRaw)

    tempBrakingForceTechnology.name = "braking-force-" .. i
    tempBrakingForceTechnology.prerequisites = { "braking-force-" .. i - 1 }
    tempBrakingForceTechnology.unit.count = ((i - 1) * 100) + 50

    table.insert(brakingForceTechnology, tempBrakingForceTechnology)
end

return brakingForceTechnology
