local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local Game = StarterPlayer.StarterPlayerScripts.Game
local HealthBar = require(ReplicatedStorage.Shared.Components.HealthBar)
local React = require(ReplicatedStorage.Packages.react)
local ReactRoblox = require(ReplicatedStorage.Packages["react-roblox"])

local Player = Players.LocalPlayer
local ce = React.createElement

local handle = Instance.new("ScreenGui")
handle.Parent = Player.PlayerGui
handle.Name = "Game"
handle.IgnoreGuiInset = true
local root = ReactRoblox.createRoot(handle)

function StandaloneModules()
	require(Game.State)
	require(Game.UiShake)
	require(Game.CoreUi)
	require(Game.FirstPerson)
	require(Game.BackpackController)
	require(Game.ViewModel)
end

task.spawn(StandaloneModules)

root:render(ce(HealthBar, {}, {}))
Players.LocalPlayer.CharacterAdded:Connect(function(char)
	root:render(ce(HealthBar, {}, {}))
end)
