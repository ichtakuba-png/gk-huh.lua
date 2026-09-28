--// ============================================================
--// 🥚 GK HUH | STEAL A EGG CLIENT PRO MAX
--// ONE FILE • ACODE • MOBILE + PC
--// Loading: SHARDS -> COLLAPSE -> GK HUH -> DEV GKIET
--// ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer

--==============================================================
-- CONFIG
--==============================================================

local Config = {
    Creator = "GK HUH",
    Developer = "GKIET",

    MinMoney = 500000000,
    MinWeight = 4000000,
    MinRarity = "Secret",

    AutoScan = true,
    ScanDelay = 1,

    Notifications = true,
    HighlightEggs = true,

    MaxLogs = 50
}

local RarityTier = {
    Common = 0,
    Uncommon = 1,
    Rare = 2,
    Epic = 3,
    Legendary = 4,
    Mythical = 5,
    Divine = 6,
    Secret = 7
}

--==============================================================
-- STATE
--==============================================================

local State = {
    Running = true,
    Scanning = Config.AutoScan,

    FPS = 0,
    Ping = 0,

    ScanCount = 0,
    FoundCount = 0,

    LastSignature = "",
    Logs = {},
    Highlights = {}
}

--==============================================================
-- UTILS
--==============================================================

local function FormatNumber(n)
    n = tonumber(n) or 0

    if n >= 1e12 then
        return string.format("%.2fT", n / 1e12)
    elseif n >= 1e9 then
        return string.format("%.2fB", n / 1e9)
    elseif n >= 1e6 then
        return string.format("%.2fM", n / 1e6)
    elseif n >= 1e3 then
        return string.format("%.2fK", n / 1e3)
    end

    return tostring(math.floor(n))
end

local function Tween(obj, info, props)
    local ok, result = pcall(function()
        return TweenService:Create(obj, info, props)
    end)

    if ok and result then
        result:Play()
        return result
    end
end

local function Notify(title, text, duration)
    if not Config.Notifications then
        return
    end

    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 5
        })
    end)
end

local function AddLog(text)
    table.insert(
        State.Logs,
        1,
        os.date("%H:%M:%S") .. " | " .. text
    )

    while #State.Logs > Config.MaxLogs do
        table.remove(State.Logs)
    end
end

local function GetValue(parent, name)
    if not parent then
        return nil
    end

    local obj = parent:FindFirstChild(name)

    if obj and obj:IsA("ValueBase") then
        return obj.Value
    end

    return nil
end

local function FindStat(...)
    local names = {...}

    local containers = {
        LP:FindFirstChild("leaderstats"),
        LP
    }

    for _, container in ipairs(containers) do
        if container then
            for _, name in ipairs(names) do
                local value = GetValue(container, name)

                if value ~= nil then
                    return value
                end
            end
        end
    end

    return 0
end

--==============================================================
-- MAIN GUI
--==============================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "GKHuhEggPRO_MAX"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    Gui.Parent = game:GetService("CoreGui")
end)

if not Gui.Parent then
    Gui.Parent = LP:WaitForChild("PlayerGui")
end

--==============================================================
-- LOADING SCREEN
--==============================================================

local Loading = Instance.new("Frame")
Loading.Size = UDim2.fromScale(1, 1)
Loading.BackgroundColor3 = Color3.fromRGB(5, 5, 9)
Loading.BorderSizePixel = 0
Loading.ZIndex = 100
Loading.Parent = Gui

-- Background glow

local Glow = Instance.new("Frame")
Glow.Size = UDim2.fromOffset(300, 300)
Glow.AnchorPoint = Vector2.new(0.5, 0.5)
Glow.Position = UDim2.fromScale(0.5, 0.46)
Glow.BackgroundColor3 = Color3.fromRGB(80, 35, 180)
Glow.BackgroundTransparency = 0.9
Glow.BorderSizePixel = 0
Glow.ZIndex = 101
Glow.Parent = Loading

local GlowCorner = Instance.new("UICorner")
GlowCorner.CornerRadius = UDim.new(1, 0)
GlowCorner.Parent = Glow

--==============================================================
-- SHARDS
--==============================================================

local Shards = {}

