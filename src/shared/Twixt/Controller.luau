local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.react)
local TwixtValue = require(ReplicatedStorage.Shared.Twixt.TwixtValue)

export type ControllerImpl = {
	__index: ControllerImpl,
	new: (props: {}) -> ({}, Controller),
	start: (self: Controller, styles: { [string]: any }, time: number) -> (),
	_disconnect: (self: Controller) -> (),
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
	local tv = TwixtValue.new(props, key)
	local binding, setBinding = React.useBinding(nil :: any)
	tv.key = key
	tv.onchange = function(new)
		setBinding(new)
	end
	return tv, binding
end

local function prepareKey(ctrl, props, key)
	local tv = ctrl.tvs[key]
	if props.from == nil then
		props.from = props.to
	end
	if not tv then
		ctrl.tvs[key], ctrl.bindings[key] = createTV(props, key)
		tv = ctrl.tvs[key]
	end
	tv:prepare(props)
end

function Controller.new(props: {}): ({}, Controller)
	local self = setmetatable({}, Controller)

	print("creating controller")
	self.bindings = {}
	self.tvs = {}

	self:start(props, 0.1)

	return self.bindings, self
end

function Controller:start(props, time)
	for key, value in pairs(props) do
		if not self.bindings[key] then
			prepareKey(self, { from = nil :: any, to = value, time = time }, key)
			-- print("no skip")
		else
			-- print("skipping")
		end
		local tvprops = {
			from = self.bindings[key]:getValue(),
			to = value,
			time = time,
		}
		prepareKey(self, tvprops, key)
		self.tvs[key]:start(tvprops)
	end
end

return Controller
