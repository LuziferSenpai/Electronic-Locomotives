require "mod-gui"
require "util"

local player_lib = require "scripts/player"
local definesevents = defines.events
local definesstate = defines.train_state
local floor = math.floor
local match = "electronic_loco_register_add_"
local fuelvalue = 10000000
local watt = {
    ["watt1"] = "kW",
    ["watt2"] = "MW",
    ["watt3"] = "GW",
    ["Watt4"] = "TW"
}
local joule = {
    ["joule1"] = "J",
    ["joule2"] = "kJ",
    ["joule3"] = "MJ",
    ["joule4"] = "GJ",
    ["joule5"] = "TJ"
}
local provider_register = {
    ["Electronic-Energy-Provider"] = true,
    ["Electronic-Energy-Provider-2"] = true
}
local loco_register = {
    ["Electronic-Standard-Locomotive"] = "more",
    ["Electronic-Cargo-Locomotive"] = "more"
}
local loco_lookup = {
    ["Electronic-Standard-Locomotive"] = 600,
    ["Electronic-Cargo-Locomotive"] = 3000
}
local blacklistsurfaces = {
    ["_BPEX_Temp_Surface"] = true,
    ["bp-editor-surface"] = true,
    ["trainConstructionSite"] = true
}
local script_data = {
    players = {},
    fuel = "electronic-fuel-01",
    energy = {["1"] = {}, ["2"] = {}, ["3"] = {}, ["4"] = {}, ["5"] = {}, ["6"] = {}, ["7"] = {}, ["8"] = {}, ["9"] = {}, ["10"] = {}, ["more"] = {}},
    where = {},
    energyall = {},
    locomotives = {},
    providers = 0,
    energytick = 0,
    surfaces = {},
    surfacenames = {},
    names = {}
}

for name, setting in pairs(settings.startup) do
    if name:find(match) then
        local data = util.split(setting.value, "_")
        local loconame = name:sub(match:len() + 1)

        loco_register[loconame] = data[1]
        loco_lookup[loconame] = tonumber(data[2])
    end
end

local function checkproviders(index, amount)
    local providers = script_data.surfaces[index].providers

    for index_number, data in pairs(providers) do
        local entity = data.entity

        if entity.valid then
            local energy = entity.energy

            if energy >= amount then
                entity.energy = energy - amount

                return 0
            else
                amount = amount - energy
                entity.energy = 0
            end
        else
            providers[index_number] = nil
            script_data.providers = script_data.providers - 1
        end
    end

    return amount
end

local function round(number, decimals)
    local multiplier = 10 ^ decimals

    return floor(number * multiplier + 0.5) / multiplier
end

local function remove(index)
    local where = script_data.where[index]

    if where then
        script_data.energy[where][index] = nil
        script_data.where[index] = nil
    end

    script_data.energyall[index] = nil
    script_data.locomotives[index] = nil
end

local function guilocotable()
    local energy = 0
    local data = 1

    for index, entity in pairs(script_data.locomotives) do
        if not entity.valid then
            remove(index)
        end
    end

    for index, name in pairs(script_data.energyall) do
        energy = energy + loco_lookup[name]
    end

    while (energy > 1000 and data < 5) do
        energy = energy / 1000
        data = data + 1
    end

    return {locomotives = table_size(script_data.locomotives), energyall = table_size(script_data.energyall), energy = {watt["watt" .. data], energy}}
end

local function guiprovidertable(index)
    local providers = script_data.surfaces[index].providers
    local energyin = 0
    local storageenergy = 0
    local storageenergy2 = 0
    local intakeenergy = 0
    local dataenergyin = 1
    local datastorageenergy = 1
    local dataintakeenergy = 1
    local value = 0

    for index_number, data in pairs(providers) do
        local entity = data.entity

        if entity.valid then
            local energy = entity.energy
            local energy_prototype = data.energy_prototype
            local buffer_capacity = energy_prototype.buffer_capacity

            energyin = energyin + energy
            storageenergy = storageenergy + buffer_capacity

            if energy < buffer_capacity then
                intakeenergy = intakeenergy + energy_prototype.input_flow_limit
            end
        else
            providers[index_number] = nil
            script_data.providers = script_data.providers - 1
        end
    end

    storageenergy2 = storageenergy
    intakeenergy = intakeenergy * 0.06

    local provideramount = table_size(providers)

    while (energyin > 1000 and dataenergyin < 5) do
        energyin = energyin / 1000
        storageenergy2 = storageenergy2 / 1000
        dataenergyin = dataenergyin + 1
    end

    while (storageenergy > 1000 and datastorageenergy < 5) do
        storageenergy = storageenergy / 1000
        datastorageenergy = datastorageenergy + 1
    end

    while (intakeenergy > 1000 and dataintakeenergy < 4) do
        intakeenergy = intakeenergy / 1000
        dataintakeenergy = dataintakeenergy + 1
    end

    energyin = round(energyin, 2)

    if provideramount > 0 then
        value = energyin / storageenergy2
    end

    return {value = value, amount = provideramount, energyin = {joule["joule" .. dataenergyin], energyin}, storageenergy = {joule["joule" .. datastorageenergy], storageenergy}, intakeenergy = {watt["watt" .. dataintakeenergy], round(intakeenergy, 1)}}
