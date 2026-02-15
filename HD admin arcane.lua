--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║       HD ADMIN ARCANE (AUTHENTIC v1.0)              ║
    ║   "L'autorité n'est pas imitée, elle est clonée."         ║
    ╚═══════════════════════════════════════════════════════════╝
    
    Opération : Sovereign Prestige (v15.0) - TRUE 1:1 CLONE
    Fix : Authentic HD UI, Hierarchical Window, Command Triangle Icons
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

-- THEME CONSTANTS (1:1 HD)
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
ScreenGui.Name = "HDAdmin_Authentic_v15"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 100000
local p = (gethui and gethui()) or (pcall(function() return CoreGui end) and CoreGui) or L:WaitForChild("PlayerGui")
ScreenGui.Parent = p

-- CIRCULAR HD BUTTON (TOPBAR)
local HDButton = Instance.new("TextButton", ScreenGui)
HDButton.Name = "HDButton"
HDButton.Size = UDim2.new(0, 28, 0, 28)
HDButton.Position = UDim2.new(0, 110, 0, 2) -- Near the Roblox menu
HDButton.BackgroundColor3 = Color3.fromRGB(40, 40, 43)
HDButton.BorderSizePixel = 0
HDButton.Text = "HD"
HDButton.TextColor3 = Color3.new(1, 1, 1)
HDButton.Font = Enum.Font.GothamBold
HDButton.TextSize = 12
HDButton.ZIndex = 110
Instance.new("UICorner", HDButton).CornerRadius = UDim.new(1, 0)
local HDStroke = Instance.new("UIStroke", HDButton)
HDStroke.Color = Color3.fromRGB(100, 100, 100)
HDStroke.Thickness = 1

-- AUTHENTIC COMMAND BAR (TOP SLIDE)
local TopBar = Instance.new("Frame", ScreenGui)
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.Position = UDim2.new(0, 0, 0, -32) -- Hidden at start
TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 43)
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 500

local BarInput = Instance.new("TextBox", TopBar)
BarInput.Name = "Input"
BarInput.Size = UDim2.new(1, 0, 1, 0)
BarInput.BackgroundTransparency = 1
BarInput.TextColor3 = Color3.new(1, 1, 1)
BarInput.Font = Enum.Font.Gotham
BarInput.TextSize = 16
BarInput.PlaceholderText = "Click here or press ; to run a command"
BarInput.Text = ""
BarInput.ZIndex = 501

local function ToggleBar(s)
    if s then
        TopBar:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quart", 0.3, true)
        BarInput:CaptureFocus()
    else
        TopBar:TweenPosition(UDim2.new(0, 0, 0, -32), "In", "Quart", 0.3, true)
    end
end

-- AUTHENTIC COMMANDS WINDOW
local CmdWindow = Instance.new("Frame", ScreenGui)
CmdWindow.Name = "CommandsWindow"
CmdWindow.Size = UDim2.new(0, 305, 0, 380)
CmdWindow.Position = UDim2.new(0.5, -152, 0.5, -190)
CmdWindow.BackgroundColor3 = HD_THEME.Background
CmdWindow.Visible = false
CmdWindow.ZIndex = 1000
Instance.new("UICorner", CmdWindow).CornerRadius = UDim.new(0, 3)

-- DRAG HANDLE (Header)
local Header = Instance.new("Frame", CmdWindow)
Header.Size = UDim2.new(1, 0, 0, 28)
Header.BackgroundColor3 = HD_THEME.MainBlue
Header.ZIndex = 1001
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 3)

local HeaderTitle = Instance.new("TextLabel", Header)
HeaderTitle.Size = UDim2.new(1, 0, 1, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "COMMANDS"
HeaderTitle.TextColor3 = HD_THEME.TextWhite
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.TextSize = 12
HeaderTitle.ZIndex = 1002

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -28, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = HD_THEME.TextWhite
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.ZIndex = 1003
CloseBtn.MouseButton1Click:Connect(function() CmdWindow.Visible = false end)

local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -56, 0, 0)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "-"
MinBtn.TextColor3 = HD_THEME.TextWhite
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.ZIndex = 1003

-- SUB-HEADER
local SubHeader = Instance.new("Frame", CmdWindow)
SubHeader.Size = UDim2.new(1, 0, 0, 24)
SubHeader.Position = UDim2.new(0, 0, 0, 28)
SubHeader.BackgroundColor3 = HD_THEME.DarkBlue
SubHeader.ZIndex = 1001