for i = 1, 42 do

    local shard = Instance.new("Frame")

    local size = math.random(4, 14)

    shard.Size = UDim2.fromOffset(size, size)
    shard.AnchorPoint = Vector2.new(0.5, 0.5)

    local angle = math.random() * math.pi * 2
    local distance = math.random(260, 650)

    local x = math.cos(angle) * distance
    local y = math.sin(angle) * distance

    shard.Position = UDim2.new(
        0.5,
        x,
        0.47,
        y
    )

    shard.Rotation = math.random(0, 360)

    shard.BackgroundColor3 =
        Color3.fromHSV(
            math.random(),
            0.65,
            1
        )

    shard.BackgroundTransparency = 0.1
    shard.BorderSizePixel = 0
    shard.ZIndex = 103
    shard.Parent = Loading

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, math.random(1, 4))
    c.Parent = shard

    table.insert(Shards, shard)
end

--==============================================================
-- CENTER LOGO
--==============================================================

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 0, 100)
Logo.AnchorPoint = Vector2.new(0.5, 0.5)
Logo.Position = UDim2.fromScale(0.5, 0.45)
Logo.BackgroundTransparency = 1
Logo.Text = ""
Logo.TextColor3 = Color3.new(1, 1, 1)
Logo.TextTransparency = 1
Logo.TextSize = 52
Logo.Font = Enum.Font.GothamBlack
Logo.ZIndex = 110
Logo.Parent = Loading

--==============================================================
-- DEV
--==============================================================

local Dev = Instance.new("TextLabel")
Dev.Size = UDim2.new(1, 0, 0, 30)
Dev.AnchorPoint = Vector2.new(0.5, 0.5)
Dev.Position = UDim2.fromScale(0.5, 0.53)
Dev.BackgroundTransparency = 1
Dev.Text = "DEV • GKIET"
Dev.TextColor3 = Color3.fromRGB(160, 160, 180)
Dev.TextTransparency = 1
Dev.TextSize = 14
Dev.Font = Enum.Font.GothamMedium
Dev.ZIndex = 110
Dev.Parent = Loading

--==============================================================
-- STATUS
--==============================================================

local LoadingText = Instance.new("TextLabel")
LoadingText.Size = UDim2.new(1, 0, 0, 30)
LoadingText.AnchorPoint = Vector2.new(0.5, 0.5)
LoadingText.Position = UDim2.fromScale(0.5, 0.61)
LoadingText.BackgroundTransparency = 1
LoadingText.Text = "INITIALIZING..."
LoadingText.TextColor3 = Color3.fromRGB(130, 130, 150)
LoadingText.TextSize = 12
LoadingText.Font = Enum.Font.Code
LoadingText.ZIndex = 110
LoadingText.Parent = Loading

--==============================================================
-- PROGRESS
--==============================================================

local ProgressBack = Instance.new("Frame")
ProgressBack.Size = UDim2.fromOffset(300, 5)
ProgressBack.AnchorPoint = Vector2.new(0.5, 0.5)
ProgressBack.Position = UDim2.fromScale(0.5, 0.67)
ProgressBack.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
ProgressBack.BorderSizePixel = 0
ProgressBack.ZIndex = 110
ProgressBack.Parent = Loading

local ProgressCorner = Instance.new("UICorner")
ProgressCorner.CornerRadius = UDim.new(1, 0)
ProgressCorner.Parent = ProgressBack

local Progress = Instance.new("Frame")
Progress.Size = UDim2.new(0, 0, 1, 0)
Progress.BackgroundColor3 = Color3.fromRGB(150, 80, 255)
Progress.BorderSizePixel = 0
Progress.ZIndex = 111
Progress.Parent = ProgressBack

local ProgressCorner2 = Instance.new("UICorner")
ProgressCorner2.CornerRadius = UDim.new(1, 0)
ProgressCorner2.Parent = Progress

--==============================================================
-- LOADING ANIMATION
--==============================================================

