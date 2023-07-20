local MSSP = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MemoryStoreService = game:GetService("MemoryStoreService")
local ServersListStore = MemoryStoreService:GetSortedMap("ServersList")
local TeleportService = game:GetService("TeleportService")


local LoadServerListEvent = Instance.new("RemoteEvent")
LoadServerListEvent.Name = "LoadServerList"
LoadServerListEvent.Parent = ReplicatedStorage

local ActivateServerGuiEvent = Instance.new("RemoteEvent")
ActivateServerGuiEvent.Name = "ActivateServerGui"
ActivateServerGuiEvent.Parent = ReplicatedStorage

local SendChatMessageEvent = Instance.new("RemoteEvent")
SendChatMessageEvent.Name = "SendChatMessage"
SendChatMessageEvent.Parent = ReplicatedStorage

local LastServerInTheList = nil
local ShowPagination = false
local ServerList
local Page = 1

-- Create Server Admin GUI
local ServerAdmin = Instance.new("ScreenGui")
ServerAdmin.Name = "ServerAdmin"
ServerAdmin.IgnoreGuiInset = true
ServerAdmin.DisplayOrder = 1
ServerAdmin.ZIndexBehavior = Enum.ZIndexBehavior.Global
ServerAdmin.Enabled = false

local ServerAdminButtonGui = Instance.new("ScreenGui")
ServerAdminButtonGui.Name = "ServerAdminButtonGui"
ServerAdminButtonGui.IgnoreGuiInset = true
ServerAdminButtonGui.DisplayOrder = 2
ServerAdminButtonGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ServerAdminButtonGui.Enabled = true

local ServerAdminButton = Instance.new("TextButton")
ServerAdminButton.Name = "ServerAdminButton"
ServerAdminButton.AnchorPoint = Vector2.new(1,0)
ServerAdminButton.BackgroundTransparency = .5
ServerAdminButton.BackgroundColor3 = Color3.new(0, 0, 0)
ServerAdminButton.TextColor = BrickColor.new(1,1,1)
ServerAdminButton.Position = UDim2.new(1, -53, 0, 5)
ServerAdminButton.Size = UDim2.new(0, 85, 0, 30)
ServerAdminButton.Text = "Server Admin"
ServerAdminButton.Visible = true
ServerAdminButton.ZIndex = 10
ServerAdminButton.Parent = ServerAdminButtonGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(.3,.3)
UICorner.Parent = ServerAdminButton

local Background = Instance.new("Frame")
Background.BackgroundColor3 = Color3.fromRGB(141, 193, 238)
Background.Size = UDim2.new(1, 0, 1, 0)
Background.Name = "Background"
Background.Parent = ServerAdmin

local ServerListHeader = Instance.new("Frame")
ServerListHeader.AnchorPoint = Vector2.new(0,1)
ServerListHeader.BackgroundTransparency = 1
ServerListHeader.Position = UDim2.new(0.01, 0, 0.2, 0)
ServerListHeader.Size = UDim2.new(0, 263, 0, 30)
ServerListHeader.Name = "ServerListHeader"
ServerListHeader.Parent = ServerAdmin

local ServerListHeaderTitle = Instance.new("TextLabel")
ServerListHeaderTitle.AnchorPoint = Vector2.new(0,0)
ServerListHeaderTitle.BackgroundTransparency = 1
ServerListHeaderTitle.Size = UDim2.new(0.5, 0, 1, 0)
ServerListHeaderTitle.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json")
ServerListHeaderTitle.TextColor = BrickColor.new(255, 255, 255)
ServerListHeaderTitle.TextSize = 20
ServerListHeaderTitle.Text = "Active Servers"
ServerListHeaderTitle.Name = "ServerListHeaderTitle"
ServerListHeaderTitle.Parent = ServerListHeader

local RefreshButton = Instance.new("ImageButton")
RefreshButton.AnchorPoint = Vector2.new(1,0)
RefreshButton.BackgroundTransparency = 1
RefreshButton.Position = UDim2.new(0.98, 0, 0.1, 0)
RefreshButton.Size = UDim2.new(0, 25, 0, 25)
RefreshButton.Image = "rbxassetid://13969262797"
RefreshButton.Name = "RefreshButton"
RefreshButton.Parent = ServerListHeader

