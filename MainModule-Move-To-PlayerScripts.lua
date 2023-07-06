wait(1)
Player.PlayerGui.ServerAdmin:GetPropertyChangedSignal("Enabled"):Connect(function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local LoadServerListClientEvent = ReplicatedStorage:WaitForChild("LoadServerList")
	if Player.PlayerGui.ServerAdmin.Enabled == true then
		LoadServerListClientEvent:FireServer()
	end
end)

Player.PlayerGui.ServerAdmin.ServerListHeader.RefreshButton.MouseButton1Click:Connect(function()
	print("test")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local LoadServerListClientEvent = ReplicatedStorage:WaitForChild("LoadServerList")
	LoadServerListClientEvent:FireServer()
end)