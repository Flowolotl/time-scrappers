local function len(t)
	local length = 0
	for _, _ in pairs(t) do
		length = length + 1
	end
	return length
end

local function joinLists<T>(...: { T }?): { T }
	local final = nil
	local changed = false

	for _, list in { ... } do
		assert(list ~= nil, "Luau")

		if #list == 0 then
			continue
		end

		if final == nil then
			final = list
		else
			assert(final ~= nil, "Luau")

			if not changed then
				final = table.clone(final)
				changed = true
			end

			table.move(list, 1, #list, #final + 1, final)
		end
	end

	return final or {}
end

local function join(...: { { [any]: any }? }?): { [any]: any }?
	local final = nil
	local changed = false

	for _, t in { ... } do
		assert(t ~= nil, "Luau")

		if len(t) == 0 then
			continue
		end

		if final == nil then
			final = t
		else
			assert(final ~= nil, "Luau")

			if not changed then
				final = table.clone(final)
				changed = true
			end

			for k, v in pairs(t) do
				final[k] = v
			end
		end
	end

	return final or {}
end

return join
