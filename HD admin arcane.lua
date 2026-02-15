--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║       HD ADMIN ARCANE (TRUE REBIRTH v2.0)           ║
    ║   "L'autorité n'est pas imitée, elle est restaurée."      ║
    ╚═══════════════════════════════════════════════════════════╝
    
    Opération : Sovereign Prestige (v14.0) - TRUE HD REBIRTH
    Fix : 1:1 HD Admin UI, Atomic Chat Hook, Command Execution Fix
]]

-- 1. CONFIGURATION ET NETTOYAGE
local Players = game:GetService("Players")
local L = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local TCS = game:GetService("TextChatService")

local State = { Prefix = ";", Muted = {}, Active = true }
_G.ArcaneState = State

pcall(function() if _G.ArcaneCleanup then _G.ArcaneCleanup() end end)

-- 2. INTERFACE AUTHENTIQUE (HD ADMIN STYLE)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HDAdmin_Arcane_v14"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 100000

local function ParentUI()
    local p = (gethui and gethui()) or (pcall(function() return CoreGui end) and CoreGui) or L:WaitForChild("PlayerGui")
    ScreenGui.Parent = p
end
ParentUI()

-- THEME COLORS
local HD_COLORS = {
    Main = Color3.fromRGB(35, 35, 38),
    Accent = Color3.fromRGB(0, 162, 255),
    TopBar = Color3.fromRGB(28, 28, 30),
    Text = Color3.fromRGB(255, 255, 255)
}

-- TOPBAR (Style HD Admin)
local TopBar = Instance.new("Frame", ScreenGui)
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(0, 160, 0, 32)
TopBar.Position = UDim2.new(0.5, -80, 0, -32) -- Départ caché
TopBar.BackgroundColor3 = HD_COLORS.TopBar
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 500

local TB_Corner = Instance.new("UICorner", TopBar)
TB_Corner.CornerRadius = UDim.new(0, 6)

local TB_Logo = Instance.new("ImageButton", TopBar)
TB_Logo.Name = "Logo"
TB_Logo.Size = UDim2.new(0, 24, 0, 24)
TB_Logo.Position = UDim2.new(0, 5, 0.5, -12)
TB_Logo.BackgroundTransparency = 1
TB_Logo.Image = "rbxassetid://857927023"
TB_Logo.ZIndex = 501

local TB_Title = Instance.new("TextLabel", TopBar)
TB_Title.Name = "Title"
TB_Title.Size = UDim2.new(1, -40, 1, 0)
TB_Title.Position = UDim2.new(0, 35, 0, 0)
TB_Title.BackgroundTransparency = 1
TB_Title.Text = "HD ADMIN"
TB_Title.TextColor3 = HD_COLORS.Text
TB_Title.Font = Enum.Font.GothamBold
TB_Title.TextSize = 14
TB_Title.TextXAlignment = Enum.TextXAlignment.Left
TB_Title.ZIndex = 501

-- COMAND BAR (Style HD Admin)
local CmdBarFrame = Instance.new("Frame", ScreenGui)
CmdBarFrame.Name = "CmdBarFrame"
CmdBarFrame.Size = UDim2.new(1, 0, 0, 40)
CmdBarFrame.Position = UDim2.new(0, 0, 0, -50) -- Caché au top
CmdBarFrame.BackgroundColor3 = HD_COLORS.Main
CmdBarFrame.BorderSizePixel = 0
CmdBarFrame.ZIndex = 600

local BarInput = Instance.new("TextBox", CmdBarFrame)
BarInput.Name = "Input"
BarInput.Size = UDim2.new(0, 600, 0, 30)
BarInput.Position = UDim2.new(0.5, -300, 0.5, -15)
BarInput.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
BarInput.TextColor3 = HD_COLORS.Text
BarInput.Font = Enum.Font.Gotham
BarInput.TextSize = 16
BarInput.PlaceholderText = "Click here or press ';' to run a command"
BarInput.Text = ""
BarInput.ZIndex = 601
Instance.new("UICorner", BarInput).CornerRadius = UDim.new(0, 4)

