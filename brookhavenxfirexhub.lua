-- Carrega as bibliotecas necessárias
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Fluent, SaveManager, InterfaceManager = loadstring(Game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/Beta.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Cria a janela principal
local Window = Fluent:CreateWindow({
    Title = "XfireX HUB (BETA)",
    SubTitle = "by fiat",
    TabWidth = 160,
    Size = UDim2.fromOffset(469, 446),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Tools = Window:AddTab({ Title = "Tools", Icon = "hammer" }),
    Lag = Window:AddTab({ Title = "Lag Bomb", Icon = "bomb" }),
    Ping = Window:AddTab({ Title = "Ping", Icon = "signal" }),
    Roubado = Window:AddTab({ Title = "Roubado", Icon = "star" }),
    Som = Window:AddTab({ Title = "Som", Icon = "music" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Variables
local SelectedPlayer = nil
local ViewConnection = nil
local FlingConnection = nil
local SoccerBallConnection = nil
local AntiLag = false
local CheckPing = false
local SavedMaterials = {}
local selectedAudioID = nil
local audioLoop = false
local fastLoop = false
local couchConnection = nil
local bombCount = 0
local bombSpeed = 1

-- Player list management
local function GetPlayers()
    local t = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(t, p.Name)
        end
    end
    return t
end

-- Update player lists when players join/leave
Players.PlayerAdded:Connect(function()
    Options.PlayerDropdown:SetValues(GetPlayers())
    Options.PlayerDropdownRoubado:SetValues(GetPlayers())
end)

Players.PlayerRemoving:Connect(function()
    Options.PlayerDropdown:SetValues(GetPlayers())
    Options.PlayerDropdownRoubado:SetValues(GetPlayers())
end)

-- Main Tab
Tabs.Main:AddParagraph({
    Title = "XfireX HUB",
    Content = "Bem-vindo ao hub de scripts!"
})

-- Player Dropdown
Options.PlayerDropdown = Tabs.Main:AddDropdown("PlayerDropdown", {
    Title = "Select Player",
    Values = GetPlayers(),
    Multi = false,
    Default = nil,
})

Options.PlayerDropdown:OnChanged(function(Value)
    SelectedPlayer = Value
end)

Tabs.Main:AddButton({
    Title = "Refresh Player",
    Description = "Atualiza a lista de jogadores",
    Callback = function()
        Options.PlayerDropdown:SetValues(GetPlayers())
    end
})

-- View Player Toggle
Options.ViewPlayerToggle = Tabs.Main:AddToggle("ViewPlayerToggle", {
    Title = "View Player",
    Default = false,
})

Options.ViewPlayerToggle:OnChanged(function(Value)
    if Value then
        ViewConnection = RunService.RenderStepped:Connect(function()
            local p = Players:FindFirstChild(SelectedPlayer or "")
            if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                Camera.CameraType = Enum.CameraType.Scriptable
                Camera.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 10)
            end
        end)
    else
        if ViewConnection then ViewConnection:Disconnect() end
        Camera.CameraType = Enum.CameraType.Custom
    end
end)

-- Fling Ball Toggle (ATUALIZADO)
Options.FlingBallToggle = Tabs.Main:AddToggle("FlingBallToggle", {
    Title = "Fling Ball (BETA)",
    Default = false,
})

Options.FlingBallToggle:OnChanged(function(Value)
    if Value then
        -- Executa o código para pegar a SoccerBall
        local args = {
            "PickingTools",
            "SoccerBall"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Too1l"):InvokeServer(unpack(args))
        
        -- Espera a tool ser equipada
        task.wait(1)
        
        -- Simula 4 cliques
        for i = 1, 4 do
            mouse1click()
            task.wait(0.1)
        end
        
        -- Inicia o magnetismo
        FlingConnection = RunService.Heartbeat:Connect(function()
            local p = Players:FindFirstChild(SelectedPlayer or "")
            if not p then
                Fluent:Notify({
                    Title = "Info",
                    Content = "Player saiu do jogo",
                    Duration = 4
                })
                Options.FlingBallToggle:SetValue(false)
                return
            end

            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local args = {
                    CFrame.new(hrp.Position.X, hrp.Position.Y, hrp.Position.Z, -0.4177906811237335, -8.8745466086948e-08, 0.9085432887077332, -6.263014284968449e-08, 1, 6.887857750825788e-08, -0.9085432887077332, -2.812536870067106e-08, -0.4177906811237335)
                }
                
                if LocalPlayer.Character:FindFirstChild("SoccerBall") then
                    LocalPlayer.Character:WaitForChild("SoccerBall"):WaitForChild("FootballInteraction"):FireServer(unpack(args))
                end
            end
        end)
        
        -- Desativa após 23 segundos
        task.wait(23)
        Options.FlingBallToggle:SetValue(false)
    else
        if FlingConnection then
            FlingConnection:Disconnect()
            FlingConnection = nil
        end
    end
end)

-- Fling Sofa Button (NOVO E ATUALIZADO)
Tabs.Main:AddButton({
    Title = "Fling Sofa",
    Description = "Clique para ativar o Fling Sofa",
    Callback = function()
        -- Executa o código para pegar o Couch
        local args = {
            "PickingTools",
            "Couch"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Too1l"):InvokeServer(unpack(args))
        
        -- Espera a tool ser equipada
        task.wait(1)
        
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local targetPlayer = Players:FindFirstChild(SelectedPlayer)
            if targetPlayer and targetPlayer.Character then
                local timeout = 14
                local startTime = os.time()
                
                couchConnection = RunService.Heartbeat:Connect(function()
                    local targetHrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetHrp then
                        -- Magnetismo: Segue o jogador selecionado no tronco
                        hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 0)
                        
                        -- Gira o jogador principal em todas as direções no próprio eixo
                        hrp.AssemblyAngularVelocity = Vector3.new(99999, 99999, 99999)
                        
                        -- Verifica si el jugador hizo animación o se sentó
                        local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid and (humanoid.Sit or humanoid:GetState() == Enum.HumanoidStateType.Seated) then
                            -- Remove a ferramenta da mão primeiro
                            LocalPlayer.Character.Humanoid:UnequipTools()
                            
                            -- Desliga tudo
                            couchConnection:Disconnect()
                            couchConnection = nil
                            hrp.AssemblyAngularVelocity = Vector3.zero
                        end
                        
                        -- Timeout após 14 segundos
                        if os.time() - startTime >= timeout then
                            LocalPlayer.Character.Humanoid:UnequipTools()
                            couchConnection:Disconnect()
                            couchConnection = nil
                            hrp.AssemblyAngularVelocity = Vector3.zero
                        end
                    end
                end)
            end
        end
    end
})

Tabs.Main:AddParagraph({
    Title = "Info",
    Content = "Fling em BETA junto com o script"
})

-- Tools Tab
Tabs.Tools:AddParagraph({
    Title = "Tools",
    Content = "Aba funcionando em breve"
})

-- TP Tool
Tabs.Tools:AddButton({
    Title = "TP Tool",
    Description = "Cria uma ferramenta de teleporte",
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

-- Roubado Tab
Tabs.Roubado:AddParagraph({
    Title = "Roubado",
    Content = "Usse ônibus ele não serve pra dar fling serve pra travar e lagar o player. Ele tipo vai dar mini fling e vai puxar o player na mesma tempo. Player vai tar normal mais vai tar travando muito, as vezes buga mais está em beta vou melhorar depois"
})

-- Player Dropdown for Roubado
Options.PlayerDropdownRoubado = Tabs.Roubado:AddDropdown("PlayerDropdownRoubado", {
    Title = "Select Player",
    Values = GetPlayers(),
    Multi = false,
    Default = nil,
})

Options.PlayerDropdownRoubado:OnChanged(function(Value)
    SelectedPlayer = Value
end)

-- Bug Player FE Toggle
Options.BugPlayerToggle = Tabs.Roubado:AddToggle("BugPlayerToggle", {
    Title = "Bug Player FE",
    Default = false,
})

Options.BugPlayerToggle:OnChanged(function(Value)
    if Value then
        Fluent:Notify({
            Title = "Bug Player FE",
            Content = "Ponha um ônibus para melhorar",
            Duration = 5
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
                
                local magnetConnection
                magnetConnection = RunService.RenderStepped:Connect(function()
                    if not player or not player.Character then return end
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and not obj.Anchored and not obj:IsDescendantOf(player.Character) then
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
                
                -- Monitorar animação
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    local animator = humanoid:FindFirstChildOfClass("Animator")
                    if animator then
                        animator.AnimationPlayed:Connect(function()
                            if hrp then
                                hrp.CFrame = CFrame.new(hrp.Position.X, -5000, hrp.Position.Z)
                                task.delay(0.2, function()
                                    magnetConnection:Disconnect()
                                    Options.BugPlayerToggle:SetValue(false)
                                end)
                            end
                        end)
                    end
                end
            end
        end
    end
end)

-- Ping Tab
Options.AntiLagToggle = Tabs.Ping:AddToggle("AntiLagToggle", {
    Title = "Anti Lag",
    Default = false,
})

Options.AntiLagToggle:OnChanged(function(Value)
    AntiLag = Value
end)

workspace.DescendantAdded:Connect(function(o)
    if AntiLag and (o:IsA("PointLight") or o:IsA("SpotLight") or o:IsA("SurfaceLight")) then
        o.Enabled = false
    end
end)

Options.CheckPingToggle = Tabs.Ping:AddToggle("CheckPingToggle", {
    Title = "Check Ping Server",
    Default = false,
})

Options.CheckPingToggle:OnChanged(function(Value)
    CheckPing = Value
    task.spawn(function()
        while CheckPing do
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            
            if ping <= 29 then
                Fluent:Notify({ Title = "🟢 Ping ótimo", Content = ping.." ms", Duration = 3 })
            elseif ping >= 200 then
                Fluent:Notify({
                    Title = "🔴 Lag pesado",
                    Content = "Ative anti lag e remover texturas",
                    Duration = 4
                })
            elseif ping >= 100 then
                Fluent:Notify({
                    Title = "🟡 Ping estranho",
                    Content = ping.." ms",
                    Duration = 3
                })
            end
            task.wait(5)
        end
    end)
end)

Options.RemoveTexturesToggle = Tabs.Ping:AddToggle("RemoveTexturesToggle", {
    Title = "Remover Texturas",
    Default = false,
})

Options.RemoveTexturesToggle:OnChanged(function(Value)
    if Value then
        for _, p in pairs(workspace:GetDescendants()) do
            if p:IsA("BasePart") then
                SavedMaterials[p] = p.Material
                p.Material = Enum.Material.SmoothPlastic
            end
        end
    else
        for p, m in pairs(SavedMaterials) do
            if p then p.Material = m end
        end
    end
end)

-- Lag Bomb Tab (ATUALIZADO)
Tabs.Lag:AddParagraph({
    Title = "Lag Bomb (BETA)",
    Content = "Essa função está em beta e pode travar você e outros jogadores. Tenha cuidado!"
})

-- Bomb Speed Slider
Options.BombSpeedSlider = Tabs.Lag:AddSlider("BombSpeedSlider", {
    Title = "Velocidade de Repetição (segundos)",
    Description = "Ajuste o tempo de repetição",
    Default = 1,
    Min = 0.8,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        bombSpeed = Value
    end
})

-- Lag Bomb Toggle (ATUALIZADO)
Options.LagBombToggle = Tabs.Lag:AddToggle("LagBombToggle", {
    Title = "Ativar Lag Bomb",
    Default = false,
})

Options.LagBombToggle:OnChanged(function(Value)
    if Value then
        -- Conexão para executar o código e equipar as bombas
        local bombConnection
        bombConnection = RunService.Heartbeat:Connect(function()
            -- Executa o código para pegar a bomba
            local args = {
                "PickingTools",
                "Bomb"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Too1l"):InvokeServer(unpack(args))
            
            -- Equipa qualquer tool de nome "Bomb" que aparecer no inventário
            for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                if tool.Name == "Bomb" then
                    LocalPlayer.Character.Humanoid:EquipTool(tool)
                end
            end
            
            -- Aguarda o tempo definido no slider
            task.wait(bombSpeed)
        end)
    else
        -- Desativa tudo
        if bombConnection then bombConnection:Disconnect() end
    end
end)

-- Som Tab
Tabs.Som:AddInput("AudioIDInput", {
    Title = "Coloque o ID do áudio",
    Default = "",
    Placeholder = "Digite o ID aqui...",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        selectedAudioID = tonumber(Value)
    end
})

-- Play Audio Button
Tabs.Som:AddButton({
    Title = "Tocar Áudio",
    Description = "Tocar o áudio uma vez",
    Callback = function()
        if selectedAudioID then
            -- Equipa a arma primeiro
            local equipArgs = {
                "Assault",
                "StockAssault"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("GunEquip"):InvokeServer(unpack(equipArgs))
            
            task.wait(1)
            
            -- Executa o som
            local args = {
                workspace:WaitForChild("Model"):WaitForChild("Street"):WaitForChild("Street"),
                game:GetService("Players").LocalPlayer.Character:WaitForChild("Assault"):WaitForChild("Handle"),
                vector.create(0.20000000298023224, 0.30000001192092896, -2.5),
                vector.create(151.98477172851562, 0.024999618530273438, -74.1072998046875),
                game:GetService("Players").LocalPlayer.Character:WaitForChild("Assault"):WaitForChild("GunScript_Local"):WaitForChild("MuzzleEffect"),
                game:GetService("Players").LocalPlayer.Character:WaitForChild("Assault"):WaitForChild("GunScript_Local"):WaitForChild("HitEffect"),
                selectedAudioID,
                0,
                {
                    false
                },
                {
                    25,
                    vector.create(9, 9, 100999),
                    BrickColor.new(24),
                    0.25,
                    Enum.Material.SmoothPlastic,
                    9
                },
                true,
                false
            }
            game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Gu1n"):FireServer(unpack(args))
        end
    end
})

-- Play Audio All Button
Tabs.Som:AddButton({
    Title = "Tocar Áudio em Todos",
    Description = "Tocar o áudio em todos os players",
    Callback = function()
        if selectedAudioID then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    -- Equipa a arma primeiro
                    local equipArgs = {
                        "Assault",
                        "StockAssault"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("GunEquip"):InvokeServer(unpack(equipArgs))
                    
                    task.wait(0.5)
                    
                    -- Executa o som no player atual
                    local args = {
                        workspace:WaitForChild("Model"):WaitForChild("Street"):WaitForChild("Street"),
                        game:GetService("Players").LocalPlayer.Character:WaitForChild("Assault"):WaitForChild("Handle"),
                        vector.create(0.20000000298023224, 0.30000001192092896, -2.5),
                        vector.create(151.98477172851562, 0.024999618530273438, -74.1072998046875),
                        game:GetService("Players").LocalPlayer.Character:WaitForChild("Assault"):WaitForChild("GunScript_Local"):WaitForChild("MuzzleEffect"),
                        game:GetService("Players").LocalPlayer.Character:WaitForChild("Assault"):WaitForChild("GunScript_Local"):WaitForChild("HitEffect"),
                        selectedAudioID,
                        0,
                        {
                            false
                        },
                        {
                            25,
                            vector.create(9, 9, 100999),
                            BrickColor.new(24),
                            0.25,
                            Enum.Material.SmoothPlastic,
                            9
                        },
                        true,
                        false
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Gu1n"):FireServer(unpack(args))
                    
                    task.wait(5)
                end
            end
        end
    end
})

-- Settings Tab
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("XfireXHub")
SaveManager:SetFolder("XfireXHub/" .. game.PlaceId)
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Initialization
Window:SelectTab(1)
Fluent:Notify({
    Title = "XfireX HUB",
    Content = "O script foi carregado com sucesso!",
    Duration = 5
})
SaveManager:LoadAutoloadConfig()

-- Garante que a interface será exibida
Window:Show()
