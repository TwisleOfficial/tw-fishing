-- PT 1 & 2

local managerPed
local rodObj

local function createManagerPed()
  local pedData = Config.PedData

  RequestModel(pedData.model)
  while not HasModelLoaded(pedData.model) do
    Wait(1)
    RequestModel(pedData.model)
    dbug('Requesting Model: ' .. pedData.model)
  end

  managerPed = CreatePed(1, pedData.model, pedData.coords.x, pedData.coords.y, pedData.coords.z - 1, pedData. coords.w, false, false)
  FreezeEntityPosition(managerPed, true)
  SetEntityInvincible(managerPed, true)
  SetBlockingOfNonTemporaryEvents(managerPed, true)

  local rodProp = `prop_fishing_rod_01`
  RequestModel(rodProp)
  while not HasModelLoaded(rodProp) do
    Wait(1)
    RequestModel(rodProp)
    dbug('Requesting Model: ' .. rodProp)
  end

  local animDict = 'amb@world_human_stand_fishing@idle_a'
  RequestAnimDict(animDict)
  while not HasAnimDictLoaded(animDict) do
    Wait(1)
    RequestAnimDict(animDict)
    dbug('Requesting Model: ' .. animDict)
  end

  TaskPlayAnim(managerPed, animDict, 'idle_b', 2.0, 2.0, -1, 51, 0, false, false, false)
  rodObj = CreateObject(rodProp, pedData.coords.x, pedData.coords.y, pedData.coords.z, false, false, false)
  AttachEntityToEntity(rodObj, managerPed, GetPedBoneIndex(managerPed, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 
    0.0, true, true, false, true, 1, true
  )

end

Citizen.CreateThread(function()
  createManagerPed()

  exports.ox_target:addLocalEntity(managerPed, {
    {
      distance = 1.5,
      name = 'fishing_manager',
      icon = Config.PedData.target.icon,
      label = Config.PedData.target.label,
      onSelect = function ()
        BuildManagerContext()
      end
    }
  })

  if Config.PedData.blip.enabled then
    local blipData = Config.PedData.blip
    local blip = AddBlipForCoord(Config.PedData.coords.xyz)
    SetBlipSprite(blip, blipData.sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, blipData.size)
    SetBlipColour(blip, blipData.color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(blipData.title)
    EndTextCommandSetBlipName(blip)
    dbug('blip Created!')
  end

end)

RegisterNetEvent('tw-fishing:client:useRod', function(level)
  dbug('used a level ' .. level .. ' rod!')
end)

AddEventHandler('onResourceStop', function(resource)
  if resource ~= GetCurrentResourceName() then return end

  DeleteObject(rodObj)

end)