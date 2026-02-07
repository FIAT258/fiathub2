--==================================================
-- SERVICES
--==================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==================================================
-- LOAD UI
--==================================================
local Library = loadstring(game:HttpGet(
"https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"
))()

--==================================================
-- WINDOW
--==================================================
local Window = Library:MakeWindow({
    Title = "Fiat Hub",
    SubTitle = "fling ball beta",
    ScriptFolder = "FiatHub"
})

local Minimizer = Window:NewMinimizer({
    KeyCode = Enum.KeyCode.LeftControl
})

--==================================================
-- UTILS
--==================================================
local function Notify(txt)
    StarterGui:SetCore("SendNotification", {
        Title = "Fiat Hub",
        Text = txt,
        Duration = 4
    })
end

--==================================================
-- PLAYER SYSTEM
--==================================================
local SelectedPlayer

local function GetPlayers()
    local t = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(t, p.Name)
        end
    end
    return t
end

--==================================================
-- MAIN TAB
--==================================================
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "home"
})

local PlayerDropdown = MainTab:AddDropdown({
    Name = "Select Player",
    Options = GetPlayers(),
    Callback = function(v)
        SelectedPlayer = Players:FindFirstChild(v)
    end
})

MainTab:AddButton({
    Name = "Refresh Player",
    Callback = function()
        PlayerDropdown:Set(GetPlayers())
    end
})

Players.PlayerAdded:Connect(function()
    PlayerDropdown:Set(GetPlayers())
end)

Players.PlayerRemoving:Connect(function(p)
    if SelectedPlayer == p then
        SelectedPlayer = nil
        Notify("player saiu do jogo")
    end
    PlayerDropdown:Set(GetPlayers())
end)

--==================================================
-- VIEW PLAYER (3ª PESSOA)
--==================================================
local ViewEnabled = false
local ViewConn
local DefaultSubject = Camera.CameraSubject

MainTab:AddToggle({
    Name = "View Player",
    Default = false,
    Callback = function(state)
        ViewEnabled = state

        if ViewConn then
            ViewConn:Disconnect()
            ViewConn = nil
        end

        if not state then
            Camera.CameraSubject = DefaultSubject
            Camera.CameraType = Enum.CameraType.Custom
            return
        end

        ViewConn = RunService.RenderStepped:Connect(function()
            if ViewEnabled
            and SelectedPlayer
            and SelectedPlayer.Character
            and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then

                Camera.CameraType = Enum.CameraType.Scriptable
                local hrp = SelectedPlayer.Character.HumanoidRootPart
                Camera.CFrame = CFrame.new(
                    hrp.Position + Vector3.new(0, 6, 12),
                    hrp.Position
                )
            end
        end)
    end
})

MainTab:AddLabel("⚠️ Fling Ball em BETA")

--==================================================
-- FLING BALL
--==================================================
local FlingBall = false
local BallConn

MainTab:AddToggle({
    Name = "Fling Ball (BETA)",
    Default = false,
    Callback = function(state)
        FlingBall = state

        if BallConn then
            BallConn:Disconnect()
            BallConn = nil
        end

        if not state then return end

        task.spawn(function()
            if not SelectedPlayer then return end

            -- pegar SoccerBall
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("Tool") and v.Name == "SoccerBall" then
                    v.Parent = LocalPlayer.Backpack
                end
            end

            task.wait(0.3)

            local tool = LocalPlayer.Backpack:FindFirstChild("SoccerBall")
            if not tool then
                Notify("SoccerBall não encontrado")
                return
            end

            tool.Parent = LocalPlayer.Character

            -- 9 clicks
            for i = 1, 9 do
                mouse1click()
            end

            -- achar modelo Soccer
            local soccerModel
            for _, m in ipairs(workspace:GetDescendants()) do
                if m.Name == "Soccer" and m:IsA("Model") then
                    soccerModel = m
                    break
                end
            end

            if not soccerModel then
                Notify("Modelo Soccer não encontrado")
                return
            end

            BallConn = RunService.Heartbeat:Connect(function()
                if not FlingBall
                or not SelectedPlayer
                or not SelectedPlayer.Character
                or not SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    return
                end

                local target = SelectedPlayer.Character.HumanoidRootPart

                for _, p in ipairs(soccerModel:GetDescendants()) do
                    if p:IsA("BasePart") then
                        local dir = (target.Position - p.Position)
                        p.Velocity = dir.Unit * 300
                        p.CFrame = p.CFrame * CFrame.Angles(0, math.rad(120), 0)
                    end
                end
            end)
        end)
    end
})

--==================================================
-- TOOLS TAB
--==================================================
local ToolsTab = Window:MakeTab({
    Name = "Tools",
    Icon = "axe"
})

ToolsTab:AddButton({
    Name = "TP Tool",
    Callback = function()
        local tool = Instance.new("Tool")
        tool.Name = "TPTool"
        tool.RequiresHandle = false
        tool.Parent = LocalPlayer.Backpack

        tool.Activated:Connect(function()
            local mouse = LocalPlayer:GetMouse()
            if mouse.Hit then
                LocalPlayer.Character.HumanoidRootPart.CFrame = mouse.Hit
            end
        end)
    end
})

ToolsTab:AddButton({
    Name = "Select Tool (click player)",
    Callback = function()
        Notify("clique em um player")
    end
})

local ToolDropdown = ToolsTab:AddDropdown({
    Name = "All Tools",
    Options = {},
    Callback = function() end
})

ToolsTab:AddButton({
    Name = "Get Tool",
    Callback = function()
        local toolName = ToolDropdown.Value
        if not toolName then return end

        for _, t in ipairs(workspace:GetDescendants()) do
            if t:IsA("Tool") and t.Name == toolName then
                t.Parent = LocalPlayer.Backpack
                break
            end
        end
    end
})

--==================================================
-- CONFIG TAB
--==================================================
local ConfigTab = Window:MakeTab({
    Name = "Config",
    Icon = "settings"
})

local AntiLag = false
ConfigTab:AddToggle({
    Name = "Anti Lag (disable lights)",
    Default = false,
    Callback = function(v)
        AntiLag = v
        if v then
            for _, l in ipairs(workspace:GetDescendants()) do
                if l:IsA("Light") then
                    l.Enabled = false
                end
            end
        end
    end
})

local Removed = {}
ConfigTab:AddToggle({
    Name = "Remove Textures",
    Default = false,
    Callback = function(v)
        if v then
            for _, d in ipairs(workspace:GetDescendants()) do
                if d:IsA("Decal") or d:IsA("Texture") then
                    Removed[d] = d.Parent
                    d.Parent = nil
                end
            end
        else
            for d, p in pairs(Removed) do
                d.Parent = p
            end
            table.clear(Removed)
        end
    end
})

--==================================================
-- PING TAB
--==================================================
local PingTab = Window:MakeTab({
    Name = "Ping",
    Icon = "wifi"
})

PingTab:AddToggle({
    Name = "Check Ping Server",
    Default = false,
    Callback = function(v)
        if not v then return end
        task.spawn(function()
            while v do
                task.wait(5)
                local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())

                if ping <= 29 then
                    Notify("🟢 ping ótimo: "..ping)
                elseif ping > 100 and ping < 200 then
                    Notify("🟡 ping estranho: "..ping)
                elseif ping >= 200 then
                    Notify("🔴 ping alto: "..ping.." | ative anti lag")
                end
            end
        end)
    end
})
