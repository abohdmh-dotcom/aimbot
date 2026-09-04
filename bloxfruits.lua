--[========================================================]
--[      YUAN THE GOAT - STEAL AN EGG GOD HUB V1.0         ]
--[      Theme: Black, Red & White | Dual Language         ]
--[========================================================]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Configuration
getgenv().YuanEggConfig = {
    Language = "EN", -- "AR" or "EN"
    SpeedEnabled = false,
    WalkSpeed = 16,
    FlyEnabled = false,
    FlySpeed = 200
}

-- Remove existing GUI
if CoreGui:FindFirstChild("YuanStealAnEggGUI") then
    CoreGui.YuanStealAnEggGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YuanStealAnEggGUI"
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

-- Main Frame (Black & Red Luxury Theme)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderColor3 = Color3.fromRGB(220, 20, 60) -- Crimson Red
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Active = true
MainFrame.Draggable = true

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 45)

local HeaderBorder = Instance.new("Frame")
HeaderBorder.Parent = Header
HeaderBorder.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
HeaderBorder.BorderSizePixel = 0
HeaderBorder.Position = UDim2.new(0, 0, 1, -2)
HeaderBorder.Size = UDim2.new(1, 0, 0, 2)

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Font = Enum.Font.Code
Title.Text = "YUAN // STEAL AN EGG HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Language Switcher Button
local LangBtn = Instance.new("TextButton")
LangBtn.Parent = Header
LangBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
LangBtn.BorderColor3 = Color3.fromRGB(220, 20, 60)
LangBtn.Position = UDim2.new(1, -110, 0.5, -15)
LangBtn.Size = UDim2.new(0, 95, 0, 30)
LangBtn.Font = Enum.Font.Code
LangBtn.Text = "LANG: EN/AR"
LangBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LangBtn.TextSize = 12

-- Container
local Container = Instance.new("ScrollingFrame")
Container.Name = "Container"
Container.Parent = MainFrame
Container.Active = true
Container.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
Container.BorderColor3 = Color3.fromRGB(30, 30, 30)
Container.Position = UDim2.new(0, 12, 0, 60)
Container.Size = UDim2.new(0, 496, 0, 265)
Container.CanvasSize = UDim2.new(0, 0, 0, 400)
Container.ScrollBarThickness = 4
Container.ScrollBarImageColor3 = Color3.fromRGB(220, 20, 60)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

-- Helper to update texts based on language
local textElements = {}

local function RegisterText(enText, arText, obj, textType)
    table.insert(textElements, {EN = enText, AR = arText, Object = obj, Type = textType})
    obj.Text = (getgenv().YuanEggConfig.Language == "AR") and arText or enText
end

LangBtn.MouseButton1Click:Connect(function()
    if getgenv().YuanEggConfig.Language == "EN" then
        getgenv().YuanEggConfig.Language = "AR"
    else
        getgenv().YuanEggConfig.Language = "EN"
    end
    
    for _, item in ipairs(textElements) do
        local txt = (getgenv().YuanEggConfig.Language == "AR") and item.AR else item.EN
        if item.Type == "Toggle" then
            local stateText = item.Object.Text:match("%[.*%]") or "[OFF]"
            item.Object.Text = "  " .. txt .. ": " .. stateText
        else
            item.Object.Text = "  " .. txt
        end
    end
end)

-- Create Toggle Function
local function CreateToggle(enName, arName, default, callback)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Parent = Container
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    ToggleBtn.BorderColor3 = Color3.fromRGB(50, 50, 50)
    ToggleBtn.Size = UDim2.new(1, -10, 0, 45)
    ToggleBtn.Font = Enum.Font.Code
    ToggleBtn.TextColor3 = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 140, 140)
    ToggleBtn.TextSize = 14
    ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left

    local state = default
    local function updateText()
        local prefix = (getgenv().YuanEggConfig.Language == "AR") and arName or enName
        ToggleBtn.Text = "  " .. prefix .. ": " .. (state and "[ON / مفعل]" or "[OFF / معطل]")
    end
    updateText()
    RegisterText(enName, arName, ToggleBtn, "Toggle")

    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        ToggleBtn.TextColor3 = state and Color3.fromRGB(255, 69, 0) or Color3.fromRGB(140, 140, 140)
        updateText()
        callback(state)
    end)
end

-- Create Slider Function
local function CreateSlider(enName, arName, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Parent = Container
    SliderFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    SliderFrame.BorderColor3 = Color3.fromRGB(50, 50, 50)
    SliderFrame.Size = UDim2.new(1, -10, 0, 55)

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Parent = SliderFrame
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.new(0, 10, 0, 5)
    TextLabel.Size = UDim2.new(1, -20, 0, 20)
    TextLabel.Font = Enum.Font.Code
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 14
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left

    local function updateLabel(val)
        local name = (getgenv().YuanEggConfig.Language == "AR") and arName or enName
        TextLabel.Text = "  " .. name .. ": " .. val
    end
    updateLabel(default)
    
    table.insert(textElements, {EN = enName, AR = arName, Object = TextLabel, Type = "Slider", ValGetter = function() return ": " .. math.floor(default) end})

    local SliderBar = Instance.new("TextButton")
    SliderBar.Parent = SliderFrame
    SliderBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    SliderBar.BorderSizePixel = 0
    SliderBar.Position = UDim2.new(0, 10, 0, 35)
    SliderBar.Size = UDim2.new(1, -20, 0, 10)
    SliderBar.Text = ""

    local Fill = Instance.new("Frame")
    Fill.Parent = SliderBar
    Fill.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
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
            default = val
            local name = (getgenv().YuanEggConfig.Language == "AR") and arName or enName
            TextLabel.Text = "  " .. name .. ": " .. val
            callback(val)
        end
    end)
end

-- 1. WalkSpeed Hack (Up to 5000 Rocket Speed)
CreateToggle("Super Speed Mode", "وضع السرعة الخارقة", false, function(state)
    getgenv().YuanEggConfig.SpeedEnabled = state
end)

CreateSlider("Max Speed (16 - 5000)", "السرعة القصوى (16 - 5000)", 16, 5000, 100, function(val)
    getgenv().YuanEggConfig.WalkSpeed = val
end)

RunService.RenderStepped:Connect(function()
    if getgenv().YuanEggConfig.SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().YuanEggConfig.WalkSpeed
    end
end)

-- 2. Fly Mode (Rocket Flight)
local flying = false
local bv, bg

CreateToggle("Rocket Flight", "الطيران الصاروخي", false, function(state)
    getgenv().YuanEggConfig.FlyEnabled = state
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

CreateSlider("Flight Speed", "سرعة الطيران", 50, 1000, 250, function(val)
    getgenv().YuanEggConfig.FlySpeed = val
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
            bv.Velocity = moveDir * getgenv().YuanEggConfig.FlySpeed
        end
    end
end)

print("Yuan Steal An Egg Hub Loaded Successfully!")
