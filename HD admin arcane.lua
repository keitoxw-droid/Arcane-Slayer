--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║       HD ADMIN ARCANE (PIXEL PERFECT v3.0)          ║
    ║   "La perfection n'est pas un luxe, c'est une règle."    ║
    ╚═══════════════════════════════════════════════════════════╝
    
    Opération : Sovereign Prestige (v14.1) - PIXEL PERFECT
    Fix : 1:1 HD Admin UI, Commands Window, Search System, Atomic Hook
]]

-- 1. CONFIGURATION
local Players = game:GetService("Players")
local L = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local TCS = game:GetService("TextChatService")
local UIS = game:GetService("UserInputService")

local State = { Prefix = ";", Muted = {}, Active = true, Open = false }
_G.ArcaneState = State
pcall(function() if _G.ArcaneCleanup then _G.ArcaneCleanup() end end)

-- UI THEME (HD ADMIN 1:1)
local THEME = {
    Header = Color3.fromRGB(0, 107, 173),
    Background = Color3.fromRGB(35, 35, 35),
    Row = Color3.fromRGB(45, 45, 45),
    Search = Color3.fromRGB(20, 20, 20),
    Accent = Color3.fromRGB(0, 162, 255),
    Text = Color3.fromRGB(255, 255, 255)
}

-- 2. INTERFACE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HDAdmin_PixelPerfect_v14"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 100000
local p = (gethui and gethui()) or (pcall(function() return CoreGui end) and CoreGui) or L:WaitForChild("PlayerGui")
ScreenGui.Parent = p

-- TOPBAR HD
local TopBar = Instance.new("Frame", ScreenGui)
TopBar.Name = "TopBar"; TopBar.Size = UDim2.new(0, 160, 0, 32); TopBar.Position = UDim2.new(0.5, -80, 0, 5)
TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 30); TopBar.BorderSizePixel = 0; TopBar.ZIndex = 500
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 6)

local TB_Logo = Instance.new("ImageButton", TopBar)
TB_Logo.Size = UDim2.new(0, 26, 0, 26); TB_Logo.Position = UDim2.new(0, 4, 0.5, -13); TB_Logo.BackgroundTransparency = 1; TB_Logo.Image = "rbxassetid://857927023"; TB_Logo.ZIndex = 501

local TB_Title = Instance.new("TextLabel", TopBar)
TB_Title.Size = UDim2.new(1, -40, 1, 0); TB_Title.Position = UDim2.new(0, 36, 0, 0); TB_Title.BackgroundTransparency = 1; TB_Title.Text = "HD ADMIN"; TB_Title.TextColor3 = THEME.Text; TB_Title.Font = Enum.Font.GothamBold; TB_Title.TextSize = 14; TB_Title.TextXAlignment = Enum.TextXAlignment.Left; TB_Title.ZIndex = 501

-- CMD BAR (TOP REVEAL)
local CmdBarFrame = Instance.new("Frame", ScreenGui)
CmdBarFrame.Size = UDim2.new(1, 0, 0, 45); CmdBarFrame.Position = UDim2.new(0, 0, 0, -50); CmdBarFrame.BackgroundColor3 = THEME.Background; CmdBarFrame.ZIndex = 600

local BarInput = Instance.new("TextBox", CmdBarFrame)
BarInput.Size = UDim2.new(0, 650, 0, 32); BarInput.Position = UDim2.new(0.5, -325, 0.5, -16); BarInput.BackgroundColor3 = THEME.Search; BarInput.TextColor3 = THEME.Text; BarInput.Font = Enum.Font.Gotham; BarInput.TextSize = 16; BarInput.PlaceholderText = "Click here or press ';' to run a command"; BarInput.Text = ""; BarInput.ZIndex = 601
Instance.new("UICorner", BarInput).CornerRadius = UDim.new(0, 4)

local function ToggleBar(s)
    if s then CmdBarFrame:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quart", 0.3, true); BarInput:CaptureFocus()
    else CmdBarFrame:TweenPosition(UDim2.new(0, 0, 0, -50), "In", "Quart", 0.3, true) end
end

-- COMMANDS WINDOW (1:1 STYLE)
local CmdWindow = Instance.new("Frame", ScreenGui)
CmdWindow.Name = "CmdWindow"; CmdWindow.Size = UDim2.new(0, 300, 0, 400); CmdWindow.Position = UDim2.new(0.5, -150, 0.5, -200); CmdWindow.BackgroundColor3 = THEME.Background; CmdWindow.Visible = false; CmdWindow.ZIndex = 700
Instance.new("UICorner", CmdWindow).CornerRadius = UDim.new(0, 4)

