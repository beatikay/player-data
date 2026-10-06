--!strict

local class = {}
class.__index = class

local cache: instance?

type instanceObject = {
    number: number
}

export type instance = setmetatable<instanceObject, typeof(class)>

local function _constructor(number: number): instance
    local instance = {
        number = number
    }
    setmetatable(instance, class)
    cache = instance
    return instance :: instance
end

function class.get(number: number): instance
    return cache or _constructor(number)
end

function class:randomize(): ()
    self.number = math.random(0, 10)
end

return class
