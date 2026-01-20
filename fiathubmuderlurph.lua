------------------------------------------------
-- LOAD NOTHING UI
------------------------------------------------
local NothingLibrary = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/3345-c-a-t-s-u-s/NOTHING/main/source.lua"
))()

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
local Window = NothingLibrary.new({
	Title = "NOTHING",
	Description = "Auto Farms / Troll / Config",
	Keybind = Enum.KeyCode.LeftControl,
	Logo = "http://www.roblox.com/asset/?id=18898582662"
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
-- FARM PRINCIPAL
------------------------------------------------
local FarmTab = Window:NewTab({
	Title = "Farm principal",
	Icon = "rbxassetid://7733960981"
})

local FarmLeft = FarmTab:NewSection({
	Title = "Auto Farms",
	Position = "Left"
})

local FarmRight = FarmTab:NewSection({
	Title = "Informação",
	Position = "Right"
})

FarmRight:NewParagraph({
	Title = "Aviso",
	Description = "auto farms em beta ative só um"
})

------------------------------------------------
-- AUTO FARM COINS
------------------------------------------------
local farmCoins = false
FarmLeft:NewToggle({
	Title = "auto farm coins",
	Default = false,
	Callback = function(v)
		farmCoins = v
		setNoclip(v)

		task.spawn(function()
			while farmCoins do
				local closest, dist = nil, math.huge
				for _,obj in pairs(ReplicatedStorage:GetDescendants()) do
					if obj:IsA("BasePart") and (obj.Name:lower():find("coin") or obj.Name:lower():find("won")) then
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
FarmLeft:NewToggle({
	Title = "auto farm muder",
	Default = false,
	Callback = function(v)
		farmMurder = v
		setNoclip(v)

		task.spawn(function()
			while farmMurder do
				if LocalPlayer.Team and LocalPlayer.Team.Name == "Murderer" then
					for _,plr in pairs(Players:GetPlayers()) do
						if plr ~= LocalPlayer and plr.Team
						and (plr.Team.Name == "Sheriff" or plr.Team.Name == "Innocent")
						and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
							tweenTo(plr.Character.HumanoidRootPart.CFrame, 60)
						end
					end
				end
				task.wait(0.5)
			end
		end)
	end
})

------------------------------------------------
-- TROLL
------------------------------------------------
local TrollTab = Window:NewTab({
	Title = "Troll",
	Icon = "rbxassetid://7743869054"
})

local TrollSection = TrollTab:NewSection({
	Title = "Troll",
	Position = "Left"
})

local selectedTeam = "Murderer"

TrollSection:NewDropdown({
	Title = "Selecionar Team",
	Options = {"Murderer","Sheriff","Innocent"},
	Default = "Murderer",
	Callback = function(v)
		selectedTeam = v
	end
})

------------------------------------------------
-- FLING ESPECÍFICO
------------------------------------------------
local flingSpecific = false
TrollSection:NewToggle({
	Title = "fling player específico",
	Default = false,
	Callback = function(v)
		flingSpecific = v
		setNoclip(v)

		task.spawn(function()
			while flingSpecific do
				for _,plr in pairs(Players:GetPlayers()) do
					if plr.Team and plr.Team.Name == selectedTeam
					and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
						for i=1,20 do
							getHRP().CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(i*25), 0)
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
TrollSection:NewToggle({
	Title = "fling all",
	Default = false,
	Callback = function(v)
		flingAll = v
		setNoclip(v)

		task.spawn(function()
			while flingAll do
				for _,plr in pairs(Players:GetPlayers()) do
					if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
						for i=1,15 do
							getHRP().CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(i*30), 0)
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
TrollSection:NewButton({
	Title = "Teleport Gun",
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
TrollSection:NewToggle({
	Title = "aim bot Murderer",
	Default = false,
	Callback = function(v)
		aimBot = v
	end
})

RunService.RenderStepped:Connect(function()
	if aimBot then
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Team and plr.Team.Name == "Murderer"
			and plr.Character and plr.Character:FindFirstChild("Head") then
				local dist = (getHRP().Position - plr.Character.Head.Position).Magnitude
				if dist <= 110 then
					workspace.CurrentCamera.CFrame =
						CFrame.new(workspace.CurrentCamera.CFrame.Position, plr.Character.Head.Position)
				end
			end
		end
	end
end)

------------------------------------------------
-- CONFIGURAÇÃO
------------------------------------------------
local ConfigTab = Window:NewTab({
	Title = "Configuração",
	Icon = "rbxassetid://7733964719"
})

local ConfigSection = ConfigTab:NewSection({
	Title = "Player / ESP",
	Position = "Left"
})

------------------------------------------------
-- ESP
------------------------------------------------
local function espTeam(teamName, color)
	for _,plr in pairs(Players:GetPlayers()) do
		if plr.Team and plr.Team.Name == teamName
		and plr.Character and not plr.Character:FindFirstChild("ESP") then
			local h = Instance.new("Highlight", plr.Character)
			h.Name = "ESP"
			h.FillColor = color
			h.OutlineColor = color
		end
	end
end

ConfigSection:NewToggle({
	Title = "esp Murderer",
	Callback = function(v)
		if v then espTeam("Murderer", Color3.fromRGB(255,0,0)) end
	end
})

ConfigSection:NewToggle({
	Title = "esp sobrevivente",
	Callback = function(v)
		if v then espTeam("Innocent", Color3.fromRGB(0,255,0)) end
	end
})

ConfigSection:NewToggle({
	Title = "esp Sheriff",
	Callback = function(v)
		if v then espTeam("Sheriff", Color3.fromRGB(0,0,255)) end
	end
})

------------------------------------------------
-- INFINITE JUMP
------------------------------------------------
local infJump = false
ConfigSection:NewToggle({
	Title = "infinit pulo",
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
ConfigSection:NewSlider({
	Title = "Velocidade",
	Min = 16,
	Max = 100,
	Default = 16,
	Callback = function(v)
		speedValue = v
	end
})

ConfigSection:NewToggle({
	Title = "ativar velocidade",
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
					h.OutlineColor = Color3.fromRGB(0,0,255)
				end
			end
		end
	end
})

------------------------------------------------
-- DISCORD
------------------------------------------------
local DiscordTab = Window:NewTab({
	Title = "Discord",
	Icon = "rbxassetid://7733960981"
})

local DiscordSection = DiscordTab:NewSection({
	Title = "Info",
	Position = "Left"
})

DiscordSection:NewParagraph({
	Title = "Créditos",
	Description = "script feito por fiat"
})

DiscordSection:NewButton({
	Title = "get Discord",
	Callback = function()
		setclipboard("https://discord.gg/VGRmqRRz")
	end
})