end

local function updatelist()
    local cache = {}

    for _, playermeta in pairs(script_data.players) do
        if playermeta.frame then
            local listbox = playermeta.listbox
            local selected_index = playermeta.selected_index

            listbox.items = script_data.surfacenames

            if selected_index == 0 then
                selected_index = 1
                listbox.selected_index = 1
                playermeta.selected_index = 1
            end

            if not cache[selected_index] then
                cache[selected_index] = guiprovidertable(script_data.names[script_data.surfacenames[selected_index]])
            end

            local data = cache[selected_index]

            playermeta.providercount.caption = data.amount
            playermeta.providerinput.caption = {"Electronic." .. data.energyin[1], data.energyin[2]}
            playermeta.providerstorage.caption = {"Electronic." .. data.storageenergy[1], data.storageenergy[2]}
            playermeta.providerintake.caption = {"Electronic." .. data.intakeenergy[1], data.intakeenergy[2]}
            playermeta.progressbar.value = data.value
        end
    end
end

local function playerstart(player_index)
    if not script_data.players[tostring(player_index)] then
        local player = player_lib.new(game.players[player_index], script_data.surfacenames)

        script_data.players[player.index] = player
    end
end

local function on_built_entity(event)
    local entity = event.created_entity or event.entity or event.destination

    if not (entity and entity.valid) then return end

    local surface = entity.surface
    local surfacename = surface.name

    if (surfacename:find("^Factory floor") or blacklistsurfaces[surfacename]) then return end
    if type(entity.unit_number) ~= "number" then return end

    local name = entity.name
    local index = tostring(entity.unit_number)

    if loco_register[name] then
        script_data.energy["1"][index] = entity
        script_data.where[index] = "1"
        script_data.energyall[index] = name
        script_data.locomotives[index] = entity
    elseif provider_register[name] then
        script_data.surfaces[tostring(surface.index)].providers[index] = {entity = entity, energy_prototype = entity.prototype.electric_energy_source_prototype}
        script_data.providers = script_data.providers + 1
    end
end

local function playerload()
    for _, player in pairs(game.players) do
        playerstart(player.index)
    end
end

local function checkresearch()
    local techs = game.forces["player"].technologies

    if techs["Electronic-Locomotives-6"].researched then
        script_data.fuel = "electronic-fuel-05"
    elseif techs["Electronic-Locomotives-5"].researched then
        script_data.fuel = "electronic-fuel-04"
    elseif techs["Electronic-Locomotives-4"].researched then
        script_data.fuel = "electronic-fuel-03"
    elseif techs["Electronic-Locomotives-3"].researched then
        script_data.fuel = "electronic-fuel-02"
    end
end

local function checksurfaces()
    for _, surface in pairs(game.surfaces) do
        local name = surface.name
        local index = tostring(surface.index)

        if not (name:find("^Factory floor") or blacklistsurfaces[name]) then
            if not script_data.surfaces[index] then
                script_data.surfaces[index] = {providers = {}, name = name, index = index}
                script_data.names[name] = index
                table.insert(script_data.surfacenames, name)
            end

            local t = {}

            for loconame, _ in pairs(loco_register) do
                table.insert(t, loconame)
            end

            for providername, _ in pairs(provider_register) do
                table.insert(t, providername)
            end

            local entities = surface.find_entities_filtered{name = t}

            for _, entity in pairs(entities) do
                if entity.type == "locomotive" and not script_data.locomotives[tostring(entity.unit_number)] then
                    on_built_entity({entity = entity})
                elseif entity.type == "electric-energy-interface" and not script_data.surfaces[index].providers[tostring(entity.unit_number)] then
                    on_built_entity({entity = entity})
                end
            end
        end
    end
end

