--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local config = require(ReplicatedStorage.Shared.config)
local PlayerDataStore = DataStoreService:GetDataStore("PlayerDataStore")

local PlayerData = {}
PlayerData.__index = PlayerData
local store = {} :: {[string]: PlayerData}

type PlayerDataObject = config.PlayerDataObject

export type PlayerData = setmetatable<PlayerDataObject, typeof(PlayerData)>

local function update(t: PlayerDataObject|{[string]: any}, changed: {[string]: any})
	for key, value: any in changed do
		if typeof(value) == "table" then
			update(t[key], value)
		else
			t[key] = value
		end
	end
end

function PlayerData.new(data: {[string]: any}?): PlayerData
	local self = table.clone(config.playerDataDefault) :: PlayerDataObject

    if data then
        update(self, data)
    end

	setmetatable(self, PlayerData)
	return self :: PlayerData
end

local function fromDataStore(userId: number): PlayerData?
    local success = pcall(Players.GetNameFromUserIdAsync, Players, userId)
    if not success then
        warn("invalid userid:", userId)
        return nil
    end

    local data = PlayerDataStore:GetAsync(tostring(userId))
    return PlayerData.new(data)
end

function PlayerData.get(userId: number): PlayerData?
    return store[tostring(userId)] or fromDataStore(userId)
end

function PlayerData:Save(player: Player)
	PlayerDataStore:SetAsync(tostring(player.UserId), PlayerData.get(player.UserId))

	if config.debug then
		print("data saved for player " .. player.Name)
	end
end

return PlayerData
