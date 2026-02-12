local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "XFIREX HUB key sisten",
    Icon = "door-open", -- lucide icon
    Author = "by fiat",
    Folder = "MySuperHub",
    
    -- ↓ This all is Optional. You can remove it.
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    
    
    [[ You can set 'rbxassetid:82224027035247//' or video to Background.
        'rbxassetid://82224027035247':
            Background = "rbxassetid://82224027035247", -- rbxassetid
        Video:
            Background = "video:YOUR-RAW-LINK-TO-VIDEO.webm", -- video 
    --]]
    
    -- ↓ Optional. You can remove it.
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
            print("clicked")
        end,
    },
    

-- Tab Key System
local KeyTab = Window:Tab({
    Title = "Key System",
    Icon = "key",
})

-- Input para a key
local KeyInput = KeyTab:Input({
    Title = "Key Input",
    Desc = "Digite sua key aqui",
    Placeholder = "Cole sua key aqui...",
    Type = "Input",
})

-- Botão para verificar a key
KeyTab:Button({
    Title = "Check Key",
    Desc = "Verifique se sua key é válida",
    Callback = function()
        local enteredKey = KeyInput.Value
        local validKey = "#fire#hubx130key18722--KEYwalfy"
        
        if enteredKey == validKey then
            WindUI:Notify({
                Title = "Sucesso",
                Content = "Key válida! Carregando hub...",
                Duration = 3,
                Icon = "check",
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
            WindUI:Notify({
                Title = "Erro",
                Content = "Clika get key e tenta pegar meu filho",
                Duration = 3,
                Icon = "x",
            })
        end
    end
})

-- Botão para pegar key
KeyTab:Button({
    Title = "Get Key",
    Desc = "Clique para copiar o link da key",
    Callback = function()
        setclipboard("https://link-target.net/1460648/MU09RvRj3fCW")
        WindUI:Notify({
            Title = "Link copiado",
            Content = "O link da key foi copiado para sua área de transferência!",
            Duration = 3,
            Icon = "copy",
        })
    end
})

-- Aviso sobre salvar key
KeyTab:Paragraph({
    Title = "Aviso Importante",
    Desc = "Salve sua key pois ela não fica salva automaticamente",
    Color = "Red",
    Icon = "alert-circle",
})

-- Tab Discord
local DiscordTab = Window:Tab({
    Title = "Discord",
    Icon = "message-circle",
})

-- Botão para pegar link do Discord
DiscordTab:Button({
    Title = "Get Discord",
    Desc = "Clique para copiar o link do nosso Discord",
    Callback = function()
        setclipboard("https://discord.gg/ccBGAGU7yK")
        WindUI:Notify({
            Title = "Link copiado",
            Content = "O link do Discord foi copiado para sua área de transferência!",
            Duration = 3,
            Icon = "copy",
        })
    end
})
