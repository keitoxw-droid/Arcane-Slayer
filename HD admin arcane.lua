--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║       HD ADMIN ARCANE (FIDELITY v10.0)              ║
    ║   "Chaque détail rapproche de la réalité."               ║
    ╚═══════════════════════════════════════════════════════════╝
    
    Opération : Sovereign Prestige (v20.0) - FIDELITY & FUNCTION
    Fix : Loupe Icon, Shadows, Active Search Filter, Pro Padding
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
    Background = Color3.fromRGB(33, 33, 36), -- #1F1F21
    Row = Color3.fromRGB(43, 43, 46), -- #2B2B2E
    TextWhite = Color3.fromRGB(245, 245, 245),
    TextGray = Color3.fromRGB(180, 180, 180),
    Border = Color3.fromRGB(20, 20, 22)
}

-- 2. INTERFACE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HD_Fidelity_v20_0"; ScreenGui.ResetOnSpawn = false; ScreenGui.DisplayOrder = 100000
local p = (gethui and gethui()) or L:WaitForChild("PlayerGui")
ScreenGui.Parent = p

-- BOUTON "HD" (Y=4 - PROFESSIONNEL)
local HDButton = Instance.new("TextButton", ScreenGui)
HDButton.Name = "HDButton"; HDButton.Size = UDim2.new(0, 30, 0, 30); HDButton.Position = UDim2.new(0, 150, 0, 4); HDButton.BackgroundColor3 = COLORS.Background; HDButton.BorderSizePixel = 0; HDButton.Text = "HD"; HDButton.TextColor3 = Color3.new(1, 1, 1); HDButton.Font = Enum.Font.SourceSansBold; HDButton.TextSize = 13; HDButton.ZIndex = 500
Instance.new("UICorner", HDButton).CornerRadius = UDim.new(1, 0)
local HDStroke = Instance.new("UIStroke", HDButton); HDStroke.Color = Color3.new(1,1,1); HDStroke.Transparency = 0.6; HDStroke.Thickness = 1

-- COMMANDS WINDOW (With Shadows/Borders)
local CmdWindow = Instance.new("Frame", ScreenGui)
CmdWindow.Name = "CmdWindow"; CmdWindow.Size = UDim2.new(0, 310, 0, 400); CmdWindow.Position = UDim2.new(0.5, -155, 0.5, -200); CmdWindow.BackgroundColor3 = COLORS.Background; CmdWindow.Visible = false; CmdWindow.Active = true; CmdWindow.ZIndex = 100
Instance.new("UICorner", CmdWindow).CornerRadius = UDim.new(0, 4)
local WindowStroke = Instance.new("UIStroke", CmdWindow); WindowStroke.Color = Color3.new(0,0,0); WindowStroke.Transparency = 0.5; WindowStroke.Thickness = 1.5 -- Effet d'ombre/bordure pro

-- HEADER
local Header = Instance.new("Frame", CmdWindow); Header.Size = UDim2.new(1, 0, 0, 30); Header.BackgroundColor3 = COLORS.Header; Header.ZIndex = 110
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 4)
local Fill = Instance.new("Frame", Header); Fill.Size = UDim2.new(1, 0, 0.5, 0); Fill.Position = UDim2.new(0, 0, 0.5, 0); Fill.BackgroundColor3 = COLORS.Header; Fill.BorderSizePixel = 0
local LBtn = Instance.new("TextLabel", Header); LBtn.Size = UDim2.new(0, 30, 1, 0); LBtn.Position = UDim2.new(0, 5, 0, 0); LBtn.BackgroundTransparency = 1; LBtn.Text = "<"; LBtn.TextColor3 = COLORS.TextWhite; LBtn.Font = Enum.Font.SourceSansBold; LBtn.TextSize = 12; LBtn.ZIndex = 111
local XBtn = Instance.new("TextButton", Header); XBtn.Size = UDim2.new(0, 30, 1, 0); XBtn.Position = UDim2.new(1, -30, 0, 0); XBtn.BackgroundTransparency = 1; XBtn.Text = "X"; XBtn.TextColor3 = COLORS.TextWhite; XBtn.Font = Enum.Font.SourceSansBold; XBtn.TextSize = 13; XBtn.ZIndex = 111
XBtn.MouseButton1Click:Connect(function() CmdWindow.Visible = false end)
local Title = Instance.new("TextLabel", Header); Title.Size = UDim2.new(1, -60, 1, 0); Title.Position = UDim2.new(0, 30, 0, 0); Title.BackgroundTransparency = 1; Title.Text = "COMMANDS"; Title.TextColor3 = COLORS.TextWhite; Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 14; Title.ZIndex = 111

-- SUB-HEADER
local SubH = Instance.new("Frame", CmdWindow); SubH.Size = UDim2.new(1, 0, 0, 24); SubH.Position = UDim2.new(0, 0, 0, 30); SubH.BackgroundColor3 = COLORS.SubHeader; SubH.ZIndex = 105
local ST = Instance.new("TextLabel", SubH); ST.Size = UDim2.new(1, 0, 1, 0); ST.BackgroundTransparency = 1; ST.Text = "<      COMMANDS      >"; ST.TextColor3 = COLORS.TextWhite; ST.Font = Enum.Font.SourceSansBold; ST.TextSize = 10; ST.ZIndex = 106

