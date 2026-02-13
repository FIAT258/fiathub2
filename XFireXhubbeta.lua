local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Fire X Hub",
    SubTitle = "by .ftgs",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    KeySystem = Window:AddTab({ Title = "Key System", Icon = "key" }),
    Discord = Window:AddTab({ Title = "Discord", Icon = "message-circle" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Função para verificar a key
local function checkKey(key)
    local validKey = "#fire#hubx130key18722--KEYwalfy"
    return key == validKey
end

-- Tab Key System
do
    -- Input para a key
    local KeyInput = Tabs.KeySystem:AddInput("KeyInput", {
        Title = "Enter Key",
        Default = "",
        Placeholder = "Paste your key here...",
        Numeric = false,
        Finished = false,
        Callback = function(Value)
            -- Não fazemos nada aqui, usaremos o botão para verificar
        end
    })

    -- Botão para verificar a key
    Tabs.KeySystem:AddButton({
        Title = "Check Key",
        Description = "Verify if your key is valid",
        Callback = function()
            local enteredKey = KeyInput.Value
            
            if checkKey(enteredKey) then
                Fluent:Notify({
                    Title = "Success",
                    Content = "Valid key! Loading hub...",
                    Duration = 3
                })
                
                -- Destruir a interface
                Window:Destroy()
                
                -- Carregar os scripts
                task.spawn(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/FIAT258/fiathub2/main/brookhavenxfirexhub.lua"))()
                end)

                task.spawn(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/FIAT258/fiathub2/main/minimizarfirex.lua"))()
                end)
            else
                Fluent:Notify({
                    Title = "Error",
                    Content = "Click 'Get Key' and try again",
                    Duration = 3
                })
            end
        end
    })

    -- Botão para pegar key
    Tabs.KeySystem:AddButton({
        Title = "Get Key",
        Description = "Copy the key link to clipboard",
        Callback = function()
            setclipboard("https://link-target.net/1460648/MU09RvRj3fCW")
            Fluent:Notify({
                Title = "Copied",
                Content = "Key link copied to clipboard!",
                Duration = 3
            })
        end
    })

    -- Aviso sobre a key
    Tabs.KeySystem:AddParagraph({
        Title = "Important Notice",
        Content = "Save your key as it won't be saved automatically"
    })
end

-- Tab Discord
do
    -- Botão para pegar link do Discord
    Tabs.Discord:AddButton({
        Title = "Get Discord",
        Description = "Copy the Discord invite link",
        Callback = function()
            setclipboard("https://discord.gg/ccBGAGU7yK")
            Fluent:Notify({
                Title = "Copied",
                Content = "Discord link copied to clipboard!",
                Duration = 3
            })
        end
    })
end

-- Configurações do SaveManager e InterfaceManager
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FireXHub")
SaveManager:SetFolder("FireXHub/config")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Selecionar a primeira aba e mostrar notificação
Window:SelectTab(1)
Fluent:Notify({
    Title = "Fire X Hub",
    Content = "Key system loaded successfully",
    Duration = 5
})
