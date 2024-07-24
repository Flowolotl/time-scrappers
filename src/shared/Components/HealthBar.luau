local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Health = require(ReplicatedStorage.Shared.Components.Health)
local React = require(ReplicatedStorage.Packages.react)
local useShake = require(ReplicatedStorage.Shared.Hooks.useShake)

local ce = React.createElement

function HealthBar()
	local health, setHealth = React.useState(100)
	--- move to a module script to be used by this script and Health.luau
	React.useEffect(function()
		local healthConnection = nil
		local conn1 = game.Players.LocalPlayer.CharacterAdded:Connect(function(char: Model)
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
	---
	local shake = useShake()
	return ce("CanvasGroup", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromHSV(199 / 360, 80 / 255, 70 / 255),
		Position = shake:map(function(v: UDim2)
			local destination = v + UDim2.new(0.145, 0, 0.912, 0)
			return destination
		end),
		Size = UDim2.new(0.241, 0, 0.071, 0),
	}, {
		Health = ce(Health, {}),
		Corner = ce("UICorner", {
			CornerRadius = UDim.new(0.05, 0),
		}),
		Padding = ce("UIPadding", {
			PaddingBottom = UDim.new(0.1, 0),
			PaddingLeft = UDim.new(0.015, 0),
			PaddingRight = UDim.new(0.017, 0),
			PaddingTop = UDim.new(0.1, 0),
		}),
		RedGradient = ce("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
				ColorSequenceKeypoint.new(
					math.clamp(0.5 - 0.5 * health / 100, 0.001, 0.5),
					Color3.fromRGB(255, 255, 255)
				),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
				ColorSequenceKeypoint.new(
					math.clamp(1 - (0.5 - 0.5 * health / 100), 0.5, 0.999),
					Color3.fromRGB(255, 255, 255)
				),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
			}),
		}),
		Stroke = ce("UIStroke", {
			Thickness = 4,
		}),
		AspectRatio = ce("UIAspectRatioConstraint", {
			AspectRatio = 6.589, -- TODO: auto calculate
		}),
	})
end

return HealthBar
