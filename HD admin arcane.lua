--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║       HD ADMIN ARCANE (DEFINITIVE v9.1)             ║
    ║   "La résurrection d'une autorité parfaite."             ║
    ╚═══════════════════════════════════════════════════════════╝
    
    Opération : Sovereign Prestige (v19.1) - DEFINITIVE RESTORATION
    Fix : UI Visibility, Stable Render Path, 1:1 Header, Y=4 Topbar
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
    Background = Color3.fromRGB(33, 33, 36), -- #1F1F21
    Row = Color3.fromRGB(43, 43, 46), -- #2B2B2E
    TextWhite = Color3.fromRGB(245, 245, 245),
    TextGray = Color3.fromRGB(180, 180, 180)
}

-- 2. INTERFACE (STABLE PATH)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HD_Restoration_v19_1"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 100000
-- On utilise PlayerGui en priorité si l'exécuteur bug sur CoreGui/Hui
local p = (gethui and gethui()) or L:WaitForChild("PlayerGui")
ScreenGui.Parent = p

-- BOUTON "HD" (Y=4 - STABLE & PROFESSIONNEL)
local HDButton = Instance.new("TextButton", ScreenGui)
HDButton.Name = "HDButton"
HDButton.Size = UDim2.new(0, 30, 0, 30)
HDButton.Position = UDim2.new(0, 150, 0, 4) -- Position parfaite Topbar
HDButton.BackgroundColor3 = Color3.fromRGB(33, 33, 36)
HDButton.BorderSizePixel = 0
HDButton.Text = "HD"
HDButton.TextColor3 = Color3.new(1, 1, 1)
HDButton.Font = Enum.Font.SourceSansBold
HDButton.TextSize = 13
HDButton.ZIndex = 500
Instance.new("UICorner", HDButton).CornerRadius = UDim.new(1, 0)
local HDStroke = Instance.new("UIStroke", HDButton); HDStroke.Color = Color3.new(1,1,1); HDStroke.Transparency = 0.6; HDStroke.Thickness = 1

-- COMMANDS WINDOW
local CmdWindow = Instance.new("Frame", ScreenGui)
CmdWindow.Name = "CmdWindow"
CmdWindow.Size = UDim2.new(0, 310, 0, 400)
CmdWindow.Position = UDim2.new(0.5, -155, 0.5, -200)
CmdWindow.BackgroundColor3 = COLORS.Background
CmdWindow.Visible = false
CmdWindow.Active = true
CmdWindow.ZIndex = 100
Instance.new("UICorner", CmdWindow).CornerRadius = UDim.new(0, 4)

-- MAIN HEADER (Surgery 1:1)
local Header = Instance.new("Frame", CmdWindow)
Header.Size = UDim2.new(1, 0, 0, 32); Header.BackgroundColor3 = COLORS.Header; Header.ZIndex = 110
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 4)
local Fill = Instance.new("Frame", Header); Fill.Size = UDim2.new(1, 0, 0.5, 0); Fill.Position = UDim2.new(0, 0, 0.5, 0); Fill.BackgroundColor3 = COLORS.Header; Fill.BorderSizePixel = 0

local LBtn = Instance.new("TextLabel", Header); LBtn.Size = UDim2.new(0, 32, 1, 0); LBtn.Position = UDim2.new(0, 2, 0, 0); LBtn.BackgroundTransparency = 1; LBtn.Text = "<"; LBtn.TextColor3 = COLORS.TextWhite; LBtn.Font = Enum.Font.SourceSansBold; LBtn.TextSize = 14; LBtn.ZIndex = 115
local MBtn = Instance.new("TextLabel", Header); MBtn.Size = UDim2.new(0, 32, 1, 0); MBtn.Position = UDim2.new(1, -64, 0, 0); MBtn.BackgroundTransparency = 1; MBtn.Text = "-"; MBtn.TextColor3 = COLORS.TextWhite; MBtn.Font = Enum.Font.SourceSansBold; MBtn.TextSize = 16; MBtn.ZIndex = 115
local XBtn = Instance.new("TextButton", Header); XBtn.Size = UDim2.new(0, 32, 1, 0); XBtn.Position = UDim2.new(1, -32, 0, 0); XBtn.BackgroundTransparency = 1; XBtn.Text = "X"; XBtn.TextColor3 = COLORS.TextWhite; XBtn.Font = Enum.Font.SourceSansBold; XBtn.TextSize = 14; XBtn.ZIndex = 115
XBtn.MouseButton1Click:Connect(function() CmdWindow.Visible = false end)
local Title = Instance.new("TextLabel", Header); Title.Size = UDim2.new(1, -100, 1, 0); Title.Position = UDim2.new(0, 50, 0, 0); Title.BackgroundTransparency = 1; Title.Text = "COMMANDS"; Title.TextColor3 = COLORS.TextWhite; Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 14; Title.ZIndex = 115

