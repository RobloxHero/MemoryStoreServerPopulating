
local MapName
local MaxServerPlayers = 0
local ServerType = "Lobby"
local ServerButtonImgs = {["Lobby"] = "rbxassetid://14103087924", ["Game"] = "rbxassetid://14103088087"}
local MSSPVersion = "Dev"
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayerscripts = game:GetService("StarterPlayer").StarterPlayerScripts
local HttpService = game:GetService("HttpService")

local function GetBranches()
	local result = HttpService:GetAsync('https://api.github.com/repos/RobloxHero/MemoryStoreServerPopulating/branches')
	return HttpService:JSONDecode(result)
end

for count, file in pairs(ServerScriptService:GetChildren()) do
	if file.Name == "MSSP-Lobby-Module" then
		ServerType = "Lobby"
	end
	if file.Name == "MSSP-Game-Module" then
		ServerType = "Game"
	end
end

local function GetFileFromGithub(name)
	
	local MSSPModuleUrl = "https://raw.githubusercontent.com/RobloxHero/MemoryStoreServerPopulating/" .. MSSPVersion  ..  "/MSSP-"..ServerType.."-Module.lua"
	local MSSPLocalscriptUrl = "https://raw.githubusercontent.com/RobloxHero/MemoryStoreServerPopulating/" .. MSSPVersion ..  "/MSSP-"..ServerType.."-Localscript.lua"
	
	if name == "MSSP-"..ServerType.."-Module" then
		local NewFile = HttpService:GetAsync(MSSPModuleUrl)
		local MSSPLobbyModule = Instance.new("ModuleScript")
		MSSPLobbyModule.Name = "MSSP-"..ServerType.."-Module"
		MSSPLobbyModule.Source = NewFile
		MSSPLobbyModule.Parent = ServerScriptService
	end
	if name == "MSSP-"..ServerType.."-Localscript" then
		local NewFile = HttpService:GetAsync(MSSPLocalscriptUrl)
		local MSSPLobbyLocalscript = Instance.new("LocalScript")
		MSSPLobbyLocalscript.Name = "MSSP-"..ServerType.."-Localscript"
		MSSPLobbyLocalscript.Source = NewFile
		MSSPLobbyLocalscript.Parent = StarterPlayerscripts
	end
end

-- Make the request to our endpoint URL
local function FileUpdate()
	for count, file in pairs(ServerScriptService:GetChildren()) do
		if file.Name == "MSSP-"..ServerType.."-Module" then
			file:Destroy()
		end
	end
	GetFileFromGithub("MSSP-"..ServerType.."-Module")
	for count, file in pairs(StarterPlayerscripts:GetChildren()) do
		if file.Name == "MSSP-"..ServerType.."-Localscript" then
			file:Destroy()
		end
	end
	GetFileFromGithub("MSSP-"..ServerType.."-Localscript")
end

local toolbar = plugin:CreateToolbar("MSSP")
local info = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,
	false,
	true,
	200,
	300
)
local gui = plugin:CreateDockWidgetPluginGui("Memory Store Server Populating", info)
gui.Enabled = true
gui.Title = "Memory Store Server Populating"

local function ChangeServerType(LobbyButton, ServerButton, GameButton)
	if ServerType == "Lobby" then
		ServerType = "Game"
		ServerButton.Image = ServerButtonImgs["Game"]
		GameButton.TextColor = BrickColor.new(0.319554, 1, 0.336568)
		LobbyButton.TextColor = BrickColor.new(0, 0, 0)
	else 
		ServerType = "Lobby"
		ServerButton.Image = ServerButtonImgs["Lobby"]
		GameButton.TextColor = BrickColor.new(0, 0, 0)
		LobbyButton.TextColor = BrickColor.new(0.303197, 0.701076, 0.967132)
	end
end

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 0)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollingFrame.CanvasSize = UDim2.new(1, 0, 2, 0)
ScrollingFrame.Parent = gui

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0,5)
UIList.FillDirection = Enum.FillDirection.Vertical
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.VerticalAlignment = Enum.VerticalAlignment.Top
UIList.Parent = ScrollingFrame

-- Server Type
local ServerTypeLabel = Instance.new("TextLabel")
ServerTypeLabel.AnchorPoint = Vector2.new(.5, .5)
ServerTypeLabel.Size = UDim2.new(1, 0, 0, 20)
ServerTypeLabel.Position = UDim2.new(.5, 0, .5, 0)
ServerTypeLabel.BackgroundTransparency = 1
ServerTypeLabel.TextColor = BrickColor.new(1, 1, 1)
ServerTypeLabel.TextXAlignment = Enum.TextXAlignment.Center
ServerTypeLabel.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json")
ServerTypeLabel.TextSize = 18
ServerTypeLabel.Text = "Server Type"
ServerTypeLabel.Parent = ScrollingFrame

