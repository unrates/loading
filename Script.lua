-- Защита от повторной загрузки
if getgenv().XenaHubLoaded then
    warn('⚠ XenaHub is already running!')
    return
end
getgenv().XenaHubLoaded = true

-- Сервисы
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")

-- Игрок
local player = Players.LocalPlayer

-- Конфигурация
local CONFIG = {
	MAIN_COLOR = Color3.fromRGB(90, 140, 255),          -- Midnight blue accent
	DEFAULT_WALK_SPEED = 16,
	DEFAULT_JUMP_POWER = 50,
	VALID_TARGET_ROLES = { "Sheriff", "Hero", "Innocent" },
	TOGGLE_SPACING = 52,
	BUTTON_HEIGHT = 48,
	SPACING = 8
}

-- Глобальные состояния
local STATES = {
	AutoFarm = {
		Enabled = false,
		Farming = false,
		BagFull = false,
		Resetting = false,
		StartPosition = nil
	},
	KillAll = {
		Enabled = false,
		AttackDelay = 0.5
	},
	Movement = {
		SpeedWalk = { Enabled = false, Value = CONFIG.DEFAULT_WALK_SPEED },
		JumpPower = { Enabled = false, Value = CONFIG.DEFAULT_JUMP_POWER }
	},
	ShootMurderer = {
		ButtonData = nil,
		Position = nil
	},
	FakeBombJump = {
		ButtonData = nil,
		Position = nil
	},
	GrabGun = {
		ButtonData = nil,
		Position = nil
	},
	GUIVisible = true,
	Performance = {
		Enabled = false,
		Overlay = nil,
		Position = nil
	},
	AntiFling = {
		Enabled = false,
		Connections = nil
	},
	MuteRadio = {
		Enabled = false
	}
}

-- Статистика фарма
local FARMING_STATS = {
	CoinsCollected = 0,
	StartTime = 0,
	IsRunning = false
}

-- RemoteEvents кэш
local REMOTE_EVENTS = {
	CoinCollected = nil,
	RoundStart = nil,
	RoundEnd = nil
}

-- Градиенты для обводки
local STROKE_GRADIENT = {
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, CONFIG.MAIN_COLOR),
		ColorSequenceKeypoint.new(0.3, CONFIG.MAIN_COLOR),
		ColorSequenceKeypoint.new(0.7, CONFIG.MAIN_COLOR),
		ColorSequenceKeypoint.new(1, CONFIG.MAIN_COLOR)
	}),
	Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.2, 0),
		NumberSequenceKeypoint.new(0.5, 0.5),
		NumberSequenceKeypoint.new(0.8, 0.8),
		NumberSequenceKeypoint.new(1, 1)
	})
}

-- UI элементы
local UI_ELEMENTS = {
	ScreenGui = nil,
	OpenCloseGui = nil,
	MainFrame = nil,
	TabButtonsContainer = nil,
	ContentFrame = nil,
	Tabs = {},
	ToggleCallbacks = {},
	ToggleStates = {}
}

-- Очередь уведомлений
local ActiveNotifications = {}
local NOTIFICATION_HEIGHT = 85

-- Утилитарные функции
local UTILS = {}

function UTILS.playClickSound()
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://138656262630730"
	sound.Volume = 0.7
	sound.Parent = SoundService
	sound:Play()
	Debris:AddItem(sound, 2)
end

function UTILS.showNotification(title, message, duration)
    duration = duration or 5
    
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://106553517979212"
    sound.Volume = 0.5
    sound.Parent = SoundService
    sound:Play()
    Debris:AddItem(sound, 3)
    
    if not UI_ELEMENTS.ScreenGui then
        UI_ELEMENTS.ScreenGui = UTILS.createInstance("ScreenGui", CoreGui, {
            Name = "MM2GUI",
            ZIndexBehavior = Enum.ZIndexBehavior.Global,
            ResetOnSpawn = false,
            DisplayOrder = 100
        })
    end
    
    local function updateNotificationStack()
        for i, frame in ipairs(ActiveNotifications) do
            if frame and frame.Parent then
                local targetY = -105 - ((#ActiveNotifications - i) * NOTIFICATION_HEIGHT)
                
                TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Position = UDim2.new(1, -300, 1, targetY)
                }):Play()
            end
        end
    end
    
    local function removeNotification(notificationFrame)
        local index = table.find(ActiveNotifications, notificationFrame)
        if index then
            table.remove(ActiveNotifications, index)
            
            notificationFrame:TweenPosition(
                UDim2.new(1, 300, notificationFrame.Position.Y.Scale, notificationFrame.Position.Y.Offset), 
                "In", 
                "Quad", 
                0.4, 
                true, 
                function()
                    notificationFrame:Destroy()
                    updateNotificationStack()
                end
            )
        end
    end
    
    if #ActiveNotifications >= 5 then
        local oldestNotification = ActiveNotifications[1]
        if oldestNotification then
            removeNotification(oldestNotification)
            task.wait(0.1)
        end
    end
    
    local notificationFrame = UTILS.createWithStaticStroke("Frame", UI_ELEMENTS.ScreenGui, {
        Name = "Notification",
        Size = UDim2.new(0, 280, 0, 75),
        Position = UDim2.new(1, 20, 1, -105),
        BackgroundColor3 = Color3.fromRGB(12, 16, 28),
        BackgroundTransparency = 0.1,
        ZIndex = 100,
        ClipsDescendants = true
    })
    UTILS.createInstance("UICorner", notificationFrame, {CornerRadius = UDim.new(0, 10)})
    
    local titleLabel = UTILS.createInstance("TextLabel", notificationFrame, {
        Text = title,
        Size = UDim2.new(1, -40, 0, 22),
        Position = UDim2.new(0, 10, 0, 6),
        BackgroundTransparency = 1,
        TextColor3 = CONFIG.MAIN_COLOR,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 101
    })

    local msgLabel = UTILS.createInstance("TextLabel", notificationFrame, {
        Text = message,
        Size = UDim2.new(1, -40, 0, 28),
        Position = UDim2.new(0, 10, 0, 28),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(210, 220, 240),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        RichText = true,
        ZIndex = 101
    })

    local progressContainer = UTILS.createInstance("Frame", notificationFrame, {
        Name = "ProgressContainer",
        Size = UDim2.new(1, -70, 0, 3),
        Position = UDim2.new(0, 10, 1, -10),
        BackgroundColor3 = Color3.fromRGB(25, 32, 50),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        ZIndex = 102
    })
    UTILS.createInstance("UICorner", progressContainer, {CornerRadius = UDim.new(1, 0)})

    local progressBar = UTILS.createInstance("Frame", progressContainer, {
        Name = "ProgressBar",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = CONFIG.MAIN_COLOR,
        BorderSizePixel = 0,
        ZIndex = 103
    })
    UTILS.createInstance("UICorner", progressBar, {CornerRadius = UDim.new(1, 0)})

    local timeText = UTILS.createInstance("TextLabel", notificationFrame, {
        Name = "TimeText",
        Size = UDim2.new(0, 40, 0, 14),
        Position = UDim2.new(1, -50, 1, -20),
        BackgroundTransparency = 1,
        Text = tostring(duration) .. "s",
        TextColor3 = Color3.fromRGB(160, 175, 200),
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 102
    })

    local closeButton = UTILS.createInstance("TextButton", notificationFrame, {
        Name = "CloseButton",
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -28, 0, 6),
        BackgroundColor3 = Color3.fromRGB(30, 40, 65),
        BackgroundTransparency = 0.3,
        Text = "×",
        TextColor3 = Color3.fromRGB(200, 210, 230),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        ZIndex = 105,
        AutoButtonColor = false
    })
    
    UTILS.createInstance("UICorner", closeButton, {CornerRadius = UDim.new(1, 0)})
    
    closeButton.MouseEnter:Connect(function()
        closeButton.BackgroundColor3 = Color3.fromRGB(45, 60, 95)
        closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    closeButton.MouseLeave:Connect(function()
        closeButton.BackgroundColor3 = Color3.fromRGB(30, 40, 65)
        closeButton.TextColor3 = Color3.fromRGB(200, 210, 230)
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        UTILS.playClickSound()
        removeNotification(notificationFrame)
    end)

    table.insert(ActiveNotifications, notificationFrame)
    updateNotificationStack()
    
    local startTime = tick()
    local progressConnection
    local textUpdateConnection
    
    progressConnection = RunService.Heartbeat:Connect(function()
        if not notificationFrame or not notificationFrame.Parent then
            if progressConnection then progressConnection:Disconnect() end
            return
        end
        
        local elapsed = tick() - startTime
        local remaining = math.max(0, duration - elapsed)
        local progress = remaining / duration
        
        progressBar.Size = UDim2.new(progress, 0, 1, 0)
        
        if progress < 0.3 then
            local pulse = math.sin(tick() * 8) * 0.3 + 0.7
            progressBar.BackgroundColor3 = Color3.fromRGB(
                CONFIG.MAIN_COLOR.R * 255 * pulse,
                CONFIG.MAIN_COLOR.G * 255 * pulse,
                CONFIG.MAIN_COLOR.B * 255 * pulse
            )
        else
            progressBar.BackgroundColor3 = CONFIG.MAIN_COLOR
        end
    end)
    
    textUpdateConnection = RunService.Heartbeat:Connect(function()
        if not notificationFrame or not notificationFrame.Parent then
            if textUpdateConnection then textUpdateConnection:Disconnect() end
            return
        end
        
        local elapsed = tick() - startTime
        local remaining = math.max(0, duration - elapsed)
        timeText.Text = math.ceil(remaining) .. "s"
    end)
    
    task.delay(duration, function()
        if notificationFrame and notificationFrame.Parent then
            removeNotification(notificationFrame)
        end
        
        if progressConnection then
            progressConnection:Disconnect()
        end
        if textUpdateConnection then
            textUpdateConnection:Disconnect()
        end
    end)
    
    return notificationFrame
end

function UTILS.createInstance(className, parent, properties)
	local obj = Instance.new(className, parent)
	for prop, value in pairs(properties) do
		obj[prop] = value
	end
	return obj
end

function UTILS.safeDestroy(obj)
	if obj and obj.Parent then
		obj:Destroy()
	end
end

function UTILS.secondsToMinutes(seconds)
	if seconds == -1 then return "" end
	local minutes = math.floor(seconds / 60)
	local remainingSeconds = seconds % 60
	return string.format("%dm %ds", minutes, remainingSeconds)
end

function UTILS.getHRP()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		return player.Character.HumanoidRootPart
	end
	return nil
end

function UTILS.addSpacer(parent, positionY, height)
	return UTILS.createInstance("Frame", parent, {
		Name = "Spacer",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, height),
		Position = UDim2.new(0, 0, 0, positionY)
	})
end

function UTILS.updateCanvasSize(scrollingFrame, contentFrame)
	if not scrollingFrame or not contentFrame or not scrollingFrame:IsA("ScrollingFrame") then
		return
	end
	
	local totalHeight = 0
	for _, child in ipairs(contentFrame:GetChildren()) do
		if child:IsA("GuiObject") then
			totalHeight = totalHeight + child.AbsoluteSize.Y
		end
	end
	
	scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 100)
	contentFrame.Size = UDim2.new(1, 0, 0, totalHeight + 80)
end

function UTILS.updateTabButtonsContainerSize(container)
	local totalHeight = 0
	for _, child in ipairs(container:GetChildren()) do
		if child:IsA("GuiObject") then
			totalHeight = totalHeight + child.AbsoluteSize.Y + 8
		end
	end
	
	container.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

function UTILS.joinAnotherServer()
	local TeleportService = game:GetService("TeleportService")
	
	local success, result = pcall(function()
		local reservedServer = TeleportService:ReserveServer(game.PlaceId)
		if reservedServer then
			TeleportService:TeleportToPrivateServer(game.PlaceId, reservedServer, {player})
		else
			TeleportService:Teleport(game.PlaceId, player)
		end
	end)
	
	if not success then
		pcall(function()
			TeleportService:Teleport(game.PlaceId, player)
		end)
	end
end

function UTILS.rejoinServer()
	local TeleportService = game:GetService("TeleportService")
	local currentJobId = game.JobId
	
	pcall(function()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, currentJobId, player)
	end)
end

function UTILS.createStaticStroke(frame)
	local stroke = UTILS.createInstance("UIStroke", frame, {
		Thickness = 2,
		Color = Color3.fromRGB(255, 255, 255),
		Transparency = 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	})
	
	local gradient = UTILS.createInstance("UIGradient", stroke, {
		Color = STROKE_GRADIENT.Color,
		Transparency = STROKE_GRADIENT.Transparency,
		Rotation = 0
	})
	
	return stroke
end

function UTILS.createWithStaticStroke(className, parent, properties)
	local obj = UTILS.createInstance(className, parent, properties)
	if className == "Frame" or className == "TextButton" or className == "ScrollingFrame" then
		UTILS.createStaticStroke(obj)
	end
	return obj
end

-- ESP и Highlight система
local ESP_SYSTEM = {}

ESP_SYSTEM.ESP_STATES = {
	ESPName = false,
	MurdererName = true,
	SheriffName = true,
	HeroName = true,
	InnocentName = true
}

ESP_SYSTEM.ESP_HIGHLIGHT_STATES = {
	ESPHighlight = false,
	ESPHighlightMurderer = true,
	ESPHighlightSheriff = true,
	ESPHighlightHero = true,
	ESPHighlightInnocent = true
}

ESP_SYSTEM.ESP_LINE_STATES = {
    ESPLine = false,
    MurdererLine = true,
    SheriffLine = true,
    HeroLine = true,
    InnocentLine = true,
    LineThickness = 1.4,
    LineTransparency = 1
}

ESP_SYSTEM.ROLE_COLORS = {
	Murderer = Color3.fromRGB(255, 0, 0),
	Sheriff = Color3.fromRGB(0, 0, 255),
	Hero = Color3.fromRGB(255, 255, 0),
	Innocent = Color3.fromRGB(0, 255, 0)
}

ESP_SYSTEM.billboards = {}
ESP_SYSTEM.currentRoles = {}
ESP_SYSTEM.Camera = workspace.CurrentCamera
ESP_SYSTEM.LineDrawings = {}

ESP_SYSTEM.MIN_DISTANCE = 5
ESP_SYSTEM.MAX_DISTANCE = 100
ESP_SYSTEM.MIN_SIZE = UDim2.new(0, 50, 0, 12)
ESP_SYSTEM.MAX_SIZE = UDim2.new(0, 200, 0, 50)
ESP_SYSTEM.MIN_TEXT_SIZE = 8
ESP_SYSTEM.MAX_TEXT_SIZE = 18

local cachedRolesData = {}
local lastRoleUpdate = 0
local UPDATE_INTERVAL = 0.5
local lineConnections = {}

function ESP_SYSTEM.IsPlayerOnScreen(targetPlayer)
    if not ESP_SYSTEM.Camera then return true end
    
    local character = targetPlayer.Character
    if not character then return false end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    local screenPoint, onScreen = ESP_SYSTEM.Camera:WorldToViewportPoint(humanoidRootPart.Position)
    
    if onScreen then
        local viewportSize = ESP_SYSTEM.Camera.ViewportSize
        if screenPoint.X >= -50 and screenPoint.X <= viewportSize.X + 50 and
           screenPoint.Y >= -50 and screenPoint.Y <= viewportSize.Y + 50 then
            return true
        end
    end
    
    return false
end

function ESP_SYSTEM.IsPlayerVisible(targetPlayer)
    if not ESP_SYSTEM.IsPlayerOnScreen(targetPlayer) then
        return false
    end
    return true
end

