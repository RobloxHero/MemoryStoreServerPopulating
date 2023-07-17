local MemoryStoreService = game:GetService("MemoryStoreService")
local ServersListStore = MemoryStoreService:GetSortedMap("ServersList")

local ServerIsInit = false
local ServerQueueDeleteKey

-- Grab the Server Id or set it to Test
-- We are using the Job Id because we are making the Server Public
-- Use the game.PrivateServerId for a Private Server
local function GetServerId()
	if game.JobId == "" or game.JobId == nil or not game.JobId then
		return 0
	end
	if game.JobId ~= "" then
		return game.JobId
	end
end

-- Update a Memory Store Queue with A Player Count
-- So we can have an updated number on the menu server when the server becomes availabe
-- This way uses Minimal Api Requests by only Updating the the count only
local function UpdateQueue(player, PlayerCount)
	repeat wait() until ServerIsInit == true
	local ServerId = GetServerId()
	local RemoveId
  -- Read the Queue
	local ReadSuccess, items, id = pcall(function()
		local ServerQueue = MemoryStoreService:GetQueue(ServerId)
		local result = ServerQueue:ReadAsync(100, false, 30)
		return result
	end)
	if PlayerCount < ServerMaxPlayerCount then
		if not items or #items < 1 then
      -- If the server is Empty add to the Queue
      -- We are adding the current player count
      -- Queue item is set to 30 days or 2592000 seconds
			local AddSuccess, AddResult = pcall(function()
				local ServerQueue = MemoryStoreService:GetQueue(ServerId)
				local result = ServerQueue:AddAsync(tostring(PlayerCount), 2592000, 1)
				return result
			end)
		end
		if #items >= 1 then
			RemoveId = id
      --If there are players in the server remove all Items in the queue
			local RemoveSuccess, RemoveResult = pcall(function()
				local ServerQueue = MemoryStoreService:GetQueue(ServerId)
				local result = ServerQueue:RemoveAsync(RemoveId)
				return result
			end)
      --Then add to the Queue
      --We are adding the current Player Count
      -- Queue item is set to 30 days or 2592000 seconds
      -- We also are adding a priority of #items + 1, so no matter what the most recent player count is returned
			local AddSuccess, AddResult = pcall(function()
				local ServerQueue = MemoryStoreService:GetQueue(ServerId)
				local result = ServerQueue:AddAsync(tostring(PlayerCount), 2592000, #items + 1)
				return result
			end)
		end
	end
  --If there are too many people in the server, or someone joins directly to the public server
  --we teleport back to the menu or remove with a nice message
	if PlayerCount >= ServerMaxPlayerCount then
		local TeleportSuccess, TeleportResult = pcall(function()
			return TeleportService:TeleportAsync(PlaceId, {player})
		end)
		if not TeleportSuccess then
			player:Kick("Server is Full.\n Try going to the Lobby Server to Join a Game :)")
		end
	end
end

-- Update The Count When A Player Leaves
local function onPlayerRemoved(player)
	UpdateActivePlayers(false, player, false)
	coroutine.wrap(UpdateQueue)(player, #Players:GetPlayers() - 1)
end

-- Remove the Available Server from the Memory Store Sorted Map when the Server Closes
local function ShutdownServer()
	local RemoveSuccess, RemoveResult = pcall(function()
		local ServerId = GetServerId()
		return ServersListStore:RemoveAsync(PlaceId)
	end)
end

--Set Available Servers List in Memory Store Sorted Map
local function InitServer()
	local AddSuccess, AddResult = pcall(function()
		local ServerId = GetServerId()
		return ServersListStore:SetAsync(ServerId, PlaceId, 3888000)
	end)
	ServerIsInit = true
end

local function onPlayerAdded(player)
	coroutine.wrap(UpdateQueue)(player, #Players:GetPlayers())
end

Players.PlayerAdded:Connect(onPlayerAdded)
game:BindToClose(ShutdownServer)
coroutine.wrap(InitServer)()