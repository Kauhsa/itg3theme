-- A Simple Alias for Easier Referencing
local ProfileTable = PROFILEMAN:GetMachineProfile():GetSaved()

function CreditTypeRow()
	local Names = { "Coins", "Tokens", "Swipe Card" }

	local type = ProfileTable.CreditType

	-- called on construction, must set exactly one list member true
	local function Load(self, list, pn)
		-- short-circuit to 'coin' if no option is set
		if not type then list[1] = true return end

		-- do any of the options match the given type?
		for i=1,3 do
			if type == string.lower(Names[i]) then list[i] = true return end
		end

		-- none of the above worked. fallback on coin
		list[1] = true
	end

	-- called as the screen destructs, to save the selected option in list
	local function Save(self, list, pn)
		for i=1,3 do
			if list[i] then
				ProfileTable.CreditType = string.lower(Names[i])
				PROFILEMAN:SaveMachineProfile()
				return
			end
		end
	end

	
	local Params = { Name = "CreditType" }

	return CreateOptionRow( Params, Names, Load, Save )
end

--put in some settings that allow you to bump in the lifebars on certain widescreen setups
function LifebarAdjustmentRow()
	local Names = { "0", "5", "10", "15", "20", "25", "30", "35", "40", "45", "50" }

	local type = ProfileTable.LifebarAdjustment
	
	local function Load(self, list, pn)
		if not type then list[1] = true return end

		for i=1,11 do
			if type == string.lower(Names[i]) then list[i] = true return end
		end

		list[1] = true
	end

	local function Save(self, list, pn)
		for i=1,11 do
			if list[i] then
				ProfileTable.LifebarAdjustment = string.lower(Names[i])
				PROFILEMAN:SaveMachineProfile()
				return
			end
		end
	end

	
	local Params = { Name = "LifebarAdjustment" }

	return CreateOptionRow( Params, Names, Load, Save )
end

-- To be called wherever the LUA needs split
function GetCreditType()
	local type = ProfileTable.CreditType
	-- assume "coin" unless otherwise specified
	if not type then return "INSERT COIN" end
	if type == "tokens" then return "INSERT TOKEN"
	elseif type == "swipe card" then return "SWIPE CARD"
	else return "INSERT COIN" end
	return type
end

-- To be called wherever the lifebars are positioned
function GetLifebarAdjustment()
	local type = ProfileTable.LifebarAdjustment
	-- assume "coin" unless otherwise specified
	if not type then return "0" end
	return type
end


function CleanScreen()
	local Names = { "Disabled", "Enabled" }

	local type = ProfileTable.CleanScreen

	-- called on construction, must set exactly one list member true
	local function Load(self, list, pn)
		-- short-circuit to 'disabled' if no option is set
		if not type then list[1] = true return end

		-- do any of the options match the given type?
		for i=1,2 do
			if type == string.lower(Names[i]) then list[i] = true return end
		end

		-- none of the above worked. fallback on disabled
		list[1] = true
	end

	-- called as the screen destructs, to save the selected option in list
	local function Save(self, list, pn)
		for i=1,2 do
			if list[i] then
				ProfileTable.CleanScreen = string.lower(Names[i])
				PROFILEMAN:SaveMachineProfile()
				return
			end
		end
	end

	
	local Params = { Name = "CleanScreen" }

	return CreateOptionRow( Params, Names, Load, Save )
end

function GetCleanScreen()
	local type = ProfileTable.CleanScreen

	if type == "enabled" then
	return true else 
	return false
	end
end

function CleanStartTime()
	local Names = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23" }

	local type = ProfileTable.CleanStartTime
	
	-- called on construction, must set exactly one list member true
	local function Load(self, list, pn)
		-- short-circuit to '1' if no option is set
		if not type then list[1] = true return end

		-- do any of the options match the given type?
		for i=1,24 do
			if type == string.lower(Names[i]) then list[i] = true return end
		end

		-- none of the above worked. fallback on 1
		list[1] = true
	end

	local function Save(self, list, pn)
		for i=1,23 do
			if list[i] then
				ProfileTable.CleanStartTime = string.lower(Names[i])
				PROFILEMAN:SaveMachineProfile()
				return
			end
		end
	end
	
	local Params = { Name = "CleanStartTime" }

	return CreateOptionRow( Params, Names, Load, Save )
end

function GetCleanStartTime()
	return tonumber(ProfileTable.CleanStartTime)
end