function ESP_SYSTEM.GetRolesData()
	local currentTime = tick()
	if currentTime - lastRoleUpdate < UPDATE_INTERVAL then
		return cachedRolesData
	end
	
	local success, rolesData = pcall(function()
		local getPlayerData = ReplicatedStorage:FindFirstChild("GetPlayerData", true)
		if getPlayerData and getPlayerData:IsA("RemoteFunction") then
			return getPlayerData:InvokeServer()
		end
		return {}
	end)
	
	if success and rolesData then
		cachedRolesData = rolesData
		lastRoleUpdate = currentTime
	end
	
	return cachedRolesData
end

function ESP_SYSTEM.IsAlive(targetPlayer, rolesData)
	if not rolesData then return false end
	
	local playerData = rolesData[targetPlayer.Name]
	return playerData and not playerData.Killed and not playerData.Dead
end

function ESP_SYSTEM.getPlayerRole(targetPlayer, rolesData)
	if not rolesData then return nil, false end
	
	local playerData = rolesData[targetPlayer.Name]
	if not playerData then return nil, false end
	
	return playerData.Role, ESP_SYSTEM.IsAlive(targetPlayer, rolesData)
end

function ESP_SYSTEM.GetPlayerColorByRole(role, isAlive)
	if not isAlive then
		return Color3.fromRGB(150, 150, 150)
	end
	
	if role == "Murderer" then
		return Color3.fromRGB(255, 0, 0)
	elseif role == "Sheriff" then
		return Color3.fromRGB(0, 0, 255)
	elseif role == "Hero" then
		return Color3.fromRGB(255, 255, 0)
	elseif role == "Innocent" then
		return Color3.fromRGB(0, 255, 0)
	else
		return Color3.fromRGB(255, 255, 255)
	end
end

function ESP_SYSTEM.ShouldShowLineForRole(role)
	if not ESP_SYSTEM.ESP_LINE_STATES.ESPLine then
		return false
	end
	
	if role == "Murderer" and ESP_SYSTEM.ESP_LINE_STATES.MurdererLine then
		return true
	elseif role == "Sheriff" and ESP_SYSTEM.ESP_LINE_STATES.SheriffLine then
		return true
	elseif role == "Hero" and ESP_SYSTEM.ESP_LINE_STATES.HeroLine then
		return true
	elseif role == "Innocent" and ESP_SYSTEM.ESP_LINE_STATES.InnocentLine then
		return true
	end
	return false
end

function ESP_SYSTEM.CreateLineDrawing()
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(1, 1)
    line.Color = Color3.fromRGB(0, 255, 50)
    line.Thickness = ESP_SYSTEM.ESP_LINE_STATES.LineThickness
    line.Transparency = ESP_SYSTEM.ESP_LINE_STATES.LineTransparency
    return line
end

function ESP_SYSTEM.GetLineForPlayer(playerName)
    local drawing = ESP_SYSTEM.LineDrawings[playerName]
    if not drawing then
        drawing = ESP_SYSTEM.CreateLineDrawing()
        ESP_SYSTEM.LineDrawings[playerName] = drawing
    end
    return drawing
end

function ESP_SYSTEM.RemoveLineForPlayer(playerName)
    if ESP_SYSTEM.LineDrawings[playerName] then
        ESP_SYSTEM.LineDrawings[playerName]:Remove()
        ESP_SYSTEM.LineDrawings[playerName] = nil
    end
end

function ESP_SYSTEM.ClearAllLines()
    for playerName, drawing in pairs(ESP_SYSTEM.LineDrawings) do
        if drawing then
            drawing:Remove()
        end
    end
    ESP_SYSTEM.LineDrawings = {}
end

function ESP_SYSTEM.UpdateCamera()
    ESP_SYSTEM.Camera = workspace.CurrentCamera
end

function ESP_SYSTEM.StopAllLines()
    for _, conn in ipairs(lineConnections) do
        if conn then 
            pcall(function() conn:Disconnect() end)
        end
    end
    lineConnections = {}
    ESP_SYSTEM.ClearAllLines()
end

function ESP_SYSTEM.InitializePlayerLines(targetPlayer)
    if not pcall(function() return Drawing.new("Line") end) then
        warn("XenaHub: Your executor does not support Drawing API for lines.")
        return nil
    end

    if not ESP_SYSTEM.LineDrawings[targetPlayer.Name] then
        local line = Drawing.new("Line")
        line.Visible = false
        line.Color = Color3.fromRGB(255, 255, 255)
        line.Thickness = ESP_SYSTEM.ESP_LINE_STATES.LineThickness
        line.Transparency = ESP_SYSTEM.ESP_LINE_STATES.LineTransparency
        
        ESP_SYSTEM.LineDrawings[targetPlayer.Name] = line
    end
    
    local cachedRole = nil
    local cachedIsAlive = false
    local lastRoleFetch = 0
    local ROLE_FETCH_INTERVAL = 0.1
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not ESP_SYSTEM.ESP_LINE_STATES.ESPLine then
            if ESP_SYSTEM.LineDrawings[targetPlayer.Name] then 
                ESP_SYSTEM.LineDrawings[targetPlayer.Name].Visible = false 
            end
            return
        end
        
        ESP_SYSTEM.UpdateCamera()
        
        if targetPlayer and targetPlayer.Character and 
           targetPlayer.Character:FindFirstChild("Humanoid") and 
           targetPlayer.Character:FindFirstChild("HumanoidRootPart") and
           targetPlayer.Name ~= player.Name and
           targetPlayer.Character.Humanoid.Health > 0 then
            
            local currentTime = tick()
            if currentTime - lastRoleFetch >= ROLE_FETCH_INTERVAL then
                local rolesData = ESP_SYSTEM.GetRolesData()
                local role, isAlive = ESP_SYSTEM.getPlayerRole(targetPlayer, rolesData)
                cachedRole = role
                cachedIsAlive = isAlive
                lastRoleFetch = currentTime
            end
            
            if not ESP_SYSTEM.ShouldShowLineForRole(cachedRole) or not cachedIsAlive then
                if ESP_SYSTEM.LineDrawings[targetPlayer.Name] then 
                    ESP_SYSTEM.LineDrawings[targetPlayer.Name].Visible = false 
                end
                return
            end
            
            local playerPos = targetPlayer.Character.HumanoidRootPart.Position
            local torsoPos, vis = ESP_SYSTEM.Camera:WorldToViewportPoint(playerPos)
            
            if vis then
                local centerX = ESP_SYSTEM.Camera.ViewportSize.X / 2
                local centerY = ESP_SYSTEM.Camera.ViewportSize.Y / 2
                
                local line = ESP_SYSTEM.LineDrawings[targetPlayer.Name]
                if line then
                    line.From = Vector2.new(centerX, centerY)
                    line.To = Vector2.new(torsoPos.X, torsoPos.Y)
                    line.Color = ESP_SYSTEM.GetPlayerColorByRole(cachedRole, cachedIsAlive)
                    line.Thickness = ESP_SYSTEM.ESP_LINE_STATES.LineThickness
                    line.Transparency = ESP_SYSTEM.ESP_LINE_STATES.LineTransparency
                    line.Visible = true
                end
            else
                if ESP_SYSTEM.LineDrawings[targetPlayer.Name] then 
                    ESP_SYSTEM.LineDrawings[targetPlayer.Name].Visible = false 
                end
            end
        else
            if ESP_SYSTEM.LineDrawings[targetPlayer.Name] then 
                ESP_SYSTEM.LineDrawings[targetPlayer.Name].Visible = false 
            end
        end
    end)
    
    return connection
end

function ESP_SYSTEM.StartAllLines()
    ESP_SYSTEM.StopAllLines()
    
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player then
            local conn = ESP_SYSTEM.InitializePlayerLines(targetPlayer)
            table.insert(lineConnections, conn)
        end
    end
end

function ESP_SYSTEM.updatePlayerBillboard(targetPlayer, role, isAlive)
	if targetPlayer == player then return end
	
	local character = targetPlayer.Character
	if not character then return end
	
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then return end
	
	local distance = (ESP_SYSTEM.Camera.CFrame.Position - humanoidRootPart.Position).Magnitude
	local billboard = humanoidRootPart:FindFirstChild("PlayerBillboard")
	
	local color
	if role == "Murderer" and isAlive then
		color = ESP_SYSTEM.ROLE_COLORS.Murderer
	elseif role == "Sheriff" and isAlive then
		color = ESP_SYSTEM.ROLE_COLORS.Sheriff
	elseif role == "Hero" and isAlive then
		color = ESP_SYSTEM.ROLE_COLORS.Hero
	elseif role == "Innocent" and isAlive then
		color = ESP_SYSTEM.ROLE_COLORS.Innocent
	else
		color = Color3.fromRGB(255, 255, 255)
	end
	
	if billboard then
		local textLabel = billboard:FindFirstChild("PlayerName")
		if textLabel then
			textLabel.TextColor3 = color
			textLabel.Text = targetPlayer.Name
		end
	else
		billboard = Instance.new("BillboardGui")
		billboard.Name = "PlayerBillboard"
		billboard.Adornee = humanoidRootPart
		billboard.AlwaysOnTop = true
		billboard.Size = UDim2.new(0, 100, 0, 30)
		billboard.StudsOffset = Vector3.new(0, 2.5, 0)
		billboard.ResetOnSpawn = false
		
		local textLabel = Instance.new("TextLabel")
		textLabel.Name = "PlayerName"
		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = targetPlayer.Name
		textLabel.TextColor3 = color
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextSize = 14
		textLabel.TextStrokeTransparency = 0.5
		textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
		textLabel.Parent = billboard
		
		billboard.Parent = humanoidRootPart
		ESP_SYSTEM.billboards[targetPlayer] = billboard
	end
end

function ESP_SYSTEM.removePlayerBillboard(targetPlayer)
	if targetPlayer == player then return end
	
	if ESP_SYSTEM.billboards[targetPlayer] then
		ESP_SYSTEM.billboards[targetPlayer]:Destroy()
		ESP_SYSTEM.billboards[targetPlayer] = nil
	end
	
	local character = targetPlayer.Character
	if character then
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if humanoidRootPart then
			local billboard = humanoidRootPart:FindFirstChild("PlayerBillboard")
			if billboard then
				billboard:Destroy()
			end
		end
	end
end

function ESP_SYSTEM.clearAllESP()
	for targetPlayer, billboard in pairs(ESP_SYSTEM.billboards) do
		if billboard and billboard.Parent then
			billboard:Destroy()
		end
	 end
	ESP_SYSTEM.billboards = {}
end

function ESP_SYSTEM.updatePlayerHighlight(targetPlayer, role, isAlive)
	if targetPlayer == player then return end
	
	local character = targetPlayer.Character
	if not character then return end
	
	local highlight = character:FindFirstChild("PlayerHighlight")
	
	if not highlight or not highlight:IsA("Highlight") then
		if highlight then
			highlight:Destroy()
		end
		
		highlight = Instance.new("Highlight")
		highlight.Name = "PlayerHighlight"
		highlight.Adornee = character
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.FillTransparency = 0.7
		highlight.OutlineTransparency = 0.4
		highlight.OutlineColor = Color3.new(1, 1, 1)
		highlight.Parent = character
	end
	
	local color
	if role == "Murderer" and isAlive then
		color = Color3.fromRGB(255, 0, 0)
	elseif role == "Sheriff" and isAlive then
		color = Color3.fromRGB(0, 0, 255)
	elseif role == "Hero" and isAlive then
		color = Color3.fromRGB(255, 255, 0)
	elseif role == "Innocent" and isAlive then
		color = Color3.fromRGB(0, 255, 0)
	else
		color = Color3.fromRGB(255, 255, 255)
	end
	
	highlight.FillColor = color
end

function ESP_SYSTEM.removePlayerHighlight(targetPlayer)
	if targetPlayer == player then return end
	
	local character = targetPlayer.Character
	if character then
		local highlight = character:FindFirstChild("PlayerHighlight")
		if highlight and highlight:IsA("Highlight") then
			highlight:Destroy()
		end
	end
end

function ESP_SYSTEM.clearAllHighlights()
	for _, targetPlayer in ipairs(Players:GetPlayers()) do
		if targetPlayer ~= player then
			ESP_SYSTEM.removePlayerHighlight(targetPlayer)
		end
	end
end

function ESP_SYSTEM.updateESP()
	if not ESP_SYSTEM.ESP_STATES.ESPName then
		ESP_SYSTEM.clearAllESP()
		return
	end
	
	local rolesData = ESP_SYSTEM.GetRolesData()
	
	for _, targetPlayer in ipairs(Players:GetPlayers()) do
		if targetPlayer == player then continue end
		
		local character = targetPlayer.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		
		if not character or not humanoidRootPart then
			ESP_SYSTEM.removePlayerBillboard(targetPlayer)
			continue
		end
		
		if not ESP_SYSTEM.IsPlayerVisible(targetPlayer) then
			ESP_SYSTEM.removePlayerBillboard(targetPlayer)
			continue
		end
		
		local role, isAlive = ESP_SYSTEM.getPlayerRole(targetPlayer, rolesData)
		
		local shouldShow = false
		if role == "Murderer" and ESP_SYSTEM.ESP_STATES.MurdererName then
			shouldShow = true
		elseif role == "Sheriff" and ESP_SYSTEM.ESP_STATES.SheriffName then
			shouldShow = true
		elseif role == "Hero" and ESP_SYSTEM.ESP_STATES.HeroName then
			shouldShow = true
		elseif role == "Innocent" and ESP_SYSTEM.ESP_STATES.InnocentName then
			shouldShow = true
		elseif not role then
			shouldShow = true
		end
		
		if shouldShow then
			ESP_SYSTEM.updatePlayerBillboard(targetPlayer, role, isAlive)
		else
			ESP_SYSTEM.removePlayerBillboard(targetPlayer)
		end
	end
end

function ESP_SYSTEM.updateHighlights()
	if not ESP_SYSTEM.ESP_HIGHLIGHT_STATES.ESPHighlight then
		ESP_SYSTEM.clearAllHighlights()
		return
	end
	
	local rolesData = ESP_SYSTEM.GetRolesData()
	
	for _, targetPlayer in ipairs(Players:GetPlayers()) do
		if targetPlayer == player then continue end
		
		local character = targetPlayer.Character
		if not character then 
			ESP_SYSTEM.removePlayerHighlight(targetPlayer)
			continue
		end
		
		if not ESP_SYSTEM.IsPlayerVisible(targetPlayer) then
			ESP_SYSTEM.removePlayerHighlight(targetPlayer)
			continue
		end
		
		local role, isAlive = ESP_SYSTEM.getPlayerRole(targetPlayer, rolesData)
		
		local shouldShow = false
		if role == "Murderer" and ESP_SYSTEM.ESP_HIGHLIGHT_STATES.ESPHighlightMurderer then
			shouldShow = true
		elseif role == "Sheriff" and ESP_SYSTEM.ESP_HIGHLIGHT_STATES.ESPHighlightSheriff then
			shouldShow = true
		elseif role == "Hero" and ESP_SYSTEM.ESP_HIGHLIGHT_STATES.ESPHighlightHero then
			shouldShow = true
		elseif role == "Innocent" and ESP_SYSTEM.ESP_HIGHLIGHT_STATES.ESPHighlightInnocent then
			shouldShow = true
		end
		
		if shouldShow then
			ESP_SYSTEM.updatePlayerHighlight(targetPlayer, role, isAlive)
		else
			ESP_SYSTEM.removePlayerHighlight(targetPlayer)
		end
	end
end

function ESP_SYSTEM.initializePlayer(targetPlayer)
	if targetPlayer == player then return end
	
	local function onCharacterAdded(character)
		task.wait(0.5)
		ESP_SYSTEM.updateESP()
	end
	
	local function onCharacterRemoving()
		ESP_SYSTEM.removePlayerBillboard(targetPlayer)
		ESP_SYSTEM.removePlayerHighlight(targetPlayer)
	end
	
	targetPlayer.CharacterAdded:Connect(onCharacterAdded)
	targetPlayer.CharacterRemoving:Connect(onCharacterRemoving)
	
	if targetPlayer.Character then
		task.spawn(onCharacterAdded, targetPlayer.Character)
	end
