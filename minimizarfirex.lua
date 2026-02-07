-- Serviços
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FireGui"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

-- Botão (quadrado arrastável)
local button = Instance.new("ImageButton")
button.Parent = gui
button.Size = UDim2.new(0, 40, 0, 40)
button.Position = UDim2.new(0.5, -20, 0.6, -20)

-- IMAGEM NO MEIO 🔥
button.Image = "rbxassetid://84973708912590"
button.ScaleType = Enum.ScaleType.Fit
button.ImageTransparency = 0
button.ImageRectOffset = Vector2.new(0,0)
button.ImageRectSize = Vector2.new(0,0)

-- Visual do quadrado
button.BackgroundTransparency = 0
button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
button.BorderSizePixel = 2
button.BorderColor3 = Color3.fromRGB(255, 140, 0)
button.AutoButtonColor = false
button.Active = true
button.ZIndex = 100

-- Drag manual
local dragging = false
local dragStart
local startPos

button.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = button.Position
	end
end)

button.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (
		input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
	) then
		local delta = input.Position - dragStart
		button.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- Clique = simular CTRL real
button.MouseButton1Click:Connect(function()
	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
	task.wait(0.08)
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
end)
