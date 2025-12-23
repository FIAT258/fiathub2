-- FIAT HUB – FORSAKEN (ALL IN ONE FINAL)
debugX = true

------------------------------------------------
-- RAYFIELD
------------------------------------------------
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "FIAT HUB (Forsaken)",
    LoadingTitle = "FIAT HUB",
    LoadingSubtitle = "ALL IN ONE",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FIAT_HUB",
        FileName = "Forsaken_All"
    },
    KeySystem = false
})

local Tab = Window:CreateTab("MAIN", 4483362458)

------------------------------------------------
-- SERVICES
------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

------------------------------------------------
-- HELPERS
------------------------------------------------
local function pressKey(key)
    keypress(key)
    task.wait()
    keyrelease(key)
end

local function getHRP(model)
    return model and model:FindFirstChild("HumanoidRootPart")
end

local function dist(a, b)
    return (a.Position - b.Position).Magnitude
end

------------------------------------------------
-- KILLER CHECK (ORIGINAL)
------------------------------------------------
local function isKiller(model)
    return model
        and model:IsA("Model")
        and model.Parent
        and model.Parent.Name == "Killers"
        and model.Parent.Parent
        and model.Parent.Parent.Name == "Players"
        and model.Parent.Parent.Parent == workspace
end

------------------------------------------------
-- STATES
------------------------------------------------
local AutoChance = {Enabled=false, Radius=90, Cooldown=false}
local AutoBlock  = {Enabled=false, Radius=1.5}
local PlayerSpeed = {Enabled=false, Speed=16}
local AutoGen = {Enabled=false, Cooldown=1.2, Last=0}

local KillerESP = {Enabled=false, Cache={}}
local SurvivorESP = {Enabled=false, Cache={}}

------------------------------------------------
-- INFINITE STAMINA (ATUALIZADO – SEGURO)
------------------------------------------------
local InfiniteStamina = false
local staminaConn

local function enableInfiniteStamina()
    if staminaConn then staminaConn:Disconnect() end

    staminaConn = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum:SetAttribute("Stamina", 100)
                hum:SetAttribute("MaxStamina", 100)
            end)
        end
    end)
end

local function disableInfiniteStamina()
    if staminaConn then
        staminaConn:Disconnect()
        staminaConn = nil
    end
end

------------------------------------------------
-- ITEM ESP (ORIGINAL)
------------------------------------------------
local ItemESP = {
    Enabled = false,
    Cache = {}
}

local function isItem(model)
    return model
        and model:IsA("Model")
        and (model.Name == "BloxyCola" or model.Name == "Medkit")
        and model.Parent
        and model.Parent.Name == "Map"
end

local function getItemPart(model)
    if model.PrimaryPart then return model.PrimaryPart end
    for _,v in pairs(model:GetDescendants()) do
        if v:IsA("BasePart") then
            return v
        end
    end
end

local function addItemESP(model)
    if ItemESP.Cache[model] then return end
    local part = getItemPart(model)
    if not part then return end

    local h = Instance.new("Highlight")
    h.FillColor = Color3.fromRGB(0,255,0)
    h.OutlineColor = Color3.fromRGB(0,255,0)
    h.Adornee = part
    h.Parent = workspace

    local bb = Instance.new("BillboardGui")
    bb.Adornee = part
    bb.Size = UDim2.new(0,120,0,35)
    bb.AlwaysOnTop = true
    bb.Parent = workspace

    local txt = Instance.new("TextLabel", bb)
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.new(1,1,1)
    txt.TextScaled = true
    txt.Text = model.Name

    ItemESP.Cache[model] = {h, bb}
end

local function clearItemESP()
    for _,v in pairs(ItemESP.Cache) do
        for _,o in pairs(v) do
            pcall(function() o:Destroy() end)
        end
    end
    table.clear(ItemESP.Cache)
end

------------------------------------------------
-- AUTO CHANCE / AUTO BLOCK (ORIGINAIS)
------------------------------------------------
-- (inalterados)

------------------------------------------------
-- AUTO GENERATOR (ATUALIZADO – REAL)
------------------------------------------------
local function runAutoGen()
    if not AutoGen.Enabled then return end
    if tick() - AutoGen.Last < AutoGen.Cooldown then return end
    AutoGen.Last = tick()

    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Parent and obj.Parent.Name:lower():find("generator") then
            pcall(function()
                fireproximityprompt(obj)
            end)
        end
    end
end

------------------------------------------------
-- RESTO DO SCRIPT
------------------------------------------------
-- 🔒 TODO O RESTO PERMANECE EXATAMENTE IGUAL AO SEU
