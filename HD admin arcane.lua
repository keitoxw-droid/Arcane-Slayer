--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║       HD ADMIN ARCANE (MASTER RECONSTRUCTION v7.0)  ║
    ║   "L'autorité est totale, le détail est sacré."          ║
    ╚═══════════════════════════════════════════════════════════╝
    
    Opération : Sovereign Prestige (v17.0) - MASTER RECONSTRUCTION
    Fix : Official Triangles, Correct Hex, Draggable Header, Offset Logo
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
    Background = Color3.fromRGB(31, 31, 33), -- #1F1F21
    Row = Color3.fromRGB(43, 43, 46), -- #2B2B2E
    TextWhite = Color3.fromRGB(250, 250, 250),
    TextGray = Color3.fromRGB(180, 180, 180)
}

-- 2. INTERFACE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HDAdmin_Master_v17_0"; ScreenGui.ResetOnSpawn = false; ScreenGui.DisplayOrder = 100000
local p = (gethui and gethui()) or (pcall(function() return CoreGui end) and CoreGui) or L:WaitForChild("PlayerGui")
ScreenGui.Parent = p

-- BOUTON "HD" (PIXEL PERFECT - 32x32 - CORRECT OFFSET)
local HDButton = Instance.new("TextButton", ScreenGui)
HDButton.Name = "HDButton"
HDButton.Size = UDim2.new(0, 32, 0, 32)
HDButton.Position = UDim2.new(0, 160, 0, 4) -- Position safe pour éviter l'overlap du chat
HDButton.BackgroundColor3 = Color3.fromRGB(31, 31, 33)
HDButton.BorderSizePixel = 0
HDButton.Text = "HD"
HDButton.TextColor3 = Color3.new(1, 1, 1)
HDButton.Font = Enum.Font.GothamBold
HDButton.TextSize = 13
HDButton.ZIndex = 110
Instance.new("UICorner", HDButton).CornerRadius = UDim.new(1, 0)
local HDStroke = Instance.new("UIStroke", HDButton); HDStroke.Color = Color3.fromRGB(255, 255, 255); HDStroke.Transparency = 0.6; HDStroke.Thickness = 1

-- COMMANDS WINDOW (DRAGGABLE)
local CmdWindow = Instance.new("Frame", ScreenGui)
CmdWindow.Name = "CommandsWindow"
CmdWindow.Size = UDim2.new(0, 320, 0, 420)
CmdWindow.Position = UDim2.new(0.5, -160, 0.5, -210)
CmdWindow.BackgroundColor3 = THEME.Background
CmdWindow.Visible = false
CmdWindow.Active = true -- Important pour le drag
CmdWindow.ZIndex = 1000
Instance.new("UICorner", CmdWindow).CornerRadius = UDim.new(0, 4)

-- Main Header (Draggable part)
local Header = Instance.new("Frame", CmdWindow)
Header.Size = UDim2.new(1, 0, 0, 32)
Header.BackgroundColor3 = THEME.Header
Header.ZIndex = 1001
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 4)
local HeaderHideBottom = Instance.new("Frame", Header); HeaderHideBottom.Size = UDim2.new(1, 0, 0.5, 0); HeaderHideBottom.Position = UDim2.new(0, 0, 0.5, 0); HeaderHideBottom.BackgroundColor3 = THEME.Header; HeaderHideBottom.BorderSizePixel = 0 -- Cache l'arrondi du bas

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0); Title.BackgroundTransparency = 1; Title.Text = "COMMANDS"; Title.TextColor3 = THEME.TextWhite; Title.Font = Enum.Font.GothamBold; Title.TextSize = 13; Title.ZIndex = 1002

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 32, 0, 32); CloseBtn.Position = UDim2.new(1, -32, 0, 0); CloseBtn.BackgroundTransparency = 1; CloseBtn.Text = "X"; CloseBtn.TextColor3 = THEME.TextWhite; CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 14; CloseBtn.ZIndex = 1003
CloseBtn.MouseButton1Click:Connect(function() CmdWindow.Visible = false end)

-- Sub Header (The one with arrows)
local SubH = Instance.new("Frame", CmdWindow); SubH.Size = UDim2.new(1, 0, 0, 26); SubH.Position = UDim2.new(0, 0, 0, 32); SubH.BackgroundColor3 = THEME.SubHeader; SubH.ZIndex = 1001
local SubT = Instance.new("TextLabel", SubH); SubT.Size = UDim2.new(1, 0, 1, 0); SubT.BackgroundTransparency = 1; SubT.Text = "<      COMMANDS      >"; SubT.TextColor3 = THEME.TextWhite; SubT.Font = Enum.Font.GothamBold; SubT.TextSize = 11; SubT.ZIndex = 1002

