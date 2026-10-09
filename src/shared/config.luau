local config = {}

--config--------------------------------------------------------------------------------------------

export type item = { --item type
	id: number,
	quantity: number,
	durability: number?,
}

export type PlayerDataObject = { --player data type
	inventory: { item? },
	stats: {[string]: number?},
	experience: number,
	settings: {[string]: number|string|boolean?},
}

config.playerDataDefault = { --default player data template values
	inventory = {},
	stats = {},
	experience = 0,
	settings = {},
}

config.debug = true

function config.toLevel(xp: number): number --xp to level formula
    return (xp/100)^(1/2)
end

function config.toExperience(level: number): number --level to xp formula (inverse of previous)
    return 100*level^2
end

----------------------------------------------------------------------------------------------------

return config