task.spawn(function()

    -- Phase 1
    LoadingText.Text = "SCATTERING SHARDS..."

    for _, shard in ipairs(Shards) do

        local centerX = math.random(-30, 30)
        local centerY = math.random(-30, 30)

        Tween(
            shard,
            TweenInfo.new(
                0.75,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out
            ),
            {
                Position = UDim2.new(
                    0.5,
                    centerX,
                    0.47,
                    centerY
                ),
                Rotation = math.random(0, 360)
            }
        )
    end

    Tween(
        Progress,
        TweenInfo.new(0.9, Enum.EasingStyle.Quart),
        {
            Size = UDim2.new(0.32, 0, 1, 0)
        }
    )

    task.wait(0.9)

    -- Phase 2
    LoadingText.Text = "COLLAPSING..."

    for _, shard in ipairs(Shards) do

        Tween(
            shard,
            TweenInfo.new(
                0.8,
                Enum.EasingStyle.Exponential,
                Enum.EasingDirection.In
            ),
            {
                Position = UDim2.fromScale(0.5, 0.47),
                Size = UDim2.fromOffset(1, 1),
                BackgroundTransparency = 0
            }
        )
    end

    Tween(
        Progress,
        TweenInfo.new(0.8, Enum.EasingStyle.Quart),
        {
            Size = UDim2.new(0.65, 0, 1, 0)
        }
    )

    task.wait(0.85)

    -- Flash
    local Flash = Instance.new("Frame")
    Flash.Size = UDim2.fromScale(1, 1)
    Flash.BackgroundColor3 = Color3.new(1,1,1)
    Flash.BackgroundTransparency = 1
    Flash.BorderSizePixel = 0
    Flash.ZIndex = 120
    Flash.Parent = Loading

    Tween(
        Flash,
        TweenInfo.new(0.12),
        {BackgroundTransparency = 0.25}
    )

    task.wait(0.12)

    Tween(
        Flash,
        TweenInfo.new(0.35),
        {BackgroundTransparency = 1}
    )

    -- Logo
    Logo.Text = "GK HUH"

    Tween(
        Logo,
        TweenInfo.new(
            0.6,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ),
        {
            TextTransparency = 0,
            TextSize = 58
        }
    )

    Tween(
        Glow,
        TweenInfo.new(0.8, Enum.EasingStyle.Sine),
        {
            BackgroundTransparency = 0.75,
            Size = UDim2.fromOffset(500, 500)
        }
    )

    Tween(
        Progress,
        TweenInfo.new(0.65, Enum.EasingStyle.Quart),
        {
            Size = UDim2.new(0.88, 0, 1, 0)
        }
    )

    LoadingText.Text = "GK HUH CLIENT INITIALIZED"

    task.wait(0.65)

    Dev.Text = "DEV • GKIET"

    Tween(
        Dev,
        TweenInfo.new(0.5),
        {
            TextTransparency = 0
        }
    )

    Tween(
        Progress,
        TweenInfo.new(0.5),
        {
            Size = UDim2.new(1, 0, 1, 0)
        }
    )

    LoadingText.Text = "WELCOME"

    task.wait(0.8)

    -- Fade everything
    for _, obj in ipairs(Loading:GetChildren()) do

        if obj:IsA("TextLabel") then

            Tween(
                obj,
                TweenInfo.new(0.45),
                {
                    TextTransparency = 1
                }
            )

        elseif obj:IsA("Frame") then

            Tween(
                obj,
                TweenInfo.new(0.45),
                {
                    BackgroundTransparency = 1
                }
            )
        end
    end

    Tween(
        Loading,
        TweenInfo.new(0.5),
        {
            BackgroundTransparency = 1
        }
    )

    task.wait(0.55)

    Loading:Destroy()

end)

--==============================================================
-- MAIN PANEL
--==============================================================

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(390, 490)
Main.Position = UDim2.new(0.5, -195, 0.5, -245)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 19)
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = Gui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(120, 70, 255)
MainStroke.Parent = Main

--==============================================================
-- TITLE
--==============================================================

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 0, 45)
Title.Position = UDim2.fromOffset(15, 5)
Title.BackgroundTransparency = 1
Title.Text = "🥚 GK HUH • EGG PRO"
Title.TextColor3 = Color3.fromRGB(235, 220, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(34, 34)
Close.Position = UDim2.new(1, -45, 0, 9)
Close.Text = "×"
Close.TextSize = 23
Close.TextColor3 = Color3.new(1,1,1)
Close.BackgroundColor3 = Color3.fromRGB(100, 35, 45)
Close.Parent = Main

Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8)

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

--==============================================================
-- STATUS
--==============================================================

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -30, 0, 35)
Status.Position = UDim2.fromOffset(15, 52)
Status.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
Status.Text = "● READY"
Status.TextColor3 = Color3.fromRGB(90, 255, 140)
Status.TextSize = 14
Status.Font = Enum.Font.GothamBold
Status.Parent = Main

