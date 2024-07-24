local Twixt = {
	useTwixt = require(script.useTwixt),
}

--[[
    Desired Functionality:

    local styles, twixt = Twixt.useTwixt(function()
        return {
            param1 = UDim2.fromScale(0, 1),
            param2 = UDim2.fromScale(0.5, 0.5),
        }
    end)

    React.useEffect(function()
        Player.CharacterAdded:Connect(function(char: Model)
            local humanoid: Humanoid = char:WaitForChild("Humanoid") :: Humanoid
            humanoid.HealthChanged:Connect(function(v: number)
                twixt.update({
                    param1 = UDim2.fromScale(v / 100, 1),
                })
            end)
        end)
    end, {})

    return ce("Frame", {
        Size = styles.param1,
        Position = styles.param2,
        AnchorPoint = Vector2.new(0.5, 0.5),
    })
]]

return Twixt
