require "mod-gui"
require "util"

local GUI = require "GUI"
local de = defines.events
local dt = defines.train_state
local Format = string.format
local FuelValue = 10000000
local Watt =
{
	["watt1"] = "kW",
	["watt2"] = "MW",
	["watt3"] = "GW",
	["Watt4"] = "TW"
}
local Joule =
{
	["joule1"] = "J",
	["joule2"] = "kJ",
	["joule3"] = "MJ",
	["joule4"] = "GJ",
	["joule5"] = "TJ"
}

local RegisterLoco =
{
	["Electronic-Standard-Locomotive"] = "more",
	["Electronic-Cargo-Locomotive"] = "more"
}

local script_data =
{
	Register =
	{
		Providers =
		{
			["Electronic-Energy-Provider"] = true,
			["Electronic-Energy-Provider-2"] = true
		},
		Locomotives = util.table.deepcopy( RegisterLoco )
	},
	Fuel = "electronic-fuel-01",
	
	Energy =
	{
		["1"] = {}, ["2"] = {}, ["3"] = {}, ["4"] = {}, ["5"] = {},
		["6"] = {}, ["7"] = {}, ["8"] = {}, ["9"] = {}, ["10"] = {},
		["more"] = {},
	},
	Where = {},
	EnergyAll = {},

	Locomotives = {},
	Providers = 0,
	EnergyTick = 0,

	SurfaceIndexs = {},
	Surfaces =
	{
		Number = 0,
		Names = {},
		Indexs = {},
		Providers = {}
	},

	--PlayerData
	GUIS = {},
	Position = {},
	Visible = {},
	UpdateLoco = {},
	UpdateProvider = {}
}

local CheckProviders = function( index_number, amount )
	local ProviderTable = script_data.Surfaces.Providers[index_number]

	for index, entity in pairs( ProviderTable ) do
		if entity.valid then
			local energy = entity.energy

			if energy >= amount then
				entity.energy = energy - amount

				return true
			end
		else
			script_data.Surfaces.Providers[index_number][index] = nil
			script_data.Providers = script_data.Providers - 1
		end
	end

	return false
end

local Round = function(number, decimals )
	local multiplier = 10 ^ decimals

	return math.floor( number * multiplier + 0.5 ) / multiplier
end

local Remove = function( index_number )
	local where = script_data.Where[index_number]

	if where then
		script_data.Energy[where][index_number] = nil
		script_data.Where[index_number] = nil
	end

	script_data.EnergyAll[index_number] = nil
	script_data.Locomotives[index_number] = nil
end

local MainGUIUpdateLocos = function( player_id )
	local gui = script_data.GUIS[player_id].A["03"]
	local energy = 0
	local data = 1

	for index_number, entity in pairs( script_data.Locomotives ) do
		if not entity.valid then
			Remove( index_number )
		end
	end

	for index_number, entity in pairs( script_data.EnergyAll ) do
		if entity.valid then
			energy = energy + ( entity.burner.heat_capacity * 0.05625 )
		else
			Remove( index_number )
		end
	end

	while ( energy > 1000 and data < 5 ) do
		energy = energy / 1000
		data = data + 1
	end

	gui["07"].caption = table_size( script_data.Locomotives )
	gui["09"].caption = table_size( script_data.EnergyAll )
	gui["11"].caption = { "Electronic." .. Watt["watt" .. data], energy }
end

