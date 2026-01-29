--// FIAT HUB - UI MULTIFUNÇÃO V6.3 (Completo)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local humanoid
local originalSettings = {}
local connections = {}
local cursor

-- Tocar som ao iniciar
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://78267113234809"
sound.Volume = 1
sound.Parent = workspace
sound:Play()

-- Criando ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FiatHubUI"
ScreenGui.Parent = game:GetService("CoreGui")

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 550, 0, 600)
MainFrame.Position = UDim2.new(0.25, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.Text = "Dono: FIAT_GORDIN | ADM GAY: LORENZO_GORDIN"
title.Font = Enum.Font.Gotham -- fonte alterada por script, ID aplicado via FontId abaixo
title.TextSize = 20
title.FontFace = Font.new("rbxassetid://12187372175")
title.Parent = MainFrame

-- Botão X
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.Gotham
closeBtn.TextSize = 18
closeBtn.FontFace = Font.new("rbxassetid://12187372175")
closeBtn.Parent = MainFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Reabrir botão 🗿
local reopenBtn = Instance.new("ImageButton")
reopenBtn.Size = UDim2.new(0, 50, 0, 50)
reopenBtn.Position = UDim2.new(0, 20, 0.8, 0)
reopenBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
reopenBtn.Image = "rbxassetid://16377625995" -- imagem do quadrado
reopenBtn.Visible = false
reopenBtn.Active = true
reopenBtn.Draggable = true
reopenBtn.Parent = ScreenGui
Instance.new("UICorner", reopenBtn).CornerRadius = UDim.new(0, 8)
local stroke = Instance.new("UIStroke", reopenBtn)
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(0, 120, 255)

-- Scroll
local Scrolling = Instance.new("ScrollingFrame")
Scrolling.Size = UDim2.new(1, -20, 1, -60)
Scrolling.Position = UDim2.new(0, 10, 0, 50)
Scrolling.CanvasSize = UDim2.new(0,0,6,0)
Scrolling.ScrollBarThickness = 6
Scrolling.BackgroundTransparency = 1
Scrolling.Parent = MainFrame

-- Criador de Botões
local function criarBotao(nome, ordem)
    local botao = Instance.new("TextButton")
    botao.Size = UDim2.new(1, -10, 0, 35)
    botao.Position = UDim2.new(0, 5, 0, ordem * 40)
    botao.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
    botao.TextColor3 = Color3.fromRGB(255, 255, 255)
    botao.Text = nome
    botao.Font = Enum.Font.Gotham
    botao.FontFace = Font.new("rbxassetid://12187372175")
    botao.TextSize = 16
    botao.Parent = Scrolling
    Instance.new("UICorner", botao).CornerRadius = UDim.new(0, 6)
    return botao
end

-- BOTÕES
local btnAntiLag = criarBotao("Anti-Lag (Invisível)", 0)
local btnReverter = criarBotao("Reverter Mapa", 1)
local btnMouseFake = criarBotao("Mouse Fake", 2)
local btnTirarMouse = criarBotao("Tirar Mouse", 3)
local btnTravAnim = criarBotao("Travar Animação", 4)
local btnVoltarAnim = criarBotao("Voltar Animação", 5)
local btnBuracoNegro = criarBotao("Buraco Negro", 6)
local btnFling = criarBotao("Fling", 7)
local btnAimbot = criarBotao("AimBot", 8)
local btnParar = criarBotao("Parar Tudo", 9)
local btnFly = criarBotao("Fly", 10)
local btnPararFly = criarBotao("Parar Fly", 11)
local btnTeleportTool = criarBotao("Teleport Tool", 12)
local btnEspiao = criarBotao("Espião", 13)
local btnPararEspiao = criarBotao("Parar Espião", 14)
local btnBoombox = criarBotao("Boombox", 15)
local btnLanterna = criarBotao("Lanterna", 16)
local btnEquipAll = criarBotao("Equip All Tools", 17)
local btnSpeedHack = criarBotao("Speed Hack", 18)
local btnGodMode = criarBotao("God Mode", 19)
local btnKaitun = criarBotao("Kaitun", 20)
local btnDiminuirUI = criarBotao("Diminuir/Voltar UI", 21)
local btnDesligarUI = criarBotao("Desligar UI", 22)
local btnShowCoord = criarBotao("Mostrar Coordenadas", 23)
local btnFastAttack = criarBotao("HoHo Hub Fast Attack", 24)
local btnStopFastAttack = criarBotao("Parar Fast Attack", 25)

-- FECHAR/ABRIR UI
closeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    reopenBtn.Visible = true
end)
reopenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    reopenBtn.Visible = false
end)

