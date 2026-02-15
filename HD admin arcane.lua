--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║       HD ADMIN ARCANE (SURGICIAL v9.0)              ║
    ║   "La précision est la courtoisie des rois."             ║
    ╚═══════════════════════════════════════════════════════════╝
    
    Opération : Sovereign Prestige (v19.0) - SURGICAL RECONSTRUCTION
    Fix : Content Visibility, Y=0 Alignment, Header Parity, 1:1 Assets
]]

-- 1. CONFIGURATION
local Players = game:GetService("Players")
local L = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TCS = game:GetService("TextChatService")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local State = { Prefix = ";", Muted = {}, Active = true }
_G.ArcaneState = State
pcall(function() if _G.ArcaneCleanup then _G.ArcaneCleanup() end end)

local COLORS = {
    Header = Color3.fromRGB(0, 107, 173), -- #006BAD
    SubHeader = Color3.fromRGB(0, 85, 135), -- #005587
    Background = Color3.fromRGB(33, 33, 36), -- #212124
    Row = Color3.fromRGB(43, 43, 45), -- #2B2B2D
    TextWhite = Color3.fromRGB(250, 250, 250),
    TextGray = Color3.fromRGB(180, 180, 180)
}

-- 2. INTERFACE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HDAdmin_Surgical_v19_0"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 100000
ScreenGui.IgnoreGuiInset = true -- Pour l'alignement Y=0 réel
local p = (gethui and gethui()) or (pcall(function() return CoreGui end) and CoreGui) or L:WaitForChild("PlayerGui")
ScreenGui.Parent = p

-- BOUTON "HD" (Y=0 FLUSH - POSITION PRECISION)
local HDButton = Instance.new("TextButton", ScreenGui)
HDButton.Name = "HDButton"
HDButton.Size = UDim2.new(0, 30, 0, 30)
HDButton.Position = UDim2.new(0, 140, 0, 0) -- Flush en haut à côté du chat
HDButton.BackgroundColor3 = Color3.fromRGB(33, 33, 36)
HDButton.BorderSizePixel = 0
HDButton.Text = "HD"
HDButton.TextColor3 = Color3.new(1, 1, 1)
HDButton.Font = Enum.Font.SourceSansBold
HDButton.TextSize = 13
HDButton.ZIndex = 200
Instance.new("UICorner", HDButton).CornerRadius = UDim.new(1, 0)
local HDStroke = Instance.new("UIStroke", HDButton); HDStroke.Color = Color3.fromRGB(255, 255, 255); HDStroke.Transparency = 0.6; HDStroke.Thickness = 1

-- COMMANDS WINDOW (Surgical Parity)
local CmdWindow = Instance.new("Frame", ScreenGui)
CmdWindow.Name = "CommandsWindow"
CmdWindow.Size = UDim2.new(0, 320, 0, 420)
CmdWindow.Position = UDim2.new(0.5, -160, 0.5, -210)
CmdWindow.BackgroundColor3 = COLORS.Background
CmdWindow.Visible = false
CmdWindow.Active = true 
CmdWindow.ZIndex = 1000
Instance.new("UICorner", CmdWindow).CornerRadius = UDim.new(0, 4)

-- MAIN HEADER (1:1 Layout)
local Header = Instance.new("Frame", CmdWindow)
Header.Size = UDim2.new(1, 0, 0, 32); Header.BackgroundColor3 = COLORS.Header; Header.ZIndex = 1100
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 4)
local Fill = Instance.new("Frame", Header); Fill.Size = UDim2.new(1, 0, 0.5, 0); Fill.Position = UDim2.new(0, 0, 0.5, 0); Fill.BackgroundColor3 = COLORS.Header; Fill.BorderSizePixel = 0

