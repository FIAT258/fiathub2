--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// LOAD LIBRARY
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"
))()

--// WINDOW
local Window = Library:MakeWindow({
    Title = "XfireX HUB",
    SubTitle = "(BETA) by fiat",
    ScriptFolder = "NiceHub-V5"
})

--// MINIMIZER
local Minimizer = Window:NewMinimizer({
    KeyCode = Enum.KeyCode.LeftControl
})

--------------------------------------------------
-- FUNÇÕES ÚTEIS
--------------------------------------------------

local function getPlayersList()
    local list = {}
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(list, plr.Name)
        end
    end
    return list
end

local function getCharacter(plr)
    return plr and plr.Character
end

local function notify(txt)
    Library:Notify({
        Title = "FIAT HUB",
        Description = txt,
        Time = 4
    })
end

--------------------------------------------------
-- ABA MAIN
--------------------------------------------------

local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "home"
})

-- DROPDOWN PLAYER
local SelectedPlayer = nil

local PlayerDropdown = MainTab:AddDropdown({
    Name = "Select Player",
    Options = getPlayersList(),
    Callback = function(v)
        SelectedPlayer = Players:FindFirstChild(v)
    end
})

-- BOTÃO REFRESH PLAYER
MainTab:AddButton({
    Name = "Refresh Player",
    Callback = function()
        PlayerDropdown:Clear()
        for _,name in ipairs(getPlayersList()) do
            PlayerDropdown:Add(name)
        end
        notify("Lista de players atualizada")
    end
})

--------------------------------------------------
-- VIEW PLAYER (LÓGICA ANTIGA)
--------------------------------------------------

local ViewToggle = false
local ViewConn

MainTab:AddToggle({
    Name = "View Player",
    Default = false,
    Callback = function(v)
        ViewToggle = v
        if v then
            ViewConn = RunService.RenderStepped:Connect(function()
                if SelectedPlayer and getCharacter(SelectedPlayer) and getCharacter(SelectedPlayer):FindFirstChild("HumanoidRootPart") then
                    Camera.CFrame = getCharacter(SelectedPlayer).HumanoidRootPart.CFrame * CFrame.new(0,5,-10)
                end
            end)
        else
            if ViewConn then ViewConn:Disconnect() end
            Camera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
        end
    end
})

--------------------------------------------------
-- FLING BALL (BETA)
--------------------------------------------------

MainTab:AddParagraph({
    Title = "FLING BALL",
    Content = "fling ball em BETA junto com o script"
})

local FlingBallToggle = false
local SoccerModel
local BallConn

MainTab:AddToggle({
    Name = "Fling Ball (BETA)",
    Default = false,
    Callback = function(v)
        FlingBallToggle = v

        if not SelectedPlayer then
            notify("Nenhum player selecionado")
            return
        end

        if v then
            -- pegar tool SoccerBall
            for _,tool in ipairs(workspace:GetDescendants()) do
                if tool:IsA("Tool") and tool.Name == "SoccerBall" then
                    tool.Parent = LocalPlayer.Backpack
                end
            end

            task.wait(0.2)

            local ballTool = LocalPlayer.Backpack:FindFirstChild("SoccerBall")
            if ballTool then
                LocalPlayer.Character.Humanoid:EquipTool(ballTool)

                -- 9 cliques
                for i=1,9 do
                    mouse1click()
                end
            end

            -- procurar modelo Soccer
            for _,m in ipairs(workspace:GetDescendants()) do
                if m:IsA("Model") and m.Name == "Soccer" then
                    SoccerModel = m
                    break
                end
            end

            if not SoccerModel then
                notify("Modelo Soccer não encontrado")
                return
            end

            BallConn = RunService.Heartbeat:Connect(function()
                if not FlingBallToggle then return end
                if not SelectedPlayer or not SelectedPlayer.Parent then
                    notify("Player saiu do jogo")
                    FlingBallToggle = false
                    BallConn:Disconnect()
                    return
                end

                local char = getCharacter(SelectedPlayer)
                if char and char:FindFirstChild("HumanoidRootPart") then
                    for _,p in ipairs(SoccerModel:GetDescendants()) do
                        if p:IsA("BasePart") then
                            p.Velocity = (char.HumanoidRootPart.Position - p.Position).Unit * 200
                            p.CFrame = p.CFrame * CFrame.Angles(0,math.rad(60),0)
                        end
                    end
                end
            end)
        else
            if BallConn then BallConn:Disconnect() end
        end
    end
})

