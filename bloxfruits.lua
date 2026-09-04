--[========================================================]
--[      YUAN THE GOAT - BLOX FRUITS GOD MODE V3.0          ]
--[         Advanced Silent Aim & Lock-On System            ]
--[========================================================]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Configuration Variables
getgenv().YuanConfig = {
    AimbotEnabled = false,
    SilentAimEnabled = false,
    AimPart = "HumanoidRootPart",
    TargetNPCs = true,
    TargetPlayers = true,
    FOV = 400,
    ShowFOV = true,
    FlyEnabled = false,
    FlySpeed = 60,
    ESPEnabled = false,
    BoxESP = true,
    NameESP = true
}

-- Remove existing GUI if any
if CoreGui:FindFirstChild("YuanBloxFruitsGUI") then
    CoreGui.YuanBloxFruitsGUI:Destroy()
end

-- Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YuanBloxFruitsGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Transparency = 0.8
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Filled = false
FOVCircle.Visible = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderSizePixel = 1
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -185)
MainFrame.Size = UDim2.new(0, 550, 0, 370)
MainFrame.Active = true
MainFrame.Draggable = true

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 40)

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Font = Enum.Font.Code
Title.Text = "YUAN // GOD MODE HUB V3"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Container
local Container = Instance.new("ScrollingFrame")
Container.Name = "Container"
Container.Parent = MainFrame
Container.Active = true
Container.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Container.BorderColor3 = Color3.fromRGB(40, 40, 40)
Container.Position = UDim2.new(0, 12, 0, 55)
Container.Size = UDim2.new(0, 526, 0, 300)
Container.CanvasSize = UDim2.new(0, 0, 0, 500)
Container.ScrollBarThickness = 4
Container.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- Toggle Creator Function
local function CreateToggle(name, default, callback)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Parent = Container
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ToggleBtn.BorderColor3 = Color3.fromRGB(60, 60, 60)
    ToggleBtn.Size = UDim2.new(1, -10, 0, 40)
    ToggleBtn.Font = Enum.Font.Code
    ToggleBtn.Text = "  " .. name .. ": " .. (default and "[ON]" or "[OFF]")
    ToggleBtn.TextColor3 = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(120, 120, 120)
    ToggleBtn.TextSize = 14
    ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left

    local state = default
    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        ToggleBtn.Text = "  " .. name .. ": " .. (state and "[ON]" or "[OFF]")
        ToggleBtn.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(120, 120, 120)
        callback(state)
    end)
end

-- FOV Slider Creator Function
local function CreateSlider(name, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Parent = Container
    SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    SliderFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
    SliderFrame.Size = UDim2.new(1, -10, 0, 50)

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Parent = SliderFrame
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.new(0, 10, 0, 5)
    TextLabel.Size = UDim2.new(1, -20, 0, 20)
    TextLabel.Font = Enum.Font.Code
    TextLabel.Text = "  " .. name .. ": " .. default
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 14
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left

    local SliderBar = Instance.new("TextButton")
    SliderBar.Parent = SliderFrame
    SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SliderBar.BorderSizePixel = 0
    SliderBar.Position = UDim2.new(0, 10, 0, 30)
    SliderBar.Size = UDim2.new(1, -20, 0, 10)
    SliderBar.Text = ""

    local Fill = Instance.new("Frame")
    Fill.Parent = SliderBar
    Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Fill.BorderSizePixel = 0
    Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)

    local dragging = false
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), 0, 1, 0)
            Fill.Size = pos
            local val = math.floor(min + ((max - min) * pos.X.Scale))
            TextLabel.Text = "  " .. name .. ": " .. val
            callback(val)
        end
    end)
end

-- Target Engine (Independent of ShiftLock)
local function GetClosestTarget()
    local closestTarget = nil
    local shortestDistance = math.huge
    local mousePos = UserInputService:GetMouseLocation()

    -- Check Players
    if getgenv().YuanConfig.TargetPlayers then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                local hrp = player.Character:FindFirstChild(getgenv().YuanConfig.AimPart)
                if hrp then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance < shortestDistance and distance <= getgenv().YuanConfig.FOV then
                        shortestDistance = distance
                        closestTarget = hrp
                    end
                end
            end
        end
    end

    -- Check NPCs/Bots
    if getgenv().YuanConfig.TargetNPCs then
        local enemiesFolder = Workspace:FindFirstChild("Enemies")
        if enemiesFolder then
            for _, npc in ipairs(enemiesFolder:GetChildren()) do
                local hum = npc:FindFirstChildOfClass("Humanoid")
                local hrp = npc:FindFirstChild(getgenv().YuanConfig.AimPart)
                if hum and hrp and hum.Health > 0 then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance < shortestDistance and distance <= getgenv().YuanConfig.FOV then
                        shortestDistance = distance
                        closestTarget = hrp
                    end
                end
            end
        end
    end

    return closestTarget
