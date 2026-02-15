--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║       HD ADMIN ARCANE (ZERO-DRAG v12.0)             ║
    ║   "Se délier de soi pour mieux lier les autres."         ║
    ╚═══════════════════════════════════════════════════════════╝
    
    Opération : Sovereign Prestige (v22.0) - THE FE PINNER
    Fix : Self-Teleport (Weld Break), Target Freeze (0.05 Jitter)
    Engine : Zero-Drag Massive Force v2.2
]]

-- 1. CONFIGURATION
local Players = game:GetService("Players")
local L = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local State = { Prefix = ";", Muted = {}, Active = true }
_G.ArcaneState = State
pcall(function() if _G.ArcaneCleanup then _G.ArcaneCleanup() end end)

local COLORS = {
    Header = Color3.fromRGB(0, 107, 173), -- #006BAD
    SubHeader = Color3.fromRGB(0, 85, 135), -- #005587
    Background = Color3.fromRGB(33, 33, 36), -- #1F1F24
    Row = Color3.fromRGB(43, 43, 46), -- #2B2B2E
    TextWhite = Color3.fromRGB(245, 245, 245),
    TextGray = Color3.fromRGB(180, 180, 180)
}

-- 2. INTERFACE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HD_Pinner_v22_0"; ScreenGui.ResetOnSpawn = false; ScreenGui.DisplayOrder = 100000
local p = (gethui and gethui()) or L:WaitForChild("PlayerGui")
ScreenGui.Parent = p

-- BOUTON "HD"
local HDButton = Instance.new("TextButton", ScreenGui)
HDButton.Size = UDim2.new(0, 30, 0, 30); HDButton.Position = UDim2.new(0, 150, 0, 4); HDButton.BackgroundColor3 = Color3.fromRGB(33, 33, 36); HDButton.BorderSizePixel = 0; HDButton.Text = "HD"; HDButton.TextColor3 = Color3.new(1, 1, 1); HDButton.Font = Enum.Font.SourceSansBold; HDButton.TextSize = 13; HDButton.ZIndex = 500
Instance.new("UICorner", HDButton).CornerRadius = UDim.new(1, 0)
local HDStroke = Instance.new("UIStroke", HDButton); HDStroke.Color = Color3.new(1,1,1); HDStroke.Transparency = 0.6

-- WINDOW
local CmdWindow = Instance.new("Frame", ScreenGui)
CmdWindow.Size = UDim2.new(0, 310, 0, 400); CmdWindow.Position = UDim2.new(0.5, -155, 0.5, -200); CmdWindow.BackgroundColor3 = COLORS.Background; CmdWindow.Visible = false; CmdWindow.Active = true; CmdWindow.ZIndex = 120
Instance.new("UICorner", CmdWindow).CornerRadius = UDim.new(0, 4)
local WindowStroke = Instance.new("UIStroke", CmdWindow); WindowStroke.Color = Color3.new(0,0,0); WindowStroke.Transparency = 0.5; WindowStroke.Thickness = 1.5

local Header = Instance.new("Frame", CmdWindow); Header.Size = UDim2.new(1, 0, 0, 32); Header.BackgroundColor3 = COLORS.Header; Header.ZIndex = 130
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 4)
local XBtn = Instance.new("TextButton", Header); XBtn.Size = UDim2.new(0, 32, 1, 0); XBtn.Position = UDim2.new(1, -32, 0, 0); XBtn.BackgroundTransparency = 1; XBtn.Text = "X"; XBtn.TextColor3 = COLORS.TextWhite; XBtn.Font = Enum.Font.SourceSansBold; XBtn.TextSize = 14; XBtn.ZIndex = 131; XBtn.MouseButton1Click:Connect(function() CmdWindow.Visible = false end)
local Title = Instance.new("TextLabel", Header); Title.Size = UDim2.new(1, 0, 1, 0); Title.BackgroundTransparency = 1; Title.Text = "COMMANDS"; Title.TextColor3 = COLORS.TextWhite; Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 14; Title.ZIndex = 111

