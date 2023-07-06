local MSSP = require(script.Parent.MainModule)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MaxPlayersInServer = 20

local FindMatchEvent = Instance.new("RemoteEvent")
FindMatchEvent.Name = "FindMatch"
FindMatchEvent.Parent = ReplicatedStorage

local OpenServerAdminEvent = Instance.new("RemoteEvent")
OpenServerAdminEvent.Name = "OpenServerAdminEvent"
OpenServerAdminEvent.Parent = ReplicatedStorage



local function FindMatch(player, map)
	MSSP.TeleportToFirstAvailableServer(player, map)
end

local function OpenServerAdmin(player)
	MSSP.ActivateServerGui(player, true)
end

local function onPlayerAdded(player)
	local ServerAdminGui = MSSP.LoadGui(player)
end

OpenServerAdminEvent.OnServerEvent:Connect(OpenServerAdmin)
FindMatchEvent.OnServerEvent:Connect(FindMatch)
RemoveFromQueueEvent.OnServerEvent:Connect(RemoveFromQueue)
Players.PlayerAdded:Connect(onPlayerAdded)