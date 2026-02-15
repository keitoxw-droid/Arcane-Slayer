--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║       HD ADMIN ARCANE (PROFESSIONAL v8.0)           ║
    ║   "L'excellence est le seul standard acceptable."        ║
    ╚═══════════════════════════════════════════════════════════╝
    
    Opération : Sovereign Prestige (v18.0) - PRO OVERHAUL
    Fix : SourceSans Typography, Y=0 Alignment, Refined Header, Play Icons
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

local THEME = {
    Header = Color3.fromRGB(0, 107, 173), -- #006BAD
    SubHeader = Color3.fromRGB(0, 85, 135), -- #005587
    Background = Color3.fromRGB(33, 33, 36), -- #1F1F21
    Row = Color3.fromRGB(43, 43, 46), -- #2B2B2E
    TextWhite = Color3.fromRGB(250, 250, 250),
    TextGray = Color3.fromRGB(180, 180, 180)
}

-- 2. INTERFACE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HDAdmin_Pro_v18_0"; ScreenGui.ResetOnSpawn = false; ScreenGui.DisplayOrder = 100000
local p = (gethui and gethui()) or (pcall(function() return CoreGui end) and CoreGui) or L:WaitForChild("PlayerGui")
ScreenGui.Parent = p

-- BOUTON "HD" (PROFESSIONAL - Y=0 / X=190)
local HDButton = Instance.new("TextButton", ScreenGui)
HDButton.Name = "HDButton"
HDButton.Size = UDim2.new(0, 32, 0, 32)
HDButton.Position = UDim2.new(0, 190, 0, 0) -- Flush at top, far right to avoid chat
HDButton.BackgroundColor3 = Color3.fromRGB(31, 31, 33)
HDButton.BorderSizePixel = 0
HDButton.Text = "HD"
HDButton.TextColor3 = Color3.new(1, 1, 1)
HDButton.Font = Enum.Font.SourceSansBold
HDButton.TextSize = 14
HDButton.ZIndex = 110
Instance.new("UICorner", HDButton).CornerRadius = UDim.new(1, 0)
local HDStroke = Instance.new("UIStroke", HDButton); HDStroke.Color = Color3.fromRGB(255, 255, 255); HDStroke.Transparency = 0.6; HDStroke.Thickness = 1

-- COMMANDS WINDOW
local CmdWindow = Instance.new("Frame", ScreenGui)
CmdWindow.Name = "CommandsWindow"
CmdWindow.Size = UDim2.new(0, 300, 0, 380)
CmdWindow.Position = UDim2.new(0.5, -150, 0.5, -190)
CmdWindow.BackgroundColor3 = THEME.Background
CmdWindow.Visible = false
CmdWindow.Active = true 
CmdWindow.ZIndex = 1000
Instance.new("UICorner", CmdWindow).CornerRadius = UDim.new(0, 4)

-- MAIN HEADER (PRO Layout)
local Header = Instance.new("Frame", CmdWindow)
Header.Size = UDim2.new(1, 0, 0, 30); Header.BackgroundColor3 = THEME.Header; Header.ZIndex = 1001
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 4)
local Fill = Instance.new("Frame", Header); Fill.Size = UDim2.new(1, 0, 0.5, 0); Fill.Position = UDim2.new(0, 0, 0.5, 0); Fill.BackgroundColor3 = THEME.Header; Fill.BorderSizePixel = 0

-- Header Buttons (Professional Glyphs)
local LBtn = Instance.new("TextButton", Header); LBtn.Size = UDim2.new(0, 30, 0, 30); LBtn.Position = UDim2.new(0, 2, 0, 0); LBtn.BackgroundTransparency = 1; LBtn.Text = "<"; LBtn.TextColor3 = THEME.TextWhite; LBtn.Font = Enum.Font.SourceSansBold; LBtn.TextSize = 14; LBtn.ZIndex = 1100
local MBtn = Instance.new("TextButton", Header); MBtn.Size = UDim2.new(0, 30, 0, 30); MBtn.Position = UDim2.new(1, -58, 0, 0); MBtn.BackgroundTransparency = 1; MBtn.Text = "-"; MBtn.TextColor3 = THEME.TextWhite; MBtn.Font = Enum.Font.SourceSansBold; MBtn.TextSize = 16; MBtn.ZIndex = 1100
local XBtn = Instance.new("TextButton", Header); XBtn.Size = UDim2.new(0, 30, 0, 30); XBtn.Position = UDim2.new(1, -30, 0, 0); XBtn.BackgroundTransparency = 1; XBtn.Text = "X"; XBtn.TextColor3 = THEME.TextWhite; XBtn.Font = Enum.Font.SourceSansBold; XBtn.TextSize = 14; XBtn.ZIndex = 1100
XBtn.MouseButton1Click:Connect(function() CmdWindow.Visible = false end)
local Title = Instance.new("TextLabel", Header); Title.Size = UDim2.new(1, -100, 1, 0); Title.Position = UDim2.new(0, 50, 0, 0); Title.BackgroundTransparency = 1; Title.Text = "COMMANDS"; Title.TextColor3 = THEME.TextWhite; Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 14

