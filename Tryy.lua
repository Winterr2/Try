local players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")
local localPlayer = players.LocalPlayer
local camera = game.Workspace.CurrentCamera 
local starterGui = game:GetService("StarterGui")

-- Toggle variable to track script state
local isEnabled = true 
-- Set your preferred keyboard toggle key here
local toggleKey = Enum.KeyCode.T 

local function showNotification(title, text)
    starterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = 3; 
    })
end

local function teleportPlayerToTouchPosition(touchPosition)
    -- Check if the script is active before running code
    if not isEnabled then return end 

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
            showNotification("Error", "No valid world position was touched!")
        end
    else
        showNotification("Error", "Could not find HumanoidRootPart!")
    end
end

-- Input handler for both toggling and teleporting
userInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end -- Ignores input if typing in chat

    -- Keyboard Toggle (PC)
    if input.KeyCode == toggleKey then
        isEnabled = not isEnabled
        local status = isEnabled and "Enabled" or "Disabled"
        showNotification("Script Toggle", "Teleport script has been " .. status)
    end

    -- Mobile Toggle (Two-finger tap to switch state)
    if input.UserInputType == Enum.UserInputType.Touch and userInputService:GetFocusedTextBox() == nil then
        local activeTouches = userInputService:GetTouches()
        if #activeTouches == 2 then
            isEnabled = not isEnabled
            local status = isEnabled and "Enabled" or "Disabled"
            showNotification("Script Toggle", "Teleport script has been " .. status)
            return
        end
    end

    -- Teleport Execution (Only fires on single touch)
    if isEnabled and input.UserInputType == Enum.UserInputType.Touch then
        teleportPlayerToTouchPosition(input.Position)
    end
end)

showNotification("Script Active", "Teleport script active. Press 'T' or tap with 2 fingers for On/Off.")