-- SEARCH BAR (With Loupe)
local SearchContainer = Instance.new("Frame", CmdWindow); SearchContainer.Size = UDim2.new(1, -10, 0, 24); SearchContainer.Position = UDim2.new(0, 5, 0, 58); SearchContainer.BackgroundColor3 = Color3.fromRGB(24, 24, 26); SearchContainer.ZIndex = 120
Instance.new("UICorner", SearchContainer).CornerRadius = UDim.new(0, 3)
local Loupe = Instance.new("ImageLabel", SearchContainer); Loupe.Size = UDim2.new(0, 16, 0, 16); Loupe.Position = UDim2.new(0, 4, 0.5, -8); Loupe.BackgroundTransparency = 1; Loupe.Image = "rbxassetid://6031154636"; Loupe.ImageColor3 = COLORS.TextGray; Loupe.ZIndex = 121
local SearchBox = Instance.new("TextBox", SearchContainer); SearchBox.Size = UDim2.new(1, -24, 1, 0); SearchBox.Position = UDim2.new(0, 24, 0, 0); SearchBox.BackgroundTransparency = 1; SearchBox.TextColor3 = COLORS.TextWhite; SearchBox.Font = Enum.Font.SourceSans; SearchBox.TextSize = 13; SearchBox.PlaceholderText = "Search"; SearchBox.Text = ""; SearchBox.TextXAlignment = Enum.TextXAlignment.Left; SearchBox.ZIndex = 121

-- LIST
local List = Instance.new("ScrollingFrame", CmdWindow); List.Size = UDim2.new(1, -10, 1, -95); List.Position = UDim2.new(0, 5, 0, 88); List.BackgroundTransparency = 1; List.ScrollBarThickness = 4; List.ZIndex = 120; List.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UIListLayout", List).SortOrder = Enum.SortOrder.LayoutOrder

local Rows = {}
local function Add(n, d)
    local r = Instance.new("Frame", List); r.Size = UDim2.new(1, 0, 0, 28); r.BackgroundColor3 = COLORS.Row; r.BorderSizePixel = 0; r.ZIndex = 121
    local i = Instance.new("ImageLabel", r); i.Size = UDim2.new(0, 14, 0, 14); i.Position = UDim2.new(0, 8, 0.5, -7); i.BackgroundTransparency = 1; i.Image = "rbxassetid://164453777"; i.ImageColor3 = Color3.fromRGB(160,160,160); i.ZIndex = 122 -- Play Icon
    local l = Instance.new("TextLabel", r); l.Size = UDim2.new(1, -40, 1, 0); l.Position = UDim2.new(0, 32, 0, 0); l.BackgroundTransparency = 1; l.Text = ";" .. n .. " " .. (d or ""); l.TextColor3 = COLORS.TextWhite; l.Font = Enum.Font.SourceSans; l.TextSize = 13; l.TextXAlignment = Enum.TextXAlignment.Left; l.ZIndex = 122
    Rows[n] = r
end
local CMDS = {{"shackle", "<player>"}, {"s", "<player>"}, {"void", "<player>"}, {"v", "<player>"}, {"mute", "<player>"}, {"m", "<player>"}, {"unmute", "<player>"}, {"cmds", ""}, {"badge", ""}}
for _, c in pairs(CMDS) do Add(c[1], c[2]) end

-- SEARCH FILTERING LOGIC
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local q = SearchBox.Text:lower()
    for n, r in pairs(Rows) do r.Visible = n:find(q) ~= nil end
end)

-- DRAG
local dS, sP, dG; Header.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dG = true; dS = i.Position; sP = CmdWindow.Position; i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dG = false end end) end end)
UIS.InputChanged:Connect(function(i) if dG and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position - dS; CmdWindow.Position = UDim2.new(sP.X.Scale, sP.X.Offset + d.X, sP.Y.Scale, sP.Y.Offset + d.Y) end end)

-- MOTEUR
L.Chatted:Connect(function(m)
    if not State.Active or m:sub(1,1) ~= ";" then return end
    local args = m:sub(2):split(" "); local cmd = args[1]:lower(); local t_name = args[2]; local t = nil
    if t_name then for _, p in pairs(Players:GetPlayers()) do if p.Name:lower():find(t_name:lower()) or p.DisplayName:lower():find(t_name:lower()) then t = p break end end end
    if (cmd == "shackle" or cmd == "s") and t then
        local a = nil; for _, v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") and v.Name == "Handle" and pcall(function() return v:GetNetworkOwner() == L end) then a = v break end end
        if a then task.spawn(function() while State.Active and t.Character and t.Parent do pcall(function() a.CFrame = t.Character.HumanoidRootPart.CFrame; a.Velocity = Vector3.new(0,0,0) end) RunService.Heartbeat:Wait() end end) end
    elseif (cmd == "void" or cmd == "v") and t and t.Character then t.Character:Destroy()
    elseif (cmd == "mute" or cmd == "m") and t then State.Muted[t.UserId] = true
    elseif cmd == "cmds" then CmdWindow.Visible = not CmdWindow.Visible end
end)
HDButton.MouseButton1Click:Connect(function() CmdWindow.Visible = not CmdWindow.Visible end)
StarterGui:SetCore("SendNotification", { Title = "🔱 ARCANE FIDELITY", Text = "Sovereign v20.0 Fidelity Update Loaded.", Duration = 4 })
_G.ArcaneCleanup = function() ScreenGui:Destroy(); State.Active = false end
print("🔱 ARCANE: Fidelity v20.0 (Search & Loupe) chargée.")
