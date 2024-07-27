local LocalPlayer = game:GetService("Players").LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Input = require(ReplicatedStorage.Packages.input)
local Signal = require(ReplicatedStorage.Packages.signal)

local Keyboard = Input.Keyboard.new()

local BackpackController = {}

BackpackController.ToolChanged = Signal.new()
local toolChangedPrev = nil :: Tool?

function BackpackController.EquipTool(tool: Tool)
	local char = LocalPlayer.Character
	if char and char.Humanoid.Health > 0 then
		local humanoid: Humanoid = char:FindFirstChild("Humanoid") :: Humanoid
		local equippedTool = char:FindFirstChildOfClass("Tool")
		if equippedTool then
			equippedTool.Parent = LocalPlayer.Backpack:FindFirstChild(equippedTool:GetAttribute("Slot"))
		end
		humanoid:EquipTool(tool)
		BackpackController.ToolChanged:Fire(tool, toolChangedPrev)
		toolChangedPrev = tool
	end
end

function BackpackController.getCurrentTool(): Tool?
	local tool = nil
	local char = LocalPlayer.Character
	if char and char.Humanoid.Health > 0 then
		tool = char:FindFirstChildOfClass("Tool")
	end
	return tool
end

Keyboard.KeyDown:Connect(function(key)
	if key == Enum.KeyCode.One then
		-- put tool in folder named for each key
		-- so player can change tools in slot 1 in main menu
		local tool = BackpackController.getCurrentTool()
		if tool then
			if tool:GetAttribute("Slot") == 1 then
				-- do nothing?
				return
			end
		end
		BackpackController.EquipTool(LocalPlayer.Backpack["1"]:FindFirstChildOfClass("Tool") :: Tool)
	elseif key == Enum.KeyCode.Two then
		local tool = BackpackController.getCurrentTool()
		if tool then
			if tool:GetAttribute("Slot") == 2 then
				-- do nothing?
				return
			end
		end
		BackpackController.EquipTool(LocalPlayer.Backpack["2"]:FindFirstChildOfClass("Tool") :: Tool)
	end
end)

BackpackController.ToolChanged:Connect(function(child, prev)
	print(`Switched from {prev} to {child}`)
end)

return BackpackController
