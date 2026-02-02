--==================================================
-- FIAT HUB - SOFA FLING UPDATE
--==================================================

--------------------------
-- SERVICES
--------------------------
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--------------------------
-- LOAD UI
--------------------------
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"
))()

local Window = Library:MakeWindow({
    Title = "xFIREx HUB",
    SubTitle = "by fiat",
    ScriptFolder = "FiatHub"
})



--------------------------
-- UTILS
--------------------------
local function Char(p)
    return p.Character or p.CharacterAdded:Wait()
end

local function HRP(p)
    return Char(p):WaitForChild("HumanoidRootPart")
end

local function Hum(p)
    return Char(p):WaitForChild("Humanoid")
end

--------------------------
-- PLAYER DROPDOWN
--------------------------
local SelectedPlayer

local function GetPlayers()
    local t = {}
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(t,p.Name)
        end
    end
    return t
end

local function FindPlayer(n)
    for _,p in ipairs(Players:GetPlayers()) do
        if p.Name == n then return p end
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
    Options = GetPlayers(),
    Callback = function(v)
        SelectedPlayer = FindPlayer(v)
    end
})

local function RefreshPlayers()
    PlayerDropdown:Refresh(GetPlayers())
end

Players.PlayerAdded:Connect(RefreshPlayers)
Players.PlayerRemoving:Connect(RefreshPlayers)

--------------------------
-- SOFA FLING TOGGLE
--------------------------
local SofaFling = false
local flingConn

MainTab:AddToggle({
    Name = "Fling Sofa",
    Default = false,
    Callback = function(state)
        SofaFling = state
        if flingConn then flingConn:Disconnect() end
        if not state then return end

        task.spawn(function()
            while SofaFling do
                if not SelectedPlayer then task.wait(1) continue end

                local hum = Hum(LocalPlayer)
                if hum.SeatPart then
                    Library:Notify({
                        Title = "FIAT HUB",
                        Text = "Você já está sentado.",
                        Duration = 3
                    })
                    SofaFling = false
                    break
                end

                local folder = Workspace:FindFirstChild("003_CouchGiveTool")
                if not folder or not folder:FindFirstChild("Seat1") then
                    task.wait(1)
                    continue
                end

                local seat = folder.Seat1
                TweenService:Create(
                    HRP(LocalPlayer),
                    TweenInfo.new(1),
                    {CFrame = seat.CFrame * CFrame.new(0,2,0)}
                ):Play()

                repeat task.wait() until hum.SeatPart

                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                task.wait(0.2)

                local tool = LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool")
                if tool then
                    tool.Parent = Char(LocalPlayer)
                end

                flingConn = RunService.Heartbeat:Connect(function()
                    if not SofaFling or not SelectedPlayer then return end

                    if Hum(SelectedPlayer).SeatPart then
                        Library:Notify({
                            Title = "FIAT HUB",
                            Text = "Player está sentado.",
                            Duration = 3
                        })
                        SofaFling = false
                        flingConn:Disconnect()
                        return
                    end

                    HRP(LocalPlayer).CFrame =
                        HRP(SelectedPlayer).CFrame *
                        CFrame.Angles(0, math.rad(tick()*5000), 0)
                end)

                SelectedPlayer.CharacterAdded:Wait()
                for _,t in ipairs(LocalPlayer.Backpack:GetChildren()) do
                    if t:IsA("Tool") then t:Destroy() end
                end
            end
        end)
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
    Name = "WalkSpeed",
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = function(v)
        Hum(LocalPlayer).WalkSpeed = v
    end
})

--------------------------
-- DISCORD TAB
--------------------------
local DiscordTab = Window:MakeTab({
    Name = "Discord",
    Icon = "message-circle"
})

DiscordTab:AddParagraph({
    Title = "FIAT HUB",
    Text = "Script feito por fiat\nUI redz V5\ncaos controlado"
})

DiscordTab:AddButton({
    Name = "Copiar Discord",
    Callback = function()
        setclipboard("https://discord.gg/VrFBWxJEp5")
    end
})

--==================================================
-- END
--==================================================
