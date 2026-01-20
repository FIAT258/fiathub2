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

local LocalPlayer = Players.LocalPlayer

------------------------------------------------
-- WINDOW
------------------------------------------------
local Window = Rayfield:CreateWindow({
	Name = "NOTHING",
	LoadingTitle = "NOTHING",
	LoadingSubtitle = "Auto Farms / Troll / Config",
	ConfigurationSaving = {
		Enabled = false
	},
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
	Content = "auto farms em beta ative só um"
})

------------------------------------------------
-- AUTO FARM COINS
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
				local closest, dist = nil, math.huge
				for _,obj in pairs(ReplicatedStorage:GetDescendants()) do
					if obj:IsA("BasePart")
					and (obj.Name:lower():find("coin") or obj.Name:lower():find("won")) then
						local d = (getHRP().Position - obj.Position).Magnitude
						if d < dist then
							dist = d
							closest = obj
						end
					end
				end

				if closest then
					tweenTo(closest.CFrame + Vector3.new(0,3,0), 40).Completed:Wait()
					task.wait(2)
				else
					tweenTo(CFrame.new(0,-150,0), 40)
					task.wait(2)
				end
			end
		end)
	end
})

------------------------------------------------
-- AUTO FARM MURDER
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

local selectedTeam = "Murderer"

TrollTab:CreateDropdown({
	Name = "Selecionar Team",
	Options = {"Murderer","Sheriff","Innocent"},
	CurrentOption = "Murderer",
	Callback = function(v)
		selectedTeam = v
	end
})

------------------------------------------------
-- FLING PLAYER ESPECÍFICO
------------------------------------------------
local flingSpecific = false
TrollTab:CreateToggle({
	Name = "fling player específico",
	CurrentValue = false,
	Callback = function(v)
		flingSpecific = v
		setNoclip(v)

		task.spawn(function()
			while flingSpecific do
				for _,plr in pairs(Players:GetPlayers()) do
					if plr.Team
					and plr.Team.Name == selectedTeam
					and plr.Character
					and plr.Character:FindFirstChild("HumanoidRootPart") then
						for i=1,20 do
							getHRP().CFrame =
								plr.Character.HumanoidRootPart.CFrame *
								CFrame.Angles(0, math.rad(i*25), 0)
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
-- TELEPORT GUN
------------------------------------------------
TrollTab:CreateButton({
	Name = "Teleport Gun",
	Callback = function()
		for _,v in pairs(ReplicatedStorage:GetDescendants()) do
			if v:IsA("BasePart") and v.Name == "Gun" then
				getHRP().CFrame = v.CFrame
			end
		end
	end
})

------------------------------------------------
-- AIMBOT MURDER
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
			if plr.Team
			and plr.Team.Name == "Murderer"
			and plr.Character
			and plr.Character:FindFirstChild("Head") then
				local d = (getHRP().Position - plr.Character.Head.Position).Magnitude
				if d <= 110 then
					workspace.CurrentCamera.CFrame =
						CFrame.new(
							workspace.CurrentCamera.CFrame.Position,
							plr.Character.Head.Position
						)
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
-- ESP
------------------------------------------------
local function espTeam(teamName, color)
	for _,plr in pairs(Players:GetPlayers()) do
		if plr.Team
		and plr.Team.Name == teamName
		and plr.Character
		and not plr.Character:FindFirstChild("ESP") then
			local h = Instance.new("Highlight", plr.Character)
			h.Name = "ESP"
			h.FillColor = color
			h.OutlineColor = color
		end
	end
end

ConfigTab:CreateToggle({
	Name = "esp Murderer",
	CurrentValue = false,
	Callback = function(v)
		if v then espTeam("Murderer", Color3.fromRGB(255,0,0)) end
	end
})

ConfigTab:CreateToggle({
	Name = "esp sobrevivente",
	CurrentValue = false,
	Callback = function(v)
		if v then espTeam("Innocent", Color3.fromRGB(0,255,0)) end
	end
})

ConfigTab:CreateToggle({
	Name = "esp Sheriff",
	CurrentValue = false,
	Callback = function(v)
		if v then espTeam("Sheriff", Color3.fromRGB(0,0,255)) end
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
-- ESP GUN
------------------------------------------------
ConfigTab:CreateToggle({
	Name = "esp gun",
	CurrentValue = false,
	Callback = function(v)
		if v then
			for _,g in pairs(ReplicatedStorage:GetDescendants()) do
				if g:IsA("BasePart") and g.Name == "Gun" then
					local h = Instance.new("Highlight", g)
					h.FillColor = Color3.fromRGB(0,0,255)
					h.OutlineColor = Color3.fromRGB(0,0,255)
				end
			end
		end
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
