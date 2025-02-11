local SPBMJR, SPBVER = "SolacePartyBuffs", "7.2.0"

local SolaceLib = _G["SolaceLib"]
local SolaceTargetFrame = nil

SolacePartyBuffs = CreateFrame("Frame")
SolacePartyBuffs:RegisterEvent("UNIT_AURA")
SolacePartyBuffs:RegisterEvent("VARIABLES_LOADED")
SolacePartyBuffs:RegisterEvent("GROUP_ROSTER_UPDATE")
SolacePartyBuffs:RegisterEvent("PLAYER_ENTERING_WORLD")

-- SolacePartyBuffs:RegisterEvent("PLAYER_TALENT_UPDATE")
SolacePartyBuffs.version = SPBVER

SolacePartyBuffsOptions = {
	["max_party_buffs"] = 32,
	["max_party_debuffs"] = 40,
	["filter_castable"] = true
}

SolacePartyBuffs.CanDispel = {
	DRUID = {
		Curse = true,
		Poison = true
	},
	MONK = {
		Poison = true,
		Disease = true
	},
	PALADIN = {
		Poison = true,
		Disease = true
	},
	PRIEST = {
		Disease = true
	},
	SHAMAN = {
		Curse = true
	}
}

SolacePartyBuffs.frameref = {
	["party1"] = "SolacePartyBuffFrame1",
	["party2"] = "SolacePartyBuffFrame2",
	["party3"] = "SolacePartyBuffFrame3",
	["party4"] = "SolacePartyBuffFrame4"
}

SolacePartyBuffs.blizzframes = {
	["party1"] = "PartyMemberFrame1",
	["party2"] = "PartyMemberFrame2",
	["party3"] = "PartyMemberFrame3",
	["party4"] = "PartyMemberFrame4"
}

function SolacePartyBuffs:ErrorMsg(name, index)
	-- DEFAULT_CHAT_FRAME:AddMessage("/solace"..SolaceLib.commands[index].cmd..": "..SolaceLib.commands[index].desc)
	-- DEFAULT_CHAT_FRAME:AddMessage(SPB_CURRENT..SolacePartyBuffsOptions[name])
end

function SolacePartyBuffs:filterhandler(msg, index)
	SolaceLib:debugPrint("SolacePartyBuffs:filterhandler("..(msg == nil and "nil" or msg)..", "..index..")")
	if msg then
		if ( msg == "on" ) then
			SolacePartyBuffsOptions.filter_castable = true
			-- DEFAULT_CHAT_FRAME:AddMessage(SPB_PFILTER_CHANGED..SPB_ENABLED)
		elseif ( msg == "off" ) then
			SolacePartyBuffsOptions.filter_castable = false
			-- DEFAULT_CHAT_FRAME:AddMessage(SPB_PFILTER_CHANGED..SPB_DISABLED)
		else
			-- DEFAULT_CHAT_FRAME:AddMessage("/solace"..SolaceLib.commands[index].cmd..": "..SolaceLib.commands[index].desc)
			if ( SolacePartyBuffsOptions.filter_castable == true ) then
				-- DEFAULT_CHAT_FRAME:AddMessage(SPB_CURRENT..SPB_ENABLED)
			else
				-- DEFAULT_CHAT_FRAME:AddMessage(SPB_CURRENT..SPB_DISABLED)
			end
		end
		for i = 1, GetNumGroupMembers() do
			SolacePartyBuffs:UpdateBuffs("party"..i)
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage("/solace"..SolaceLib.commands[index].cmd..": "..SolaceLib.commands[index].desc)
		if ( SolacePartyBuffsOptions.filter_castable == true ) then
			-- DEFAULT_CHAT_FRAME:AddMessage(SPB_CURRENT..SPB_ENABLED)
		else
			-- DEFAULT_CHAT_FRAME:AddMessage(SPB_CURRENT..SPB_DISABLED)
		end
	end
end

