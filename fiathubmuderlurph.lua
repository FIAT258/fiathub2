-- RAYFIELD
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- WINDOW
local Window = Rayfield:CreateWindow({
	Name = "FIAT HUB",
	LoadingTitle = "FIAT HUB",
	LoadingSubtitle = "by fiat",
	ConfigurationSaving = { Enabled = false },
	KeySystem = false
})

------------------------------------------------
-- VARIABLES
------------------------------------------------
local noclipConn
local autoCoin = false
local autoMurder = false
local flingSpecific = false
local flingAll = false
local aimBot = false
local infiniteJump = false
local speedEnabled = false
local speedValue = 16
local selectedPlayer = nil

------------------------------------------------
-- UTILS
------------------------------------------------
local function setNoclip(state)
	if state then
		noclipConn = RunService.Stepped:Connect(function()
			for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end)
	else
		if noclipConn then noclipConn:Disconnect() end
	end
end

local function tweenTo(cf)
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local t = TweenService:Create(hrp, TweenInfo.new(1, Enum.EasingStyle.Linear), {CFrame = cf})
	t:Play()
	t.Completed:Wait()
end

------------------------------------------------
-- FARM PRINCIPAL
------------------------------------------------
local FarmTab = Window:CreateTab("Farm principal", 4483362458)
local FarmSection = FarmTab:CreateSection("Farms")

FarmSection:CreateParagraph({
	Title = "Aviso",
	Content = "Auto farms em beta, ative apenas um"
})

-- AUTO FARM COIN
FarmSection:CreateToggle({
	Name = "Auto farm coins",
	CurrentValue = false,
	Callback = function(v)
		autoCoin = v
		setNoclip(v)

		task.spawn(function()
			while autoCoin do
				local coin = workspace:FindFirstChild("Coin_Server", true)
				if coin and coin:IsA("BasePart") then
					tweenTo(coin.CFrame + Vector3.new(0,3,0))
					repeat task.wait() until not coin.Parent or not autoCoin
				else
					task.wait(1)
				end
			end
		end)
	end
})

-- AUTO FARM MURDER
FarmSection:CreateToggle({
	Name = "Auto farm murderer",
	CurrentValue = false,
	Callback = function(v)
		autoMurder = v
		setNoclip(v)

		task.spawn(function()
			while autoMurder do
				for _,plr in pairs(Players:GetPlayers()) do
					if plr ~= LocalPlayer and plr.Character and plr.Backpack:FindFirstChild("Knife") then
						tweenTo(plr.Character.HumanoidRootPart.CFrame)
					end
				end
				task.wait()
			end
		end)
	end
})

------------------------------------------------
-- TROLL
------------------------------------------------
local TrollTab = Window:CreateTab("Troll", 4483362458)
local TrollSection = TrollTab:CreateSection("Fling")

-- DROPDOWN PLAYERS
local function getPlayers()
	local list = {}
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			table.insert(list, p.Name)
		end
	end
	return list
end

TrollSection:CreateDropdown({
	Name = "Selecionar player",
	Options = getPlayers(),
	CurrentOption = nil,
	Callback = function(v)
		selectedPlayer = v
	end
})

Players.PlayerAdded:Connect(function()
	Rayfield:Notify({Title="Player entrou",Content="Atualize dropdown",Duration=2})
end)

-- FLING ESPECÍFICO
TrollSection:CreateToggle({
	Name = "Fling player específico",
	CurrentValue = false,
	Callback = function(v)
		flingSpecific = v
		task.spawn(function()
			while flingSpecific and selectedPlayer do
				local plr = Players:FindFirstChild(selectedPlayer)
				if plr and plr.Character then
					tweenTo(plr.Character.HumanoidRootPart.CFrame)
					LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(9999,9999,9999)
				end
				task.wait()
			end
		end)
	end
})

-- FLING ALL
TrollSection:CreateToggle({
	Name = "Fling all",
	CurrentValue = false,
	Callback = function(v)
		flingAll = v
		task.spawn(function()
			while flingAll do
				for _,plr in pairs(Players:GetPlayers()) do
					if plr ~= LocalPlayer and plr.Character then
						tweenTo(plr.Character.HumanoidRootPart.CFrame)
						LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(9999,9999,9999)
					end
				end
				task.wait()
			end
		end)
	end
})

-- TELEPORT GUN
TrollSection:CreateButton({
	Name = "Teleport Gun",
	Callback = function()
		local gun = workspace:FindFirstChild("GunDrop", true)
		if gun then
			LocalPlayer.Character:PivotTo(gun.CFrame)
		end
	end
})

-- AIMBOT KNIFE
TrollSection:CreateToggle({
	Name = "Aim bot Murderer",
	CurrentValue = false,
	Callback = function(v)
		aimBot = v
		RunService.RenderStepped:Connect(function()
			if not aimBot then return end
			for _,plr in pairs(Players:GetPlayers()) do
				if plr ~= LocalPlayer and plr.Character and plr.Backpack:FindFirstChild("Knife") then
					local dist = (plr.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
					if dist <= 100 then
						Camera.CFrame = CFrame.new(Camera.CFrame.Position, plr.Character.HumanoidRootPart.Position)
					end
				end
			end
		end)
	end
})

------------------------------------------------
-- CONFIGURAÇÃO
------------------------------------------------
local ConfigTab = Window:CreateTab("Configuração", 4483362458)
local ConfigSection = ConfigTab:CreateSection("Player")

-- ESP SHERIFF / KILLER
ConfigSection:CreateToggle({
	Name = "ESP Sheriff/Killer",
	CurrentValue = false,
	Callback = function(v)
		for _,plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				local h = Instance.new("Highlight", plr.Character)
				h.FillColor = Color3.fromRGB(0,0,255)
				if not v then h:Destroy() end
			end
		end
	end
})

-- ESP ASSASSINO
ConfigSection:CreateToggle({
	Name = "ESP Assassino",
	CurrentValue = false,
	Callback = function(v)
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Backpack:FindFirstChild("Knife") then
				local h = Instance.new("Highlight", plr.Character)
				h.FillColor = Color3.fromRGB(255,0,0)
				if not v then h:Destroy() end
			end
		end
	end
})

-- INFINITE JUMP
ConfigSection:CreateToggle({
	Name = "Infinite Jump",
	CurrentValue = false,
	Callback = function(v)
		infiniteJump = v
	end
})

UserInputService.JumpRequest:Connect(function()
	if infiniteJump then
		LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- SPEED
ConfigSection:CreateSlider({
	Name = "Velocidade",
	Range = {16,100},
	Increment = 1,
	CurrentValue = 16,
	Callback = function(v)
		speedValue = v
	end
})

ConfigSection:CreateToggle({
	Name = "Ativar velocidade",
	CurrentValue = false,
	Callback = function(v)
		speedEnabled = v
		RunService.Stepped:Connect(function()
			if speedEnabled then
				LocalPlayer.Character.Humanoid.WalkSpeed = speedValue
			end
		end)
	end
})

-- NOCLIP
ConfigSection:CreateToggle({
	Name = "Noclip",
	CurrentValue = false,
	Callback = function(v)
		setNoclip(v)
	end
})

------------------------------------------------
-- DISCORD
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