end

-- Anti-Fling система
local ANTI_FLING = {}

function ANTI_FLING.enable()
    if STATES.AntiFling.Enabled then
        return
    end
    
    STATES.AntiFling.Enabled = true
    
    local localPlayer = player
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    
    local function disableAllPlayersParts()
        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if targetPlayer ~= localPlayer and targetPlayer.Character then
                for _, part in ipairs(targetPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and not part.Anchored then
                        part.CanCollide = false
                    end
                end
            end
        end
    end
    
    disableAllPlayersParts()
    
    local antiFlingTask = nil
    antiFlingTask = task.spawn(function()
        while STATES.AntiFling.Enabled do
            task.wait(0.3)
            
            if not character or character.Parent == nil then
                character = localPlayer.Character
                if character then
                    humanoid = character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                    end
                end
            end
            
            disableAllPlayersParts()
        end
    end)
    
    local function onPlayerAdded(targetPlayer)
        if targetPlayer ~= localPlayer then
            targetPlayer.CharacterAdded:Connect(function(char)
                task.wait(0.2)
                if STATES.AntiFling.Enabled then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and not part.Anchored then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end
    
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        onPlayerAdded(targetPlayer)
    end
    
    local playerAddedConnection
    playerAddedConnection = Players.PlayerAdded:Connect(onPlayerAdded)
    
    local characterAddedConnection
    characterAddedConnection = localPlayer.CharacterAdded:Connect(function(newChar)
        character = newChar
        humanoid = character:FindFirstChild("Humanoid")
        if humanoid and STATES.AntiFling.Enabled then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        end
        task.wait(0.2)
        if STATES.AntiFling.Enabled then
            disableAllPlayersParts()
        end
    end)
    
    STATES.AntiFling.Connections = {
        task = antiFlingTask,
        playerAdded = playerAddedConnection,
        characterAdded = characterAddedConnection
    }
end

function ANTI_FLING.disable()
    if not STATES.AntiFling.Enabled then
        return
    end
    
    STATES.AntiFling.Enabled = false
    
    if STATES.AntiFling.Connections and STATES.AntiFling.Connections.task then
        task.cancel(STATES.AntiFling.Connections.task)
    end
    
    if STATES.AntiFling.Connections and STATES.AntiFling.Connections.playerAdded then
        STATES.AntiFling.Connections.playerAdded:Disconnect()
    end
    
    if STATES.AntiFling.Connections and STATES.AntiFling.Connections.characterAdded then
        STATES.AntiFling.Connections.characterAdded:Disconnect()
    end
    
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Character then
            for _, part in ipairs(targetPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
    
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        end
    end
    
    STATES.AntiFling.Connections = nil
end

-- Функция для Mute Radio
local function toggleMuteRadio(value)
    STATES.MuteRadio.Enabled = value
    
    local function muteRadioSounds()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Sound") and obj.Name == "RadioSound" then
                if value then
                    obj.Volume = 0
                else
                    obj.Volume = 1
                end
            end
        end
    end
    
    muteRadioSounds()
    
    local connection
    connection = workspace.DescendantAdded:Connect(function(descendant)
        if STATES.MuteRadio.Enabled and descendant:IsA("Sound") and descendant.Name == "RadioSound" then
            descendant.Volume = 0
        end
    end)
    
    if value then
        if not STATES.MuteRadio.Connection then
            STATES.MuteRadio.Connection = connection
        end
    else
        if STATES.MuteRadio.Connection then
            STATES.MuteRadio.Connection:Disconnect()
            STATES.MuteRadio.Connection = nil
        end
    end
end

-- Фарминг системы
local FARMING = {}

function FARMING.getNearestCoin()
	local root = UTILS.getHRP()
	if not root then return nil, math.huge end
	
	local nearestCoin = nil
	local nearestDistance = math.huge
	
	for _, obj in ipairs(workspace:GetChildren()) do
		if obj:FindFirstChild("CoinContainer") then
			for _, coin in ipairs(obj.CoinContainer:GetChildren()) do
				if coin:IsA("BasePart") and coin:GetAttribute("CoinID") == "Coin" and coin:FindFirstChild("TouchInterest") then
					local distance = (root.Position - coin.Position).Magnitude
					if distance < nearestDistance then
						nearestDistance = distance
						nearestCoin = coin
					end
				end
			end
		end
	end
	
	return nearestCoin, nearestDistance
end

local farmingLoopActive = true

function FARMING.startFarmingLoop()
	task.spawn(function()
		while farmingLoopActive do
			local waitTime = 0.1
			
			if STATES.AutoFarm.Enabled and STATES.AutoFarm.Farming and not STATES.AutoFarm.BagFull then
				local coin, dist = FARMING.getNearestCoin()
				local hrp = UTILS.getHRP()
				
				if coin and hrp then
					if dist > 150 then
						hrp.CFrame = coin.CFrame
					else
						local tween = TweenService:Create(hrp, TweenInfo.new(dist / 25, Enum.EasingStyle.Linear), {CFrame = coin.CFrame})
						tween:Play()
						
						local startTime = tick()
						repeat
							task.wait()
							if tick() - startTime > 5 then break end
						until not coin:FindFirstChild("TouchInterest") or not STATES.AutoFarm.Farming or not STATES.AutoFarm.Enabled
						
						if tween then tween:Cancel() end
					end
				end
			elseif STATES.AutoFarm.Enabled then
				waitTime = 0.5
			else
				waitTime = 1
			end
			
			task.wait(waitTime)
		end
	end)
end

function FARMING.autoReset()
	if STATES.AutoFarm.Enabled and STATES.AutoFarm.BagFull and not STATES.AutoFarm.Resetting then
		STATES.AutoFarm.Resetting = true
		
		local hrp = UTILS.getHRP()
		if hrp and STATES.AutoFarm.StartPosition then
			local tween = TweenService:Create(hrp, TweenInfo.new(2, Enum.EasingStyle.Linear), {CFrame = STATES.AutoFarm.StartPosition})
			tween:Play()
			tween.Completed:Wait()
		end
		
		task.wait(0.5)
		
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			player.Character.Humanoid.Health = 0
		end
		
		player.CharacterAdded:Wait()
		task.wait(1.5)
		
		STATES.AutoFarm.Resetting = false
		STATES.AutoFarm.BagFull = false
	end
end

-- Kill All системы
local KILL_ALL = {}

function KILL_ALL.getPlayerRoleFromServer(targetPlayer)
	local getPlayerDataRemote = ReplicatedStorage:FindFirstChild("GetPlayerData", true)
	if getPlayerDataRemote and getPlayerDataRemote:IsA("RemoteFunction") then
		local playerData = getPlayerDataRemote:InvokeServer()
		return playerData and playerData[targetPlayer.Name] and playerData[targetPlayer.Name].Role
	end
	return nil
end

function KILL_ALL.hasKnife()
	local char = player.Character
	if not char then return false end
	
	if char:FindFirstChild("Knife") then return true end
	
	local knife = player.Backpack:FindFirstChild("Knife")
	if knife then
		knife.Parent = char
		return true
	end
	
	return false
end

function KILL_ALL.equipKnife()
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    if not character then return false end
    
    local knife = (backpack and backpack:FindFirstChild("Knife")) or character:FindFirstChild("Knife")
    
    if knife then
        if knife.Parent ~= character then
            knife.Parent = character
        end
        return true
    end
    return false
end

function KILL_ALL.getNearestTarget()
	local validTargets = {}
	local myRoot = UTILS.getHRP()
	if not myRoot then return nil end
	
	for _, targetPlayer in ipairs(Players:GetPlayers()) do
		if targetPlayer ~= player and targetPlayer.Character then
			local role = KILL_ALL.getPlayerRoleFromServer(targetPlayer)
			local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
			local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
			
			if role and humanoid and humanoid.Health > 0 and root and table.find(CONFIG.VALID_TARGET_ROLES, role) then
				local distance = (myRoot.Position - root.Position).Magnitude
				table.insert(validTargets, {
					Player = targetPlayer,
					Distance = distance
				})
			end
		end
	end
	
	table.sort(validTargets, function(a, b) return a.Distance < b.Distance end)
	
	return validTargets[1] and validTargets[1].Player or nil
end

function KILL_ALL.getAllValidTargets()
    local validTargets = {}
    
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Character then
            local role = KILL_ALL.getPlayerRoleFromServer(targetPlayer)
            local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
            
            if role and humanoid and humanoid.Health > 0 and table.find(CONFIG.VALID_TARGET_ROLES, role) then
                table.insert(validTargets, targetPlayer)
            end
        end
    end
    
    return validTargets
end

function KILL_ALL.killTargetThroughEvent(target)
    if not target or not target.Character then return false end
    
    local humanoid = target.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    
    if not KILL_ALL.equipKnife() then return false end
    
    task.wait(0.1)
    
    local myRoot = UTILS.getHRP()
    local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
    
    if not myRoot or not targetRoot then return false end
    
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local killEvent = remotes and remotes:FindFirstChild("Gameplay") and remotes.Gameplay:FindFirstChild("KillEvent")
    
    if not killEvent then
        local knife = player.Character:FindFirstChild("Knife")
        if knife and knife:FindFirstChild("Stab") then
            knife.Stab:FireServer("Down")
            task.wait(0.1)
            knife.Stab:FireServer("Down")
            return true
        end
        return false
    end
    
    targetRoot.CFrame = myRoot.CFrame * CFrame.new(0, 0, -3)
    
    pcall(function()
        killEvent:FireServer(target.Name, Color3.new(1, 0, 0))
    end)
    
    return true
end

local killAllLoopActive = true

function KILL_ALL.killAllPlayers()
    if not STATES.KillAll.Enabled then
        return
    end
    
    if not KILL_ALL.equipKnife() then
        return
    end
    
    task.wait(0.1)
    
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local killEvent = remotes and remotes:FindFirstChild("Gameplay") and remotes.Gameplay:FindFirstChild("KillEvent")
    
    if not killEvent then
        return
    end
    
    local allTargets = KILL_ALL.getAllValidTargets()
    local myRoot = UTILS.getHRP()
    
    if not myRoot then return end
    
    for _, target in ipairs(allTargets) do
        if not STATES.KillAll.Enabled then
            break
        end
        
        if target.Character and target.Character:FindFirstChild("Humanoid") and 
           target.Character.Humanoid.Health > 0 and 
           target.Character:FindFirstChild("HumanoidRootPart") then
            
            local targetRoot = target.Character.HumanoidRootPart
            targetRoot.CFrame = myRoot.CFrame * CFrame.new(0, 0, -3)
            
            pcall(function()
                killEvent:FireServer(target.Name, Color3.new(1, 0, 0))
            end)
            
            task.wait(STATES.KillAll.AttackDelay or 0.2)
        end
    end
end

function KILL_ALL.startKillAllLoop()
	task.spawn(function()
		while killAllLoopActive do
			local waitTime = 0.1
			
			if STATES.KillAll.Enabled and STATES.AutoFarm.BagFull then
				if KILL_ALL.hasKnife() then
				    KILL_ALL.killAllPlayers()
				    waitTime = 3
				else
					waitTime = 1
				end
			else
				waitTime = 0.5
			end
			
			task.wait(waitTime)
		end
	end)
end

-- Движение системы
local MOVEMENT = {}

function MOVEMENT.updateWalkSpeed()
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.WalkSpeed = STATES.Movement.SpeedWalk.Enabled and 
			STATES.Movement.SpeedWalk.Value or CONFIG.DEFAULT_WALK_SPEED
	end
end

function MOVEMENT.updateJumpPower()
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.JumpPower = STATES.Movement.JumpPower.Enabled and 
			STATES.Movement.JumpPower.Value or CONFIG.DEFAULT_JUMP_POWER
	end
end

-- RemoteEvents системы
local REMOTE_SYSTEM = {}

function REMOTE_SYSTEM.findRemoteEvents()
	for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
		if obj:IsA("RemoteEvent") then
			if obj.Name == "CoinCollected" then
				REMOTE_EVENTS.CoinCollected = obj
			elseif obj.Name == "RoundStart" then
				REMOTE_EVENTS.RoundStart = obj
			elseif obj.Name == "RoundEnd" then
				REMOTE_EVENTS.RoundEnd = obj
			end
		end
		
		if REMOTE_EVENTS.CoinCollected and REMOTE_EVENTS.RoundStart and REMOTE_EVENTS.RoundEnd then
			break
		end
	end
end

function REMOTE_SYSTEM.connectRemoteEvents()
	if REMOTE_EVENTS.CoinCollected then
		REMOTE_EVENTS.CoinCollected.OnClientEvent:Connect(function(_, current, max)
			if STATES.AutoFarm.Enabled then
				FARMING_STATS.CoinsCollected = FARMING_STATS.CoinsCollected + 1
			end
			
			if current == max and not STATES.AutoFarm.Resetting then
				STATES.AutoFarm.BagFull = true
				if STATES.AutoFarm.Enabled then
					task.spawn(FARMING.autoReset)
				end
			end
		end)
	end
	
	if REMOTE_EVENTS.RoundStart then
		REMOTE_EVENTS.RoundStart.OnClientEvent:Connect(function()
			STATES.AutoFarm.Farming = true
			STATES.AutoFarm.BagFull = false
			
			local hrp = UTILS.getHRP()
			if hrp then
				STATES.AutoFarm.StartPosition = hrp.CFrame
			end
		end)
	end
	
	if REMOTE_EVENTS.RoundEnd then
		REMOTE_EVENTS.RoundEnd.OnClientEvent:Connect(function()
			STATES.AutoFarm.Farming = false
			STATES.KillAll.Enabled = false
		end)
	end
end

-- Функция для создания Performance Stats Overlay
local function createPerformanceOverlay()
    if STATES.Performance.Overlay then
        return
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "StatsOverlay"
    screenGui.Parent = CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.DisplayOrder = 95
    screenGui.ResetOnSpawn = false
    
    local frame = UTILS.createWithStaticStroke("Frame", screenGui, {
        Name = "StatsFrame",
        Size = UDim2.new(0, 100, 0, 40),
        Position = STATES.Performance.Position or UDim2.new(0.5, -50, 0.5, -20),
        BackgroundColor3 = Color3.fromRGB(12, 16, 28),
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Active = true,
        ZIndex = 5
    })
    
    UTILS.createInstance("UICorner", frame, {CornerRadius = UDim.new(0, 4)})
    
    local bgGradient = UTILS.createInstance("UIGradient", frame, {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 30, 50)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 20, 35))
        }),
        Rotation = 90
    })
    
    local statsContainer = UTILS.createInstance("Frame", frame, {
        Name = "StatsContainer",
        Size = UDim2.new(1, -4, 1, -4),
        Position = UDim2.new(0, 2, 0, 2),
        BackgroundTransparency = 1,
        ZIndex = 6
    })
    
    local pingLabel = UTILS.createInstance("TextLabel", statsContainer, {
        Name = "PingLabel",
        Size = UDim2.new(1, 0, 0.5, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(210, 220, 240),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
        TextSize = 10,
        RichText = true,
        Text = "<font color='rgb(90, 140, 255)'>•</font> Ping: ...",
        ZIndex = 7
    })
    
    local fpsLabel = UTILS.createInstance("TextLabel", statsContainer, {
        Name = "FPSLabel",
        Size = UDim2.new(1, 0, 0.5, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(210, 220, 240),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
        TextSize = 10,
        RichText = true,
        Text = "<font color='rgb(90, 140, 255)'>•</font> FPS: ...",
        ZIndex = 7
    })
    
    local isDragging = false
    local dragStartPos
    local frameStartPos
    local dragTouchId
    local DRAG_THRESHOLD = 5
    
    local dragButton = UTILS.createInstance("TextButton", frame, {
        Name = "DragButton",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 10
    })
    
    dragButton.AutoButtonColor = false
    dragButton.Selected = false
    
    local function onDragStart(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            
            isDragging = false
            dragTouchId = input.UserInputType == Enum.UserInputType.Touch and input
            dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
            frameStartPos = frame.Position
            
            frame.BackgroundColor3 = Color3.fromRGB(25, 35, 55)
            
            return Enum.ContextActionResult.Sink
        end
    end
    
    local function onDrag(input)
        if not dragStartPos then return end
        
        if input.UserInputType == Enum.UserInputType.Touch then
            if not dragTouchId or dragTouchId ~= input then
                return
            end
        end
        
        local currentPos = Vector2.new(input.Position.X, input.Position.Y)
        local delta = currentPos - dragStartPos
        
        if not isDragging and delta.Magnitude > DRAG_THRESHOLD then
            isDragging = true
        end
        
        if isDragging then
            local newPosition = UDim2.new(
                frameStartPos.X.Scale,
                frameStartPos.X.Offset + delta.X,
                frameStartPos.Y.Scale,
                frameStartPos.Y.Offset + delta.Y
            )
            
            frame.Position = newPosition
        end
    end
    
    local function onDragEnd(input)
        frame.BackgroundColor3 = Color3.fromRGB(12, 16, 28)
        
        if isDragging then
            local finalPosition = frame.Position
            if not STATES.Performance then
                STATES.Performance = {}
            end
            STATES.Performance.Position = finalPosition
        end
        
        isDragging = false
        dragStartPos = nil
        dragTouchId = nil
        frameStartPos = nil
    end
    
    dragButton.InputBegan:Connect(onDragStart)
    dragButton.InputChanged:Connect(onDrag)
    dragButton.InputEnded:Connect(onDragEnd)
    
    local lastTime = tick()
    local frameCount = 0
    local updateConnection
    
    updateConnection = RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        if tick() - lastTime >= 1 then
            local success, ping = pcall(function()
                return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
            
            if success then
                local pingColor
                if ping < 50 then
                    pingColor = "rgb(100, 255, 100)"
                elseif ping < 100 then
                    pingColor = "rgb(255, 255, 100)"
                elseif ping < 200 then
                    pingColor = "rgb(255, 150, 100)"
                else
                    pingColor = "rgb(255, 100, 100)"
                end
                
                pingLabel.Text = string.format(
                    "<font color='rgb(90, 140, 255)'>•</font> Ping: <font color='%s'>%d</font>",
                    pingColor, ping
                )
            else
                pingLabel.Text = "<font color='rgb(90, 140, 255)'>•</font> Ping: ..."
            end
            
            local fpsColor
            if frameCount >= 60 then
                fpsColor = "rgb(100, 255, 100)"
            elseif frameCount >= 30 then
                fpsColor = "rgb(255, 255, 100)"
            else
                fpsColor = "rgb(255, 100, 100)"
            end
            
            fpsLabel.Text = string.format(
                "<font color='rgb(90, 140, 255)'>•</font> FPS: <font color='%s'>%d</font>",
                fpsColor, frameCount
            )
            
            frameCount = 0
            lastTime = tick()
        end
    end)
    
    STATES.Performance.Overlay = {
        gui = screenGui,
        frame = frame,
        connections = {
            update = updateConnection
        },
        destroy = function()
            if updateConnection then updateConnection:Disconnect() end
            if screenGui then screenGui:Destroy() end
            STATES.Performance.Overlay = nil
        end
    }
end

-- Фабрика для создания стилизованных кнопок
local function createStyledButton(parent, config)
    config = config or {}
    
    local buttonContainer = UTILS.createWithStaticStroke("Frame", parent, {
        Name = config.name or "StyledButton",
        BackgroundColor3 = config.backgroundColor or Color3.fromRGB(16, 22, 38),
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Size = config.size or UDim2.new(1, -20, 0, 50),
        Position = config.position or UDim2.new(0, 10, 0, 0),
        ZIndex = 5
    })
    
    UTILS.createInstance("UICorner", buttonContainer, {CornerRadius = UDim.new(0, 8)})
    
    local iconContainer = UTILS.createInstance("Frame", buttonContainer, {
        Name = "IconContainer",
        BackgroundColor3 = Color3.fromRGB(30, 42, 70),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 36, 0, 36),
        Position = UDim2.new(0, 12, 0.5, -18),
        ZIndex = 6
    })
    UTILS.createInstance("UICorner", iconContainer, {CornerRadius = UDim.new(1, 0)})
    
    local icon = UTILS.createInstance("ImageLabel", iconContainer, {
        Name = "Icon",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0.5, -12, 0.5, -12),
        Image = config.icon or "rbxthumb://type=Asset&id=77289067728929&w=150&h=150",
        ScaleType = Enum.ScaleType.Fit,
        ZIndex = 7
    })
    
    local titleLabel = UTILS.createInstance("TextLabel", buttonContainer, {
        Name = "Title",
        Text = config.title or "Button",
        TextColor3 = Color3.fromRGB(210, 220, 240),
        TextSize = 15,
        FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 55, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7
    })
    
    local button = UTILS.createInstance("TextButton", buttonContainer, {
        Name = "Button",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        AutoButtonColor = false,
        ZIndex = 8
    })
    
    button.MouseEnter:Connect(function()
        TweenService:Create(buttonContainer, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(25, 35, 58),
            BackgroundTransparency = 0.1
        }):Play()
        
        TweenService:Create(titleLabel, TweenInfo.new(0.15), {
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        
        TweenService:Create(iconContainer, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(45, 60, 95)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(buttonContainer, TweenInfo.new(0.15), {
            BackgroundColor3 = config.backgroundColor or Color3.fromRGB(16, 22, 38),
            BackgroundTransparency = 0.2
        }):Play()
        
        TweenService:Create(titleLabel, TweenInfo.new(0.15), {
            TextColor3 = Color3.fromRGB(210, 220, 240)
        }):Play()
        
        TweenService:Create(iconContainer, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(30, 42, 70)
        }):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        UTILS.playClickSound()
        
        TweenService:Create(buttonContainer, TweenInfo.new(0.05), {
            Size = UDim2.new(1, -20, 0, 48)
        }):Play()
        
        task.wait(0.05)
        
        TweenService:Create(buttonContainer, TweenInfo.new(0.05), {
            Size = config.size or UDim2.new(1, -20, 0, 50)
        }):Play()
        
        local originalColor = buttonContainer.BackgroundColor3
        buttonContainer.BackgroundColor3 = config.accentColor or CONFIG.MAIN_COLOR
        task.wait(0.1)
        buttonContainer.BackgroundColor3 = originalColor
        
        if config.onClick then
            config.onClick()
        end
    end)
    
    return {
        container = buttonContainer,
        button = button,
        title = titleLabel,
        icon = icon
    }
end

-- Функция создания тогглов
local function createToggle(parent, text, positionY, stateTable, stateKey, callback)
    local toggleFrame = UTILS.createWithStaticStroke("Frame", parent, {
        Name = text .. "Toggle",
        Size = UDim2.new(1, -20, 0, 45),
        Position = UDim2.new(0, 10, 0, positionY),
        BackgroundColor3 = Color3.fromRGB(16, 22, 38),
        BackgroundTransparency = 0.5,
        ZIndex = 5
    })
    UTILS.createInstance("UICorner", toggleFrame, {CornerRadius = UDim.new(0, 8)})
    
    local title = UTILS.createInstance("TextLabel", toggleFrame, {
        Text = text,
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(200, 210, 230),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6
    })
    
    local switchBg = UTILS.createInstance("Frame", toggleFrame, {
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -55, 0.5, -10),
        BackgroundColor3 = stateTable[stateKey] and CONFIG.MAIN_COLOR or Color3.fromRGB(35, 45, 70),
        ZIndex = 6
    })
    UTILS.createInstance("UICorner", switchBg, {CornerRadius = UDim.new(1, 0)})
    
    local ball = UTILS.createInstance("Frame", switchBg, {
        Size = UDim2.new(0, 16, 0, 16),
        Position = stateTable[stateKey] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 7
    })
    UTILS.createInstance("UICorner", ball, {CornerRadius = UDim.new(1, 0)})
    
    local button = UTILS.createInstance("TextButton", toggleFrame, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 8
    })
    
    button.MouseButton1Click:Connect(function()
        stateTable[stateKey] = not stateTable[stateKey]
        local newState = stateTable[stateKey]
        
        TweenService:Create(switchBg, TweenInfo.new(0.3), {
            BackgroundColor3 = newState and CONFIG.MAIN_COLOR or Color3.fromRGB(35, 45, 70)
        }):Play()
        
        TweenService:Create(ball, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Position = newState and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }):Play()
        
        if callback then
            task.spawn(callback, newState)
        end        
        UTILS.playClickSound()
    end)
    
    button.MouseEnter:Connect(function()
        TweenService:Create(toggleFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(22, 30, 50),
            BackgroundTransparency = 0.3
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(toggleFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(16, 22, 38),
            BackgroundTransparency = 0.5
        }):Play()
    end)
    
    return toggleFrame, button
