local LocalPlayer = game:GetService("Players").LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Input = require(ReplicatedStorage.Packages.input)
local Signal = require(ReplicatedStorage.Packages.signal)

local Keyboard = Input.Keyboard.new()

local Tool = {}

Tool.ToolChanged = Signal.new()
local toolChangedPrev = nil :: Tool?

function Tool.EquipTool(tool: Tool)
	local char = LocalPlayer.Character
	if char and char.Humanoid.Health > 0 then
		local humanoid: Humanoid = char:FindFirstChild("Humanoid") :: Humanoid
		local equippedTool = char:FindFirstChildOfClass("Tool")
		if equippedTool then
			equippedTool.Parent = LocalPlayer.Backpack:FindFirstChild(equippedTool:GetAttribute("Slot"))
		end
		humanoid:EquipTool(tool)
	end
end

function Tool.getCurrentTool(): Tool?
	local tool = nil
	local char = LocalPlayer.Character
	if char and char.Humanoid.Health > 0 then
		tool = char:FindFirstChildOfClass("Tool")
	end
	return tool
end

function Tool.getAccessibleTools(): { Tool? }
	local tools = {}
	table.move(LocalPlayer.Backpack:GetChildren(), 1, #LocalPlayer.Backpack:GetChildren(), #tools, tools)
	local char = LocalPlayer.Character
	if char and char.Humanoid.Health > 0 then
		table.move(char:FindFirstChildOfClass("Tool"), 1, #char:FindFirstChildOfClass("Tool"), #tools, tools)
	end
	return tools
end

Keyboard.KeyDown:Connect(function(key)
	if key == Enum.KeyCode.One then
		-- put tool in folder named for each key
		-- so player can change tools in slot 1 in main menu
		local tool = Tool.getCurrentTool()
		if tool then
			if tool:GetAttribute("Slot") == 1 then
				-- do nothing?
				return
			end
		end
		Tool.EquipTool(LocalPlayer.Backpack["1"]:FindFirstChildOfClass("Tool") :: Tool)
	elseif key == Enum.KeyCode.Two then
		local tool = Tool.getCurrentTool()
		if tool then
			if tool:GetAttribute("Slot") == 2 then
				-- do nothing?
				return
			end
		end
		Tool.EquipTool(LocalPlayer.Backpack["2"]:FindFirstChildOfClass("Tool") :: Tool)
	end
end)

Character.ChildAdded:Connect(function(child)
	if child:IsA("Tool") then
		Tool.ToolChanged:Fire(child, toolChangedPrev)
		toolChangedPrev = child
	end
end)

Character.ChildRemoved:Connect(function(child)
	if child:IsA("Tool") then
		Tool.ToolChanged:Fire(nil :: any, toolChangedPrev)
		toolChangedPrev = nil
	end
end)

Tool.ToolChanged:Connect(function(child, prev)
	print(`Switched from {prev} to {child}`)
end)

return Tool