Instance.new("UICorner", Status).CornerRadius = UDim.new(0, 8)

--==============================================================
-- INFO
--==============================================================

local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, -30, 0, 145)
Info.Position = UDim2.fromOffset(15, 96)
Info.BackgroundColor3 = Color3.fromRGB(19, 19, 28)
Info.TextColor3 = Color3.fromRGB(220, 220, 230)
Info.TextSize = 13
Info.Font = Enum.Font.Code
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.TextYAlignment = Enum.TextYAlignment.Top
Info.Text = "Loading..."
Info.Parent = Main

Instance.new("UICorner", Info).CornerRadius = UDim.new(0, 10)

--==============================================================
-- BUTTON FUNCTION
--==============================================================

local function Button(text, y, color)

    local b = Instance.new("TextButton")

    b.Size = UDim2.new(1, -30, 0, 39)
    b.Position = UDim2.fromOffset(15, y)
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.TextSize = 13
    b.Font = Enum.Font.GothamBold
    b.Parent = Main

    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 9)

    return b
end

local ScanButton =
    Button("🔎 SCAN NGAY", 250,
        Color3.fromRGB(70, 50, 160))

local AutoButton =
    Button("🟢 AUTO SCAN: ON", 295,
        Color3.fromRGB(35, 125, 75))

local HighlightButton =
    Button("🟣 HIGHLIGHT EGG: ON", 340,
        Color3.fromRGB(85, 55, 140))

local LogButton =
    Button("📜 LOG", 385,
        Color3.fromRGB(45, 45, 65))

local UnloadButton =
    Button("⛔ UNLOAD", 430,
        Color3.fromRGB(120, 40, 50))

--==============================================================
-- DRAG
--==============================================================

local dragging = false
local dragStart
local startPos

Title.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = Main.Position

        input.Changed:Connect(function()

            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end

        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if not dragging then
        return
    end

    if input.UserInputType ~= Enum.UserInputType.MouseMovement
    and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local delta = input.Position - dragStart

    Main.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end)

--==============================================================
-- GAME DATA
--==============================================================

local function GetRarity()

    local status =
        ReplicatedStorage:FindFirstChild("CurrentEggStatus")

    if status then

        local rarity =
            status:FindFirstChild("Rarity")

        if rarity and rarity:IsA("ValueBase") then
            return tostring(rarity.Value)
        end
    end

    return "Unknown"
end

local function GetGameData()

    return {
        Money = tonumber(
            FindStat("Money", "Cash", "Coins")
        ) or 0,

        Weight = tonumber(
            FindStat("Weight", "EggWeight")
        ) or 0,

        Rarity = GetRarity()
    }
end

local function RarityAllowed(rarity)

    local current = RarityTier[rarity]
    local minimum = RarityTier[Config.MinRarity]

    if not current or not minimum then
        return false
    end

    return current >= minimum
end

--==============================================================
-- SCAN
--==============================================================

local function Scan()

    if not State.Running then
        return
    end

    local data = GetGameData()

    State.ScanCount += 1

    local moneyOK =
        data.Money >= Config.MinMoney

    local weightOK =
        data.Weight >= Config.MinWeight

    local rarityOK =
        RarityAllowed(data.Rarity)

    local qualified =
        moneyOK and weightOK and rarityOK

    Info.Text =
        "👤 PLAYER  : " .. LP.Name
        .. "\n\n"
        .. "💰 MONEY   : " .. FormatNumber(data.Money)
        .. "\n"
        .. "⚖ WEIGHT  : " .. FormatNumber(data.Weight)
        .. "\n"
        .. "🥚 RARITY  : " .. data.Rarity
        .. "\n\n"
        .. "MIN MONEY  : " .. FormatNumber(Config.MinMoney)
        .. "\n"
        .. "MIN WEIGHT : " .. FormatNumber(Config.MinWeight)

    if qualified then

        Status.Text = "🟢 CONDITION MET"
        Status.TextColor3 =
            Color3.fromRGB(80, 255, 130)

        local signature =
            data.Rarity
            .. "|"
            .. tostring(data.Money)
            .. "|"
            .. tostring(data.Weight)

        if signature ~= State.LastSignature then

            State.LastSignature = signature
            State.FoundCount += 1

            AddLog(
                "FOUND "
                .. data.Rarity
                .. " | "
                .. FormatNumber(data.Money)
                .. " | "
                .. FormatNumber(data.Weight)
            )

            Notify(
                "🥚 GK HUH | FOUND",
                data.Rarity
                .. " | "
                .. FormatNumber(data.Money)
                .. " | "
                .. FormatNumber(data.Weight),
                8
            )
        end

    else

        Status.Text = "🟡 SCANNING"
        Status.TextColor3 =
            Color3.fromRGB(255, 210, 70)
    end
