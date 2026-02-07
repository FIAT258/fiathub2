--==================================================
-- FIAT HUB - REDZ V5 REMAKE
--==================================================

-- LOAD LIB
local Library = loadstring(game:HttpGet(
"https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"
))()

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==================================================
-- WINDOW
--==================================================
local Window = Library:MakeWindow({
    Title = "FIAT HUB",
    SubTitle = "Redz V5 Remake",
    ScriptFolder = "FiatHub"
})

-- MINIMIZER
local Minimizer = Window:NewMinimizer({
    KeyCode = Enum.KeyCode.LeftControl
})

--==================================================
-- TABS
--==================================================
local MainTab   = Window:MakeTab({"Main","home"})
local ToolsTab  = Window:MakeTab({"Tools","axe"})
local ConfigTab = Window:MakeTab({"Config","settings"})
local PingTab   = Window:MakeTab({"Ping","activity"})
local DiscordTab= Window:MakeTab({"Discord","message-circle"})

--==================================================
-- UTILS
--==================================================
local function Notify(t,d)
    Library:Notify({
        Title = t,
        Description = d,
        Time = 4
    })
end

--==================================================
-- PLAYER DROPDOWN
--==================================================
local SelectedPlayer
local PlayerNames = {}

local PlayerDropdown
local function RefreshPlayers()
    PlayerNames = {}
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(PlayerNames, p.Name)
        end
    end
    PlayerDropdown:Set(PlayerNames)
end

PlayerDropdown = MainTab:AddDropdown({
    Name = "Selecionar Player",
    Options = {},
    Callback = function(v)
        SelectedPlayer = Players:FindFirstChild(v)
    end
})

MainTab:AddButton({
    Name = "Refresh Player",
    Callback = function()
        RefreshPlayers()
        Notify("Players","Lista atualizada")
    end
})

Players.PlayerAdded:Connect(RefreshPlayers)
Players.PlayerRemoving:Connect(function(p)
    if SelectedPlayer == p then
        SelectedPlayer = nil
        Notify("Player","Player saiu do jogo")
    end
    RefreshPlayers()
end)

RefreshPlayers()

--==================================================
-- VIEW PLAYER (3ª PESSOA)
--==================================================
local Viewing = false
local ViewConn

MainTab:AddSwitch({
    Name = "View Player",
    Default = false,
    Callback = function(state)
        Viewing = state

        if ViewConn then
            ViewConn:Disconnect()
            ViewConn = nil
        end

        if not state then
            Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            return
        end

        ViewConn = RunService.RenderStepped:Connect(function()
            if SelectedPlayer
            and SelectedPlayer.Character
            and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
            and SelectedPlayer.Character:FindFirstChild("Humanoid") then

                local hrp = SelectedPlayer.Character.HumanoidRootPart
                Camera.CameraType = Enum.CameraType.Custom
                Camera.CameraSubject = SelectedPlayer.Character.Humanoid
                Camera.CFrame = hrp.CFrame * CFrame.new(0,5,12)
            end
        end)
    end
})

--==================================================
-- FLING BALL (BETA)
--==================================================
local FlingBall = false
local SoccerModel
local FlingConn

MainTab:AddParagraph({
    Title = "Aviso",
    Content = "⚠ Fling Ball em BETA"
})

MainTab:AddSwitch({
    Name = "Fling Ball",
    Default = false,
    Callback = function(state)
        FlingBall = state

        if FlingConn then
            FlingConn:Disconnect()
            FlingConn = nil
        end

        if not state then return end
        if not SelectedPlayer then
            Notify("Erro","Selecione um player")
            return
        end

        -- procurar tool SoccerBall
        for _,v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Tool") and v.Name == "SoccerBall" then
                v:Clone().Parent = LocalPlayer.Backpack
                break
            end
        end

        local tool = LocalPlayer.Backpack:FindFirstChild("SoccerBall")
        if tool then
            LocalPlayer.Character.Humanoid:EquipTool(tool)
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
            Notify("Erro","Modelo Soccer não encontrado")
            return
        end

        FlingConn = RunService.Heartbeat:Connect(function()
            if not FlingBall then return end
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
        Notify("Tool","TP Tool criado")
    end
})

--==================================================
-- CONFIG TAB
--==================================================
ConfigTab:AddSwitch({
    Name = "Anti Lag (bloquear novas luzes)",
    Default = false,
    Callback = function(state)
        if not state then return end
        workspace.DescendantAdded:Connect(function(v)
            if v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
                v.Enabled = false
            end
        end)
    end
})

--==================================================
-- PING TAB
--==================================================
PingTab:AddSwitch({
    Name = "Check Ping Server",
    Default = false,
    Callback = function(state)
        if not state then return end
        task.spawn(function()
            while state do
                local ping = math.floor(
                    Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
                )
                if ping <= 29 then
                    Notify("🟢 Ping ótimo", ping.." ms")
                elseif ping > 100 and ping <= 200 then
                    Notify("🟡 Ping estranho", ping.." ms")
                elseif ping > 200 then
                    Notify("🔴 Lag pesado","Ative Anti Lag")
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
    Content = "Script feito por fiat\nhttps://discord.gg/VrFBWxJEp5"
})

Notify("FIAT HUB","Script carregado com sucesso")