end

-- UI системы
local UI_SYSTEM = {}

function UI_SYSTEM.createPlayerInfoContainer(parent)
	local playerInfoContainer = UTILS.createWithStaticStroke("Frame", parent, {
		Name = "PlayerInfoContainer",
		BackgroundColor3 = Color3.fromRGB(16, 22, 38),
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 360, 0, 100),
		Position = UDim2.new(0, 8, 0, 8),
		ZIndex = 5
	})
	
	UTILS.createInstance("UICorner", playerInfoContainer, {CornerRadius = UDim.new(0, 8)})
	
	local avatarInfoFrame = UTILS.createInstance("Frame", playerInfoContainer, {
		Name = "AvatarInfoFrame",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -16, 1, -8),
		Position = UDim2.new(0, 8, 0, 8),
		ZIndex = 6
	})
	
	local playerAvatar = UTILS.createInstance("ImageLabel", avatarInfoFrame, {
		Name = "PlayerAvatar",
		BackgroundColor3 = Color3.fromRGB(30, 42, 70),
		BorderSizePixel = 0,
		Size = UDim2.new(0, 64, 0, 64),
		Position = UDim2.new(0, 0, 0, 0),
		Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150", player.UserId),
		ZIndex = 7
	})
	
	UTILS.createInstance("UICorner", playerAvatar, {CornerRadius = UDim.new(0, 8)})
	
	local infoFrame = UTILS.createInstance("Frame", avatarInfoFrame, {
		Name = "InfoFrame",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -72, 1, 0),
		Position = UDim2.new(0, 72, 0, 0),
		ZIndex = 6
	})
	
	UTILS.createInstance("TextLabel", infoFrame, {
		Name = "DisplayName",
		Text = player.DisplayName,
		TextColor3 = Color3.fromRGB(230, 235, 250),
		TextSize = 18,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 24),
		Position = UDim2.new(0, 0, 0, 0),
		ZIndex = 7
	})
	
	UTILS.createInstance("TextLabel", infoFrame, {
		Name = "Username",
		Text = "@" .. player.Name,
		TextColor3 = Color3.fromRGB(170, 185, 210),
		TextSize = 12,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 18),
		Position = UDim2.new(0, 0, 0, 24),
		ZIndex = 7
	})
	
	UTILS.createInstance("TextLabel", infoFrame, {
		Name = "GameName",
		Text = "Murder Mystery 2",
		TextColor3 = Color3.fromRGB(150, 170, 210),
		TextSize = 14,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 20),
		Position = UDim2.new(0, 0, 0, 48),
		ZIndex = 7
	})
	
	UTILS.createInstance("TextLabel", infoFrame, {
		Name = "PlayerId",
		Text = "Player ID: " .. tostring(player.UserId),
		TextColor3 = Color3.fromRGB(170, 185, 210),
		TextSize = 12,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		BackgroundTransparency = 1,
		Size = UDim2.new(0.48, -4, 0, 18),
		Position = UDim2.new(0, 0, 0, 72),
		ZIndex = 7
	})
	
	UTILS.createInstance("TextLabel", infoFrame, {
		Name = "ServerId",
		Text = "Server ID: " .. tostring(game.PlaceId),
		TextColor3 = Color3.fromRGB(170, 185, 210),
		TextSize = 12,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		BackgroundTransparency = 1,
		Size = UDim2.new(0.48, -4, 0, 18),
		Position = UDim2.new(0.52, 0, 0, 72),
		ZIndex = 7
	})
	
	return playerInfoContainer
end

