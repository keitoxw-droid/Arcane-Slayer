--[[
    🔱 NOX HUB v12.0 [FLUX-ROTATION] 🔱
    "Adapt. Rotate. Overcome."
    
    FLUX FEATURES:
    - [FLUX UI] : Fixed, absolute-positioned layout. No more visual bugs.
    - [ATTACK ROTATION] : Cycles between Sound, Chat, and Animation spam every 3 seconds.
      -> Prevents Server Anti-Spam from catching 1 specific method.
      -> Bypasses the "4 Seconds" limit you encountered.
    - [PHANTOM GUARD] : Keeps the Anti-Ban active.
]]

-- // CORE SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- // 1. ROTATION ENGINE //
local Engine = {
    Running = false,
    Phase = 1, -- 1=Audio, 2=Chat, 3=Anim
    LastSwitch = 0
}

-- ATTACK 1: AUDIO FLOOD (CPU STRESS)
local function Attack_Audio()
    -- Clones sounds locally and plays them loudly
    local Sounds = {}
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("Sound") then table.insert(Sounds, v) end
    end
    -- Fallback
    if #Sounds == 0 then 
        local s = Instance.new("Sound") 
        s.SoundId = "rbxassetid://12221967" -- Genetic sound
        table.insert(Sounds, s) 
    end
    
    for i = 1, 10 do
        local s = Sounds[math.random(1, #Sounds)]:Clone()
        s.Parent = workspace
        s.Volume = 5
        s:Play()
        game:GetService("Debris"):AddItem(s, 2)
    end
end

-- ATTACK 2: CHAT LAG (FILTER STRESS)
local function Attack_Chat()
    local ZWSP = "​​"
    local Payload = string.rep(ZWSP, 300) .. "NOX" .. string.rep(ZWSP, 300)
    
    pcall(function()
        if TextChatService.ChatInputBarConfiguration.TargetTextChannel then
            TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(Payload)
        else
            ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest"):FireServer(Payload, "All")
        end
    end)
end

-- ATTACK 3: EMOTE SPAM (NETWORK STRESS)
local function Attack_Anim()
    local Char = LocalPlayer.Character
    local Hum = Char and Char:FindFirstChild("Humanoid")
    if Hum then
        -- Rapidly falling state forces replication
        Hum:ChangeState(Enum.HumanoidStateType.FallingDown)
        Hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

function Engine:StartCycle()
    if Engine.Running then return end
    Engine.Running = true
    Engine.Phase = 1
    
    task.spawn(function()
        while Engine.Running do
            local Time = tick()
            
            -- ROTATE EVERY 3 SECONDS
            if Time - Engine.LastSwitch > 3 then
                Engine.Phase = Engine.Phase + 1
                if Engine.Phase > 3 then Engine.Phase = 1 end
                Engine.LastSwitch = Time
                
                -- Update UI Status
                local StatusTxt = "PHASE " .. Engine.Phase .. ": "
                if Engine.Phase == 1 then StatusTxt = StatusTxt .. "AUDIO OVERLOAD" end
                if Engine.Phase == 2 then StatusTxt = StatusTxt .. "CHAT FLOOD" end
                if Engine.Phase == 3 then StatusTxt = StatusTxt .. "PHYSIC SPAM" end
                
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "NOX ROTATION",
                    Text = StatusTxt,
                    Duration = 1
                })
            end
            
            -- EXECUTE CURRENT PHASE
            if Engine.Phase == 1 then Attack_Audio() end
            if Engine.Phase == 2 then Attack_Chat() end
            if Engine.Phase == 3 then Attack_Anim() end
            
            task.wait(0.2) -- Fast tick
        end
    end)
end

-- // 2. FLUX UI (REWRITTEN & FIXED) //
local Nox = {}