local SubH = Instance.new("Frame", CmdWindow); SubH.Size = UDim2.new(1, 0, 0, 26); SubH.Position = UDim2.new(0, 0, 0, 32); SubH.BackgroundColor3 = COLORS.SubHeader; SubH.ZIndex = 105
local ST = Instance.new("TextLabel", SubH); ST.Size = UDim2.new(1, 0, 1, 0); ST.BackgroundTransparency = 1; ST.Text = "<      COMMANDS      >"; ST.TextColor3 = COLORS.TextWhite; ST.Font = Enum.Font.SourceSansBold; ST.TextSize = 11; ST.ZIndex = 106

-- SEARCH
local SC = Instance.new("Frame", CmdWindow); SC.Size = UDim2.new(1, -10, 0, 26); SC.Position = UDim2.new(0, 5, 0, 62); SC.BackgroundColor3 = Color3.fromRGB(24, 24, 26); SC.ZIndex = 120
Instance.new("UICorner", SC).CornerRadius = UDim.new(0, 3)
local Loupe = Instance.new("ImageLabel", SC); Loupe.Size = UDim2.new(0, 16, 0, 16); Loupe.Position = UDim2.new(0, 4, 0.5, -8); Loupe.BackgroundTransparency = 1; Loupe.Image = "rbxassetid://6031154636"; Loupe.ImageColor3 = Color3.fromRGB(150,150,150); Loupe.ZIndex = 121
local SB = Instance.new("TextBox", SC); SB.Size = UDim2.new(1, -24, 1, 0); SB.Position = UDim2.new(0, 24, 0, 0); SB.BackgroundTransparency = 1; SB.TextColor3 = COLORS.TextWhite; SB.Font = Enum.Font.SourceSans; SB.TextSize = 13; SB.PlaceholderText = "Search"; SB.Text = ""; SB.TextXAlignment = Enum.TextXAlignment.Left; SB.ZIndex = 121

local List = Instance.new("ScrollingFrame", CmdWindow); List.Size = UDim2.new(1, -10, 1, -100); List.Position = UDim2.new(0, 5, 0, 93); List.BackgroundTransparency = 1; List.ScrollBarThickness = 5; List.ZIndex = 120; List.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UIListLayout", List).SortOrder = Enum.SortOrder.LayoutOrder

local Rows = {}
local function Add(n, d)
    local r = Instance.new("Frame", List); r.Size = UDim2.new(1, 0, 0, 28); r.BackgroundColor3 = COLORS.Row; r.BorderSizePixel = 0; r.ZIndex = 121
    local i = Instance.new("ImageLabel", r); i.Size = UDim2.new(0, 14, 0, 14); i.Position = UDim2.new(0, 8, 0.5, -7); i.BackgroundTransparency = 1; i.Image = "rbxassetid://164453777"; i.ImageColor3 = Color3.fromRGB(160,160,160); i.ZIndex = 122
    local l = Instance.new("TextLabel", r); l.Size = UDim2.new(1, -40, 1, 0); l.Position = UDim2.new(0, 32, 0, 0); l.BackgroundTransparency = 1; l.Text = ";" .. n .. " " .. (d or ""); l.TextColor3 = COLORS.TextWhite; l.Font = Enum.Font.SourceSans; l.TextSize = 13; l.TextXAlignment = Enum.TextXAlignment.Left; l.ZIndex = 122
    Rows[n] = r
end
for _, c in pairs({{"shackle", "<player>"}, {"s", "<player>"}, {"void", "<player>"}, {"v", "<player>"}, {"mute", "<player>"}, {"m", "<player>"}, {"cmds", ""}, {"badge", ""}}) do Add(c[1], c[2]) end

