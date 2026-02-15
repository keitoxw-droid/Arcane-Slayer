--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║       HD ADMIN ARCANE (PIXEL FINAL v5.0)            ║
    ║   "La perfection est une question de millimètres."        ║
    ╚═══════════════════════════════════════════════════════════╝
    
    Opération : Sovereign Prestige (v15.4) - PIXEL FINAL
    Fix : 44x44 Logo, True Alignment, Draggable, Clean List
]]

-- 1. CONFIGURATION
local Players = game:GetService("Players")
local L = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TCS = game:GetService("TextChatService")
local UIS = game:GetService("UserInputService")

local State = { Prefix = ";", Muted = {}, Active = true }
_G.ArcaneState = State
pcall(function() if _G.ArcaneCleanup then _G.ArcaneCleanup() end end)

local COLORS = {
    Header = Color3.fromRGB(0, 107, 173), -- #006BAD
    SubHeader = Color3.fromRGB(0, 85, 135), -- #005587
    Background = Color3.fromRGB(35, 35, 38),
    Row = Color3.fromRGB(45, 45, 48),
    Text = Color3.fromRGB(245, 245, 245)
}

-- 2. INTERFACE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HDAdmin_PixelFinal_v15_4"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 100000
local p = (gethui and gethui()) or (pcall(function() return CoreGui end) and CoreGui) or L:WaitForChild("PlayerGui")
ScreenGui.Parent = p

-- BOUTON "HD" (PIXEL PERFECT - 44x44)
local HDButton = Instance.new("TextButton", ScreenGui)
HDButton.Name = "HDButton"
HDButton.Size = UDim2.new(0, 44, 0, 44)
HDButton.Position = UDim2.new(0, 95, 0, 4) -- Aligné avec les icones roblox
HDButton.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
HDButton.BorderSizePixel = 0
HDButton.Text = "HD"
HDButton.TextColor3 = Color3.new(1, 1, 1)
HDButton.Font = Enum.Font.GothamBold
HDButton.TextSize = 16
HDButton.ZIndex = 110
Instance.new("UICorner", HDButton).CornerRadius = UDim.new(1, 0)
local HDStroke = Instance.new("UIStroke", HDButton)
HDStroke.Color = Color3.fromRGB(255, 255, 255)
HDStroke.Transparency = 0.5
HDStroke.Thickness = 1

-- COMMANDS WINDOW (DRAGGABLE & CLEAN)
local CmdWindow = Instance.new("Frame", ScreenGui)
CmdWindow.Name = "CommandsWindow"
CmdWindow.Size = UDim2.new(0, 310, 0, 350)
CmdWindow.Position = UDim2.new(0.5, -155, 0.5, -175)
CmdWindow.BackgroundColor3 = COLORS.Background
CmdWindow.Visible = false
CmdWindow.ZIndex = 1000
Instance.new("UICorner", CmdWindow).CornerRadius = UDim.new(0, 4)

-- Header Draggable
local Header = Instance.new("Frame", CmdWindow)
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = COLORS.Header
Header.ZIndex = 1001
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 4)
local HeaderFill = Instance.new("Frame", Header)
HeaderFill.Size = UDim2.new(1, 0, 0.5, 0); HeaderFill.Position = UDim2.new(0, 0, 0.5, 0); HeaderFill.BackgroundColor3 = COLORS.Header; HeaderFill.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0); Title.BackgroundTransparency = 1; Title.Text = "COMMANDS"; Title.TextColor3 = COLORS.Text; Title.Font = Enum.Font.GothamBold; Title.TextSize = 13; Title.ZIndex = 1002

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -30, 0, 0); CloseBtn.BackgroundTransparency = 1; CloseBtn.Text = "X"; CloseBtn.TextColor3 = COLORS.Text; CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 15; CloseBtn.ZIndex = 1003
CloseBtn.MouseButton1Click:Connect(function() CmdWindow.Visible = false end)

-- SubHeader
local SubH = Instance.new("Frame", CmdWindow); SubH.Size = UDim2.new(1, 0, 0, 24); SubH.Position = UDim2.new(0, 0, 0, 30); SubH.BackgroundColor3 = COLORS.SubHeader; SubH.ZIndex = 1001
local SubT = Instance.new("TextLabel", SubH); SubT.Size = UDim2.new(1, 0, 1, 0); SubT.BackgroundTransparency = 1; SubT.Text = "<      COMMANDS      >"; SubT.TextColor3 = COLORS.Text; SubT.Font = Enum.Font.GothamBold; SubT.TextSize = 11; SubT.ZIndex = 1002