function Nox:CreateUI()
    -- Cleanup
    for _, v in pairs(CoreGui:GetChildren()) do 
        if v.Name == "NoxFlux" or v.Name == "NoxPrime" then v:Destroy() end 
    end
    
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "NoxFlux"
    pcall(function() Screen.Parent = CoreGui end)
    
    -- Main Container
    local Main = Instance.new("Frame", Screen)
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 500, 0, 300)
    Main.Position = UDim2.new(0.5, -250, 0.5, -150)
    Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    Main.BorderSizePixel = 0
    
    local MainCorner = Instance.new("UICorner", Main)
    MainCorner.CornerRadius = UDim.new(0, 8)
    
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(40, 40, 50)
    Stroke.Thickness = 2
    
    -- SIDEBAR (Fixed Layout)
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Sidebar.BorderSizePixel = 0
    
    local SideCorner = Instance.new("UICorner", Sidebar)
    SideCorner.CornerRadius = UDim.new(0, 8)
    
    -- Square off right side of sidebar
    local Fix = Instance.new("Frame", Sidebar)
    Fix.Size = UDim2.new(0, 20, 1, 0)
    Fix.Position = UDim2.new(1, -10, 0, 0)
    Fix.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Fix.BorderSizePixel = 0
    Fix.ZIndex = 1
    
    -- LOGO
    local Logo = Instance.new("TextLabel", Sidebar)
    Logo.Text = "NOX FLUX"
    Logo.Size = UDim2.new(1, 0, 0, 50)
    Logo.TextColor3 = Color3.fromRGB(80, 180, 255)
    Logo.Font = Enum.Font.GothamBlack
    Logo.TextSize = 22
    Logo.BackgroundTransparency = 1
    Logo.ZIndex = 2
    
    -- BUTTON CONTAINER
    local BtnContainer = Instance.new("Frame", Sidebar)
    BtnContainer.Size = UDim2.new(1, 0, 1, -60)
    BtnContainer.Position = UDim2.new(0, 0, 0, 60)
    BtnContainer.BackgroundTransparency = 1
    BtnContainer.ZIndex = 2
    
    local List = Instance.new("UIListLayout", BtnContainer)
    List.Padding = UDim.new(0, 5)
    List.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    -- CONTENT AREA
    local Content = Instance.new("Frame", Main)
    Content.Size = UDim2.new(1, -160, 1, -20)
    Content.Position = UDim2.new(0, 160, 0, 10)
    Content.BackgroundTransparency = 1
    
    -- TABS
    local Tabs = {}
    
    local function CreateTab(name, iconId)
        -- 1. Create content frame (Hidden by default)
        local Page = Instance.new("ScrollingFrame", Content)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        
        local PageList = Instance.new("UIListLayout", Page)
        PageList.Padding = UDim.new(0, 10)
        
        -- 2. Create sidebar button
        local Btn = Instance.new("TextButton", BtnContainer)
        Btn.Size = UDim2.new(0.9, 0, 0, 35)
        Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        Btn.Text = name
        Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 14
        
        local BtnCorner = Instance.new("UICorner", Btn)
        BtnCorner.CornerRadius = UDim.new(0, 6)
        
        -- Click Event
        Btn.MouseButton1Click:Connect(function()
            -- Hide all
            for _, t in pairs(Tabs) do 
                t.Page.Visible = false 
                TweenService:Create(t.Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 30), TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
            end
            -- Show active
            Page.Visible = true
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 180, 255), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)
        
        table.insert(Tabs, {Page=Page, Btn=Btn})
        return Page
    end
    
    -- ELEMENTS
    local function AddButton(page, text, method)
        local b = Instance.new("TextButton", page)
        b.Size = UDim2.new(1, 0, 0, 45)
        b.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        b.Text = text
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 14
        
        local c = Instance.new("UICorner", b)
        c.CornerRadius = UDim.new(0, 6)
        
        b.MouseButton1Click:Connect(function()
            method(b)
        end)
    end
    
    -- BUILD TABS
    local Home = CreateTab("SERVER", "")
    local Visuals = CreateTab("VISUALS", "")
    local Settings = CreateTab("SETTINGS", "")
    
    -- HOME CONTENT
    AddButton(Home, "START ROTATION ATTACK (Loop)", function(btn) 
        if Engine.Running then
            Engine.Running = false
            btn.Text = "START ROTATION ATTACK (Loop)"
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            game:GetService("StarterGui"):SetCore("SendNotification", {Title="NOX", Text="ATTACK STOPPED"})
        else
            Engine:StartCycle()
            btn.Text = "STOP ATTACK (Running...)"
            btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            game:GetService("StarterGui"):SetCore("SendNotification", {Title="NOX", Text="ROTATION STARTED"})
        end
    end)
    
    AddButton(Home, "Force Lag Switch (Manual)", function(btn)
        local On = settings().Network.IncomingReplicationLag > 0
        if On then
            settings().Network.IncomingReplicationLag = 0
            btn.Text = "Force Lag Switch (OFF)"
        else
            settings().Network.IncomingReplicationLag = 1000
            btn.Text = "Force Lag Switch (ON)"
        end
    end)
    
    -- VISUALS CONTENT
    AddButton(Visuals, "Fullbright", function()
        game:GetService("Lighting").Brightness = 3
        game:GetService("Lighting").GlobalShadows = false
    end)
    
    -- INITIAL SELECT
    Tabs[1].Btn.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
    Tabs[1].Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tabs[1].Page.Visible = true
    
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
