local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Find = require(ReplicatedStorage.Shared.Find)
local React = require(Find.path(ReplicatedStorage, "Packages/react"))
local ReactRoblox = require(Find.path(ReplicatedStorage, "Packages/react-roblox"))
local Input = require(Find.path(ReplicatedStorage, "Packages/input"))
local Keyboard = Input.Keyboard.new()

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local handle = Instance.new("ScreenGui")
handle.Parent = PlayerGui

print("Hello world, from client!")

local function Corner()
	return React.createElement("UICorner", {
		CornerRadius = UDim.new(0, 30),
	})
end

local function Component(props)
	local text, setText = React.useState(props.Key)

	Keyboard.KeyDown:Connect(function(key)
		setText(key.Name)
	end)

	Keyboard.KeyUp:Connect(function(key)
		setText("")
	end)

	return React.createElement("TextLabel", {
		Size = UDim2.new(0, 100, 0, 100),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(100, 164, 211),
		Text = text,
	}, { Corner() })
end

local root = ReactRoblox.createRoot(handle)

root:render(React.createElement(Component, { Key = "" }, {}))
