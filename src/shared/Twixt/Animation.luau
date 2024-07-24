local ReplicatedStorage = game:GetService("ReplicatedStorage")
local helpers = require(ReplicatedStorage.Shared.Twixt.helpers)

export type wasd = {
	from: number,
	to: number,
	time: number,
	onchange: (a: any) -> ()?,
}

export type AnimationImpl = {
	__index: AnimationImpl,
	new: (props: wasd, key: string) -> Animation,
	setValue: (self: Animation, index: number, value: any) -> (),
	getValue: (self: Animation) -> any,
	stop: (self: Animation) -> (),
}

export type Animation = typeof(setmetatable(
	{} :: {
		values: any,
		fromValues: any,
		toValues: any,
		lastPosition: any,
		type: string,
		done: { boolean },
		elapsedTime: { number },
	},
	{} :: AnimationImpl
))

local Animation = {} :: AnimationImpl
Animation.__index = Animation

function Animation.new(props, key): Animation
	local self = setmetatable({}, Animation)
	local to = props.to
	local from = props.from
	local length = #helpers.getValuesFromType(from or to)

	self.values = helpers.getValuesFromType(from or to) -- current/intermediate values
	self.fromValues = helpers.getValuesFromType(from or to) -- start values
	self.toValues = helpers.getValuesFromType(to) -- target values
	self.lastPosition = helpers.getValuesFromType(from or to)
	self.type = typeof(from or to)
	self.done = table.create(length, false)
	self.elapsedTime = table.create(length, 0)
	return self
end

function Animation:setValue(index: number, value)
	if self.values[index] == value then
		return false
	end
	self.values[index] = value
	return true
end

function Animation:getValue()
	return helpers.getTypeFromValues(self.type, self.values)
end

function Animation:stop()
	for i, v in ipairs(self.values) do
		self.elapsedTime = table.create(#self.values, 0)
	end
end

return Animation
