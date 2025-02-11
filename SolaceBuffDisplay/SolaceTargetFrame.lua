local STFMJR, STFVER = "SolaceTargetFrame", "4.0.1"
local SolaceTargetFrame = _G[STFMJR] or { version = STFVER }
_G[STFMJR] = SolaceTargetFrame

SolaceTargetFrameOptions = {
	["maxbuffs"] = 32,
	["maxdebuffs"] = 40,
	["showownbig"] = "off"
}

function SolaceTargetFrame:onEvent(event, ...)
	if ( ( event == "VARIABLES_LOADED" ) ) then

	end
end

function SolaceTargetFrame:showbuffsHandler(msg,index)
	if msg then
		msg = tonumber(msg)
		if ( SolaceTargetFrameOptions.maxbuffs > msg ) then
			local button
			for i = msg+1, SolaceTargetFrameOptions.maxbuffs do
				button = _G["TargetFrameBuff"..i]
				if ( button ) then
					button:Hide()
				end
			end
		end
		MAX_TARGET_BUFFS = msg
		SolaceTargetFrameOptions.maxbuffs = msg
		DEFAULT_CHAT_FRAME:AddMessage(SOLACE_SHOWBUFFS..MAX_TARGET_BUFFS)
		TargetFrame_UpdateAuras(_G["TargetFrame"])
	else
		DEFAULT_CHAT_FRAME:AddMessage("/solace "..SolaceLib.commands[index].cmd..": "..SolaceLib.commands[index].desc)
		DEFAULT_CHAT_FRAME:AddMessage(SOLACE_SHOWBUFFS..MAX_TARGET_BUFFS)
	end
end

function SolaceTargetFrame:showdebuffsHandler(msg,index)
	if msg then
		msg = tonumber(msg)
		if ( SolaceTargetFrameOptions.maxdebuffs > msg ) then
			local button
			for i = msg+1, SolaceTargetFrameOptions.maxdebuffs do
				button = _G["TargetFrameDebuff"..i]
				if ( button ) then
					button:Hide()
				end
			end
		end
		MAX_TARGET_DEBUFFS = msg
		SolaceTargetFrameOptions.maxdebuffs = msg
		DEFAULT_CHAT_FRAME:AddMessage(SOLACE_SHOWDEBUFFS..MAX_TARGET_DEBUFFS)
		TargetFrame_UpdateAuras(_G["TargetFrame"])
	else
		DEFAULT_CHAT_FRAME:AddMessage("/solace "..SolaceLib.commands[index].cmd..": "..SolaceLib.commands[index].desc)
		DEFAULT_CHAT_FRAME:AddMessage(SOLACE_SHOWDEBUFFS..MAX_TARGET_DEBUFFS)
	end
end

function SolaceTargetFrame:showownHandler(msg,index)
	if ( msg == "on" ) then
		LARGE_BUFF_SIZE = 21
		LARGE_BUFF_FRAME_SIZE = 23
		SolaceTargetFrameOptions.showownbig = msg
		DEFAULT_CHAT_FRAME:AddMessage(SOLACE_SHOWOWNON)
	elseif ( msg == "off" ) then
		LARGE_BUFF_SIZE = 17
		LARGE_BUFF_FRAME_SIZE = 19
		SolaceTargetFrameOptions.showownbig = msg
		DEFAULT_CHAT_FRAME:AddMessage(SOLACE_SHOWOWNOFF)
	else
		DEFAULT_CHAT_FRAME:AddMessage("/solace "..SolaceLib.commands[index].cmd..": "..SolaceLib.commands[index].desc)
		DEFAULT_CHAT_FRAME:AddMessage(SOLACE_SHOWOWNCURRENT..SolaceTargetFrameOptions.showownbig)
	end
end

