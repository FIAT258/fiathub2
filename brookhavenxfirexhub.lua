--// REDZ V5 REMAKE - SCRIPT COMPLETO
--// feito por fiat (como pedido)

--==================================================
-- LOAD LIBRARY (CORRETA)
--==================================================
local Library = loadstring(game:HttpGet(
"https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"
))()

--==================================================
-- SERVICES
--==================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==================================================
-- WINDOW
--==================================================
local Window = Library:MakeWindow({
    Title = "FIAT HUB",
    SubTitle = "Redz V5 Remake",
    ScriptFolder = "FiatHubV5"
})

-- Minimizer
local Minimizer = Window:NewMinimizer({
    KeyCode = Enum.KeyCode.LeftControl
})

--==================================================
-- TABS
--==================================================
local MainTab   = Window:MakeTab({"Main", "home"})
local ToolsTab  = Window:MakeTab({"Tools", "axe"})
local ConfigTab = Window:MakeTab({"Configuração", "settings"})
local PingTab   = Window:MakeTab({"Ping", "activity"})
local DiscordTab= Window:MakeTab({"Discord", "message-circle"})

--==================================================
-- UTIL FUNCTIONS
--==================================================
local function Notify(title, text)
    Library:Notify({
        Title = title,
        Description = text,
        Time = 4
    })
end

--==================================================
-- PLAYER DROPDOWN
--==================================================
local SelectedPlayer = nil
local PlayerList = {}

local function RefreshPlayers()
    PlayerList = {}
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(PlayerList, plr.Name)
        end
    end
    PlayerDropdown:Set(PlayerList)
end

--==================================================
-- MAIN TAB
--==================================================

PlayerDropdown = MainTab:AddDropdown({
    Name = "Selecionar Player",
    Options = {},
    Default = nil,
    Callback = function(v)
        SelectedPlayer = Players:FindFirstChild(v)
    end
})

MainTab:AddButton({
    Name = "Refresh Player",
    Callback = function()
        RefreshPlayers()
        Notify("Players", "Lista atualizada")
    end
})

Players.PlayerAdded:Connect(RefreshPlayers)
Players.PlayerRemoving:Connect(function(plr)
    if SelectedPlayer == plr then
        SelectedPlayer = nil
        Notify("Player saiu", "Player saiu do jogo")
    end
    RefreshPlayers()
end)

RefreshPlayers()

--==================================================
-- VIEW PLAYER (3ª PESSOA)
--==================================================
local ViewConnection
local Viewing = false
local OriginalSubject = Camera.CameraSubject

MainTab:AddToggle({
    Name = "View Player",
    Default = false,
    Callback = function(state)
        Viewing = state

        if ViewConnection then
            ViewConnection:Disconnect()
            ViewConnection = nil
        end

        if not state then
            Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            return
        end

        ViewConnection = RunService.RenderStepped:Connect(function()
            if SelectedPlayer
            and SelectedPlayer.Character
            and SelectedPlayer.Character:FindFirstChild("Humanoid")
            and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then

                Camera.CameraType = Enum.CameraType.Custom
                Camera.CameraSubject = SelectedPlayer.Character.Humanoid
                Camera.CFrame =
                    SelectedPlayer.Character.HumanoidRootPart.CFrame
                    * CFrame.new(0, 5, 12)
            end
        end)
    end
})

--==================================================
-- FLING BALL (BETA)
--==================================================
local FlingBallRunning = false
local SoccerModel
local FlingConn

MainTab:AddParagraph({
    Title = "Aviso",
    Content = "⚠ Fling Ball em BETA"
})

MainTab:AddToggle({
    Name = "Fling Ball (BETA)",
    Default = false,
    Callback = function(state)
        FlingBallRunning = state

        if not state then
            if FlingConn then FlingConn:Disconnect() end
            return
        end

        if not SelectedPlayer then
            Notify("Erro", "Selecione um player")
            return
        end

        -- procura tool SoccerBall
        local toolFound
        for _,v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Tool") and v.Name == "SoccerBall" then
                toolFound = v:Clone()
                break
            end
        end

        if toolFound then
            toolFound.Parent = LocalPlayer.Backpack
            LocalPlayer.Character.Humanoid:EquipTool(toolFound)

            -- 9 clicks
            for i=1,9 do
                VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0)
                VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0)
            end
        end

        -- procurar modelo Soccer
        for _,m in ipairs(workspace:GetDescendants()) do
            if m:IsA("Model") and m.Name == "Soccer" then
                SoccerModel = m
                break
            end
        end

        if not SoccerModel then
            Notify("Erro", "Modelo Soccer não encontrado")
            return
        end

        FlingConn = RunService.Heartbeat:Connect(function()
            if not FlingBallRunning then return end
            if not SelectedPlayer or not SelectedPlayer.Character then return end

            local hrp = SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            for _,p in ipairs(SoccerModel:GetDescendants()) do
                if p:IsA("BasePart") then
                    local dir = (hrp.Position - p.Position)
                    p.Velocity = dir.Unit * 120
                    p.RotVelocity = Vector3.new(0,50,0)
                end
            end
        end)
    end
})

