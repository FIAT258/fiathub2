-- FIAT HUB – INTERFACE LIMPA (BETA) | RAYFIELD ATUAL

------------------------------------------------
-- RAYFIELD
------------------------------------------------
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "FIAT HUB (BETA)",
    Icon = 0,
    LoadingTitle = "FIAT HUB",
    LoadingSubtitle = "by fiat",
    ShowText = "FIAT",
    Theme = "Ocean", -- <<<<<< TEMA (MUDE SE QUISER)

    ToggleUIKeybind = "K",

    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,

    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FIAT_HUB",
        FileName = "Config"
    },

    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },

    KeySystem = false
})

------------------------------------------------
-- SERVICES
------------------------------------------------
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

------------------------------------------------
-- TABs
------------------------------------------------
local BetaTab   = Window:CreateTab("BETA", 6862780938)
local ConfigTab = Window:CreateTab("CONFIG", 9632115853)

------------------------------------------------
-- STATES
------------------------------------------------
local SelectedPlayer = nil
local ESPPlayer = false
local ESP_CACHE = {}

------------------------------------------------
-- PLAYER LIST (DROPDOWN DINÂMICO)
------------------------------------------------
local function getPlayerNames()
    local list = {}
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(list, p.Name)
        end
    end
    return list
end

local PlayerDropdown = BetaTab:CreateDropdown({
    Name = "Select Player",
    Options = getPlayerNames(),
    CurrentOption = nil,
    Callback = function(v)
        SelectedPlayer = v
    end
})

local function refreshDropdown()
    PlayerDropdown:Refresh(getPlayerNames(), true)
end

Players.PlayerAdded:Connect(refreshDropdown)
Players.PlayerRemoving:Connect(refreshDropdown)

------------------------------------------------
-- ESP PLAYER (BRANCO + NOME)
------------------------------------------------
local function addESP(player)
    if ESP_CACHE[player] then return end
    if not player.Character then return end

    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255,255,255)
    highlight.OutlineColor = Color3.fromRGB(255,255,255)
    highlight.Parent = player.Character

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,200,0,40)
    billboard.AlwaysOnTop = true
    billboard.Parent = player.Character

    local head = player.Character:FindFirstChild("Head")
    if head then billboard.Adornee = head end

    local text = Instance.new("TextLabel", billboard)
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.TextScaled = true
    text.TextColor3 = Color3.new(1,1,1)
    text.Text = player.Name

    ESP_CACHE[player] = {highlight, billboard}
end

local function clearESP()
    for _,v in pairs(ESP_CACHE) do
        for _,obj in pairs(v) do
            pcall(function() obj:Destroy() end)
        end
    end
    table.clear(ESP_CACHE)
end

------------------------------------------------
-- BETA TOGGLES (SEM LÓGICA)
------------------------------------------------
BetaTab:CreateToggle({
    Name="Fling",
    Callback=function(v)
        -----?
    end
})

BetaTab:CreateToggle({
    Name="Lag Player",
    Callback=function(v)
        -----?
    end
})

BetaTab:CreateToggle({
    Name="Especter",
    Callback=function(v)
        -----?
    end
})

BetaTab:CreateToggle({
    Name="Fling Canoa",
    Callback=function(v)
        -----?
    end
})

BetaTab:CreateToggle({
    Name="Fling Ball",
    Callback=function(v)
        -----?
    end
})

------------------------------------------------
-- CONFIG
------------------------------------------------
ConfigTab:CreateToggle({
    Name="Full Light",
    Callback=function(v)
        if v then
            Lighting.Brightness = 5
            Lighting.ClockTime = 14
        end
    end
})

ConfigTab:CreateToggle({
    Name="Anti Sit",
    Callback=function(v)
        if v and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.Sit = false end
        end
    end
})

ConfigTab:CreateToggle({
    Name="ESP Player",
    Callback=function(v)
        ESPPlayer = v
        if not v then
            clearESP()
        else
            for _,p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    addESP(p)
                end
            end
        end
    end
})

ConfigTab:CreateButton({
    Name="Delete Interface",
    Callback=function()
        clearESP()
        Rayfield:Destroy()
    end
})

------------------------------------------------
-- ESP AUTO UPDATE
------------------------------------------------
Players.PlayerAdded:Connect(function(p)
    if ESPPlayer then
        p.CharacterAdded:Connect(function()
            task.wait(1)
            addESP(p)
        end)
    end
end)

Rayfield:LoadConfiguration()