local LBtn = Instance.new("TextLabel", Header); LBtn.Size = UDim2.new(0, 32, 1, 0); LBtn.Position = UDim2.new(0, 5, 0, 0); LBtn.BackgroundTransparency = 1; LBtn.Text = "<"; LBtn.TextColor3 = COLORS.TextWhite; LBtn.Font = Enum.Font.SourceSansBold; LBtn.TextSize = 12; LBtn.ZIndex = 1101
local MBtn = Instance.new("TextLabel", Header); MBtn.Size = UDim2.new(0, 32, 1, 0); MBtn.Position = UDim2.new(1, -64, 0, 0); MBtn.BackgroundTransparency = 1; MBtn.Text = "-"; MBtn.TextColor3 = COLORS.TextWhite; MBtn.Font = Enum.Font.SourceSansBold; MBtn.TextSize = 16; MBtn.ZIndex = 1101
local XBtn = Instance.new("TextButton", Header); XBtn.Size = UDim2.new(0, 32, 1, 0); XBtn.Position = UDim2.new(1, -32, 0, 0); XBtn.BackgroundTransparency = 1; XBtn.Text = "X"; XBtn.TextColor3 = COLORS.TextWhite; XBtn.Font = Enum.Font.SourceSansBold; XBtn.TextSize = 13; XBtn.ZIndex = 1101
XBtn.MouseButton1Click:Connect(function() CmdWindow.Visible = false end)
local Title = Instance.new("TextLabel", Header); Title.Size = UDim2.new(1, -100, 1, 0); Title.Position = UDim2.new(0, 50, 0, 0); Title.BackgroundTransparency = 1; Title.Text = "COMMANDS"; Title.TextColor3 = COLORS.TextWhite; Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 14; Title.ZIndex = 1101

-- SUB HEADER (Navigation)
local SubH = Instance.new("Frame", CmdWindow); SubH.Size = UDim2.new(1, 0, 0, 26); SubH.Position = UDim2.new(0, 0, 0, 32); SubH.BackgroundColor3 = COLORS.SubHeader; SubH.ZIndex = 1005
local SL = Instance.new("TextLabel", SubH); SL.Size = UDim2.new(0, 26, 1, 0); SL.BackgroundTransparency = 1; SL.Text = "<"; SL.TextColor3 = COLORS.TextWhite; SL.Font = Enum.Font.SourceSansBold; SL.TextSize = 10; SL.ZIndex = 1100
local SR = Instance.new("TextLabel", SubH); SR.Size = UDim2.new(0, 26, 1, 0); SR.Position = UDim2.new(1, -26, 0, 0); SR.BackgroundTransparency = 1; SR.Text = ">"; SR.TextColor3 = COLORS.TextWhite; SR.Font = Enum.Font.SourceSansBold; SR.TextSize = 10; SR.ZIndex = 1100
local ST = Instance.new("TextLabel", SubH); ST.Size = UDim2.new(1, -60, 1, 0); ST.Position = UDim2.new(0, 30, 0, 0); ST.BackgroundTransparency = 1; ST.Text = "COMMANDS"; ST.TextColor3 = COLORS.TextWhite; ST.Font = Enum.Font.SourceSansBold; ST.TextSize = 11; ST.ZIndex = 1100

-- SEARCH BAR
local SearchBox = Instance.new("TextBox", CmdWindow); SearchBox.Size = UDim2.new(1, -10, 0, 26); SearchBox.Position = UDim2.new(0, 5, 0, 62); SearchBox.BackgroundColor3 = Color3.fromRGB(24, 24, 26); SearchBox.TextColor3 = COLORS.TextWhite; SearchBox.Font = Enum.Font.SourceSans; SearchBox.TextSize = 13; SearchBox.PlaceholderText = "Search"; SearchBox.Text = ""; SearchBox.ZIndex = 1005
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 3)
local SIcon = Instance.new("ImageLabel", SearchBox); SIcon.Size = UDim2.new(0, 16, 0, 16); SIcon.Position = UDim2.new(0, 6, 0.5, -8); SIcon.BackgroundTransparency = 1; SIcon.Image = "rbxassetid://6031154636"; SIcon.ImageColor3 = COLORS.TextGray; SIcon.ZIndex = 1006

