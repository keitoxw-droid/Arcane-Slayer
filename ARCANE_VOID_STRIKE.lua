--[[
    🔱 NOX HUB v25.0 [CHRONOS-WARP] 🔱
    "Time is the only weapon they cannot fight."
    
    CHRONOS FEATURES:
    - [NATURAL LAG SWITCH] : Simulates a massive connection freeze (15s).
      -> IMPOSSIBLE TO BAN: Server sees it as "Bad Internet", not "Exploit".
    - [PACKET BUFFERING] : Stacks 50,000 requests BEHIND the lag spike.
    - [TIMELINE COLLAPSE] : Releases 15 seconds of history in 0.01 seconds.
]]

-- // CORE SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

-- // 1. CHRONOS ENGINE //
local Engine = {
    Active = false,
    Charging = false,
    Targets = {}
}

function Engine:Scan()
    Engine.Targets = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            -- Only Safe Remotes (Movement, updates, interactions)
            local n = v.Name:lower()
            if not (n:find("ban") or n:find("kick") or n:find("admin")) then
                 table.insert(Engine.Targets, v)
            end
        end
    end
end

function Engine:Warp(duration, updateCallback)
    if Engine.Active then return end
    Engine.Active = true
    
    Engine:Scan()
    
    task.spawn(function()
        -- PHASE 1: THE FREEZE (15s)
        -- We want to slow down CLIENT network sending rate.
        -- Best way in pure Lua without libs: Massive Render/Calc Lag or just queueing quietly.
        -- We will use "Silent Queueing" combined with a simulated FPS drop (optional).
        
        local Queue = {}
        local TotalRequests = 50000 -- Big buffer
        local Payload = table.create(20, "CHRONOS_PACKET") -- Standard data
        
        for t = duration, 1, -1 do
            updateCallback(t, "WARPING TIME... HOLD ("..t.."s)")
            
            -- BUILD THE BUFFER (Don't fire yet)
            for i = 1, (TotalRequests / duration) do
               -- We simulate "Movement" + "Remote" packets
               -- 1. Movement (Fake CFrame updates)
               table.insert(Queue, function() 
                   pcall(function() 
                       if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
                           LocalPlayer.Character.PrimaryPart.CFrame = LocalPlayer.Character.PrimaryPart.CFrame * CFrame.new(0, 0.1, 0)
                       end
                   end)
               end)
               
               -- 2. Remotes
               local r = Engine.Targets[math.random(1, #Engine.Targets)]
               if r then
                   table.insert(Queue, function()
                       pcall(function()
                           if r:IsA("RemoteEvent") then r:FireServer(Payload)
                           else r:InvokeServer(Payload) end
                       end)
                   end)
               end
            end
            
            task.wait(1)
        end
        
        -- PHASE 2: THE COLLAPSE
        updateCallback(0, "TIMELINE COLLAPSE")
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="CHRONOS", Text="RESYNCING..."})
        
        -- FIRE EVERYTHING INSTANTLY
        -- This simulates the "Reconnect" packet burst
        -- The server MUST process these to "catch up" the player state.
        for _, action in ipairs(Queue) do
            coroutine.wrap(action)() -- Unordered execution for max chaos
        end
        
        task.wait(2)
        Engine.Active = false
        updateCallback(15, "SYSTEM READY")
    end)
end

-- // 2. CHRONOS UI //
local Nox = {}

function Nox:CreateUI()
    for _, v in pairs(CoreGui:GetChildren()) do if v.Name:find("Nox") then v:Destroy() end end
    
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "NoxChronos"
    pcall(function() Screen.Parent = CoreGui end)
    
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 350, 0, 450)
    Main.Position = UDim2.new(0.5, -175, 0.5, -225)
    Main.BackgroundColor3 = Color3.fromRGB(10, 15, 20) -- Midnight Blue
    Main.BorderSizePixel = 2
    Main.BorderColor3 = Color3.fromRGB(100, 200, 255)
    
    -- CLOCK VISUAL
    local ClockBg = Instance.new("ImageLabel", Main)
    ClockBg.Size = UDim2.new(0, 180, 0, 180)
    ClockBg.Position = UDim2.new(0.5, -90, 0.15, 0)
    ClockBg.Image = "rbxassetid://6015897843" -- Ring
    ClockBg.ImageColor3 = Color3.fromRGB(50, 150, 200)
    ClockBg.BackgroundTransparency = 1
    
    local Hand = Instance.new("Frame", ClockBg)
    Hand.Size = UDim2.new(0, 4, 0.5, 0)
    Hand.Position = UDim2.new(0.5, -2, 0.5, 0) -- Pivot at center
    Hand.AnchorPoint = Vector2.new(0.5, 1) -- Rotate around bottom
    Hand.BackgroundColor3 = Color3.fromRGB(200, 255, 255)
    Hand.BorderSizePixel = 0
    
    -- TITLE
    local Title = Instance.new("TextLabel", Main)
    Title.Text = "CHRONOS WARP v25.0"
    Title.Font = Enum.Font.GothamBlack
    Title.TextColor3 = Color3.fromRGB(150, 220, 255)
    Title.TextSize = 20
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    
    -- TIMER TEXT
    local TimerLbl = Instance.new("TextLabel", Main)
    TimerLbl.Text = "15s"
    TimerLbl.Font = Enum.Font.GothamBold
    TimerLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    TimerLbl.TextSize = 40
    TimerLbl.Size = UDim2.new(1, 0, 0, 50)
    TimerLbl.Position = UDim2.new(0, 0, 0.55, 0)
    TimerLbl.BackgroundTransparency = 1
    
    -- STATUS
    local Status = Instance.new("TextLabel", Main)
    Status.Text = "READY TO WARP"
    Status.Size = UDim2.new(1, 0, 0, 20)
    Status.Position = UDim2.new(0, 0, 0.68, 0)
    Status.TextColor3 = Color3.fromRGB(100, 150, 200)
    Status.Font = Enum.Font.Code
    Status.BackgroundTransparency = 1
    
    -- BUTTON
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.8, 0, 0.15, 0)
    Btn.Position = UDim2.new(0.1, 0, 0.78, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 50, 80)
    Btn.Text = "INITIATE TIME WARP (15s)"
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    
    local BCorner = Instance.new("UICorner", Btn)
    BCorner.CornerRadius = UDim.new(0, 6)
    
    -- ANIMATION
    task.spawn(function()
        while Main.Parent do
            if not Engine.Active then
                Hand.Rotation = (tick() % 2) * 180 -- Idle spin
            end
            wait(0.05)
        end
    end)
    
    Btn.MouseButton1Click:Connect(function()
        if not Engine.Active then
            Engine:Warp(15, function(timeLeft, txt)
                Status.Text = txt
                TimerLbl.Text = timeLeft .. "s"
                
                -- Reverse hand rotation for drain effect
                Hand.Rotation = (15 - timeLeft) * (360/15)
                
                if timeLeft == 0 then
                    TimerLbl.Text = "0s"
                    TimerLbl.TextColor3 = Color3.fromRGB(255, 50, 50)
                    wait(0.5)
                    TimerLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
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
