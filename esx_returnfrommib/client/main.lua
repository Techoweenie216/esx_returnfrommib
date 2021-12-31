ESX              = nil
local PlayerData = {}
local HasAlreadyGotMessage = false
local isInMarker = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)


Citizen.CreateThread(function()
   local markerPos = vector3(487.1351, 4820.73, -57.68285)
   local controlpanelmarker = vector3(2459.764, -387.1532, 92.32552)
   
   while true do
	Citizen.Wait(1)
	local ped = GetPlayerPed(-1)
	local playerCoords = GetEntityCoords(ped)
	local distance = #(playerCoords - markerPos)
	local distance2 = #(playerCoords - controlpanelmarker)

	
		if distance < 1.5 then
			isInMarker = true
			transportback()
		else 
			isInMarker = false
		
		end
	
		if distance2 < 1.5 then
			isInMarker = true
			transportinside()
		else 
			isInMarker = false
		end

	end
end)
	
function transportback()
	local markerPos = vector3(487.1351, 4820.73, -57.68285)
	ESX.Game.Utils.DrawText3D(markerPos, "Press ~y~[H]~w~ to transport the Fed Facility.", 4, 4)

	-- press H key    
		if IsControlJustReleased(0, 74) then 
		local dict = 'anim@amb@office@standing@male@game@var_a@base@'
		local anim = 'enter'
		local ped = GetPlayerPed(-1)
		local time = 2500

		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(7)
		end

		TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 0, 0, 0, 0, 0)
		Citizen.Wait(time)
		ClearPedTasks(ped)
		
		if ESX.Game.IsSpawnPointClear(vector3(2457.52, -381.81, 93.33),1) then
			RequestNamedPtfxAsset("scr_rcbarry1")
			-- Wait for the particle dictionary to load.
			while not HasNamedPtfxAssetLoaded("scr_rcbarry1") do
				Citizen.Wait(0)
			end	
					
			-- Display particle
			UseParticleFxAssetNextCall("scr_rcbarry1")
			local playerCoords = GetEntityCoords(ped)
			StartParticleFxNonLoopedAtCoord("scr_alien_teleport", playerCoords.x, playerCoords.y, playerCoords.z+0.25, 0.0, 0.0, 0.0, 1.2, false, false, false)
			Citizen.Wait(1650)
			DoScreenFadeOut(100)
			Citizen.Wait(750)
			ESX.Game.Teleport(PlayerPedId(), {x = 2457.52, y = -381.81, z = 93.33, h = 80.09} )
			DoScreenFadeIn(100)
			
		end
		end
end

function transportinside()
	local inventory = ESX.GetPlayerData().inventory
	local controltext = vector3(2459.764, -387.1532, 94.32552)
	
	ESX.Game.Utils.DrawText3D(controltext, "Press ~y~[H]~w~ to enter.", 4, 4)
	
		-- press H key    
		if IsControlJustReleased(0, 74) then 
			local dict = 'anim@amb@office@standing@male@game@var_a@base@'
			local anim = 'enter'
			local ped = GetPlayerPed(-1)
			local time = 2500

			RequestAnimDict(dict)

			while not HasAnimDictLoaded(dict) do
				Citizen.Wait(7)
			end

			TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 0, 0, 0, 0, 0)
			Citizen.Wait(time)
			ClearPedTasks(ped)


		--local count = 0
			for i=1, #inventory, 1 do
				-- if the player had the mib badge then teleport is active
				if inventory[i].name == 'mib-id' then
					if inventory[i].count > 0 then
						
						--if proper ID is in inverntory fire up the transporter
						RequestNamedPtfxAsset("scr_rcbarry1")
						-- Wait for the particle dictionary to load.
						while not HasNamedPtfxAssetLoaded("scr_rcbarry1") do
							Citizen.Wait(0)
						end	

						TriggerEvent('chatMessage', 'You have your ID.')
						Citizen.Wait(1000)
						TriggerEvent('chatMessage', 'Please wait for the teleport to warm up. Please stand still')
						
						-- Display particle
						UseParticleFxAssetNextCall("scr_rcbarry1")
						local playerCoords = GetEntityCoords(ped)
						StartParticleFxNonLoopedAtCoord("scr_alien_teleport", playerCoords.x, playerCoords.y, playerCoords.z+0.25, 0.0, 0.0, 0.0, 1.2, false, false, false)

						Citizen.Wait(1650)
						TriggerEvent('chatMessage', 'Teleporting now.')
						DoScreenFadeOut(100)
						Citizen.Wait(750)
						ESX.Game.Teleport(PlayerPedId(), {x = 482.67, y = 4812.92, z = -58.38, h = 13.05} )
						DoScreenFadeIn(100)
						HasAlreadyGotMessage = true
					end
					
					
					if inventory[i].count <= 0 then
						TriggerEvent('chatMessage', 'You do not have the proper code.')
						Citizen.Wait(2000)
						HasAlreadyGotMessage = true
					end
				end
			end
		end
end

