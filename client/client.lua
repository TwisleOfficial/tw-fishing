local managerPed
local rod

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

  rod = CreateObject(rodProp, pedData.coords.x, pedData.coords.y, pedData.coords.z, false, false, false)
  TaskPlayAnim(managerPed, animDict, "idle_b", 2.0, 2.0, -1, 51, 0, false, false, false)
  AttachEntityToEntity(rod, managerPed, GetPedBoneIndex(managerPed, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
    true, true, false, true, 1, true
  )

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
  dbug('used level ' .. level .. ' fishing rod')
end)

AddEventHandler('onResourceStop', function(resource)
   if resource ~= GetCurrentResourceName() then
      return
   end

  DeleteObject(rod)
  DeleteObject(managerPed)

end)