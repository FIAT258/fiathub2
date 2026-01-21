------------------------------------------------
-- RAYFIELD UI
------------------------------------------------
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

------------------------------------------------
-- SERVICES
------------------------------------------------
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

------------------------------------------------
-- WINDOW
------------------------------------------------
local Window = Rayfield:CreateWindow({
	Name = "NOTHING",
	LoadingTitle = "NOTHING",
	LoadingSubtitle = "Auto Farms / Troll / Config",
	ConfigurationSaving = { Enabled = false },
	KeySystem = false
})

------------------------------------------------
-- UTILS
------------------------------------------------
local function getChar()
	return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHRP()
	return getChar():WaitForChild("HumanoidRootPart")
end

local function getHum()
	return getChar():WaitForChild("Humanoid")
end

local noclipConnection
local function setNoclip(state)
	if noclipConnection then
		noclipConnection:Disconnect()
		noclipConnection = nil
	end
	if state then
		noclipConnection = RunService.Stepped:Connect(function()
			for _,v in pairs(getChar():GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end)
	end
end

local function tweenTo(cf, speed)
	local hrp = getHRP()
	local dist = (hrp.Position - cf.Position).Magnitude
	local tween = TweenService:Create(
		hrp,
		TweenInfo.new(dist / speed, Enum.EasingStyle.Linear),
		{CFrame = cf}
	)
	tween:Play()
	return tween
end

------------------------------------------------
-- ABA FARM PRINCIPAL
------------------------------------------------
local FarmTab = Window:CreateTab("Farm principal", 4483362458)

FarmTab:CreateParagraph({
	Title = "Informação",
	Content = "auto farms em beta, ative apenas um"
})

------------------------------------------------
-- AUTO FARM COIN (NOVO)
------------------------------------------------
local farmCoins = false
FarmTab:CreateToggle({
	Name = "auto farm coins",
	CurrentValue = false,
	Callback = function(v)
		farmCoins = v
		setNoclip(v)

		task.spawn(function()
			while farmCoins do
				local coin = Workspace:FindFirstChild("Coin_Server", true)
					or ReplicatedStorage:FindFirstChild("Coin_Server", true)

				if coin and coin:IsA("BasePart") then
					local t = tweenTo(coin.CFrame + Vector3.new(0,3,0), 40)
					repeat task.wait() until not coin.Parent or not farmCoins
				else
					task.wait(1)
				end
			end
		end)
	end
})

------------------------------------------------
-- AUTO FARM MURDER (MANTIDO)
------------------------------------------------
local farmMurder = false
FarmTab:CreateToggle({
	Name = "auto farm muder",
	CurrentValue = false,
	Callback = function(v)
		farmMurder = v
		setNoclip(v)

		task.spawn(function()
			while farmMurder do
				if LocalPlayer.Team and LocalPlayer.Team.Name == "Murderer" then
					for _,plr in pairs(Players:GetPlayers()) do
						if plr ~= LocalPlayer
						and plr.Team
						and (plr.Team.Name == "Sheriff" or plr.Team.Name == "Innocent")
						and plr.Character
						and plr.Character:FindFirstChild("HumanoidRootPart") then
							tweenTo(plr.Character.HumanoidRootPart.CFrame, 60)
						end
					end
				end
				task.wait(0.4)
			end
		end)
	end
})

------------------------------------------------
-- ABA TROLL
------------------------------------------------
local TrollTab = Window:CreateTab("Troll", 4483362458)

local selectedPlayer

local function updatePlayers()
	local list = {}
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			table.insert(list, p.Name)
		end
	end
	return list
end

TrollTab:CreateDropdown({
	Name = "Selecionar player",
	Options = updatePlayers(),
	CurrentOption = nil,
	Callback = function(v)
		selectedPlayer = v
	end
})

Players.PlayerAdded:Connect(function()
	Rayfield:Notify({Title="Info",Content="Atualize o dropdown",Duration=2})
end)

------------------------------------------------
-- FLING PLAYER ESPECÍFICO (NOVO)
------------------------------------------------
local flingSpecific = false
TrollTab:CreateToggle({
	Name = "fling player específico",
	CurrentValue = false,
	Callback = function(v)
		flingSpecific = v
		setNoclip(v)

		task.spawn(function()
			while flingSpecific and selectedPlayer do
				local plr = Players:FindFirstChild(selectedPlayer)
				if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
					for i=1,20 do
						getHRP().CFrame =
							plr.Character.HumanoidRootPart.CFrame *
							CFrame.Angles(0, math.rad(i*30), 0)
						task.wait()
					end
				end
				task.wait()
			end
		end)
	end
})

------------------------------------------------
-- FLING ALL
------------------------------------------------
local flingAll = false
TrollTab:CreateToggle({
	Name = "fling all",
	CurrentValue = false,
	Callback = function(v)
		flingAll = v
		setNoclip(v)

		task.spawn(function()
			while flingAll do
				for _,plr in pairs(Players:GetPlayers()) do
					if plr ~= LocalPlayer
					and plr.Character
					and plr.Character:FindFirstChild("HumanoidRootPart") then
						for i=1,15 do
							getHRP().CFrame =
								plr.Character.HumanoidRootPart.CFrame *
								CFrame.Angles(0, math.rad(i*30), 0)
							task.wait()
						end
					end
				end
				task.wait()
			end
		end)
	end
})

------------------------------------------------
-- TELEPORT GUNDROP
------------------------------------------------
TrollTab:CreateButton({
	Name = "Teleport Gun",
	Callback = function()
		local gun = Workspace:FindFirstChild("GunDrop", true)
		if gun then
			getHRP().CFrame = gun.CFrame
		end
	end
})

------------------------------------------------
-- AIM BOT KNIFE (NOVO)
------------------------------------------------
local aimBot = false
TrollTab:CreateToggle({
	Name = "aim bot Murderer",
	CurrentValue = false,
	Callback = function(v)
		aimBot = v
	end
})

RunService.RenderStepped:Connect(function()
	if aimBot then
		for _,plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer
			and plr.Backpack:FindFirstChild("Knife")
			and plr.Character
			and plr.Character:FindFirstChild("Head") then
				local d = (getHRP().Position - plr.Character.Head.Position).Magnitude
				if d <= 100 then
					Camera.CFrame = CFrame.new(Camera.CFrame.Position, plr.Character.Head.Position)
				end
			end
		end
	end
end)

------------------------------------------------
-- ABA CONFIGURAÇÃO
------------------------------------------------
local ConfigTab = Window:CreateTab("Configuração", 4483362458)

------------------------------------------------
-- ESP SHERIFF / KILLER
------------------------------------------------
ConfigTab:CreateToggle({
	Name = "esp Sheriff/Killer",
	CurrentValue = false,
	Callback = function(v)
		for _,plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer
			and plr.Team ~= LocalPlayer.Team
			and plr.Character then
				if v then
					local h = Instance.new("Highlight", plr.Character)
					h.FillColor = Color3.fromRGB(0,0,255)
					h.OutlineColor = h.FillColor
				end
			end
		end
	end
})

------------------------------------------------
-- ESP ASSASSINO
------------------------------------------------
ConfigTab:CreateToggle({
	Name = "esp assasino",
	CurrentValue = false,
	Callback = function(v)
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Backpack:FindFirstChild("Knife") and plr.Character then
				if v then
					local h = Instance.new("Highlight", plr.Character)
					h.FillColor = Color3.fromRGB(255,0,0)
					h.OutlineColor = h.FillColor
				end
			end
		end
	end
})

------------------------------------------------
-- INFINITE JUMP
------------------------------------------------
local infJump = false
ConfigTab:CreateToggle({
	Name = "infinit pulo",
	CurrentValue = false,
	Callback = function(v)
		infJump = v
	end
})

UserInputService.JumpRequest:Connect(function()
	if infJump then
		getHum():ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

------------------------------------------------
-- SPEED
------------------------------------------------
local speedValue = 16
ConfigTab:CreateSlider({
	Name = "Velocidade",
	Range = {16,100},
	Increment = 1,
	CurrentValue = 16,
	Callback = function(v)
		speedValue = v
	end
})

ConfigTab:CreateToggle({
	Name = "ativar velocidade",
	CurrentValue = false,
	Callback = function(v)
		RunService.Heartbeat:Connect(function()
			if v then
				getHum().WalkSpeed = speedValue
			end
		end)
	end
})

------------------------------------------------
-- NOCLIP
------------------------------------------------
ConfigTab:CreateToggle({
	Name = "noclip",
	CurrentValue = false,
	Callback = function(v)
		setNoclip(v)
	end
})

------------------------------------------------
-- ABA DISCORD
------------------------------------------------
local DiscordTab = Window:CreateTab("Discord", 4483362458)

DiscordTab:CreateParagraph({
	Title = "Créditos",
	Content = "script feito por fiat"
})

DiscordTab:CreateButton({
	Name = "get Discord",
	Callback = function()
		setclipboard("https://discord.gg/VGRmqRRz")
	end
})
