wait(1)
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local Service = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SendChatMessageEvent = ReplicatedStorage:WaitForChild("SendChatMessage")

local function SendChatMessage(msg)
	local text = "<font color = \"rgb(255,255,0)\">" .. msg .. "</font>"
	Service.TextChannels.RBXSystem:DisplaySystemMessage(text)
end

PlayerGui.ServerAdmin:GetPropertyChangedSignal("Enabled"):Connect(function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local LoadServerListClientEvent = ReplicatedStorage:WaitForChild("LoadServerList")
	if game.Players.LocalPlayer.PlayerGui.ServerAdmin.Enabled == true then
		LoadServerListClientEvent:FireServer()
	end
end)

PlayerGui.ServerAdmin.ServerListHeader.RefreshButton.MouseButton1Click:Connect(function()
	print("test")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local LoadServerListClientEvent = ReplicatedStorage:WaitForChild("LoadServerList")
	LoadServerListClientEvent:FireServer()
end)

PlayerGui.ServerAdminButtonGui.ServerAdminButton.MouseButton1Click:Connect(function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local ActivateServerGuiEvent = ReplicatedStorage:WaitForChild("ActivateServerGui")
	ActivateServerGuiEvent:FireServer(true)
end)

SendChatMessageEvent.OnClientEvent:Connect(SendChatMessage)