local ServerList = Instance.new("ScrollingFrame")
ServerList.AnchorPoint = Vector2.new(0,0)
ServerList.BackgroundTransparency = 1
ServerList.Position = UDim2.new(0.01, 0, 0.2, 0)
ServerList.Size = UDim2.new(0, 263, 0.8, 0)
ServerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
ServerList.ScrollBarThickness = 0
ServerList.ScrollingDirection = Enum.ScrollingDirection.Y
ServerList.Name = "ServerList"
ServerList.Parent = ServerAdmin

local ServerListUIListLayout = Instance.new("UIListLayout")
ServerListUIListLayout.Padding = UDim.new(0,3)
ServerListUIListLayout.FillDirection = Enum.FillDirection.Vertical
ServerListUIListLayout.SortOrder = Enum.SortOrder.Name
ServerListUIListLayout.Name = "ServerListUIListLayout"
ServerListUIListLayout.Parent = ServerList

local Server = Instance.new("Frame")
Server.AnchorPoint = Vector2.new(0,0)
Server.BackgroundTransparency = .9
Server.Position = UDim2.new(0.01, 0, 0.2, 0)
Server.Size = UDim2.new(1, 0, 0, 55)
Server.Visible = false
Server.Name = "Server"
Server.Parent = ServerList

--local RemoveServer = Instance.new("ImageButton")
--RemoveServer.AnchorPoint = Vector2.new(1,1)
--RemoveServer.BackgroundTransparency = 1
--RemoveServer.Position = UDim2.new(0.96, 0, 0.9, 0)
--RemoveServer.Size = UDim2.new(0, 45, 0, 45)
--RemoveServer.Image = "rbxassetid://13967004049"
--RemoveServer.Name = "RemoveServer"
--RemoveServer.Parent = Server

local JesusLabel = Instance.new("TextLabel")
JesusLabel.AnchorPoint = Vector2.new(1,0)
JesusLabel.BackgroundTransparency = 1
JesusLabel.Position = UDim2.new(0.52, 0, .75, 0)
JesusLabel.Size = UDim2.new(0.5, 0, .25, 0)
JesusLabel.FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Bold)
JesusLabel.TextColor = BrickColor.new(255, 255, 255)
JesusLabel.TextSize = 14
JesusLabel.Text = "Jesus?"
JesusLabel.Name = "JesusLabel"
JesusLabel.Parent = Server

local PlayersLabel = Instance.new("TextLabel")
PlayersLabel.AnchorPoint = Vector2.new(1,0)
PlayersLabel.BackgroundTransparency = 1
PlayersLabel.Position = UDim2.new(0.52, 0, .5, 0)
PlayersLabel.Size = UDim2.new(0.5, 0, .25, 0)
PlayersLabel.FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Bold)
PlayersLabel.TextColor = BrickColor.new(255, 255, 255)
PlayersLabel.TextSize = 14
PlayersLabel.Text = "Players: "
PlayersLabel.Name = "PlayersLabel"
PlayersLabel.Parent = Server

local ServerIdLabel = Instance.new("TextLabel")
ServerIdLabel.AnchorPoint = Vector2.new(1,0)
ServerIdLabel.BackgroundTransparency = 1
ServerIdLabel.Position = UDim2.new(0.52, 0, 0, 0)
ServerIdLabel.Size = UDim2.new(0.5, 0, .25, 0)
ServerIdLabel.FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Bold)
ServerIdLabel.TextColor = BrickColor.new(255, 255, 255)
ServerIdLabel.TextSize = 14
ServerIdLabel.Text = "ServerId: "
ServerIdLabel.Name = "ServerIdLabel"
ServerIdLabel.Parent = Server

local MapLabel = Instance.new("TextLabel")
MapLabel.AnchorPoint = Vector2.new(1,0)
MapLabel.BackgroundTransparency = 1
MapLabel.Position = UDim2.new(0.52, 0, .25, 0)
MapLabel.Size = UDim2.new(0.5, 0, .25, 0)
MapLabel.FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Bold)
MapLabel.TextColor = BrickColor.new(255, 255, 255)
MapLabel.TextSize = 14
MapLabel.Text = "ServerId: "
MapLabel.Name = "MapLabel"
MapLabel.Parent = Server

function MSSP.LoadGui(player)
	local ServerAdminClone = ServerAdmin:Clone()
	ServerAdminClone.Parent = player.PlayerGui
	local ServerAdminButtonGuiClone = ServerAdminButtonGui:Clone()
	ServerAdminButtonGuiClone.Parent = player.PlayerGui
	ServerAdminButtonGuiClone.Enabled = true
	return player.PlayerGui.ServerAdmin
end

