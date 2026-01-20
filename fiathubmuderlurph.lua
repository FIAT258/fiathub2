-- NOTHING UI
local NothingLibrary = loadstring(game:HttpGetAsync(
    'https://raw.githubusercontent.com/3345-c-a-t-s-u-s/NOTHING/main/source.lua'
))()

-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- ATUALIZA CHAR
LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
	HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
	Humanoid = char:WaitForChild("Humanoid")
end)

------------------------------------------------
-- WINDOW
------------------------------------------------
local Window = NothingLibrary.new({
	Title = "FIAT HUB (murderr mysty)",
	Description = "FIAT HUB aura+ego",
	Keybind = Enum.KeyCode.LeftControl,
	Logo = "http://www.roblox.com/asset/?id=18898582662"
})

------------------------------------------------
-- FUNÇÕES ÚTEIS
------------------------------------------------
local function setNoclip(state)
	RunService.Stepped:Connect(function()
		if state and Character then
			for _,v in pairs(Character:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end
	end)
end

local function tweenTo(cf, speed)
	local dist = (HumanoidRootPart.Position - cf.Position).Magnitude
	local tween = TweenService:Create(
		HumanoidRootPart,
		TweenInfo.new(dist / speed, Enum.EasingStyle.Linear),
		{CFrame = cf}
	)
	tween:Play()
	return tween
end

------------------------------------------------
-- ABA FARM PRINCIPAL
------------------------------------------------
local FarmTab = Window:NewTab({
	Title = "Farm principal",
	Icon = "rbxassetid://7733960981"
})

local FarmSection = FarmTab:NewSection({
	Title = "Auto Farms",
	Position = "Left"
})

local InfoSection = FarmTab:NewSection({
	Title = "Informação",
	Position = "Right"
})

InfoSection:NewLabel({
	Text = "auto farms em beta ative só um"
})

------------------------------------------------
-- AUTO FARM COINS
------------------------------------------------
local AutoFarmCoins = false
local coinTween

FarmSection:NewToggle({
	Title = "auto farm coins",
	Default = false,
	Callback = function(state)
		AutoFarmCoins = state
		setNoclip(state)

		task.spawn(function()
			while AutoFarmCoins do
				local closest
				local dist = math.huge

				for _,v in pairs(ReplicatedStorage:GetDescendants()) do
					if v:IsA("BasePart") and (v.Name:lower():find("coin") or v.Name:lower():find("won")) then
						local d = (HumanoidRootPart.Position - v.Position).Magnitude
						if d < dist then
							dist = d
							closest = v
						end
					end
				end

				if closest then
					coinTween = tweenTo(closest.CFrame + Vector3.new(0,3,0), 40)
					coinTween.Completed:Wait()
					task.wait(2)
				else
					tweenTo(CFrame.new(0,-200,0), 40)
					task.wait(2)
				end
			end
			if coinTween then coinTween:Cancel() end
		end)
	end
})

------------------------------------------------
-- AUTO FARM MURDER
------------------------------------------------
local AutoFarmMurder = false

FarmSection:NewToggle({
	Title = "auto farm muder",
	Default = false,
	Callback = function(state)
		AutoFarmMurder = state
		setNoclip(state)

		task.spawn(function()
			while AutoFarmMurder do
				if LocalPlayer.Team and LocalPlayer.Team.Name == "Murderer" then
					keypress(0x31) -- tecla 1
					for _,plr in pairs(Players:GetPlayers()) do
						if plr ~= LocalPlayer and plr.Team 
						and (plr.Team.Name == "Sheriff" or plr.Team.Name == "Innocent") then
							if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
								tweenTo(plr.Character.HumanoidRootPart.CFrame, 60)
								for i=1,10 do
									mouse1click()
									task.wait(0.1)
								end
							end
						end
					end
				end
				task.wait(0.5)
			end
		end)
	end
})

------------------------------------------------
-- ABA TROLL
------------------------------------------------
local TrollTab = Window:NewTab({
	Title = "Troll",
	Icon = "rbxassetid://7743869054"
})

local TrollSection = TrollTab:NewSection({
	Title = "Fling",
	Position = "Left"
})

local selectedTeam = "Murderer"

TrollSection:NewDropdown({
	Title = "Selecionar Team",
	Options = {"Murderer","Sheriff","Innocent"},
	Default = "Murderer",
	Callback = function(val)
		selectedTeam = val
	end
})

------------------------------------------------
-- FLING ESPECÍFICO
------------------------------------------------
local FlingSpecific = false

TrollSection:NewToggle({
	Title = "fling player específico",
	Default = false,
	Callback = function(state)
		FlingSpecific = state
		setNoclip(state)

		task.spawn(function()
			while FlingSpecific do
				for _,plr in pairs(Players:GetPlayers()) do
					if plr.Team and plr.Team.Name == selectedTeam and plr.Character then
						local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
						if hrp then
							for i=1,20 do
								HumanoidRootPart.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(i*30), 0)
								task.wait()
							end
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
local FlingAll = false

TrollSection:NewToggle({
	Title = "fling all",
	Default = false,
	Callback = function(state)
		FlingAll = state
		setNoclip(state)

		task.spawn(function()
			while FlingAll do
				for _,plr in pairs(Players:GetPlayers()) do
					if plr ~= LocalPlayer and plr.Character then
						local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
						if hrp then
							for i=1,15 do
								HumanoidRootPart.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(i*25), 0)
								task.wait()
							end
						end
					end
				end
				task.wait()
			end
		end)
	end
})

------------------------------------------------
-- BOTÃO PEGAR GUN
------------------------------------------------
TrollSection:NewButton({
	Title = "Teleport Gun",
	Callback = function()
		for _,v in pairs(ReplicatedStorage:GetDescendants()) do
			if v:IsA("BasePart") and v.Name == "Gun" then
				HumanoidRootPart.CFrame = v.CFrame
			end
		end
	end
})

------------------------------------------------
-- AIMBOT MURDER
------------------------------------------------
local AimBot = false

TrollSection:NewToggle({
	Title = "aim bot Murderer",
	Default = false,
	Callback = function(state)
		AimBot = state
	end
})

RunService.RenderStepped:Connect(function()
	if AimBot then
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team and plr.Team.Name == "Murderer"
			and plr.Character and plr.Character:FindFirstChild("Head") then
				local dist = (HumanoidRootPart.Position - plr.Character.Head.Position).Magnitude
				if dist <= 110 then
					workspace.CurrentCamera.CFrame =
						CFrame.new(workspace.CurrentCamera.CFrame.Position, plr.Character.Head.Position)
				end
			end
		end
	end
end)

------------------------------------------------
-- ABA CONFIGURAÇÃO
------------------------------------------------
local ConfigTab = Window:NewTab({
	Title = "Configuração",
	Icon = "rbxassetid://7733964719"
})

local ConfigSection = ConfigTab:NewSection({
	Title = "ESP / Player",
	Position = "Left"
})

------------------------------------------------
-- ESP FUNÇÃO
------------------------------------------------
local function applyESP(teamName, color)
	for _,plr in pairs(Players:GetPlayers()) do
		if plr.Team and plr.Team.Name == teamName and plr.Character then
			if not plr.Character:FindFirstChild("ESP") then
				local h = Instance.new("Highlight", plr.Character)
				h.Name = "ESP"
				h.FillColor = color
				h.OutlineColor = color
			end
		end
	end
end

ConfigSection:NewToggle({
	Title = "esp Murderer",
	Callback = function(v)
		if v then applyESP("Murderer", Color3.fromRGB(255,0,0)) end
	end
})

ConfigSection:NewToggle({
	Title = "esp sobrevivente",
	Callback = function(v)
		if v then applyESP("Innocent", Color3.fromRGB(0,255,0)) end
	end
})

ConfigSection:NewToggle({
	Title = "esp Sheriff",
	Callback = function(v)
		if v then applyESP("Sheriff", Color3.fromRGB(0,0,255)) end
	end
})

------------------------------------------------
-- INFINITE JUMP
------------------------------------------------
local InfJump = false
ConfigSection:NewToggle({
	Title = "infinit pulo",
	Callback = function(v)
		InfJump = v
	end
})

UserInputService.JumpRequest:Connect(function()
	if InfJump then
		Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

------------------------------------------------
-- SPEED
------------------------------------------------
local SpeedValue = 16

ConfigSection:NewSlider({
	Title = "Velocidade",
	Min = 16,
	Max = 100,
	Default = 16,
	Callback = function(v)
		SpeedValue = v
	end
})

ConfigSection:NewToggle({
	Title = "ativar velocidade",
	Callback = function(v)
		RunService.Heartbeat:Connect(function()
			if v then
				Humanoid.WalkSpeed = SpeedValue
			end
		end)
	end
})

------------------------------------------------
-- NOCLIP
------------------------------------------------
ConfigSection:NewToggle({
	Title = "noclip",
	Callback = function(v)
		setNoclip(v)
	end
})

------------------------------------------------
-- ESP GUN
------------------------------------------------
ConfigSection:NewToggle({
	Title = "esp gun",
	Callback = function(v)
		if v then
			for _,g in pairs(ReplicatedStorage:GetDescendants()) do
				if g:IsA("BasePart") and g.Name == "Gun" then
					local h = Instance.new("Highlight", g)
					h.FillColor = Color3.fromRGB(0,0,255)
				end
			end
		end
	end
})

------------------------------------------------
-- ABA DISCORD
------------------------------------------------
local DiscordTab = Window:NewTab({
	Title = "Discord",
	Icon = "rbxassetid://7733960981"
})

local DiscordSection = DiscordTab:NewSection({
	Title = "Info",
	Position = "Left"
})

DiscordSection:NewLabel({
	Text = "script feito por fiat"
})

DiscordSection:NewButton({
	Title = "get Discord",
	Callback = function()
		setclipboard("https://discord.gg/VGRmqRRz")
	end
})
