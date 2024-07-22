local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")

local React = require(ReplicatedStorage.Packages.react)
local UiShake = require(StarterPlayer.StarterPlayerScripts.Game.UiShake)

local function useShake()
	local shakeBinding, setShakeBinding = React.useBinding(UDim2.fromScale(0, 0))

	React.useEffect(function()
		local conn = RunService.RenderStepped:Connect(function()
			setShakeBinding(UiShake.MouseDeltaOffset(0.025, 0.05))
		end)

		return function()
			conn:Disconnect()
		end
	end, {})

	return shakeBinding
end

return useShake
