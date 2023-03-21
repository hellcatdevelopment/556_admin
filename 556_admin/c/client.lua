local ShowPlayerNames = false
local ShowPedIds = false
local ShowVehIds = false
local ShowObjIds = false
local TagDrawDistance = 150
local HudIsRevealed = false
local ActivePlayers = {}
local MyCoords = vector3(0, 0, 0)
local NoClipActive = false
local invisible = false
local timer
local ids = false

local display = false
local Text = nil

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for _, playerId in ipairs(GetActivePlayers()) do
			local ped = GetPlayerPed(playerId)
			local bone = GetPedBoneCoords(ped, 12844, 0.0, 0.0, 0.0)
			local coords = GetEntityCoords(PlayerPedId())
            if ids then
			    if Citizen.InvokeNative(0xF3A21BCD95725A4A, 0, 0x8AAA0AD4) then
			    	--if ped ~= PlayerPedId() then
			    		if #(coords - bone) <= 30 and not Citizen.InvokeNative(0xD5FE956C70FF370B, ped) then -- GetPedCrouchMovement (https://vespura.com/doc/natives/?_0xD5FE956C70FF370B)
			    			if Text == nil or not Text then
			    				local text = GetPlayerServerId(playerId)
			    				if Citizen.InvokeNative(0xEF6F2A35FAAF2ED7, playerId) then -- N_0xef6f2a35faaf2ed7 (https://vespura.com/doc/natives/?_0xEF6F2A35FAAF2ED7)
			    					text = "~d~Talking~s~("..GetPlayerServerId(playerId)..")"
			    				end
			    				DrawText3D2(bone.x, bone.y, bone.z + 1.3, ''..text..'')
			    			end
			    		end
			    	--end
			    end
            end
            end
		end
end)

RegisterNetEvent('556_admin:menu')
AddEventHandler('556_admin:menu', function(_source)
	OpenItemPicture()
end)

RegisterNetEvent('556_admin:menu2')
AddEventHandler('556_admin:menu2', function(_source)
	Invisible()
    TriggerEvent('556_admin:nc')
end)

function OpenItemPicture()
    SetNuiFocus(true, true)
    SendNUIMessage({openPicture = true})
  end

RegisterNUICallback('exit', function (data)
        SetNuiFocus(false, false)
        SendNUIMessage({closePicture = false})
end)

RegisterNUICallback('god', function (data)
    SetNuiFocus(false, false)
    SendNUIMessage({closePicture = false})
    GODmode()
end)

RegisterNUICallback('noclip', function (data)
    SetNuiFocus(false, false)
    SendNUIMessage({closePicture = false})
    TriggerEvent('556_admin:nc')
end)

RegisterNUICallback('pnames', function (data)
    SetNuiFocus(false, false)
    SendNUIMessage({closePicture = false})
    TriggerEvent('556_admin:pnames')
end)

RegisterNUICallback('invisible', function (data)
    SetNuiFocus(false, false)
    SendNUIMessage({closePicture = false})
    --TriggerEvent('556_admin:invisible')
    Invisible()
end)

RegisterNUICallback('heal', function (data)
    SetNuiFocus(false, false)
    SendNUIMessage({closePicture = false})
    TriggerEvent('vorp:resurrectPlayer')
    Citizen.Wait(200)
    TriggerEvent('vorp:heal')
end)
RegisterNUICallback('id', function (data)
    SetNuiFocus(false, false)
    SendNUIMessage({closePicture = false})
    TriggerEvent('556_admin:id')

end)

Config = {

    ShowControls = true,
        Controls = {
    
            goUp = 0xD9D0E1C0, -- space
            goDown = 0x8FFC75D6, -- Z
            turnLeft = 0x7065027D, -- A
            turnRight = 0xB4E465B4, -- D
            goForward = 0x8FD015D8, -- W
            goBackward = 0xD27782E3, -- S
            changeSpeed = 0x07CE1E61, -- mwup
            ShowControls = 0x8AAA0AD4 -- left alt
        },
    
        Speeds = {
            -- You can add or edit existing speeds with relative label
            { label = 'Very Slow', speed = 0 },
            { label = 'Normal', speed = 3 },
            { label = 'Very Fast', speed = 12 },
            { label = 'Max', speed = 33 },
        },
    
        Offsets = {
            y = 0.2, -- Forward and backward movement speed multiplier
            z = 0.1, -- Upward and downward movement speed multiplier
            h = 1, -- Rotation movement speed multiplier
        },
    
        FrozenPosition = true
    }

