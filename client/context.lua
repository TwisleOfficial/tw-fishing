local function buildShopContext(rep)

  local function CanBuyRod(minRep)
    if rep > minRep then return false else return true end
  end

  lib.registerContext({
    id = 'fish_master_shop',
    title = 'Fish Monger Shop',
    menu = 'fish_master_main',
    options = {
      {
        title = 'Buy Level One Rod',
        description = 'Anyone can buy this fishing rod.',
        icon = "fa-solid fa-1",
        onSelect = function()
          TriggerServerEvent('tw-fishing:server:givePlayerRod', 1)
        end
      },
      {
        title = 'Buy Level Two Rod',
        description = 'You need at least 30 rep to buy this rod.',
        icon = "fa-solid fa-2",
        disabled = CanBuyRod(30),
        onSelect = function()
          TriggerServerEvent('tw-fishing:server:givePlayerRod', 2)
        end
      },
      {
        title = 'Buy Level Three Rod',
        description = 'You need at least 75 rep to buy this rod.',
        icon = "fa-solid fa-3",
        disabled = CanBuyRod(75),
        onSelect = function()
          TriggerServerEvent('tw-fishing:server:givePlayerRod', 3)
        end
      },
    },
  })

  lib.showContext('fish_master_shop')
end

local function buildLeaderboardContext()
  local topOptions = {}
  local topFive = lib.callback.await('tw-fishing:server:getTopFisher', false)

  if #topFive > 0 then
    for i, fisher in ipairs(topFive) do
      local plrName = lib.callback.await('tw-fishing:server:getPlayerName', false, fisher.citizen_id)

      table.insert(topOptions, {
        title = '#' .. i .. ' ' .. plrName,
        description = 'Their score is ' .. fisher.score .. '. They have caught ' .. fisher.fish_caught .. ' fish!',
        icon = 'fa-solid fa-star',
        iconColor = Config.ColorPalette.yellow
      })
    end
  else
    table.insert(topOptions, {
      title = 'No Leaderboard To Display!',
      description = 'There might be a error in my score keeping...',
      icon = "fa-solid fa-exclamation",
      iconColor = Config.ColorPalette.red,
    })
  end

  lib.registerContext({
    id = 'fish_master_leaderboard',
    title = 'Fishing Leaderboard',
    options = topOptions
  })
  lib.showContext('fish_master_leaderboard')
end

function BuildManagerContext()
  local fishingData = lib.callback.await('tw-fishing:server:getPlayerFishingData', false)

  local function GetRep()
    return fishingData.rep
  end
  local function GetScore()
    return fishingData.score
  end

  lib.registerContext({
    id = 'fish_master_main',
    title = 'Fish Monger',
    options = {
      {
        title = 'Your Repuatation',
        description = '',
        icon = "fa-solid fa-user",
        iconColor = Config.ColorPalette.orange,
        progress = GetRep(),
        colorScheme = 'orange',
        metadata = {
          { label = 'Your Rep', value = GetRep() },
        },
      },
      {
        title = 'Your Score',
        description = '',
        icon = "fa-solid fa-star",
        iconColor = Config.ColorPalette.yellow,
        progress = GetScore(),
        colorScheme = 'yellow',
        metadata = {
          { label = 'Your Score', value = GetScore() },
        },
      },
      {
        title = 'Fishing Shop',
        description = 'Click to open the fishing shop.',
        icon = "fa-solid fa-cart-shopping",
        iconColor = Config.ColorPalette.green,
        onSelect = function()
          buildShopContext(GetRep())
        end
      },
      {
        title = 'Fishing Leaderboard',
        description = 'Click to open the fishing leaderboard.',
        icon = "fa-solid fa-chart-simple",
        iconColor = Config.ColorPalette.blue,
        onSelect = function()
          buildLeaderboardContext()
        end
      },
    },
  })

  lib.showContext('fish_master_main')

end