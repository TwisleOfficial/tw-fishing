Config = {}

Config.Debug = true

Config.Framework = 'qbx' -- qb, qbx, esx

Config.LeaderboardShow = 5

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

Config.FishAreas = {
  freshwater = {
    'LAGO',
    'ZANCUDO',
    'ALAMO',
    'LACT',
    'CCREAK'
  },
  saltwater = {
    'OCEANA',
    'PALCOV',
    'TERMINA',
    'ELYSIAN',
    'NCHU'
  },
}

Config.FishData = {
  Freshwater = {
    { name = "r_common_carp",     rarity = 0.8 },
    { name = "r_perch",           rarity = 0.7 },
    { name = "r_catfish",         rarity = 0.7 },
    { name = "r_largemouth_bass", rarity = 0.6 },
    { name = "r_bluegill",        rarity = 0.6 },
    { name = "r_tilapia",         rarity = 0.6 },
    { name = "r_brown_trout",     rarity = 0.5 },
    { name = "r_cutthroat_trout", rarity = 0.5 },
    { name = "r_striped_bass",    rarity = 0.5 },
    { name = "r_coho_salmon",     rarity = 0.4 },
    { name = "r_black_crappie",   rarity = 0.4 },
    { name = "r_chinook_salmon",  rarity = 0.3 },
    { name = "r_white_sturgeon",  rarity = 0.3 }
  },
  Saltwater = {
    { name = "o_anchovy",         rarity = 0.8 },
    { name = "o_mackerel",        rarity = 0.6 },
    { name = "o_spot_prawn",      rarity = 0.6 },
    { name = "o_codfish",         rarity = 0.6 },
    { name = "o_pacific_sardine", rarity = 0.7 },
    { name = "o_mahi_mahi",       rarity = 0.5 },
    { name = "o_rainbow_trout",   rarity = 0.5 },
    { name = "o_giant_seabass",   rarity = 0.4 },
    { name = "o_pacific_halibut", rarity = 0.4 },
    { name = "o_red_snapper",     rarity = 0.4 },
    { name = "o_white_seabass",   rarity = 0.4 },
    { name = "o_redfish",         rarity = 0.3 },
    { name = "o_stingray",        rarity = 0.3 },
    { name = "o_grouper",         rarity = 0.3 },
    { name = "o_kingcrab",        rarity = 0.2 },
    { name = "o_lobster",         rarity = 0.2 },
    { name = "o_yellowfin_tuna",  rarity = 0.2 }
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
