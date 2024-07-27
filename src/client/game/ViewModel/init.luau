local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")
local BackpackController = require(StarterPlayer.StarterPlayerScripts.Game.BackpackController)

local runServiceConnection: RBXScriptConnection? = nil

BackpackController.ToolChanged:Connect(function(tool, prev)
	if runServiceConnection then
		runServiceConnection:Disconnect()
		runServiceConnection = nil
	end
	local model: Model = tool:FindFirstChild("Model") :: Model
	local scale = 0.125
	if model then
		model:ScaleTo(scale)
		runServiceConnection = RunService.RenderStepped:Connect(function()
			model:PivotTo(workspace.CurrentCamera.CFrame * CFrame.new(Vector3.new(4, -1, -6) * scale))
		end)
	end
end)

return {}
