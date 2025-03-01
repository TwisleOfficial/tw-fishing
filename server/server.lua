local function GetPlayerCid(src)
  local cid = nil

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

local function GetPlayerByTheCid(cid)
  if Config.Framework == 'qbx' then
    return exports.qbx_core:GetPlayerByCitizenId(cid)
  elseif Config.Framework == 'qb' then
    local qb = exports['qb-core']:GetCoreObject()
    return qb.Functions.GetPlayerByCitizenId(cid)
  end
end

local function DoNotify(src, duration, title, desc, type)
  if Config.Notification == 'ox' then
    TriggerClientEvent('ox_lib:notify', src, {
      title = title,
      description = desc,
      type = type,
      duration = duration,
      showDuration = true,
    })
  elseif Config.Notification == 'qb' then
    TriggerClientEvent('QBCore:Notify', src, title .. ' ' .. desc, type, duration)
  end
end

local function DoNotify(src, duration, title, desc, type)
  if Config.Notification == 'ox' then
    TriggerClientEvent('ox_lib:notify', src, {
      title = title,
      description = desc,
      type = type,
      duration = duration,
      showDuration = true,
    })
  elseif Config.Notification == 'qb' then
    TriggerClientEvent('QBCore:Notify', src, title .. ' ' .. desc, type, duration)
  end
end

lib.callback.register('tw-fishing:server:giveFish', function(source, waterType)
  local src = source
  local fishToGive = nil

  -- Debug: Check the waterType received
  print("Water Type Received: " .. waterType)

  -- Get the appropriate fish data based on the water type (Freshwater or Saltwater)
  if waterType == "freshwater" then
    fishToGive = Config.FishData.Freshwater
    print("Freshwater selected.")
  elseif waterType == "saltwater" then
    fishToGive = Config.FishData.Saltwater
    print("Saltwater selected.")
  else
    print("Invalid water type!")
    return
  end

  -- Debug: Check if fishToGive is populated
  if fishToGive == nil then
    print("No fish data found for the given water type.")
    return
  end

  -- Select a fish based on its rarity
  local totalRarity = 0
  for _, fish in ipairs(fishToGive) do
    totalRarity = totalRarity + fish.rarity
    print("Fish: " .. fish.name .. ", Rarity: " .. fish.rarity)
  end

  -- Debug: Check total rarity
  print("Total Rarity: " .. totalRarity)

  -- Pick a random number and use it to select a fish
  local randomPick = math.random() * totalRarity
  print("Random Pick Value: " .. randomPick)
  local cumulativeRarity = 0

  for _, fish in ipairs(fishToGive) do
    cumulativeRarity = cumulativeRarity + fish.rarity
    print("Cumulative Rarity: " .. cumulativeRarity)
    if randomPick <= cumulativeRarity then
      fishToGive = fish.name
      print("Fish selected: " .. fishToGive)
      break
    end
  end

  -- Check if the player can carry the item
  if not exports.ox_inventory:CanCarryAmount(src, fishToGive, 1) then
    print("Player can't carry more fish.")
    DoNotify(src, "You can't carry more fish.")
    return
  end

  -- Add the fish to the player's inventory
  exports.ox_inventory:AddItem(src, fishToGive, 1)
  print("Fish added to inventory: " .. fishToGive)

  -- Notify the player about the fish they caught
  DoNotify(src, "You caught a " .. fishToGive .. "!")
end)

lib.callback.register('tw-fishing:server:getTopFishers', function(source)

  print('test')

  local fishing = MySQL.query.await('SELECT * FROM `tw_fishing` ORDER BY `rep` DESC LIMIT 5', {})

  dbug(#fishing)

  return fishing
end)

lib.callback.register('tw-fishing:server:getPlayerFishingData', function(source)
  local src = source

  local fishingData = MySQL.single.await('SELECT * FROM `tw_fishing` WHERE `citizen_id` = ?', { GetPlayerCid(src) })

  if fishingData then
    return fishingData
  else
    MySQL.insert.await(
      'INSERT INTO tw_fishing (citizen_id) VALUES (?, ?, ?, ?)',
      { cid }, function(rowsChanged)
      if rowsChanged > 0 then
        print(("Fishing data entry created for %s"):format(cid))
      else
        print(("Failed to create entry for %s, possible duplicate"):format(cid))
      end
    end)
    local fishingData = MySQL.single.await('SELECT * FROM `tw_fishing` WHERE `citizen_id` = ?', { GetPlayerCid(src) })
    return fishingData
  end

end)

lib.callback.register('tw-fishing:server:getPlayerName', function(source, id)
  print("Looking up player name for:", id)

  local player = GetPlayerByTheCid(id)
  if player then
    print("Found Online Player:", player.PlayerData.charinfo.firstname, player.PlayerData.charinfo.lastname)
    return player.PlayerData.charinfo.firstname .. ' ' .. player.PlayerData.charinfo.lastname
  else
    local playerData = MySQL.single.await('SELECT charinfo FROM `players` WHERE citizenid = ?', { id })
    if playerData and playerData.charinfo then
      local charinfo = json.decode(playerData.charinfo)
      print("Found Offline Player:", charinfo.firstname, charinfo.lastname)
      return charinfo.firstname .. ' ' .. charinfo.lastname
    else
      print("Player Not Found, Returning Unknown")
      return "Unknown"
    end
  end
end)

RegisterNetEvent('tw-fishing:server:givePlayerRod', function(level)
  local src = source

  exports.ox_inventory:AddItem(src, 'fishing_rod' .. level, 1)

end)

Citizen.CreateThread(function()
  for i = 1, 3 do
    exports.qbx_core:CreateUseableItem('fishing_rod' .. i, function(source, item)
      TriggerClientEvent('tw-fishing:client:useRod', source, i)
    end)
  end
end)