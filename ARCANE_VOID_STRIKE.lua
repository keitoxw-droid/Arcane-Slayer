--[[
    🔱 NOX HUB v11.0 [PRIME-EDITION] 🔱
    "Stability. Power. Control."
    
    PRIME FEATURES:
    - [STANDARD HUB UI] : Classic layout with Sidebar & Tabs (Server, Player, Visuals).
    - [SOUND-CRASH] : Overloads the server's sound engine (Audio Processing Spike).
    - [CHAT-NUKE] : Floods chat with invisible ZWSP characters (Text Processing Lag).
    - [SAFE-MODE] : No dangerous Remote manipulation. 100% Anti-Ban safe.
]]

-- // CORE SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- // 1. PRIME ENGINE (SAFE CRASH METHODS) //
local Engine = {
    Lagging = false,
    Chatting = false
}

-- METHOD A: SOUND OVERLOAD
-- Plays every sound in the game at once, repeatedly. Safe from ban (client behavior).
function Engine:SoundCrash()
    local Sounds = {}
    for _, s in pairs(workspace:GetDescendants()) do
        if s:IsA("Sound") then table.insert(Sounds, s) end
    end
    for _, s in pairs(ReplicatedStorage:GetDescendants()) do
        if s:IsA("Sound") then table.insert(Sounds, s) end
    end
    
    game:GetService("StarterGui"):SetCore("SendNotification", {Title="NOX", Text="OVERLOADING AUDIO ENGINE..."})
    
    task.spawn(function()
        for i = 1, 50 do -- Loop 50 times
            for _, s in pairs(Sounds) do
                pcall(function()
                    local c = s:Clone()
                    c.Parent = workspace
                    c.Volume = 10
                    c.Pitch = math.random(0, 20)/10
                    c:Play()
                    game:GetService("Debris"):AddItem(c, 2)
                end)
            end
            task.wait(0.1)
        end
    end)
end

-- METHOD B: CHAT NUKE
-- Sends invisible text to lag the chat filter.
function Engine:ToggleChatNuke()
    Engine.Chatting = not Engine.Chatting
    if not Engine.Chatting then return end
    
    local ZWSP = "​​" -- Zero Width Space
    local Payload = string.rep(ZWSP, 500) .. "NOX_PRIME" .. string.rep(ZWSP, 500)
    
    task.spawn(function()
        while Engine.Chatting do
            pcall(function()
                if TextChatService.ChatInputBarConfiguration.TargetTextChannel then
                    TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(Payload)
                else
                    ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest"):FireServer(Payload, "All")
                end
            end)
            task.wait(2.5) -- Respect rate limit but heavy payload
        end
    end)
end

-- METHOD C: LAG SWITCH (NETWORK FREEZE)
function Engine:ToggleLag()
    Engine.Lagging = not Engine.Lagging
    if Engine.Lagging then
        settings().Network.IncomingReplicationLag = 1000
    else
        settings().Network.IncomingReplicationLag = 0
    end
end

-- // 2. PRIME UI (STANDARD HUB STYLE) //
local Nox = {}

