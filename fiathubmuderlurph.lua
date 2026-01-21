local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()

local Window = Rayfield:CreateWindow({
	Name = "TESTE",
	LoadingTitle = "Teste",
	LoadingSubtitle = "Rayfield",
	ConfigurationSaving = { Enabled = false },
	KeySystem = false
})

local Tab = Window:CreateTab("Aba 1", 4483362458)

Tab:CreateToggle({
	Name = "Toggle Teste",
	CurrentValue = false,
	Callback = function(v)
		print(v)
	end
})

Tab:CreateButton({
	Name = "Botão Teste",
	Callback = function()
		print("clicou")
	end
})

local Tab2 = Window:CreateTab("Discord", 4483362458)

Tab2:CreateParagraph({
	Title = "Info",
	Content = "Script feito por fiat"
})

Tab2:CreateButton({
	Name = "Get Discord",
	Callback = function()
		setclipboard("https://discord.gg/VGRmqRRz")
	end
})