local MainGUIUpdateProviders = function( player_id )
	local gui = script_data.GUIS[player_id].A
	local selected_index = gui["03"]["14"].selected_index
	
	if selected_index < 1 then
		gui["03"]["14"].selected_index = 1
		selected_index = 1
	end
	
	local index = Format( "%05d", selected_index )
	local energyin = 0
	local storageenergy = 0
	local storageenergy2 = 0
	local intakeenergy = 0
	local data = { energyin = 1, storageenergy = 1, intakeenergy = 1 }
	
	for index_number, entity in pairs( script_data.Surfaces.Providers[index] ) do
		if entity.valid then
			local energy = entity.energy
			local energy_prototype = entity.prototype.electric_energy_source_prototype
			local buffer_capacity = energy_prototype.buffer_capacity
			
			energyin = energyin + energy
			storageenergy = storageenergy + buffer_capacity
			storageenergy2 = storageenergy2 + buffer_capacity

			if energy < buffer_capacity then
				intakeenergy = intakeenergy + energy_prototype.input_flow_limit
			end
		else
			script_data.Surfaces.Providers[index][index_number] = nil
			script_data.Providers = script_data.Providers - 1
		end
	end

	while ( energyin > 1000 and data.energyin < 5 ) do
		energyin = energyin / 1000
		storageenergy2 = storageenergy2 / 1000
		data.energyin = data.energyin + 1
	end

	while ( storageenergy > 1000 and data.storageenergy < 5 ) do
		storageenergy = storageenergy / 1000
		data.storageenergy = data.storageenergy + 1
	end

	intakeenergy = intakeenergy * 0.06

	while ( intakeenergy > 1000 and data.intakeenergy < 4 ) do
		intakeenergy = intakeenergy / 1000
		data.intakeenergy = data.intakeenergy + 1
	end

	local provideramount = table_size( script_data.Surfaces.Providers[index] )
	local gui2 = gui["04"]["05"]

	energyin = Round( energyin, 2 )
	storageenergy2 = Round( storageenergy2, 2 )

	if provideramount > 0 then
		gui2.value = energyin / storageenergy2
	else
		gui2.value = 0
	end

	gui = gui["05"]

	gui["02"].caption = provideramount
	gui["04"].caption = { "Electronic." .. Joule["joule" .. data.energyin], energyin }
	gui["06"].caption = { "Electronic." .. Joule["joule" .. data.storageenergy], Round( storageenergy, 2 ) }
	gui["08"].caption = { "Electronic." .. Watt["watt" .. data.intakeenergy], Round( intakeenergy, 1 ) }
end

local MainGUIUpdateProviderList = function()
	local gui = script_data.GUIS

	if not gui then return end

	for _, player in pairs( game.players ) do
		local player_id = player.index
		if next( gui[player_id] ) then
			gui[player_id].A["03"]["14"].items = script_data.Surfaces.Names

			MainGUIUpdateProviders( player_id )
		end
	end
end

local MainGUIToggle = function( player_id )
	local player = game.players[player_id]
	local screen = player.gui.screen

	if screen.ElectronicFrameAGUI01 then
		local gui = script_data.GUIS[player_id].A["01"]

		gui.visible = not gui.visible
	else
		local gui = GUI.Main( screen )

		gui["01"].location = script_data.Position[player_id]
		gui["03"]["14"].items = script_data.Surfaces.Names
		gui["03"]["14"].selected_index = 1
		
		script_data.GUIS[player_id].A = gui

		MainGUIUpdateLocos( player_id )
		MainGUIUpdateProviders( player_id )
	end

	local Visible = script_data.Visible
	Visible[player_id] = not Visible[player_id]
end

local AddSurface = function( addtype, index_number, name, providers )
	if addtype == "new" and ( name:find( "^Factory floor" ) or name == "_BPEX_Temp_Surface" or name == "bp-editor-surface" or script_data.SurfaceIndexs[index_number] ) then
		return false
	end

	local Surfaces = script_data.Surfaces
	
	if Surfaces.Number < 29999 then
		Surfaces.Number = Surfaces.Number + 1

		local index = Format( "%05d", Surfaces.Number )

		Surfaces.Names[index] = name
		Surfaces.Indexs[index] = index_number
		Surfaces.Providers[index] = providers or {}

		script_data.SurfaceIndexs[index_number] = index

		return true
	else
		return false
	end
end

local Events =
{
	["ElectronicCheckboxAGUI01"] = function( event )
		local player_id = event.player_index
		local state = event.element.state
		
		script_data.UpdateLoco[player_id] = state
		script_data.GUIS[player_id].A["03"]["04"].enabled = not state
	end,
	["ElectronicCheckboxAGUI02"] = function( event )
		local player_id = event.player_index
		local state = event.element.state
		
		script_data.UpdateProvider[player_id] = state
		script_data.GUIS[player_id].A["03"]["12"].enabled = not state
	end,
	["ElectronicListBoxAGUI01"] = function( event )
		MainGUIUpdateProviders( event.player_index )
	end
}

local Click =
{
	["ElectronicButton"] = function( event )
		MainGUIToggle( event.player_index )
	end,
	["ElectronicSpriteButtonAGUI01"] = function( event )
		local player_id = event.player_index

		script_data.GUIS[player_id].A["01"].visible = false
		script_data.Visible[player_id] = false
	end,
	["ElectronicSpriteButtonAGUI02"] = function( event )
		MainGUIUpdateLocos( event.player_index )
	end,
	["ElectronicSpriteButtonAGUI03"] = function( event )
		MainGUIUpdateProviders( event.player_index )
	end
}

