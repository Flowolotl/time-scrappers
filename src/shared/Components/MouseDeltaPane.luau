local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local React = require(ReplicatedStorage.Packages.react)
local join = require(ReplicatedStorage.Shared.join)
local useShake = require(ReplicatedStorage.Shared.Hooks.useShake)

local ce = React.createElement

type MouseDeltaPaneProps = {
	native: { [any]: any }?,
	children: React.ReactNode,
	position: UDim2,
}

function MouseDeltaPane(props: MouseDeltaPaneProps)
	local shake = useShake()
	return ce(
		"Frame",
		join({
			Position = shake:map(function(v)
				return props.position + v
			end),
		}, props.native),
		props.children
	)
end

return MouseDeltaPane
