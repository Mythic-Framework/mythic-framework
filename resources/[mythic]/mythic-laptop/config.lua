Config = Config or {}

Config.MarketOpeningDelayMinutes = math.random(30, 90) -- (Defined in minutes) random value from 30-90 minutes. If you'd like one set amount of time every restart just do = 30.
Config.DeleteVehicleDelay = 0.5 -- (Defined in minutes) Vehicle gets deleted after 30 seconds of being delivered.
Config.MarketItems = {
    { item = "racing_crappy", coin = "VRM", price = 3, vpn = false, qty = 1000 },
    { item = "racedongle", coin = "VRM", rep = "Racing", repLvl = 2, price = 20, vpn = false, qty = 1000 },
    { item = "harness", coin = "VRM", rep = "Racing", repLvl = 1, price = 20, vpn = false, qty = 1000 },
    { item = "purgecontroller", coin = "VRM", rep = "Racing", repLvl = 3, price = 50, vpn = true, qty = 1000 },
    { item = "boosting_tracking_disabler", coin = "VRM", price = 50, vpn = true, qty = 1000 },
    { item = "fakeplates", coin = "VRM", rep = "Racing", repLvl = 1, price = 20, vpn = true, qty = 1000 },
    --{ item = "fakeplates", coin = "MALD", price = 50, vpn = true, qty = 1000 },
    { item = "nitrous", coin = "VRM", price = 10, vpn = true, qty = 1000 },
    --{ item = "nitrous", coin = "MALD", price = 40, vpn = true, qty = 1000 },
}
