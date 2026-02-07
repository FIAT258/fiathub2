local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

local Window = redzlib:MakeWindow({
    Title = "Nome do hub",
    SubTitle = "Descrição",
    ScriptFolder = "pasta"
})

Window:AddMinimizeButton({
    Button = {
        Image = redzlib:GetIcon("home"),
        BackgroundTransparency = 0
    },
    Corner = { CornerRadius = UDim.new(0, 6) }
})

local Main = Window:MakeTab({"Main", "home"})
local Tools = Window:MakeTab({"Tools", "axe"})
local Config = Window:MakeTab({"Config", "settings"})
local Ping  = Window:MakeTab({"Ping", "wifi"})
local Discord = Window:MakeTab({"Discord", "message-circle"})

-- Depois de criar a tab, ADICIONE elementos nela:
Main:AddButton({"Click me", function() print("clicked") end})
Main:AddToggle({Name = "Toggle", Default = false, Callback = function(v) print(v) end})
Main:AddDropdown({Name = "Select", Options = {"opt1","opt2"}, Callback = function(v) print(v) end})