SB:GetPropertyChangedSignal("Text"):Connect(function()
    local q = SB.Text:lower()
    for n, r in pairs(Rows) do r.Visible = n:find(q) ~= nil end
end)

local dS, sP, dG; Header.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dG = true; dS = i.Position; sP = CmdWindow.Position; i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dG = false end end) end end)
UIS.InputChanged:Connect(function(i) if dG and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position - dS; CmdWindow.Position = UDim2.new(sP.X.Scale, sP.X.Offset + d.X, sP.Y.Scale, sP.Y.Offset + d.Y) end end)

-- PHYSICS ANCHOR DETECTOR
local function getAnchor()
    local t = L.Character and L.Character:FindFirstChildOfClass("Tool")
    if t then return t:FindFirstChild("Handle") or t:FindFirstChildWhichIsA("BasePart"), true end
    t = L.Backpack:FindFirstChildOfClass("Tool")
    if t then return t:FindFirstChild("Handle") or t:FindFirstChildWhichIsA("BasePart"), false end
    return nil, false
end

-- 3. MOTEUR ZERO-DRAG
L.Chatted:Connect(function(m)
    if not State.Active or m:sub(1,1) ~= ";" then return end
    local args = m:sub(2):split(" "); local cmd = args[1]:lower(); local t_name = args[2]; local t = nil
    if t_name then for _, p in pairs(Players:GetPlayers()) do if p.Name:lower():find(t_name:lower()) or p.DisplayName:lower():find(t_name:lower()) then t = p break end end end
    
    if (cmd == "shackle" or cmd == "s") and t then
        local a, isEquipped = getAnchor()
        if a and isEquipped then
            -- v22.0: Detach from hand to stop self-teleport
            for _, v in pairs(L.Character:GetDescendants()) do
                if v:IsA("Weld") or v:IsA("ManualWeld") or v:IsA("Motor6D") then
                    if v.Part0 == a or v.Part1 == a or v.Name:find("Grip") then v:Destroy() end
                end
            end
            
            task.spawn(function()
                local conn
                conn = RunService.RenderStepped:Connect(function()
                    if not (State.Active and t.Character and t.Character:FindFirstChild("HumanoidRootPart") and a.Parent) then conn:Disconnect() return end
                    pcall(function()
                        local targetPos = t.Character.HumanoidRootPart.CFrame
                        -- v22.0: Incrased Jitter for Hard Freeze
                        local jitter = Vector3.new(math.random(-1,1)*0.05, math.random(-1,1)*0.05, math.random(-1,1)*0.05)
                        a.CFrame = targetPos + jitter
                        a.AssemblyLinearVelocity = Vector3.zero
                        a.AssemblyAngularVelocity = Vector3.zero
                    end)
                end)
            end)
        elseif a and not isEquipped then
            StarterGui:SetCore("SendNotification", { Title = "AUTHORITY", Text = "Equip your tool to activate Zero-Drag Shackle!", Duration = 5 })
        else
            StarterGui:SetCore("SendNotification", { Title = "ERROR", Text = "No Tool/Caddie detected!", Duration = 3 })
        end
    elseif (cmd == "void" or cmd == "v") and t and t.Character then t.Character:Destroy()
    elseif (cmd == "mute" or cmd == "m") and t then State.Muted[t.UserId] = true
    elseif cmd == "cmds" then CmdWindow.Visible = not CmdWindow.Visible
    elseif cmd == "badge" then
        StarterGui:SetCore("SendNotification", { Title = "🔱 HD AUTHORITY", Text = "Identity Verified: Arcane Sovereign.", Duration = 4 })
    end
end)
HDButton.MouseButton1Click:Connect(function() CmdWindow.Visible = not CmdWindow.Visible end)
StarterGui:SetCore("SendNotification", { Title = "🔱 ZERO-DRAG", Text = "Sovereign v22.0 FE Pinner Deployed.", Duration = 4 })
_G.ArcaneCleanup = function() ScreenGui:Destroy(); State.Active = false end
