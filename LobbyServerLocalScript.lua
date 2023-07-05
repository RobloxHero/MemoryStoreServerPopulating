local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SendChatMessageEvent = ReplicatedStorage:WaitForChild("SendChatMessage")

local function SendChatMessage(text)
	local formattedText = string.format("<font face='Roboto' size='18' color='#ecf072'><strong>%s</strong></font>", text)
	game.TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage(text)
end

SendChatMessageEvent.OnClientEvent:Connect(SendChatMessage)