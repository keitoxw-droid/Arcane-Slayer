--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║       HD ADMIN ARCANE (ABSOLUTE STABILITY v1.0)      ║
    ║   "Une autorité qui ne vacille jamais."                  ║
    ╚═══════════════════════════════════════════════════════════╝
    
    Opération : Sovereign Prestige (v13.4) - ABSOLUTE STABILITY
    Fix : Chat Hook Double-Buffer, Eternal UI Persistence
]]

-- 1. SERVICES
local Players = game:GetService("Players")
local L = Players.LocalPlayer
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TCS = game:GetService("TextChatService")

-- 2. ÉTAT & CLEANUP
local State = { Prefix = ";", Muted = {}, Active = true }
_G.ArcaneState = State

pcall(function() if _G.ArcaneCleanup then _G.ArcaneCleanup() end end)

-- 3. INTERFACE (ÉTERNELLE)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Arcane_Eternal"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 100000

local function InfallibleInject()
    local parent = (gethui and gethui()) or (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui")) or L:WaitForChild("PlayerGui")
    ScreenGui.Parent = parent
end

-- LOGO TRIDENT (Haute visibilité)
local Logo = Instance.new("TextButton", ScreenGui)
Logo.Name = "HDLogo"; Logo.Size = UDim2.new(0, 60, 0, 60); Logo.Position = UDim2.new(0, 20, 0, 350)
Logo.BackgroundColor3 = Color3.fromRGB(25, 25, 28); Logo.Text = "🔱"; Logo.TextSize = 40; Logo.TextColor3 = Color3.new(1, 1, 1); Logo.ZIndex = 200
Instance.new("UICorner", Logo).CornerRadius = UDim.new(1, 0)
local Stroke = Instance.new("UIStroke", Logo); Stroke.Color = Color3.new(1, 1, 1); Stroke.Thickness = 2

-- BARRE
local Bar = Instance.new("TextBox", ScreenGui)
Bar.Name = "CmdBar"; Bar.Size = UDim2.new(0, 260, 0, 45); Bar.Position = UDim2.new(0, 90, 0, 358)
Bar.BackgroundColor3 = Color3.fromRGB(15, 15, 18); Bar.TextColor3 = Color3.new(1, 1, 1); Bar.Font = Enum.Font.GothamBold
Bar.PlaceholderText = "Commande Arcane..."; Bar.Visible = false; Bar.ZIndex = 202
Instance.new("UICorner", Bar).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Bar).Color = Color3.fromRGB(74, 144, 226); Instance.new("UIStroke", Bar).Thickness = 2

Logo.MouseButton1Click:Connect(function() Bar.Visible = not Bar.Visible if Bar.Visible then Bar:CaptureFocus() end end)

-- Boucle de Persistance (Récupère l'UI si elle disparaît)
task.spawn(function()
    while State.Active do
        if not ScreenGui.Parent or not Logo.Visible then
            pcall(InfallibleInject)
            Logo.Visible = true
        end
        task.wait(2)
    end
end)

-- 4. COMMANDES
local function execute(msg)
    if not State.Active or msg:sub(1,1) ~= State.Prefix then return end
    local args = msg:sub(2):split(" ")
    local cmd = args[1]:lower(); local target_name = args[2]; local target = nil
    if target_name then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Name:lower():find(target_name:lower()) or p.DisplayName:lower():find(target_name:lower()) then target = p break end
        end
    end

    if (cmd == "shackle" or cmd == "s") and target then
        local anchor = nil
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name == "Handle" and pcall(function() return v:GetNetworkOwner() == L end) then anchor = v break end
        end
        if anchor then
            task.spawn(function()
                while State.Active and target.Character and target.Parent do
                    pcall(function() anchor.CFrame = target.Character.HumanoidRootPart.CFrame; anchor.Velocity = Vector3.new(0,0,0) end)
                    RunService.Heartbeat:Wait()
                end
            end)
        end
    elseif (cmd == "mute" or cmd == "m") and target then State.Muted[target.UserId] = true
    elseif (cmd == "void" or cmd == "v") and target and target.Character then target.Character:Destroy()
    end
end

L.Chatted:Connect(execute)
Bar.FocusLost:Connect(function(ep) if ep then execute(State.Prefix .. Bar.Text); Bar.Text = ""; Bar.Visible = false end end)

-- 5. CHAT HOOK DOUBLE-BUFFER (ANTI-CRASH)
if TCS then
    pcall(function()
        TCS.OnIncomingMessage = function(msg)
            local success, props = pcall(function()
                local p = Instance.new("TextChatMessageProperties")
                if msg and msg.TextSource and State.Muted[msg.TextSource.UserId] then
                    p.Text = ""
                end
                return p
            end)
            if success and props then return props end
            return Instance.new("TextChatMessageProperties") -- Fallback de sécurité
        end
    end)
end

_G.ArcaneCleanup = function() State.Active = false; ScreenGui:Destroy() end
pcall(function() StarterGui:SetCore("SendNotification", { Title = "ARCANE v13.4", Text = "Protocol Eternal Actif.", Icon = "rbxassetid://857927023" }) end)
print("🔱 ARCANE: Moteur v13.4 (ABSOLUTE) chargé.")
