local SOLACELIB_MAJOR, SOLACELIB_MINOR = "SolaceLib", 0.50
local SolaceLib = _G[SOLACELIB_MAJOR]

if not SolaceLib or SolaceLib.minor < SOLACELIB_MINOR then 
	SolaceLib = SolaceLib or { }
	_G[SOLACELIB_MAJOR] = SolaceLib
	SolaceLib.minor = SOLACELIB_MINOR

	SolaceLib.commandsCount = 0
	SolaceLib.commands = { }

	SolaceLibOptions = {}
	SolaceLibOptions["spam"] = false

	SLASH_SOLACE1 = "/solace"
	SlashCmdList["SOLACE"] = function(msg) SolaceLib:slashHandler(msg) end

	function SolaceLib:commandsInit(cmd,desc,fnct)
		
		-- Initialize soulmsg
		SolaceLib.commandsCount = SolaceLib.commandsCount + 1
		SolaceLib.commands[SolaceLib.commandsCount] = { }
		SolaceLib.commands[SolaceLib.commandsCount].cmd = cmd
		SolaceLib.commands[SolaceLib.commandsCount].desc = desc
		if type( fnct ) == "string" then
			SolaceLib.commands[SolaceLib.commandsCount].func = function(msg, index)
				self[fnct](SolaceLib, msg, index)
			end
		else
			SolaceLib.commands[SolaceLib.commandsCount].func = fnct
		end
	end

	function SolaceLib:printHelp()
		DEFAULT_CHAT_FRAME:AddMessage("/solace commands:")
		for i = 1, SolaceLib.commandsCount do
			DEFAULT_CHAT_FRAME:AddMessage(" - "..SolaceLib.commands[i].cmd..": "..SolaceLib.commands[i].desc)
		end
	end

	-- Internal function to pick which channel to should get the messages.
	function SolaceLib:slashParser(msg)
		local firstspace = string.find(msg, " ", 1, true)
		if (firstspace) then
			local command = string.sub(msg, 1, firstspace - 1)
			local option = string.sub(msg, firstspace + 1)
			return command, option
		else
			return msg, nil
		end
	end

	function SolaceLib:cmdSearch(needle)
		for idx, command in pairs(SolaceLib.commands) do
			if needle == command.cmd then
				SolaceLib:debugPrint(needle.." does match known command "..command.cmd..".")
				return command, idx
			else
				SolaceLib:debugPrint(needle.." does not match known command "..command.cmd..".")
			end
		end
		return nil
	end

	function SolaceLib:slashHandler(msg)
		SolaceLib:debugPrint("SolaceLib:slashHandler("..msg..")")
		local carg1, carg2 = SolaceLib:slashParser(msg)
		local matchfound = false
		
		if carg1 then
			carg1 = string.lower(carg1)
		end

		SolaceLib:debugPrint("carg1: "..carg1)
		SolaceLib:debugPrint("carg2: "..(carg2 == nil and "nil" or carg2))
		
		if ( not carg1 ) then
			SolaceLib:printHelp()
		else
			command, idx = SolaceLib:cmdSearch(carg1)

			if command == nil then
				if carg1 then
					DEFAULT_CHAT_FRAME:AddMessage("/solace: No such command as "..carg1)
				end
				SolaceLib:printHelp()
			else
				command.func(carg2, idx)
			end
		end
	end

	function SolaceLib:getCmdindex(cmd)
		for idx, command in pairs(SolaceLib.commands) do
			if cmd == command.cmd then
				return idx
			end
		end
		return false
	end

	-- Compatibility Functions
	function SolaceCmdInit(cmd,desc,fun)
		DEFAULT_CHAT_FRAME:AddMessage("One of your Solace mods is out of date!  Please update SolaceBuffDisplay or SolaceStones.")
		SolaceLib:commandsInit(cmd,desc,func)
	end
	function SolaceGetCmdIndex(cmd) SolaceLib:getCmdindex(cmd) end
	SOLACELIB_VER = SOLACELIB_MINOR
	-- End Compatibility Functions

	function SolaceLib:debugPrint(s)
		if SolaceLibOptions["spam"] then
			print(s)
		end
	end

	function SolaceLib:SetSpam(msg, idx)
		SolaceLibOptions["spam"] = not SolaceLibOptions["spam"]
		DEFAULT_CHAT_FRAME:AddMessage("/solace: spam is now "..(SolaceLibOptions["spam"] and "true" or "false"))
	end

	function SolaceLib:Init()
		self:commandsInit("spam", "Toggle spamminess", "SetSpam")
	end
	SolaceLib:Init()
end