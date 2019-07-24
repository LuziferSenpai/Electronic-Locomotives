require "mod-gui"
require "util"

local F = require "functions"
local de = defines.events
local dt = defines.train_state
local fv = 10000000

script.on_init( function()
	F.Globals()
	F.Players()
end )

script.on_configuration_changed( function( ee )
	local d = ee.mod_changes or {}
	if not next( d ) then return end
	F.Globals()
	F.Players()
	local de = d["Electronic_Locomotives"] or {}
	if next( de ) then
		local o = de.old_version
		if o and de.new_version then
			if o <= "0.1.1" then
				local t = global.List.Trains
				global.List.Trains = {}
				if next( t ) then
					for i, e in pairs( t ) do
						global.List.Trains[i] = e.e
					end
				end
			end
		end
	end
end )

script.on_event( de.on_gui_click, function( ee )
	local id = ee.player_index
	local p = game.players[id]
	local e = ee.element
	local n = e.name
	local pa = e.parent
	if ( n == nil or pa == nil ) then return end
	local m = p.gui.left
	if n == "ElectricButton" then
		if m.ElectricFrame then
			m.ElectricFrame.destroy()
			global.GUIS[id] = {}
		else
			F.GUI( m, id )
		end
	end
end )

script.on_event( de.on_player_created, function( ee )
	local id = ee.player_index
	local p = game.players[id]
	local m = mod_gui.get_button_flow( p )
	if not m.ElectricButton then
		local b = F.AddSpriteButton( m, "ElectricButton", "item/Senpais-Power-Provider" )
	end
	global.GUIS[p.index] = global.GUIS[p.index] or {}
end )

script.on_event( de.on_tick, function( ee )
	if ee.tick % ( game.speed * 15 ) < 1 then
		for _, p in pairs( game.players ) do
			if p.gui.left.ElectricFrame then
				F.Update( p.index )
			end
		end
	end
	if next( global.List.Trains ) and next( global.List.Accus ) then
		local t = global.Power 
		if next( t ) then
			local ps = 0
			local pu = 0
			local mp = table_size( t ) * fv
			local aa = global.List.Accus
			for id, e in pairs( aa ) do
				if ps < mp then
					if e.valid then
						ps = ps + e.energy
					else
						global.List.Accus[id] = nil
					end
				else
					break
				end
			end
			aa = global.List.Accus
			for id, e in pairs( t ) do
				if e.valid then
					local b = e.burner
					local re = b.remaining_burning_fuel
					local ca = b.heat_capacity
					if ca >= re then
						local r = fv - re
						if ps >= r then
							local ti = global.Register.Trains[e.name]
							ps = ps - r
							pu = pu + r
							b.currently_burning = global.Register.Fuel[global.Fuel]
							b.remaining_burning_fuel = fv
							if e.speed == 0 then
								global.Power[id] = nil
							end
						end
					end
				else
					F.Remove( id )
				end
			end
			for _, e in pairs( aa ) do
				if pu > 0 then
					local en = e.energy
					if pu > en then
						e.energy = 0
						pu = pu - en
					else
						e.energy = en - pu
						pu = 0
						break
					end
				else
					break
				end
			end
		end
	end
end )

script.on_event( de.on_train_changed_state, function( ee )
	local t = ee.train
	local l = t.locomotives
	local lo = {}
	if next( l.back_movers ) then
		for _, y in pairs( l.back_movers ) do
			if global.Register.Trains[y.name] then
				lo["E" .. y.unit_number] = y
			end
		end
	end
	if next( l.front_movers ) then
		for _, y in pairs( l.front_movers ) do
			if global.Register.Trains[y.name] then
				lo["E" .. y.unit_number] = y
			end
		end
	end
	if next( lo ) then
		local s = t.state
		if not ( s == dt.wait_signal or s == dt.wait_station ) then
			if ( s == dt.arrive_signal or s == dt.arrive_station ) or ( t.speed == 0 and s ~= dt.on_the_path ) then
				for id, _ in pairs( lo ) do
					global.Power[id] = nil
				end
			else
				for id, e in pairs( lo ) do
					global.Power[id] = e
				end
			end
		end
	end
end )

script.on_event( { de.on_built_entity, de.on_robot_built_entity, de.script_raised_built }, function( ee )
	local e = ee.created_entity or ee.entity
	if e and e.valid then
		local u = "E" .. e.unit_number
		local n = e.name
		if n == "Senpais-Power-Provider" then
			global.List.Accus[u] = e
		elseif global.Register.Trains[n] then
			global.List.Trains[u] = e
			global.Power[u] = e
		end
	end
end )

script.on_event( de.on_research_finished, function( ee )
	local r = ee.research
	local n = r.name
	if n == "Senpais-Electric-Train-3" then
		global.Fuel = "F02"
	elseif n == "Senpais-Electric-Train-4" then
		global.Fuel = "F03"
	elseif n == "Senpais-Electric-Train-5" then
		global.Fuel = "F04"
	elseif n == "Senpais-Electric-Train-6" then
		global.Fuel = "F05"
	else
		return
	end
end )

remote.add_interface
(
	"AddElectricTrain",
	{
		new = function( n )
			local e = game.entity_prototypes[n]
			if e then
				global.Register.Trains[n] = true
			end
		end
	}
)