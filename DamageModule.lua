local dmg = {}

local function checkCharacter(hitbox)
	if hitbox:HasTag("Hitbox") and hitbox:HasTag("Perfect Block") then
		return "Nope"	
	elseif hitbox:HasTag("Hitbox") and not hitbox:HasTag("IFrame") then
		local enemy = hitbox.Parent.Parent
		return enemy
	else
		return "Nope"
	end
end

dmg.ranged = function(character,range)
	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = {character,workspace.Debris,workspace.Map}
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	
	local ray = workspace:Raycast(character.HumanoidRootPart.Position,character.HumanoidRootPart.CFrame.LookVector * range,rayParams)
	
	if ray then
		return checkCharacter(ray.Instance)
	else
		return "Nope"
	end
end

dmg.hitbox = function(character,size,cframe)
	local overlapParams = OverlapParams.new()
	overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	overlapParams.FilterDescendantsInstances = {character,workspace.Debris,workspace.Map}

	local hits = {}

	local hitparts = workspace:GetPartBoundsInBox(cframe,size,overlapParams)

	for i,part in pairs(hitparts) do
		if checkCharacter(part) ~= "Nope" then
			table.insert(hits, part.Parent.Parent)
		end
	end
	
	if hits == {} then
		return "Nope"
	else
		return hits
	end
end

return dmg
