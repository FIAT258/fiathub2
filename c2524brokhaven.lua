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
-- PLAYER LIST (DROPDOWN CORRIGIDO)
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
    CurrentOption = {},
    Callback = function(v)
        if typeof(v) == "table" then
            SelectedPlayer = v[1]
        else
            SelectedPlayer = v
        end
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
    if ESP_CACHE[player] or not player.Character then return end

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
        for _,o in pairs(v) do
            pcall(function() o:Destroy() end)
        end
    end
    table.clear(ESP_CACHE)
end

------------------------------------------------
-- ESPECTER PLAYER (FUNCIONANDO)
------------------------------------------------
local SpectateEnabled = false
local SpectateConnection
local OriginalCameraType
local OriginalCameraSubject
local OriginalCFrame

local function getPlayerByName(name)
    for _,p in pairs(Players:GetPlayers()) do
        if p.Name == name then return p end
    end
end

local function EnableSpectate()
    if SpectateEnabled or not SelectedPlayer then return end
    local targetPlayer = getPlayerByName(SelectedPlayer)
    if not targetPlayer then return end

    SpectateEnabled = true
    OriginalCameraType = Camera.CameraType
    OriginalCameraSubject = Camera.CameraSubject
    OriginalCFrame = Camera.CFrame

    Camera.CameraType = Enum.CameraType.Scriptable

    SpectateConnection = RunService.RenderStepped:Connect(function()
        if not SpectateEnabled then return end
        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,3,8)
        end
    end)
end

local function DisableSpectate()
    SpectateEnabled = false
    if SpectateConnection then SpectateConnection:Disconnect() end

    Camera.CameraType = OriginalCameraType or Enum.CameraType.Custom
    Camera.CameraSubject = OriginalCameraSubject or LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if OriginalCFrame then Camera.CFrame = OriginalCFrame end
end

------------------------------------------------
-- BETA TOGGLES
------------------------------------------------
BetaTab:CreateToggle({Name="Fling",Callback=function(v) -----? end})
BetaTab:CreateToggle({Name="Lag Player",Callback=function(v) -----? end})

BetaTab:CreateToggle({
    Name="Especter",
    Callback=function(v)
        if v then EnableSpectate() else DisableSpectate() end
    end
})

BetaTab:CreateToggle({Name="Fling Canoa",Callback=function(v) -----? end})
BetaTab:CreateToggle({Name="Fling Ball",Callback=function(v) -----? end})

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

------------------------------------------------
-- ANTI SIT (FORTE)
------------------------------------------------
local AntiSit = false
local AntiSitConn

ConfigTab:CreateToggle({
    Name="Anti Sit",
    Callback=function(v)
        AntiSit = v
        if v then
            AntiSitConn = RunService.Heartbeat:Connect(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.Sit = false
                    hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                end
            end)
        else
            if AntiSitConn then AntiSitConn:Disconnect() end
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true) end
        end
    end
})

ConfigTab:CreateToggle({
    Name="ESP Player",
    Callback=function(v)
        ESPPlayer = v
        if not v then clearESP() end
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and v then addESP(p) end
        end
    end
})

ConfigTab:CreateButton({
    Name="Delete Interface",
    Callback=function()
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
        addESP(p)
    end
end)

Rayfield:LoadConfiguration()
