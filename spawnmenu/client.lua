local hasSpawned = false
local skyCamera = nil
local activeLocations = {} 

RegisterNetEvent('spawnmenu:receiveLocations')
AddEventHandler('spawnmenu:receiveLocations', function(serverLocations)
    activeLocations = serverLocations
    
    SendNUIMessage({
        type = "refreshLocations",
        locations = activeLocations
    })
end)

local function StartSkyCamera()
    skyCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(skyCamera, 0.0, 0.0, 1000.0) 
    SetCamRot(skyCamera, -90.0, 0.0, 0.0, 2) 
    SetCamActive(skyCamera, true)
    RenderScriptCams(true, false, 0, true, true)

    CreateThread(function()
        local heading = 0.0
        while skyCamera ~= nil do
            Wait(0)
            heading = heading + 0.05 
            if heading > 360.0 then heading = 0.0 end
            SetCamRot(skyCamera, -90.0, 0.0, heading, 2)
        end
    end)
end

local function StopSkyCamera()
    if skyCamera then
        SetCamActive(skyCamera, false)
        DestroyCam(skyCamera, true)
        RenderScriptCams(false, true, 1000, true, true) 
        skyCamera = nil
    end
end

local function OpenSpawnMenu()
    SetNuiFocus(true, true)
    
    local lastLocString = GetResourceKvpString("spawnmenu_last_loc")
    local lastLocationData = nil
    if lastLocString then lastLocationData = json.decode(lastLocString) end

    SendNUIMessage({
        type = "openSpawnMenu",
        locations = activeLocations, 
        lastLocation = lastLocationData
    })
end

CreateThread(function()
    TriggerServerEvent('spawnmenu:requestLocations')

    while true do
        Wait(100)
        if NetworkIsPlayerActive(PlayerId()) and not hasSpawned then
            while GetIsLoadingScreenActive() do Wait(500) end
            
            hasSpawned = true
            DoScreenFadeOut(0)
            Wait(500)
            StartSkyCamera()
            DoScreenFadeIn(1000)
            OpenSpawnMenu()
            break 
        end
    end
end)

CreateThread(function()
    while true do
        Wait(10000) 
        local ped = PlayerPedId()
        if NetworkIsPlayerActive(PlayerId()) and hasSpawned and not IsEntityDead(ped) then
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            local locationData = json.encode({ x = coords.x, y = coords.y, z = coords.z, h = heading })
            SetResourceKvp("spawnmenu_last_loc", locationData)
        end
    end
end)

RegisterNUICallback('spawnPlayer', function(data, cb)
    SetNuiFocus(false, false)
    local x, y, z, h = data.x, data.y, data.z, data.h

    DoScreenFadeOut(500)
    Wait(500)
    StopSkyCamera()

    local model = GetHashKey("mp_m_freemode_01")
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end
    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)

    local playerPed = PlayerPedId()
    SetPedDefaultComponentVariation(playerPed) 
    
    SetEntityCoordsNoOffset(playerPed, x, y, z, false, false, false, true)
    SetEntityHeading(playerPed, h)

    RequestCollisionAtCoord(x, y, z)
    while not HasCollisionLoadedAroundEntity(playerPed) do Wait(0) end

    DoScreenFadeIn(1000)
    cb('ok')
end)

RegisterNUICallback('deleteLocation', function(data, cb)
    TriggerServerEvent('spawnmenu:deleteLocation', data.name)
    cb('ok')
end)

RegisterCommand('addspawn', function(source, args)
    local locationName = table.concat(args, " ")
    if locationName == "" then return print("Usage: /addspawn [Location Name]") end
    
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    
    TriggerServerEvent('spawnmenu:saveLocation', locationName, coords, heading)
    
    SetNotificationTextEntry("STRING")
    AddTextComponentString("~g~Spawn Added:~w~ " .. locationName)
    DrawNotification(false, false)
end, false)

RegisterCommand('spawn', function()
    DoScreenFadeOut(500)
    Wait(500)
    StartSkyCamera()
    DoScreenFadeIn(500)
    OpenSpawnMenu()
end, false)