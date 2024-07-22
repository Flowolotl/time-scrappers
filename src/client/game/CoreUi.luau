local StarterGui = game:GetService("StarterGui")

local function disable(types: { Enum.CoreGuiType })
	for type in types do
		StarterGui:SetCoreGuiEnabled(type, false)
	end
	return types
end

return disable({ Enum.CoreGuiType.EmotesMenu, Enum.CoreGuiType.Backpack, Enum.CoreGuiType.Health })