-- SUB HEADER (SourceSans Alignment)
local SubH = Instance.new("Frame", CmdWindow); SubH.Size = UDim2.new(1, 0, 0, 24); SubH.Position = UDim2.new(0, 0, 0, 30); SubH.BackgroundColor3 = THEME.SubHeader
local SL = Instance.new("TextLabel", SubH); SL.Size = UDim2.new(0, 24, 1, 0); SL.BackgroundTransparency = 1; SL.Text = "<"; SL.TextColor3 = THEME.TextWhite; SL.Font = Enum.Font.SourceSansBold; SL.TextSize = 12
local SR = Instance.new("TextLabel", SubH); SR.Size = UDim2.new(0, 24, 1, 0); SR.Position = UDim2.new(1, -24, 0, 0); SR.BackgroundTransparency = 1; SR.Text = ">"; SR.TextColor3 = THEME.TextWhite; SR.Font = Enum.Font.SourceSansBold; SR.TextSize = 12
local ST = Instance.new("TextLabel", SubH); ST.Size = UDim2.new(1, -50, 1, 0); ST.Position = UDim2.new(0, 25, 0, 0); ST.BackgroundTransparency = 1; ST.Text = "COMMANDS"; ST.TextColor3 = THEME.TextWhite; ST.Font = Enum.Font.SourceSansBold; ST.TextSize = 12

-- SEARCH & LIST
local Search = Instance.new("TextBox", CmdWindow); Search.Size = UDim2.new(1, -8, 0, 24); Search.Position = UDim2.new(0, 4, 0, 58); Search.BackgroundColor3 = Color3.fromRGB(24, 24, 26); Search.TextColor3 = THEME.TextWhite; Search.Font = Enum.Font.SourceSans; Search.TextSize = 13; Search.PlaceholderText = "Search"; Search.Text = ""
Instance.new("UICorner", Search).CornerRadius = UDim.new(0, 2)
local List = Instance.new("ScrollingFrame", CmdWindow); List.Size = UDim2.new(1, -8, 1, -95); List.Position = UDim2.new(0, 4, 0, 88); List.BackgroundTransparency = 1; List.ScrollBarThickness = 4; List.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UIListLayout", List).SortOrder = Enum.SortOrder.LayoutOrder

local function Add(n, d)
    local r = Instance.new("Frame", List); r.Size = UDim2.new(1, 0, 0, 28); r.BackgroundColor3 = THEME.Row; r.BorderSizePixel = 0
    local i = Instance.new("ImageLabel", r); i.Size = UDim2.new(0, 14, 0, 14); i.Position = UDim2.new(0, 8, 0.5, -7); i.BackgroundTransparency = 1; i.Image = "rbxassetid://164453777"; i.ImageColor3 = Color3.fromRGB(160, 160, 160) -- Play Icon
    local l = Instance.new("TextLabel", r); l.Size = UDim2.new(1, -40, 1, 0); l.Position = UDim2.new(0, 32, 0, 0); l.BackgroundTransparency = 1; l.Text = ";" .. n .. " " .. (d or ""); l.TextColor3 = THEME.TextWhite; l.Font = Enum.Font.SourceSans; l.TextSize = 13; l.TextXAlignment = Enum.TextXAlignment.Left
    local b = Instance.new("Frame", r); b.Size = UDim2.new(1, 0, 0, 1); b.Position = UDim2.new(0, 0, 1, -1); b.BackgroundColor3 = Color3.fromRGB(24, 24, 26); b.BorderSizePixel = 0
end
for _, c in pairs({{"shackle", "<player>"}, {"s", "<player>"}, {"void", "<player>"}, {"v", "<player>"}, {"mute", "<player>"}, {"m", "<player>"}, {"cmds", ""}, {"badge", ""}}) do Add(c[1], c[2]) end

-- DRAG
local dS, sP, dG; Header.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dG = true; dS = i.Position; sP = CmdWindow.Position; i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dG = false end end) end end)
UIS.InputChanged:Connect(function(i) if dG and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position - dS; CmdWindow.Position = UDim2.new(sP.X.Scale, sP.X.Offset + d.X, sP.Y.Scale, sP.Y.Offset + d.Y) end end)

-- MOTEUR
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
StarterGui:SetCore("SendNotification", { Title = "🔱 ARCANE PROFESSIONAL", Text = "Sovereign v18.0 Professional Overhaul Deployed.", Duration = 4 })
_G.ArcaneCleanup = function() ScreenGui:Destroy(); State.Active = false end
print("🔱 ARCANE: Professional Overhaul v18.0 Chargée (SourceSans + Y=0).")
