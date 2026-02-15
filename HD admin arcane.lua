--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║       HD ADMIN ARCANE (MIMETIC SOVEREIGN v1.5)        ║
    ║   "L'autorité est un vêtement que nous tissons en code."  ║
    ╚═══════════════════════════════════════════════════════════╝
    
    Opération : Sovereign Prestige (v12.9) - NUCLEAR RECOVERY
    Fix : Atomic Chat Hook, Safe-Container UI, Desktop Deployment
]]

-- ═══════════════════════════════════════════════════════════
--  1. ATOMIC CHAT FIX (DÉBLOQUE LE JEU)
-- ═══════════════════════════════════════════════════════════
local TCS = game:GetService("TextChatService")
local FALLBACK_PROPS = Instance.new("TextChatMessageProperties")

if TCS then
    pcall(function()
        TCS.OnIncomingMessage = function()
            return FALLBACK_PROPS
        end
    end)
    print("🔱 ARCANE [NUCLEAR]: Chat Engine débloqué.")
end

-- ═══════════════════════════════════════════════════════════
--  2. NETTOYAGE & SERVICES
-- ═══════════════════════════════════════════════════════════
local Players = game:GetService("Players")
local L = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local function NuclearCleanup()
    if _G.ArcaneCleanup then pcall(_G.ArcaneCleanup) end
    local names = {"Arcane", "Sovereign"}
    local containers = {
        (gethui and gethui()),
        CoreGui,
        L:FindFirstChild("PlayerGui")
    }
    for _, parent in pairs(containers) do
        if parent then
            for _, v in pairs(parent:GetChildren()) do
                for _, n in pairs(names) do
                    if v.Name:find(n) then pcall(function() v:Destroy() end) end
                end
            end
        end
    end
end
pcall(NuclearCleanup)

-- ═══════════════════════════════════════════════════════════
--  3. ÉTAT & ASSETS
-- ═══════════════════════════════════════════════════════════
local State = { Prefix = ";", Shackled = {}, Voided = {}, Muted = {}, Commands = {}, Connections = {}, Active = true }
_G.ArcaneState = State

local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local HD_LOGO = "rbxassetid://857927023"
local HD_FONT = Enum.Font.GothamBold
local HD_COLORS = { Main = Color3.fromRGB(45, 45, 48), Blurple = Color3.fromRGB(74, 144, 226), White = Color3.fromRGB(255, 255, 255) }

-- ═══════════════════════════════════════════════════════════
--  4. INTERFACE (UI) SAFE-CONTAINER
-- ═══════════════════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArcaneSovereign_v12.9"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 10000

