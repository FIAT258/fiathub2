--==================================================
-- FIAT HUB - FULL GOD SCRIPT
-- UI: redz V5 remake
--==================================================

--------------------------
-- SERVICES
--------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--------------------------
-- SAFE CHARACTER FETCH
--------------------------
local function GetChar(plr)
    return plr.Character or plr.CharacterAdded:Wait()
end

local function GetHRP(plr)
    local char = GetChar(plr)
    return char:WaitForChild("HumanoidRootPart")
end

local function GetHum(plr)
    local char = GetChar(plr)
    return char:WaitForChild("Humanoid")
end

--------------------------
-- GLOBAL STATES
--------------------------
local SelectedPlayer = nil
local Toggles = {
    ViewPlayer = false,
    FlingBall = false,
    KillCanoa = false,
    LagIphone = false,
    BlackHole = false,
    InfJump = false
}

--------------------------
-- LOAD UI
--------------------------
local Library = loadstring(game:HttpGet(
"https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"
))()

local Window = Library:MakeWindow({
    Title = "xfirex hub (beta)",
    SubTitle = "by fiat",
    ScriptFolder = "FiatHub-God"
})

local Minimizer = Window:NewMinimizer({
    KeyCode = Enum.KeyCode.RightControl
})

local MobileButton = Minimizer:CreateMobileMinimizer({
    Image = "rbxassetid://1843070968", -- fogo
    BackgroundColor3 = Color3.fromRGB(255,120,0) -- laranja
})

--------------------------
-- PLAYER DROPDOWN LOGIC
--------------------------
local function GetPlayerNames()
    local list = {}
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(list, p.Name)
        end
    end
    return list
end

local function ResolvePlayer(name)
    for _,p in ipairs(Players:GetPlayers()) do
        if p.Name == name then
            return p
        end
    end
end

--------------------------
-- MAIN TAB
--------------------------
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "home"
})

local PlayerDropdown = MainTab:AddDropdown({
    Name = "Select Player",
    Options = GetPlayerNames(),
    Callback = function(v)
        SelectedPlayer = ResolvePlayer(v)
    end
})

task.spawn(function()
    while task.wait(2) do
        PlayerDropdown:Refresh(GetPlayerNames())
    end
end)

--------------------------
-- VIEW PLAYER (CAMERA)
--------------------------
local camConn
MainTab:AddToggle({
    Name = "View Player",
    Default = false,
    Callback = function(v)
        Toggles.ViewPlayer = v
        if camConn then camConn:Disconnect() end

        if v then
            camConn = RunService.RenderStepped:Connect(function()
                if SelectedPlayer and SelectedPlayer.Character then
                    local hrp = GetHRP(SelectedPlayer)
                    Camera.CameraSubject = hrp
                    Camera.CameraType = Enum.CameraType.Custom
                end
            end)
        else
            Camera.CameraSubject = GetHum(LocalPlayer)
        end
    end
})

--------------------------
-- FLING BALL (BETA)
--------------------------
local function GiveSoccerBall()
    local folder = Workspace:FindFirstChild("001_GiveTools")
    if folder and folder:FindFirstChild("SoccerBall") then
        local tool = folder.SoccerBall:Clone()
        tool.Parent = LocalPlayer.Backpack
        return tool
    end
end