end

ScanButton.MouseButton1Click:Connect(Scan)

--==============================================================
-- AUTO
--==============================================================

AutoButton.MouseButton1Click:Connect(function()

    State.Scanning = not State.Scanning

    if State.Scanning then

        AutoButton.Text =
            "🟢 AUTO SCAN: ON"

        AutoButton.BackgroundColor3 =
            Color3.fromRGB(35, 125, 75)

        AddLog("Auto Scan ON")

    else

        AutoButton.Text =
            "🔴 AUTO SCAN: OFF"

        AutoButton.BackgroundColor3 =
            Color3.fromRGB(120, 45, 50)

        AddLog("Auto Scan OFF")
    end
end)

--==============================================================
-- HIGHLIGHT
--==============================================================

local function IsEgg(obj)

    local n = string.lower(obj.Name)

    return
        string.find(n, "egg")
        or string.find(n, "trung")
        or string.find(n, "secret")
        or string.find(n, "divine")
end

local function Highlight(obj)

    if not Config.HighlightEggs then
        return
    end

    if State.Highlights[obj] then
        return
    end

    if not obj:IsA("BasePart")
    and not obj:IsA("Model") then
        return
    end

    local h = Instance.new("Highlight")

    h.Name = "GKHuhHighlight"
    h.FillTransparency = 0.65
    h.OutlineTransparency = 0
    h.DepthMode =
        Enum.HighlightDepthMode.AlwaysOnTop

    h.Parent = obj

    State.Highlights[obj] = h
end

local function ScanEggs()

    for _, obj in ipairs(Workspace:GetDescendants()) do

        if IsEgg(obj) then
            pcall(function()
                Highlight(obj)
            end)
        end
    end
end

HighlightButton.MouseButton1Click:Connect(function()

    Config.HighlightEggs =
        not Config.HighlightEggs

    if Config.HighlightEggs then

        HighlightButton.Text =
            "🟣 HIGHLIGHT EGG: ON"

        ScanEggs()

    else

        HighlightButton.Text =
            "⚫ HIGHLIGHT EGG: OFF"

        for obj, h in pairs(State.Highlights) do

            if h then
                h:Destroy()
            end

        end

        State.Highlights = {}
    end
end)

Workspace.DescendantAdded:Connect(function(obj)

    if not State.Running then
        return
    end

    if Config.HighlightEggs and IsEgg(obj) then

        task.wait(0.1)

        pcall(function()
            Highlight(obj)
        end)
    end
end)

--==============================================================
-- LOG WINDOW
--==============================================================

local LogFrame = Instance.new("Frame")
LogFrame.Size = UDim2.fromOffset(390, 360)
LogFrame.Position = UDim2.new(0.5, -195, 0.5, -180)
LogFrame.BackgroundColor3 = Color3.fromRGB(11, 11, 17)
LogFrame.BorderSizePixel = 0
LogFrame.Visible = false
LogFrame.ZIndex = 50
LogFrame.Parent = Gui

Instance.new("UICorner", LogFrame).CornerRadius =
    UDim.new(0, 14)

local LogTitle = Instance.new("TextLabel")
LogTitle.Size = UDim2.new(1, -55, 0, 40)
LogTitle.Position = UDim2.fromOffset(15, 5)
LogTitle.BackgroundTransparency = 1
LogTitle.Text = "📜 GK HUH • LOG"
LogTitle.TextColor3 = Color3.fromRGB(230, 220, 255)
LogTitle.TextSize = 17
LogTitle.Font = Enum.Font.GothamBold
LogTitle.TextXAlignment = Enum.TextXAlignment.Left
LogTitle.Parent = LogFrame

local LogClose = Instance.new("TextButton")
LogClose.Size = UDim2.fromOffset(32, 32)
LogClose.Position = UDim2.new(1, -42, 0, 8)
LogClose.Text = "×"
LogClose.TextSize = 22
LogClose.TextColor3 = Color3.new(1,1,1)
LogClose.BackgroundColor3 = Color3.fromRGB(100, 40, 45)
LogClose.Parent = LogFrame

