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
local AutoGen = {Enabled=false, Cooldown=3.9, Last=0}

local KillerESP = {Enabled=false, Cache={}}
local SurvivorESP = {Enabled=false, Cache={}}

------------------------------------------------
-- INFINITE STAMINA (LOGICA NOVA – SPRINTING MODULE)
------------------------------------------------
local InfiniteStamina = false

local function enableInfiniteStamina()
    local sprintingModule = require(game:GetService("ReplicatedStorage").Systems.Character.Game.Sprinting)

    local originalStaminaChange = sprintingModule.ChangeStat
    sprintingModule.ChangeStat = function(self, stat, value)
        if stat == "Stamina" then
            return
        end
        return originalStaminaChange(self, stat, value)
    end

    local originalInit = sprintingModule.Init
    sprintingModule.Init = function(self)
        originalInit(self)

        self.StaminaLossDisabled = true
        self.Stamina = self.MaxStamina

        local staminaLoop
        staminaLoop = game:GetService("RunService").Heartbeat:Connect(function()
            if self.Stamina < self.MaxStamina then
                self.Stamina = self.MaxStamina
                if self.__staminaChangedEvent then
                    self.__staminaChangedEvent:Fire(self.MaxStamina)
                end
            end
        end)

        self._infiniteStaminaLoop = staminaLoop
    end

    if sprintingModule.DefaultsSet then
        sprintingModule.StaminaLossDisabled = true
        sprintingModule.Stamina = sprintingModule.MaxStamina

        if not sprintingModule._infiniteStaminaLoop then
            local staminaLoop = game:GetService("RunService").Heartbeat:Connect(function()
                if sprintingModule.Stamina < sprintingModule.MaxStamina then
                    sprintingModule.Stamina = sprintingModule.MaxStamina
                    if sprintingModule.__staminaChangedEvent then
                        sprintingModule.__staminaChangedEvent:Fire(sprintingModule.MaxStamina)
                    end
                end
            end)
            sprintingModule._infiniteStaminaLoop = staminaLoop
        end
    end

    _G.InfiniteStaminaData = {
        OriginalChangeStat = originalStaminaChange,
        OriginalInit = originalInit,
        Module = sprintingModule
    }
end

local function disableInfiniteStamina()
    if _G.InfiniteStaminaData then
        local sprintingModule = _G.InfiniteStaminaData.Module

        sprintingModule.ChangeStat = _G.InfiniteStaminaData.OriginalChangeStat
        sprintingModule.Init = _G.InfiniteStaminaData.OriginalInit
        sprintingModule.StaminaLossDisabled = false

        if sprintingModule._infiniteStaminaLoop then
            sprintingModule._infiniteStaminaLoop:Disconnect()
            sprintingModule._infiniteStaminaLoop = nil
        end

        _G.InfiniteStaminaData = nil
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
-- AUTO CHANCE (ORIGINAL)
------------------------------------------------
local function runAutoChance()
    if AutoChance.Cooldown then return end
    local myHRP = getHRP(LocalPlayer.Character)
    if not myHRP then return end

    for _,m in pairs(workspace:GetDescendants()) do
        if isKiller(m) then
            local hrp = getHRP(m)
            if hrp and dist(myHRP, hrp) <= AutoChance.Radius then
                AutoChance.Cooldown = true
                pressKey(Enum.KeyCode.LeftControl)

                local cam
                cam = RunService.RenderStepped:Connect(function()
                    if not AutoChance.Enabled then cam:Disconnect() end
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, hrp.Position)
                end)

                task.wait(0.2)
                pressKey(Enum.KeyCode.E)
                task.wait(1)
                if cam then cam:Disconnect() end

                task.delay(45,function()
                    AutoChance.Cooldown = false
                end)
                break
            end
        end
    end
end

------------------------------------------------
-- AUTO BLOCK (ORIGINAL)
------------------------------------------------
local function runAutoBlock()
    local myHRP = getHRP(LocalPlayer.Character)
    if not myHRP then return end

    for _,p in pairs(workspace:GetDescendants()) do
        if p:IsA("BasePart") and p.Name:lower():find("hit") then
            if dist(myHRP, p) <= AutoBlock.Radius then
                pressKey(Enum.KeyCode.Q)
                task.wait(0.7)
                pressKey(Enum.KeyCode.R)
                break
            end
        end
    end
