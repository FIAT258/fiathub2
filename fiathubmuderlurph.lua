local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
	Name = "TESTE RAYFIELD",
	LoadingTitle = "Teste",
	LoadingSubtitle = "UI",
	ConfigurationSaving = {Enabled = false},
	KeySystem = false
})

local Tab1 = Window:CreateTab("Farm principal", 4483362458)

Tab1:CreateToggle({
	Name = "Toggle Teste",
	CurrentValue = false,
	Callback = function(v)
		print("Toggle:", v)
	end
})

Tab1:CreateButton({
	Name = "Botão Teste",
	Callback = function()
		print("Botão clicado")
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
