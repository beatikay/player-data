--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local playerData = require(ServerScriptService.Server.playerData)
local config = require(ReplicatedStorage.Shared.config)
local Item = require(ReplicatedStorage.Shared.item)
type item = Item.item

--events--------------------------------------------------------------------------------------------

local events = ReplicatedStorage:WaitForChild("Events")

local sendEvent: RemoteEvent = events:FindFirstChild("send") or error("no event found")

--local---------------------------------------------------------------------------------------------

local function update(t: {[string]: any}, changed: {[string]: any})
	for key, value: any in changed do
		if typeof(value) == "table" then
			update(t[key], value)
		else
			t[key] = value
		end
	end
end

----------------------------------------------------------------------------------------------------

local PlayerData = {}

PlayerData.cache = {} :: PlayerData
PlayerData.interface = {}
PlayerData.schema = {}
PlayerData.metatable = {}

type PlayerDataObject = {
	inventory: { item },
	stats: {number},
	experience: number,
	equipped: {},
	settings: {},
}

export type PlayerData = setmetatable<PlayerDataObject, typeof(PlayerData.metatable)>

----------------------------------------------------------------------------------------------------

local init = false

local function hasInit(): boolean
	if #PlayerData.cache == 0 then
		return true
	end
	return false
end

--interface-----------------------------------------------------------------------------------------
function PlayerData.interface.new(): PlayerData
	local self = {
		inventory = {},
		stats = {},
		experience = 0,
		equipped = {},
		settings = {},
	}

	setmetatable(self, PlayerData.metatable)
	return self
end

function PlayerData.interface:Init()
	PlayerData.cache = PlayerData.interface.new()

	if config.debug then
		print("client initialized")
	end
end

----------------------------------------------------------------------------------------------------

sendEvent.OnClientEvent:Connect(function(data)
	if not init and hasInit() then
		PlayerData.interface:Init()
		init = true
	end

	update(PlayerData.cache, data)

	if config.debug then
		print("client cache updated")
	end
end)

return PlayerData.interface
