--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║       HD ADMIN ARCANE (ALPHA VISION v1.2)            ║
    ║   "Si tu ne peux pas le voir, c'est que je n'existe pas." ║
    ╚═══════════════════════════════════════════════════════════╝
    
    Opération : Sovereign Prestige (v13.2) - SYNTAX RECOVERY
    Fix : Syntax Error (Missing End), Triple-Parent Injection
]]

print("🔱 ARCANE [v13.2]: Initialisation...")

-- ═══════════════════════════════════════════════════════════
--  1. NETTOYAGE TOTAL (ANTI-GHOST)
-- ═══════════════════════════════════════════════════════════
local Players = game:GetService("Players")
local L = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local function FinalReset()
    if _G.ArcaneCleanup then pcall(_G.ArcaneCleanup) end
    local names = {"Arcane", "Sovereign", "HDLogo", "CmdBar"}
    local targets = { (gethui and gethui()), CoreGui, L:FindFirstChild("PlayerGui") }
    for _, parent in pairs(targets) do
        if parent then
            for _, v in pairs(parent:GetChildren()) do
                for _, n in pairs(names) do 
                    if v.Name:find(n) then pcall(function() v:Destroy() end) end 
                end
            end
        end
    end
end
pcall(FinalReset)

-- ═══════════════════════════════════════════════════════════
--  2. MOTEUR & ÉTAT
-- ═══════════════════════════════════════════════════════════
local State = { Prefix = ";", Muted = {}, Active = true }
_G.ArcaneState = State
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TCS = game:GetService("TextChatService")

-- ═══════════════════════════════════════════════════════════
--  3. INTERFACE (ALPHA VISION)
-- ═══════════════════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Arcane_v13.2"; ScreenGui.ResetOnSpawn = false; ScreenGui.DisplayOrder = 100000 

local function InjectUI()
    local parent = (gethui and gethui()) or (pcall(function() return CoreGui end) and CoreGui) or L:WaitForChild("PlayerGui")
    ScreenGui.Parent = parent
end
InjectUI()

-- LOGO CHROME-FINISH
local Logo = Instance.new("ImageButton", ScreenGui)
Logo.Name = "HDLogo"; Logo.Size = UDim2.new(0, 50, 0, 50); Logo.Position = UDim2.new(0, 15, 0, 250)
Logo.BackgroundColor3 = Color3.fromRGB(45, 45, 48); Logo.BackgroundTransparency = 0.3; Logo.Image = "rbxassetid://857927023"; Logo.ZIndex = 200
Instance.new("UICorner", Logo).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", Logo).Color = Color3.fromRGB(255, 255, 255)

local Fallback = Instance.new("TextLabel", Logo)
Fallback.Size = UDim2.new(1, 0, 1, 0); Fallback.BackgroundTransparency = 1; Fallback.Text = "🔱"; Fallback.TextSize = 25; Fallback.TextColor3 = Color3.new(1, 1, 1); Fallback.ZIndex = 201

-- BAR
local Bar = Instance.new("TextBox", ScreenGui)
Bar.Name = "CmdBar"; Bar.Size = UDim2.new(0, 250, 0, 35); Bar.Position = UDim2.new(0, 75, 0, 258)
Bar.BackgroundColor3 = Color3.fromRGB(30, 30, 33); Bar.TextColor3 = Color3.new(1, 1, 1); Bar.Font = Enum.Font.GothamBold
Bar.PlaceholderText = "Commande (ex: ;s me)"; Bar.Visible = false; Bar.ZIndex = 202
Instance.new("UICorner", Bar).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", Bar).Color = Color3.fromRGB(74, 144, 226)

Logo.MouseButton1Click:Connect(function() Bar.Visible = not Bar.Visible if Bar.Visible then Bar:CaptureFocus() end end)

-- ═══════════════════════════════════════════════════════════
--  4. LOGIQUE
-- ═══════════════════════════════════════════════════════════
local function ntf(t, m) pcall(function() StarterGui:SetCore("SendNotification", { Title = t, Text = m, Icon = "rbxassetid://857927023", Duration = 6 }) end) end

local function execute(msg)
    if not State.Active or msg:sub(1,1) ~= State.Prefix then return false end
    local args = msg:sub(2):split(" ")
    local cmd = args[1]:lower()
    local target = nil
    for _, p in pairs(Players:GetPlayers()) do
        if args[2] and (p.Name:lower():find(args[2]:lower()) or p.DisplayName:lower():find(args[2]:lower())) then target = p break end
    end

    if (cmd == "shackle" or cmd == "s") and target then
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
        else ntf("ERREUR", "Sors un objet !") end
    elseif (cmd == "mute" or cmd == "m") and target then
        State.Muted[target.UserId] = true; ntf("SILENCE", target.DisplayName)
    elseif (cmd == "void" or cmd == "v") and target and target.Character then
        target.Character:Destroy(); ntf("VOID", target.DisplayName)
    end
    return true
end

L.Chatted:Connect(execute)
Bar.FocusLost:Connect(function(ep) if ep then execute(State.Prefix .. Bar.Text); Bar.Text = ""; Bar.Visible = false end end)

if TCS then
    pcall(function()
        TCS.OnIncomingMessage = function(m)
            local p = Instance.new("TextChatMessageProperties")
            if m.TextSource and State.Muted[m.TextSource.UserId] then p.Text = "" end
            return p
        end
    end)
end

_G.ArcaneCleanup = function() State.Active = false; ScreenGui:Destroy() end
ntf("ALPHA VISION", "Moteur v13.2 Déployé. trident 🔱 visible !")
print("🔱 ARCANE: Succès v13.2.")