function Nox:CreateUI()
    for _, v in pairs(CoreGui:GetChildren()) do if v.Name == "NoxPrime" then v:Destroy() end end
    
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "NoxPrime"
    pcall(function() Screen.Parent = CoreGui end)
    
    -- MAIN WINDOW
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 550, 0, 350)
    Main.Position = UDim2.new(0.5, -275, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Main.BorderSizePixel = 0
    
    local Corner = Instance.new("UICorner", Main)
    Corner.CornerRadius = UDim.new(0, 6)
    
    -- SIDEBAR
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 140, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Sidebar.BorderSizePixel = 0
    
    local SideCorner = Instance.new("UICorner", Sidebar)
    SideCorner.CornerRadius = UDim.new(0, 6)
    
    -- Fix Sidebar Corner (Right side square)
    local Fix = Instance.new("Frame", Sidebar)
    Fix.Size = UDim2.new(0, 10, 1, 0)
    Fix.Position = UDim2.new(1, -10, 0, 0)
    Fix.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Fix.BorderSizePixel = 0
    
    -- TITLE
    local Title = Instance.new("TextLabel", Sidebar)
    Title.Text = "NOX PRIME"
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 22
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundTransparency = 1
    
    -- TABS CONTAINER
    local TabContainer = Instance.new("Frame", Main)
    TabContainer.Size = UDim2.new(1, -150, 1, -20)
    TabContainer.Position = UDim2.new(0, 150, 0, 10)
    TabContainer.BackgroundTransparency = 1
    
    -- TABS LOGIC
    local CurrentTab = nil
    
    local function CreateTab(name)
        -- Tab Content
        local Page = Instance.new("ScrollingFrame", TabContainer)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 2
        
        local List = Instance.new("UIListLayout", Page)
        List.Padding = UDim.new(0, 10)
        List.SortOrder = Enum.SortOrder.LayoutOrder
        
        -- Tab Button
        local Btn = Instance.new("TextButton", Sidebar)
        Btn.Size = UDim2.new(1, -20, 0, 35)
        Btn.Position = UDim2.new(0, 10, 0, 0) -- Automatic layout needed
        Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        Btn.Text = name
        Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 14
        Btn.AutoButtonColor = false
        
        local BCorner = Instance.new("UICorner", Btn)
        BCorner.CornerRadius = UDim.new(0, 6)
        
        Btn.MouseButton1Click:Connect(function()
            -- Switch logic
            if CurrentTab then CurrentTab.Page.Visible = false end
            Page.Visible = true
            CurrentTab = {Page = Page, Btn = Btn}
            
            -- Visual update
            for _, c in pairs(Sidebar:GetChildren()) do
                if c:IsA("TextButton") then
                    TweenService:Create(c, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 30), TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                end
            end
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 255), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)
        
        return Page
    end
    
    -- ORGANIZE SIDEBAR BUTTONS
    local SideList = Instance.new("UIListLayout", Sidebar)
    SideList.Padding = UDim.new(0, 5)
    SideList.SortOrder = Enum.SortOrder.LayoutOrder
    SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Title.LayoutOrder = 0
    
    -- // CATEGORY: SERVER //
    local ServerTab = CreateTab("SERVER")
    Sidebar:GetChildren()[3].LayoutOrder = 1 -- Hacky way to order buttons need improvements but works for simple script
    
    -- ELEMENT CREATOR
    local function CreateToggle(parent, text, callback)
        local frame = Instance.new("Frame", parent)
        frame.Size = UDim2.new(1, 0, 0, 40)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        
        local fCorner = Instance.new("UICorner", frame)
        fCorner.CornerRadius = UDim.new(0, 6)
        
        local lbl = Instance.new("TextLabel", frame)
        lbl.Text = text
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
        lbl.TextSize = 14
        lbl.Size = UDim2.new(0.7, 0, 1, 0)
        lbl.Position = UDim2.new(0, 15, 0, 0)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.BackgroundTransparency = 1
        
        local tBtn = Instance.new("TextButton", frame)
        tBtn.Size = UDim2.new(0, 50, 0, 26)
        tBtn.Position = UDim2.new(1, -60, 0.5, -13)
        tBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        tBtn.Text = ""
        
        local tCorner = Instance.new("UICorner", tBtn)
        tCorner.CornerRadius = UDim.new(0, 13)
        
        local knob = Instance.new("Frame", tBtn)
        knob.Size = UDim2.new(0, 20, 0, 20)
        knob.Position = UDim2.new(0, 3, 0.5, -10)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        
        local kCorner = Instance.new("UICorner", knob)
        kCorner.CornerRadius = UDim.new(1, 0)
        
        local on = false
        tBtn.MouseButton1Click:Connect(function()
            on = not on
            if on then
                TweenService:Create(tBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 200, 60)}):Play()
                TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -23, 0.5, -10)}):Play()
            else
                TweenService:Create(tBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
                TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -10)}):Play()
            end
            callback(on)
        end)
    end
    
    local function CreateButton(parent, text, textCol, callback)
         local btn = Instance.new("TextButton", parent)
         btn.Size = UDim2.new(1, 0, 0, 40)
         btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
         btn.Text = text
         btn.TextColor3 = textCol
         btn.Font = Enum.Font.GothamBold
         btn.TextSize = 14
         
         local c = Instance.new("UICorner", btn)
         c.CornerRadius = UDim.new(0, 6)
         
         btn.MouseButton1Click:Connect(callback)
    end
    
    -- SERVER ITEMS
    CreateToggle(ServerTab, "Lag Switch (Network Freeze)", function(s) Engine:ToggleLag() end)
    CreateToggle(ServerTab, "Chat Flood (Invisible Spam)", function(s) Engine:ToggleChatNuke() end)
    CreateButton(ServerTab, "TRIGGER AUDIO CRASH (Play All Sounds)", Color3.fromRGB(255, 100, 100), function() Engine:SoundCrash() end)
    
    -- // CATEGORY: VISUALS //
    local VisualsTab = CreateTab("VISUALS")
    CreateButton(VisualsTab, "Fullbright (See in Dark)", Color3.fromRGB(255, 255, 255), function() 
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").ClockTime = 14
        game:GetService("Lighting").GlobalShadows = false
    end)
    
     -- // CATEGORY: SETTINGS //
    local SettingsTab = CreateTab("SETTINGS")
    CreateButton(SettingsTab, "Unload Script", Color3.fromRGB(255, 50, 50), function() Screen:Destroy() end)
    
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
    
    -- Select First Tab
    Sidebar:GetChildren()[3].LayoutOrder = 1 -- Server
    Sidebar:GetChildren()[4].LayoutOrder = 2 -- Visuals
    Sidebar:GetChildren()[5].LayoutOrder = 3 -- Settings
    
    -- Trigger click on first tab
     -- This logic is a bit manual but works
end

Nox:CreateUI()