-- List
local List = Instance.new("ScrollingFrame", CmdWindow)
List.Size = UDim2.new(1, -10, 1, -64)
List.Position = UDim2.new(0, 5, 0, 58)
List.BackgroundTransparency = 1
List.ScrollBarThickness = 5
List.ZIndex = 1001
List.AutomaticCanvasSize = Enum.AutomaticSize.Y
List.CanvasSize = UDim2.new(0, 0, 0, 0)
local Layout = Instance.new("UIListLayout", List); Layout.SortOrder = Enum.SortOrder.LayoutOrder

local function Add(n, d)
    local r = Instance.new("Frame", List); r.Size = UDim2.new(1, 0, 0, 26); r.BackgroundColor3 = COLORS.Row; r.BorderSizePixel = 0; r.ZIndex = 1002
    local i = Instance.new("ImageLabel", r); i.Size = UDim2.new(0, 14, 0, 14); i.Position = UDim2.new(0, 6, 0.5, -7); i.BackgroundTransparency = 1; i.Image = "rbxassetid://4370345144"; i.ZIndex = 1003
    local l = Instance.new("TextLabel", r); l.Size = UDim2.new(1, -30, 1, 0); l.Position = UDim2.new(0, 26, 0, 0); l.BackgroundTransparency = 1; l.Text = ";" .. n .. " " .. (d or ""); l.TextColor3 = COLORS.Text; l.Font = Enum.Font.Gotham; l.TextSize = 11; l.TextXAlignment = Enum.TextXAlignment.Left; l.ZIndex = 1003
    local b = Instance.new("Frame", r); b.Size = UDim2.new(1, 0, 0, 1); b.Position = UDim2.new(0, 0, 1, -1); b.BackgroundColor3 = Color3.fromRGB(30, 30, 33); b.BorderSizePixel = 0; b.ZIndex = 1003
end

local CMDS = {{"shackle", "<player>"}, {"s", "<player>"}, {"unshackle", "<player>"}, {"void", "<player>"}, {"v", "<player>"}, {"mute", "<player>"}, {"m", "<player>"}, {"unmute", "<player>"}, {"cmds", ""}}
for _, c in pairs(CMDS) do Add(c[1], c[2]) end

-- DRAG LOGIC
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = CmdWindow.Position; input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
Header.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UIS.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart; CmdWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)

-- 3. MOTEUR
local function execute(msg)
    if not State.Active or msg:sub(1,1) ~= State.Prefix then return end
    local args = msg:sub(2):split(" ")
    local cmd = args[1]:lower(); local t_name = args[2]; local t = nil
    if t_name then for _, p in pairs(Players:GetPlayers()) do if p.Name:lower():find(t_name:lower()) or p.DisplayName:lower():find(t_name:lower()) then t = p break end end end
    if (cmd == "shackle" or cmd == "s") and t then
        local anchor = nil
        for _, v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") and v.Name == "Handle" and pcall(function() return v:GetNetworkOwner() == L end) then anchor = v break end end
        if anchor then task.spawn(function() while State.Active and t.Character and t.Parent do pcall(function() anchor.CFrame = t.Character.HumanoidRootPart.CFrame; anchor.Velocity = Vector3.new(0,0,0) end) RunService.Heartbeat:Wait() end end) end
    elseif (cmd == "mute" or cmd == "m") and t then State.Muted[t.UserId] = true
    elseif (cmd == "void" or cmd == "v") and t and t.Character then t.Character:Destroy()
    elseif cmd == "cmds" then CmdWindow.Visible = not CmdWindow.Visible end
end

L.Chatted:Connect(execute)
HDButton.MouseButton1Click:Connect(function() CmdWindow.Visible = not CmdWindow.Visible end)

-- 4. CHAT HOOK ATOMIQUE
_G.ArcaneProps = Instance.new("TextChatMessageProperties")
if TCS then pcall(function() TCS.OnIncomingMessage = function(m) pcall(function() if m.TextSource and State.Muted[m.TextSource.UserId] then _G.ArcaneProps.Text = "" else _G.ArcaneProps.Text = nil end end) return _G.ArcaneProps end end) end

_G.ArcaneCleanup = function() State.Active = false; ScreenGui:Destroy() end
print("🔱 ARCANE: Pixel Final v15.4 chargé.")