function UI_SYSTEM.createSpeedJumpContainer(parent)
	local speedJumpContainer = UTILS.createWithStaticStroke("Frame", parent, {
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(12, 16, 28),
		BackgroundTransparency = 0.5,
		Size = UDim2.new(0, 360, 0, 180),
		Position = UDim2.new(0, 8, 0, 116),
		Name = "SpeedJumpContainer",
		ZIndex = 5
	})
	
	UTILS.createInstance("UICorner", speedJumpContainer, {CornerRadius = UDim.new(0, 8)})
	
	UTILS.createInstance("TextLabel", speedJumpContainer, {
		Name = "SpeedJumpTitle",
		Text = "Speed And Jump",
		TextColor3 = Color3.fromRGB(210, 220, 240),
		TextSize = 14,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 20),
		Position = UDim2.new(0, 0, 0, 8),
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 6
	})
	
	local speedWalkToggle = createToggle(speedJumpContainer, "Speed Walk", 32, STATES.Movement.SpeedWalk, "Enabled", function(isEnabled)
		STATES.Movement.SpeedWalk.Enabled = isEnabled
		MOVEMENT.updateWalkSpeed()
	end)
	
	local speedWalkSliderContainer = UTILS.createInstance("Frame", speedJumpContainer, {
		Name = "SpeedWalkSliderContainer",
		BackgroundColor3 = Color3.fromRGB(16, 22, 38),
		BackgroundTransparency = 0.2,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -20, 0, 24),
		Position = UDim2.new(0, 10, 0, 76),
		ZIndex = 6
	})
	
	UTILS.createInstance("UICorner", speedWalkSliderContainer, {CornerRadius = UDim.new(0, 8)})
	
	local speedWalkSlider = UTILS.createInstance("Frame", speedWalkSliderContainer, {
		Name = "SpeedWalkSlider",
		BackgroundColor3 = Color3.fromRGB(40, 55, 95),
		BorderSizePixel = 0,
		Size = UDim2.new(0, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		ZIndex = 7
	})
	
	UTILS.createInstance("UICorner", speedWalkSlider, {CornerRadius = UDim.new(0, 8)})
	
	local speedWalkValue = UTILS.createInstance("TextLabel", speedWalkSliderContainer, {
		Name = "SpeedWalkValue",
		Text = "16",
		TextColor3 = Color3.fromRGB(210, 220, 240),
		TextSize = 12,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 8
	})
	
	local jumpPowerToggle = createToggle(speedJumpContainer, "Jump Power", 104, STATES.Movement.JumpPower, "Enabled", function(isEnabled)
		STATES.Movement.JumpPower.Enabled = isEnabled
		MOVEMENT.updateJumpPower()
	end)
	
	local jumpPowerSliderContainer = UTILS.createInstance("Frame", speedJumpContainer, {
		Name = "JumpPowerSliderContainer",
		BackgroundColor3 = Color3.fromRGB(16, 22, 38),
		BackgroundTransparency = 0.2,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -20, 0, 24),
		Position = UDim2.new(0, 10, 0, 148),
		ZIndex = 6
	})
	
	UTILS.createInstance("UICorner", jumpPowerSliderContainer, {CornerRadius = UDim.new(0, 8)})
	
	local jumpPowerSlider = UTILS.createInstance("Frame", jumpPowerSliderContainer, {
		Name = "JumpPowerSlider",
		BackgroundColor3 = Color3.fromRGB(40, 55, 95),
		BorderSizePixel = 0,
		Size = UDim2.new(0, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		ZIndex = 7
	})
	
	UTILS.createInstance("UICorner", jumpPowerSlider, {CornerRadius = UDim.new(0, 8)})
	
	local jumpPowerValue = UTILS.createInstance("TextLabel", jumpPowerSliderContainer, {
		Name = "JumpPowerValue",
		Text = "50",
		TextColor3 = Color3.fromRGB(210, 220, 240),
		TextSize = 12,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 8
	})
	
	local speedWalkSliderObj = UI_SYSTEM.createSlider(
		speedWalkSlider,
		speedWalkValue,
		16, 116, 16,
		function(value)
			STATES.Movement.SpeedWalk.Value = value
			if STATES.Movement.SpeedWalk.Enabled then
				MOVEMENT.updateWalkSpeed()
			end
		end
	)
	
	local jumpPowerSliderObj = UI_SYSTEM.createSlider(
		jumpPowerSlider,
		jumpPowerValue,
		50, 150, 50,
		function(value)
			STATES.Movement.JumpPower.Value = value
			if STATES.Movement.JumpPower.Enabled then
				MOVEMENT.updateJumpPower()
			end
		end
	)
	
	return speedJumpContainer
end

function UI_SYSTEM.createSlider(sliderFrame, valueLabel, minValue, maxValue, defaultValue, callback)
	local isDragging = false
	local currentValue = defaultValue or minValue
	local startPercentage = (defaultValue - minValue) / (maxValue - minValue)
	
	local thumb = UTILS.createInstance("Frame", sliderFrame.Parent, {
		Name = "SliderThumb",
		Size = UDim2.new(0, 20, 0, 20),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(startPercentage, 0, 0.5, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		ZIndex = 15
	})
	
	UTILS.createInstance("UICorner", thumb, {CornerRadius = UDim.new(1, 0)})
	UTILS.createInstance("UIStroke", thumb, {
		Thickness = 2,
		Color = CONFIG.MAIN_COLOR
	})
	
	sliderFrame.Size = UDim2.new(startPercentage, 0, 1, 0)
	
	local function updateSlider(positionX)
		local containerWidth = sliderFrame.Parent.AbsoluteSize.X
		local newX = math.clamp(positionX, 0, containerWidth)
		local percentage = newX / containerWidth
		local value = math.floor(minValue + (maxValue - minValue) * percentage)
		
		TweenService:Create(sliderFrame, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(percentage, 0, 1, 0)
		}):Play()
		
		TweenService:Create(thumb, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.new(percentage, 0, 0.5, 0)
		}):Play()
		
		valueLabel.Text = tostring(value)
		currentValue = value
		
		thumb.BackgroundColor3 = isDragging and Color3.fromRGB(160, 190, 255) or Color3.fromRGB(255, 255, 255)
		sliderFrame.BackgroundColor3 = isDragging and Color3.fromRGB(60, 80, 130) or Color3.fromRGB(40, 55, 95)
		
		if callback then callback(value) end
	end
	
	local containerButton = UTILS.createInstance("TextButton", sliderFrame.Parent, {
		Name = "SliderButton",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		Text = "",
		AutoButtonColor = false,
		ZIndex = 10
	})
	
	local thumbButton = UTILS.createInstance("TextButton", thumb, {
		Name = "ThumbButton",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		Text = "",
		AutoButtonColor = false,
		ZIndex = 20
	})
	
	local function handleContainerInputBegan(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = true
			local containerPosition = sliderFrame.Parent.AbsolutePosition
			local relativeX = input.Position.X - containerPosition.X
			updateSlider(relativeX)
		end
	end
	
	local thumbStartPos, thumbStartMousePos
	
	local function handleThumbInputBegan(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = true
			thumbStartPos = thumb.Position
			thumbStartMousePos = input.Position
			thumb.BackgroundColor3 = Color3.fromRGB(160, 190, 255)
		end
	end
	
	local function handleInputEnded(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = false
			thumbStartPos = nil
			thumbStartMousePos = nil
			
			TweenService:Create(thumb, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			}):Play()
			
			TweenService:Create(sliderFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundColor3 = Color3.fromRGB(40, 55, 95)
			}):Play()
		end
	end
	
	local function handleThumbInputChanged(input)
		if isDragging and thumbStartPos and thumbStartMousePos and 
		   (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local containerPosition = sliderFrame.Parent.AbsolutePosition
			local containerWidth = sliderFrame.Parent.AbsoluteSize.X
			local deltaX = input.Position.X - thumbStartMousePos.X
			local newX = math.clamp((thumbStartPos.X.Scale * containerWidth) + deltaX, 0, containerWidth)
			updateSlider(newX)
		end
	end
	
	local function handleContainerInputChanged(input)
		if isDragging and not thumbStartPos and 
		   (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local containerPosition = sliderFrame.Parent.AbsolutePosition
			local relativeX = input.Position.X - containerPosition.X
			updateSlider(relativeX)
		end
	end
	
	containerButton.InputBegan:Connect(handleContainerInputBegan)
	containerButton.InputEnded:Connect(handleInputEnded)
	containerButton.InputChanged:Connect(handleContainerInputChanged)
	
	thumbButton.InputBegan:Connect(handleThumbInputBegan)
	thumbButton.InputEnded:Connect(handleInputEnded)
	thumbButton.InputChanged:Connect(handleThumbInputChanged)
	
	local function setValue(newValue)
		newValue = math.clamp(newValue, minValue, maxValue)
		local percentage = (newValue - minValue) / (maxValue - minValue)
		
		TweenService:Create(sliderFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(percentage, 0, 1, 0)
		}):Play()
		
		TweenService:Create(thumb, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.new(percentage, 0, 0.5, 0)
		}):Play()
		
		valueLabel.Text = tostring(newValue)
		currentValue = newValue
		
		if callback then callback(newValue) end
	end
	
	thumbButton.MouseEnter:Connect(function()
		if not isDragging then
			TweenService:Create(thumb, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 24, 0, 24),
				BackgroundColor3 = Color3.fromRGB(200, 215, 255)
			}):Play()
		end
	end)
	
	thumbButton.MouseLeave:Connect(function()
		if not isDragging then
			TweenService:Create(thumb, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 20, 0, 20),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			}):Play()
		end
	end)
	
	containerButton.MouseEnter:Connect(function()
		TweenService:Create(sliderFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = Color3.fromRGB(50, 70, 115)
		}):Play()
	end)
	
	containerButton.MouseLeave:Connect(function()
		if not isDragging then
			TweenService:Create(sliderFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundColor3 = Color3.fromRGB(40, 55, 95)
			}):Play()
		end
	end)
	
	setValue(defaultValue)
	
	return {
		setValue = setValue,
		getValue = function() return currentValue end,
		thumb = thumb
	}
end

function UI_SYSTEM.createTabButton(parent, text, positionY, tabName, contentFrame)
	local tabFrame = UTILS.createWithStaticStroke("Frame", parent, {
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(22, 30, 50),
		Size = UDim2.new(0, 116, 0, 48),
		Position = UDim2.new(0, 4, 0, positionY),
		Name = "Tab_" .. tabName,
		BackgroundTransparency = 0.7,
		ZIndex = 12
	})
	
	UTILS.createInstance("UICorner", tabFrame, {CornerRadius = UDim.new(0, 5)})
	
	local tabButton = UTILS.createInstance("TextButton", tabFrame, {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Name = "TabButton_" .. tabName,
		ZIndex = 15
	})
	
	local textLabel = UTILS.createInstance("TextLabel", tabFrame, {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = Color3.fromRGB(200, 210, 230),
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
		TextSize = 13,
		TextWrapped = true,
		ZIndex = 13
	})
	
	local tabContentScrolling = UTILS.createInstance("ScrollingFrame", contentFrame, {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Visible = false,
		Name = "content_" .. tabName,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = Color3.fromRGB(70, 100, 170),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		BorderSizePixel = 0,
		ZIndex = 5
	})
	
	local tabContent = UTILS.createInstance("Frame", tabContentScrolling, {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		Name = "contentContainer_" .. tabName,
		ZIndex = 5
	})
	
	return tabButton, tabFrame, tabContent, textLabel, tabContentScrolling
end

function UI_SYSTEM.createShootMurdererButton()
	local ScreenGui_1 = UTILS.createInstance("ScreenGui", CoreGui, {
		Name = "ShootMurdererGui",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		DisplayOrder = 50
	})
	
	local shootButton_2 = UTILS.createWithStaticStroke("Frame", ScreenGui_1, {
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(16, 22, 38),
		Size = UDim2.new(0, 184, 0, 82),
		Position = STATES.ShootMurderer.Position or UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Name = "shootButton",
		BackgroundTransparency = 0.3,
		ZIndex = 1
	})
	
	UTILS.createInstance("UICorner", shootButton_2, {CornerRadius = UDim.new(0, 5)})
	
	local backgroundGradient = UTILS.createInstance("UIGradient", shootButton_2, {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 35, 55)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 20, 35))
		}),
		Rotation = 90
	})
	
	local TextLabel_5 = UTILS.createInstance("TextLabel", shootButton_2, {
		BorderSizePixel = 0,
		TextSize = 19,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Text = "Shoot Murderer",
		TextColor3 = Color3.fromRGB(210, 220, 240),
		TextScaled = false,
		TextWrapped = true,
		ZIndex = 2
	})
	
	local isDragging = false
	local dragStartPos
	local buttonStartPos
	local dragTouchId
	local wasClick = false
	local DRAG_THRESHOLD = 5
	
	local instakillshoot = false
	local shootOffset = 2.8
	
	local function findMurderer()
		for _, i in ipairs(Players:GetPlayers()) do
			if i.Backpack:FindFirstChild("Knife") then
				return i
			end
		end
	
		for _, i in ipairs(Players:GetPlayers()) do
			if not i.Character then continue end
			if i.Character:FindFirstChild("Knife") then
				return i
			end
		end
	
		return nil
	end
	
	local function findSheriff()
		for _, i in ipairs(Players:GetPlayers()) do
			if i.Backpack:FindFirstChild("Gun") then
				return i
			end
		end
	
		for _, i in ipairs(Players:GetPlayers()) do
			if not i.Character then continue end
			if i.Character:FindFirstChild("Gun") then
				return i
			end
		end
	
		return nil
	end
	
	local function getPredictedPosition(targetPlayer, offset)
		if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local playerHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
			local playerHum = targetPlayer.Character:FindFirstChild("Humanoid")
			
			if not playerHRP or not playerHum then
				return playerHRP and playerHRP.Position or Vector3.new(0, 0, 0)
			end
	
			local velocity = playerHRP.AssemblyLinearVelocity
			local playerMoveDirection = playerHum.MoveDirection
			
			local predictedPosition = playerHRP.Position + 
				((velocity * Vector3.new(0.75, 0.5, 0.75))) * (offset / 15) + 
				playerMoveDirection * offset
				
			return predictedPosition
		end
		return Vector3.new(0, 0, 0)
	end
	
	local function shootMurdererFunction()
		if findSheriff() ~= player then 
			return 
		end
	
		local murderer = findMurderer()
		if not murderer then
			return
		end
	
		if not player.Character then
			return
		end
	
		if not player.Character:FindFirstChild("Gun") then
			local hum = player.Character:FindFirstChild("Humanoid")
			if hum and player.Backpack:FindFirstChild("Gun") then
				hum:EquipTool(player.Backpack:FindFirstChild("Gun"))
			else
				return
			end
		end
	
		local murdererHRP = murderer.Character:FindFirstChild("HumanoidRootPart")
		if not murdererHRP then
			return
		end
	
		local predictedPosition = getPredictedPosition(murderer, shootOffset)
	
		local args
		if instakillshoot then
			args = {
				CFrame.new(murdererHRP.Position + Vector3.new(0, 1, 0)),
				CFrame.new(murdererHRP.Position)
			}
		else
			if not player.Character:FindFirstChild("RightHand") then
				return
			end
			args = {
				CFrame.new(player.Character.RightHand.Position),
				CFrame.new(predictedPosition)
			}
		end
		
		local gun = player.Character:WaitForChild("Gun")
		local shootEvent = gun:WaitForChild("Shoot")
		shootEvent:FireServer(unpack(args))
		
		local originalColor = shootButton_2.BackgroundColor3
		local flashTween = TweenService:Create(shootButton_2, TweenInfo.new(0.1), {
			BackgroundColor3 = Color3.fromRGB(255, 100, 100)
		})
		flashTween:Play()
		
		task.wait(0.1)
		
		local returnTween = TweenService:Create(shootButton_2, TweenInfo.new(0.1), {
			BackgroundColor3 = originalColor
		})
		returnTween:Play()
	end
	
	local function onDragStart(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or 
		   input.UserInputType == Enum.UserInputType.Touch then
			
			isDragging = false
			wasClick = true
			dragTouchId = input.UserInputType == Enum.UserInputType.Touch and input
			dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
			buttonStartPos = shootButton_2.Position
			
			shootButton_2.BackgroundColor3 = Color3.fromRGB(25, 35, 55)
			shootButton_2.BackgroundTransparency = 0.2
			
			return Enum.ContextActionResult.Sink
		end
	end
	
	local function onDrag(input)
		if not dragStartPos then return end
		
		if input.UserInputType == Enum.UserInputType.Touch then
			if not dragTouchId or dragTouchId ~= input then
				return
			end
		end
		
		local currentPos = Vector2.new(input.Position.X, input.Position.Y)
		local delta = currentPos - dragStartPos
		
		if not isDragging and delta.Magnitude > DRAG_THRESHOLD then
			isDragging = true
			wasClick = false
		end
		
		if isDragging then
			local newPosition = UDim2.new(
				buttonStartPos.X.Scale,
				buttonStartPos.X.Offset + delta.X,
				buttonStartPos.Y.Scale,
				buttonStartPos.Y.Offset + delta.Y
			)
			
			shootButton_2.Position = newPosition
		end
	end
	
	local function onDragEnd(input)
		if wasClick and not isDragging then
			UTILS.playClickSound()
			shootMurdererFunction()
		end
		
		shootButton_2.BackgroundColor3 = Color3.fromRGB(16, 22, 38)
		shootButton_2.BackgroundTransparency = 0.3
		TextLabel_5.TextColor3 = Color3.fromRGB(210, 220, 240)
		
		if isDragging then
			local finalPosition = shootButton_2.Position
			STATES.ShootMurderer.Position = finalPosition
		end
		
		isDragging = false
		wasClick = false
		dragStartPos = nil
		dragTouchId = nil
		buttonStartPos = nil
	end
	
	local dragButton = UTILS.createInstance("TextButton", shootButton_2, {
		Name = "DragButton",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 10
	})
	
	dragButton.InputBegan:Connect(onDragStart)
	dragButton.InputChanged:Connect(onDrag)
	dragButton.InputEnded:Connect(onDragEnd)
	
	dragButton.MouseEnter:Connect(function()
		if not isDragging then
			shootButton_2.BackgroundTransparency = 0.2
			shootButton_2.BackgroundColor3 = Color3.fromRGB(22, 30, 50)
			TextLabel_5.TextColor3 = Color3.fromRGB(255, 255, 255)
		end
	end)
	
	dragButton.MouseLeave:Connect(function()
		if not isDragging then
			shootButton_2.BackgroundTransparency = 0.3
			shootButton_2.BackgroundColor3 = Color3.fromRGB(16, 22, 38)
			TextLabel_5.TextColor3 = Color3.fromRGB(210, 220, 240)
		end
	end)
	
	return {
		gui = ScreenGui_1,
		destroy = function()
			if ScreenGui_1 then ScreenGui_1:Destroy() end
		end
	}
end

function UI_SYSTEM.createEspContainer(parent)
	local espContainer = UTILS.createWithStaticStroke("Frame", parent, {
		Name = "EspContainer",
		BackgroundColor3 = Color3.fromRGB(16, 22, 38),
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -20, 0, 300),
		Position = UDim2.new(0, 10, 0, 20),
		ZIndex = 5
	})
	
	UTILS.createInstance("UICorner", espContainer, {CornerRadius = UDim.new(0, 8)})
	
	UTILS.createInstance("TextLabel", espContainer, {
		Name = "EspTitle",
		Text = "ESP",
		TextColor3 = Color3.fromRGB(210, 220, 240),
		TextSize = 16,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 30),
		Position = UDim2.new(0, 0, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 6
	})
	
	local currentY = 40
	local toggleSpacing = 52
	
	local espNameToggle = createToggle(espContainer, "ESP Name", currentY, ESP_SYSTEM.ESP_STATES, "ESPName", function(isEnabled)
		if not isEnabled then
			ESP_SYSTEM.clearAllESP()
		else
			ESP_SYSTEM.updateESP()
		end
	end)
	currentY = currentY + toggleSpacing
	
	local murdererToggle = createToggle(espContainer, "Murderer Name", currentY, ESP_SYSTEM.ESP_STATES, "MurdererName", function(isEnabled)
		if ESP_SYSTEM.ESP_STATES.ESPName then
			ESP_SYSTEM.updateESP()
		end
	end)
	currentY = currentY + toggleSpacing
	
	local sheriffToggle = createToggle(espContainer, "Sheriff Name", currentY, ESP_SYSTEM.ESP_STATES, "SheriffName", function(isEnabled)
		if ESP_SYSTEM.ESP_STATES.ESPName then
			ESP_SYSTEM.updateESP()
		end
	end)
	currentY = currentY + toggleSpacing
	
	local heroToggle = createToggle(espContainer, "Hero Name", currentY, ESP_SYSTEM.ESP_STATES, "HeroName", function(isEnabled)
		if ESP_SYSTEM.ESP_STATES.ESPName then
			ESP_SYSTEM.updateESP()
		end
	end)
	currentY = currentY + toggleSpacing
	
	local innocentToggle = createToggle(espContainer, "Innocent Name", currentY, ESP_SYSTEM.ESP_STATES, "InnocentName", function(isEnabled)
		if ESP_SYSTEM.ESP_STATES.ESPName then
			ESP_SYSTEM.updateESP()
		end
	end)
	
	return espContainer
