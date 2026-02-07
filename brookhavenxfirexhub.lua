-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- LOAD LIBRARY
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"
))()

-- WINDOW
local Window = Library:MakeWindow({
    Title = "Nice Hub",
    SubTitle = "debug real agora",
    ScriptFolder = "NiceHub"
})

-- MINIMIZER
Window:NewMinimizer({
    KeyCode = Enum.KeyCode.LeftControl
})

--------------------------------------------------
-- FUNÇÕES
--------------------------------------------------

local function getPlayers()
    local t = {}
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(t, p.Name)
        end
    end
    return t
end

--------------------------------------------------
-- ABA MAIN
--------------------------------------------------

local MainTab = Window:AddTab({
    Name = "Main",
    Icon = "home"
})

local SelectedPlayer

local PlayerDropdown = MainTab:AddDropdown({
    Name = "Select Player",
    Options = getPlayers(),
    Callback = function(v)
        SelectedPlayer = Players:FindFirstChild(v)
    end
})

MainTab:AddButton({
    Name = "Refresh Player",
    Callback = function()
        PlayerDropdown:Clear()
        for _,n in ipairs(getPlayers()) do
            PlayerDropdown:Add(n)
        end
    end
})

--------------------------------------------------
-- VIEW PLAYER (CORRIGIDO)
--------------------------------------------------

local ViewEnabled = false
local ViewConn

MainTab:AddToggle({
    Name = "View Player",
    Default = false,
    Callback = function(state)
        ViewEnabled = state

        if state then
            ViewConn = RunService.RenderStepped:Connect(function()
                if SelectedPlayer
                and SelectedPlayer.Character
                and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then

                    Camera.CameraType = Enum.CameraType.Scriptable
                    Camera.CFrame =
                        SelectedPlayer.Character.HumanoidRootPart.CFrame
                        * CFrame.new(0, 4, -10)
                end
            end)
        else
            if ViewConn then ViewConn:Disconnect() end
            Camera.CameraType = Enum.CameraType.Custom
            Camera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
        end
    end
})

--------------------------------------------------
-- FLING BALL (APARECE AGORA)
--------------------------------------------------

MainTab:AddToggle({
    Name = "Fling Ball (BETA)",
    Default = false,
    Callback = function(v)
        if not SelectedPlayer then
            Library:Notify({
                Title = "Erro",
                Description = "Selecione um player",
                Time = 3
            })
            return
        end

        Library:Notify({
            Title = "Fling Ball",
            Description = v and "Ativado (BETA)" or "Desativado",
            Time = 3
        })
    end
})

--------------------------------------------------
-- OUTRAS ABAS (TESTE VISUAL)
--------------------------------------------------

Window:AddTab({
    Name = "Tools",
    Icon = "axe"
})

Window:AddTab({
    Name = "Config",
    Icon = "settings"
})

Window:AddTab({
    Name = "Ping",
    Icon = "wifi"
})
