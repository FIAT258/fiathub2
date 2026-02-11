--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

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

-- Minimizer (opcional)
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

-- Dropdown para selecionar jogador
local PlayerDropdown = MainTab:AddDropdown({
 Name = "Select Player",
 Options = GetPlayers(),
 Callback = function(v)
  SelectedPlayer = v
  print("Player selecionado:", v)
 end
})

-- Botão para atualizar lista de jogadores
MainTab:AddButton({
 Name = "Refresh Player",
 Callback = function()
  PlayerDropdown:Set(GetPlayers())
  print("Lista de players atualizada!")
 end
})

-- Toggle para visualizar jogador
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

-- Toggle para Fling Ball
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

-- Parágrafo informativo
MainTab:AddParagraph(
 "Info",
 "Fling Ball em BETA junto com o script"
)

--==================================================
-- TOOLS TAB
--==================================================
local ToolsTab = Window:MakeTab({
 Title = "Tools",
 Icon = ICONS.Tools
})

-- Botão para criar Teleport Tool
ToolsTab:AddButton({
 Name = "Teleport Tool",
 Callback = function()
  -- Verificar se já existe a ferramenta
  local existingTool = LocalPlayer.Backpack:FindFirstChild("Teleport Tool") or 
                      LocalPlayer.Character:FindFirstChild("Teleport Tool")
  
  if existingTool then
   Window:Notify({
    Title = "Info",
    Content = "Você já tem a Teleport Tool!",
    Duration = 3
   })
   return
  end

  -- Criar a ferramenta
  local Tool = Instance.new("Tool")
  Tool.Name = "Teleport Tool"
  Tool.Parent = LocalPlayer.Backpack
  Tool.ToolTip = "Clique para teleportar"
  
  -- Ícone da ferramenta (opcional)
  Tool.TextureId = "rbxassetid://7072706620" -- Ícone de teleporte

  Tool.Activated:Connect(function()
   local character = LocalPlayer.Character
   if not character then return end
   
   local humanoid = character:FindFirstChildOfClass("Humanoid")
   if not humanoid then return end
   
   local hrp = character:FindFirstChild("HumanoidRootPart")
   if not hrp then return end
   
   local mouse = LocalPlayer:GetMouse()
   if mouse.Target then
    -- Teleportar para a posição do mouse
    local targetPos = mouse.Hit.Position
    local offset = Vector3.new(0, humanoid.HipHeight + (hrp.Size.Y/2), 0)
    
    hrp.CFrame = CFrame.new(targetPos + offset)
    
    Window:Notify({
     Title = "Teleport",
     Content = "Teleportado com sucesso!",
     Duration = 2
    })
   end
  end)
  
  -- Equipar automaticamente
  if LocalPlayer.Character then
   Tool.Parent = LocalPlayer.Character
  end
  
  Window:Notify({
   Title = "Sucesso",
   Content = "Teleport Tool adicionada ao seu inventário!",
   Duration = 4
  })
 end
})

-- Botão para selecionar jogador
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

-- Dropdown para selecionar ferramentas do jogo
local ToolDropdown = ToolsTab:AddDropdown({
 Name = "Tools do Jogo",
 Options = {}
})

-- Botão para atualizar lista de ferramentas
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

-- Botão para pegar ferramenta
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

-- Parágrafo informativo
ToolsTab:AddParagraph(
 "Info",
 "Aba Tools funcionando em breve"
)

--==================================================
-- PING TAB
--==================================================
local PingTab = Window:MakeTab({
 Title = "Ping",
 Icon = ICONS.Ping
})

-- Slider para ajustar ping
PingTab:AddSlider({
 Name = "Ajustar Ping",
 Min = 0,
 Max = 1000,
 Default = 0,
 Callback = function(Value)
  Stats.Network.ServerStatsItem["Data Ping"]:SetValue(Value)
 end
})

-- Parágrafo informativo
PingTab:AddParagraph(
 "Info",
 "Ajuste seu ping para valores mais baixos."
)

--==================================================
-- DISCORD TAB
--==================================================
local DiscordTab = Window:MakeTab({
 Title = "Discord",
 Icon = ICONS.Discord
})

-- Botão para copiar link do Discord
DiscordTab:AddButton({
 Name = "Copiar Link do Discord",
 Callback = function()
  setclipboard("https://discord.gg/xxxxxx")
  Window:Notify({
   Title = "Discord",
   Content = "Link copiado!",
   Duration = 3
  })
 end
})

-- Parágrafo informativo
DiscordTab:AddParagraph(
 "Info",
 "Entre no nosso Discord para mais scripts!"
)

--==================================================
-- ROUBADO TAB
--==================================================
local RoubadoTab = Window:MakeTab({
 Title = "Roubado",
 Icon = ICONS.Roubado
})

-- Botão para ativar script roubado
RoubadoTab:AddButton({
 Name = "Ativar Script Roubado",
 Callback = function()
  Window:Notify({
   Title = "Roubado",
   Content = "Script roubado ativado!",
   Duration = 3
  })
 end
})

-- Parágrafo informativo
RoubadoTab:AddParagraph(
 "Info",
 "Scripts roubados podem não funcionar corretamente."
)

--==================================================
-- SOM TAB
--==================================================
local SomTab = Window:MakeTab({
 Title = "Som",
 Icon = ICONS.Som
})

-- Slider para ajustar volume
SomTab:AddSlider({
 Name = "Ajustar Volume",
 Min = 0,
 Max = 100,
 Default = 50,
 Callback = function(Value)
  game:GetService("SoundService").AmbientVolume = Value
 end
})

-- Parágrafo informativo
SomTab:AddParagraph(
 "Info",
 "Ajuste o volume do jogo."
)

--==================================================
-- CONFIG TAB
--==================================================
local ConfigTab = Window:MakeTab({
 Title = "Config",
 Icon = ICONS.Config
})

-- Botão para salvar configurações
ConfigTab:AddButton({
 Name = "Salvar Configurações",
 Callback = function()
  Window:Notify({
   Title = "Configurações",
   Content = "Configurações salvas com sucesso!",
   Duration = 3
  })
 end
})

-- Parágrafo informativo
ConfigTab:AddParagraph(
 "Info",
 "Configure suas preferências aqui."
)

--==================================================
-- FINALIZAÇÃO
--==================================================
print("Script carregado com sucesso!")
