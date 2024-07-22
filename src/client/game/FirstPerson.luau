local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera

local FirstPerson = {}

Player.CameraMode = Enum.CameraMode.LockFirstPerson

return FirstPerson