local ServerTypeBackground = Instance.new("Frame")
ServerTypeBackground.AnchorPoint = Vector2.new(0, 0)
ServerTypeBackground.Size = UDim2.new(1,0, 0, 45)
ServerTypeBackground.BackgroundColor3 = Color3.new(1, 1, 1)
ServerTypeBackground.Transparency = .9
ServerTypeBackground.Parent = ScrollingFrame

local LobbyLabel = Instance.new("TextButton")
LobbyLabel.AnchorPoint = Vector2.new(0,.5)
LobbyLabel.Size = UDim2.new(.3, 0, 0, 20)
LobbyLabel.Position = UDim2.new(0, 0, 0.5, 0)
LobbyLabel.BackgroundTransparency = 1
if ServerType == 'Lobby' then
	LobbyLabel.TextColor = BrickColor.new(0.303197, 0.701076, 0.967132)

end
if ServerType == "Game" then
	LobbyLabel.TextColor = BrickColor.new(0, 0, 0)

end
LobbyLabel.TextXAlignment = Enum.TextXAlignment.Center
LobbyLabel.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json")
LobbyLabel.TextSize = 24
LobbyLabel.Text = "Lobby"
LobbyLabel.Parent = ServerTypeBackground

local ServerButton = Instance.new("ImageButton")
ServerButton.AnchorPoint = Vector2.new(0,.5)
ServerButton.Size = UDim2.new(.3, 0, 0, 35)
ServerButton.Position = UDim2.new(0.345, 0, 0.5, 0)
ServerButton.BackgroundTransparency = 1
ServerButton.Image = ServerButtonImgs[ServerType]
ServerButton.ScaleType = Enum.ScaleType.Fit
ServerButton.Visible = true
ServerButton.Parent = ServerTypeBackground

local GameLabel = Instance.new("TextButton")
GameLabel.AnchorPoint = Vector2.new(0,.5)
GameLabel.Size = UDim2.new(.3, 0, 0, 20)
GameLabel.Position = UDim2.new(0.66, 0, 0.5, 0)
GameLabel.BackgroundTransparency = 1
if ServerType == "Lobby" then
	GameLabel.TextColor = BrickColor.new(0, 0, 0)

end
if ServerType == "Game" then
	GameLabel.TextColor = BrickColor.new(0.319554, 1, 0.336568)

end
GameLabel.TextXAlignment = Enum.TextXAlignment.Center
GameLabel.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json")
GameLabel.TextSize = 24
GameLabel.Text = "Game"
GameLabel.Parent = ServerTypeBackground

LobbyLabel.MouseButton1Click:Connect(function()
	ChangeServerType(LobbyLabel, ServerButton, GameLabel)
end)
ServerButton.MouseButton1Click:Connect(function()
	ChangeServerType(LobbyLabel, ServerButton, GameLabel)
end)
GameLabel.MouseButton1Click:Connect(function()
	ChangeServerType(LobbyLabel, ServerButton, GameLabel)
end)

-- select Gihub Branch
local BranchLabel = Instance.new("TextLabel")
BranchLabel.AnchorPoint = Vector2.new(.5, .5)
BranchLabel.Size = UDim2.new(1, 0, 0, 20)
BranchLabel.Position = UDim2.new(.5, 0, .5, 0)
BranchLabel.BackgroundTransparency = 1
BranchLabel.TextColor = BrickColor.new(1, 1, 1)
BranchLabel.TextXAlignment = Enum.TextXAlignment.Center
BranchLabel.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json")
BranchLabel.TextSize = 18
BranchLabel.Text = "Select Gihub Branch"
BranchLabel.Parent = ScrollingFrame

local BranchBackground = Instance.new("Frame")
BranchBackground.AnchorPoint = Vector2.new(0, 0)
BranchBackground.Size = UDim2.new(1,0, 0, 45)
BranchBackground.BackgroundColor3 = Color3.new(1, 1, 1)
BranchBackground.Transparency = .9
BranchBackground.Parent = ScrollingFrame


local BranchButton = Instance.new("TextButton")
BranchButton.AnchorPoint = Vector2.new(.5,.5)
BranchButton.Size = UDim2.new(0, 175, 0, 35)
BranchButton.Position = UDim2.new(0.5, 0, 0.5, 0)
BranchButton.BackgroundColor3 = Color3.new(1, 1, 1)
BranchButton.TextColor = BrickColor.new(0.180392, 0.180392, 0.180392)
BranchButton.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json")
BranchButton.TextSize = 24
BranchButton.Text = MSSPVersion

