--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local config = require(ReplicatedStorage.Shared.config)

local events = ReplicatedStorage:WaitForChild("Events")

local sendEvent: RemoteEvent = events:FindFirstChild("send") or error("no event found")

local function update(t: PlayerDataObject|{[string]: any}, changed: {[string]: any})
	for key, value: any in changed do
		if typeof(value) == "table" then
			update(t[key], value)
		else
			t[key] = value
		end
	end
end

local PlayerData = {}
PlayerData.__index = PlayerData
local cache: PlayerData?

type PlayerDataObject = config.PlayerDataObject

export type PlayerData = setmetatable<PlayerDataObject, typeof(PlayerData)>

local function constructor(): PlayerData
	local self = table.clone(config.playerDataDefault) :: PlayerDataObject

	setmetatable(self, PlayerData)
	cache = self
	return self
end

function PlayerData.get(): PlayerData
	local data = cache or constructor()
	if config.debug then
		print(data)
	end
	return data
end

local function received(data)
	update(PlayerData.get(), data)

	if config.debug then
		print("client cache updated")
	end
end

sendEvent.OnClientEvent:Connect(received)

return PlayerData
