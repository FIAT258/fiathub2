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
    Theme = "Ocean",
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
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

------------------------------------------------
-- TABS
------------------------------------------------
local BetaTab   = Window:CreateTab("BETA", 6862780938)
local ConfigTab = Window:CreateTab("CONFIG", 6862780938)

------------------------------------------------
-- STATES
------------------------------------------------
local SelectedPlayer = nil
local ESPPlayer = false
local ESP_CACHE = {}

------------------------------------------------
-- PLAYER LIST (DROPDOWN)
------------------------------------------------
local function getPlayerNames()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
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
-- ESP PLAYER
------------------------------------------------
local function addESP(player)
    if ESP_CACHE[player] or not player.Character then return end

    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.new(1,1,1)
    highlight.OutlineColor = Color3.new(1,1,1)
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
    for _, objs in pairs(ESP_CACHE) do
        for _, obj in pairs(objs) do
            pcall(function() obj:Destroy() end)
        end
    end
    table.clear(ESP_CACHE)
end

------------------------------------------------
-- ESPECTER PLAYER (100% FUNCIONAL)
------------------------------------------------
local SpectateEnabled = false
local SpectateConnection
local OriginalCameraSubject
local OriginalCameraType

local function getTarget()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name == SelectedPlayer then
            return p
        end
    end
end

local function EnableSpectate()
    if SpectateEnabled or not SelectedPlayer then return end

    local target = getTarget()
    if not target or not target.Character then return end

    local hum = target.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    SpectateEnabled = true
    OriginalCameraSubject = Camera.CameraSubject
    OriginalCameraType = Camera.CameraType

    Camera.CameraType = Enum.CameraType.Custom
    Camera.CameraSubject = hum
end

local function DisableSpectate()
    if not SpectateEnabled then return end
    SpectateEnabled = false

    Camera.CameraType = OriginalCameraType or Enum.CameraType.Custom
    Camera.CameraSubject = OriginalCameraSubject or LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
end

------------------------------------------------
-- BETA TOGGLES (TODOS)
------------------------------------------------
BetaTab:CreateToggle({
    Name = "Fling",
    Callback = function(v)
        -----?
    end
})

BetaTab:CreateToggle({
    Name = "Lag Player",
    Callback = function(v)
        -----?
    end
})

BetaTab:CreateToggle({
    Name = "Especter Player",
    Callback = function(v)
        if v then
            EnableSpectate()
        else
            DisableSpectate()
        end
    end
})

BetaTab:CreateToggle({
    Name = "Fling Canoa",
    Callback = function(v)
        -----?
    end
})

BetaTab:CreateToggle({
    Name = "Fling Ball",
    Callback = function(v)
        -----?
    end
})

BetaTab:CreateToggle({
    Name = "Freeze Player",
    Callback = function(v)
        -----?
    end
})

BetaTab:CreateToggle({
    Name = "Bring Player",
    Callback = function(v)
        -----?
    end
})

------------------------------------------------
-- CONFIG
------------------------------------------------
ConfigTab:CreateToggle({
    Name = "Full Light",
    Callback = function(v)
        if v then
            Lighting.Brightness = 5
            Lighting.ClockTime = 14
        end
    end
})

ConfigTab:CreateToggle({
    Name = "Anti Sit (FORTE)",
    Callback = function(v)
        if v then
            RunService.Stepped:Connect(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.Sit = false end
            end)
        end
    end
})

ConfigTab:CreateToggle({
    Name = "ESP Player",
    Callback = function(v)
        ESPPlayer = v
        if not v then
            clearESP()
        else
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    addESP(p)
                end
            end
        end
    end
})

ConfigTab:CreateButton({
    Name = "Delete Interface",
    Callback = function()
        clearESP()
        DisableSpectate()
        Rayfield:Destroy()
    end
})

------------------------------------------------
-- AUTO ESP
------------------------------------------------
Players.PlayerAdded:Connect(function(p)
    if ESPPlayer then
        p.CharacterAdded:Wait()
        task.wait(1)
        addESP(p)
    end
end)

Rayfield:LoadConfiguration()