-- DIMINUIR / VOLTAR UI
local uiMinimized = false
local originalSize = MainFrame.Size
local originalPos = MainFrame.Position
btnDiminuirUI.MouseButton1Click:Connect(function()
    if not uiMinimized then
        MainFrame.Size = UDim2.new(0, 300, 0, 350)
        MainFrame.Position = UDim2.new(0.35, 0, 0.2, 0)
        uiMinimized = true
    else
        MainFrame.Size = originalSize
        MainFrame.Position = originalPos
        uiMinimized = false
    end
end)

-- FUNÇÕES ANTIGAS (Todas)
btnAntiLag.MouseButton1Click:Connect(function()
    originalSettings.shadows = game.Lighting.GlobalShadows
    originalSettings.fog = game.Lighting.FogEnd
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    game.Lighting.GlobalShadows = false
    game.Lighting.FogEnd = 9e9
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            v.Transparency = 1
        end
    end
end)

btnReverter.MouseButton1Click:Connect(function()
    game.Lighting.GlobalShadows = originalSettings.shadows or true
    game.Lighting.FogEnd = originalSettings.fog or 1000
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then v.Transparency = 0
        elseif v:IsA("Decal") then v.Transparency = 0 end
    end
end)

btnMouseFake.MouseButton1Click:Connect(function()
    if not cursor then
        cursor = Instance.new("ImageLabel")
        cursor.Size = UDim2.new(0, 30, 0, 30)
        cursor.BackgroundTransparency = 1
        cursor.Image = "rbxassetid://7072718362"
        cursor.Position = UDim2.new(0.5, -15, 0.5, -15)
        cursor.Active = true
        cursor.Draggable = true
        cursor.Parent = ScreenGui
        connections["mouseClick"] = UserInputService.InputBegan:Connect(function(input, gpe)
            if not gpe and cursor and cursor.Visible then
                print("Clique fake em: ", cursor.Position)
            end
        end)
    end
    cursor.Visible = true
end)

btnTirarMouse.MouseButton1Click:Connect(function()
    if cursor then cursor.Visible = false end
end)

btnTravAnim.MouseButton1Click:Connect(function()
    if player.Character then
        humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid:FindFirstChild("Animator") then
            for _, track in pairs(humanoid.Animator:GetPlayingAnimationTracks()) do
                track:AdjustSpeed(0)
            end
        end
    end
end)

btnVoltarAnim.MouseButton1Click:Connect(function()
    if humanoid and humanoid:FindFirstChild("Animator") then
        for _, track in pairs(humanoid.Animator:GetPlayingAnimationTracks()) do
            track:AdjustSpeed(1)
        end
    end
end)

btnBuracoNegro.MouseButton1Click:Connect(function()
    if connections["blackhole"] then return end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    connections["blackhole"] = RunService.Heartbeat:Connect(function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Anchored and v ~= hrp then
                local dir = (hrp.Position - v.Position).Unit
                v.Velocity = dir * 100
            end
        end
    end)
end)

btnFling.MouseButton1Click:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local target = plr.Character.HumanoidRootPart
            local bv = Instance.new("BodyVelocity")
            bv.Velocity = (target.Position - hrp.Position).Unit * 200
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.Parent = target
            game.Debris:AddItem(bv, 0.2)
        end
    end
end)

