Config = {}

Config.PawnLocation = {
    coords = vector3(1139.31, -464.31, 66.85),
    length = 1.5,
    width = 1.8,
    heading = 1.81,
    debugPoly = false,
    minZ = 65.66,
    maxZ = 67.66,
    distance = 2.0
}

Config.BankMoney = false -- Set to true if you want the money to go into the players bank
Config.UseTimes = false -- Set to false if you want the pawnshop open 24/7
Config.TimeOpen = 7 -- Opening Time
Config.TimeClosed = 17 -- Closing Time
Config.SendMeltingEmail = true

Config.UseTarget = GetConvar('UseTarget', 'false') == 'true'

Config.PawnItems = {
    [1] = {
        item = 'wine',
        price = math.random(50,100)
    },
}

Config.MeltingItems = { -- meltTime is amount of time in minutes per item
   
}
