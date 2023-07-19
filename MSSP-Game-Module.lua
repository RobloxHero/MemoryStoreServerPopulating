local MSSP = {}

local MemoryStoreService = game:GetService("MemoryStoreService")
local ServersListStore = MemoryStoreService:GetSortedMap("ServersList")

MSSP.ServerName = nil
MSSP.ServerIsInit = false
MSSP.ServerMaxPlayerCount = nil
MSSP.ServerId = nil
MSSP.PlaceId = nil
MSSP.ServerPlayers = {["PlaceId"] = MSSP.PlaceId, ["Players"]= {}}

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
    table.remove(ps["Players"], player.UserId)
    return ps
  end, 604800)
end

function MSSP.AddPlayerToServer(player, PlayerCount)
	repeat wait() until MSSP.ServerIsInit == true
	MSSP.ServerId = GetServerId()
	local RemoveId
	local ReadSuccess, ServerStorePlayers = pcall(function()
		local result = ServersListStore:GetAsync(MSSP.ServerId)
		return result
	end)
	if PlayerCount < MSSP.ServerMaxPlayerCount then
		local AddSuccess, AddResult = pcall(function()
      local result = ServersListStore:UpdateAsync(MSSP.ServerId, function(ps)
        table.insert(ps["Players"], player.UserId)
        return ps
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

local function StartServer()
	local AddSuccess, AddResult = pcall(function()
		return ServersListStore:SetAsync(MSSP.ServerId, ServerPlayers, 604800)
	end)
	print("Server is running.")
	MSSP.ServerIsInit = true
end

function MSSP.ShutdownServer()
	local RemoveSuccess, RemoveResult = pcall(function()
		MSSP.ServerId = GetServerId()
		return ServersListStore:RemoveAsync(MSSP.PlaceId)
	end)
end

game:BindToClose(MSSP.ShutdownServer)
coroutine.wrap(MSSP.StartServer)()