btnAimbot.MouseButton1Click:Connect(function()
    if connections["aimbot"] then return end
    local camera = workspace.CurrentCamera
    connections["aimbot"] = RunService.RenderStepped:Connect(function()
        local nearest, dist = nil, math.huge
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
                local head = plr.Character.Head
                local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                local mag = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if onScreen and mag < dist then
                    dist = mag
                    nearest = head
                end
            end
        end
        if nearest then
            camera.CFrame = CFrame.new(camera.CFrame.Position, nearest.Position)
        end
    end)
end)

btnFly.MouseButton1Click:Connect(function()
    if connections["fly"] then return end
    local char = player.Character
    humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    connections["fly"] = RunService.Heartbeat:Connect(function()
        local move = humanoid.MoveDirection
        if move.Magnitude > 0 then
            char:TranslateBy(move * 10)
        end
    end)
end)

btnPararFly.MouseButton1Click:Connect(function()
    if connections["fly"] then connections["fly"]:Disconnect() connections["fly"]=nil end
end)

btnTeleportTool.MouseButton1Click:Connect(function()
    local tool = Instance.new("Tool")
    tool.RequiresHandle = false
    tool.Name = "Teleport Tool"
    tool.Parent = player.Backpack
    tool.Activated:Connect(function()
        local mouse = player:GetMouse()
        if mouse.Hit then
            player.Character:MoveTo(mouse.Hit.p + Vector3.new(0,3,0))
        end
    end)
end)

btnEspiao.MouseButton1Click:Connect(function()
    if connections["espiao"] then return end
    connections["espiao"] = RunService.RenderStepped:Connect(function()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
                local head = plr.Character.Head
                if not head:FindFirstChild("EspiaoName") then
                    local gui = Instance.new("BillboardGui")
                    gui.Name = "EspiaoName"
                    gui.Adornee = head
                    gui.Size = UDim2.new(0,200,0,50)
                    gui.AlwaysOnTop = true
                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1,0,1,0)
                    label.BackgroundTransparency = 1
                    label.TextColor3 = Color3.fromRGB(255,255,255)
                    label.Text = plr.Name
                    label.Font = Enum.Font.Gotham
                    label.FontFace = Font.new("rbxassetid://12187372175")
                    label.TextSize = 16
                    label.Parent = gui
                    gui.Parent = head
                end
                if not plr.Character:FindFirstChild("EspiaoHighlight") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "EspiaoHighlight"
                    hl.FillTransparency = 1
                    hl.OutlineColor = Color3.fromRGB(255,255,255)
                    hl.Parent = plr.Character
                end
            end
        end
    end)
end)

btnPararEspiao.MouseButton1Click:Connect(function()
    if connections["espiao"] then
        connections["espiao"]:Disconnect()
        connections["espiao"] = nil
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Head") then
                local gui = plr.Character.Head:FindFirstChild("EspiaoName")
                if gui then gui:Destroy() end
            end
            if plr.Character and plr.Character:FindFirstChild("EspiaoHighlight") then
                plr.Character.EspiaoHighlight:Destroy()
            end
        end
    end
end)

btnBoombox.MouseButton1Click:Connect(function()
    local tool = Instance.new("Tool")
    tool.Name = "Boombox"
    tool.RequiresHandle = false
    tool.Parent = player.Backpack
end)

btnLanterna.MouseButton1Click:Connect(function()
    local tool = Instance.new("Tool")
    tool.Name = "Lanterna"
    tool.RequiresHandle = false
    tool.Parent = player.Backpack
    tool.Activated:Connect(function()
        local light = Instance.new("PointLight")
        light.Brightness = 10
        light.Range = 20
        light.Parent = player.Character:FindFirstChild("HumanoidRootPart")
    end)
end)

btnEquipAll.MouseButton1Click:Connect(function()
    for _, tool in pairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            humanoid:EquipTool(tool)
        end
    end
end)

btnSpeedHack.MouseButton1Click:Connect(function()
    humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.WalkSpeed = 140 end
end)