function GODmode()
    local player = PlayerPedId()
    if not god then

        TriggerEvent("vorp:ShowSimpleCenterText", "Godmode ON", 3000)
        SetEntityCanBeDamaged(PlayerPedId(), false)
        SetEntityInvincible(PlayerPedId(), true)
        SetPedConfigFlag(PlayerPedId(), 2, true) -- no critical hits
        SetPedCanRagdoll(PlayerPedId(), false)
        SetPedCanBeTargetted(PlayerPedId(), false)
        Citizen.InvokeNative(0x5240864E847C691C, PlayerPedId(), false) --set ped can be incapacitaded
        SetPlayerInvincible(PlayerPedId(), true)
        Citizen.InvokeNative(0xFD6943B6DF77E449, PlayerPedId(), false) -- set ped can be lassoed

        --[[if Config.BoosterLogs.GodMode then -- if nil dont send
            TriggerServerEvent("vorp_admin:logs", Config.BoosterLogs.GodMode, _U("titlebooster"),
                _U("usedgod"))
        end]]
        god = true
    else

        TriggerEvent("vorp:ShowSimpleCenterText", "Godmode OFF", 3000)
        SetEntityCanBeDamaged(PlayerPedId(), true)
        SetEntityInvincible(PlayerPedId(), false)
        SetPedConfigFlag(PlayerPedId(), 2, false)
        SetPedCanRagdoll(PlayerPedId(), true)
        SetPedCanBeTargetted(PlayerPedId(), true)
        Citizen.InvokeNative(0x5240864E847C691C, PlayerPedId(), true)
        SetPlayerInvincible(PlayerPedId(), false)
        Citizen.InvokeNative(0xFD6943B6DF77E449, PlayerPedId(), true)
        god = false
    end
end

function DisableControls()
    DisableControlAction(0, 0xB238FE0B, true) --disable controls here
    DisableControlAction(0, 0x3C0A40F2, true) --disable controls here
end

function DrawText(text, x, y, centred)
    SetTextScale(0.35, 0.35)
    SetTextColor(255, 255, 255, 255)
    SetTextCentre(centred)
    SetTextDropshadow(1, 0, 0, 0, 200)
    SetTextFontForCurrentCommand(22)
    DisplayText(CreateVarString(10, "LITERAL_STRING", text), x, y)
end

