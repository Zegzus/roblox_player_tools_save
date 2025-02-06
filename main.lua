local itemsFolder = game:GetService("ServerStorage"):WaitForChild("Itemstostore")
local players = game:GetService('Players')
local dataStoreService = game:GetService('DataStoreService')
local dataStore =  dataStoreService:GetDataStore('Items')

local function playerAdded(plr)
	repeat
		task.wait()
	until plr.Character
		task.wait(3)
	local success, inventory = pcall(function()
		return dataStore:GetAsync(plr.UserId)
	end)
	if success then
		for i,name in pairs(inventory or {}) do
			local Item = itemsFolder:FindFirstChild(name)
			if Item then
				local clone = Item:Clone()
				clone.Parent = plr.Backpack
			end
		end
	end
end

local function playerLeft(plr)
	local backpack = plr.Backpack
	local char = plr.Character
	local itemsTab = {}
	if char then
		for i, object in pairs(char:GetChildren()) do
			if object and object:IsA('Tool') then
				table.insert(itemsTab, object.Name)
			end
		end
	end
	for i, object in pairs(backpack:GetChildren()) do
		if object and object:IsA('Tool') then
			table.insert(itemsTab, object.Name)
		end
	end
	local success,err = pcall(function()
		return dataStore:SetAsync(plr.UserId, itemsTab)
	end)
	if not success then
		print(err)
	end
end

players.PlayerAdded:Connect(playerAdded)
players.PlayerRemoving:Connect(playerLeft)
