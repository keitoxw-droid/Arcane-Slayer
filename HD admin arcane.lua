--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║       HD ADMIN ARCANE (SURGICAL CLONE v1.0)         ║
    ║   "L'autorité est une présence, pas une gêne."            ║
    ╚═══════════════════════════════════════════════════════════╝
    
    Opération : Sovereign Prestige (v15.1) - SURGICAL CLONE
    Fix : Minimalist UI, True Circular HD Button, Chat-Only Commands
]]

-- 1. CONFIGURATION
local Players = game:GetService("Players")
local L = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local TCS = game:GetService("TextChatService")
local UIS = game:GetService("UserInputService")

local State = { Prefix = ";", Muted = {}, Active = true }
_G.ArcaneState = State
pcall(function() if _G.ArcaneCleanup then _G.ArcaneCleanup() end end)

local HD_THEME = {
    MainBlue = Color3.fromRGB(0, 107, 173),
    DarkBlue = Color3.fromRGB(0, 85, 135),
    Background = Color3.fromRGB(35, 35, 38),
    SearchBg = Color3.fromRGB(20, 20, 20),
    RowBg = Color3.fromRGB(45, 45, 48),
    TextWhite = Color3.fromRGB(240, 240, 240),
    TextGray = Color3.fromRGB(180, 180, 180)
}

-- 2. INTERFACE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HDAdmin_Surgical_v15_1"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 100000
local p = (gethui and gethui()) or (pcall(function() return CoreGui end) and CoreGui) or L:WaitForChild("PlayerGui")
ScreenGui.Parent = p

-- BOUTON "HD" ROND (TAILLE ET POSITION 1:1)
local HDButton = Instance.new("TextButton", ScreenGui)
HDButton.Name = "HDButton"
HDButton.Size = UDim2.new(0, 30, 0, 30)
HDButton.Position = UDim2.new(0, 125, 0, 4) -- Alignement Topbar
HDButton.BackgroundColor3 = Color3.fromRGB(40, 40, 43)
HDButton.BorderSizePixel = 0
HDButton.Text = "HD"
HDButton.TextColor3 = Color3.new(1, 1, 1)
HDButton.Font = Enum.Font.GothamBold
HDButton.TextSize = 13
HDButton.ZIndex = 110
Instance.new("UICorner", HDButton).CornerRadius = UDim.new(1, 0)
local HDStroke = Instance.new("UIStroke", HDButton)
HDStroke.Color = Color3.fromRGB(100, 100, 100)
HDStroke.Thickness = 1

-- COMMANDS WINDOW
local CmdWindow = Instance.new("Frame", ScreenGui)
CmdWindow.Name = "CommandsWindow"
CmdWindow.Size = UDim2.new(0, 300, 0, 380)
CmdWindow.Position = UDim2.new(0.5, -150, 0.5, -190)
CmdWindow.BackgroundColor3 = HD_THEME.Background
CmdWindow.Visible = false
CmdWindow.ZIndex = 1000
Instance.new("UICorner", CmdWindow).CornerRadius = UDim.new(0, 4)

-- Header Principal
local Header = Instance.new("Frame", CmdWindow)
Header.Size = UDim2.new(1, 0, 0, 28)
Header.BackgroundColor3 = HD_THEME.MainBlue
Header.ZIndex = 1001
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 4)

local HeaderTitle = Instance.new("TextLabel", Header)
HeaderTitle.Size = UDim2.new(1, 0, 1, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "COMMANDS"
HeaderTitle.TextColor3 = HD_THEME.TextWhite
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.TextSize = 12

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -28, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = HD_THEME.TextWhite
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.MouseButton1Click:Connect(function() CmdWindow.Visible = false end)

local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -56, 0, 0)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "-"
MinBtn.TextColor3 = HD_THEME.TextWhite
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18

-- Sub Header
local SubH = Instance.new("Frame", CmdWindow)
SubH.Size = UDim2.new(1, 0, 0, 24)
SubH.Position = UDim2.new(0, 0, 0, 28)
SubH.BackgroundColor3 = HD_THEME.DarkBlue
SubH.ZIndex = 1001

local SubT = Instance.new("TextLabel", SubH)
SubT.Size = UDim2.new(1, 0, 1, 0)
SubT.BackgroundTransparency = 1
SubT.Text = "<      COMMANDS      >"
SubT.TextColor3 = HD_THEME.TextWhite
SubT.Font = Enum.Font.GothamBold
SubT.TextSize = 12