--CREDITS to the author for the noclip
Citizen.CreateThread(function()
    local player = PlayerPedId()
    local index = 1
    local CurrentSpeed = Config.Speeds[index].speed
    local FollowCamMode = true

    while true do
        while NoClipActive do

            if IsPedInAnyVehicle(PlayerPedId(), false) then
                player = GetVehiclePedIsIn(PlayerPedId(), false)
            else
                player = PlayerPedId()
            end

            local yoff = 0.0
            local zoff = 0.0

            DisableControls()


            if IsDisabledControlJustPressed(1, Config.Controls.changeSpeed) then
                timer = 2000
                if index ~= #Config.Speeds then
                    index = index + 1
                    CurrentSpeed = Config.Speeds[index].speed
                else
                    CurrentSpeed = Config.Speeds[1].speed
                    index = 1
                end

            end
            if Config.ShowControls then
                DrawText(string.format('~e~NoClip Speed: %.1f', CurrentSpeed), 0.5, 0.90, true)
            end
            if IsDisabledControlPressed(0, Config.Controls.goForward) then
                if Config.FrozenPosition then
                    yoff = -Config.Offsets.y
                else
                    yoff = Config.Offsets.y
                end
            end

            if IsDisabledControlPressed(0, Config.Controls.goBackward) then
                if Config.FrozenPosition then
                    yoff = Config.Offsets.y
                else
                    yoff = -Config.Offsets.y
                end
            end

            if IsDisabledControlPressed(0, Config.Controls.goUp) then
                zoff = Config.Offsets.z
            end

            if IsDisabledControlPressed(0, Config.Controls.goDown) then
                zoff = -Config.Offsets.z
            end

            local newPos = GetOffsetFromEntityInWorldCoords(player, 0.0, yoff * (CurrentSpeed + 0.3),
                zoff * (CurrentSpeed + 0.3))
            local heading = GetEntityHeading(player)
            SetEntityVelocity(player, 0.0, 0.0, 0.0)
            if Config.FrozenPosition then
                SetEntityRotation(player, 0.0, 0.0, 180.0, 0, false)
            else
                SetEntityRotation(player, 0.0, 0.0, 0.0, 0, false)
            end
            if (FollowCamMode) then
                SetEntityHeading(player, GetGameplayCamRelativeHeading())
            else
                SetEntityHeading(player, heading);
            end
            if Config.FrozenPosition then
                SetEntityCoordsNoOffset(player, newPos.x, newPos.y, newPos.z, not NoClipActive, not NoClipActive,
                    not NoClipActive)
            else
                SetEntityCoordsNoOffset(player, newPos.x, newPos.y, newPos.z, NoClipActive, NoClipActive, NoClipActive)
            end

            SetEntityCollision(player, false, false)
            FreezeEntityPosition(player, true)
            --SetEntityInvincible(player, true)
            --SetEntityVisible(player, false, false)
            --SetEveryoneIgnorePlayer(PlayerPedId(), true)
            --SetPedCanBeTargetted(player, false)
            Citizen.Wait(0)

            SetEntityCollision(player, true, true)
            FreezeEntityPosition(player, false)
            --SetEntityInvincible(player, false)
            --SetEntityVisible(player, true, false)
            --SetEveryoneIgnorePlayer(PlayerPedId(), false)
            --SetPedCanBeTargetted(player, true)
            if Config.ShowControls then
                DrawText('~e~W/A/S/D/Q/Z - Move, Mouse1 - Change speed', 0.5, 0.95, true)
            end
        end
        Citizen.Wait(0)
    end
end)

--[[Citizen.CreateThread(function()
    local player = PlayerPedId()

    while true do
        Citizen.Wait(0)
        if Invisible then

            SetEntityInvincible(PlayerPedId(), true)
            SetEntityVisible(PlayerPedId(), false, false)
            SetEveryoneIgnorePlayer(PlayerPedId(), true)
            SetPedCanBeTargetted(PlayerPedId(), false)
             Citizen.Wait(0)

        else

            SetEntityInvincible(PlayerPedId(), false)
            SetEntityVisible(PlayerPedId(), true, false)
            SetEveryoneIgnorePlayer(PlayerPedId(), false)
            SetPedCanBeTargetted(PlayerPedId(), true)
        end
        Citizen.Wait(0)
    end
end)]]

function Invisible()
	local player = PlayerPedId()
        if not invisible then
            TriggerEvent("vorp:ShowSimpleCenterText", "Invisible", 3000)
            SetEntityInvincible(PlayerPedId(), true)
            SetEntityVisible(PlayerPedId(), false, false)
            SetEveryoneIgnorePlayer(PlayerPedId(), true)
            SetPedCanBeTargetted(PlayerPedId(), false)
             Citizen.Wait(0)
             invisible = true

        else
            TriggerEvent("vorp:ShowSimpleCenterText", "Visible", 3000)
            SetEntityInvincible(PlayerPedId(), false)
            SetEntityVisible(PlayerPedId(), true, false)
            SetEveryoneIgnorePlayer(PlayerPedId(), false)
            SetPedCanBeTargetted(PlayerPedId(), true)
            invisible = false
        end
        Citizen.Wait(0)
end

RegisterNetEvent('556_admin:nc')
AddEventHandler('556_admin:nc', function(_source)
	if not NoClipActive then

        NoClipActive = true
        TriggerEvent("vorp:ShowSimpleCenterText", "Noclip ON", 3000)
        if Config.FrozenPosition then
            SetEntityHeading(player, GetEntityHeading(player) + 180)
        end
    else
        NoClipActive = false
        timer = 5000
        TriggerEvent("vorp:ShowSimpleCenterText", "Noclip OFF", 3000)
    end
end)

RegisterNetEvent('556_admin:id')
AddEventHandler('556_admin:id', function(_source)
	TriggerServerEvent('556_admin:idadmincheck')
end)