local PlayerStart = function( player_id )
	local player = game.players[player_id]
	local button_flow = mod_gui.get_button_flow( player )

	if not button_flow.ElectronicButton then
		local b = GUI.AddSpriteButton( button_flow, "ElectronicButton", "item/Electronic-Energy-Provider" )
	end

	script_data.Position[player_id] = script_data.Position[player_id] or { x = 5, y = 85 * player.display_scale }
	script_data.GUIS[player_id] = script_data.GUIS[player_id] or {}
	script_data.Visible[player_id] = script_data.Visible[player_id] or false
	script_data.UpdateLoco[player_id] = script_data.UpdateLoco[player_id] or false
	script_data.UpdateProvider[player_id] = script_data.UpdateProvider[player_id] or false
end

local PlayerLoad = function()
	for _, player in pairs( game.players ) do
		PlayerStart( player.index )
	end
end

local CheckSurface = function()
	for _, surface in pairs( game.surfaces ) do
		if AddSurface( "new", "S" .. surface.index, surface.name ) then
			MainGUIUpdateProviderList()
		end
	end
end


--Events
local on_tick = function()
	if next( script_data.Locomotives ) and script_data.Providers > 0 then
		script_data.EnergyTick = script_data.EnergyTick + 1

		local Energy = script_data.Energy
		local Where = script_data.Where

		if next( Energy["1"] ) then
			local Fuel = script_data.Fuel
			local entry_table = script_data.Register.Locomotives
			local SurfaceIndexs = script_data.SurfaceIndexs

			for index, entity in pairs( Energy["1"] ) do
				if entity.valid then
					local burner = entity.burner

					if CheckProviders( SurfaceIndexs["S" .. entity.surface.index], FuelValue - burner.remaining_burning_fuel ) then
						burner.currently_burning = Fuel
						burner.remaining_burning_fuel = FuelValue

						if entity.speed == 0 and entity.train.state == dt.manual_control then
							script_data.Where[index] = nil
							script_data.EnergyAll[index] = nil
						else
							local where = entry_table[entity.name]
							
							Energy[where][index] = entity
							Where[index] = where
						end
					else
						Energy["2"][index] = entity
						Where[index] = "2"
					end
				else
					Remove( index )
				end
			end
		end

		for index, loco_table in pairs( Energy ) do
			if index ~= "more" and index ~= "1" then
				local index_number = "" .. tonumber( index ) - 1

				for unit_number in pairs( loco_table ) do
					Where[unit_number] = index_number
				end

				Energy[index_number] = loco_table
			end
		end

		script_data.Energy["10"] = {}

		if script_data.EnergyTick == 10 then
			script_data.EnergyTick = 0

			for index, entity in pairs( Energy["more"] ) do
				if entity.valid then
					local burner = entity.burner
					local FuelTick = math.floor( burner.remaining_burning_fuel / burner.heat_capacity )

					if FuelTick < 11 then
						if FuelTick < 1 then FuelTick = 1 end

						local index_number = "" .. FuelTick

						script_data.Energy["more"][index] = nil

						Energy[index_number][index] = entity
						Where[index] = index_number
					end
				else
					Remove( index )
				end
			end
		end
	end
end

local on_created_entity = function( event )
	local entity = event.created_entity or event.entity or event.destination

	if not ( entity and entity.valid ) then return end

	local surface = entity.surface

	if surface.name:find( "^Factory floor" ) then return end

	if type( entity.unit_number ) ~= "number" then return end

	local name = entity.name
	local unit_number = "E" .. entity.unit_number

	if script_data.Register.Providers[name] then		
		script_data.Surfaces.Providers[script_data.SurfaceIndexs["S" .. surface.index]][unit_number] = entity
		script_data.Providers = script_data.Providers + 1
	elseif script_data.Register.Locomotives[name] then
		script_data.Energy["1"][unit_number] = entity
		script_data.Where[unit_number] = "1"
		script_data.EnergyAll[unit_number] = entity
		script_data.Locomotives[unit_number] = entity
	end
end

local on_gui_event = function( event )
	local events = Events[event.element.name]
		
	if events then
		events( event )
	end