local SubTitle = Instance.new("TextLabel", SubHeader)
SubTitle.Size = UDim2.new(1, 0, 1, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "<      COMMANDS      >"
SubTitle.TextColor3 = HD_THEME.TextWhite
SubTitle.Font = Enum.Font.GothamBold
SubTitle.TextSize = 12
SubTitle.ZIndex = 1002

-- SEARCH BAR
local SearchBox = Instance.new("TextBox", CmdWindow)
SearchBox.Size = UDim2.new(1, -8, 0, 24)
SearchBox.Position = UDim2.new(0, 4, 0, 56)
SearchBox.BackgroundColor3 = HD_THEME.SearchBg
SearchBox.TextColor3 = HD_THEME.TextWhite
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 12
SearchBox.PlaceholderText = "Search"
SearchBox.Text = ""
SearchBox.ZIndex = 1001
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 2)

local SearchIcon = Instance.new("ImageLabel", SearchBox)
SearchIcon.Size = UDim2.new(0, 16, 0, 16)
SearchIcon.Position = UDim2.new(0, 4, 0.5, -8)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Image = "rbxassetid://6031154871"
SearchIcon.ImageColor3 = HD_THEME.TextGray
SearchIcon.ZIndex = 1002
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.TextIndentPosition = Enum.TextIndentPosition.Left
-- Add padding to text to avoid overlap with icon
pcall(function() SearchBox.TextXAlignment = Enum.TextXAlignment.Left SearchBox.ClearTextOnFocus = true end)

-- COMMAND LIST
local List = Instance.new("ScrollingFrame", CmdWindow)
List.Size = UDim2.new(1, -8, 1, -88)
List.Position = UDim2.new(0, 4, 0, 84)
List.BackgroundTransparency = 1
List.ZIndex = 1001
List.ScrollBarThickness = 4
List.ScrollBarImageColor3 = HD_THEME.DarkBlue

local Layout = Instance.new("UIListLayout", List)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

local function CreateRow(n, d)
    local r = Instance.new("Frame", List)
    r.Size = UDim2.new(1, 0, 0, 26)
    r.BackgroundColor3 = HD_THEME.RowBg
    r.BorderSizePixel = 0
    
    local Icon = Instance.new("ImageLabel", r)
    Icon.Size = UDim2.new(0, 14, 0, 14)
    Icon.Position = UDim2.new(0, 6, 0.5, -7)
    Icon.BackgroundTransparency = 1
    Icon.Image = "rbxassetid://4370345144" -- Triangle icon
    Icon.ImageColor3 = HD_THEME.TextGray
    
    local Label = Instance.new("TextLabel", r)
    Label.Size = UDim2.new(1, -30, 1, 0)
    Label.Position = UDim2.new(0, 26, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = ";" .. n .. " " .. (d or "")
    Label.TextColor3 = HD_THEME.TextWhite
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Line = Instance.new("Frame", r)
    Line.Size = UDim2.new(1, 0, 0, 1)
    Line.Position = UDim2.new(0, 0, 1, -1)
    Line.BackgroundColor3 = Color3.fromRGB(30, 30, 33)
    Line.BorderSizePixel = 0
end

local CMDS = {
    {"shackle", "<player>"}, {"s", "<player>"}, {"unshackle", "<player>"},
    {"void", "<player>"}, {"v", "<player>"}, {"mute", "<player>"},
    {"m", "<player>"}, {"unmute", "<player>"}, {"cmds", ""}, {"badge", ""}
}
for _, c in pairs(CMDS) do CreateRow(c[1], c[2]) end

-- 3. MOTEUR
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

-- KEYBINDS & CLICKS
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.Semicolon then ToggleBar(true); task.wait(); BarInput.Text = "" end end)
BarInput.FocusLost:Connect(function(ep) if ep then execute(";" .. BarInput.Text); BarInput.Text = "" end ToggleBar(false) end)
HDButton.MouseButton1Click:Connect(function() CmdWindow.Visible = not CmdWindow.Visible end)

-- 4. ATOMIC CHAT HOOK
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
print("🔱 ARCANE: Restoration HD Admin 1:1 complétée.")