end

function UI_SYSTEM.createEspHighlightContainer(parent)
	local espHighlightContainer = UTILS.createWithStaticStroke("Frame", parent, {
		Name = "EspHighlightContainer",
		BackgroundColor3 = Color3.fromRGB(16, 22, 38),
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -20, 0, 300),
		Position = UDim2.new(0, 10, 0, 330),
		ZIndex = 5
	})
	
	UTILS.createInstance("UICorner", espHighlightContainer, {CornerRadius = UDim.new(0, 8)})
	
	UTILS.createInstance("TextLabel", espHighlightContainer, {
		Name = "EspHighlightTitle",
		Text = "ESP Highlight",
		TextColor3 = Color3.fromRGB(210, 220, 240),
		TextSize = 16,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 30),
		Position = UDim2.new(0, 0, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 6
	})
	
	local currentY = 40
	local toggleSpacing = 52
	
	local espHighlightToggle = createToggle(espHighlightContainer, "ESP Highlight", currentY, ESP_SYSTEM.ESP_HIGHLIGHT_STATES, "ESPHighlight", function(isEnabled)
		if not isEnabled then
			ESP_SYSTEM.clearAllHighlights()
		else
			ESP_SYSTEM.updateHighlights()
		end
	end)
	currentY = currentY + toggleSpacing
	
	local espHighlightMurderer = createToggle(espHighlightContainer, "ESP Highlight Murderer", currentY, ESP_SYSTEM.ESP_HIGHLIGHT_STATES, "ESPHighlightMurderer", function(isEnabled)
		if ESP_SYSTEM.ESP_HIGHLIGHT_STATES.ESPHighlight then
			ESP_SYSTEM.updateHighlights()
		end
	end)
	currentY = currentY + toggleSpacing
	
	local espHighlightSheriff = createToggle(espHighlightContainer, "ESP Highlight Sheriff", currentY, ESP_SYSTEM.ESP_HIGHLIGHT_STATES, "ESPHighlightSheriff", function(isEnabled)
		if ESP_SYSTEM.ESP_HIGHLIGHT_STATES.ESPHighlight then
			ESP_SYSTEM.updateHighlights()
		end
	end)
	currentY = currentY + toggleSpacing
	
	local espHighlightHero = createToggle(espHighlightContainer, "ESP Highlight Hero", currentY, ESP_SYSTEM.ESP_HIGHLIGHT_STATES, "ESPHighlightHero", function(isEnabled)
		if ESP_SYSTEM.ESP_HIGHLIGHT_STATES.ESPHighlight then
			ESP_SYSTEM.updateHighlights()
		end
	end)
	currentY = currentY + toggleSpacing
	
	local espHighlightInnocent = createToggle(espHighlightContainer, "ESP Highlight Innocent", currentY, ESP_SYSTEM.ESP_HIGHLIGHT_STATES, "ESPHighlightInnocent", function(isEnabled)
		if ESP_SYSTEM.ESP_HIGHLIGHT_STATES.ESPHighlight then
			ESP_SYSTEM.updateHighlights()
		end
	end)
	
	return espHighlightContainer
end

function UI_SYSTEM.createEspLineContainer(parent)
	local espLineContainer = UTILS.createWithStaticStroke("Frame", parent, {
		Name = "EspLineContainer",
		BackgroundColor3 = Color3.fromRGB(16, 22, 38),
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -20, 0, 300),
		Position = UDim2.new(0, 10, 0, 640),
		ZIndex = 5
	})
	
	UTILS.createInstance("UICorner", espLineContainer, {CornerRadius = UDim.new(0, 8)})
	
	UTILS.createInstance("TextLabel", espLineContainer, {
		Name = "EspLineTitle",
		Text = "Tracers",
		TextColor3 = Color3.fromRGB(210, 220, 240),
		TextSize = 16,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 30),
		Position = UDim2.new(0, 0, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 6
	})
	
	local currentY = 40
	local toggleSpacing = 52
	
	local espLineToggle = createToggle(espLineContainer, "ESP Tracer", currentY, ESP_SYSTEM.ESP_LINE_STATES, "ESPLine", function(isEnabled)
		if isEnabled then
			ESP_SYSTEM.StartAllLines()
		else
			ESP_SYSTEM.StopAllLines()
		end
	end)
	currentY = currentY + toggleSpacing
	
	local espLineMurderer = createToggle(espLineContainer, "Murderer Tracer", currentY, ESP_SYSTEM.ESP_LINE_STATES, "MurdererLine", function(isEnabled)
		if ESP_SYSTEM.ESP_LINE_STATES.ESPLine then
			ESP_SYSTEM.StartAllLines()
		end
	end)
	currentY = currentY + toggleSpacing
	
	local espLineSheriff = createToggle(espLineContainer, "Sheriff Tracer", currentY, ESP_SYSTEM.ESP_LINE_STATES, "SheriffLine", function(isEnabled)
		if ESP_SYSTEM.ESP_LINE_STATES.ESPLine then
			ESP_SYSTEM.StartAllLines()
		end
	end)
	currentY = currentY + toggleSpacing
	
	local espLineHero = createToggle(espLineContainer, "Hero Tracer", currentY, ESP_SYSTEM.ESP_LINE_STATES, "HeroLine", function(isEnabled)
		if ESP_SYSTEM.ESP_LINE_STATES.ESPLine then
			ESP_SYSTEM.StartAllLines()
		end
	end)
	currentY = currentY + toggleSpacing
	
	local espLineInnocent = createToggle(espLineContainer, "Innocent Tracer", currentY, ESP_SYSTEM.ESP_LINE_STATES, "InnocentLine", function(isEnabled)
		if ESP_SYSTEM.ESP_LINE_STATES.ESPLine then
			ESP_SYSTEM.StartAllLines()
		end
	end)
	
	return espLineContainer
end

function UI_SYSTEM.createMainTabContent(content)
	UI_SYSTEM.createPlayerInfoContainer(content)
	UI_SYSTEM.createSpeedJumpContainer(content)
    
    local performanceY = 116 + 180 + 20
    local performanceToggle = createToggle(content, "Performance (Ping & Fps)", performanceY, STATES.Performance, "Enabled", function(isEnabled)
		if isEnabled then
			createPerformanceOverlay()
		else
			if STATES.Performance.Overlay then
				STATES.Performance.Overlay.destroy()
			end
		end
	end)
end

function UI_SYSTEM.createVisualTabContent(content)
	local espContainer = UI_SYSTEM.createEspContainer(content)
	local espHighlightContainer = UI_SYSTEM.createEspHighlightContainer(content)
	local espLineContainer = UI_SYSTEM.createEspLineContainer(content)
	return espContainer, espHighlightContainer, espLineContainer
end

function UI_SYSTEM.createCombatTabContent(content)
	local shootToggle = createToggle(content, "Shoot The Murderer", 32, STATES, "ShootMurdererTemp", function(isEnabled)
		if isEnabled then
			if not STATES.ShootMurderer.ButtonData then
				STATES.ShootMurderer.ButtonData = UI_SYSTEM.createShootMurdererButton()
			end
		else
			if STATES.ShootMurderer.ButtonData then
				STATES.ShootMurderer.ButtonData.destroy()
				STATES.ShootMurderer.ButtonData = nil
			end
		end
	end)
end

STATES.ShootMurdererTemp = false