RegisterNetEvent('556_admin:id2')
AddEventHandler('556_admin:id2', function(_source)
	if not ids then
        ids = true
        TriggerEvent("vorp:ShowSimpleCenterText", "ID ON, press LALT to use", 3000)
    else
        ids = false
        TriggerEvent("vorp:ShowSimpleCenterText", "ID OFF", 3000)
    end
end)

--[[RegisterNetEvent('556_admin:invisible')
AddEventHandler('556_admin:invisible', function(_source)
	if not Invisible then
        Invisible = true
        TriggerEvent("vorp:ShowSimpleCenterText", "Invisible", 3000)
    else
        Invisible = false
        TriggerEvent("vorp:ShowSimpleCenterText", "Visible", 3000)
    end
end)]]

RegisterNetEvent('556_admin:pnames')
AddEventHandler('556_admin:pnames', function(_source)
	ShowPlayerNames = not ShowPlayerNames
    TriggerEvent("vorp:ShowSimpleCenterText", "Playernames toggled", 3000)
end)

local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end
		enum.destructor = nil
		enum.handle = nil
	end
}

function EnumerateEntities(firstFunc, nextFunc, endFunc)
	return coroutine.wrap(function()
		local iter, id = firstFunc()

		if not id or id == 0 then
			endFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = endFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
			coroutine.yield(id)
			next, id = nextFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		endFunc(iter)
	end)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function DrawText3D(x, y, z, text)
	local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(x, y, z)

	SetTextScale(0.35, 0.35)
	SetTextFontForCurrentCommand(1)
	SetTextColor(255, 255, 255, 223)
	SetTextCentre(1)
	DisplayText(CreateVarString(10, "LITERAL_STRING", text), screenX, screenY)
end

function DrawText3D2(x, y, z, text)
	local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(x, y, z)
	local dist = #(GetFinalRenderedCamCoord()- vector3(x, y, z))

	local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

	if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
		SetTextFontForCurrentCommand(1)
		SetTextColor(255, 255, 255, 223)
		SetTextCentre(1)
		DisplayText(CreateVarString(10, "LITERAL_STRING", text), screenX, screenY)

    end

end

function GetPedCrouchMovement(ped)
	return Citizen.InvokeNative(0xD5FE956C70FF370B, ped)
end

function OnRevealHud()
	HudIsRevealed = true
	SetTimeout(3000, function()
		HudIsRevealed = false
	end)
end

function VoiceChatIsPlayerSpeaking(player)
	return Citizen.InvokeNative(0xEF6F2A35FAAF2ED7, player)
end

function DrawTags()
	if ShowPlayerNames or HudIsRevealed then
		for _, playerId in ipairs(ActivePlayers) do
			local ped = GetPlayerPed(playerId)
			local pedCoords = GetEntityCoords(ped)

			if #(MyCoords - pedCoords) <= TagDrawDistance and not GetPedCrouchMovement(ped) then
				local text = GetPlayerName(playerId)

				if VoiceChatIsPlayerSpeaking(playerId) then
					text = "~d~Talking: ~s~" .. text
				end

				DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z + 1, text)
			end
		end
	end

	if ShowPedIds then
		for ped in EnumeratePeds() do
			if not IsPedAPlayer(ped) then
				local pedCoords = GetEntityCoords(ped)

				if #(MyCoords - pedCoords) <= TagDrawDistance then
					DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z + 1, string.format('ped %x', ped))
				end
			end
		end
	end

	if ShowVehIds then
		for vehicle in EnumerateVehicles() do
			local vehCoords = GetEntityCoords(vehicle)

			if #(MyCoords - vehCoords) <= TagDrawDistance then
				DrawText3D(vehCoords.x, vehCoords.y, vehCoords.z + 1, string.format('veh %x', vehicle))
			end
		end
	end

	if ShowObjIds then
		for object in EnumerateObjects() do
			local objCoords = GetEntityCoords(object)

			if #(MyCoords - objCoords) <= TagDrawDistance then
				DrawText3D(objCoords.x, objCoords.y, objCoords.z + 1, string.format('obj %x', object))
			end
		end
	end
end

Citizen.CreateThread(function()
	while true do
		if IsControlJustPressed(0, `INPUT_REVEAL_HUD`) then
			OnRevealHud()
		end

		DrawTags()

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		ActivePlayers = GetActivePlayers()
		MyCoords = GetEntityCoords(PlayerPedId())
		Citizen.Wait(500)
	end
end)