end

------------------------------------------------
-- AUTO GENERATOR (LOGICA ATUALIZADA – REAL)
------------------------------------------------
local function runAutoGen()
    if not AutoGen.Enabled then return end
    if tick() - AutoGen.Last < AutoGen.Cooldown then return end
    AutoGen.Last = tick()

    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt")
        and obj.Parent
        and obj.Parent.Name:lower():find("generator") then
            pcall(function()
                fireproximityprompt(obj)
            end)
        end
    end
end

------------------------------------------------
-- ESP HELPERS
------------------------------------------------
local function applyESP(model,color,cache)
    if cache[model] then return end
    local h = Instance.new("Highlight")
    h.FillColor = color
    h.OutlineColor = color
    h.Adornee = model
    h.Parent = model
    cache[model] = h
end

local function clearESP(cache)
    for _,h in pairs(cache) do
        pcall(function() h:Destroy() end)
    end
    table.clear(cache)
end

------------------------------------------------
-- MAIN LOOP
------------------------------------------------
RunService.Heartbeat:Connect(function()
    if AutoChance.Enabled then runAutoChance() end
    if AutoBlock.Enabled then runAutoBlock() end
    if AutoGen.Enabled then runAutoGen() end

    if PlayerSpeed.Enabled then
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = PlayerSpeed.Speed end
    end

    if KillerESP.Enabled then
        for _,m in pairs(workspace:GetDescendants()) do
            if isKiller(m) then
                applyESP(m, Color3.fromRGB(255,0,0), KillerESP.Cache)
            end
        end
    end

    if SurvivorESP.Enabled then
        for _,p in pairs(Players:GetPlayers()) do
            if p.Character and not isKiller(p.Character) then
                applyESP(p.Character, Color3.fromRGB(0,255,0), SurvivorESP.Cache)
            end
        end
    end

    if ItemESP.Enabled then
        for _,m in pairs(workspace:GetDescendants()) do
            if isItem(m) then
                addItemESP(m)
            end
        end
    end
end)

------------------------------------------------
-- LIGHT
------------------------------------------------
local orig = {Lighting.Brightness, Lighting.ClockTime}
local function lightOn()
    Lighting.Brightness = 5
    Lighting.ClockTime = 14
end
local function lightOff()
    Lighting.Brightness = orig[1]
    Lighting.ClockTime = orig[2]
end

------------------------------------------------
-- UI (NADA SEPARADO)
------------------------------------------------
Tab:CreateToggle({Name="Aim Bot Chance",Callback=function(v) AutoChance.Enabled=v end})
Tab:CreateToggle({Name="Auto Block",Callback=function(v) AutoBlock.Enabled=v end})
Tab:CreateToggle({Name="Auto Generator",Callback=function(v) AutoGen.Enabled=v end})

Tab:CreateToggle({
    Name="Infinite Stamina",
    Callback=function(v)
        InfiniteStamina = v
        if v then enableInfiniteStamina() else disableInfiniteStamina() end
    end
})

Tab:CreateToggle({Name="ESP Killer",Callback=function(v) KillerESP.Enabled=v if not v then clearESP(KillerESP.Cache) end end})
Tab:CreateToggle({Name="ESP Sobreviventes",Callback=function(v) SurvivorESP.Enabled=v if not v then clearESP(SurvivorESP.Cache) end end})
Tab:CreateToggle({Name="ESP Itens",Callback=function(v) ItemESP.Enabled=v if not v then clearItemESP() end end})
Tab:CreateToggle({Name="Luz",Callback=function(v) if v then lightOn() else lightOff() end end})

Tab:CreateSlider({
    Name="Player Speed",
    Range={0,100},
    CurrentValue=16,
    Callback=function(v) PlayerSpeed.Speed=v end
})

Tab:CreateToggle({
    Name="Ativar Speed",
    Callback=function(v) PlayerSpeed.Enabled=v end
})

Rayfield:LoadConfiguration()