end

local on_gui_click = function( event )
	local click = Click[event.element.name]
		
	if click then
		click( event )
	end
end

local on_gui_location_changed = function( event )
	local element = event.element

	if element.name == "ElectronicFrameAGUI01" then
		script_data.Position[event.player_index] = element.location
	end
end

local on_player_created = function( event )
	PlayerStart( event.player_index )
end

local on_player_removed = function( event )
	local player_id = event.player_index

	script_data.Position[player_id] = nil
	script_data.GUI[player_id] = nil
	script_data.Visible[player_id] = nil
	script_data.UpdateLoco[player_id] = nil
	script_data.UpdateProvider[player_id] = nil
end

local on_research_finished = function( event )
	local name = event.research.name

	if name == "Electronic-Locomotives-3" then
		script_data.Fuel = "electronic-fuel-02"
	elseif name == "Electronic-Locomotives-4" then
		script_data.Fuel = "electronic-fuel-03"
	elseif name == "Electronic-Locomotives-5" then
		script_data.Fuel = "electronic-fuel-04"
	elseif name == "Electronic-Locomotives-6" then
		script_data.Fuel = "electronic-fuel-05"
	end
end

local on_surface_created = function( event )
	local index = event.surface_index

	if AddSurface( "new", "S" .. index, game.surfaces[index].name ) then
		MainGUIUpdateProviderList()
	end
end

local on_surface_deleted = function( event )
	local index_number = "S" .. event.surface_index
	local index = script_data.SurfaceIndexs[index_number]

	if type( index ) ~= "string" then return end
	
	local Surfaces = script_data.Surfaces

	script_data.Providers = script_data.Providers - table_size( Surfaces.Providers[index] )
	script_data.SurfaceIndexs[index_number] = nil

	Surfaces.Names[index] = nil
	Surfaces.Indexs[index] = nil
	Surfaces.Providers[index] = nil

	script_data.Surfaces =
	{
		Number = 0,
		Names = {},
		Indexs = {},
		Providers = {}
	}

	local Names = Surfaces.Names

	for entry, Name in pairs( Names ) do
		AddSurface( "", Surfaces.Indexs[entry], Name, Surfaces.Providers[entry] )
	end

	MainGUIUpdateProviderList()
end

local on_surface_renamed = function( event )
	local newname = event.new_name

	if ( newname:find( "^Factory floor" ) or event.old_name:find( "^Factory floor" ) ) then return end

	script_data.Surfaces.Names[script_data.SurfaceIndexs["S" .. event.surface_index]] = newname

	MainGUIUpdateProviderList()
end

local on_train_changed_state = function( event )
	local train = event.train
	local state = train.state

	if ( state == dt.wait_signal or state == dt.wait_station ) then return end

	local locomotives = train.locomotives
	local Locomotives = {}
	local locomotive_table = script_data.Register.Locomotives

	for _, locomotive in pairs( locomotives.back_movers ) do
		if locomotive_table[locomotive.name] then
			Locomotives["E" .. locomotive.unit_number] = locomotive
		end
	end

	for _, locomotive in pairs( locomotives.front_movers ) do
		if locomotive_table[locomotive.name] then
			Locomotives["E" .. locomotive.unit_number] = locomotive
		end
	end

	if next( Locomotives ) then
		local Energy = script_data.Energy
		local Where = script_data.Where
		local EnergyAll = script_data.EnergyAll

		if ( ( state == dt.arrive_signal or state == dt.arrive_station ) or ( train.speed == 0 and state ~= dt.on_the_path ) ) then
			for index in pairs( Locomotives ) do
				local where = Where[index]

				if where then
					script_data.Energy[where][index] = nil
					script_data.Where[index] = nil
				end

				script_data.EnergyAll[index] = nil
			end
		else
			for index, entity in pairs( Locomotives ) do
				local burner = entity.burner
				local FuelTick = math.floor( burner.remaining_burning_fuel / burner.heat_capacity )

				local index_number = "more"

				if FuelTick < 11 then FuelTick = 1 end
				if FuelTick < 11 then index_number = "" .. FuelTick end

				Energy[index_number][index] = entity
				Where[index] = index_number
				EnergyAll[index] = entity
			end
		end
	end
end	

local lib = {}