-- SUB HEADER
local SubHeader = Instance.new("Frame", CmdWindow)
SubHeader.Size = UDim2.new(1, 0, 0, 26); SubHeader.Position = UDim2.new(0, 0, 0, 32); SubHeader.BackgroundColor3 = COLORS.SubHeader; SubHeader.ZIndex = 120
local ST = Instance.new("TextLabel", SubHeader); ST.Size = UDim2.new(1, 0, 1, 0); ST.BackgroundTransparency = 1; ST.Text = "<      COMMANDS      >"; ST.TextColor3 = COLORS.TextWhite; ST.Font = Enum.Font.SourceSansBold; ST.TextSize = 11; ST.ZIndex = 121

-- CONTENT CONTAINER (Ensures visibility)
local Content = Instance.new("Frame", CmdWindow)
Content.Size = UDim2.new(1, 0, 1, -58); Content.Position = UDim2.new(0, 0, 0, 58); Content.BackgroundTransparency = 1; Content.ZIndex = 120

local Search = Instance.new("TextBox", Content); Search.Size = UDim2.new(1, -10, 0, 26); Search.Position = UDim2.new(0, 5, 0, 4); Search.BackgroundColor3 = Color3.fromRGB(24, 24, 26); Search.TextColor3 = COLORS.TextWhite; Search.Font = Enum.Font.SourceSans; Search.TextSize = 13; Search.PlaceholderText = "Search"; Search.Text = ""; Search.ZIndex = 125
Instance.new("UICorner", Search).CornerRadius = UDim.new(0, 3)
local SIcon = Instance.new("ImageLabel", Search); SIcon.Size = UDim2.new(0, 16, 0, 16); SIcon.Position = UDim2.new(0, 6, 0.5, -8); SIcon.BackgroundTransparency = 1; SIcon.Image = "rbxassetid://6031154636"; SIcon.ImageColor3 = COLORS.TextGray; SIcon.ZIndex = 126

local List = Instance.new("ScrollingFrame", Content); List.Size = UDim2.new(1, -10, 1, -40); List.Position = UDim2.new(0, 5, 0, 35); List.BackgroundTransparency = 1; List.ScrollBarThickness = 5; List.ZIndex = 125; List.AutomaticCanvasSize = Enum.AutomaticSize.Y; List.CanvasSize = UDim2.new(0,0,0,0)
Instance.new("UIListLayout", List).SortOrder = Enum.SortOrder.LayoutOrder

local function Add(n, d)
    local r = Instance.new("Frame", List); r.Size = UDim2.new(1, 0, 0, 28); r.BackgroundColor3 = COLORS.Row; r.BorderSizePixel = 0; r.ZIndex = 126
    local i = Instance.new("ImageLabel", r); i.Size = UDim2.new(0, 14, 0, 14); i.Position = UDim2.new(0, 8, 0.5, -7); i.BackgroundTransparency = 1; i.Image = "rbxassetid://164453777"; i.ImageColor3 = Color3.fromRGB(160,160,160); i.ZIndex = 127
    local l = Instance.new("TextLabel", r); l.Size = UDim2.new(1, -40, 1, 0); l.Position = UDim2.new(0, 32, 0, 0); l.BackgroundTransparency = 1; l.Text = ";" .. n .. " " .. (d or ""); l.TextColor3 = COLORS.TextWhite; l.Font = Enum.Font.SourceSans; l.TextSize = 13; l.TextXAlignment = Enum.TextXAlignment.Left; l.ZIndex = 127
end
for _, c in pairs({{"shackle", "<player>"}, {"s", "<player>"}, {"void", "<player>"}, {"v", "<player>"}, {"mute", "<player>"}, {"m", "<player>"}, {"cmds", ""}}) do Add(c[1], c[2]) end

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
StarterGui:SetCore("SendNotification", { Title = "🔱 ARCANE DEFINITIVE", Text = "Sovereign v19.1 Restoration complete.", Duration = 4 })
_G.ArcaneCleanup = function() ScreenGui:Destroy(); State.Active = false end
print("🔱 ARCANE: Restoration Definitive v19.1 Loaded (Visibility Fix).")
