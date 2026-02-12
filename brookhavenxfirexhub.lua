local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "XfireX HUB (BETA)",
    SubTitle = "by fiat",
    TabWidth = 160,
    Size = UDim2.fromOffset(490, 390),
    Acrylic = true,
    Theme = "Darker",
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
local SoccerModel = nil
local AntiLag = false
local CheckPing = false
local SavedMaterials = {}
local selectedAudioID = nil
local audioLoop = false
local fastLoop = false
local couchConnection = nil

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
        -- Equip SoccerBall tool
        for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
            if v.Name == "SoccerBall" then
                LocalPlayer.Character.Humanoid:EquipTool(v)
                break
            end
        end

        -- Simulate clicks
        for i = 1, 9 do
            mouse1click()
            task.wait(0.1)
        end

        -- Find Soccer part/model
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "Soccer" and (obj:IsA("BasePart") or obj:IsA("Model")) then
                SoccerModel = obj
                break
            end
        end

        if SoccerModel then
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
                    if SoccerModel:IsA("BasePart") then
                        SoccerModel.CFrame = hrp.CFrame * CFrame.new(0, 0, -3)
                        SoccerModel.AssemblyAngularVelocity = Vector3.new(0, 9999, 0)
                    elseif SoccerModel:IsA("Model") then
                        SoccerModel:SetPrimaryPartCFrame(hrp.CFrame * CFrame.new(0, 0, -3))
                        SoccerModel.PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 9999, 0)
                    end
                end
            end)
        end
    else
        if FlingConnection then
            FlingConnection:Disconnect()
            FlingConnection = nil
        end
        SoccerModel = nil
    end
end)

-- Fling Sofa Button (NOVO)
Tabs.Main:AddButton({
    Title = "Fling Sofa",
    Description = "Clique para ativar o Fling Sofa",
    Callback = function()
        local targetPos = Vector3.new(-83, 20, -130)
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- Tween to target position
            local tween = TweenService:Create(
                hrp,
                TweenInfo.new(5, Enum.EasingStyle.Linear),
                {CFrame = CFrame.new(targetPos)}
            )
            tween:Play()
            
            tween.Completed:Wait()
            Fluent:Notify({
                Title = "Fling Sofa",
                Content = "Sente no sofá",
                Duration = 10
            })
            
            task.wait(12)
            
            -- Check for Couch tool
            local couchTool = LocalPlayer.Backpack:FindFirstChild("Couch") or LocalPlayer.Character:FindFirstChild("Couch")
            if couchTool then
                LocalPlayer.Character.Humanoid:EquipTool(couchTool)
                
                local targetPlayer = Players:FindFirstChild(SelectedPlayer)
                if targetPlayer and targetPlayer.Character then
                    couchConnection = RunService.Heartbeat:Connect(function()
                        local targetHrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if targetHrp then
                            hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, -3)
                            hrp.AssemblyAngularVelocity = Vector3.new(0, 9999, 0)
                            
                            -- Check for animation or sitting
                            local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid and (humanoid.Sit or humanoid:GetState() == Enum.HumanoidStateType.Seated) then
                                couchConnection:Disconnect()
                                couchConnection = nil
                                LocalPlayer.Character.Humanoid:UnequipTools()
                            end
                        end
                    end)
                end
            end
        end
    end
})

Tabs.Main:AddParagraph({
    Title = "Info",
    Content = "Fling Ball em BETA junto com o script"
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

local function PlayAudio(ID)
    if ID then
        pcall(function()
            ReplicatedStorage:FindFirstChild("1Gu1nSound1s", true):FireServer(Workspace, ID, 1)
        end)
    end
end

Tabs.Som:AddButton({
    Title = "Tocar Áudio",
    Description = "Tocar o áudio uma vez",
    Callback = function()
        PlayAudio(selectedAudioID)
    end
})

Options.AudioLoopToggle = Tabs.Som:AddToggle("AudioLoopToggle", {
    Title = "Loop Áudio",
    Default = false,
})

Options.AudioLoopToggle:OnChanged(function(Value)
    audioLoop = Value
    task.spawn(function()
        while audioLoop do
            PlayAudio(selectedAudioID)
            task.wait(1)
        end
    end)
end)

Options.FastLoopToggle = Tabs.Som:AddToggle("FastLoopToggle", {
    Title = "Loop Rápido (Spam)",
    Default = false,
})

Options.FastLoopToggle:OnChanged(function(Value)
    fastLoop = Value
    task.spawn(function()
        while fastLoop do
            PlayAudio(selectedAudioID)
            task.wait()
        end
    end)
end)

Tabs.Som:AddButton({
    Title = "Parar Tudo",
    Description = "Para todos os áudios",
    Callback = function()
        audioLoop = false
        fastLoop = false
        Options.AudioLoopToggle:SetValue(false)
        Options.FastLoopToggle:SetValue(false)
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
