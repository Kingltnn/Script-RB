--[[  
        Auto Claim Eggs, Auto Buy Pixel Eggs, Auto Sell Pets
        Created/Made By:Sub2BK & butterfinger
]]

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window =
    Rayfield:CreateWindow(
    {
        Name = "Grow a Garden | PS99",
        Icon = "scroll-text", -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
        LoadingTitle = "Loading",
        LoadingSubtitle = "ERm?",
        Theme = "Amethyst", -- Check https://docs.sirius.menu/rayfield/configuration/themes
        DisableRayfieldPrompts = false,
        DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "Growagardenps99", -- Create a custom folder for your hub/game
            FileName = "config"
        },
        Discord = {
            Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
            Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
            RememberJoins = true -- Set this to false to make them join the discord every time they load it up
        },
        KeySystem = false, -- Set this to true to use our key system
        KeySettings = {
            Title = "S",
            Subtitle = "Era Era!",
            Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
            FileName = "", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
            SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
            GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
            Key = {""} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
        }
    }
)

Rayfield:Notify({
    Title = "Script Has Been Loaded!",
    Content = "Enjoy it",
    Duration = 5,
    Image = "monitor-up"
})

local CreditTab = Window:CreateTab("Credits", "circle-user") -- Title, Image
local MainTab = Window:CreateTab("Main", "earth") -- Title, Image

----------------------------------------------------------------------
-- All Toggles Control/Loop

local selectedSellPets = {}
local autoSellEnabled = false
local selectedEggs = {}
local autoBuyEnabled = false
local autoHarvestEnabled = false

----------------------------------------------------------------------
-- All Services/Locals

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = ReplicatedStorage:WaitForChild("Network")
local InvokeRemote = Network:WaitForChild("Plots_Invoke")
local HarvestRemote = Network:WaitForChild("Farming_Harvest")
local PetsFolder = workspace:WaitForChild("__THINGS"):WaitForChild("Pets")
local FarmEggsFolder = workspace:WaitForChild("__THINGS"):WaitForChild("FarmEggs")
local PlotsFolder = workspace:WaitForChild("__THINGS"):WaitForChild("Plots")

-------------------------------------------------------
-- Plot ID Finder

local function getMyPlotID()
    for _, plot in ipairs(PlotsFolder:GetChildren()) do
        if plot:IsA("Model") and tonumber(plot.Name) then
            if plot:FindFirstChild("Interactable") and plot.Interactable:FindFirstChild("MyFarmBillboard") then
                return tonumber(plot.Name)
            end
        end
    end
end

-------------------------------------------------------
-- Lists

local pixelEggs = {
    "Pixel Angelus", "Pixel Agony", "Pixel Demon", "Pixel Yeti",
    "Pixel Griffin", "Pixel Tiger",  "Pixel Wolf", "Pixel Monkey",
    "Pixel Bee", "Pixel Goblin", "Pixel Bunny", "Pixel Corgi",
    "Pixel Piggy", "Pixel Cat", "Pixel Chick"
}

local sellPetsList = {
    "Baby Pixel Angelus", "Baby Pixel Agony",
    "Baby Pixel Demon", "Baby Pixel Yeti", "Baby Pixel Griffin",
    "Baby Pixel Tiger", "Baby Pixel Wolf", "Baby Pixel Monkey",
    "Baby Pixel Bee", "Baby Pixel Goblin", "Baby Pixel Bunny",
    "Baby Pixel Corgi", "Baby Pixel Piggy", "Baby Pixel Cat",
    "Baby Pixel Chick"
}

-------------------------------------------------------
local Label = CreditTab:CreateLabel("Made By (Sub2BK & butterfinger)", "circle-user", Color3.fromRGB(73, 17, 124), false) -- Title, Icon, Color, IgnoreTheme
local Divider = CreditTab:CreateDivider()

local Section = MainTab:CreateSection("Harvest Stuff")

-- Auto Harvest Eggs
MainTab:CreateToggle({
    Name = "Auto Harvest Eggs",
    CurrentValue = false,
    Flag = "AutoHarvestEggsToggle",
    Callback = function(value)
        autoHarvestEnabled = value
    end,
})

task.spawn(function()
    while task.wait() do
        if autoHarvestEnabled then
            for _, egg in ipairs(FarmEggsFolder:GetChildren()) do
                if egg:IsA("Model") and egg.Name == "Egg" then
                    local uid = egg:GetAttribute("UID")
                    if uid then
                        pcall(function()
                            HarvestRemote:InvokeServer(uid)
                        end)
                    end
                end
            end
        end
    end
end)

local Section = MainTab:CreateSection("Eggs Stuff")

-- Auto Buy Eggs
MainTab:CreateDropdown({
    Name = "Select Eggs to Buy",
    Options = pixelEggs,
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "SelectEggs",
    Callback = function(Options)
        selectedEggs = Options
    end,
})

MainTab:CreateToggle({
    Name = "Auto Buy Selected Eggs",
    CurrentValue = false,
    Flag = "AutoBuyEggsToggle",
    Callback = function(value)
        autoBuyEnabled = value
    end,
})

task.spawn(function()
    while task.wait() do
        if autoBuyEnabled and #selectedEggs > 0 then
            local plotID = getMyPlotID()
            if plotID then
                for _, eggName in ipairs(selectedEggs) do
                    local args = {
                        plotID,
                        "BuyEgg",
                        eggName
                    }

                    pcall(function()
                        InvokeRemote:InvokeServer(unpack(args))
                    end)

                    task.wait()
                end
            end
        end
    end
end)

local Section = MainTab:CreateSection("Sell Stuff")

-- Auto Sell Pets
MainTab:CreateDropdown({
    Name = "Select Pets to Auto Sell",
    Options = sellPetsList,
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "SelectPets",
    Callback = function(Options)
        selectedSellPets = Options
    end,
})

MainTab:CreateToggle({
    Name = "Auto Sell Selected Pets",
    CurrentValue = false,
    Flag = "AutoSellPetsToggle",
    Callback = function(value)
        autoSellEnabled = value
    end,
})

task.spawn(function()
    while task.wait() do
        if autoSellEnabled and #selectedSellPets > 0 then
            local myPlotID = getMyPlotID()
            if myPlotID then
                for _, pet in ipairs(PetsFolder:GetChildren()) do
                    if pet:IsA("Model") and pet:FindFirstChild(pet.Name) then
                        local gui = pet[pet.Name]:FindFirstChild("PetGui")
                        if gui and gui:FindFirstChild("Title") and gui.Title:IsA("TextLabel") then
                            if table.find(selectedSellPets, gui.Title.Text) then
                                local args = {
                                    myPlotID,
                                    "SellPets",
                                    { pet.Name }
                                }
                                pcall(function()
                                    InvokeRemote:InvokeServer(unpack(args))
                                end)
                            end
                        end
                    end
                end
            end
        end
    end
end)
