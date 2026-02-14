--[[
    🔱 NOX HUB v10.0 [ECLIPSE-MIRROR] 🔱
    "Attack with their own weapons."
    
    Verified Failure Analysis:
    - v9.0 hit "DevTools" because it spammed blindly.
    
    ECLIPSE SOLUTION:
    - [PASSIVE SNIFFER] : Records REAL traffic sent by the game.
    - [SAFE-LIST BUILDING] : Only targets Remotes that have been legitimately fired.
    - [REPLAY ATTACK] : Re-uses legitimate arguments to bypass type-checking.
]]

-- // CORE SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- // 1. TRAFFIC MIRROR ENGINE //
local Engine = {
    Recording = true,
    Attacking = false,
    SafeLog = {} -- Stores {Remote = instance, Args = {...}}
}

-- THE HOOK (SNIFFER)
local function InstallHook()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if method == "FireServer" and self:IsA("RemoteEvent") then
            -- If the script is NOT attacking, we are learning.
            if not Engine.Attacking and Engine.Recording then
                -- Check if we already know this remote
                local known = false
                for _, log in pairs(Engine.SafeLog) do
                    if log.Remote == self then known = true break end
                end
                
                if not known then
                    -- FILTER: Ignore obviously bad ones even if game uses them (rare)
                    local n = self.Name:lower()
                    if not (n:find("ban") or n:find("kick") or n:find("debug")) then
                        -- STORE IT AS SAFE
                        table.insert(Engine.SafeLog, {
                            Remote = self,
                            Args = args -- Capture valid args
                        })
                    end
                end
            end
        end
        
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end
task.spawn(InstallHook)

-- THE ATTACK
function Engine:Start()
    if Engine.Attacking then return end
    if #Engine.SafeLog == 0 then
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="NOX", Text="NO TRAFFIC CAPTURED YET. PLAY THE GAME FIRST!"})
        return
    end
    
    Engine.Attacking = true
    Engine.Recording = false -- Stop recording to save memory
    
    task.spawn(function()
        while Engine.Attacking do
            -- SPAM ONLY THE KNOWN SAFE REMOTES
            for _, log in pairs(Engine.SafeLog) do
                pcall(function()
                    -- REPLAY THE EXACT VALID ARGUMENTS 10 TIMES
                    for i = 1, 10 do
                        log.Remote:FireServer(unpack(log.Args))
                    end
                end)
            end
            RunService.Heartbeat:Wait()
        end
    end)
end

function Engine:Stop()
    Engine.Attacking = false
    Engine.Recording = true -- Resume learning
end

-- // 2. ECLIPSE UI //
local Nox = {}

function Nox:CreateUI()
    for _, v in pairs(CoreGui:GetChildren()) do if v.Name == "NoxEclipse" then v:Destroy() end end
    
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "NoxEclipse"
    pcall(function() Screen.Parent = CoreGui end)
    
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 350, 0, 180)
    Main.Position = UDim2.new(0.5, -175, 0.5, -90)
    Main.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    Main.BorderSizePixel = 1
    Main.BorderColor3 = Color3.fromRGB(100, 100, 255)
    
    -- HEADER
    local Title = Instance.new("TextLabel", Main)
    Title.Text = "NOX // ECLIPSE v10.0"
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Color3.fromRGB(150, 150, 255)
    Title.TextSize = 16
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundTransparency = 1
    
    -- TRAFFIC MONITOR
    local Monitor = Instance.new("TextLabel", Main)
    Monitor.Text = "LISTENING FOR TRAFFIC..."
    Monitor.TextColor3 = Color3.fromRGB(100, 255, 100)
    Monitor.Font = Enum.Font.Code
    Monitor.TextSize = 14
    Monitor.Size = UDim2.new(1, 0, 0, 20)
    Monitor.Position = UDim2.new(0, 0, 0, 40)
    Monitor.BackgroundTransparency = 1
    
    -- UPDATE LOOP
    task.spawn(function()
        while Main.Parent do
            if not Engine.Attacking then
                Monitor.Text = "CAPTURED PACKETS: " .. #Engine.SafeLog
                Monitor.TextColor3 = Color3.fromRGB(100, 255, 100)
            else
                Monitor.Text = "REPLAYING " .. #Engine.SafeLog .. " VECTORS..."
                Monitor.TextColor3 = Color3.fromRGB(255, 50, 50)
            end
            wait(0.5)
        end
    end)
    
    -- ACTION BUTTON
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.8, 0, 0.4, 0)
    Btn.Position = UDim2.new(0.1, 0, 0.5, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    Btn.Text = "MIRROR ATTACK"
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBlack
    Btn.TextSize = 20
    
    Btn.MouseButton1Click:Connect(function()
        if not Engine.Attacking then
            Engine:Start()
            Btn.Text = "STOP REFLECTION"
            Btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
        else
            Engine:Stop()
            Btn.Text = "MIRROR ATTACK"
            Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
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

Nox:CreateUI()
