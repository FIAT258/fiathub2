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
    Theme = "Ocean",
    ToggleUIKeybind = "K",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FIAT_HUB",
        FileName = "Config"
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
-- PLAYER LIST (SAFE)
------------------------------------------------
local function getPlayerNames()
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(list, p.Name)
        end
    end
    return list
end

local PlayerDropdown = BetaTab:CreateDropdown({
    Name = "Select Player",
    Options = getPlayerNames(),
    CurrentOption = "",
    Callback = function(v)
        SelectedPlayer = v
    end
})

Players.PlayerAdded:Connect(function()
    PlayerDropdown:Refresh(getPlayerNames(), true)
end)

Players.PlayerRemoving:Connect(function()
    PlayerDropdown:Refresh(getPlayerNames(), true)
end)

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
-- ESPECTER PLAYER (FIXED)
------------------------------------------------
local SpectateEnabled = false
local SpectateConnection

local OriginalCameraType
local OriginalCameraSubject

local function getPlayerByName(name)
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name == name then
            return p
        end
    end
end

local function EnableSpectate()
    if SpectateEnabled then return end
    if not SelectedPlayer or SelectedPlayer == "" then return end

    local target = getPlayerByName(SelectedPlayer)
    if not target or not target.Character then return end

    local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    SpectateEnabled = true

    OriginalCameraType = Camera.CameraType
    OriginalCameraSubject = Camera.CameraSubject

    Camera.CameraType = Enum.CameraType.Custom
    Camera.CameraSubject = humanoid

    SpectateConnection = target.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid")
        Camera.CameraSubject = hum
    end)
end

local function DisableSpectate()
    SpectateEnabled = false

    if SpectateConnection then
        SpectateConnection:Disconnect()
        SpectateConnection = nil
    end

    Camera.CameraType = OriginalCameraType or Enum.CameraType.Custom
    Camera.CameraSubject = OriginalCameraSubject or LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
end

------------------------------------------------
-- BETA TOGGLES
------------------------------------------------
BetaTab:CreateToggle({
    Name = "Especter",
    Callback = function(v)
        if v then
            EnableSpectate()
        else
            DisableSpectate()
        end
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

-- ANTI SIT FORTE (100%)
local AntiSit = false
RunService.Heartbeat:Connect(function()
    if AntiSit and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Sit then
            hum.Sit = false
        end
    end
end)

ConfigTab:CreateToggle({
    Name = "Anti Sit",
    Callback = function(v)
        AntiSit = v
    end
})

ConfigTab:CreateToggle({
    Name = "ESP Player",
    Callback = function(v)
        ESPPlayer = v
        if not v then
            clearESP()
        else
            for _, p in pairs(Players:GetPlayers()) do
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
-- ESP AUTO UPDATE
------------------------------------------------
Players.PlayerAdded:Connect(function(p)
    if ESPPlayer then
        p.CharacterAdded:Wait()
        task.wait(1)
        addESP(p)
    end
end)

Rayfield:LoadConfiguration()
