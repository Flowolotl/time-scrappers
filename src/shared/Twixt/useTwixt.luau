local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Controller = require(script.Parent.Controller)
local React = require(ReplicatedStorage.Packages.react)

export type UseTwixt = (() -> { [string]: any }) -> ({ [string]: any }, Controller.Controller)

type Controllers = { Controller.Controller }

function useTwixt(func)
	local stylesList = React.useRef({} :: { { [string]: React.Binding<any> } })
	local controllerList = React.useRef({} :: Controllers)
	assert(controllerList["current"] ~= nil, "never")
	assert(stylesList["current"] ~= nil, "never")

	local length = 1

	React.useMemo(function()
		if #controllerList["current"] < length then
			for i = #controllerList["current"] + 1, length do
				local styles, controller = Controller.new(func())

				controllerList["current"][i] = controller
				stylesList["current"][i] = styles
			end
		else
			for i = length + 1, #controllerList["current"] do
				controllerList["current"][i]:stop()
				controllerList["current"][i] = nil
				stylesList["current"][i] = nil
			end
		end
	end, { length })

	React.useEffect(function()
		return function()
			for _, ctrl in pairs(controllerList["current"]) do
				ctrl:stop()
			end
		end
	end, {})

	local a, b = stylesList["current"][1], controllerList["current"][1]
	return a, b
end

local et: UseTwixt = useTwixt
return et