-- Search
local Search = Instance.new("TextBox", CmdWindow)
Search.Size = UDim2.new(1, -10, 0, 24)
Search.Position = UDim2.new(0, 5, 0, 56)
Search.BackgroundColor3 = HD_THEME.SearchBg
Search.TextColor3 = HD_THEME.TextWhite
Search.Font = Enum.Font.Gotham
Search.TextSize = 12
Search.PlaceholderText = "Search"
Search.Text = ""
Instance.new("UICorner", Search).CornerRadius = UDim.new(0, 2)

local SIcon = Instance.new("ImageLabel", Search)
SIcon.Size = UDim2.new(0, 16, 0, 16)
SIcon.Position = UDim2.new(0, 4, 0.5, -8)
SIcon.BackgroundTransparency = 1
SIcon.Image = "rbxassetid://6031154871"
SIcon.ImageColor3 = HD_THEME.TextGray

-- List
local List = Instance.new("ScrollingFrame", CmdWindow)
List.Size = UDim2.new(1, -10, 1, -90)
List.Position = UDim2.new(0, 5, 0, 85)
List.BackgroundTransparency = 1
List.ScrollBarThickness = 4
Instance.new("UIListLayout", List).SortOrder = Enum.SortOrder.LayoutOrder

local function AddCmd(n, d)
    local r = Instance.new("Frame", List)
    r.Size = UDim2.new(1, 0, 0, 26)
    r.BackgroundColor3 = HD_THEME.RowBg
    r.BorderSizePixel = 0
    
    local i = Instance.new("ImageLabel", r)
    i.Size = UDim2.new(0, 14, 0, 14)
    i.Position = UDim2.new(0, 6, 0.5, -7)
    i.BackgroundTransparency = 1
    i.Image = "rbxassetid://4370345144"
    i.ImageColor3 = HD_THEME.TextGray
    
    local l = Instance.new("TextLabel", r)
    l.Size = UDim2.new(1, -30, 1, 0)
    l.Position = UDim2.new(0, 26, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = ";" .. n .. " " .. (d or "")
    l.TextColor3 = HD_THEME.TextWhite
    l.Font = Enum.Font.Gotham
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    
    local li = Instance.new("Frame", r)
    li.Size = UDim2.new(1, 0, 0, 1)
    li.Position = UDim2.new(0, 0, 1, -1)
    li.BackgroundColor3 = Color3.fromRGB(30, 30, 33)
    li.BorderSizePixel = 0
end

local CMDS = {
    {"shackle", "<player>"}, {"s", "<player>"}, {"unshackle", "<player>"},
    {"void", "<player>"}, {"v", "<player>"}, {"mute", "<player>"},
    {"m", "<player>"}, {"unmute", "<player>"}, {"cmds", ""}, {"badge", ""}
}
for _, c in pairs(CMDS) do AddCmd(c[1], c[2]) end

-- 3. MOTEUR (CHAT ONLY)
local function execute(msg)
    if not State.Active or msg:sub(1,1) ~= State.Prefix then return end
    local args = msg:sub(2):split(" ")
    local cmd = args[1]:lower(); local t_name = args[2]; local t = nil
    if t_name then
        for _, p in pairs(Players:GetPlayers()) do if p.Name:lower():find(t_name:lower()) or p.DisplayName:lower():find(t_name:lower()) then t = p break end end
    end
    if (cmd == "shackle" or cmd == "s") and t then
        local anchor = nil
        for _, v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") and v.Name == "Handle" and pcall(function() return v:GetNetworkOwner() == L end) then anchor = v break end end
        if anchor then task.spawn(function() while State.Active and t.Character and t.Parent do pcall(function() anchor.CFrame = t.Character.HumanoidRootPart.CFrame; anchor.Velocity = Vector3.new(0,0,0) end) RunService.Heartbeat:Wait() end end) end
    elseif (cmd == "mute" or cmd == "m") and t then State.Muted[t.UserId] = true
    elseif (cmd == "void" or cmd == "v") and t and t.Character then t.Character:Destroy()
    elseif cmd == "cmds" then CmdWindow.Visible = true end
end

L.Chatted:Connect(execute)
HDButton.MouseButton1Click:Connect(function() CmdWindow.Visible = not CmdWindow.Visible end)

-- 4. CHAT HOOK ATOMIQUE
_G.ArcaneProps = Instance.new("TextChatMessageProperties")
if TCS then
    pcall(function()
        TCS.OnIncomingMessage = function(m)
            pcall(function() if m.TextSource and State.Muted[m.TextSource.UserId] then _G.ArcaneProps.Text = "" else _G.ArcaneProps.Text = nil end end)
            return _G.ArcaneProps
        end
    end)
end

_G.ArcaneCleanup = function() State.Active = false; ScreenGui:Destroy() end
print("🔱 ARCANE: Restoration Minimaliste HD 1:1 complétée.")
