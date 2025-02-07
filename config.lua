Config = {}

Config.Debug = true

Config.Framework = 'qbx' -- qb, qbx, esx

Config.PedData = {
  model = `cs_hunter`,
  coords = vec4(-2077.74, 2604.29, 2.03, 291.25),

  target = {
    label = 'Talk To The Fish Monger',
    icon = "fa-solid fa-comment"
  },

  blip = {
    enabled = true,
    size = 0.65,
    sprite = 762,
    color = 0,
    title = 'Fish Monger'
  }

}

Config.ColorPalette = {
  red = '#cf4030',
  green = '#479423',
  blue = '#3789bb',
  yellow = '#fdd041',
  orange = '#f7931a'
}

function dbug(...)
  if Config.Debug then print('^3[DEBUG]^7', ...) end
end