btnGodMode.MouseButton1Click:Connect(function()
    if humanoid then
        humanoid.MaxHealth = math.huge
        humanoid.Health = humanoid.MaxHealth
    end
end)

-- Kaitun
btnKaitun.MouseButton1Click:Connect(function()
    getgenv().Mode = "OneClick"
    getgenv().Setting = {
        ["Team"] = "Pirates",
        ["FucusOnLevel"] = true,
        ["Fruits"] = {
            ["Primary"] = {"Dough-Dough","Dragon-Dragon","Buddha-Buddha"},
            ["Normal"] = {"Flame-Flame","Light-Light","Magma-Magma"},
        },
        ["Lock Fruits"] = {"Yeti-Yeti","T-Rex-T-Rex"},
        ["IdleCheck"] = 300,
    }
    loadstring(game:HttpGet("https://raw.githubusercontent.com/xQuartyx/QuartyzScript/main/Loader.lua"))()
end)

-- Desligar UI
btnDesligarUI.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Parar Tudo
btnParar.MouseButton1Click:Connect(function()
    for name, conn in pairs(connections) do
        if conn then conn:Disconnect() connections[name]=nil end
    end
    if humanoid then humanoid.WalkSpeed = 16 end
    print("Todas funções desligadas")
end)

-- Mostrar Coordenadas
btnShowCoord.MouseButton1Click:Connect(function()
    if not ScreenGui:FindFirstChild("CoordLabel") then
        local coordLabel = Instance.new("TextLabel")
        coordLabel.Name = "CoordLabel"
        coordLabel.Size = UDim2.new(0, 200, 0, 40)
        coordLabel.Position = UDim2.new(1, -210, 0, 10)
        coordLabel.BackgroundTransparency = 0.5
        coordLabel.BackgroundColor3 = Color3.fromRGB(0,0,0)
        coordLabel.TextColor3 = Color3.fromRGB(0,255,0)
        coordLabel.Font = Enum.Font.Gotham
        coordLabel.FontFace = Font.new("rbxassetid://12187372175")
        coordLabel.TextSize = 16
        coordLabel.Parent = ScreenGui
        RunService.RenderStepped:Connect(function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local pos = player.Character.HumanoidRootPart.Position
                coordLabel.Text = "X: "..math.floor(pos.X).."  Y: "..math.floor(pos.Y).."  Z: "..math.floor(pos.Z)
            end
        end)
    end
end)

-- HOHO HUB FAST ATTACK
local fastAttackRunning = false
local fastAttackConnection
btnFastAttack.MouseButton1Click:Connect(function()
    if fastAttackRunning then return end
    fastAttackRunning = true
    fastAttackConnection = RunService.RenderStepped:Connect(function()
        if fastAttackRunning then
            local mouse = player:GetMouse()
            mouse1click()
        end
    end)
    print("Fast Attack iniciado!")
end)

btnStopFastAttack.MouseButton1Click:Connect(function()
    if fastAttackRunning and fastAttackConnection then
        fastAttackConnection:Disconnect()
        fastAttackConnection = nil
        fastAttackRunning = false
        print("Fast Attack parado!")
    end
end)

-- Fullscreen Image Animation
local PlayerGui = player:WaitForChild("PlayerGui")
local screenGuiImage = Instance.new("ScreenGui")
screenGuiImage.Name = "FullScreenImage"
screenGuiImage.Parent = PlayerGui

local imageLabel = Instance.new("ImageLabel")
imageLabel.Parent = screenGuiImage
imageLabel.Size = UDim2.new(1, 0, 1, 0)
imageLabel.Position = UDim2.new(-1, 0, 0, 0)
imageLabel.Image = "rbxassetid://119584522141804"
imageLabel.BackgroundTransparency = 1

local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local goal = {Position = UDim2.new(1, 0, 0, 0)}
local tween = TweenService:Create(imageLabel, tweenInfo, goal)
tween:Play()
tween.Completed:Connect(function()
    screenGuiImage:Destroy()
end)
