local players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")
local localPlayer = players.LocalPlayer
local camera = game.Workspace.CurrentCamera 
local starterGui = game:GetService("StarterGui")
local coreGui = game:GetService("CoreGui")

-- Toggle state variables
local scriptEnabled = true

local function showNotification(title, text)
    starterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = 5; 
    })
end

local function teleportPlayerToTouchPosition(touchPosition)
    -- Check if script is toggled on before running
    if not scriptEnabled then return end

    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local ray = camera:ScreenPointToRay(touchPosition.X, touchPosition.Y)
        
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {localPlayer.Character} 
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        
        local raycastResult = workspace:Raycast(ray.Origin, ray.Direction * 1000, raycastParams)
        if raycastResult then
            local newPosition = raycastResult.Position
            localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(newPosition)

            showNotification("Teleported", "You have teleported to the touched location!")
        else
            showNotification("Error", "No valid surface found at the touched position!")
        end
    else
        showNotification("Error", "Could not find HumanoidRootPart!")
    end
end

userInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end -- Prevents teleporting when tapping UI elements
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        teleportPlayerToTouchPosition(input.Position)
    end
end)

-- ==========================================
-- FLOATING TOGGLE PANEL GUI CREATION
-- ==========================================

-- Clean up any previous instances of this UI running to avoid duplicates
if coreGui:FindFirstChild("TeleportToggleGui") then
    coreGui.TeleportToggleGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportToggleGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = coreGui

-- Main Frame (The Floating Panel) - Height adjusted to 75 to fit the title
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 160, 0, 75)
mainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true 
mainFrame.Parent = screenGui

-- UI Corner for styling
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Title Text (Winter)
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 25)
titleLabel.Position = UDim2.new(0, 0, 0, 4)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Winter"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 16
titleLabel.Parent = mainFrame

-- Toggle Button - Shifted down to accommodate the title text
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(1, -14, 0, 35)
toggleButton.Position = UDim2.new(0, 7, 0, 33)
toggleButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 14
toggleButton.Text = "Teleport: ON"
toggleButton.BorderSizePixel = 0
toggleButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = toggleButton

-- Toggle Logic Functionality
toggleButton.MouseButton1Click:Connect(function()
    scriptEnabled = not scriptEnabled
    if scriptEnabled then
        toggleButton.Text = "Teleport: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        showNotification("Teleport Script", "Teleport feature has been enabled.")
    else
        toggleButton.Text = "Teleport: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
        showNotification("Teleport Script", "Teleport feature has been disabled.")
    end
end)

showNotification("Script Active", "Teleport script has been activated.")
mainFrame.Draggable = true -- Allows you to hold and drag the panel anywhere on your screen
mainFrame.Parent = screenGui

-- UI Corner for styling
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(1, -10, 1, -10)
toggleButton.Position = UDim2.new(0, 5, 0, 5)
toggleButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113) -- Green initially
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 16
toggleButton.Text = "Teleport: ON"
toggleButton.BorderSizePixel = 0
toggleButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = toggleButton

-- Toggle Logic Functionality
toggleButton.MouseButton1Click:Connect(function()
    scriptEnabled = not scriptEnabled
    if scriptEnabled then
        toggleButton.Text = "Teleport: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113) -- Green
        showNotification("Teleport Script", "Teleport feature has been enabled.")
    else
        toggleButton.Text = "Teleport: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60) -- Red
        showNotification("Teleport Script", "Teleport feature has been disabled.")
    end
end)

showNotification("Script Active", "Teleport script has been activated.")
showNotification("Script Active", "Teleport script active. Press 'T' or tap with 2 fingers for On/Off.")
