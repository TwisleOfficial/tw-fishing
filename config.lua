-- PT 1 & 2

Config = {}

Config.Debug = true

Config.Framework = 'qbx' -- qb, qbx

Config.PedData = {
  model = `cs_hunter`,
  coords = vec4(-2077.74, 2604.29, 2.03, 291.25),

  target = {
    label = 'Speak With Fish Monger',
    icon = "fa-solid fa-comment"
  },

  blip = {
    enabled = true,
    size = 1.0,
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
