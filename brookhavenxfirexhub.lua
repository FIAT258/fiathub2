--// REDZ V5 REMAKE - UPDATE GRANDE
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Library = loadstring(game:HttpGet(
 "https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"
))()

local Window = Library:MakeWindow({
 Title = "Fiat Hub",
 SubTitle = "Update Grande",
 ScriptFolder = "FiatHub"
})

local Minimizer = Window:NewMinimizer({
 KeyCode = Enum.KeyCode.LeftControl
})

-- ================= PLAYERS =================
local function getPlayers()
 local t = {}
 for _,p in pairs(Players:GetPlayers()) do
  if p ~= LocalPlayer then table.insert(t,p.Name) end
 end
 return t
end

-- ================= MAIN =================
local Main = Window:MakeTab({Name="Main"})
local SelectedPlayer
local ViewConn
local FlingConn
local SoccerModel

local PlayerDrop = Main:AddDropdown({
 Name="Select Player",
 Options=getPlayers(),
 Callback=function(v) SelectedPlayer=v end
})

Main:AddButton({
 Name="Refresh Player",
 Callback=function() PlayerDrop:Set(getPlayers()) end
})

Main:AddSwitch({
 Name="View Player",
 Default=false,
 Callback=function(v)
  if v then
   ViewConn = RunService.RenderStepped:Connect(function()
    local p = Players:FindFirstChild(SelectedPlayer or "")
    if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
     Camera.CameraType = Enum.CameraType.Scriptable
     Camera.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0,3,10)
    end
   end)
  else
   if ViewConn then ViewConn:Disconnect() end
   Camera.CameraType = Enum.CameraType.Custom
  end
 end
})

Main:AddSwitch({
 Name="Fling Ball (BETA)",
 Default=false,
 Callback=function(v)
  if v then
   -- pegar SoccerBall
   for _,t in pairs(workspace:GetDescendants()) do
    if t:IsA("Tool") and t.Name=="SoccerBall" then
     t.Parent=LocalPlayer.Backpack
    end
   end

   local tool = LocalPlayer.Backpack:FindFirstChild("SoccerBall")
   if tool then
    LocalPlayer.Character.Humanoid:EquipTool(tool)
    for i=1,9 do
     mouse1click()
    end
   end

   -- achar model Soccer
   for _,m in pairs(workspace:GetDescendants()) do
    if m:IsA("Model") and m.Name=="Soccer" then
     SoccerModel=m
    end
   end

   FlingConn = RunService.Heartbeat:Connect(function()
    local p = Players:FindFirstChild(SelectedPlayer or "")
    if not p then
     Library:Notify({Title="Info",Description="Player saiu do jogo",Time=4})
     if FlingConn then FlingConn:Disconnect() end
     return
    end

    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and SoccerModel and SoccerModel.PrimaryPart then
     local hrp = p.Character.HumanoidRootPart
     SoccerModel:SetPrimaryPartCFrame(
      CFrame.new(hrp.Position + (hrp.CFrame.LookVector * 2))
     )
     SoccerModel.PrimaryPart.AssemblyAngularVelocity = Vector3.new(0,9999,0)
    end
   end)
  else
   if FlingConn then FlingConn:Disconnect() end
  end
 end
})

Main:AddParagraph({
 Title="Info",
 Content="Fling Ball em BETA junto com o script"
})

-- ================= TOOLS =================
local Tools = Window:MakeTab({Name="Tools",Icon="🪓"})

Tools:AddButton({
 Name="TP Tool",
 Callback=function()
  local Tool = Instance.new("Tool",LocalPlayer.Backpack)
  Tool.Name="TP Tool"
  Tool.Activated:Connect(function()
   local mouse = LocalPlayer:GetMouse()
   if mouse.Hit then
    LocalPlayer.Character.HumanoidRootPart.CFrame = mouse.Hit
   end
  end)
 end
})

Tools:AddButton({
 Name="Select Tool Player",
 Callback=function()
  local mouse = LocalPlayer:GetMouse()
  mouse.Button1Down:Wait()
  if mouse.Target then
   local p = Players:GetPlayerFromCharacter(mouse.Target.Parent)
   if p then
    Library:Notify({Title="Player",Description=p.Name,Time=3})
   end
  end
 end
})

local ToolDrop = Tools:AddDropdown({
 Name="Tools do Jogo",
 Options={}
})

Tools:AddButton({
 Name="Refresh Tools",
 Callback=function()
  local t={}
  for _,v in pairs(workspace:GetDescendants()) do
   if v:IsA("Tool") then table.insert(t,v.Name) end
  end
  ToolDrop:Set(t)
 end
})

Tools:AddButton({
 Name="Get Tool",
 Callback=function()
  local name = ToolDrop.Value
  for _,v in pairs(workspace:GetDescendants()) do
   if v:IsA("Tool") and v.Name==name then
    v.Parent=LocalPlayer.Backpack
   end
  end
 end
})

-- ================= CONFIG =================
local Config = Window:MakeTab({Name="Config"})
local AntiLag=false

Config:AddSwitch({
 Name="Anti Lag",
 Default=false,
 Callback=function(v) AntiLag=v end
})

workspace.DescendantAdded:Connect(function(o)
 if AntiLag and (o:IsA("PointLight") or o:IsA("SurfaceLight") or o:IsA("SpotLight")) then
  o.Enabled=false
 end
end)

-- ================= PING =================
local Ping = Window:MakeTab({Name="Ping"})
local CheckPing=false
local SavedTextures={}

Ping:AddSwitch({
 Name="Check Ping Server",
 Default=false,
 Callback=function(v)
  CheckPing=v
  task.spawn(function()
   while CheckPing do
    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    if ping<=29 then
     Library:Notify({Title="🟢 Ping ótimo",Description=ping.." ms",Time=2})
    elseif ping>=200 then
     Library:Notify({Title="🔴 Lag pesado",Description="Ative anti lag e remover texturas",Time=4})
    elseif ping>=100 then
     Library:Notify({Title="🟡 Ping estranho",Description=ping.." ms",Time=3})
    end
    task.wait(5)
   end
  end)
 end
})

Ping:AddSwitch({
 Name="Remover Texturas",
 Default=false,
 Callback=function(v)
  if v then
   for _,p in pairs(workspace:GetDescendants()) do
    if p:IsA("BasePart") then
     SavedTextures[p]=p.Material
     p.Material=Enum.Material.SmoothPlastic
    end
   end
  else
   for p,m in pairs(SavedTextures) do
    if p then p.Material=m end
   end
  end
 end
})