local BranchesFrameBackground = Instance.new("Frame")
BranchesFrameBackground.Size = UDim2.new(1,0,1,0)
BranchesFrameBackground.AnchorPoint = Vector2.new(0,0)
BranchesFrameBackground.Position = UDim2.new(0, 0, 0, 0)
BranchesFrameBackground.BackgroundColor3 = Color3.new(0,0,0)
BranchesFrameBackground.Transparency = .5
BranchesFrameBackground.ZIndex = 9
BranchesFrameBackground.Visible = false


local BranchesFrame = Instance.new("Frame")
BranchesFrame.Size = UDim2.new(0,175,3,0)
BranchesFrame.AnchorPoint = Vector2.new(.5,.5)
BranchesFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
BranchesFrame.BackgroundColor3 = Color3.new(1,1,1)
BranchesFrame.ZIndex = 10
BranchesFrame.Visible = false

local BranchesUIList = Instance.new("UIListLayout")
BranchesUIList.Padding = UDim.new(0,5)
BranchesUIList.FillDirection = Enum.FillDirection.Vertical
BranchesUIList.SortOrder = Enum.SortOrder.LayoutOrder
BranchesUIList.VerticalAlignment = Enum.VerticalAlignment.Center
BranchesUIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

BranchButton.Parent = BranchBackground
BranchesFrameBackground.Parent = gui
BranchesFrame.Parent = BranchBackground
BranchesUIList.Parent = BranchesFrame

local Branches = GetBranches()
for count, branch in pairs(Branches) do
	local Button = Instance.new("TextButton")
	Button.Name = branch.name
	Button.AnchorPoint = Vector2.new(.5,.5)
	Button.Size = UDim2.new(1, 0, 0, 25)
	Button.BackgroundColor3 = Color3.new(1, 1, 1)
	Button.BackgroundTransparency = .7
	Button.TextColor = BrickColor.new(0.180392, 0.180392, 0.180392)
	Button.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json")
	Button.TextSize = 24
	Button.Text = branch.name
	Button.MouseButton1Click:Connect(function()
		MSSPVersion = branch.name
		BranchesFrame.Visible = false
		BranchesFrameBackground.Visible = false
		BranchButton.Text = branch.name
	end)
	Button.ZIndex = 10
	Button.Parent = BranchesFrame
end

BranchButton.MouseButton1Click:Connect(function()
	BranchesFrame.Visible = true
	BranchesFrameBackground.Visible = true
end)

-- Update from Github
local UpdateBackground = Instance.new("Frame")
UpdateBackground.AnchorPoint = Vector2.new(0, 0)
UpdateBackground.Size = UDim2.new(1,0, 0, 45)
UpdateBackground.BackgroundColor3 = Color3.new(1, 1, 1)
UpdateBackground.Transparency = .9
UpdateBackground.Parent = ScrollingFrame


local UpdateButton = Instance.new("TextButton")
UpdateButton.AnchorPoint = Vector2.new(.5,.5)
UpdateButton.Size = UDim2.new(0, 125, 0, 35)
UpdateButton.Position = UDim2.new(0.5, 0, 0.5, 0)
UpdateButton.BackgroundColor3 = Color3.new(0.540261, 0.986862, 0.686671)
UpdateButton.TextColor = BrickColor.new(0.180392, 0.180392, 0.180392)
UpdateButton.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json")
UpdateButton.TextSize = 24
UpdateButton.Text = "Update"

UpdateButton.MouseButton1Click:Connect(function()
	FileUpdate()
end)

UpdateButton.Parent = UpdateBackground

local GiveThanksToJesus = Instance.new("TextLabel")
GiveThanksToJesus.AnchorPoint = Vector2.new(.5, .5)
GiveThanksToJesus.Size = UDim2.new(1, 0, 0, 20)
GiveThanksToJesus.Position = UDim2.new(.5, 0, .5, 0)
GiveThanksToJesus.BackgroundTransparency = 1
GiveThanksToJesus.TextColor = BrickColor.new(1, 1, 1)
GiveThanksToJesus.TextXAlignment = Enum.TextXAlignment.Center
GiveThanksToJesus.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json")
GiveThanksToJesus.TextSize = 18
GiveThanksToJesus.Text = "Give \u{0001F49C} to Jesus"
GiveThanksToJesus.ZIndex = 10
GiveThanksToJesus.Parent = ScrollingFrame


local OpenWindowButton = toolbar:CreateButton("OpenWindow", "Open Window", "rbxassetid://14112128998", "Open Window") 
OpenWindowButton:SetActive(true)
OpenWindowButton.Click:Connect(function()
	gui.Enabled = not gui.Enabled
end)

gui:BindToClose(function()
	OpenWindowButton:SetActive(false)
end)