function UI_SYSTEM.createTeleportTabContent(content)
    local currentY = 20
    
    local bombContainer = UTILS.createWithStaticStroke("Frame", content, {
        Name = "FakeBombJumpContainer",
        BackgroundColor3 = Color3.fromRGB(16, 22, 38),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -20, 0, 100),
        Position = UDim2.new(0, 10, 0, currentY),
        ZIndex = 5
    })
    
    UTILS.createInstance("UICorner", bombContainer, {CornerRadius = UDim.new(0, 8)})
    
    UTILS.createInstance("TextLabel", bombContainer, {
        Name = "BombContainerTitle",
        Text = "Fake Bomb Jump",
        TextColor3 = Color3.fromRGB(210, 220, 240),
        TextSize = 16,
        FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 5),
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 6
    })
    
    local bombButtonData = nil
    
    local function createBombButton()
        if bombButtonData then return end
        
        local bombGui = UTILS.createInstance("ScreenGui", CoreGui, {
            Name = "FakeBombJumpGui",
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            ResetOnSpawn = false,
            DisplayOrder = 50
        })
        
        local bombFrame = UTILS.createWithStaticStroke("Frame", bombGui, {
            Name = "BombJumpFrame",
            BackgroundColor3 = Color3.fromRGB(16, 22, 38),
            BackgroundTransparency = 0.3,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 78, 0, 78),
            Position = STATES.FakeBombJump.Position or UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ZIndex = 1
        })
        
        UTILS.createInstance("UICorner", bombFrame, {CornerRadius = UDim.new(0, 5)})
        
        local backgroundGradient = UTILS.createInstance("UIGradient", bombFrame, {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 35, 55)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 20, 35))
            }),
            Rotation = 90
        })
        
        local textLabel = UTILS.createInstance("TextLabel", bombFrame, {
            Name = "BombText",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "💣",
            TextColor3 = Color3.fromRGB(210, 220, 240),
            TextSize = 30,
            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
            TextWrapped = true,
            ZIndex = 2
        })
        
        local button = UTILS.createInstance("TextButton", bombFrame, {
            Name = "BombButton",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 3
        })
        
        local bombAvailable = true
        local bombCooldown = 22
        local cooldownActive = false
        local isDragging = false
        local dragStartPos
        local buttonStartPos
        local dragTouchId
        local wasClick = false
        local DRAG_THRESHOLD = 5
        
        local COLORS = {
            READY = Color3.fromRGB(210, 220, 240),
            READY_HOVER = Color3.fromRGB(255, 255, 255),
            COOLDOWN = Color3.fromRGB(255, 150, 150)
        }
        
        local function updateUI(status, message)
            if status == "ready" then
                textLabel.Text = "💣"
                cooldownActive = false
                textLabel.TextColor3 = COLORS.READY
            elseif status == "cooldown" then
                textLabel.Text = tostring(message) .. "s"
                cooldownActive = true
                textLabel.TextColor3 = COLORS.COOLDOWN
            end
        end
        
        local function useBomb()
            if bombAvailable and not cooldownActive then
                bombAvailable = false
                cooldownActive = true
                
                local player = Players.LocalPlayer
                local character = player.Character
                
                if not character then
                    bombAvailable = true
                    cooldownActive = false
                    updateUI("ready")
                    return
                end
                
                local backpack = player.Backpack
                
                local bomb = backpack:FindFirstChild("FakeBomb") or character:FindFirstChild("FakeBomb")
                if not bomb then
                    local remote = ReplicatedStorage:FindFirstChild("Remotes")
                    if remote then
                        local extras = remote:FindFirstChild("Extras")
                        if extras then
                            local replicateToy = extras:FindFirstChild("ReplicateToy")
                            if replicateToy then
                                pcall(function()
                                    replicateToy:InvokeServer("FakeBomb")
                                end)
                            end
                        end
                    end
                    
                    bomb = backpack:WaitForChild("FakeBomb", 5)
                    if not bomb then
                        bombAvailable = true
                        cooldownActive = false
                        updateUI("ready")
                        return
                    end
                end
                
                bomb.Parent = character
                
                if bomb:IsDescendantOf(character) and character:FindFirstChild("Humanoid") then
                    local humanoid = character.Humanoid
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    
                    if hrp then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        humanoid.JumpPower = 53
                        
                        if bomb:FindFirstChild("Remote") then
                            bomb.Remote:FireServer(hrp.CFrame * CFrame.new(0, -3, 0), 50)
                        end
                        
                        task.wait(0.3)
                        
                        if bomb and bomb.Parent == character then
                            bomb.Parent = backpack
                        end
                        
                        if humanoid then
                            humanoid.JumpPower = 51
                        end
                    end
                end
                
                local startTime = time()
                local characterCheck = character
                
                while time() - startTime < bombCooldown do
                    if Players.LocalPlayer.Character ~= characterCheck then
                        bombAvailable = true
                        cooldownActive = false
                        updateUI("ready")
                        return
                    end
                    
                    local remaining = math.ceil(bombCooldown - (time() - startTime))
                    updateUI("cooldown", remaining)
                    task.wait(1)
                end
                
                bombAvailable = true
                cooldownActive = false
                updateUI("ready")
            end
        end
        
        local function onDragStart(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                
                isDragging = false
                wasClick = true
                dragTouchId = input.UserInputType == Enum.UserInputType.Touch and input
                dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
                buttonStartPos = bombFrame.Position
                
                bombFrame.BackgroundColor3 = Color3.fromRGB(25, 35, 55)
                bombFrame.BackgroundTransparency = 0.2
                
                return Enum.ContextActionResult.Sink
            end
        end
        
        local function onDrag(input)
            if not dragStartPos then return end
            
            if input.UserInputType == Enum.UserInputType.Touch then
                if not dragTouchId or dragTouchId ~= input then
                    return
                end
            end
            
            local currentPos = Vector2.new(input.Position.X, input.Position.Y)
            local delta = currentPos - dragStartPos
            
            if not isDragging and delta.Magnitude > DRAG_THRESHOLD then
                isDragging = true
                wasClick = false
            end
            
            if isDragging then
                local newPosition = UDim2.new(
                    buttonStartPos.X.Scale,
                    buttonStartPos.X.Offset + delta.X,
                    buttonStartPos.Y.Scale,
                    buttonStartPos.Y.Offset + delta.Y
                )
                
                bombFrame.Position = newPosition
            end
        end
        
        local function onDragEnd(input)
            if wasClick and not isDragging then
                UTILS.playClickSound()
                if not cooldownActive then
                    useBomb()
                end
            end
            
            bombFrame.BackgroundColor3 = Color3.fromRGB(16, 22, 38)
            bombFrame.BackgroundTransparency = 0.3
            local targetColor = cooldownActive and COLORS.COOLDOWN or COLORS.READY
            textLabel.TextColor3 = targetColor
            
            if isDragging then
                local finalPosition = bombFrame.Position
                STATES.FakeBombJump.Position = finalPosition
            end
            
            isDragging = false
            wasClick = false
            dragStartPos = nil
            dragTouchId = nil
            buttonStartPos = nil
        end
        
        button.InputBegan:Connect(onDragStart)
        button.InputChanged:Connect(onDrag)
        button.InputEnded:Connect(onDragEnd)
        
        button.MouseEnter:Connect(function()
            if not isDragging then
                bombFrame.BackgroundTransparency = 0.2
                bombFrame.BackgroundColor3 = Color3.fromRGB(22, 30, 50)
                
                if not cooldownActive then
                    textLabel.TextColor3 = COLORS.READY_HOVER
                end
            end
        end)
        
        button.MouseLeave:Connect(function()
            if not isDragging then
                bombFrame.BackgroundTransparency = 0.3
                bombFrame.BackgroundColor3 = Color3.fromRGB(16, 22, 38)
                
                local targetColor = cooldownActive and COLORS.COOLDOWN or COLORS.READY
                textLabel.TextColor3 = targetColor
            end
        end)
        
        updateUI("ready")
        
        bombButtonData = {
            gui = bombGui,
            frame = bombFrame,
            destroy = function()
                if bombGui then
                    bombGui:Destroy()
                end
                bombButtonData = nil
            end
        }
    end
    
    local function destroyBombButton()
        if bombButtonData then
            bombButtonData.destroy()
        end
    end
    
    STATES.FakeBombJumpTemp = false
    local bombToggle = createToggle(bombContainer, "Fake Bomb Jump Button", 40, STATES, "FakeBombJumpTemp", function(isEnabled)
        if isEnabled then
            createBombButton()
        else
            destroyBombButton()
        end
    end)
    
    currentY = currentY + 100 + 20
    
    local grabberContainer = UTILS.createWithStaticStroke("Frame", content, {
        Name = "GrabberContainer",
        BackgroundColor3 = Color3.fromRGB(16, 22, 38),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -20, 0, 205),
        Position = UDim2.new(0, 10, 0, currentY),
        ZIndex = 5
    })
    
    UTILS.createInstance("UICorner", grabberContainer, {CornerRadius = UDim.new(0, 8)})
    
    UTILS.createInstance("TextLabel", grabberContainer, {
        Name = "GrabberTitle",
        Text = "Grabber",
        TextColor3 = Color3.fromRGB(210, 220, 240),
        TextSize = 16,
        FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 5),
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 6
    })
    
    local function GrabGunRemote()
        local hrp = UTILS.getHRP()
        if not hrp then return false end
        
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Model") and obj:FindFirstChild("GunDrop") then
                local gun = obj.GunDrop
                firetouchinterest(hrp, gun, 0)
                task.wait(0.1)
                firetouchinterest(hrp, gun, 1)
                return true
            end
        end
        return false
    end
    
    local grabGunButton = createStyledButton(grabberContainer, {
        name = "GrabGunStyledButton",
        title = "Grab Gun",
        icon = "rbxthumb://type=Asset&id=77289067728929&w=150&h=150",
        accentColor = CONFIG.MAIN_COLOR,
        position = UDim2.new(0, 10, 0, 40),
        onClick = function()
            GrabGunRemote()
        end
    })
    
    local toggleY = 100
    
    local grabGunButtonData = nil
    
    local function createGunDropButton()
        if grabGunButtonData then return end
        
        local gunGui = UTILS.createInstance("ScreenGui", CoreGui, {
            Name = "GunDropButtonGui",
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            ResetOnSpawn = false,
            DisplayOrder = 50
        })
        
        local gunFrame = UTILS.createWithStaticStroke("Frame", gunGui, {
            Name = "GunDropFrame",
            BackgroundColor3 = Color3.fromRGB(16, 22, 38),
            BackgroundTransparency = 0.3,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 48, 0, 48),
            Position = STATES.GrabGun.Position or UDim2.new(0, 130, 0, 46),
            AnchorPoint = Vector2.new(0, 0),
            ZIndex = 1
        })
        
        UTILS.createInstance("UICorner", gunFrame, {CornerRadius = UDim.new(1, 0)})
        
        local backgroundGradient = UTILS.createInstance("UIGradient", gunFrame, {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 35, 55)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 20, 35))
            }),
            Rotation = 90
        })
        
        local textLabel = UTILS.createInstance("TextLabel", gunFrame, {
            Name = "GunText",
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Text = "Get Gun",
            TextColor3 = Color3.fromRGB(210, 220, 240),
            TextSize = 10,
            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
            TextScaled = false,
            TextWrapped = true,
            ZIndex = 2
        })
        
        local button = UTILS.createInstance("TextButton", gunFrame, {
            Name = "GunButton",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 3
        })
        
        local isDragging = false
        local dragStartPos
        local buttonStartPos
        local dragTouchId
        local wasClick = false
        local DRAG_THRESHOLD = 5
        
        local function onDragStart(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                
                isDragging = false
                wasClick = true
                dragTouchId = input.UserInputType == Enum.UserInputType.Touch and input
                dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
                buttonStartPos = gunFrame.Position
                
                gunFrame.BackgroundColor3 = Color3.fromRGB(25, 35, 55)
                
                return Enum.ContextActionResult.Sink
            end
        end
        
        local function onDrag(input)
            if not dragStartPos then return end
            
            if input.UserInputType == Enum.UserInputType.Touch then
                if not dragTouchId or dragTouchId ~= input then
                    return
                end
            end
            
            local currentPos = Vector2.new(input.Position.X, input.Position.Y)
            local delta = currentPos - dragStartPos
            
            if not isDragging and delta.Magnitude > DRAG_THRESHOLD then
                isDragging = true
                wasClick = false
            end
            
            if isDragging then
                local newPosition = UDim2.new(
                    buttonStartPos.X.Scale,
                    buttonStartPos.X.Offset + delta.X,
                    buttonStartPos.Y.Scale,
                    buttonStartPos.Y.Offset + delta.Y
                )
                
                gunFrame.Position = newPosition
            end
        end
        
        local function onDragEnd(input)
            if wasClick and not isDragging then
                UTILS.playClickSound()
                GrabGunRemote()
            end
            
            gunFrame.BackgroundTransparency = 0.3
            gunFrame.BackgroundColor3 = Color3.fromRGB(16, 22, 38)
            textLabel.TextColor3 = Color3.fromRGB(210, 220, 240)
            
            if isDragging then
                local finalPosition = gunFrame.Position
                STATES.GrabGun.Position = finalPosition
            end
            
            isDragging = false
            wasClick = false
            dragStartPos = nil
            dragTouchId = nil
            buttonStartPos = nil
        end
        
        button.InputBegan:Connect(onDragStart)
        button.InputChanged:Connect(onDrag)
        button.InputEnded:Connect(onDragEnd)
        
        button.MouseEnter:Connect(function()
            if not isDragging then
                gunFrame.BackgroundTransparency = 0.2
                gunFrame.BackgroundColor3 = Color3.fromRGB(22, 30, 50)
                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end)
        
        button.MouseLeave:Connect(function()
            if not isDragging then
                gunFrame.BackgroundTransparency = 0.3
                gunFrame.BackgroundColor3 = Color3.fromRGB(16, 22, 38)
                textLabel.TextColor3 = Color3.fromRGB(210, 220, 240)
            end
        end)
        
        grabGunButtonData = {
            gui = gunGui,
            frame = gunFrame,
            destroy = function()
                if gunGui then
                    gunGui:Destroy()
                end
                grabGunButtonData = nil
            end
        }
    end
    
    local function destroyGunDropButton()
        if grabGunButtonData then
            grabGunButtonData.destroy()
        end
    end
    
    STATES.GrabGunTemp = false
    local grabGunToggle = createToggle(grabberContainer, "GrabGun Button", toggleY, STATES, "GrabGunTemp", function(isEnabled)
        if isEnabled then
            createGunDropButton()
        else
            destroyGunDropButton()
        end
    end)
    
    toggleY = toggleY + 52
    
    local autoGrabGunActive = false
    local autoGrabGunConnection = nil
    
    STATES.AutoGrabGunTemp = false
    local autoGrabGunToggle = createToggle(grabberContainer, "AutoGrabGun", toggleY, STATES, "AutoGrabGunTemp", function(isEnabled)
        autoGrabGunActive = isEnabled
        
        if isEnabled then
            if autoGrabGunConnection then
                autoGrabGunConnection:Disconnect()
            end
            
            autoGrabGunConnection = RunService.Heartbeat:Connect(function()
                if autoGrabGunActive then
                    GrabGunRemote()
                    task.wait(0.2)
                end
            end)
        else
            if autoGrabGunConnection then
                autoGrabGunConnection:Disconnect()
                autoGrabGunConnection = nil
            end
        end
    end)
    
    return bombContainer, grabberContainer
end

function UI_SYSTEM.createAutoFarmTabContent(content)
	local currentY = 20
	
	local farmContainer = UTILS.createWithStaticStroke("Frame", content, {
		Name = "FarmContainer",
		BackgroundColor3 = Color3.fromRGB(16, 22, 38),
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -20, 0, 160),
		Position = UDim2.new(0, 10, 0, currentY),
		ZIndex = 5
	})
	
	UTILS.createInstance("UICorner", farmContainer, {CornerRadius = UDim.new(0, 8)})
	
	local farmY = 10
	local autoFarmToggle = createToggle(farmContainer, "Auto Farm", farmY, STATES.AutoFarm, "Enabled", function(isEnabled)
		STATES.AutoFarm.Enabled = isEnabled
		if isEnabled then
			STATES.AutoFarm.Farming = true
		else
			STATES.AutoFarm.Farming = false
		end
	end)
	
	farmY = farmY + 52
	local autoResetToggle = createToggle(farmContainer, "Auto Reset (Full Bag)", farmY, STATES.AutoFarm, "Enabled", function(isEnabled)
		STATES.AutoFarm.Enabled = isEnabled
		if isEnabled then
			STATES.AutoFarm.Farming = true
		else
			STATES.AutoFarm.Farming = false
		end
	end)
	
	farmY = farmY + 52
	local autoKillToggle = createToggle(farmContainer, "Auto Kill All (Murderer)", farmY, STATES.KillAll, "Enabled", function(isEnabled)
		STATES.KillAll.Enabled = isEnabled
		if not isEnabled then 
			STATES.AutoFarm.BagFull = false 
		end
	end)
	
	currentY = currentY + 160 + 20
	
	local statsFrame = UTILS.createWithStaticStroke("Frame", content, {
		Name = "StatsContainer",
		Size = UDim2.new(1, -20, 0, 100),
		Position = UDim2.new(0, 10, 0, currentY),
		BackgroundColor3 = Color3.fromRGB(14, 20, 35),
		BackgroundTransparency = 0.2,
		BorderSizePixel = 0,
		ZIndex = 5
	})
	UTILS.createInstance("UICorner", statsFrame, {CornerRadius = UDim.new(0, 8)})
	
	UTILS.createInstance("TextLabel", statsFrame, {
		Name = "StatsTitle",
		Text = "Farming Statistics",
		TextColor3 = Color3.fromRGB(210, 220, 240),
		TextSize = 14,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -20, 0, 20),
		Position = UDim2.new(0, 10, 0, 5),
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 6
	})
	
	local coinLabel = UTILS.createInstance("TextLabel", statsFrame, {
		Name = "CoinLabel",
		Text = "Coin: 0",
		Size = UDim2.new(1, -20, 0, 20),
		Position = UDim2.new(0, 10, 0, 25),
		BackgroundTransparency = 1,
		TextColor3 = Color3.fromRGB(230, 235, 250),
		TextXAlignment = Enum.TextXAlignment.Left,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
		TextSize = 13,
		ZIndex = 6
	})

	local hourLabel = UTILS.createInstance("TextLabel", statsFrame, {
		Name = "HourLabel",
		Text = "Coins/hour: 0",
		Size = UDim2.new(1, -20, 0, 20),
		Position = UDim2.new(0, 10, 0, 45),
		BackgroundTransparency = 1,
		TextColor3 = Color3.fromRGB(150, 220, 180),
		TextXAlignment = Enum.TextXAlignment.Left,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
		TextSize = 13,
		ZIndex = 6
	})

	local timeLabel = UTILS.createInstance("TextLabel", statsFrame, {
		Name = "TimeLabel",
		Text = "0h 0m 0s",
		Size = UDim2.new(1, -20, 0, 20),
		Position = UDim2.new(0, 10, 0, 65),
		BackgroundTransparency = 1,
		TextColor3 = Color3.fromRGB(160, 175, 200),
		TextXAlignment = Enum.TextXAlignment.Left,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
		TextSize = 13,
		ZIndex = 6
	})
	
	RunService.Heartbeat:Connect(function()
		if STATES.AutoFarm.Enabled then
			if not FARMING_STATS.IsRunning then
				FARMING_STATS.StartTime = tick()
				FARMING_STATS.IsRunning = true
				FARMING_STATS.CoinsCollected = 0
			end
			
			local elapsed = tick() - FARMING_STATS.StartTime
			local hours = math.floor(elapsed / 3600)
			local minutes = math.floor((elapsed % 3600) / 60)
			local seconds = math.floor(elapsed % 60)
			
			timeLabel.Text = string.format("%dh %dm %ds", hours, minutes, seconds)
			coinLabel.Text = "Coin: " .. FARMING_STATS.CoinsCollected
			
			if elapsed > 0 then
				local cph = math.floor((FARMING_STATS.CoinsCollected / elapsed) * 3600)
				hourLabel.Text = "Coins/hour: " .. cph
			end
		else
			FARMING_STATS.IsRunning = false
		end
	end)
	
	return farmContainer, statsFrame
end

function UI_SYSTEM.createActMgrTabContent(content)
    local currentY = 20
    
    local joinButton = createStyledButton(content, {
        name = "JoinAnotherServer",
        title = "Join Another Server",
        icon = "rbxthumb://type=Asset&id=77289067728929&w=150&h=150",
        accentColor = CONFIG.MAIN_COLOR,
        position = UDim2.new(0, 10, 0, currentY),
        onClick = function()
            UTILS.joinAnotherServer()
        end
    })
    
    currentY = currentY + 60
    
    local rejoinButton = createStyledButton(content, {
        name = "RejoinServer",
        title = "Rejoin",
        icon = "rbxthumb://type=Asset&id=77289067728929&w=150&h=150",
        accentColor = CONFIG.MAIN_COLOR,
        position = UDim2.new(0, 10, 0, currentY),
        onClick = function()
            UTILS.rejoinServer()
        end
    })
    
    currentY = currentY + 60
    
    local antiAFKInterval = 5
    
    local antiAFKEnabled = false
    local antiAFKTask = nil
    
    local function getVirtualUser()
        local VirtualUser = cloneref and cloneref(game:GetService("VirtualUser")) or game:GetService("VirtualUser")
        return VirtualUser
    end
    
    local function simulateActivity()
        local VirtualUser = getVirtualUser()
        local camera = workspace.CurrentCamera
        
        if VirtualUser and camera then
            pcall(function()
                VirtualUser:Button2Down(Vector2.new(0, 0), camera.CFrame)
                task.wait(0.1)
                VirtualUser:Button2Up(Vector2.new(0, 0), camera.CFrame)
            end)
        end
    end
    
    local function toggleAntiAFK(value)
        antiAFKEnabled = value
        
        if value then
            if antiAFKTask then
                task.cancel(antiAFKTask)
                antiAFKTask = nil
            end
            
            antiAFKTask = task.spawn(function()
                while antiAFKEnabled do
                    task.wait(antiAFKInterval * 60)
                    simulateActivity()
                end
            end)
        else
            if antiAFKTask then
                task.cancel(antiAFKTask)
                antiAFKTask = nil
            end
        end
    end
    
    STATES.AntiAFKTemp = false
    local antiAFKToggle = createToggle(content, "Anti-AFK (every " .. antiAFKInterval .. " min)", currentY, STATES, "AntiAFKTemp", function(isEnabled)
        toggleAntiAFK(isEnabled)
    end)
    
    currentY = currentY + 60
    
    local antiFlingToggle = createToggle(content, "Anti-Fling", currentY, STATES.AntiFling, "Enabled", function(isEnabled)
        if isEnabled then
            ANTI_FLING.enable()
        else
            ANTI_FLING.disable()
        end
    end)
    
    currentY = currentY + 60
    
    local muteRadioToggle = createToggle(content, "Mute Radio", currentY, STATES.MuteRadio, "Enabled", function(isEnabled)
        toggleMuteRadio(isEnabled)
    end)
    
    return joinButton.container, rejoinButton.container, antiAFKToggle, antiFlingToggle, muteRadioToggle