--==================================================
-- TOOLS TAB
--==================================================
ToolsTab:AddButton({
    Name = "TP Tool",
    Callback = function()
        local tool = Instance.new("Tool")
        tool.Name = "TPTool"
        tool.RequiresHandle = false

        tool.Activated:Connect(function()
            local mouse = LocalPlayer:GetMouse()
            if mouse.Hit then
                LocalPlayer.Character:MoveTo(mouse.Hit.Position)
            end
        end)

        tool.Parent = LocalPlayer.Backpack
        Notify("Tool", "TP Tool criado")
    end
})

ToolsTab:AddButton({
    Name = "Select Player (Click)",
    Callback = function()
        Notify("Info", "Clique em um player")
        local mouse = LocalPlayer:GetMouse()
        mouse.Button1Down:Wait()
        if mouse.Target then
            local hum = mouse.Target.Parent:FindFirstChild("Humanoid")
            if hum then
                Notify("Player", mouse.Target.Parent.Name)
            end
        end
    end
})

local ToolList = {}
local SelectedTool

local function RefreshTools()
    ToolList = {}
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Tool") then
            table.insert(ToolList, v.Name)
        end
    end
    ToolDropdown:Set(ToolList)
end

ToolDropdown = ToolsTab:AddDropdown({
    Name = "Tools do Jogo",
    Options = {},
    Callback = function(v)
        SelectedTool = v
    end
})

ToolsTab:AddButton({
    Name = "Get Tool",
    Callback = function()
        if not SelectedTool then return end
        for _,v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Tool") and v.Name == SelectedTool then
                v:Clone().Parent = LocalPlayer.Backpack
                Notify("Tool", "Tool adicionado")
                break
            end
        end
    end
})

RefreshTools()

--==================================================
-- CONFIG TAB
--==================================================
local AntiLag = false
local LightConn

ConfigTab:AddToggle({
    Name = "Anti Lag (bloquear novas luzes)",
    Default = false,
    Callback = function(state)
        AntiLag = state
        if LightConn then LightConn:Disconnect() end

        if state then
            LightConn = workspace.DescendantAdded:Connect(function(v)
                if v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
                    v.Enabled = false
                end
            end)
        end
    end
})

local TexturesRemoved = {}

ConfigTab:AddToggle({
    Name = "Remover Texturas",
    Default = false,
    Callback = function(state)
        if state then
            for _,v in ipairs(workspace:GetDescendants()) do
                if v:IsA("Decal") or v:IsA("Texture") then
                    TexturesRemoved[v] = v.Transparency
                    v.Transparency = 1
                end
            end
        else
            for v,trans in pairs(TexturesRemoved) do
                if v then
                    v.Transparency = trans
                end
            end
            TexturesRemoved = {}
        end
    end
})

--==================================================
-- PING TAB
--==================================================
PingTab:AddToggle({
    Name = "Check Ping Server",
    Default = false,
    Callback = function(state)
        if not state then return end

        task.spawn(function()
            while state do
                local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())

                if ping <= 29 then
                    Notify("🟢 Ping ótimo", ping.." ms")
                elseif ping > 100 and ping <= 200 then
                    Notify("🟡 Ping estranho", ping.." ms")
                elseif ping > 200 then
                    Notify("🔴 Lag pesado", "Ative Anti Lag e Remover Texturas")
                end
                task.wait(5)
            end
        end)
    end
})

--==================================================
-- DISCORD TAB
--==================================================
DiscordTab:AddParagraph({
    Title = "Discord",
    Content = "Script feito por fiat\nEntre no discord para updates"
})

--==================================================
Notify("FIAT HUB", "Script carregado com sucesso")
