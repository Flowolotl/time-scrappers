local Find = require(game:GetService("ReplicatedStorage").Shared.Find)
local React = require(Find.path(game:GetService("ReplicatedStorage"), "Packages/react"))

return function()
    return React.createElement("UICorner", {
	    CornerRadius = UDim.new(0, 30),
    })
end
