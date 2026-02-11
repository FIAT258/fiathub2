--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

--// LIB
local Library = loadstring(game:HttpGet(
 "https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"
))()

Library:SetUIScale(2.0)

--// WINDOW
local Window = Library:MakeWindow({
 Title = "XfireX HUB (BETA)",
 SubTitle = "by fiat",
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
 Callback = func(Value)
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
 Icon = "Hammer"
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

ToolsTab:AddParagraph(
 "Info",
 "aba funcionando em breve"
)

--==================================================
-- PING TAB
--==================================================
local PingTab = Window:MakeTab({
 Title = "Ping",
 Icon = "Signal"
})

local AntiLag = false

PingTab:AddToggle({
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
 Title = "XfireX HUB",
 Description = "gg ez.",
 Banner = "rbxassetid://82224027035247",
 Logo = "rbxassetid://84973708912590",
 Invite = "https://discord.gg/VrFBWxJEp5",
 Members = 67,
 Online = 67
})

--==================================================
-- ROUBADO TAB
--==================================================
local RoubadoTab = Window:MakeTab({
 Title = "Roubado",
 Icon = "Star"
})

local playerDropdownRoubado = RoubadoTab:AddDropdown({
 Name = "Select Player",
 Options = GetPlayers(),
 Callback = function(v)
  SelectedPlayer = v
 end
})

Players.PlayerAdded:Connect(function(player)
 playerDropdownRoubado:Set(GetPlayers())
end)

Players.PlayerRemoving:Connect(function(player)
 playerDropdownRoubado:Set(GetPlayers())
end)

RoubadoTab:AddToggle({
 Name = "Bug Player FE",
 Default = false,
 Callback = function(Value)
  if Value then
   Window:Notify({
    Title = "Bug Player FE",
    Content = "Ponha um ônibus para melhorar",
    Duration = 4
   })
   
   local player = Players:FindFirstChild(SelectedPlayer)
   if player and player.Character then
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
     hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -130)
     task.wait(2)
     
     for _, obj in ipairs(workspace:GetDescendants()) do
      if obj.Name == "VehicleSeat" and (obj.Position - hrp.Position).Magnitude <= 40 then
       hrp.CFrame = obj.CFrame
       break
      end
     end
     
     -- Magnetismo
     local RAIO = 120
     local VELOCIDADE_ROT = 6
     local originais = {}
     
     RunService.RenderStepped:Connect(function()
      if not player or not player.Character then return end
      local hrp = player.Character:FindFirstChild("HumanoidRootPart")
      if not hrp then return end
      
      for _, obj in ipairs(workspace:GetDescendants()) do
       if obj:IsA("BasePart")
        and not obj.Anchored
        and not obj:IsDescendantOf(player.Character) then
        
        local dist = (obj.Position - hrp.Position).Magnitude
        if dist <= RAIO then
         if not originais[obj] then
          originais[obj] = obj.CFrame
         end
         
         local ang = os.clock() * VELOCIDADE_ROT
         obj.AssemblyLinearVelocity = Vector3.zero
         obj.CFrame = hrp.CFrame * CFrame.Angles(ang, ang * 0.7, ang * 1.1)
        end
       end
      end
     end)
    end
   end
  end
 end
})

--==================================================
-- SOM TAB
--==================================================
local SomTab = Window:MakeTab({
 Title = "Som",
 Icon = "Music"
})

local selectedAudioID = nil
local audioLoop = false
local fastLoop = false

local function PlayAudio(ID)
 if ID then
  pcall(function()
   ReplicatedStorage:FindFirstChild("1Gu1nSound1s", true)
    :FireServer(Workspace, ID, 1)
  end)
 end
end

SomTab:AddTextBox({
 Name = "Coloque o ID do áudio",
 Default = "",
 Placeholder = "Digite o ID aqui...",
 ClearOnFocus = true,
 Callback = function(Value)
  selectedAudioID = tonumber(Value)
 end
})

SomTab:AddButton({
 Name = "Tocar Áudio",
 Debounce = 0.5,
 Callback = function()
  PlayAudio(selectedAudioID)
 end
})

SomTab:AddToggle({
 Name = "Loop Áudio",
 Default = false,
 Callback = function(Value)
  audioLoop = Value
  task.spawn(function()
   while audioLoop do
    PlayAudio(selectedAudioID)
    task.wait(1)
   end
  end)
 end
})

SomTab:AddToggle({
 Name = "Loop Rápido (Spam)",
 Default = false,
 Callback = function(Value)
  fastLoop = Value
  task.spawn(function()
   while fastLoop do
    PlayAudio(selectedAudioID)
    task.wait()
   end
  end)
 end
})

SomTab:AddButton({
 Name = "Parar Tudo",
 Debounce = 0.5,
 Callback = function()
  audioLoop = false
  fastLoop = false
 end
})

SomTab:AddParagraph(
 "Info",
 "Controle de áudio completo"
)

RoubadoTab:AddParagraph(
 "Info",
 "Usse ônibus ele não serve pra dar fling serve pra travar e lagar o player. Ele tipo vai dar mini fling e vai puxar o player na mesma tempo. Player vai tar normal mais vai tar travando muito, as vezes buga mais está em beta vou melhorar depois"
)

print("Script carregado com sucesso!")
