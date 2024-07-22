local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)
		local humanoid = char:WaitForChild("Humanoid")
		while task.wait(1) do
			humanoid.Health = math.random(1, 100)
		end
	end)
end)
