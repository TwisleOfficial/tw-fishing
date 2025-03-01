local managerPed
local managerRod

local playerRod

local fishing = false
local catching = false

local ped = nil

local function createManagerPed()
  local pedData = Config.PedData

  RequestModel(pedData.model)
  while not HasModelLoaded(pedData.model) do
    Wait(1)
    RequestModel()
    dbug('Reuqesting : ' .. pedData.model)
  end

  managerPed = CreatePed(1, pedData.model, pedData.coords.x, pedData.coords.y, pedData.coords.z - 1, pedData.coords.w,
    false, false
  )
  FreezeEntityPosition(managerPed, true)
  SetEntityInvincible(managerPed, true)
  SetBlockingOfNonTemporaryEvents(managerPed, true)


  local rodProp = `prop_fishing_rod_01`

  RequestModel(rodProp)
  while not HasModelLoaded(rodProp) do
    Wait(1)
    RequestModel(rodProp)
    dbug("Requesting model: " .. rodProp)
  end

  local animDict = 'amb@world_human_stand_fishing@idle_a'
  RequestAnimDict(animDict)
  while not HasAnimDictLoaded(animDict) do
    Wait(1)
    RequestAnimDict(animDict)
    dbug('Reuqesting : ' .. animDict)
  end

  managerRod = CreateObject(rodProp, pedData.coords.x, pedData.coords.y, pedData.coords.z, false, false, false)
  TaskPlayAnim(managerPed, animDict, "idle_b", 2.0, 2.0, -1, 51, 0, false, false, false)
  AttachEntityToEntity(managerRod, managerPed, GetPedBoneIndex(managerPed, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
    true, true, false, true, 1, true
  )

end

local function GetFishZone(ped)
  local coords = GetEntityCoords(ped)
  local forwardVec = GetEntityForwardVector(ped)

  local pointX = coords.x + (forwardVec.x * 10)
  local pointY = coords.y + (forwardVec.y * 10)
  local pointZ = coords.z + (forwardVec.z * 10)

    -- Start the shape test
  local inWater, castPoint = TestProbeAgainstWater(
    coords.x,
    coords.y,
    coords.z,
    pointX,
    pointY,
    pointZ - 1
  )

  local waterType = "unknown" -- Default value
  if inWater then
    zone = GetNameOfZone(castPoint.x, castPoint.y, castPoint.z)

    for _, freshwaterZone in ipairs(Config.FishAreas.freshwater) do
        if zone == freshwaterZone then
            waterType = "freshwater"
            break
        end
    end

    if waterType == "unknown" then
        for _, saltwaterZone in ipairs(Config.FishAreas.saltwater) do
            if zone == saltwaterZone then
                waterType = "saltwater"
                break
            end
        end
    end

    -- Debug print or use this waterType value for further logic
    print("Fishing in:", waterType)
  end

  return inWater, waterType
end

local function CatchFish(waterType)
  catching = true
  print(waterType)


  exports['boii_minigames']:skill_bar({
    style = 'default',
    icon = 'fas fa-fish',
    orientation = 2,
    area_size = 20,
    perfect_area_size = 5,
    speed = 0.5,
    moving_icon = true,
    icon_speed = 3,
  }, function(success) -- Game callback
    if success == 'perfect' then
      lib.callback.await('tw-fishing:server:giveFish', false, waterType)
    elseif success == 'success' then
      lib.callback.await('tw-fishing:server:giveFish', false, waterType)
    elseif success == 'failed' then
      -- If failed do something
      print('skill_bar fail')
    end
  end)

  catching = false
end

local function StartFishing(level, waterType)
  local ped = PlayerPedId()
  fishing = true
  catching = false

  -- Freeze player position
  FreezeEntityPosition(ped, true)

  -- Disable player controls (so they can't move or do actions)
  Citizen.CreateThread(function()
    while fishing do
      DisableControlAction(0, 24, true)       -- Disable attack
      DisableControlAction(0, 25, true)       -- Disable aim
      DisableControlAction(0, 21, true)       -- Disable sprint
      DisableControlAction(0, 22, true)       -- Disable jump
      DisableControlAction(0, 30, true)       -- Disable move left/right
      DisableControlAction(0, 31, true)       -- Disable move forward/back
      DisableControlAction(0, 75, true)       -- Disable exit vehicle
      Wait(0)
    end
  end)

  -- Spawn fishing rod
  playerRod = CreateObject(`prop_fishing_rod_01`, 0, 0, 0, false, false, false)
  AttachEntityToEntity(playerRod, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
    true, true, false, true, 1, true
  )

  -- Start the fishing animation and keep it running
  Citizen.CreateThread(function()
    while fishing do
      if not IsEntityPlayingAnim(ped, "amb@world_human_stand_fishing@idle_a", "idle_b", 3) then
        RequestAnimDict("amb@world_human_stand_fishing@idle_a")
        while not HasAnimDictLoaded("amb@world_human_stand_fishing@idle_a") do
          Wait(100)
        end
        TaskPlayAnim(ped, "amb@world_human_stand_fishing@idle_a", "idle_b", 2.0, 2.0, -1, 51, 0, false, false, false)
      end
      Wait(5000)       -- Check every 5 seconds to prevent animation stops
    end
  end)

  -- Define wait times based on level (higher level = shorter wait)
  local waitTime = 0

  if level == 1 then
    waitTime = math.random(22000, 27000)     -- 22-27 sec
  elseif level == 2 then
    waitTime = math.random(17000, 21000)     -- 17-21 sec
  elseif level == 3 then
    waitTime = math.random(10000, 15000)     -- 10-15 sec
  else
    print("Invalid fishing level!")
    return
  end

  -- Fishing loop
  Citizen.CreateThread(function()
    while fishing do
      Wait(waitTime)

      if not catching and fishing then
        CatchFish(waterType)
      end
    end
  end)
end

local function StopFishing()
  DeleteEntity(playerRod)
  FreezeEntityPosition(ped, false)
end

Citizen.CreateThread(function()
  createManagerPed()

  exports.ox_target:addLocalEntity(managerPed, {
    {
      distance = 1.5,
      name = "fishing_manager",
      icon = Config.PedData.target.icon,
      label = Config.PedData.target.label,
      onSelect = function()
        buildMangerContext()
      end,
    }
  })

  if Config.PedData.blip.enabled then
    local blip = AddBlipForCoord(Config.PedData.coords.xyz)
    SetBlipSprite(blip, Config.PedData.blip.sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, Config.PedData.blip.size)
    SetBlipColour(blip, Config.PedData.blip.color)
    SetBlipAsShortRange(blip, true)
    SetBlipAlpha(blip, 255)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.PedData.blip.title)
    EndTextCommandSetBlipName(blip)
    dbug('Blip Created!')
  end
end)




RegisterNetEvent('tw-fishing:client:useRod', function (level)
  fishing = not fishing

  ped = PlayerPedId()
  ClearPedTasksImmediately(ped)

  if not fishing then
    StopFishing()
    return
  end

  local inWater, zone = GetFishZone(ped)

  if not inWater or zone == "unknown" then
    lib.notify({
      title = 'Fishing',
      description = 'You cant fish here!',
      type = 'error',
      duration = 2500,
      showDuration = true,
    })
    return
  end

  if lib.progressCircle({
    duration = 1700,
    position = 'bottom',
    label = 'Casting Rod',
    useWhileDead = false,
    canCancel = true,
    disable = {
      combat = true,
      move = true,
    },
    anim = {
      dict = 'anim@heists@narcotics@trash',
      clip = 'throw_b',
    }
  }) then
    ClearPedTasksImmediately(ped)
    StartFishing(level, zone)
  else
    print('Do stuff when cancelled')
  end
end)

RegisterCommand('ocean', function()
  dbug(GetNameOfZone(GetEntityCoords(PlayerPedId()).xyz))
end, false)

AddEventHandler('onResourceStop', function(resource)
   if resource ~= GetCurrentResourceName() then
      return
   end

  DeleteObject(rod)
  DeleteObject(managerPed)

  DeleteObject(playerRod)

end)