--------------------------------------------------
-- ABA TOOLS
--------------------------------------------------

local ToolsTab = Window:MakeTab({
    Name = "Tools",
    Icon = "axe"
})

-- TP TOOL
ToolsTab:AddButton({
    Name = "TP Tool",
    Callback = function()
        local tool = Instance.new("Tool")
        tool.Name = "TPTool"
        tool.RequiresHandle = false
        tool.Parent = LocalPlayer.Backpack

        tool.Activated:Connect(function()
            local mouse = LocalPlayer:GetMouse()
            if mouse.Hit then
                LocalPlayer.Character:MoveTo(mouse.Hit.Position)
            end
        end)
    end
})

-- SELECT TOOL
ToolsTab:AddButton({
    Name = "Select Tool (Click Player)",
    Callback = function()
        notify("Clique em um player")
        local mouse = LocalPlayer:GetMouse()
        mouse.Button1Down:Wait()
        if mouse.Target and mouse.Target.Parent:FindFirstChild("Humanoid") then
            notify("Selecionado: "..mouse.Target.Parent.Name)
        end
    end
})

-- DROPDOWN TOOLS
local ToolSelected

local ToolDropdown = ToolsTab:AddDropdown({
    Name = "All Tools",
    Options = {},
    Callback = function(v)
        ToolSelected = v
    end
})

ToolsTab:AddButton({
    Name = "Refresh Tools",
    Callback = function()
        ToolDropdown:Clear()
        for _,t in ipairs(workspace:GetDescendants()) do
            if t:IsA("Tool") then
                ToolDropdown:Add(t.Name)
            end
        end
    end
})

-- GET TOOL
ToolsTab:AddButton({
    Name = "Get Tool",
    Callback = function()
        if not ToolSelected then return end
        for _,t in ipairs(workspace:GetDescendants()) do
            if t:IsA("Tool") and t.Name == ToolSelected then
                t.Parent = LocalPlayer.Backpack
            end
        end
    end
})

--------------------------------------------------
-- ABA CONFIGURAÇÃO
--------------------------------------------------

local ConfigTab = Window:MakeTab({
    Name = "Config",
    Icon = "settings"
})

-- ANTI LAG
ConfigTab:AddToggle({
    Name = "Anti Lag",
    Default = false,
    Callback = function(v)
        if v then
            Lighting.ChildAdded:Connect(function(obj)
                if obj:IsA("Light") then
                    obj.Enabled = false
                end
            end)
        end
    end
})

-- REMOVER TEXTURAS
local StoredTextures = {}

ConfigTab:AddToggle({
    Name = "Remover Texturas",
    Default = false,
    Callback = function(v)
        if v then
            for _,d in ipairs(workspace:GetDescendants()) do
                if d:IsA("Texture") or d:IsA("Decal") then
                    StoredTextures[d] = d.Transparency
                    d.Transparency = 1
                end
            end
        else
            for tex,val in pairs(StoredTextures) do
                if tex then tex.Transparency = val end
            end
        end
    end
})

--------------------------------------------------
-- ABA PING
--------------------------------------------------

local PingTab = Window:MakeTab({
    Name = "Ping",
    Icon = "wifi"
})

PingTab:AddToggle({
    Name = "Check Ping Server",
    Default = false,
    Callback = function(v)
        if v then
            task.spawn(function()
                while v do
                    local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
                    if ping <= 29 then
                        notify("🟢 Ping ótimo")
                    elseif ping >= 100 and ping < 200 then
                        notify("🟡 Ping estranho")
                    elseif ping >= 200 then
                        notify("🔴 Ping alto! Ative anti lag e remover texturas")
                    end
                    task.wait(5)
                end
            end)
        end
    end
})