Instance.new("UICorner", LogClose).CornerRadius =
    UDim.new(0, 8)

local LogText = Instance.new("TextLabel")
LogText.Size = UDim2.new(1, -24, 1, -55)
LogText.Position = UDim2.fromOffset(12, 48)
LogText.BackgroundColor3 = Color3.fromRGB(19, 19, 26)
LogText.TextColor3 = Color3.fromRGB(210, 210, 220)
LogText.TextSize = 12
LogText.Font = Enum.Font.Code
LogText.TextXAlignment = Enum.TextXAlignment.Left
LogText.TextYAlignment = Enum.TextYAlignment.Top
LogText.Text = "No logs."
LogText.Parent = LogFrame

Instance.new("UICorner", LogText).CornerRadius =
    UDim.new(0, 9)

local function RefreshLogs()

    if #State.Logs == 0 then
        LogText.Text = "No logs."
        return
    end

    LogText.Text =
        table.concat(State.Logs, "\n")
end

LogButton.MouseButton1Click:Connect(function()

    RefreshLogs()

    LogFrame.Visible = true
    Main.Visible = false
end)

LogClose.MouseButton1Click:Connect(function()

    LogFrame.Visible = false
    Main.Visible = true
end)

--==============================================================
-- FPS
--==============================================================

local frames = 0
local elapsed = 0

RunService.RenderStepped:Connect(function(dt)

    if not State.Running then
        return
    end

    frames += 1
    elapsed += dt

    if elapsed >= 1 then

        State.FPS = frames

        frames = 0
        elapsed = 0
    end
end)

--==============================================================
-- PING
--==============================================================

local function GetPing()

    local ok, value = pcall(function()

        return Stats
            .Network
            .ServerStatsItem["Data Ping"]
            :GetValue()
    end)

    if ok and value then
        return math.floor(value)
    end

    return 0
end

--==============================================================
-- FOOTER
--==============================================================

local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, -30, 0, 20)
Footer.Position = UDim2.fromOffset(15, 465)
Footer.BackgroundTransparency = 1
Footer.Text = "GK HUH • DEV GKIET"
Footer.TextColor3 = Color3.fromRGB(120, 120, 135)
Footer.TextSize = 10
Footer.Font = Enum.Font.Gotham
Footer.Parent = Main

--==============================================================
-- WORKERS
--==============================================================

task.spawn(function()

    task.wait(2.8)

    if not State.Running then
        return
    end

    Main.Visible = true

    AddLog("Client initialized")
    AddLog("Developer: GKIET")
    AddLog("Monitor ready")

    Notify(
        "🥚 GK HUH PRO",
        "Welcome • DEV GKIET",
        5
    )

    pcall(Scan)
    pcall(ScanEggs)
end)

task.spawn(function()

    while State.Running do

        if State.Scanning then
            pcall(Scan)
        end

        task.wait(Config.ScanDelay)
    end
end)

task.spawn(function()

    while State.Running do

        task.wait(0.5)

        if not State.Running then
            break
        end

        State.Ping = GetPing()

        Footer.Text =
            "GK HUH • DEV GKIET"
            .. " • FPS: "
            .. tostring(State.FPS)
            .. " • PING: "
            .. tostring(State.Ping)
            .. "ms"
            .. " • FOUND: "
            .. tostring(State.FoundCount)
    end
end)

--==============================================================
-- UNLOAD
--==============================================================

UnloadButton.MouseButton1Click:Connect(function()

    State.Running = false
    State.Scanning = false

    for _, h in pairs(State.Highlights) do

        if h then
            h:Destroy()
        end
    end

    State.Highlights = {}

    Gui:Destroy()
end)

--==============================================================
-- FINAL
--==============================================================

print("==============================================")
print("🥚 GK HUH | STEAL A EGG CLIENT PRO MAX")
print("👑 CREATOR : GK HUH")
print("🛠 DEV     : GKIET")
print("✨ SHARDS  : ENABLED")
print("✨ LOADING : ENABLED")
print("✨ MONITOR : ENABLED")
print("✨ FPS     : ENABLED")
print("✨ PING    : ENABLED")
print("✨ LOG     : ENABLED")
print("✨ HIGHLIGHT: ENABLED")
print("==============================================")