end

-- 1. Hard Aimbot (No ShiftLock Required)
CreateToggle("Hard Aimbot (Instant Lock)", false, function(state)
    getgenv().YuanConfig.AimbotEnabled = state
end)

RunService.RenderStepped:Connect(function()
    if getgenv().YuanConfig.AimbotEnabled then
        local target = GetClosestTarget()
        if target then
            -- Forces Camera to look directly at target regardless of shift lock state
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end

    -- FOV Visualizer Update
    if getgenv().YuanConfig.ShowFOV then
        FOVCircle.Position = UserInputService:GetMouseLocation()
        FOVCircle.Radius = getgenv().YuanConfig.FOV
        FOVCircle.Visible = getgenv().YuanConfig.AimbotEnabled or getgenv().YuanConfig.SilentAimEnabled
    else
        FOVCircle.Visible = false
    end
end)

-- Slider for FOV Range
CreateSlider("FOV Range", 100, 1000, 400, function(val)
    getgenv().YuanConfig.FOV = val
end)

-- 2. God-Tier Silent Aim (Auto Hit without Character Turning)
CreateToggle("Silent Aim (Zero Miss / No Turn)", false, function(state)
    getgenv().YuanConfig.SilentAimEnabled = state
end)

local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if getgenv().YuanConfig.SilentAimEnabled and (method == "FireServer" or method == "InvokeServer") then
        local target = GetClosestTarget()
        if target then
            for i, v in ipairs(args) do
                if typeof(v) == "Vector3" then
                    args[i] = target.Position
                elseif typeof(v) == "CFrame" then
                    args[i] = CFrame.new(target.Position)
                end
            end
            return oldNamecall(self, unpack(args))
        end
    end
    
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- 3. Advanced Fly Mode
local flying = false
local bv, bg

CreateToggle("Flight (Fly Mode)", false, function(state)
    getgenv().YuanConfig.FlyEnabled = state
    flying = state
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    if flying then
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = char.HumanoidRootPart

        bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.CFrame = Camera.CFrame
        bg.Parent = char.HumanoidRootPart
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

RunService.RenderStepped:Connect(function()
    if flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if bv and bg then
            bg.CFrame = Camera.CFrame
            local moveDir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
            bv.Velocity = moveDir * getgenv().YuanConfig.FlySpeed
        end
    end
end)

-- 4. ESP Engine
local espCache = {}

local function CreateESP(object, nameText)
    if espCache[object] then return end
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 255, 255)
    box.Thickness = 1
    box.Filled = false

    local name = Drawing.new("Text")
    name.Visible = false
    name.Color = Color3.fromRGB(255, 255, 255)
    name.Size = 13
    name.Center = true
    name.Outline = true

    espCache[object] = {Box = box, Name = name}
end

CreateToggle("ESP (Players & NPCs)", false, function(state)
    getgenv().YuanConfig.ESPEnabled = state
    if not state then
        for _, data in pairs(espCache) do
            data.Box.Visible = false
            data.Name.Visible = false
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if not getgenv().YuanConfig.ESPEnabled then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            CreateESP(player.Character)
        end
    end

    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if enemiesFolder then
        for _, npc in ipairs(enemiesFolder:GetChildren()) do
            local hum = npc:FindFirstChildOfClass("Humanoid")
            local hrp = npc:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then
                CreateESP(npc)
            end
        end
    end

    for obj, data in pairs(espCache) do
        if obj and obj.Parent and obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChildOfClass("Humanoid") and obj.Humanoid.Health > 0 then
            local hrp = obj.HumanoidRootPart
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local headPos = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 2.5, 0))
                local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height / 2

                data.Box.Size = Vector2.new(width, height)
                data.Box.Position = Vector2.new(vector.X - width / 2, vector.Y - height / 2)
                data.Box.Visible = getgenv().YuanConfig.BoxESP

                data.Name.Text = obj.Name
                data.Name.Position = Vector2.new(vector.X, headPos.Y - 15)
                data.Name.Visible = getgenv().YuanConfig.NameESP
            else
                data.Box.Visible = false
                data.Name.Visible = false
            end
        else
            data.Box.Visible = false
            data.Name.Visible = false
            espCache[obj] = nil
        end
    end
end)

print("Yuan God Mode Hub V3 Loaded Successfully!")
