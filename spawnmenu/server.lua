local fileName = "locations.json"

local function GetLocations()
    local fileData = LoadResourceFile(GetCurrentResourceName(), fileName)
    if fileData and fileData ~= "" then
        return json.decode(fileData) or {}
    end
    return {}
end

RegisterNetEvent('spawnmenu:requestLocations')
AddEventHandler('spawnmenu:requestLocations', function()
    local src = source
    TriggerClientEvent('spawnmenu:receiveLocations', src, GetLocations())
end)

RegisterNetEvent('spawnmenu:saveLocation')
AddEventHandler('spawnmenu:saveLocation', function(name, coords, heading)
    local locs = GetLocations()
    table.insert(locs, { name = name, x = coords.x, y = coords.y, z = coords.z, h = heading })
    
    local jsonData = json.encode(locs, {indent = true})
    SaveResourceFile(GetCurrentResourceName(), fileName, jsonData, -1)
    
    print("^2[Spawn Menu] Saved new location: ^0" .. name)
    TriggerClientEvent('spawnmenu:receiveLocations', -1, locs)
end)

RegisterNetEvent('spawnmenu:deleteLocation')
AddEventHandler('spawnmenu:deleteLocation', function(locationName)
    local locs = GetLocations()

    for i, loc in ipairs(locs) do
        if loc.name == locationName then
            if loc.locked then
                print("^1[Spawn Menu] Blocked attempt to delete locked location: ^0" .. locationName)
                return 
            end
            
            table.remove(locs, i)
            break
        end
    end
    
    local jsonData = json.encode(locs, {indent = true})
    SaveResourceFile(GetCurrentResourceName(), fileName, jsonData, -1)
    
    print("^1[Spawn Menu] Deleted location: ^0" .. locationName)
    TriggerClientEvent('spawnmenu:receiveLocations', -1, locs) 
end)