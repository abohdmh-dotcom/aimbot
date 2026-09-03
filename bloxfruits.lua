--[========================================================]
--[        YUAN THE GOAT - BLOX FRUITS ULTIMATE GUI        ]
--[          Designed for Performance & Precision          ]
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
    AimbotSmoothness = 1,
    AimPart = "HumanoidRootPart",
    TargetNPCs = true,
    TargetPlayers = true,
    FOV = 350,
    ShowFOV = true,
    FlyEnabled = false,
    FlySpeed = 50,
    ESPEnabled = false,
    BoxESP = true,
    NameESP = true,
    DistanceESP = true
}

-- Remove existing GUI if any
if CoreGui:FindFirstChild("YuanBloxFruitsGUI") then
    CoreGui.YuanBloxFruitsGUI:Destroy()
end

-- Main ScreenGui (Minimalist Dark Theme: Black & White)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YuanBloxFruitsGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Protect GUI if executor supports it
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
FOVCircle.Transparency = 0.7
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
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true

-- Top Bar / Header
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
Title.Text = "YUAN // BLOX FRUITS HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local Subtitle = Instance.new("TextLabel")
Subtitle.Parent = Header
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.new(1, -150, 0, 0)
Subtitle.Size = UDim2.new(0, 140, 1, 0)
Subtitle.Font = Enum.Font.Code
Subtitle.Text = "[v2.0 PRO]"
Subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
Subtitle.TextSize = 14
Subtitle.TextXAlignment = Enum.TextXAlignment.Right

-- Container for Toggles / Features
local Container = Instance.new("ScrollingFrame")
Container.Name = "Container"
Container.Parent = MainFrame
Container.Active = true
Container.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Container.BorderColor3 = Color3.fromRGB(40, 40, 40)
Container.Position = UDim2.new(0, 12, 0, 55)
Container.Size = UDim2.new(0, 526, 0, 280)
Container.CanvasSize = UDim2.new(0, 0, 0, 450)
Container.ScrollBarThickness = 4
Container.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- Function to create clean toggle buttons
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

-- Utility: Find Closest Target (Players + NPCs)
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

    -- Check NPCs (Enemies in Blox Fruits workspace)
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

-- 1. Aimbot Logic
CreateToggle("Hard Aimbot (Lock-on)", false, function(state)
    getgenv().YuanConfig.AimbotEnabled = state
end)

RunService.RenderStepped:Connect(function()
    if getgenv().YuanConfig.AimbotEnabled then
        local target = GetClosestTarget()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end

    -- Update FOV Circle Position
    if getgenv().YuanConfig.ShowFOV then
        FOVCircle.Position = UserInputService:GetMouseLocation()
        FOVCircle.Radius = getgenv().YuanConfig.FOV
        FOVCircle.Visible = getgenv().YuanConfig.AimbotEnabled or getgenv().YuanConfig.SilentAimEnabled
    else
        FOVCircle.Visible = false
    end
end)

-- 2. Silent Aim Logic
CreateToggle("Silent Aim (Zero Miss)", false, function(state)
    getgenv().YuanConfig.SilentAimEnabled = state
end)

-- Hooking Metatable to redirect bullets/attacks directly to target
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
                    -- Redirect Vector3 positions (such as projectiles or raycasts) to the exact target part
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

-- 3. Fly Logic
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
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + Camera.CFrame.RightVector
            end
            bv.Velocity = moveDir * getgenv().YuanConfig.FlySpeed
        end
    end
end)

-- 4. ESP Logic (Players & Enemies)
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

    espCache[object] = {Box = box, Name = name, Target = object}
end

local function RemoveESP(object)
    if espCache[object] then
        espCache[object].Box:Remove()
        espCache[object].Name:Remove()
        espCache[object] = nil
    end
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

    -- Manage Players ESP
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            CreateESP(player.Character, player.Name)
        end
    end

    -- Manage NPCs ESP
    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if enemiesFolder then
        for _, npc in ipairs(enemiesFolder:GetChildren()) do
            local hum = npc:FindFirstChildOfClass("Humanoid")
            local hrp = npc:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then
                CreateESP(npc, npc.Name)
            end
        end
    end

    -- Render ESP items
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
            RemoveESP(obj)
        end
    end
end)

print("Yuan Blox Fruits Hub Loaded Successfully!")