-- Send Chat Message
local function SendChatMessage(player, text)
	SendChatMessageEvent:FireClient(player, text)
end

-- Find the first available Server and teleport.
local function LoadServerList(player)

	local gui = player.PlayerGui.ServerAdmin
	-- Delete all the Existing ServerList Items
	local ExistingServerList = gui.ServerList:GetChildren()
	for count, item in ipairs(ExistingServerList) do
		if item.Name ~= "ServerListUIListLayout" and item.Name ~= "Server" then
			item:Destroy()
		end
	end
	-- Get a list of 10 Servers per page
	local ServersPageSize = 10
	local GetServersSuccess, GetServersResult = pcall(function()
		ServerList = ServersListStore:GetRangeAsync(Enum.SortDirection.Ascending, ServersPageSize, LastServerInTheList)
		return ServerList
	end)
	--Set the last item of the page so our server pages display
	if GetServersSuccess == true and Page ~= 1 then
		LastServerInTheList = ServerList[#ServerList * page]
	end
	-- Show pagination if there are 10 items
	if GetServersSuccess == true and #ServerList == 10 then
		ShowPagination = true
	end
	-- If the Sorted Map Contains Servers
	if GetServersSuccess == true then
		-- Loop through the list and create a server list gui item
		SendChatMessage(player, #GetServersResult.." Servers Found")
		for count, item in ipairs(GetServersResult) do
			local ServerId = item["key"]
			local ServerInfo = item["value"]
			SendChatMessage(player, item["key"])
			SendChatMessage(player, item["value"]["PlaceId"])
			-- read the memory queue to get the number of players in the server
			local ReadSuccess, items, id = pcall(function()
				local ServerQueue = MemoryStoreService:GetQueue(ServerId)
				local result  = ServerQueue:ReadAsync(1, true, 30)
				return result
			end)
			-- Create the Server List Item
			if ReadSuccess and #items > 0 then
				local PlayersInServer = #ServerInfo["Players"]
				local ServerListItem = gui.ServerList.Server:Clone()
				ServerListItem.Name = ServerId
				ServerListItem.ServerIdLabel.Text ="ServerId: ".. ServerId
				ServerListItem.MapLabel.Text = "Server Name: ".. ServerInfo["ServerName"]
				ServerListItem.PlayersLabel.Text = "Players: ".. PlayersInServer
				
				ServerListItem.Parent = gui.ServerList
				ServerListItem.Visible = true
			end
			wait(.01)
		end
	end
	-- If there are no servers in the Memory Sorted Map then just teleport to the place
	if GetServersSuccess == false then

	end
end

local LastServerInTheList = nil
-- Find the first available Server and teleport.
function MSSP.TeleportToFirstAvailableServer(player, PlaceId)
	local ServersPageSize = 10
	local FoundMatch = false
	-- Pull a list of Available Servers from Memory Sorted Map
	local GetServersSuccess, GetServersResult = pcall(function()
		return ServersListStore:GetRangeAsync(Enum.SortDirection.Ascending, ServersPageSize, LastServerInTheList)
	end)
	-- If the Sorted Map Contains Servers
	if GetServersSuccess == true then
		SendChatMessage(player, #GetServersResult .." Servers Found")
		for count, item in ipairs(GetServersResult) do
			SendChatMessage(player, count)
			SendChatMessage(player, item["value"]["Players"])
			local ServerId = item["key"]
			if ServerId ~= "0" then
				local ServerInfo = item["value"]
					if #ServerInfo["Players"] > 1 and #ServerInfo["Players"] < ServerInfo["MaxServerPlayers"] then
					FoundMatch = true
					SendChatMessage(player, "Found Server: "..ServerId.. " with ".. #ServerInfo["Players"] .. " players in the queue.")
					local TeleportOptions = Instance.new("TeleportOptions")
					TeleportOptions.ServerInstanceId = ServerId
					local Result = TeleportService:TeleportAsync(ServerInfo["PlaceId"], {player}, TeleportOptions)
					SendChatMessage(player, Result)
				end
				wait(1)
			end
		end
		local Result = TeleportService:TeleportAsync(PlaceId, {player})
		SendChatMessage(player, Result)
	end
end

function ActivateServerGui(player, isActive)
	player.PlayerGui.ServerAdmin.Enabled = not player.PlayerGui.ServerAdmin.Enabled
end

LoadServerListEvent.OnServerEvent:Connect(LoadServerList)
ActivateServerGuiEvent.OnServerEvent:Connect(ActivateServerGui)

return MSSP
