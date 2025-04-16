getgenv().Settings = {
    ["Egg Settings"] = {
        OpenEggs = true,
        Egg = "Best",

        ["Notifications"] = {
            Webhook = "https://discord.com/api/webhooks/1279722812931575851/G30w5whctavJ7ABeLBE0ZCFgxegLu-PHd9HMex-748vLqJ6tLK-QdicuAiY0Xqm8wRwo",
            DiscordID = "",
            Difficulty = 20000,
        },

        ["Rifts"] = {
            FindRifts = true,
            SortByMultiplier = false,
            Targets = {},
        },
    },

    ["Enchant Settings"] = {
        EnchantPets = false,

        ["Require All Enchants"] = true,
        ["Enchants Needed"] = {
            ["Team Up"] = {Tier = 5, HigherTiers = true},
        },
    },
    ["Debug"] = {
        DisableUI = false,
    },
}
loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/aab9fba1c9d41f8edf82e1d0bd14b1ea.lua"))()
