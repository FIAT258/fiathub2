--==================================================
-- FIAT HUB - FLING CARRINHO UPDATE
--==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

----------------------------------------------------
-- UI LOAD
----------------------------------------------------
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"
))()

local Window = Library:MakeWindow({
    Title = "xFiREx HUB",
    SubTitle = "BY FIAT",
    ScriptFolder = "FiatHub"
})

----------------------------------------------------
-- UTILS
----------------------------------------------------
local function Char(p) return p.Character or p.CharacterAdded:Wait() end
local function HRP(p) return Char(p):WaitForChild("HumanoidRootPart") end
local function Hum(p) return Char(p):WaitForChild("Humanoid") end

----------------------------------------------------
-- MAIN TAB
----------------------------------------------------
local MainTab = Window:MakeTab({ Name = "Main", Icon = "home" })

local SelectedPlayer
local function GetPlayers()
    local t = {}
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(t,p.Name) end
    end
    return t
end

local function FindPlayer(n)
    for _,p in ipairs(Players:GetPlayers()) do
        if p.Name == n then return p end
    end
end

local PlayerDropdown = MainTab:AddDropdown({
    Name = "Selecionar Player",
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

----------------------------------------------------
-- FLING CARRINHO
----------------------------------------------------
local FlingCart = false
local flingConn

MainTab:AddToggle({
    Name = "Fling Carrinho",
    Default = false,
    Callback = function(state)
        FlingCart = state
        if flingConn then flingConn:Disconnect() end
        if not state then return end

        task.spawn(function()
            while FlingCart do
                if not SelectedPlayer then task.wait() continue end
                if Hum(SelectedPlayer).SeatPart then break end

                local tool = LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool")
                if tool then
                    tool.Parent = Char(LocalPlayer)
                end

                local start = tick()
                flingConn = RunService.Heartbeat:Connect(function()
                    if not FlingCart or not SelectedPlayer then return end

                    HRP(LocalPlayer).CFrame =
                        HRP(SelectedPlayer).CFrame *
                        CFrame.Angles(0, math.rad(tick()*6000), 0)
                end)

                task.wait(0.4)

                if Hum(SelectedPlayer).SeatPart then
                    if tool and tool.Parent == Char(LocalPlayer) then
                        tool.Parent = LocalPlayer.Backpack
                    end
                    if flingConn then flingConn:Disconnect() end
                    break
                end
            end
            FlingCart = false
        end)
    end
})

----------------------------------------------------
-- CONFIG TAB
----------------------------------------------------
local ConfigTab = Window:MakeTab({ Name = "Config", Icon = "settings" })

-- Infinite Jump (CORRIGIDO)
local InfJump = false
ConfigTab:AddToggle({
    Name = "Infinite Jump",
    Callback = function(v) InfJump = v end
})

UserInputService.JumpRequest:Connect(function()
    if InfJump then
        Hum(LocalPlayer):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

----------------------------------------------------
-- ESP PLAYER
----------------------------------------------------
local ESPEnabled = false
local espLabels = {}

ConfigTab:AddToggle({
    Name = "ESP Player",
    Callback = function(v)
        ESPEnabled = v
        if not v then
            for _,g in pairs(espLabels) do g:Destroy() end
            table.clear(espLabels)
        end
    end
})

RunService.RenderStepped:Connect(function()
    if not ESPEnabled then return end

    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and HRP(p) then
            if not espLabels[p] then
                local bb = Instance.new("BillboardGui", p.Character)
                bb.Size = UDim2.fromOffset(100,40)
                bb.AlwaysOnTop = true
                bb.Name = "ESP"

                local tl = Instance.new("TextLabel", bb)
                tl.Size = UDim2.fromScale(1,1)
                tl.BackgroundTransparency = 1
                tl.TextColor3 = Color3.fromRGB(255,255,255)
                tl.TextScaled = true

                bb.Adornee = HRP(p)
                espLabels[p] = bb
            end

            local dist = (HRP(LocalPlayer).Position - HRP(p).Position).Magnitude
            espLabels[p].TextLabel.Text =
                p.Name .. " | " .. math.floor(dist) .. "m"
        end
    end
end)

--==================================================
-- END
--==================================================
