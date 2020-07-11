if mods["angelsindustries"] then
    local subgroup = data.raw["item"]["accumulator"].subgroup
    data.raw["item"]["Electronic-Energy-Provider"].subgroup = subgroup
    data.raw["item"]["Electronic-Energy-Provider-2"].subgroup = subgroup

    if angelsmods.industries.components then
        data.raw["recipe"]["Electronic-Energy-Provider"].ingredients = {
            {"accumulator", 5},
            {"battery", 10},
            {"block-construction-3", 10}
        }
        data.raw["recipe"]["Electronic-Energy-Provider-2"].ingredients = {
            {"Electronic-Energy-Provider", 10},
            {"block-construction-5", 10},
            {"block-electronics-5", 10}
        }
        data.raw["recipe"]["Electronic-Standard-Locomotive"].ingredients = {
            {"locomotive", 1},
            {"battery", 10},
            {"block-construction-3", 10}
        }
        data.raw["recipe"]["Electronic-Cargo-Locomotive"].ingredients = {
            {"Electronic-Standard-Locomotive", 1},
            {"block-construction-4", 10},
            {"block-electronics-4", 10}
        }
    end

    if angelsmods.industries.tech then
        data.raw["technology"]["Electronic-Locomotives"].unit.ingredients = {
            {"angels-science-pack-blue", 1},
            {"datacore-energy-2", 2}
        }
        data.raw["technology"]["Electronic-Locomotives-2"].unit.ingredients = {
            {"angels-science-pack-blue", 1},
            {"datacore-energy-2", 2}
        }
        data.raw["technology"]["Electronic-Locomotives-3"].unit.ingredients = {
            {"angels-science-pack-blue", 1},
            {"datacore-energy-2", 2}
        }
        data.raw["technology"]["Electronic-Locomotives-4"].unit.ingredients = {
            {"angels-science-pack-yellow", 1},
            {"datacore-energy-2", 2}
        }
        data.raw["technology"]["Electronic-Locomotives-5"].unit.ingredients = {
            {"angels-science-pack-yellow", 1},
            {"datacore-energy-2", 2}
        }
        data.raw["technology"]["Electronic-Locomotives-6"].unit.ingredients = {
            {"angels-science-pack-white", 1},
            {"datacore-energy-2", 2}
        }
        data.raw["technology"]["Electronic-Locomotives-7"].unit.ingredients = {
            {"angels-science-pack-white", 1},
            {"datacore-energy-2", 2}
        }
    end
end