-- Define the list of players with their keys
local keyList = {
    {id = 1266290261, key = "key-AE8CFB76BBDC978D31591C35D2B9B"},
    {id = 7215115217, key = "key-FB1BECF3AB441F36DF648CF7AA44F"}
}

-- Function to check the player
local function checkPlayer(id, providedKey)
    for _, player in ipairs(keyList) do
        if player.id == id then
            if player.key == providedKey then
                return true
            else
                print("Key is incorrect.")
                return false
            end
        end
    end
    print("Player ID not found.")
    return false
end

-- Create and setup UI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.new(1, 1, 1)
frame.Parent = screenGui



local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, -20)
title.Text = "Midnight hub - key"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.new(0, 0, 0)
title.Parent = frame

local KeySystem = Instance.new("TextBox")
KeySystem.Size = UDim2.new(1, 0, 0.6, 0)
KeySystem.Position = UDim2.new(0, 0, 0.2, 0)
KeySystem.Text = "Enter the Key"
KeySystem.TextColor3 = Color3.new(0, 0, 0)
KeySystem.BackgroundTransparency = 0.5
KeySystem.BackgroundColor3 = Color3.new(1, 1, 1)
KeySystem.TextWrapped = true
KeySystem.Parent = frame

local SubmitButton = Instance.new("TextButton")
SubmitButton.Size = UDim2.new(1, 0, 0.3, 0)
SubmitButton.Position = UDim2.new(0, 0, 0.8, 0)
SubmitButton.Text = "Submit"
SubmitButton.Parent = frame

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 39, 0, 39)
CloseButton.Position = UDim2.new(1, -39, 0, -20)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.BackgroundColor3 = Color3.new(1, 0, 0)
CloseButton.Parent = frame

-- Handle button clicks
CloseButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

SubmitButton.MouseButton1Click:Connect(function()
    local enteredKey = KeySystem.Text
    local localPlayerID = game.Players.LocalPlayer.UserId
    if checkPlayer(localPlayerID, enteredKey) then
        screenGui:Destroy()
        print("Key activated successfully!")

        -- Main script execution starts here
        local dwCamera = workspace.CurrentCamera
        local dwRunService = game:GetService("RunService")
        local dwUIS = game:GetService("UserInputService")
        local dwEntities = game:GetService("Players")
        local dwLocalPlayer = dwEntities.LocalPlayer
        local dwMouse = dwLocalPlayer:GetMouse()

        local settings = {
            Aimbot = true,
            Aiming = false,
            Aimbot_AimPart = "Head",
            Aimbot_TeamCheck = true,
            Aimbot_Draw_FOV = true,
            Aimbot_FOV_Radius = 200,
            Aimbot_FOV_Color = Color3.fromRGB(255,255,255)
        }

        local fovcircle = Drawing.new("Circle")
        fovcircle.Visible = settings.Aimbot_Draw_FOV
        fovcircle.Radius = settings.Aimbot_FOV_Radius
        fovcircle.Color = settings.Aimbot_FOV_Color
        fovcircle.Thickness = 1
        fovcircle.Filled = false
        fovcircle.Transparency = 1
        fovcircle.Position = Vector2.new(dwCamera.ViewportSize.X / 2, dwCamera.ViewportSize.Y / 2)

        dwUIS.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton2 then
                settings.Aiming = true
            end
        end)

        dwUIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton2 then
                settings.Aiming = false
            end
        end)

        dwRunService.RenderStepped:Connect(function()
            local dist = math.huge
            local closest_char = nil

            if settings.Aiming then
                for i, v in next, dwEntities:GetChildren() do
                    if v ~= dwLocalPlayer and
                    v.Character and
                    v.Character:FindFirstChild("HumanoidRootPart") and
                    v.Character:FindFirstChild("Humanoid") and
                    v.Character:FindFirstChild("Humanoid").Health > 0 then
                        if settings.Aimbot_TeamCheck == true and
                        v.Team ~= dwLocalPlayer.Team or
                        settings.Aimbot_TeamCheck == false then
                            local char = v.Character
                            local char_part_pos, is_onscreen = dwCamera:WorldToViewportPoint(char[settings.Aimbot_AimPart].Position)
                            if is_onscreen then
                                local mag = (Vector2.new(dwMouse.X, dwMouse.Y) - Vector2.new(char_part_pos.X, char_part_pos.Y)).Magnitude
                                if mag < dist and mag < settings.Aimbot_FOV_Radius then
                                    dist = mag
                                    closest_char = char
                                end
                            end
                        end
                    end
                end

                if closest_char ~= nil and
                closest_char:FindFirstChild("HumanoidRootPart") and
                closest_char:FindFirstChild("Humanoid") and
                closest_char:FindFirstChild("Humanoid").Health > 0 then
                    dwCamera.CFrame = CFrame.new(dwCamera.CFrame.Position, closest_char[settings.Aimbot_AimPart].Position)
                end
            end
        end)

        local color = BrickColor.new(255,0,0)
        local transparency = .8

        local Players = game:GetService("Players")
        local function _ESP(c)
            repeat wait() until c.PrimaryPart ~= nil
            for i, p in pairs(c:GetChildren()) do
                if p.ClassName == "Part" or p.ClassName == "MeshPart" then
                    if p:FindFirstChild("shit") then p.shit:Destroy() end
                    local a = Instance.new("BoxHandleAdornment", p)
                    a.Name = "shit"
                    a.Size = p.Size
                    a.Color = color
                    a.Transparency = transparency
                    a.AlwaysOnTop = true    
                    a.Visible = true    
                    a.Adornee = p
                    a.ZIndex = true    
                end
            end
        end

        local function ESP()
            for i, v in pairs(Players:GetChildren()) do
                if v ~= game.Players.LocalPlayer then
                    if v.Character then
                        _ESP(v.Character)
                    end
                    v.CharacterAdded:Connect(function(chr)
                        _ESP(chr)
                    end)
                end
            end
            Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function(chr)
                    _ESP(chr)
                end)  
            end)
        end
        ESP()
    else
        print("Invalid key or ID. Please try again.")
    end
end)
