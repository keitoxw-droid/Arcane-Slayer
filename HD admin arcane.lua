--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║       HD ADMIN ARCANE (GOD MODE v1.0)               ║
    ║   "L'ordre absolu est la seule réponse au chaos."        ║
    ╚═══════════════════════════════════════════════════════════╝
    
    Opération : Sovereign Prestige (v13.3) - GOD MODE STABILITY
    Fix : Syntax Error (Final), Multi-Parent Injection, Anchor Logic
]]

-- 1. NETTOYAGE (ANTI-CONFLIT)
pcall(function() if _G.ArcaneCleanup then _G.ArcaneCleanup() end end)

-- 2. INTERFACE (PRIORITÉ ABSOLUE)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Arcane_v13.3"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 100000

local function InfallibleInject()
    local parent = (gethui and gethui()) or (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui")) or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Parent = parent
end
pcall(InfallibleInject)

-- LOGO TRIDENT (Blanc sur Noir pour visibilité)
local Logo = Instance.new("TextButton", ScreenGui)
Logo.Name = "HDLogo"
Logo.Size = UDim2.new(0, 55, 0, 55)
Logo.Position = UDim2.new(0, 15, 0, 300)
Logo.BackgroundColor3 = Color3.fromRGB(30, 30, 33)
Logo.BorderSizePixel = 2
Logo.Text = "🔱"
Logo.TextSize = 35
Logo.TextColor3 = Color3.new(1, 1, 1)
Logo.ZIndex = 200
Instance.new("UICorner", Logo).CornerRadius = UDim.new(1, 0)
local StrokeLogo = Instance.new("UIStroke", Logo)
StrokeLogo.Color = Color3.new(1, 1, 1)
StrokeLogo.Thickness = 2

-- BARRE
local Bar = Instance.new("TextBox", ScreenGui)
Bar.Name = "CmdBar"
Bar.Size = UDim2.new(0, 250, 0, 40)
Bar.Position = UDim2.new(0, 80, 0, 308)
Bar.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
Bar.TextColor3 = Color3.new(1, 1, 1)
Bar.Font = Enum.Font.GothamBold
Bar.PlaceholderText = "Tapes une commande..."
Bar.Visible = false
Bar.ZIndex = 202
Instance.new("UICorner", Bar).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Bar).Color = Color3.fromRGB(74, 144, 226)

Logo.MouseButton1Click:Connect(function()
    Bar.Visible = not Bar.Visible
    if Bar.Visible then Bar:CaptureFocus() end
end)

-- 3. MOTEUR DE COMMANDES (SÉCURISÉ)
local State = { Prefix = ";", Muted = {}, Active = true }
_G.ArcaneState = State
local Players = game:GetService("Players")
local L = Players.LocalPlayer
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local function execute(msg)
    if not State.Active or msg:sub(1,1) ~= State.Prefix then return end
    local content = msg:sub(2)
    local args = content:split(" ")
    local cmd = args[1]:lower()
    local target_name = args[2]
    local target = nil
    
    if target_name then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Name:lower():find(target_name:lower()) or p.DisplayName:lower():find(target_name:lower()) then
                target = p
                break
            end
        end
    end

    if cmd == "shackle" or cmd == "s" then
        if target then
            local anchor = nil
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name == "Handle" and pcall(function() return v:GetNetworkOwner() == L end) then
                    anchor = v
                    break
                end
            end
            if anchor then
                task.spawn(function()
                    while State.Active and target.Character and target.Parent do
                        pcall(function()
                            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                anchor.CFrame = hrp.CFrame
                                anchor.Velocity = Vector3.new(0,0,0)
                            end
                        end)
                        RunService.Heartbeat:Wait()
                    end
                end)
            end
        end
    elseif cmd == "mute" or cmd == "m" then
        if target then State.Muted[target.UserId] = true end
    elseif cmd == "void" or cmd == "v" then
        if target and target.Character then target.Character:Destroy() end
    end
end

L.Chatted:Connect(execute)
Bar.FocusLost:Connect(function(ep)
    if ep then
        execute(";" .. Bar.Text)
        Bar.Text = ""
        Bar.Visible = false
    end
end)

-- 4. CHAT HOOK (STABILITÉ ALPHA)
pcall(function()
    game:GetService("TextChatService").OnIncomingMessage = function(m)
        local props = Instance.new("TextChatMessageProperties")
        if m.TextSource and State.Muted[m.TextSource.UserId] then
            props.Text = ""
        end
        return props
    end
end)

_G.ArcaneCleanup = function() 
    State.Active = false
    pcall(function() ScreenGui:Destroy() end)
end

pcall(function() StarterGui:SetCore("SendNotification", { Title = "ARCANE v13.3", Text = "God Mode Activé. Trident visible !", Icon = "rbxassetid://857927023" }) end)
print("🔱 ARCANE: Moteur v13.3 chargé avec succès.")
