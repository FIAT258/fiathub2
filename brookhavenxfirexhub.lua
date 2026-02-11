--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Verificação inicial
print("Script iniciado com sucesso!")

--// LIB
local success, Library = pcall(function()
 return loadstring(game:HttpGet(
  "https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"
 ))()
end)

if not success or not Library then
 warn("Erro ao carregar a Library! Verifique o link.")
 return
end

print("Library carregada com sucesso!")

Library:SetUIScale(2.0)

--// WINDOW
local Window = Library:MakeWindow({
 Title = "XfireX HUB (BETA)",
 SubTitle = "by fiat",
 ScriptFolder = "FiatHub"
})

if not Window then
 warn("Erro ao criar a janela!")
 return
end

print("Janela criada com sucesso!")

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

-- Ícones IDs
local ICONS = {
    Home = 10723407389,          -- home
    Tools = 10723405360,         -- hammer
    Ping = 10734961133,          -- signal
    Discord = 10734930886,       -- puzzle
    Roubado = 10734966248,       -- star
    Som = 10734905958,           -- music
    Config = 10709810948         -- cog
}

--==================================================
-- MAIN TAB
--==================================================
local MainTab = Window:MakeTab({
 Title = "Main",
 Icon = ICONS.Home
})

if not MainTab then
 warn("Erro ao criar a aba Main!")
 return
end

print("Aba Main criada com sucesso!")

local SelectedPlayer = nil
local ViewConnection = nil
local FlingConnection = nil
local SoccerModel = nil
local CameraOffset = Vector3.new(0, 3, 15) -- Distância maior da câmera
local CameraAngle = 0

local PlayerDropdown = MainTab:AddDropdown({
 Name = "Select Player",
 Options = GetPlayers(),
 Callback = function(v)
  SelectedPlayer = v
  print("Player selecionado:", v)
 end
})

MainTab:AddButton({
 Name = "Refresh Player",
 Callback = function()
  PlayerDropdown:Set(GetPlayers())
  print("Lista de players atualizada!")
 end
})

-- VIEW PLAYER (ATUALIZADO)
MainTab:AddToggle({
 Name = "View Player",
 Default = false,
 Callback = function(Value)
  if Value then
   print("View Player ativado!")
   -- Conexão para girar a câmera com o mouse
   local InputConnection
   InputConnection = UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
     CameraAngle = CameraAngle + input.Delta.X * 0.01
    end
   end)

   ViewConnection = RunService.RenderStepped:Connect(function()
    local p = Players:FindFirstChild(SelectedPlayer or "")
    if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
     Camera.CameraType = Enum.CameraType.Scriptable
     
     -- Calcular posição da câmera com rotação
     local offset = CFrame.Angles(0, CameraAngle, 0) * CameraOffset
     Camera.CFrame = CFrame.lookAt(
      p.Character.HumanoidRootPart.Position + offset,
      p.Character.HumanoidRootPart.Position
     )
    end
   end)
  else
   if ViewConnection then 
    ViewConnection:Disconnect() 
    ViewConnection = nil
   end
   Camera.CameraType = Enum.CameraType.Custom
   CameraAngle = 0
   print("View Player desativado!")
  end
 end
})

-- ... (restante do script permanece igual)