lib.events =
{
	[de.on_tick] = on_tick,
	[de.on_built_entity] = on_created_entity,
	[de.on_entity_cloned] = on_created_entity,
	[de.on_gui_checked_state_changed] = on_gui_event,
	[de.on_gui_click] = on_gui_click,
	[de.on_gui_location_changed] = on_gui_location_changed,
	[de.on_gui_selection_state_changed] = on_gui_event,
	[de.on_player_created] = on_player_created,
	[de.on_player_removed] = on_player_removed,
	[de.on_research_finished] = on_research_finished,
	[de.on_robot_built_entity] = on_created_entity,
	[de.on_surface_created] = on_surface_created,
	[de.on_surface_deleted] = on_surface_deleted,
	[de.on_surface_imported] = on_surface_created,
	[de.on_surface_renamed] = on_surface_renamed,
	[de.on_train_changed_state] = on_train_changed_state,	
	[de.script_raised_built] = on_created_entity,
  	[de.script_raised_revive] = on_created_entity
}

lib.on_nth_tick =
{
	[15] = function()
		local Visible = script_data.Visible
		local UpdateLoco = script_data.UpdateLoco
		local UpdateProvider = script_data.UpdateProvider

		for _, player in pairs( game.players ) do
			local player_id = player.index

			if Visible[player_id] then
				if UpdateLoco[player_id] then
					MainGUIUpdateLocos( player_id )
				end

				if UpdateProvider[player_id] then
					MainGUIUpdateProviders( player_id )
				end
			end
		end
	end
}

lib.add_remote_interface = function()
	remote.add_interface
	(
		"AddElectronicLocomotive",
		{
			new = function( name )
				local FuelTick = math.floor( FuelValue / ( game.entity_prototypes[name].max_energy_usage / 0.9375 ) )
				local entry = "more"
				
				if FuelTick < 11 then entry = "" .. FuelTick end
					
				script_data.Register.Locomotives[name] = entry
			end
		}
	)
end

lib.on_load = function()
	script_data = global.script_data or script_data
end

lib.on_configuration_changed = function( event )
	local changes = event.mod_changes or {}

	if next( changes ) then
		global.script_data = global.script_data or script_data
		
		global.script_data.Register.Locomotives = util.table.deepcopy( RegisterLoco )
		
		PlayerLoad()
		CheckSurface()
		local electronicchanges = changes["Electronic_Locomotives"] or {}

		if next( electronicchanges ) then
			local oldversion = electronicchanges.old_version

			if oldversion and electronicchanges.new_version then
				if oldversion <= "0.2.1" then
					for _, player in pairs( game.players ) do
						local button_flow = mod_gui.get_button_flow( player )
						local left = player.gui.left

						if button_flow.ElectricButton then button_flow.ElectricButton.destroy() end
						if left.ElectricFrame then left.ElectricFrame.destroy() end
					end

					local Locomotives = global.List.Trains
					local Provider = global.List.Accus
					local Locomotive = script_data.Locomotives
					local Energy = script_data.Energy
					local Where = script_data.Where
					local EnergyAll = script_data.EnergyAll
					local SurfaceIndexs = script_data.SurfaceIndexs
					local Surfaces = script_data.Surfaces

					for index, entity in pairs( Locomotives ) do
						if entity.valid and not entity.surface.name:find( "^Factory floor" ) then
							Locomotive[index] = entity

							local burner = entity.burner
							local FuelTick = math.floor( burner.remaining_burning_fuel / burner.heat_capacity )

							local index_number = "more"

							if FuelTick < 11 then FuelTick = 1 end
							if FuelTick < 11 then index_number = "" .. FuelTick end

							Energy[index_number][index] = entity
							Where[index] = index_number
							EnergyAll[index] = entity
						end
					end

					for index, entity in pairs( Provider ) do
						if entity.valid and not entity.surface.name:find( "^Factory floor" ) then
							local surface = entity.surface

							Surfaces.Providers[SurfaceIndexs["S" .. surface.index]][index] = entity
							script_data.Providers = script_data.Providers + 1
						end
					end

					global.Register = nil
					global.List = nil
					global.Power = nil
					global.GUIS = nil
					global.Fuel = nil
				end
			end
		end
	end
end

lib.on_init = function()
	global.script_data = global.script_data or script_data

	script_data.Register.Locomotives = util.table.deepcopy( RegisterLoco )

	PlayerLoad()
	CheckSurface()
end

return lib