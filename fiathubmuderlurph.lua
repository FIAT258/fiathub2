-- RAYFIELD (BASE FUNCIONAL)
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
	Name = "FIAT HUB",
	LoadingTitle = "FIAT HUB",
	LoadingSubtitle = "by fiat",
	ConfigurationSaving = {
		Enabled = false
	},
	KeySystem = false
})

------------------------------------------------
-- ABA FARM PRINCIPAL
------------------------------------------------
local FarmTab = Window:CreateTab("Farm principal", 4483362458)

local FarmSection = FarmTab:CreateSection("Farms")

FarmSection:CreateToggle({
	Name = "Auto farm coins",
	CurrentValue = false,
	Callback = function(v)
		print("Auto farm coins:", v)
	end
})

FarmSection:CreateToggle({
	Name = "Auto farm murderer",
	CurrentValue = false,
	Callback = function(v)
		print("Auto farm murderer:", v)
	end
})

FarmSection:CreateParagraph({
	Title = "Aviso",
	Content = "Auto farms em beta, ative apenas um"
})

------------------------------------------------
-- ABA TROLL
------------------------------------------------
local TrollTab = Window:CreateTab("Troll", 4483362458)
local TrollSection = TrollTab:CreateSection("Trollagens")

TrollSection:CreateDropdown({
	Name = "Selecionar player",
	Options = {"Player1","Player2"},
	CurrentOption = nil,
	Callback = function(v)
		print("Selecionado:", v)
	end
})

TrollSection:CreateToggle({
	Name = "Fling player específico",
	CurrentValue = false,
	Callback = function(v)
		print("Fling específico:", v)
	end
})

TrollSection:CreateToggle({
	Name = "Fling all",
	CurrentValue = false,
	Callback = function(v)
		print("Fling all:", v)
	end
})

TrollSection:CreateButton({
	Name = "Teleport Gun",
	Callback = function()
		print("Teleport Gun")
	end
})

TrollSection:CreateToggle({
	Name = "Aim bot Murderer",
	CurrentValue = false,
	Callback = function(v)
		print("Aim bot:", v)
	end
})

------------------------------------------------
-- ABA CONFIGURAÇÃO
------------------------------------------------
local ConfigTab = Window:CreateTab("Configuração", 4483362458)
local ConfigSection = ConfigTab:CreateSection("Player")

ConfigSection:CreateToggle({
	Name = "ESP Sheriff/Killer",
	CurrentValue = false,
	Callback = function(v)
		print("ESP Sheriff/Killer:", v)
	end
})

ConfigSection:CreateToggle({
	Name = "ESP Assassino",
	CurrentValue = false,
	Callback = function(v)
		print("ESP Assassino:", v)
	end
})

ConfigSection:CreateToggle({
	Name = "Infinite Jump",
	CurrentValue = false,
	Callback = function(v)
		print("Infinite Jump:", v)
	end
})

ConfigSection:CreateSlider({
	Name = "Velocidade",
	Range = {16,100},
	Increment = 1,
	CurrentValue = 16,
	Callback = function(v)
		print("Speed:", v)
	end
})

ConfigSection:CreateToggle({
	Name = "Ativar velocidade",
	CurrentValue = false,
	Callback = function(v)
		print("Speed toggle:", v)
	end
})

ConfigSection:CreateToggle({
	Name = "Noclip",
	CurrentValue = false,
	Callback = function(v)
		print("Noclip:", v)
	end
})

------------------------------------------------
-- ABA DISCORD
------------------------------------------------
local DiscordTab = Window:CreateTab("Discord", 4483362458)
local DiscordSection = DiscordTab:CreateSection("Info")

DiscordSection:CreateParagraph({
	Title = "Informação",
	Content = "Script feito por fiat"
})

DiscordSection:CreateButton({
	Name = "Get Discord",
	Callback = function()
		setclipboard("https://discord.gg/VGRmqRRz")
	end
})
