local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.react)
local TwixtValue = require(ReplicatedStorage.Shared.Twixt.TwixtValue)

export type ControllerImpl = {
	__index: ControllerImpl,
	new: (props: {}) -> ({ string: any }, Controller),
	start: (self: Controller, styles: { [string]: any }, time: number) -> (),
	_disconnect: (self: Controller) -> (),
	stop: (self: Controller) -> (),
	_update: (self: Controller, styles: { [string]: any }) -> (),
}

export type Controller = typeof(setmetatable(
	{} :: {
		bindings: { [string]: any },
		tvs: { [string]: any },
	},
	{} :: ControllerImpl
))

local Controller = {} :: ControllerImpl
Controller.__index = Controller

local function createTV(props, key: string)
	local binding, setBinding = React.createBinding(nil :: any)
	local tv = TwixtValue.new(props, key)
	print(tv)
	tv.key = key
	tv.onchange = function(new)
		setBinding(new)
	end
	return tv, binding
end

local function prepareKey(ctrl, props, key)
	local tv = ctrl.tvs[key]
	if not tv then
		ctrl.tvs[key], ctrl.bindings[key] = createTV(props, key)
		tv = ctrl.tvs[key]
	end
	tv:prepare(props)
end

function Controller.new(props: {}): ({ [string]: any }, Controller)
	local self = setmetatable({}, Controller)

	self.bindings = {}
	self.tvs = {}

	self:start(props, 0.1)

	return self.bindings, self
end

function Controller:start(props, time)
	for key, value in pairs(props) do
		local foo = nil
		if self.bindings[key] == nil then
			foo = value
		end
		local tvprops = {
			from = foo or self.bindings[key]:getValue(),
			to = value,
			time = time,
		}
		prepareKey(self, tvprops, key)
		self.tvs[key]:start(tvprops)
	end
end

function Controller:stop()
	for _, tv in pairs(self.tvs) do
		tv:stop()
	end
end

return Controller