function SolacePartyBuffs:onEvent(event, ...)
	if SolaceTargetFrame == nil then
		SolaceTargetFrame = _G["SolaceTargetFrame"]
	else
		SolaceTargetFrame:onEvent(event, ...)
	end
	
	if ( event == "VARIABLES_LOADED" ) then
		self["commandsInit"] = SolaceLib["commandsInit"]
		self:commandsInit("maxpartybuffs", SPB_MAXPARTYBUFFS, "buffshandler")
		self:commandsInit("maxpartydebuffs", SPB_MAXPARTYDEBUFFS, "debuffshandler")
		self:commandsInit("partyaurafilter", SPB_FILTERDEBUFFS, "filterhandler")
		-- DEFAULT_CHAT_FRAME:AddMessage(SPB_LOADED)
		SolaceLib:debugPrint(SolacePartyBuffsOptions["max_party_debuffs"])
	end
	if ( event == "UNIT_AURA" ) then
		local arg1 = ...
		SolaceLib:debugPrint("Updating auras for "..(arg1 == nil and "nil" or arg1))
		for k, v in pairs(SolacePartyBuffs.frameref) do
			if ( arg1 == k ) then
				SolacePartyBuffs:UpdateBuffs(arg1)
				return
			end
		end
	end
	if ( event == "PARTY_MEMBERS_CHANGED" or event == "PLAYER_ENTERING_WORLD" ) then
		for i = 1, GetNumGroupMembers() do
			self:UpdateBuffs("party"..i)
		end
	end
	
end

SolacePartyBuffs:SetScript("OnEvent", SolacePartyBuffs["onEvent"])

function SolacePartyBuffs:UpdateBuffs(unit)
	SolaceLib:debugPrint("SolacePartyBuffs:UpdateBuffs("..unit..")")
	if not unit then return end
--~ 	Hide the Blizzard debuffs.
	for i = 1, 4 do
		local blizz_frame = self.blizzframes[unit]
		if blizz_frame ~= nil then
			_G[blizz_frame.."Debuff"..i]:Hide()
		end
	end
	
	local frame = self.frameref[unit]
	
	if frame == nil then
		return
	end
	
	local button, buttonname
	local name, icon, count, duration, expirationTime
	local buffCount
	local cooldown, startCooldownTime
	local filter_castable = nil
	
	if SolacePartyBuffsOptions.filter_castable then filter_castable = "PLAYER" end
	
	local i = 1
	while ( i <= SolacePartyBuffsOptions.max_party_buffs ) do
		name, icon, count, debuffType, duration, expirationTime = UnitBuff(unit, i, "HELPFUL")
		-- SolaceLib:debugPrint(name, icon, count, debuffType, duration, expirationTime)
		buttonname = frame.."Buff"..i
		button = _G[buttonname]
		
		if ( icon ) then
			if ( not button ) then
				button = CreateFrame("Button", buttonname, _G[frame], "SolacePartyBuffButtonTemplate")
			end

			_G[buttonname.."Icon"]:SetTexture(icon)
			buffCount = _G[buttonname.."Count"]
			
			if (count > 1) then
				buffCount:SetText(count)
				buffCount:Show()
			else
				buffCount:Hide()
			end
			
			cooldown = _G[buttonname.."Cooldown"]
			if ( duration and expirationTime ) then
				if ( duration > 0 ) then
					cooldown:Show()
					CooldownFrame_Set(cooldown, expirationTime - duration, duration, 1)
				else
					cooldown:Hide()
				end
			else
				cooldown:Hide()
			end
			
			button:SetID(i)
			
			button:ClearAllPoints()
			self:PositionButtons(frame.."Buff", i, frame, "Buff")
			
			button:Show()
		else
			if (button) then
				button:Hide()
			end
		end

		i = i + 1
	end

	local debuffType, color
	local debuffCount, debuffBorder
	local buttonname, button
	local debuffIdx = 0

	local _, eClass = UnitClass("player")

	i = 1
	SolaceLib:debugPrint("..Checking up to "..SolacePartyBuffsOptions.max_party_debuffs.." debuffs")
	while i <= SolacePartyBuffsOptions.max_party_debuffs do
		
		name, icon, count, debuffType, duration, timeLeft = UnitDebuff(unit, i, "HARMFUL")

		-- SolaceLib:debugPrint("eClass = "..(eClass == nil and "nil" or eClass))
		-- SolaceLib:debugPrint("Checking debuff at idx "..i..":")
		-- SolaceLib:debugPrint(name, icon, count, debuffType, duration, timeLeft)
		if self.CanDispel[eClass] then
			SolaceLib:debugPrint(SolacePartyBuffs.CanDispel[eClass][debuffType] == nil and "nil" or SolacePartyBuffs.CanDispel[eClass][debuffType])
		end

		if (
				debuffType == nil
			) or (
				self.CanDispel[eClass] and (self.CanDispel[eClass][debuffType] == true)
			)
		then
			debuffIdx = debuffIdx + 1
			buttonname = frame.."Debuff"..debuffIdx
			button = _G[buttonname]
			
			if ( icon ) then
				if ( not button ) then
					button = CreateFrame("Button", buttonname, _G[frame], "SolacePartyDebuffButtonTemplate")
				end
				debuffBorder = _G[buttonname.."Border"]
				
				_G[buttonname.."Icon"]:SetTexture(icon)
				debuffCount = _G[buttonname.."Count"]
				
				if ( debuffType ) then
					color = DebuffTypeColor[debuffType]
				else
					color = DebuffTypeColor["none"]
				end
				
				if (count > 1) then
					debuffCount:SetText(count)
					debuffCount:Show()
				else
					debuffCount:Hide()
				end
				
				cooldown = _G[buttonname.."Cooldown"]
				if ( duration and expirationTime ) then
					if ( duration > 0 ) then
						cooldown:Show()
						CooldownFrame_Set(cooldown, expirationTime - duration, duration, 1)
					else
						cooldown:Hide()
					end
				else
					cooldown:Hide()
				end
				
				debuffBorder:SetVertexColor(color.r, color.g, color.b)
				
				button:SetID(debuffIdx)
				
				button:ClearAllPoints()
				self:PositionButtons(frame.."Debuff", debuffIdx, frame, "Debuff")
				
				button:Show()
				
			else
				if button then
					button:Hide()
				end
			end
		end
	i = i + 1
	end

	debuffIdx = debuffIdx + 1
	buttonname = frame.."Debuff"..debuffIdx
	button = _G[buttonname]
	while (button) do
		button:Hide()
		debuffIdx = debuffIdx + 1
		buttonname = frame.."Debuff"..debuffIdx
		button = _G[buttonname]
	end
