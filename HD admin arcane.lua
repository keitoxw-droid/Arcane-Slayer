--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║       HD ADMIN ARCANE (MIMETIC SOVEREIGN v1.5)        ║
    ║   "L'autorité est un vêtement que nous tissons en code."  ║
    ╚═══════════════════════════════════════════════════════════╝
    
    Opération : Sovereign Prestige (v12.8) - RECOVERY ENGINE
    Fix : Immediate Chat Reset, Ultra-Defensive UI, Boot Logs
]]

print("🔱 ARCANE [BOOT]: Démarrage...")

-- ═══════════════════════════════════════════════════════════
--  1. RESET CHAT & CLEANUP (PRIORITÉ ABSOLUE)
-- ═══════════════════════════════════════════════════════════
local TCS = game:GetService("TextChatService")
if TCS then
    pcall(function()
        TCS.OnIncomingMessage = function()
            return Instance.new("TextChatMessageProperties")
        end
    end)
    print("🔱 ARCANE [BOOT]: Chat Hook débloqué.")
end

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local L = Players.LocalPlayer

local function ForceCleanup()
    if _G.ArcaneCleanup then pcall(_G.ArcaneCleanup) end
    local targets = {CoreGui, L:FindFirstChild("PlayerGui")}
    for _, p in pairs(targets) do
        if p then
            for _, v in pairs(p:GetChildren()) do
                if v.Name:find("Arcane") or v.Name:find("Sovereign") then pcall(function() v:Destroy() end) end
            end
        end
    end
end
pcall(ForceCleanup)
print("🔱 ARCANE [BOOT]: Cleanup terminé.")

-- ═══════════════════════════════════════════════════════════
--  2. ÉTAT GLOBAL
-- ═══════════════════════════════════════════════════════════
local State = {
    Prefix = ";", Shackled = {}, Voided = {}, Muted = {},
    Commands = {}, Connections = {}, Active = true
}
_G.ArcaneState = State

local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local HD_LOGO = "rbxassetid://857927023"
local HD_FONT = Enum.Font.GothamBold
local HD_COLORS = { Main = Color3.fromRGB(45, 45, 48), Blurple = Color3.fromRGB(74, 144, 226), White = Color3.fromRGB(255, 255, 255) }

-- ═══════════════════════════════════════════════════════════
--  3. INTERFACE (UI) ULTRA-DÉFENSIVE
-- ═══════════════════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArcaneSovereign_v12.8"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 10000

local ui_parent = nil
if pcall(function() ScreenGui.Parent = CoreGui end) then
    ui_parent = CoreGui
else
    ui_parent = L:FindFirstChild("PlayerGui")
    if ui_parent then ScreenGui.Parent = ui_parent end
end

if not ScreenGui.Parent then 
    warn("❌ ARCANE [BOOT]: Échec injection UI.")
    return 
end
print("✅ ARCANE [BOOT]: UI injectée dans " .. ScreenGui.Parent.Name)

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
--  4. LOGIQUE MOTEUR
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

-- COMMANDES
register("cmds", {"help"}, "Liste", function()
    local c = ""
    for n, d in pairs(State.Commands) do c = c .. n .. ", " end
    print("🔱 ARCANE: COMMANDES -> " .. c); ntf("CMDS", "Check F9 console.")
end)

register("shackle", {"s"}, "Stase", function(args)
    local target = get(args[1])
    if not target then return ntf("ERROR", "Joueur introuvable") end
    local anchor = nil
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name == "Handle" and pcall(function() return v:GetNetworkOwner() == L end) then anchor = v break end
    end
    if not anchor then return ntf("ERROR", "Sors un objet !") end
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
    local t = get(args[1]); if t and t.Character then t.Character:Destroy(); ntf("VOID", "Cible purgée.") end
end)

register("mute", {"m"}, "Censure locale", function(args)
    local t = get(args[1]); if t then State.Muted[t.UserId] = true ntf("MUTE", "Voix étouffée.") end
end)

register("badge", {"admin"}, "Prestige Staff", function()
    local char = L.Character or L.CharacterAdded:Wait()
    local h = char:WaitForChild("Head")
    local b = h:FindFirstChild("ArcaneBadge") or Instance.new("BillboardGui", h)
    b.Name = "ArcaneBadge"; b.Size = UDim2.new(0, 150, 0, 40); b.StudsOffset = Vector3.new(0, 3, 0); b.AlwaysOnTop = true
    local m = b:FindFirstChild("Main") or Instance.new("Frame", b); m.Size = UDim2.new(1, 0, 1, 0); m.BackgroundColor3 = HD_COLORS.Blurple
    if not m:FindFirstChildOfClass("UICorner") then Instance.new("UICorner", m).CornerRadius = UDim.new(0, 8) end
    local l = m:FindFirstChild("Label") or Instance.new("TextLabel", m); l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1
    l.Text = "🛡️ STAFF 🛡️"; l.TextColor3 = HD_COLORS.White; l.TextScaled = true; l.Font = HD_FONT
    ntf("PRESTIGE", "Rang confirmé.")
end)

-- ═══════════════════════════════════════════════════════════
--  5. CHAT ENGINE (FINAL HOOK)
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

ntf("ARCANE", "Shadow HD v12.8 (RECOVERY) actif. <3")
print("🔱 ARCANE [BOOT]: Succès total.")
