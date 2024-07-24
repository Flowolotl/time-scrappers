local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Animation = require(ReplicatedStorage.Shared.Twixt.Animation)
local Easings = require(ReplicatedStorage.Shared.Easings)
local helpers = require(ReplicatedStorage.Shared.Twixt.helpers)

export type TwixtValueImpl = {
	__index: TwixtValueImpl,
	new: (props: TwixtValueProps, key: string) -> TwixtValue,
	start: (self: TwixtValue, props: TwixtValueProps) -> (),
	_update: (self: TwixtValue, props: TwixtValueProps) -> (),
	prepare: (self: TwixtValue, props: TwixtValueProps) -> (),
	stop: (self: TwixtValue) -> (),
	_disconnect: (self: TwixtValue) -> (),
}

export type TwixtValue = typeof(setmetatable(
	{} :: {
		animation: Animation.Animation,
		key: string,
		onchange: (a: any) -> (),
		_connection: RBXScriptConnection?,
	},
	{} :: TwixtValueImpl
))

export type TwixtValueProps = {
	from: number,
	to: number,
	time: number,
	onchange: (a: number) -> ()?,
}

local TwixtValue = {} :: TwixtValueImpl
TwixtValue.__index = TwixtValue

function TwixtValue.new(props, key): TwixtValue
	local self = setmetatable({}, TwixtValue)
	self.animation = Animation.new(props, key)
	self.key = key
	self.onchange = props.onchange or function() end
	self._connection = nil
	return self
end

function TwixtValue:start(props)
	self:_update(props)
end

function TwixtValue:_update(props)
	self.animation.elapsedTime = table.create(#self.animation.values, 0)
	self.animation.done = table.create(#self.animation.values, false)
	self.animation.toValues = helpers.getValuesFromType(props.to)
	self.animation.fromValues = table.clone(self.animation.lastPosition)
	if not self._connection then
		self._connection = RunService.RenderStepped:Connect(function(dt)
			local idle = true
			local changed = false

			local anim = self.animation

			for i, _ in ipairs(anim.values) do
				if anim.done[i] then
					continue
				end
				anim.elapsedTime[i] += dt
				local elapsed = anim.elapsedTime[i]
				local from = anim.fromValues[i]
				local to = anim.toValues[i]
				-- print(props.time, elapsed, time)
				-- formula
				-- completion: math.clamp(elapsed / props.time, 0, 1)
				-- eased: easing(completion)
				-- difference: to - from
				-- displacement: difference * eased
				-- new: from + displacement
				local completion = math.clamp(elapsed / props.time, 0, 1)
				local eased = Easings.Cubic.Out(completion)
				local difference = to - from
				local displacement = difference * eased
				local new = from + displacement

				if completion == 1 then
					anim.done[i] = true
				else
					idle = false
				end

				if anim:setValue(i, new) then
					changed = true
				end
			end

			if idle then
				self.onchange(anim:getValue())
				self:_disconnect()
				self.animation:stop()
			elseif changed then
				-- print(anim:getValue())
				self.onchange(anim:getValue())
			end
		end)
	end
end

function TwixtValue:prepare(props)
	local values = helpers.getValuesFromType(props.from or props.to)
	self.animation.lastPosition = table.clone(values)
end

function TwixtValue:stop()
	self.animation:stop()
	self:_disconnect()
end

function TwixtValue:_disconnect()
	if self._connection then
		self._connection:Disconnect()
		self._connection = nil
	end
end

return TwixtValue
