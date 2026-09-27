local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local events = Instance.new("Folder")
events.Name = "events"
events.Parent = ReplicatedStorage

local module = {}

function module.new(name: string?)
	name = name or "RemoteEvent"

	local event = Instance.new("RemoteEvent")
	event.Name = name
	event.Parent = events
	print(string.format("created new remote event: %q", name :: string))
end

function module:Fetch(name: string): RemoteEvent
	return events:FindFirstChild(name) or nil
end

function module:Fire(name: string, ...: any?)
	local event = module:Fetch(name) or module.new(name)
	if RunService:IsClient() then
		event:FireServer(...)
	else
		event:FireClient(...)
	end
end

function module:Listen(name: string, func: (...any?) -> any?): RBXScriptConnection?
	local event = module:Fetch(name)
	if not event then
		warn(string.format("unknown event: %s", name))
		return nil
	end

	if RunService:IsClient() then
		return event.OnClientEvent:Connect(func)
	else
		return event.OnServerEvent:Connect(func)
	end
end

return module
