--wichtige vorgenerirungen
ESX = nil

local Categories = {}
local Vehicles   = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
--ende
RegisterServerEvent("admin:getIsAllowed")
AddEventHandler("admin:getIsAllowed", function()
    if IsPlayerAceAllowed(source, "simpleadmin.admin") then
        TriggerClientEvent("admin:returnIsAllowed", source, true)
    else
        TriggerClientEvent("admin:returnIsAllowed", source, false)
    end
end)
RegisterServerEvent("admin:getEUP")
AddEventHandler("admin:getEUP", function()
    if IsPlayerAceAllowed(source, "eup.command") then
        TriggerClientEvent("admin:returnIsAllowed", source, true)
    else
        TriggerClientEvent("admin:returnIsAllowed", source, false)
    end
end)


--givecar
RegisterServerEvent("SimpleAdmin:getIsAllowedmanagecar")
	AddEventHandler('SimpleAdmin:getIsAllowedmanagecar', function(playerId,carspawnname)
	
	
		local adminname
		if IsPlayerAceAllowed(source, "simpleadmin.managecar") then
			local adminname = source
				TriggerClientEvent('simpleadmin:register',source,carspawnname,playerId)
				
				RegisterServerEvent('simpleadmin:sql')
					
				AddEventHandler('simpleadmin:sql', function (vehicleProps,youId)
				
					local _source = youId
					local xPlayer = ESX.GetPlayerFromId(_source)

					MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, stored) VALUES (@owner, @plate, @vehicle, @stored )',
					{
						['@owner']   = xPlayer.identifier,
						['@plate']   = vehicleProps.plate,
						['@vehicle'] = json.encode(vehicleProps),
						['@stored'] = 1
					}, function (rowsChanged)
						TriggerClientEvent('esx:showNotification', _source,'Auto eingefügt:'..vehicleProps.plate)
						TriggerClientEvent('esx:showNotification', adminname,'Spieler '..GetPlayerName(_source) ..' hat sein Auto erfolgreich erhalten! Kenzeichen: '..vehicleProps.plate)						
					end)
				end)
		end
	end)
--givecar
--removecar
RegisterServerEvent("SimpleAdmin:removecar")
	AddEventHandler('SimpleAdmin:removecar', function(playerId,carlicenseplate)
	
	
	
		if IsPlayerAceAllowed(source, "simpleadmin.managecar") then
		
				MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
				['@plate'] = carlicenseplate
			})	
		end
	end)
--removecar	
	

	

function PrintDebugMessage(msg)
	if enableDebugging then -- make sure debugging is enabled before Proceding
		Citizen.Trace("^1"..GetCurrentResourceName().."^7: "..msg.."^7\n")
	else
		if GetConvar("ea_enableDebugging", "false") == "true" then
			enableDebugging = true
			PrintDebugMessage(msg) -- recursion?
		end
	end
end
--wichtige function
ESX.RegisterServerCallback('simpleadmin:isPlateTaken', function (source, cb, plate)
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function (result)
		cb(result[1] ~= nil)
	end)
end)







function mysplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

--testbereich
--RegisterServerEvent("SimpleAdmin:getIsAllowedmanagecar")
--	AddEventHandler('SimpleAdmin:getIsAllowedmanagecar', function(playerId,carspawnname)
--	
--		if IsPlayerAceAllowed(source, "simpleadmin.managecar") then
--		
----SendWebhookMessage(moderationNotification,string.format(GetLocalisedText("adminkickedplayer"), getName(source), getName(playerId), carspawnname))
--PrintDebugMessage("Kicking Player "..GetPlayerName(playerId).." for "..carspawnname)
--DropPlayer(playerId,"Hey "..GetPlayerName(playerId).." du wurdest von "..GetPlayerName(source).." mit der begründung "..carspawnname.."gekickt." )
--			
--end
--	end)

--function PrintDebugMessage(msg)
--	if enableDebugging then -- make sure debugging is enabled before Proceding
--		Citizen.Trace("^1"..GetCurrentResourceName().."^7: "..msg.."^7\n")
--	else
--		if GetConvar("ea_enableDebugging", "false") == "true" then
--			enableDebugging = true
--			PrintDebugMessage(msg) -- recursion?
--		end
--	end
--end