local Header = Instance.new("Frame", CmdWindow)
Header.Size = UDim2.new(1, 0, 0, 30); Header.BackgroundColor3 = THEME.Header; Header.ZIndex = 701
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 4)
local HeaderFill = Instance.new("Frame", Header) -- Hide bottom corners
HeaderFill.Size = UDim2.new(1, 0, 0.5, 0); HeaderFill.Position = UDim2.new(0, 0, 0.5, 0); HeaderFill.BackgroundColor3 = THEME.Header; HeaderFill.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0); Title.BackgroundTransparency = 1; Title.Text = "COMMANDS"; Title.TextColor3 = THEME.Text; Title.Font = Enum.Font.GothamBold; Title.TextSize = 14; Title.ZIndex = 702

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -30, 0, 0); CloseBtn.BackgroundTransparency = 1; CloseBtn.Text = "X"; CloseBtn.TextColor3 = THEME.Text; CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 14; CloseBtn.ZIndex = 702
CloseBtn.MouseButton1Click:Connect(function() CmdWindow.Visible = false end)

local SearchBox = Instance.new("TextBox", CmdWindow)
SearchBox.Size = UDim2.new(1, -10, 0, 25); SearchBox.Position = UDim2.new(0, 5, 0, 35); SearchBox.BackgroundColor3 = THEME.Search; SearchBox.TextColor3 = THEME.Text; SearchBox.Font = Enum.Font.Gotham; SearchBox.TextSize = 14; SearchBox.PlaceholderText = "Search"; SearchBox.Text = ""; SearchBox.ZIndex = 701
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 2)

local List = Instance.new("ScrollingFrame", CmdWindow)
List.Size = UDim2.new(1, -10, 1, -75); List.Position = UDim2.new(0, 5, 0, 65); List.BackgroundTransparency = 1; List.ZIndex = 701; List.ScrollBarThickness = 4

local ListLayout = Instance.new("UIListLayout", List)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function AddCmd(n, d)
    local r = Instance.new("Frame", List)
    r.Size = UDim2.new(1, 0, 0, 25); r.BackgroundColor3 = THEME.Row; r.BorderSizePixel = 0
    local label = Instance.new("TextLabel", r)
    label.Size = UDim2.new(1, -10, 1, 0); label.Position = UDim2.new(0, 5, 0, 0); label.BackgroundTransparency = 1; label.Text = ";" .. n .. " " .. (d or ""); label.TextColor3 = Color3.fromRGB(200, 200, 200); label.Font = Enum.Font.Gotham; label.TextSize = 12; label.TextXAlignment = Enum.TextXAlignment.Left
end

-- DATA
local CMDS_LIST = {
    {"shackle", "<player>"}, {"s", "<player>"}, {"void", "<player>"}, {"v", "<player>"},
    {"mute", "<player>"}, {"m", "<player>"}, {"unmute", "<player>"}, {"cmds", ""}, 
    {"badge", ""}, {"help", ""}
}
for _, c in pairs(CMDS_LIST) do AddCmd(c[1], c[2]) end

-- 3. MOTEUR
local function notify(t, m) pcall(function() StarterGui:SetCore("SendNotification", { Title = t, Text = m, Icon = "rbxassetid://857927023", Duration = 6 }) end) end

local function execute(msg)
    if not State.Active or msg:sub(1,1) ~= State.Prefix then return end
    local args = msg:sub(2):split(" ")
    local cmd = args[1]:lower(); local t_name = args[2]; local t = nil
    if t_name then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Name:lower():find(t_name:lower()) or p.DisplayName:lower():find(t_name:lower()) then t = p break end
        end
    end

    if (cmd == "shackle" or cmd == "s") and t then
        local anchor = nil
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name == "Handle" and pcall(function() return v:GetNetworkOwner() == L end) then anchor = v break end
        end
        if anchor then
            notify("STASIS", t.DisplayName .. " est immobilisé.")
            task.spawn(function()
                while State.Active and t.Character and t.Parent do
                    pcall(function() anchor.CFrame = t.Character.HumanoidRootPart.CFrame; anchor.Velocity = Vector3.new(0,0,0) end)
                    RunService.Heartbeat:Wait()
                end
            end)
        else notify("ERREUR", "Sors un objet !") end
    elseif (cmd == "mute" or cmd == "m") and t then State.Muted[t.UserId] = true; notify("CENSURE", t.DisplayName)
    elseif (cmd == "void" or cmd == "v") and t and t.Character then t.Character:Destroy(); notify("VOID", t.DisplayName)
    elseif cmd == "cmds" then CmdWindow.Visible = true
    end
end

-- KEYBINDS
UIS.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.Semicolon then ToggleBar(true); task.wait(); BarInput.Text = "" end end)
BarInput.FocusLost:Connect(function(ep) if ep then execute(";" .. BarInput.Text); BarInput.Text = "" end ToggleBar(false) end)
TB_Logo.MouseButton1Click:Connect(function() ToggleBar(not (CmdBarFrame.Position.Y.Offset == 0)) end)

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
notify("ARCANE PIXEL PERFECT", "Autorité HD restaurée. Tape ;cmds")
print("🔱 ARCANE: Restoration Pixel Perfect accomplie.")