end

-- Основная инициализация
function UI_SYSTEM.init()
	UI_ELEMENTS.ScreenGui = UTILS.createInstance("ScreenGui", CoreGui, {
		Name = "MM2GUI",
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		ResetOnSpawn = false,
		DisplayOrder = 100
	})
	
	UI_ELEMENTS.OpenCloseGui = UTILS.createInstance("ScreenGui", CoreGui, {
		Name = "MM2OpenCloseGUI",
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		ResetOnSpawn = false,
		DisplayOrder = 99
	})
	
	local open_close_2 = UTILS.createWithStaticStroke("Frame", UI_ELEMENTS.OpenCloseGui, {
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(12, 16, 28),
		Size = UDim2.new(0, 50, 0, 50),
		Position = UDim2.new(0, 20, 0, 20),
		Name = "open close",
		BackgroundTransparency = 0.5,
		ZIndex = 5
	})
	
	UTILS.createInstance("UICorner", open_close_2, {CornerRadius = UDim.new(0, 8)})
	
	local openCloseButton = UTILS.createInstance("TextButton", open_close_2, {
		Name = "OpenCloseButton",
		Text = "",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		ZIndex = 6
	})
	
	local function toggleGUI()
		STATES.GUIVisible = not STATES.GUIVisible
		UI_ELEMENTS.MainFrame.Visible = STATES.GUIVisible
		open_close_2.BackgroundColor3 = STATES.GUIVisible and Color3.fromRGB(12, 16, 28) or Color3.fromRGB(25, 35, 55)
	end
	
	openCloseButton.MouseButton1Click:Connect(function()
		UTILS.playClickSound()
		toggleGUI()
	end)
	
	openCloseButton.MouseEnter:Connect(function()
		open_close_2.BackgroundColor3 = STATES.GUIVisible and Color3.fromRGB(18, 25, 42) or Color3.fromRGB(35, 48, 75)
	end)
	
	openCloseButton.MouseLeave:Connect(function()
		open_close_2.BackgroundColor3 = STATES.GUIVisible and Color3.fromRGB(12, 16, 28) or Color3.fromRGB(25, 35, 55)
	end)
	
	UI_ELEMENTS.MainFrame = UTILS.createWithStaticStroke("Frame", UI_ELEMENTS.ScreenGui, {
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(10, 14, 24),
		Size = UDim2.new(0, 522, 0, 306),
		Position = UDim2.new(0, 130, 0, -14),
		Name = "mainFrame",
		BackgroundTransparency = 0.5,
		Visible = true,
		ZIndex = 5
	})
	
	UTILS.createInstance("UICorner", UI_ELEMENTS.MainFrame, {CornerRadius = UDim.new(0, 5)})
	
	UI_ELEMENTS.TabButtonsContainer = UTILS.createWithStaticStroke("ScrollingFrame", UI_ELEMENTS.MainFrame, {
		ScrollingDirection = Enum.ScrollingDirection.Y,
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(14, 20, 35),
		Name = "tabButtonsContainer",
		Size = UDim2.new(0, 124, 0, 258),
		Position = UDim2.new(0, 390, 0, 40),
		ScrollBarThickness = 6,
		ScrollBarImageColor3 = Color3.fromRGB(70, 100, 170),
		BackgroundTransparency = 0.3,
		SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
		SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ClipsDescendants = true,
		ZIndex = 10
	})
	
	UTILS.createInstance("UICorner", UI_ELEMENTS.TabButtonsContainer, {CornerRadius = UDim.new(0, 5)})
	
	UI_ELEMENTS.ContentFrame = UTILS.createWithStaticStroke("Frame", UI_ELEMENTS.MainFrame, {
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Size = UDim2.new(0, 376, 0, 258),
		Position = UDim2.new(0, 6, 0, 40),
		Name = "contentFrame",
		BackgroundTransparency = 1,
		ZIndex = 5
	})
	
	UTILS.createInstance("UICorner", UI_ELEMENTS.ContentFrame, {CornerRadius = UDim.new(0, 5)})
	
	local headerFrame = UTILS.createWithStaticStroke("Frame", UI_ELEMENTS.MainFrame, {
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Size = UDim2.new(0, 510, 0, 26),
		Position = UDim2.new(0, 6, 0, 6),
		Name = "header",
		BackgroundTransparency = 1,
		ZIndex = 5
	})
	
	UTILS.createInstance("UICorner", headerFrame, {CornerRadius = UDim.new(0, 5)})
	
	UTILS.createInstance("TextLabel", headerFrame, {
		BorderSizePixel = 0,
		TextSize = 16,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
		TextColor3 = Color3.fromRGB(210, 220, 240),
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 200, 0, 30),
		BorderColor3 = Color3.fromRGB(255, 255, 255),
		Text = "Murder Mystery 2 | XenaHub",
		Position = UDim2.new(0, 44, 0, -2),
		ZIndex = 6
	})

	-- ========== DRAGGABLE MENU ==========
	do
		local isDragging = false
		local dragStartPos
		local frameStartPos
		local dragTouchId
		local DRAG_THRESHOLD = 5

		local dragHandle = UTILS.createInstance("TextButton", headerFrame, {
			Name = "DragHandle",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 20
		})

		local function onDragStart(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or 
			   input.UserInputType == Enum.UserInputType.Touch then
				
				isDragging = false
				dragTouchId = input.UserInputType == Enum.UserInputType.Touch and input
				dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
				frameStartPos = UI_ELEMENTS.MainFrame.Position
				
				return Enum.ContextActionResult.Sink
			end
		end
		
		local function onDrag(input)
			if not dragStartPos then return end
			
			if input.UserInputType == Enum.UserInputType.Touch then
				if not dragTouchId or dragTouchId ~= input then
					return
				end
			end
			
			local currentPos = Vector2.new(input.Position.X, input.Position.Y)
			local delta = currentPos - dragStartPos
			
			if not isDragging and delta.Magnitude > DRAG_THRESHOLD then
				isDragging = true
			end
			
			if isDragging then
				local newPosition = UDim2.new(
					frameStartPos.X.Scale,
					frameStartPos.X.Offset + delta.X,
					frameStartPos.Y.Scale,
					frameStartPos.Y.Offset + delta.Y
				)
				
				UI_ELEMENTS.MainFrame.Position = newPosition
			end
		end
		
		local function onDragEnd(input)
			isDragging = false
			dragStartPos = nil
			dragTouchId = nil
			frameStartPos = nil
		end
		
		dragHandle.InputBegan:Connect(onDragStart)
		dragHandle.InputChanged:Connect(onDrag)
		dragHandle.InputEnded:Connect(onDragEnd)
	end
	-- ========== END DRAGGABLE ==========
	
	local tabNames = {"Main", "Visual", "Combat", "Optimization", "Teleport", "Auto Farm", "Emote", "ActMgr"}
	local tabButtons = {}
	local tabFrames = {}
	UI_ELEMENTS.Tabs = {
		Contents = {},
		Scrolls = {}
	}
	local activeTab = "Main"
	
	for i, tabName in ipairs(tabNames) do
		local positionY = 4 + ((i-1) * (CONFIG.BUTTON_HEIGHT + CONFIG.SPACING))
		local button, frame, content, label, contentScroll = UI_SYSTEM.createTabButton(
			UI_ELEMENTS.TabButtonsContainer, tabName, positionY, tabName, UI_ELEMENTS.ContentFrame
		)
		
		tabButtons[tabName] = button
		tabFrames[tabName] = frame
		UI_ELEMENTS.Tabs.Contents[tabName] = content
		UI_ELEMENTS.Tabs.Scrolls[tabName] = contentScroll
		
		button.MouseButton1Click:Connect(function()
			UTILS.playClickSound()
			
			for name, tabFrame in pairs(tabFrames) do
				if tabFrame then
					tabFrame.BackgroundColor3 = Color3.fromRGB(22, 30, 50)
					tabFrame.BackgroundTransparency = 0.7
				end
			end
			
			for name, contentScroll in pairs(UI_ELEMENTS.Tabs.Scrolls) do
				if contentScroll then contentScroll.Visible = false end
			end
			
			if frame then
				frame.BackgroundColor3 = Color3.fromRGB(40, 55, 95)
				frame.BackgroundTransparency = 0.3
			end
			
			if contentScroll then contentScroll.Visible = true end
			activeTab = tabName
		end)
		
		button.MouseEnter:Connect(function()
			if activeTab ~= tabName then
				TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = Color3.fromRGB(30, 42, 70),
					BackgroundTransparency = 0.5
				}):Play()
			end
		end)
		
		button.MouseLeave:Connect(function()
			if activeTab ~= tabName then
				TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = Color3.fromRGB(22, 30, 50),
					BackgroundTransparency = 0.7
				}):Play()
			end
		end)
	end
	
	UTILS.updateTabButtonsContainerSize(UI_ELEMENTS.TabButtonsContainer)
	
	if tabFrames[activeTab] then
		tabFrames[activeTab].BackgroundColor3 = Color3.fromRGB(40, 55, 95)
		tabFrames[activeTab].BackgroundTransparency = 0.3
	end
	if UI_ELEMENTS.Tabs.Scrolls[activeTab] then
		UI_ELEMENTS.Tabs.Scrolls[activeTab].Visible = true
	end
	
	if UI_ELEMENTS.Tabs.Contents["Main"] then
		UI_SYSTEM.createMainTabContent(UI_ELEMENTS.Tabs.Contents["Main"])
		UTILS.updateCanvasSize(UI_ELEMENTS.Tabs.Scrolls["Main"], UI_ELEMENTS.Tabs.Contents["Main"])
	end
	
	if UI_ELEMENTS.Tabs.Contents["Visual"] then
		UI_SYSTEM.createVisualTabContent(UI_ELEMENTS.Tabs.Contents["Visual"])
		UTILS.updateCanvasSize(UI_ELEMENTS.Tabs.Scrolls["Visual"], UI_ELEMENTS.Tabs.Contents["Visual"])
	end
	
	if UI_ELEMENTS.Tabs.Contents["Combat"] then
		UI_SYSTEM.createCombatTabContent(UI_ELEMENTS.Tabs.Contents["Combat"])
		UTILS.updateCanvasSize(UI_ELEMENTS.Tabs.Scrolls["Combat"], UI_ELEMENTS.Tabs.Contents["Combat"])
	end
	
	if UI_ELEMENTS.Tabs.Contents["Teleport"] then
		UI_SYSTEM.createTeleportTabContent(UI_ELEMENTS.Tabs.Contents["Teleport"])
		UTILS.updateCanvasSize(UI_ELEMENTS.Tabs.Scrolls["Teleport"], UI_ELEMENTS.Tabs.Contents["Teleport"])
	end
	
	if UI_ELEMENTS.Tabs.Contents["Auto Farm"] then
		UI_SYSTEM.createAutoFarmTabContent(UI_ELEMENTS.Tabs.Contents["Auto Farm"])
		UTILS.updateCanvasSize(UI_ELEMENTS.Tabs.Scrolls["Auto Farm"], UI_ELEMENTS.Tabs.Contents["Auto Farm"])
	end
	
	if UI_ELEMENTS.Tabs.Contents["ActMgr"] then
		UI_SYSTEM.createActMgrTabContent(UI_ELEMENTS.Tabs.Contents["ActMgr"])
		UTILS.updateCanvasSize(UI_ELEMENTS.Tabs.Scrolls["ActMgr"], UI_ELEMENTS.Tabs.Contents["ActMgr"])
	end
	
	for _, tabName in ipairs({"Optimization", "Emote"}) do
		if UI_ELEMENTS.Tabs.Contents[tabName] then
			UTILS.addSpacer(UI_ELEMENTS.Tabs.Contents[tabName], 20, 400)
			UTILS.updateCanvasSize(UI_ELEMENTS.Tabs.Scrolls[tabName], UI_ELEMENTS.Tabs.Contents[tabName])
		end
	end
	
	return UI_ELEMENTS.ScreenGui, UI_ELEMENTS.OpenCloseGui
end

local function init()
    local screenGui, openCloseGui = UI_SYSTEM.init()

    REMOTE_SYSTEM.findRemoteEvents()
    REMOTE_SYSTEM.connectRemoteEvents()

    FARMING.startFarmingLoop()
    KILL_ALL.startKillAllLoop()

    player.CharacterAdded:Connect(function(character)
        character:WaitForChild("Humanoid")
        task.wait(0.1)
        MOVEMENT.updateWalkSpeed()
        MOVEMENT.updateJumpPower()
    end)

    if player.Character and player.Character:FindFirstChild("Humanoid") then
        MOVEMENT.updateWalkSpeed()
        MOVEMENT.updateJumpPower()
    end

    local espConnection
    local highlightConnection

    espConnection = RunService.Heartbeat:Connect(function()
        if ESP_SYSTEM.ESP_STATES.ESPName then
            ESP_SYSTEM.updateESP()
        else
            ESP_SYSTEM.clearAllESP()
        end
    end)

    highlightConnection = RunService.Heartbeat:Connect(function()
        if ESP_SYSTEM.ESP_HIGHLIGHT_STATES.ESPHighlight then
            ESP_SYSTEM.updateHighlights()
        else
            ESP_SYSTEM.clearAllHighlights()
        end
    end)

    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player then
            ESP_SYSTEM.initializePlayer(targetPlayer)
        end
    end

    Players.PlayerAdded:Connect(function(targetPlayer)
        if targetPlayer ~= player then
            ESP_SYSTEM.initializePlayer(targetPlayer)
        end
    end)

    Players.PlayerRemoving:Connect(function(targetPlayer)
        if targetPlayer ~= player then
            ESP_SYSTEM.removePlayerBillboard(targetPlayer)
            ESP_SYSTEM.removePlayerHighlight(targetPlayer)
            ESP_SYSTEM.RemoveLineForPlayer(targetPlayer.Name)
        end
    end)

    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        ESP_SYSTEM.Camera = workspace.CurrentCamera
    end)
    
    Players.PlayerAdded:Connect(function(newPlayer)
        if newPlayer ~= player and ESP_SYSTEM.ESP_LINE_STATES.ESPLine then
            local conn = ESP_SYSTEM.InitializePlayerLines(newPlayer)
            table.insert(lineConnections, conn)
        end
    end)

    UTILS.showNotification("XenaHub", "Script successfully loaded!", 3.5)

    return screenGui, openCloseGui
end

return init()
