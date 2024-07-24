local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Controller = require(script.Parent.Controller)
local React = require(ReplicatedStorage.Packages.react)

export type UseTwixt = (() -> { [string]: any }) -> ({ [string]: any }, Controller.Controller)

function useTwixt(func)
	local styles, controller = Controller.new(func())
	React.useEffect(function()
		return function()
			for _, ctrl in pairs(controller.tvs) do
				ctrl:stop()
			end
		end
	end, {})
	return styles, controller
end

local et: UseTwixt = useTwixt
return et
