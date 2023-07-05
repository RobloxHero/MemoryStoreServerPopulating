local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MemoryStoreService = game:GetService("MemoryStoreService")
local ServersListStore = MemoryStoreService:GetSortedMap("ServersList")
local TeleportService = game:GetService("TeleportService")

local MaxPlayersInServer = 20
local Players = game:GetService("Players")

local FindMatchEvent = Instance.new("RemoteEvent")
FindMatchEvent.Name = "FindMatch"
FindMatchEvent.Parent = ReplicatedStorage

local LastServerInTheList = nil

-- Find the first available Server and teleport.
local function TeleportToFirstAvailableServer(player, map)
	local ServersPageSize = 100
  -- Pull a list of Available Servers from Memory Sorted Map
	local GetServersSuccess, GetServersResult = pcall(function()
		return ServersListStore:GetRangeAsync(Enum.SortDirection.Ascending, ServersPageSize, LastServerInTheList)
	end)
  -- If the Sorted Map Contains Servers
	if GetServersSuccess == true then
    -- Loop through the list and check the queue for the server with the Server Job ID
    -- The queue only contains a Player Count
		for _, item in ipairs(GetServersResult) do
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
					if PlayersInQueue < MaxPlayersInServer then
						print("Found Server: "..ServerId.. " with ".. PlayersInQueue.. " players in the queue.")
						local TeleportOptions = { ["ServerInstanceId"] = ServerId }
						TeleportService:TeleportAsync(PlaceId, {player}, TeleportOptions)
					end
				end
				wait(1)
			end
		end
	end
  -- If there are no servers in the Memory Sorted Map then just teleport to the place
	if GetServersSuccess == false then
		TeleportService:TeleportAsync(map, {player})
	end
end

local function FindMatch(player, map)
	local PlayerGui = player:WaitForChild("PlayerGui")
	local Loading = PlayerGui:WaitForChild("Loading")
	TeleportToFirstAvailableServer(player, map)
end

FindMatchEvent.OnServerEvent:Connect(FindMatch)