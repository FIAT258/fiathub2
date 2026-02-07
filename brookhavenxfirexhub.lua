--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// LIB
local Library = loadstring(game:HttpGet(
 "https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"
))()

--// WINDOW
local Window = Library:MakeWindow({
 Title = "Fiat Hub",
 SubTitle = "Update Grande",
 ScriptFolder = "FiatHub"
})

local Minimizer = Window:NewMinimizer({
 KeyCode = Enum.KeyCode.LeftControl
})

--// UTILS
local function GetPlayers()
 local t = {}
 for _,p in pairs(Players:GetPlayers()) do
  if p ~= LocalPlayer then
   table.insert(t,p.Name)
  end
 end
 return t
end

--==================================================
-- MAIN TAB
--==================================================
local MainTab = Window:MakeTab({
 Title = "Main",
 Icon = "Home"
})

local SelectedPlayer = nil
local ViewConnection = nil
local FlingConnection = nil
local SoccerModel = nil

local PlayerDropdown = MainTab:AddDropdown({
 Name = "Select Player",
 Options = GetPlayers(),
 Callback = function(v)
  SelectedPlayer = v
 end
})

MainTab:AddButton({
 Name = "Refresh Player",
 Callback = function()
  PlayerDropdown:Set(GetPlayers())
 end
})

-- VIEW PLAYER
MainTab:AddToggle({
 Name = "View Player",
 Default = false,
 Callback = function(Value)
  if Value then
   ViewConnection = RunService.RenderStepped:Connect(function()
    local p = Players:FindFirstChild(SelectedPlayer or "")
    if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
     Camera.CameraType = Enum.CameraType.Scriptable
     Camera.CFrame =
      p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 10)
    end
   end)
  else
   if ViewConnection then ViewConnection:Disconnect() end
   Camera.CameraType = Enum.CameraType.Custom
  end
 end
})

-- FLING BALL
MainTab:AddToggle({
 Name = "Fling Ball (BETA)",
 Default = false,
 Callback = function(Value)
  if Value then
   -- pegar SoccerBall
   for _,v in pairs(workspace:GetDescendants()) do
    if v:IsA("Tool") and v.Name == "SoccerBall" then
     v.Parent = LocalPlayer.Backpack
    end
   end

   local tool = LocalPlayer.Backpack:FindFirstChild("SoccerBall")
   if tool then
    LocalPlayer.Character.Humanoid:EquipTool(tool)
    for i = 1,9 do
     mouse1click()
    end
   end

   -- pegar modelo Soccer
   for _,m in pairs(workspace:GetDescendants()) do
    if m:IsA("Model") and m.Name == "Soccer" then
     SoccerModel = m
    end
   end

   FlingConnection = RunService.Heartbeat:Connect(function()
    local p = Players:FindFirstChild(SelectedPlayer or "")
    if not p then
     Window:Notify({
      Title = "Info",
      Content = "Player saiu do jogo",
      Duration = 4
     })
     FlingConnection:Disconnect()
     return
    end

    if p.Character and p.Character:FindFirstChild("HumanoidRootPart")
     and SoccerModel and SoccerModel.PrimaryPart then

     local hrp = p.Character.HumanoidRootPart
     SoccerModel:SetPrimaryPartCFrame(
      CFrame.new(hrp.Position + hrp.CFrame.LookVector * 2)
     )
     SoccerModel.PrimaryPart.AssemblyAngularVelocity =
      Vector3.new(0, 9999, 0)
    end
   end)
  else
   if FlingConnection then FlingConnection:Disconnect() end
  end
 end
})

MainTab:AddParagraph(
 "Info",
 "Fling Ball em BETA junto com o script"
)

--==================================================
-- TOOLS TAB
--==================================================
local ToolsTab = Window:MakeTab({
 Title = "Tools",
 Icon = "🪓"
})

