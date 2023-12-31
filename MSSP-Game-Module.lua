local MSSP = {}

local MemoryStoreService = game:GetService("MemoryStoreService")
local ServersListStore = MemoryStoreService:GetSortedMap("ServersList")
local TeleportService = game:GetService("TeleportService")

MSSP.ServerName = nil
MSSP.ServerIsInit = false
MSSP.ServerMaxPlayerCount = nil
MSSP.ServerId = nil
MSSP.PlaceId = nil
MSSP.IsConfigured = false
MSSP.ServerInfo = {["Players"] = {}}

function MSSP.Configure(ServerName, ServerMaxPlayers, PlaceId)
	print("configured")
	MSSP.ServerName = ServerName
	MSSP.ServerInfo["ServerName"] = ServerName
	MSSP.ServerMaxPlayerCount = ServerMaxPlayers
	MSSP.ServerInfo["MaxServerPlayers"] = ServerMaxPlayers
	MSSP.PlaceId = PlaceId
	MSSP.ServerInfo["PlaceId"] = PlaceId
	MSSP.IsConfigured = true
end

function MSSP.GetServerId()
	if game.JobId == "" or game.JobId == nil or not game.JobId then
		return 0
	end
	if game.JobId ~= "" then
		return game.JobId
	end
end

function MSSP.RemovePlayerFromServer(player)
  local result = ServersListStore:UpdateAsync(MSSP.ServerId, function(ps)
		local ServerInfo = ps
		table.insert(ServerInfo["Players"], player.UserId)
		return ServerInfo
  end, 604800)
end

function MSSP.AddPlayerToServer(player, PlayerCount)
	repeat wait() until MSSP.ServerIsInit == true
	local RemoveId
	local ReadSuccess, ServerStorePlayers = pcall(function()
		local result = ServersListStore:GetAsync(MSSP.ServerId)
		return result
	end)
	if PlayerCount < MSSP.ServerMaxPlayerCount then
		local AddSuccess, AddResult = pcall(function()
			local result = ServersListStore:UpdateAsync(MSSP.ServerId, function(ps)
				local ServerInfo = ps
				table.insert(ServerInfo["Players"], player.UserId)
        		return ServerInfo
      end, 604800)
		end)
	end
	if PlayerCount >= MSSP.ServerMaxPlayerCount then
		local TeleportSuccess, TeleportResult = pcall(function()
			return TeleportService:TeleportAsync(MSSP.PlaceId, {player})
		end)
		if not TeleportSuccess then
			player:Kick("Server is Full.\n Try going to the Lobby Server to Join a Game :)")
		end
	end
end

function MSSP.StartServer()
	wait(2)
	MSSP.ServerId = MSSP.GetServerId()
	local AddSuccess, AddResult = pcall(function()
		return ServersListStore:SetAsync(MSSP.ServerId, MSSP.ServerInfo, 604800)
	end)
	print("Server is running.")
	MSSP.ServerIsInit = true
end

function MSSP.ShutdownServer()
	local RemoveSuccess, RemoveResult = pcall(function()
		return ServersListStore:RemoveAsync(MSSP.ServerId)
	end)
end

game:BindToClose(MSSP.ShutdownServer)
coroutine.wrap(MSSP.StartServer)()

return MSSP