-- SCROLLING LIST
local List = Instance.new("ScrollingFrame", CmdWindow); List.Size = UDim2.new(1, -10, 1, -100); List.Position = UDim2.new(0, 5, 0, 93); List.BackgroundTransparency = 1; List.ScrollBarThickness = 5; List.ZIndex = 1005; List.AutomaticCanvasSize = Enum.AutomaticSize.Y; List.CanvasSize = UDim2.new(0,0,0,0)
Instance.new("UIListLayout", List).SortOrder = Enum.SortOrder.LayoutOrder

local function Add(n, d)
    local r = Instance.new("Frame", List); r.Size = UDim2.new(1, 0, 0, 30); r.BackgroundColor3 = COLORS.Row; r.BorderSizePixel = 0; r.ZIndex = 1006
    local i = Instance.new("ImageLabel", r); i.Size = UDim2.new(0, 16, 0, 16); i.Position = UDim2.new(0, 8, 0.5, -8); i.BackgroundTransparency = 1; i.Image = "rbxassetid://164453777"; i.ImageColor3 = COLORS.TextGray; i.ZIndex = 1007
    local l = Instance.new("TextLabel", r); l.Size = UDim2.new(1, -40, 1, 0); l.Position = UDim2.new(0, 34, 0, 0); l.BackgroundTransparency = 1; l.Text = ";" .. n .. " " .. (d or ""); l.TextColor3 = COLORS.TextWhite; l.Font = Enum.Font.SourceSans; l.TextSize = 12; l.TextXAlignment = Enum.TextXAlignment.Left; l.ZIndex = 1007
    local b = Instance.new("Frame", r); b.Size = UDim2.new(1, 0, 0, 1); b.Position = UDim2.new(0, 0, 1, -1); b.BackgroundColor3 = Color3.fromRGB(24, 24, 26); b.BorderSizePixel = 0; b.ZIndex = 1007
end
for _, c in pairs({{"shackle", "<player>"}, {"s", "<player>"}, {"void", "<player>"}, {"v", "<player>"}, {"mute", "<player>"}, {"m", "<player>"}, {"cmds", ""}}) do Add(c[1], c[2]) end

-- DRAG SYSTEM (Locked to Header)
local dragStart, startPos, dragging; Header.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = CmdWindow.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
UIS.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart; CmdWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

-- 3. MOTEUR
local function execute(msg)
    if not State.Active or msg:sub(1,1) ~= State.Prefix then return end
    local args = msg:sub(2):split(" "); local cmd = args[1]:lower(); local t_name = args[2]; local t = nil
    if t_name then for _, p in pairs(Players:GetPlayers()) do if p.Name:lower():find(t_name:lower()) or p.DisplayName:lower():find(t_name:lower()) then t = p break end end end
    if (cmd == "shackle" or cmd == "s") and t then
        local a = nil; for _, v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") and v.Name == "Handle" and pcall(function() return v:GetNetworkOwner() == L end) then a = v break end end
        if a then task.spawn(function() while State.Active and t.Character and t.Parent do pcall(function() a.CFrame = t.Character.HumanoidRootPart.CFrame; a.Velocity = Vector3.new(0,0,0) end) RunService.Heartbeat:Wait() end end) end
    elseif (cmd == "mute" or cmd == "m") and t then State.Muted[t.UserId] = true
    elseif (cmd == "void" or cmd == "v") and t and t.Character then t.Character:Destroy()
    elseif cmd == "cmds" then CmdWindow.Visible = not CmdWindow.Visible end
end

L.Chatted:Connect(execute)
HDButton.MouseButton1Click:Connect(function() CmdWindow.Visible = not CmdWindow.Visible end)
StarterGui:SetCore("SendNotification", { Title = "🔱 ARCANE SURGICAL", Text = "Sovereign v19.0 Reconstruction Loaded.", Duration = 4 })
_G.ArcaneCleanup = function() ScreenGui:Destroy(); State.Active = false end
print("🔱 ARCANE: Surgical v19.0 (1:1 Reconstruction) chargée.")