local function PullBallsToPlayer(target)
    local balls = Workspace:FindFirstChild("001_SoccerBalls")
    if not balls then return end
    for _,v in ipairs(balls:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
            task.spawn(function()
                while Toggles.FlingBall and SelectedPlayer == target do
                    local hrp = GetHRP(target)
                    v.CFrame = hrp.CFrame * CFrame.new(math.random(-2,2),0,math.random(-2,2))
                    v.RotVelocity = Vector3.new(999,999,999)
                    task.wait()
                end
            end)
        end
    end
end

MainTab:AddToggle({
    Name = "Fling Ball (BETA)",
    Default = false,
    Callback = function(v)
        Toggles.FlingBall = v
        if not v then return end
        if not SelectedPlayer then return end

        local tool = GiveSoccerBall()
        if tool then
            task.wait(0.3)
            tool.Parent = GetChar(LocalPlayer)
            task.wait(3)
            PullBallsToPlayer(SelectedPlayer)
        end
    end
})

--------------------------
-- KILL CANOA
--------------------------
local function GetClosestClickDetector(root)
    local dist, found = math.huge, nil
    for _,v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("ClickDetector") and v.Parent:IsA("BasePart") then
            local d = (v.Parent.Position - root.Position).Magnitude
            if d < dist then
                dist, found = d, v
            end
        end
    end
    return found
end

MainTab:AddToggle({
    Name = "Kill Canoa",
    Default = false,
    Callback = function(v)
        Toggles.KillCanoa = v
        task.spawn(function()
            while Toggles.KillCanoa do
                if not SelectedPlayer then task.wait(1) continue end
                local hrp = GetHRP(LocalPlayer)

                local cd = GetClosestClickDetector(hrp)
                if cd then fireclickdetector(cd) end

                task.wait(2)

                local seat
                for _,v in ipairs(Workspace:GetDescendants()) do
                    if v:IsA("VehicleSeat") then seat = v break end
                end

                if seat then
                    TweenService:Create(hrp,TweenInfo.new(1),{CFrame=seat.CFrame}):Play()
                    task.wait(1)
                    seat:Sit(GetHum(LocalPlayer))
                    task.wait(1)
                    hrp.CFrame = GetHRP(SelectedPlayer).CFrame
                    task.wait(1)
                    hrp.CFrame = CFrame.new(0,-10000,0)
                end
                task.wait(2)
            end
        end)
    end
})

--------------------------
-- TROLL GOD TAB
--------------------------
local TrollTab = Window:MakeTab({
    Name = "Troll God",
    Icon = "zap"
})

--------------------------
-- LAG IPHONE
--------------------------
TrollTab:AddToggle({
    Name = "Lag iPhone",
    Default = false,
    Callback = function(v)
        Toggles.LagIphone = v
        task.spawn(function()
            while Toggles.LagIphone do
                local store = Workspace:FindFirstChild("Commercial1Store1")
                if store then
                    for _,cd in ipairs(store:GetDescendants()) do
                        if cd:IsA("ClickDetector") then
                            fireclickdetector(cd)
                        end
                    end
                end
                task.wait(1)

                local tool = LocalPlayer.Backpack:FindFirstChild("Ipone")
                if tool then
                    tool.Parent = GetChar(LocalPlayer)
                    task.spawn(function()
                        while Toggles.LagIphone do
                            local clone = tool:Clone()
                            clone.Parent = LocalPlayer.Backpack
                            task.wait(0.3)
                        end
                    end)
                end
                task.wait(2)
            end
        end)
    end
})

--------------------------
-- BLACK HOLE (FIXED)
--------------------------
local Network = {Parts={}}
local BHFolder = Instance.new("Folder",Workspace)
BHFolder.Name="FiatBlackHole"

local Anchor = Instance.new("Part",BHFolder)
Anchor.Anchored=true
Anchor.Transparency=1
Anchor.CanCollide=false

local Att1 = Instance.new("Attachment",Anchor)

local function ForcePart(p)
    if p:IsA("BasePart") and not p.Anchored and not p.Parent:FindFirstChildOfClass("Humanoid") then
        p.CanCollide=false
        local att2 = Instance.new("Attachment",p)
        local ap = Instance.new("AlignPosition",p)
        ap.Attachment0=att2
        ap.Attachment1=Att1
        ap.MaxForce=math.huge
        ap.Responsiveness=200
    end
end

TrollTab:AddToggle({
    Name = "Black Role",
    Default = false,
    Callback = function(v)
        Toggles.BlackHole = v
        if v then
            for _,p in ipairs(Workspace:GetDescendants()) do
                ForcePart(p)
            end
            RunService.RenderStepped:Connect(function()
                if Toggles.BlackHole then
                    Anchor.CFrame = GetHRP(LocalPlayer).CFrame
                end
            end)
        end
    end
})

--------------------------
-- CONFIG TAB
--------------------------
local ConfigTab = Window:MakeTab({
    Name = "Config",
    Icon = "settings"
})

ConfigTab:AddSlider({
    Name = "Speed",
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = function(v)
        GetHum(LocalPlayer).WalkSpeed = v
    end
})

ConfigTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(v)
        Toggles.InfJump = v
    end
})

UserInputService.JumpRequest:Connect(function()
    if Toggles.InfJump then
        GetHum(LocalPlayer):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

--------------------------
-- DISCORD TAB
--------------------------
local DiscordTab = Window:MakeTab({
    Name = "Discord",
    Icon = "message-circle"
})

DiscordTab:AddParagraph({
    Title = "Credits",
    Text = "Script feito por fiat\nChaos Engine\nUse com responsabilidade (ou não)"
})

DiscordTab:AddButton({
    Name = "Get Discord",
    Callback = function()
        setclipboard("https://discord.gg/VrFBWxJEp5")
    end
})

--==================================================
-- FIM DO SCRIPT
--==================================================
