--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║       HD ADMIN ARCANE (ZERO-POINT ENGINE v1.0)        ║
    ║   "Même dans le chaos, l'ordre finit par triompher."      ║
    ╚═══════════════════════════════════════════════════════════╝
    
    Opération : Sovereign Prestige (v13.0) - NUCLEAR RESET
    Fix : Console Flood, Ghost Hooks, UI Invisibility
]]

-- ═══════════════════════════════════════════════════════════
--  1. RESET NUCLÉAIRE (ARRÊTE TOUTES LES ERREURS)
-- ═══════════════════════════════════════════════════════════
print("☢️ ARCANE [NUCLEAR]: Initialisation du Hard Reset...")

-- Désactive tous les anciens états globaux
_G.ArcaneActive = false
if _G.ArcaneState then _G.ArcaneState.Active = false end

-- Débloque le Chat Hook (Tue les erreurs [string])
local TCS = game:GetService("TextChatService")
if TCS then
    pcall(function()
        TCS.OnIncomingMessage = nil -- Supprime le hook buggé
    end)
    task.wait(0.2)
    pcall(function()
        local dummy = Instance.new("TextChatMessageProperties")
        TCS.OnIncomingMessage = function() return dummy end
    end)
    print("☢️ ARCANE [NUCLEAR]: Chat Hook nettoyé.")
end

-- Cleanup UI
local function ForceCleanup()
    local names = {"Arcane", "Sovereign", "HDLogo", "CmdBar"}
    local p = game:GetService("CoreGui"):FindFirstChildOfClass("ScreenGui") or game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    if p then
        for _, v in pairs(p:GetChildren()) do
            for _, n in pairs(names) do
                if v.Name:find(n) then pcall(function() v:Destroy() end) end
            end
        end
    end
end
pcall(ForceCleanup)

-- ═══════════════════════════════════════════════════════════
--  2. NOUVEAU MOTEUR v13.0 (ULTRA-SIMPLIFIÉ)
-- ═══════════════════════════════════════════════════════════
local Players = game:GetService("Players")
local L = Players.LocalPlayer
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local State = {
    Prefix = ";",
    Muted = {},
    Active = true
}

-- UI Container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Arcane_v13"; ScreenGui.ResetOnSpawn = false; ScreenGui.DisplayOrder = 99999
pcall(function() ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = L:WaitForChild("PlayerGui") end

-- Assets
local HD_LOGO = "rbxassetid://857927023"
local HD_COLORS = { Main = Color3.fromRGB(45, 45, 48), Blurple = Color3.fromRGB(74, 144, 226) }

-- Logo
local Logo = Instance.new("ImageButton", ScreenGui)
Logo.Name = "HDLogo"; Logo.Size = UDim2.new(0, 45, 0, 45); Logo.Position = UDim2.new(0, 50, 0, 5)
Logo.BackgroundTransparency = 1; Logo.Image = HD_LOGO; Logo.ZIndex = 110

-- Bar
local Bar = Instance.new("TextBox", ScreenGui)
Bar.Name = "CmdBar"; Bar.Size = UDim2.new(0, 250, 0, 30); Bar.Position = UDim2.new(0, 100, 0, 12)
Bar.BackgroundColor3 = HD_COLORS.Main; Bar.TextColor3 = Color3.new(1,1,1); Bar.Font = Enum.Font.GothamBold
Bar.PlaceholderText = "Commande..."; Bar.Visible = false; Bar.ZIndex = 111
Instance.new("UICorner", Bar).CornerRadius = UDim.new(0, 6)

Logo.MouseButton1Click:Connect(function()
    Bar.Visible = not Bar.Visible
    if Bar.Visible then Bar:CaptureFocus() end
end)

-- Logic
local function ntf(t, m) pcall(function() StarterGui:SetCore("SendNotification", { Title = t, Text = m, Icon = HD_LOGO }) end) end

local function execute(msg)
    if msg:sub(1,1) == State.Prefix then
        local args = msg:sub(2):split(" ")
        local cmd = args[1]:lower()
        local target = nil
        for _, p in pairs(Players:GetPlayers()) do
            if args[2] and (p.Name:lower():find(args[2]:lower()) or p.DisplayName:lower():find(args[2]:lower())) then target = p break end
        end

        if cmd == "shackle" or cmd == "s" then
            if target then
                local anchor = nil
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and v.Name == "Handle" and pcall(function() return v:GetNetworkOwner() == L end) then anchor = v break end
                end
                if anchor then
                    ntf("STASIS", target.DisplayName)
                    task.spawn(function()
                        while State.Active and target.Character do
                            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then anchor.CFrame = hrp.CFrame; anchor.Velocity = Vector3.new(0,0,0) end
                            RunService.Heartbeat:Wait()
                        end
                    end)
                else ntf("ERROR", "Sors un objet !") end
            end
        elseif cmd == "mute" or cmd == "m" then
            if target then State.Muted[target.UserId] = true; ntf("MUTE", target.DisplayName) end
        elseif cmd == "void" or cmd == "v" then
            if target and target.Character then target.Character:Destroy(); ntf("VOID", target.DisplayName) end
        elseif cmd == "badge" or cmd == "admin" then
            ntf("STAFF", "Activé")
            -- (Badge code simplifié ici pour la stabilité)
        end
        return true
    end
    return false
end

L.Chatted:Connect(execute)
Bar.FocusLost:Connect(function(ep) if ep then execute(State.Prefix .. Bar.Text); Bar.Text = ""; Bar.Visible = false end end)

-- Final Safe Hook
if TCS then
    pcall(function()
        local p = Instance.new("TextChatMessageProperties")
        TCS.OnIncomingMessage = function(m)
            if State.Muted[m.TextSource.UserId] then p.Text = "" else p.Text = m.Text end
            return p
        end
    end)
end

ntf("ARCANE v13", "Moteur de secours opérationnel. <3")
print("🔱 ARCANE [v13]: Hard Reset Success.")