-- Search Input
local Search = Instance.new("TextBox", CmdWindow); Search.Size = UDim2.new(1, -10, 0, 26); Search.Position = UDim2.new(0, 5, 0, 62); Search.BackgroundColor3 = Color3.fromRGB(20, 20, 22); Search.TextColor3 = THEME.TextWhite; Search.Font = Enum.Font.Gotham; Search.TextSize = 12; Search.PlaceholderText = "Search"; Search.Text = ""; Search.ZIndex = 1001
Instance.new("UICorner", Search).CornerRadius = UDim.new(0, 3)
local SIcon = Instance.new("ImageLabel", Search); SIcon.Size = UDim2.new(0, 16, 0, 16); SIcon.Position = UDim2.new(0, 6, 0.5, -8); SIcon.BackgroundTransparency = 1; SIcon.Image = "rbxassetid://6031154636"; SIcon.ImageColor3 = THEME.TextGray; SIcon.ZIndex = 1002

-- Commands List
local List = Instance.new("ScrollingFrame", CmdWindow); List.Size = UDim2.new(1, -10, 1, -100); List.Position = UDim2.new(0, 5, 0, 93); List.BackgroundTransparency = 1; List.ScrollBarThickness = 5; List.ZIndex = 1001; List.AutomaticCanvasSize = Enum.AutomaticSize.Y; List.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UIListLayout", List).SortOrder = Enum.SortOrder.LayoutOrder

local function Add(n, d)
    local r = Instance.new("Frame", List); r.Size = UDim2.new(1, 0, 0, 30); r.BackgroundColor3 = THEME.Row; r.BorderSizePixel = 0; r.ZIndex = 1002
    local i = Instance.new("ImageLabel", r); i.Size = UDim2.new(0, 16, 0, 16); i.Position = UDim2.new(0, 8, 0.5, -8); i.BackgroundTransparency = 1; i.Image = "rbxassetid://164453777"; i.ImageColor3 = THEME.TextGray; i.ZIndex = 1003 -- Triangle icon!
    local l = Instance.new("TextLabel", r); l.Size = UDim2.new(1, -40, 1, 0); l.Position = UDim2.new(0, 32, 0, 0); l.BackgroundTransparency = 1; l.Text = ";" .. n .. " " .. (d or ""); l.TextColor3 = THEME.TextWhite; l.Font = Enum.Font.Gotham; l.TextSize = 12; l.TextXAlignment = Enum.TextXAlignment.Left; l.ZIndex = 1003
    local b = Instance.new("Frame", r); b.Size = UDim2.new(1, 0, 0, 1); b.Position = UDim2.new(0, 0, 1, -1); b.BackgroundColor3 = Color3.fromRGB(20, 20, 22); b.BorderSizePixel = 0; b.ZIndex = 1003
end

local CMDS = {
    {"shackle", "<player>"}, {"s", "<player>"}, {"unshackle", "<player>"},
    {"void", "<player>"}, {"v", "<player>"}, {"mute", "<player>"},
    {"m", "<player>"}, {"unmute", "<player>"}, {"cmds", ""}, {"badge", ""}
}
for _, c in pairs(CMDS) do Add(c[1], c[2]) end

-- DRAG SCRIPT (ROBUST)
local dragStart, startPos, dragging; Header.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = CmdWindow.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
UIS.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragStart; CmdWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

-- 3. MOTEUR
local function execute(msg)
    if not State.Active or msg:sub(1,1) ~= State.Prefix then return end
    local args = msg:sub(2):split(" ")
    local cmd = args[1]:lower(); local t_name = args[2]; local t = nil
    if t_name then for _, p in pairs(Players:GetPlayers()) do if p.Name:lower():find(t_name:lower()) or p.DisplayName:lower():find(t_name:lower()) then t = p break end end end
    if (cmd == "shackle" or cmd == "s") and t then
        local anchor = nil; for _, v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") and v.Name == "Handle" and pcall(function() return v:GetNetworkOwner() == L end) then anchor = v break end end
        if anchor then task.spawn(function() while State.Active and t.Character and t.Parent do pcall(function() anchor.CFrame = t.Character.HumanoidRootPart.CFrame; anchor.Velocity = Vector3.new(0,0,0) end) RunService.Heartbeat:Wait() end end) end
    elseif (cmd == "mute" or cmd == "m") and t then State.Muted[t.UserId] = true
    elseif (cmd == "void" or cmd == "v") and t and t.Character then t.Character:Destroy()
    elseif cmd == "cmds" then CmdWindow.Visible = not CmdWindow.Visible end
end

L.Chatted:Connect(execute)
HDButton.MouseButton1Click:Connect(function() CmdWindow.Visible = not CmdWindow.Visible end)
StarterGui:SetCore("SendNotification", { Title = "🔱 ARCANE MASTERED", Text = "Sovereign v17.0 Master Reconstruction Loaded.", Duration = 4 })
_G.ArcaneCleanup = function() ScreenGui:Destroy(); State.Active = false end
print("🔱 ARCANE: Restoration Master v17.0 Chargée (Triangles + Drag Fix).")
