local StarterPlayer = game:GetService("StarterPlayer")
local UserInputService = game:GetService("UserInputService")
local State = require(StarterPlayer.StarterPlayerScripts.Game.State)

local UiShake = {}

function UiShake.MouseDeltaOffset(xm, ym)
	local delta = UserInputService:GetMouseDelta()
	local dx, dy = delta.X / State.cur_vp.X, delta.Y / State.cur_vp.Y
	local x = math.clamp(dx, -xm, xm)
	local y = math.clamp(dy, -ym, ym)
	return UDim2.new(x, 0, y, 0)
end

return UiShake