end

function SolacePartyBuffs:PositionButtons(name, index, frame, btype)
	local button = _G[name..index]
	local debuffBorder = _G[name..index.."Border"]
	if ( btype == "Buff" ) then
		if ( index == 1 ) then
			button:SetPoint("TOPLEFT", _G[frame], "TOPLEFT", 0, 0)
		elseif ( index == 17 ) then
			button:SetPoint("TOPLEFT", _G[name.."3"], "BOTTOM", 0, -2)
		else
			button:SetPoint("TOPLEFT", _G[name..(index - 1)], "TOPRIGHT", 2, 0)
		end
	else
		if ( index == 1 ) then
			debuffBorder:Hide()
			button:SetPoint("LEFT", _G[frame], "LEFT", 75, 38)
			debuffBorder:SetPoint("CENTER", button, "CENTER", 0, 0)
			debuffBorder:Show()
		else
			button:SetPoint("TOPLEFT", _G[name..(index - 1)], "TOPRIGHT", 2, 0)
		end
	end
end

function SolacePartyBuffs:TalentDetect(eClass)
	local a, b, c, d, role, f, g, h, i = GetSpecializationInfo(GetSpecialization())

	if ( eClass == "DRUID" ) then
		if ( role == "HEALER" ) then
			SolacePartyBuffs.CanDispel[eClass]["Magic"] = true
		else
			SolacePartyBuffs.CanDispel[eClass]["Magic"] = false
		end
	elseif ( eClass == "MONK" ) then
		if ( role == "HEALER" ) then
			SolacePartyBuffs.CanDispel[eClass]["Magic"] = true
		else
			SolacePartyBuffs.CanDispel[eClass]["Magic"] = false
		end
	elseif ( eClass == "PALADIN" ) then
		if ( role == "HEALER" ) then
			SolacePartyBuffs.CanDispel[eClass]["Magic"] = true
		else
			SolacePartyBuffs.CanDispel[eClass]["Magic"] = false
		end
	elseif ( eClass == "PRIEST" ) then
		if ( role == "HEALER" ) then
			SolacePartyBuffs.CanDispel[eClass]["Magic"] = true
		else
			SolacePartyBuffs.CanDispel[eClass]["Magic"] = false
		end
	elseif ( eClass == "SHAMAN" ) then
		if ( role == "HEALER" ) then
			SolacePartyBuffs.CanDispel[eClass]["Magic"] = true
		else
			SolacePartyBuffs.CanDispel[eClass]["Magic"] = false
		end
	end
end

local oldPartyMemberBuffTooltip_Update = PartyMemberBuffTooltip_Update
local function newPartyMemberBuffTooltip_Update(self)
	oldPartyMemberBuffTooltip_Update(self)    
	if (not string.find(self.unit,"pet")) then
		PartyMemberBuffTooltip:Hide()
	end
end
PartyMemberBuffTooltip_Update = newPartyMemberBuffTooltip_Update
