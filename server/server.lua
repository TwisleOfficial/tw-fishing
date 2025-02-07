local function GetPlayerCid(src)
  local cid = ''

  if Config.Framework == 'qbx' then
    local player = exports.qbx_core:GetPlayer(src)
    cid = player.PlayerData.citizenid
  elseif Config.Framework == 'qb' then
    local qb = exports['qb-core']:GetCoreObject()
    local player = qb.Functions.GetPlayer(src)
    cid = player.PlayerData.citizenid
  end

  return cid
end

local function GetPlayerByCid(cid)
  if Config.Framework == 'qbx' then
    return exports.qbx_core:GetPlayerByCitizenId(cid)
  elseif Config.Framework == 'qb' then
    local qb = exports['qb-core']:GetCoreObject()
    return qb.Functions.GetPlayerByCitizenId(cid)
  end
end

lib.callback.register('tw-fishing:server:getTopFisher', function(source)
  local fishers = MySQL.query.await('SELECT * FROM `tw_fishing` ORDER BY `rep` DESC LIMIT 5', {})
  return fishers
end)

lib.callback.register('tw-fishing:server:getPlayerFishingData', function (source)
  local src = source

  local fishingData = MySQL.single.await('SELECT * FROM `tw_fishing` WHERE `citizen_id` = ?', 
    {GetPlayerCid(src)}
  )

  if fishingData then
    return fishingData
  else
    MySQL.insert.await('INSERT INTO tw_fishing (citizen_id) VALUES (?)', { GetPlayerCid(src) })

    local fishingData2 = MySQL.single.await('SELECT * FROM `tw_fishing` WHERE `citizen_id` = ?',
      { GetPlayerCid(src) }
    )
    return fishingData2
  end

end)

lib.callback.register('tw-fishing:server:getPlayerName', function(source, cid)
  local player = GetPlayerByCid(cid)

  if player then
    return player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname
  else
    local playerData = MySQL.single.await('SELECT charinfo FROM `players` WHERE citizenid = ?', { cid })
    if playerData and playerData.charinfo then
      local charinfo = json.decode(playerData.charinfo)
      return charinfo.firstname .. ' ' .. charinfo.lastname
    else
      return 'Unkown'
    end
  end
end)

RegisterNetEvent('tw-fishing:server:givePlayerRod', function(level)
  local src = source
  exports.ox_inventory:AddItem(src, 'fishing_rod'..level, 1)
end)

Citizen.CreateThread(function()
  for i = 1, 3 do
    exports.qbx_core:CreateUseableItem('fishing_rod'.. i, function (source, item)
      TriggerClientEvent('tw-fishing:client:useRod', source, i)
    end)
  end
end)