-- ANIMATIONS
local function ToggleBar(state)
    if state then
        CmdBarFrame:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quart", 0.3, true)
        BarInput:CaptureFocus()
    else
        CmdBarFrame:TweenPosition(UDim2.new(0, 0, 0, -50), "In", "Quart", 0.3, true)
    end
end

TopBar:TweenPosition(UDim2.new(0.5, -80, 0, 5), "Out", "Back", 0.5, true)
TB_Logo.MouseButton1Click:Connect(function() ToggleBar(not (CmdBarFrame.Position.Y.Offset == 0)) end)

-- ACCÈS RAPIDE TOUCHE ";"
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Semicolon then
        ToggleBar(true)
        task.wait()
        BarInput.Text = "" -- Clean le ";" du textbox
    end
end)

-- 3. MOTEUR ARCANE (COMMANDES)
local function notify(title, msg)
    task.spawn(function()
        pcall(function() StarterGui:SetCore("SendNotification", { Title = title, Text = msg, Icon = "rbxassetid://857927023", Duration = 6 }) end)
    end)
end

local function execute(msg)
    if not State.Active or msg:sub(1,1) ~= State.Prefix then return end
    local content = msg:sub(2)
    local args = content:split(" ")
    local cmd = args[1]:lower()
    local target_name = args[2]
    local target = nil
    
    if target_name then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Name:lower():find(target_name:lower()) or p.DisplayName:lower():find(target_name:lower()) then target = p break end
        end
    end

    if cmd == "shackle" or cmd == "s" then
        if target then
            local anchor = nil
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name == "Handle" and pcall(function() return v:GetNetworkOwner() == L end) then anchor = v break end
            end
            if anchor then
                notify("STASIS", target.DisplayName .. " est maintenant en stase.")
                task.spawn(function()
                    while State.Active and target.Character and target.Parent do
                        pcall(function() anchor.CFrame = target.Character.HumanoidRootPart.CFrame; anchor.Velocity = Vector3.new(0,0,0) end)
                        RunService.Heartbeat:Wait()
                    end
                end)
            else notify("ERREUR", "Aucun objet tenu pour verrouiller !") end
        end
    elseif cmd == "mute" or cmd == "m" then
        if target then State.Muted[target.UserId] = true; notify("CENSURE", target.DisplayName .. " est réduit au silence.") end
    elseif cmd == "void" or cmd == "v" then
        if target and target.Character then target.Character:Destroy(); notify("VOID", target.DisplayName .. " a été purgé.") end
    elseif cmd == "unmute" then
        if target then State.Muted[target.UserId] = nil; notify("LIBERTÉ", target.DisplayName .. " peut reparler.") end
    end
end

L.Chatted:Connect(execute)
BarInput.FocusLost:Connect(function(ep)
    if ep then execute(";" .. BarInput.Text); BarInput.Text = "" end
    ToggleBar(false)
end)

-- 4. ATOMIC CHAT HOOK (FIX FINAL TEXTCHATSERVICE)
-- On utilise une variable globale pour le retour afin d'être sûr de ne JAMAIS échouer
_G.ArcaneProps = Instance.new("TextChatMessageProperties")
if TCS then
    pcall(function()
        TCS.OnIncomingMessage = function(m)
            pcall(function()
                if m.TextSource and State.Muted[m.TextSource.UserId] then
                    _G.ArcaneProps.Text = ""
                else
                    _G.ArcaneProps.Text = nil -- Reset
                end
            end)
            return _G.ArcaneProps -- Retourne l'objet INSTANTANÉMENT
        end
    end)
end

-- 5. SURVIE DE L'AUTORITÉ
_G.ArcaneCleanup = function() 
    State.Active = false
    pcall(function() ScreenGui:Destroy() end)
end

notify("ARCANE REBIRTH", "Moteur HD v14.0 initialisé.")
print("🔱 ARCANE: Restoration de l'autorité HD Admin accomplie.")