ToolsTab:AddButton({
 Name = "TP Tool",
 Callback = function()
  local Tool = Instance.new("Tool")
  Tool.Name = "TP Tool"
  Tool.Parent = LocalPlayer.Backpack

  Tool.Activated:Connect(function()
   local mouse = LocalPlayer:GetMouse()
   if mouse.Hit then
    LocalPlayer.Character.HumanoidRootPart.CFrame = mouse.Hit
   end
  end)
 end
})

ToolsTab:AddButton({
 Name = "Select Tool Player",
 Callback = function()
  local mouse = LocalPlayer:GetMouse()
  mouse.Button1Down:Wait()
  local p = Players:GetPlayerFromCharacter(mouse.Target.Parent)
  if p then
   Window:Notify({
    Title = "Player Selecionado",
    Content = p.Name,
    Duration = 3
   })
  end
 end
})

local ToolDropdown = ToolsTab:AddDropdown({
 Name = "Tools do Jogo",
 Options = {}
})

ToolsTab:AddButton({
 Name = "Refresh Tools",
 Callback = function()
  local t = {}
  for _,v in pairs(workspace:GetDescendants()) do
   if v:IsA("Tool") then
    table.insert(t, v.Name)
   end
  end
  ToolDropdown:Set(t)
 end
})

ToolsTab:AddButton({
 Name = "Get Tool",
 Callback = function()
  local name = ToolDropdown.Value
  for _,v in pairs(workspace:GetDescendants()) do
   if v:IsA("Tool") and v.Name == name then
    v.Parent = LocalPlayer.Backpack
   end
  end
 end
})

--==================================================
-- CONFIG TAB
--==================================================
local ConfigTab = Window:MakeTab({
 Title = "Configuração",
 Icon = "Settings"
})

local AntiLag = false

ConfigTab:AddToggle({
 Name = "Anti Lag",
 Default = false,
 Callback = function(v)
  AntiLag = v
 end
})

workspace.DescendantAdded:Connect(function(o)
 if AntiLag and (o:IsA("PointLight") or o:IsA("SpotLight") or o:IsA("SurfaceLight")) then
  o.Enabled = false
 end
end)

--==================================================
-- PING TAB
--==================================================
local PingTab = Window:MakeTab({
 Title = "Ping",
 Icon = "Signal"
})

local CheckPing = false
local SavedMaterials = {}

PingTab:AddToggle({
 Name = "Check Ping Server",
 Default = false,
 Callback = function(v)
  CheckPing = v
  task.spawn(function()
   while CheckPing do
    local ping = math.floor(
     Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    )

    if ping <= 29 then
     Window:Notify({Title="🟢 Ping ótimo",Content=ping.." ms",Duration=3})
    elseif ping >= 200 then
     Window:Notify({
      Title="🔴 Lag pesado",
      Content="Ative anti lag e remover texturas",
      Duration=4
     })
    elseif ping >= 100 then
     Window:Notify({
      Title="🟡 Ping estranho",
      Content=ping.." ms",
      Duration=3
     })
    end
    task.wait(5)
   end
  end)
 end
})

PingTab:AddToggle({
 Name = "Remover Texturas",
 Default = false,
 Callback = function(v)
  if v then
   for _,p in pairs(workspace:GetDescendants()) do
    if p:IsA("BasePart") then
     SavedMaterials[p] = p.Material
     p.Material = Enum.Material.SmoothPlastic
    end
   end
  else
   for p,m in pairs(SavedMaterials) do
    if p then p.Material = m end
   end
  end
 end
})

--==================================================
-- DISCORD TAB
--==================================================
local DiscordTab = Window:MakeTab({
 Title = "Discord",
 Icon = "Discord"
})

DiscordTab:AddDiscordInvite({
 Title = "redz Hub | Community",
 Description = "A community for redz Hub Users -- official scripts, updates, and suport in one place.",
 Banner = "rbxassetid://17382040552",
 Logo = "rbxassetid://17382040552",
 Invite = "https://discord.gg/redz-hub",
 Members = 470000,
 Online = 20000
})
