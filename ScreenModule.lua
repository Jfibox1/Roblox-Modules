local screen = {}

local ts = game:GetService("TweenService")

local getShake = function(range)
	return math.random(-range * 100, range * 100) / 100
end

screen.ScreenShake = function(humanoid, range, intensity)
	for i = 1,intensity do
		humanoid.CameraOffset = Vector3.new(getShake(range), getShake(range), getShake(range))
		wait()
	end
	humanoid.CameraOffset = Vector3.new(0,0,0)
end

screen.ColorContrast = function(full, color, contrastTime, noTween)
	local contrast = Instance.new("ColorCorrectionEffect", game.Lighting)
	contrast.Brightness = 0
	contrast.Contrast = 0
	
	if full == true then
		contrast.Brightness = 0
		contrast.Contrast = 0
		contrast.Saturation = -2
		contrast.TintColor = Color3.fromRGB(255, 255, 255)
		
		delay(contrastTime,function()
			contrast:Destroy()
		end)
	else
		if noTween == true then
			contrast.Saturation = 0
			contrast.TintColor = Color3.fromRGB(255, 255, 255)
			local tweenContrast = ts:Create(contrast, TweenInfo.new(contrastTime / 10), {TintColor = color})
			local tweenBack = ts:Create(contrast, TweenInfo.new(contrastTime / 10), {TintColor = Color3.fromRGB(255, 255, 255)})
			
			tweenContrast:Play()
			tweenContrast.Completed:Connect(function()
				task.delay(contrastTime - contrastTime / 10,function()
					tweenBack:Play()
					tweenBack.Completed:Connect(function()
						--contrast:Destroy()
						contrast.Enabled = false
					end)
				end)
			end)
		else
			contrast.Saturation = 0
			contrast.TintColor = Color3.fromRGB(255, 255, 255)
			local tweenContrast = ts:Create(contrast, TweenInfo.new(contrastTime / 2), {TintColor = color})
			local tweenBack = ts:Create(contrast, TweenInfo.new(contrastTime / 2), {TintColor = Color3.fromRGB(255, 255, 255)})

			tweenContrast:Play()
			tweenContrast.Completed:Connect(function()
				tweenBack:Play()
				tweenBack.Completed:Connect(function()
					--contrast:Destroy()
					contrast.Enabled = false
				end)
			end)
		end
	end
end

screen.LimitRange = function(character, range, deleteTime, welded)
	local hrp = character.HumanoidRootPart
	
	local rangeModel = Instance.new("Model", workspace.Debris)
	rangeModel.Name = character.Name.."'s Range"
	
	local center = Instance.new("Part",rangeModel)
	center.Name = "Center"
	center.Transparency = 1
	center.CanCollide = false
	center.Size = hrp.Size
	center.CFrame = hrp.CFrame
	
	if welded == true then
		local centerWeld = Instance.new("WeldConstraint", center)
		centerWeld.Part0 = center
		centerWeld.Part1 = hrp
	else
		center.Anchored = true
	end
	
	local top = Instance.new("Part", rangeModel)
	local front = Instance.new("Part", rangeModel)
	local back = Instance.new("Part", rangeModel)
	local left = Instance.new("Part", rangeModel)
	local right = Instance.new("Part", rangeModel)
	
	top.CFrame = hrp.CFrame * CFrame.new(0, range / 2 ,0)
	front.CFrame = hrp.CFrame * CFrame.new(0, 0, -range / 2)
	back.CFrame = hrp.CFrame * CFrame.new(0, 0, range / 2)
	left.CFrame = hrp.CFrame * CFrame.new(-range / 2, 0, 0)
	right.CFrame = hrp.CFrame * CFrame.new(range / 2, 0, 0)
	top.Orientation += Vector3.new(90,0,0)
	left.Orientation += Vector3.new(0,90,0)
	right.Orientation += Vector3.new(0,90,0)
	
	for i,v in pairs(rangeModel:GetChildren()) do
		if v:IsA("Part") and v.Name ~= center.Name then
			v.Transparency = 1
			v.CanCollide = false
			v.Size = Vector3.new(range, range, 1)
			local weld = Instance.new("WeldConstraint", v)
			weld.Part0 = v
			weld.Part1 = center
		end
	end
	
	game.Debris:AddItem(rangeModel ,deleteTime)
end

return screen
