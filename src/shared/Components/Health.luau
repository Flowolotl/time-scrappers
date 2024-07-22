local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.react)

local Player = Players.LocalPlayer
local ce = React.createElement

function Health()
	local health, setHealth = React.useState(100)

	React.useEffect(function()
		local healthConnection = nil
		local conn1 = Player.CharacterAdded:Connect(function(char: Model)
			local humanoid: Humanoid = char:WaitForChild("Humanoid") :: Humanoid
			healthConnection = humanoid.HealthChanged:Connect(function(v: number)
				setHealth(v)
			end)
		end)

		return function()
			healthConnection:Disconnect()
			conn1:Disconnect()
		end
	end, {})

	return ce("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromHSV(199 / 360, 80 / 255, 191 / 255),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(health / 100, 0, 1, 0),
	}, {
		Corner = ce("UICorner", {
			CornerRadius = UDim.new(0.05, 0),
		}),
		Gradient = ce("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromHSV(199 / 360, 80 / 255, 203 / 255)),
				ColorSequenceKeypoint.new(1, Color3.fromHSV(199 / 360, 80 / 255, 191 / 255)),
			}),
		}),
		Stroke = ce("UIStroke", {
			Color = Color3.fromRGB(177, 229, 255),
			Thickness = 4,
		}, {
			Gradient = ce("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromHSV(199 / 360, 80 / 255, 255 / 255)),
					ColorSequenceKeypoint.new(1, Color3.fromHSV(199 / 360, 80 / 255, 243 / 255)),
				}),
			}),
		}),
	})
end

return Health
