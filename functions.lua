local F = {}
F.w =
{
	["w1"] = "kW",
	["w2"] = "MW",
	["w3"] = "GW",
	["w4"] = "TW",
}
F.j =
{
	["j1"] = "J",
	["j2"] = "kJ",
	["j3"] = "MJ",
	["j4"] = "GJ",
	["j5"] = "TJ",
}
F.Globals = function()
	global.Register =
	{
		Trains =
		{
			["Senpais-Electric-Train"] = true,
			["Senpais-Electric-Train-Heavy"] = true
		},
		Fuel =
		{
			["F01"] = "electronic-fuel-01",
			["F02"] = "electronic-fuel-02",
			["F03"] = "electronic-fuel-03",
			["F04"] = "electronic-fuel-04",
			["F05"] = "electronic-fuel-05"
		}
	}
	global.List = global.List or { Accus = {}, Trains = {} }
	global.Power = global.Power or{}
	global.GUIS = global.GUIS or {}
	global.Fuel = "F01"
end
F.Players = function()
	for _, p in pairs( game.players ) do
		local m = mod_gui.get_button_flow( p )
		if not m.ElectricButton then
			local b = F.AddSpriteButton( m, "ElectricButton", "item/Senpais-Power-Provider" )
		end
		global.GUIS[p.index] = global.GUIS[p.index] or {}
	end
end
F.GUI = function( m, id )
	local G = {}

	G.A01 = F.AddFrame( m, "ElectricFrame", "frame_in_right_container" )
	G.A02 =
	{
		F.AddLabel( G.A01, "ElectricLabel01", { "Electronic-Locomotives.ElectricStates" } ),
		F.AddFlow( G.A01, "ElectricFlow01", "description_vertical_flow" ),
		F.AddFlow( G.A01, "ElectricFlow02", "description_vertical_flow" ),
		F.AddFlow( G.A01, "ElectricFlow03", "description_vertical_flow" ),
		F.AddFlow( G.A01, "ElectricFlow04", "description_vertical_flow" ),
		F.AddFlow( G.A01, "ElectricFlow05", "description_vertical_flow" ),
		F.AddFlow( G.A01, "ElectricFlow06", "description_vertical_flow" ),
		F.AddFlow( G.A01, "ElectricFlow07", "description_vertical_flow" ),
		F.AddProgressbar( G.A01, "ElectricProgressbar", 0 )
	}
	G.A02[1].style = "description_title_label"
	G.A02[9].style = "electric_satisfaction_progressbar"
	G.A03 =
	{
		F.AddTable( G.A02[2], "ElectricTable01", 2 ),
		F.AddTable( G.A02[3], "ElectricTable02", 2 ),
		F.AddTable( G.A02[4], "ElectricTable03", 2 ),
		F.AddTable( G.A02[5], "ElectricTable04", 2 ),
		F.AddTable( G.A02[6], "ElectricTable05", 2 ),
		F.AddTable( G.A02[7], "ElectricTable06", 2 ),
		F.AddTable( G.A02[8], "ElectricTable06", 2 ),
	}
	G.A04 =
	{
		F.AddLabel( G.A03[1], "ElectricLabel02", { "Electronic-Locomotives.ELC" } ),
		F.AddLabel( G.A03[1], "ElectricLabel03", "" ),
		F.AddLabel( G.A03[2], "ElectricLabel04", { "Electronic-Locomotives.CAEL" } ),
		F.AddLabel( G.A03[2], "ElectricLabel05", "" ),
		F.AddLabel( G.A03[3], "ElectricLabel06", { "Electronic-Locomotives.TPNFL" } ),
		F.AddLabel( G.A03[3], "ElectricLabel07", "" ),
		F.AddLabel( G.A03[4], "ElectricLabel08", { "Electronic-Locomotives.PC" } ),
		F.AddLabel( G.A03[4], "ElectricLabel09", "" ),
		F.AddLabel( G.A03[5], "ElectricLabel10", { "Electronic-Locomotives.TPIP" } ),
		F.AddLabel( G.A03[5], "ElectricLabel11", "" ),
		F.AddLabel( G.A03[6], "ElectricLabel12", { "Electronic-Locomotives.TPPCS" } ),
		F.AddLabel( G.A03[6], "ElectricLabel13", "" ),
		F.AddLabel( G.A03[7], "ElectricLabel14", { "Electronic-Locomotives.CPI" } ),
		F.AddLabel( G.A03[7], "ElectricLabel15", "" )
	}
	G.A04[1].style = "description_label"
	G.A04[2].style = "description_value_label"
	G.A04[3].style = "description_label"
	G.A04[4].style = "description_value_label"
	G.A04[5].style = "description_label"
	G.A04[6].style = "description_value_label"
	G.A04[7].style = "description_label"
	G.A04[8].style = "description_value_label"
	G.A04[9].style = "description_label"
	G.A04[10].style = "description_value_label"
	G.A04[11].style = "description_label"
	G.A04[12].style = "description_value_label"
	G.A04[13].style = "description_label"
	G.A04[14].style = "description_value_label"
	global.GUIS[id] = G
	F.Update( id )
