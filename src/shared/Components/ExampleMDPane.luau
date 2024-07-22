local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local MouseDeltaPane = require(ReplicatedStorage.Shared.Components.MouseDeltaPane)
local React = require(ReplicatedStorage.Packages.react)

local ce = React.createElement

function ExampleMDPane()
	local A, setA = React.useState(UDim2.fromScale(0.25, 0.75))

	React.useEffect(function()
		local t = tick()
		local conn = RunService.RenderStepped:Connect(function()
			if tick() - t > 1 then
				print(A, t, tick())
				setA(A + UDim2.fromScale(0.05, 0.05))
				t = tick()
			end
		end)

		return function()
			conn:Disconnect()
		end
	end, {})

	return ce(MouseDeltaPane, {
		position = A,
		BackgroundTransparency = 0.3,
		native = {
			Size = UDim2.new(0.5, 0, 0.5, 0),
		},
	}, {})
end

return ExampleMDPane
