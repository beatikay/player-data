local config = {}

config.debug = true

function config.toLevel(xp)
    return (xp/100)^(1/2)
end

function config.toExperience(level)
    return 100*level^2
end

return config