local function on_surface_created(event)
    local index = event.surface_index
    local index_number = tostring(index)
    local surface = game.surfaces[index]
    local name = game.surfaces[index].name

    if not (name:find("^Factory floor") or blacklistsurfaces[name] or script_data.surfaces[index_number]) then
        script_data.surfaces[index_number] = {providers = {}, name = name, index = index_number}
        script_data.names[name] = index_number
        table.insert(script_data.surfacenames, name)

        updatelist()
    end
end

return {
    on_init = function()
        global.electronic = global.electronic or script_data

        playerload()
        checkresearch()
        checksurfaces()
    end,
    on_load = function()
        script_data = global.electronic or script_data

        for _, player in pairs(script_data.players) do
            setmetatable(player, player_lib.metatable)
        end
    end,
    on_configuration_changed = function(event)
        local changes = event.mod_changes and event.mod_changes["Electronic_Locomotives"] or {}

        global.electronic = global.electronic or script_data

        playerload()
        checkresearch()
        checksurfaces()

        if next(changes) then
            local oldchanges = changes.old_version

            if oldchanges and changes.new_version then
                if oldchanges == "0.3.14" then
                    local old_script_data = global.script_data
                    local GUIS = old_script_data.GUIS
                    local energy = script_data.energy
                    local where = script_data.where
                    local energyall = script_data.energyall
                    local locomotives = script_data.locomotives
                    local players = script_data.players

                    script_data.fuel = old_script_data.Fuel
                    script_data.energytick = old_script_data.EnergyTick

                    for index, locotable in pairs(old_script_data.Energy) do
                        for _, entity in pairs(locotable) do
                            if entity.valid then
                                local index_number = tostring(entity.unit_number)

                                energy[index][index_number] = entity
                                where[index_number] = index
                            end
                        end
                    end

                    for _, entity in pairs(old_script_data.EnergyAll) do
                        if entity.valid then
                            energyall[tostring(entity.unit_number)] = entity.name
                        end
                    end

                    for _, entity in pairs(old_script_data.Locomotives) do
                        if entity.valid then
                            locomotives[tostring(entity.unit_number)] = entity
                        end
                    end

                    for _, surface in pairs(game.surfaces) do
                        local name = surface.name
                        local index = tostring(surface.index)

                        if not (name:find("^Factory floor") or blacklistsurfaces[name]) then
                            local providertable = surface.find_entities_filtered{name = {"Electronic-Energy-Provider", "Electronic-Energy-Provider-2"}}
                            local surfaceproviders = script_data.surfaces[index].providers

                            for _, entity in pairs(providertable) do
                                surfaceproviders[tostring(entity.unit_number)] = {entity = entity, energy_prototype = entity.prototype.electric_energy_source_prototype}
                                script_data.providers = script_data.providers + 1
                            end
                        end
                    end

                    for _, player in pairs(game.players) do
                        local index = player.index
                        local playermeta = players[tostring(index)]

                        mod_gui.get_button_flow(player).ElectronicButton.destroy()
                        
                        playermeta.location = old_script_data.Position[index]
                        playermeta.update_locos = old_script_data.UpdateLoco[index]
                        playermeta.update_provider = old_script_data.UpdateProvider[index]

                        if next(GUIS[index]) then
                            GUIS[index].A["01"].destroy()
                        end
                    end

                    global.script_data = nil
                end
            end
        end
    end,
    events = {
        [definesevents.on_tick] = function()
            if next(script_data.locomotives) and script_data.providers > 0 then
                script_data.energytick = script_data.energytick + 1

                local energy = script_data.energy
                local energyall = script_data.energyall
                local where = script_data.where
                local first = energy["1"]

                if next(first) then
                    local fuel = script_data.fuel

                    for index, entity in pairs(first) do
                        if entity.valid then
                            local burner = entity.burner
                            local missingfuel = fuelvalue - burner.remaining_burning_fuel
                            local fuelamount = checkproviders(tostring(entity.surface.index), missingfuel)

                            if fuelamount < missingfuel then
                                burner.currently_burning = fuel
                                burner.remaining_burning_fuel = fuelvalue - fuelamount

                                if entity.speed == 0 and entity.train.state == definesstate.manual_control then
                                    where[index] = nil
                                    energyall[index] = nil
                                else
                                    local register = loco_register[entity.name]
                                    energy[register][index] = entity
                                    where[index] = register
                                end
                            else
                                energy["2"][index] = entity
                                where[index] = "2"
                            end
                        else
                            remove(index)
                        end
                    end
                end

                for index, loco_table in pairs(energy) do
                    if index ~= "more" and index ~= "1" then
                        local index_number = tostring(tonumber(index) - 1)

                        for index_number2 in pairs(loco_table) do
                            where[index_number2] = index_number
                        end

                        energy[index_number] = loco_table
                    end
                end

                energy["10"] = {}

                if script_data.energytick == 10 then
                    script_data.energytick = 0

                    local more = energy["more"]

                    for index, entity in pairs(more) do
                        if entity.valid then
                            local burner = entity.burner
                            local fueltick = math.floor(burner.remaining_burning_fuel / burner.heat_capacity)

                            if fueltick < 11 then
                                if fueltick < 1 then fueltick = 1 end

                                local index_number = tostring(fueltick)

                                more[index] = nil
                                energy[index_number][index] = entity
                                where[index] = index_number
                            end
                        else
                            remove(index)
                        end
                    end
                end
            end
        end,
        [definesevents.on_built_entity] = on_built_entity,
        [definesevents.on_entity_cloned] = on_built_entity,
        [definesevents.on_gui_checked_state_changed] = function(event)
            local element = event.element
            local name = element.name

            if name:sub(1, 16) == "ELECTRONIC_CHECK" then
                local playermeta = script_data.players[tostring(event.player_index)]
                local number = name:sub(17, 18)

                if number == "01" then
                    local state = element.state

                    playermeta.update_locos = state
                    playermeta.updatelocobutton.enabled = not state
                elseif number == "02" then
                    local state = element.state

                    playermeta.update_provider = state
                    playermeta.updateproviderbutton.enabled = not state
                end
            end
        end,
        [definesevents.on_gui_click] = function(event)
            local name = event.element.name

            if name:sub(1, 16) == "ELECTRONIC_CLICK" then
                local playermeta = script_data.players[tostring(event.player_index)]
                local number = name:sub(17, 18)

                if number == "01" then
                    if playermeta.frame then
                        playermeta:clear()
                    else
                        playermeta:gui(guilocotable(), guiprovidertable(script_data.names[script_data.surfacenames[playermeta.selected_index]]))
                    end
                elseif number == "02" then
                    playermeta:clear()
                elseif number == "03" then
                    local data = guilocotable()

                    playermeta.lococount.caption = data.locomotives
                    playermeta.activeloco.caption = data.energyall
                    playermeta.energyloco.caption = {"Electronic." .. data.energy[1], data.energy[2]}
                elseif number == "04" then
                    local data = guiprovidertable(script_data.names[script_data.surfacenames[playermeta.selected_index]])

                    playermeta.providercount.caption = data.amount
                    playermeta.providerinput.caption = {"Electronic." .. data.energyin[1], data.energyin[2]}
                    playermeta.providerstorage.caption = {"Electronic." .. data.storageenergy[1], data.storageenergy[2]}
                    playermeta.providerintake.caption = {"Electronic." .. data.intakeenergy[1], data.intakeenergy[2]}
                    playermeta.progressbar.value = data.value
                end
            end
        end,
        [definesevents.on_gui_location_changed] = function(event)
            local playermeta = script_data.players[tostring(event.player_index)]
            local element = event.element

            if playermeta.frame and element.index == playermeta.frame.index then
                playermeta.location = element.location
            end
        end,
        [definesevents.on_gui_selection_state_changed] = function(event)
            local element = event.element
            local name = element.name

            if name:sub(1, 15) == "ELECTRONIC_DROP" then
                local playermeta = script_data.players[tostring(event.player_index)]
                local number = name:sub(16, 17)

                if number == "01" then
                    local selected_index = element.selected_index
                    local data = guiprovidertable(script_data.names[script_data.surfacenames[selected_index]])

                    playermeta.selected_index = selected_index
                    playermeta.providercount.caption = data.amount
                    playermeta.providerinput.caption = {"Electronic." .. data.energyin[1], data.energyin[2]}
                    playermeta.providerstorage.caption = {"Electronic." .. data.storageenergy[1], data.storageenergy[2]}
                    playermeta.providerintake.caption = {"Electronic." .. data.intakeenergy[1], data.intakeenergy[2]}
                    playermeta.progressbar.value = data.value
                end
            end
        end,
        [definesevents.on_player_created] = function(event)
            playerstart(event.player_index)
        end,
        [definesevents.on_player_removed] = function(event)
            script_data.players[tostring(event.player_index)] = nil
        end,
        [definesevents.on_research_finished] = function(event)
            local name = event.research.name

            if name == "Electronic-Locomotives-3" then
                script_data.fuel = "electronic-fuel-02"
            elseif name == "Electronic-Locomotives-4" then
                script_data.fuel = "electronic-fuel-03"
            elseif name == "Electronic-Locomotives-5" then
                script_data.fuel = "electronic-fuel-04"
            elseif name == "Electronic-Locomotives-6" then
                script_data.fuel = "electronic-fuel-05"
            end
        end,
        [definesevents.on_robot_built_entity] = on_built_entity,
        [definesevents.on_surface_created] = on_surface_created,
        [definesevents.on_surface_deleted] = function(event)
            local surface = script_data.surfaces[tostring(event.surface_index)]
            local name = surface.name

            script_data.surfaces[surface.index] = nil
            script_data.names[name] = nil

            for index, surfacename in pairs(script_data.surfacenames) do
                if name == surfacename then
                    table.remove(script_data.surfacenames, index)

                    break
                end
            end

            updatelist()
        end,
        [definesevents.on_surface_imported] = on_surface_created,
        [definesevents.on_surface_renamed] = function(event)
            local index = tostring(event.surface_index)
            local old_name = event.old_name
            local new_name = event.new_name

            if (old_name:find("^Factory floor") or blacklistsurfaces[old_name] or new_name:find("^Factory floor") or blacklistsurfaces[new_name] ) then return end

            script_data.surfaces[index].name = new_name
            script_data.names[old_name] = nil
            script_data.names[new_name] = index

            for index_number, name in pairs(script_data.surfacenames) do
                if name == old_name then
                    script_data.surfacenames[index_number] = new_name

                    break
                end
            end

            updatelist()
        end,
        [definesevents.on_train_changed_state] = function(event)
            local train = event.train
            local state = train.state

            if (state == definesstate.wait_signal or state == definesevents.wait_station) then return end

            local locomotives = train.locomotives
            local locomotive_table = {}

            for _, locomotive in pairs(locomotives.back_movers) do
                if loco_register[locomotive.name] then
                    locomotive_table[tostring(locomotive.unit_number)] = locomotive
                end
            end

            for _, locomotive in pairs(locomotives.front_movers) do
                if loco_register[locomotive.name] then
                    locomotive_table[tostring(locomotive.unit_number)] = locomotive
                end
            end

            if next(locomotive_table) then
                local energy = script_data.energy
                local where = script_data.where
                local energyall = script_data.energyall

                if ((state == definesstate.arrive_signal or state == definesstate.arrive_station) or (train.speed == 0 and state ~= definesstate.on_the_path)) then
                    for index in pairs(locomotive_table) do
                        local where_data = where[index]

                        if where_data then
                            energy[where_data][index] = nil
                            where[index] = nil
                        end

                        energyall[index] = nil
                    end
                else
                    for index, entity in pairs(locomotive_table) do
                        local burner = entity.burner
                        local fueltick = math.floor(burner.remaining_burning_fuel/burner.heat_capacity)

                        local index_number = "more"

                        if fueltick < 1 then fueltick = 1 end
                        if fueltick < 11 then index_number = tostring(fueltick) end

                        energy[index_number][index] = entity
                        where[index] = index_number
                        energyall[index] = entity.name
                    end
                end
            end
        end,
        [definesevents.script_raised_built] = on_built_entity,
        [definesevents.script_raised_revive] = on_built_entity
    },
    on_nth_tick = {
        [15] = function()
            local locodata = guilocotable()
            local cache = {}

            for _, playermeta in pairs(script_data.players) do
                if playermeta.frame then
                    if playermeta.update_locos then
                        playermeta.lococount.caption = locodata.locomotives
                        playermeta.activeloco.caption = locodata.energyall
                        playermeta.energyloco.caption = {"Electronic." .. locodata.energy[1], locodata.energy[2]}
                    end

                    if playermeta.update_provider then
                        local selected_index = playermeta.selected_index

                        if not cache[selected_index] then
                            cache[selected_index] = guiprovidertable(script_data.names[script_data.surfacenames[selected_index]])
                        end

                        local data = cache[selected_index]

                        playermeta.providercount.caption = data.amount
                        playermeta.providerinput.caption = {"Electronic." .. data.energyin[1], data.energyin[2]}
                        playermeta.providerstorage.caption = {"Electronic." .. data.storageenergy[1], data.storageenergy[2]}
                        playermeta.providerintake.caption = {"Electronic." .. data.intakeenergy[1], data.intakeenergy[2]}
                        playermeta.progressbar.value = data.value
                    end
                end
            end
        end
    }
}