function CleanEndTime()
	local Names = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23" }

	local type = ProfileTable.CleanEndTime
	
	-- called on construction, must set exactly one list member true
	local function Load(self, list, pn)
		-- short-circuit to '2' if no option is set
		if not type then list[2] = true return end

		-- do any of the options match the given type?
		for i=1,23 do
			if type == string.lower(Names[i]) then list[i] = true return end
		end

		-- none of the above worked. fallback on 2
		list[1] = true
	end

	local function Save(self, list, pn)
		for i=1,23 do
			if list[i] then
				ProfileTable.CleanEndTime = string.lower(Names[i])
				PROFILEMAN:SaveMachineProfile()
				return
			end
		end
	end

	local Params = { Name = "CleanEndTime" }

	return CreateOptionRow( Params, Names, Load, Save )
end

function GetCleanEndTime()
	return tonumber(ProfileTable.CleanEndTime)
end

function Get2PlayerJoinMessage()
	if not GAMESTATE:PlayersCanJoin() then return "" end
	if GAMESTATE:GetCoinMode()==COIN_MODE_FREE then return "2 Player mode available" end
	
	local numSidesNotJoined = NUM_PLAYERS - GAMESTATE:GetNumSidesJoined()
	if GAMESTATE:GetPremium() == PREMIUM_JOINT then numSidesNotJoined = numSidesNotJoined - 1 end	
	local coinsRequiredToJoinRest = numSidesNotJoined * PREFSMAN:GetPreference("CoinsPerCredit")
	local remaining = coinsRequiredToJoinRest - GAMESTATE:GetCoins();
	local type = ProfileTable.CreditType
	
	if remaining <= 0 then return "2 Player mode available" end
	
	if type == "tokens" then
	local s = "For 2 Players, insert " .. remaining .. " more token(s)"
	if remaining > 1 then s = s.."s" end		
	return s	
	end
	
	
	if type == "swipe card" then
		local s = "For 2 Players, swipe a card with credits"	
			return s
	end
	
	if type ~= "swipe card" and type ~= "tokens" then
	local s = "For 2 Players, insert " .. remaining .. " more coin(s)"
	if remaining > 1 then s = s.."s" end
		return s
	end
end

function SpeedModTypeRow()
	local Names = { "Basic", "Advanced" }

	local type = ProfileTable.SpeedModType

	-- called on construction, must set exactly one list member true
	local function Load(self, list, pn)
		-- short-circuit to 'basic' if no option is set
		if not type then list[1] = true return end

		-- do any of the options match the given type?
		for i=1,2 do
			if type == string.lower(Names[i]) then list[i] = true return end
		end

		-- none of the above worked. fallback on standard
		list[1] = true
	end

	-- called as the screen destructs, to save the selected option in list
	local function Save(self, list, pn)
		for i=1,2 do
			if list[i] then
				ProfileTable.SpeedModType = string.lower(Names[i])
				PROFILEMAN:SaveMachineProfile()
				return
			end
		end
	end

	
	local Params = { Name = "SpeedModType" }

	return CreateOptionRow( Params, Names, Load, Save )
end

function GetSpeedModType()
	local type = ProfileTable.SpeedModType
		
	if type == "advanced" then
	return "list,Speed2" else
	return "list,Speed"
	end
end

function OptionsListToggleRow()
	local Names = { "Disabled", "Enabled" }

	local type = ProfileTable.OptionsListToggle

	-- called on construction, must set exactly one list member true
	local function Load(self, list, pn)
		-- short-circuit to 'disabled' if no option is set
		if not type then list[1] = true return end

		-- do any of the options match the given type?
		for i=1,2 do
			if type == string.lower(Names[i]) then list[i] = true return end
		end

		-- none of the above worked. fallback on standard
		list[1] = true
	end

	-- called as the screen destructs, to save the selected option in list
	local function Save(self, list, pn)
		for i=1,2 do
			if list[i] then
				ProfileTable.OptionsListToggle = string.lower(Names[i])
				PROFILEMAN:SaveMachineProfile()
				return
			end
		end
	end

	
	local Params = { Name = "OptionsListToggle" }

	return CreateOptionRow( Params, Names, Load, Save )
end

function GetOptionsList()
	local type = ProfileTable.OptionsListToggle
		
	if type == "enabled" and GAMESTATE:GetPlayMode() ~= PLAY_MODE_ONI then
	return "1" else
	return "0"
	end
end