local UI_PARENT = (gethui and gethui()) or (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui")) or L:WaitForChild("PlayerGui")
ScreenGui.Parent = UI_PARENT

print("✅ ARCANE [NUCLEAR]: UI injectée dans " .. (UI_PARENT and UI_PARENT.Name or "Unknown"))

local LogoBtn = Instance.new("ImageButton", ScreenGui)
LogoBtn.Name = "HDLogo"; LogoBtn.Size = UDim2.new(0, 45, 0, 45)
LogoBtn.Position = UDim2.new(0, 50, 0, 5); LogoBtn.BackgroundTransparency = 1
LogoBtn.Image = HD_LOGO; LogoBtn.ZIndex = 110

local CmdBar = Instance.new("TextBox", ScreenGui)
CmdBar.Name = "CmdBar"; CmdBar.Size = UDim2.new(0, 250, 0, 30)
CmdBar.Position = UDim2.new(0, 100, 0, 12); CmdBar.BackgroundColor3 = HD_COLORS.Main
CmdBar.TextColor3 = HD_COLORS.White; CmdBar.Font = HD_FONT; CmdBar.TextSize = 14
CmdBar.PlaceholderText = "Command Bar..."; CmdBar.Text = ""
CmdBar.Visible = false; CmdBar.ZIndex = 111
Instance.new("UICorner", CmdBar).CornerRadius = UDim.new(0, 5)

LogoBtn.MouseButton1Click:Connect(function()
    CmdBar.Visible = not CmdBar.Visible
    if CmdBar.Visible then CmdBar:CaptureFocus() end
end)

-- ═══════════════════════════════════════════════════════════
--  5. COMMANDES
-- ═══════════════════════════════════════════════════════════
local function ntf(t, m) pcall(function() StarterGui:SetCore("SendNotification", { Title = t, Text = m, Icon = HD_LOGO, Duration = 5 }) end) end
local function register(n, a, d, c) State.Commands[n] = {Aliases = a, Desc = d, Callback = c} end
local function get(name)
    name = (name or ""):lower()
    for _, p in pairs(Players:GetPlayers()) do if p.Name:lower():find(name) or p.DisplayName:lower():find(name) then return p end end
    return nil
end
local function execute(msg)
    if not State.Active then return false end
    local prefix = State.Prefix
    if msg:sub(1, #prefix) == prefix then
        local args = msg:sub(#prefix + 1):split(" ")
        local cmdName = table.remove(args, 1):lower()
        for name, cmd in pairs(State.Commands) do
            if name == cmdName or table.find(cmd.Aliases, cmdName) then task.spawn(function() pcall(cmd.Callback, args) end) return true end
        end
    end
    return false
end
table.insert(State.Connections, L.Chatted:Connect(execute))
CmdBar.FocusLost:Connect(function(ep) if ep then execute(CmdBar.Text); CmdBar.Text = ""; CmdBar.Visible = false end end)

register("cmds", {"help"}, "Liste", function()
    local c = ""
    for n, d in pairs(State.Commands) do c = c .. n .. ", " end
    print("🔱 ARCANE: CMDS -> " .. c); ntf("CMDS", "Check F9 console.")
end)

register("shackle", {"s"}, "Stase", function(args)
    local target = get(args[1])
    if not target then return ntf("ERROR", "Joueur introuvable") end
    local anchor = nil
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name == "Handle" and pcall(function() return v:GetNetworkOwner() == L end) then anchor = v break end
    end
    if not anchor then return ntf("ERROR", "Sors un objet (Skate/Outil) !") end
    State.Shackled[target.UserId] = anchor
    ntf("STASIS", target.DisplayName .. " bloqué.")
    task.spawn(function()
        while State.Active and State.Shackled[target.UserId] == anchor and target.Character do
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp then anchor.CFrame = hrp.CFrame; anchor.Velocity = Vector3.new(0,0,0) end
            RunService.Heartbeat:Wait()
        end
    end)
end)

register("unshackle", {"un"}, "Libère", function(args)
    local t = get(args[1]); if t then State.Shackled[t.UserId] = nil ntf("RELEASE", "Libéré.") end
end)

register("void", {"v"}, "Purge locale", function(args)
    local t = get(args[1]); if t and t.Character then t.Character:Destroy(); ntf("VOID", "Purgé.") end
end)

register("mute", {"m"}, "Censure locale", function(args)
    local t = get(args[1]); if t then State.Muted[t.UserId] = true ntf("MUTE", "Mute.") end
end)

register("badge", {"admin"}, "Prestige Staff", function()
    local char = L.Character or L.CharacterAdded:Wait()
    local h = char:WaitForChild("Head")
    local b = h:FindFirstChild("ArcaneBadge") or Instance.new("BillboardGui", h)
    b.Name = "ArcaneBadge"; b.Size = UDim2.new(0, 150, 0, 40); b.AlwaysOnTop = true
    local m = b:FindFirstChild("Main") or Instance.new("Frame", b); m.Size = UDim2.new(1, 0, 1, 0); m.BackgroundColor3 = HD_COLORS.Blurple
    if not m:FindFirstChildOfClass("UICorner") then Instance.new("UICorner", m).CornerRadius = UDim.new(0, 8) end
    local l = m:FindFirstChild("Label") or Instance.new("TextLabel", m); l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1
    l.Text = "🛡️ STAFF 🛡️"; l.TextColor3 = HD_COLORS.White; l.TextScaled = true; l.Font = HD_FONT
    ntf("PRESTIGE", "Confirmé.")
end)

-- ═══════════════════════════════════════════════════════════
--  6. FINAL RECOVERY HOOK
-- ═══════════════════════════════════════════════════════════
_G.ArcaneCleanup = function()
    State.Active = false
    pcall(function() ScreenGui:Destroy() end)
    for _, c in pairs(State.Connections) do pcall(function() c:Disconnect() end) end
end

if TCS then
    pcall(function()
        TCS.OnIncomingMessage = function(message)
            local p = Instance.new("TextChatMessageProperties")
            pcall(function()
                if State and State.Active and State.Muted and message and message.TextSource then
                    if State.Muted[message.TextSource.UserId] then p.Text = "" end
                end
            end)
            return p
        end
    end)
end

ntf("ARCANE", "Shadow HD v12.9 (NUCLEAR) Déployé. <3")
print("🔥 ARCANE [BOOT]: Tout est opérationnel.")
