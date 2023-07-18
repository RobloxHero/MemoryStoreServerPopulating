local MSSP = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MemoryStoreService = game:GetService("MemoryStoreService")
local ServersListStore = MemoryStoreService:GetSortedMap("ServersList")
local TeleportService = game:GetService("TeleportService")

-- module Attributes
script:SetAttribute("MaxServerPlayers", 10)
script:SetAttribute("MapName", "Map 1")

MSSP.MapName = ""

local LoadServerListEvent = Instance.new("RemoteEvent")
LoadServerListEvent.Name = "LoadServerList"
LoadServerListEvent.Parent = ReplicatedStorage

local LastServerInTheList = nil
local ShowPagination = false
local ServerList
local Page = 1

-- Create Server Admin GUI
local ServerAdmin = Instance.new("ScreenGui")
ServerAdmin.Name = "ServerAdmin"
ServerAdmin.IgnoreGuiInset = true
ServerAdmin.Enabled = false


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

local RemoveServer = Instance.new("ImageButton")
RemoveServer.AnchorPoint = Vector2.new(1,1)
RemoveServer.BackgroundTransparency = 1
RemoveServer.Position = UDim2.new(0.96, 0, 0.9, 0)
RemoveServer.Size = UDim2.new(0, 45, 0, 45)
RemoveServer.Image = "rbxassetid://13967004049"
RemoveServer.Name = "RemoveServer"
RemoveServer.Parent = Server

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
	return player.PlayerGui.ServerAdmin
end

-- Send Chat Message
local function SendChatMessage(text)
	--local formattedText = string.format("<font face='Roboto' size='18' color='#ecf072'><strong>%s</strong></font>", text)
	print(text)
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
		SendChatMessage(#GetServersResult.." Servers Found")
		for count, item in ipairs(GetServersResult) do
			local ServerId = item["key"]
			local PlaceId = tonumber(item["value"])
			-- read the memory queue to get the number of players in the server
			local ReadSuccess, items, id = pcall(function()
				local ServerQueue = MemoryStoreService:GetQueue(ServerId)
				local result  = ServerQueue:ReadAsync(1, true, 30)
				return result
			end)
			-- Create the Server List Item
			if ReadSuccess and #items > 0 then
				local PlayersInQueue = tonumber(items[1])
				local ServerListItem = gui.ServerList.Server:Clone()
				ServerListItem.Name = ServerId
				ServerListItem.ServerIdLabel.Text ="ServerId: ".. ServerId
				ServerListItem.MapLabel.Text = "PlaceID: ".. PlaceId
				ServerListItem.PlayersLabel.Text = "Players: ".. items[1]
				-- Remove server button then reload the list when the button is clicked
				ServerListItem.RemoveServer.MouseButton1Click:Connect(function()
					local GetServersSuccess, GetServersResult = pcall(function()
						local ServerList = ServersListStore:RemoveAsync(ServerId)
						return ServerList
					end)
					if GetServersSuccess == true then
						LoadServerList(Page)
					end
				end)
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
 function MSSP.TeleportToFirstAvailableServer(player, map)
	local ServersPageSize = 100
	local FoundMatch = false
	-- Pull a list of Available Servers from Memory Sorted Map
	local GetServersSuccess, GetServersResult = pcall(function()
		return ServersListStore:GetRangeAsync(Enum.SortDirection.Ascending, ServersPageSize, LastServerInTheList)
	end)
	-- If the Sorted Map Contains Servers
	if GetServersSuccess == true then
		-- Loop through the list and check the queue for the server with the Server Job ID
		-- The queue only contains a Player Count
		SendChatMessage(#GetServersResult.." Servers Found")
		for count, item in ipairs(GetServersResult) do
			local ServerId = item["key"]
			if ServerId ~= "0" then
				local PlaceId = tonumber(item["value"])
				local ReadSuccess, items, id = pcall(function()
					local ServerQueue = MemoryStoreService:GetQueue(ServerId)
					local result  = ServerQueue:ReadAsync(1, true, 30)
					return result
				end)
				-- If the Server has space then teleport
				if ReadSuccess and #items > 0 then
					local PlayersInQueue = tonumber(items[1])
					if PlayersInQueue > 1 and PlayersInQueue < MaxPlayersInServer then
						FoundMatch = true
						SendChatMessage("Found Server: "..ServerId.. " with ".. PlayersInQueue.. " players in the queue.")
						local TeleportOptions = Instance.new("TeleportOptions")
						TeleportOptions.ServerInstanceId = ServerId
						local Result = TeleportService:TeleportAsync(PlaceId, {player}, TeleportOptions)
						SendChatMessage(Result)
					end
				end
				wait(1)
			end
			if count == #GetServersResult and FoundMatch == false then
				local Result = TeleportService:TeleportAsync(map, {player})
				SendChatMessage(Result)
			end
		end
	end
	-- If there are no servers in the Memory Sorted Map then just teleport to the place
	if GetServersSuccess == false then
		TeleportService:TeleportAsync(map, {player})
	end
end

function MSSP.ActivateServerGui(player, isActive)
	if isActive then
		player.PlayerGui.ServerAdmin.Enabled = isActive
	end
	if not isActive then
		player.PlayerGui.ServerAdmin.Enabled = true
	end
end


LoadServerListEvent.OnServerEvent:Connect(LoadServerList)


return MSSP