end
F.Round = function( n, d )
	local m = 10 ^ d
	return math.floor( n * m + 0.5 ) / m
end
F.Remove = function( id )
	global.List.Trains[id] = nil
	global.Power[id] = nil
end
F.Update = function( id )
	local pn = 0
	local pp = 0
	local ppa = 0
	local am = 0
	local int = 0
	local data = { t = 1, i = 1, m = 3, p = 2 }
	local tl = global.Power
	local al = global.List.Accus
	if next( tl ) then
		for i, t in pairs( tl ) do
			if t.valid then
				pn = pn + ( t.burner.heat_capacity * 0.05625 )
			else
				F.Remove( i )
			end
		end
	end
	tl = global.Power
	while ( pn > 1000 and data.t < 5 ) do
		pn = pn / 1000
		data.t = data.t + 1
	end
	for i, a in pairs( al ) do
		if a.valid then
			pp = pp + a.energy
			if a.energy < 200000000 then
				int = int + 1
			end
		else
			global.List.Accus[i] = nil
		end
	end
	al = global.List.Accus
	local ali = table_size( al )
	am = 200 * ali
	ppa = 1000000 * am
	while ( pp > 1000 and data.i < 6 ) do
		pp = pp / 1000
		ppa = ppa / 1000
		data.i = data.i + 1
	end
	pp = F.Round( pp, 2 )
	ppa = F.Round( ppa, 2 )
	while ( am > 1000 and data.m < 6 ) do
		am = am / 1000
		data.m = data.m + 1
	end
	int = int * 5
	while ( int > 1000 and data.p < 5 ) do
		int = int / 1000
		data.p = data.p + 1
	end
	int = F.Round( int, 1 )
	local G = global.GUIS[id]
	if ali > 0 then
		G.A02[9].value = pp / ppa
	else
		G.A02[9].value = 0
	end
	G.A04[2].caption = table_size( global.List.Trains )
	G.A04[4].caption = table_size( tl )
	G.A04[6].caption = { "Electronic-Locomotives." .. F.w["w" .. data.t], pn }
	G.A04[8].caption = table_size( al )
	G.A04[10].caption = { "Electronic-Locomotives." .. F.j["j" .. data.i], pp }
	G.A04[12].caption = { "Electronic-Locomotives." .. F.j["j" .. data.m], am }
	G.A04[14].caption = { "Electronic-Locomotives." .. F.w["w" .. data.p], int }
	global.GUIS[id] = G
end
F.AddFlow = function( f, n, s )
	return f.add{ type = "flow", name = n, direction = "vertical", style = s }
end
F.AddFrame = function( f, n, s )
	return f.add{ type = "frame", name = n, direction = "vertical", style = s, caption = c }
end
F.AddLabel = function( f, n, c )
	return f.add{ type = "label", name = n, caption = c }
end
F.AddProgressbar = function( f, n, s, v )
	return f.add{ type = "progressbar", name = n, value = v }
end
F.AddSpriteButton = function( f, n, s )
	return f.add{ type = "sprite-button", name = n, sprite = s }
end
F.AddTable = function( f, n, c )
	return f.add{ type = "table", name = n, column_count = c }
end

return F