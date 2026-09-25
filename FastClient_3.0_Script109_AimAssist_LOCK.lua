--[[
    ================================================================================
    FAST CLIENT 3.0 | ULTIMATE MERGED FULL (FIXED)
    ИСПРАВЛЕНИЯ ВНЕСЕНЫ:
    1. Arrows - стрелки на игроков + расстояние
    2. KeyBinds - зелёный при включении, белый при выключении
    3. NameTags - HP обновляется при получении урона, показывает ник и HP
    4. AimAssist - исправлен, наводится на голову
    5. Spider - скорость 16-50, запрыгивает на блоки
    6. TargetStrafe - быстрый на 850 (сильно крутится)
    7. Снег падает сверху вниз
    8. FAST CLIENT 2.1 BETA — статичный заголовок без тряски
    9. Strafe - работает в прыжке
    10. Удалён TargetHUD
    11. ESP цвета: 4 круга - Зелёный, Красный, Синий, Фиолетовый
    ================================================================================
]]

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Очистка старых интерфейсов
local guisToClean = {
    "FastClientGUI", "FastClient_Loading", "MiniHUD", "BindListGUI",
    "NotificationGUI", "TargetHUDGui", "ArbuzESPScreen"
}
for _, name in ipairs(guisToClean) do
    if CoreGui:FindFirstChild(name) then CoreGui[name]:Destroy() end
end

-- Главный ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FastClientGUI"
if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
if gethui then ScreenGui.Parent = gethui() else ScreenGui.Parent = CoreGui end
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Notification System
local NotificationGUI = Instance.new("ScreenGui")
NotificationGUI.Name = "NotificationGUI"
NotificationGUI.Parent = CoreGui
NotificationGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local notifContainer = Instance.new("Frame")
notifContainer.Parent = NotificationGUI
notifContainer.BackgroundTransparency = 1
notifContainer.Position = UDim2.new(1, -220, 0, 10)
notifContainer.Size = UDim2.new(0, 200, 0, 0)
notifContainer.ClipsDescendants = true

local notifLayout = Instance.new("UIListLayout")
notifLayout.Parent = notifContainer
notifLayout.Padding = UDim.new(0, 6)
notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local function ShowNotification(text, color)
    color = color or Color3.fromRGB(100, 255, 150)
    
    local frame = Instance.new("Frame")
    frame.Parent = notifContainer
    frame.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
    frame.BackgroundTransparency = 0.1
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.ClipsDescendants = true
    local fCorner = Instance.new("UICorner") fCorner.CornerRadius = UDim.new(0, 6) fCorner.Parent = frame
    local fStroke = Instance.new("UIStroke") fStroke.Color = color fStroke.Thickness = 1.5 fStroke.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -10, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.Text = text
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    notifContainer.Size = UDim2.new(0, 200, 0, notifContainer.Size.Y.Offset + 36)
    
    task.wait(3)
    TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    task.wait(0.3)
    frame:Destroy()
    notifContainer.Size = UDim2.new(0, 200, 0, notifContainer.Size.Y.Offset - 36)
end

-- Loading Screen
local LoadScreen = Instance.new("Frame")
LoadScreen.Parent = ScreenGui
LoadScreen.BackgroundColor3 = Color3.fromRGB(18, 12, 25)
LoadScreen.Size = UDim2.new(1, 0, 1, 0)
LoadScreen.ZIndex = 9999

local LoadHolder = Instance.new("Frame")
LoadHolder.Parent = LoadScreen
LoadHolder.BackgroundTransparency = 1
LoadHolder.Position = UDim2.new(0.5, -160, 0.5, -80)
LoadHolder.Size = UDim2.new(0, 320, 0, 160)

local LoadLogo = Instance.new("TextLabel")
LoadLogo.Parent = LoadHolder
LoadLogo.BackgroundTransparency = 1
LoadLogo.Position = UDim2.new(0.5, -25, 0, 5)
LoadLogo.Size = UDim2.new(0, 50, 0, 50)
LoadLogo.Font = Enum.Font.GothamBold
LoadLogo.Text = "F"
LoadLogo.TextColor3 = Color3.fromRGB(175, 100, 255)
LoadLogo.TextSize = 48
LoadLogo.TextXAlignment = Enum.TextXAlignment.Center

-- Static loading logo: no shaking/rotation.
LoadLogo.Rotation = 0

local LoadTitle = Instance.new("TextLabel")
LoadTitle.Parent = LoadHolder
LoadTitle.BackgroundTransparency = 1
LoadTitle.Position = UDim2.new(0, 0, 0, 58)
LoadTitle.Size = UDim2.new(1, 0, 0, 25)
LoadTitle.Font = Enum.Font.GothamBold
LoadTitle.Text = "FAST CLIENT 3.0"
LoadTitle.TextColor3 = Color3.fromRGB(175, 100, 255)
LoadTitle.TextSize = 16
LoadTitle.TextXAlignment = Enum.TextXAlignment.Center

local LoadSubTitle = Instance.new("TextLabel")
LoadSubTitle.Parent = LoadHolder
LoadSubTitle.BackgroundTransparency = 1
LoadSubTitle.Position = UDim2.new(0, 0, 0, 83)
LoadSubTitle.Size = UDim2.new(1, 0, 0, 18)
LoadSubTitle.Font = Enum.Font.GothamMedium
LoadSubTitle.Text = "Запускается..."
LoadSubTitle.TextColor3 = Color3.fromRGB(150, 130, 170)
LoadSubTitle.TextSize = 11
LoadSubTitle.TextXAlignment = Enum.TextXAlignment.Center

local BarBg = Instance.new("Frame")
BarBg.Parent = LoadHolder
BarBg.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
BarBg.Position = UDim2.new(0, 0, 0, 115)
BarBg.Size = UDim2.new(1, 0, 0, 6)
local bbgc = Instance.new("UICorner") bbgc.CornerRadius = UDim.new(1, 0) bbgc.Parent = BarBg

local BarFill = Instance.new("Frame")
BarFill.Parent = BarBg
BarFill.BackgroundColor3 = Color3.fromRGB(175, 100, 255)
BarFill.Size = UDim2.new(0, 0, 1, 0)
local bfc = Instance.new("UICorner") bfc.CornerRadius = UDim.new(1, 0) bfc.Parent = BarFill

local function startLoadingSequence()
    task.spawn(function()
        local duration = 1.5
        local elapsed = 0
        local dots = 0
        while elapsed < duration do
            local dt = task.wait()
            elapsed = elapsed + dt
            local alpha = math.clamp(elapsed / duration, 0, 1)
            BarFill.Size = UDim2.new(alpha, 0, 1, 0)
            dots = (dots + 1) % 4
            LoadSubTitle.Text = "Запускается" .. string.rep(".", dots)
        end
        LoadSubTitle.Text = "Готово!"
        task.wait(0.3)
        TweenService:Create(LoadScreen, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        for _, obj in ipairs(LoadHolder:GetDescendants()) do
            if obj:IsA("TextLabel") then
                TweenService:Create(obj, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            elseif obj:IsA("Frame") then
                TweenService:Create(obj, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            end
        end
        task.wait(0.3)
        LoadScreen:Destroy()
    end)
end
startLoadingSequence()

-- Mini HUD
local MiniHUD = Instance.new("ScreenGui")
MiniHUD.Name = "MiniHUD"
MiniHUD.Parent = CoreGui
MiniHUD.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MiniFrame = Instance.new("Frame")
MiniFrame.Parent = MiniHUD
MiniFrame.BackgroundColor3 = Color3.fromRGB(20, 18, 28)
MiniFrame.BackgroundTransparency = 0.2
MiniFrame.Position = UDim2.new(0, 15, 0, 15)
MiniFrame.Size = UDim2.new(0, 130, 0, 42)
MiniFrame.ClipsDescendants = true
local mfCorner = Instance.new("UICorner") mfCorner.CornerRadius = UDim.new(0, 10) mfCorner.Parent = MiniFrame
local mfStroke = Instance.new("UIStroke") mfStroke.Color = Color3.fromRGB(175, 100, 255) mfStroke.Thickness = 1.5 mfStroke.Parent = MiniFrame

local MiniLogo = Instance.new("TextLabel")
MiniLogo.Parent = MiniFrame
MiniLogo.BackgroundTransparency = 1
MiniLogo.Position = UDim2.new(0, 6, 0, 0)
MiniLogo.Size = UDim2.new(0, 30, 0, 42)
MiniLogo.Font = Enum.Font.GothamBold
MiniLogo.Text = "F"
MiniLogo.TextColor3 = Color3.fromRGB(175, 100, 255)
MiniLogo.TextSize = 32
MiniLogo.TextXAlignment = Enum.TextXAlignment.Left

MiniLogo.Rotation = 0

local BetaLabel = Instance.new("TextLabel")
BetaLabel.Parent = MiniFrame
BetaLabel.BackgroundTransparency = 1
BetaLabel.Position = UDim2.new(0, 38, 0, 2)
BetaLabel.Size = UDim2.new(0, 60, 0, 16)
BetaLabel.Font = Enum.Font.GothamBold
BetaLabel.Text = "BETA 2.1"
BetaLabel.TextColor3 = Color3.fromRGB(230, 230, 240)
BetaLabel.TextSize = 10
BetaLabel.TextXAlignment = Enum.TextXAlignment.Left

local FpsLabel = Instance.new("TextLabel")
FpsLabel.Parent = MiniFrame
FpsLabel.BackgroundTransparency = 1
FpsLabel.Position = UDim2.new(0, 38, 0, 20)
FpsLabel.Size = UDim2.new(0, 40, 0, 18)
FpsLabel.Font = Enum.Font.GothamMedium
FpsLabel.Text = "FPS: 0"
FpsLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
FpsLabel.TextSize = 10
FpsLabel.TextXAlignment = Enum.TextXAlignment.Left

local PingLabel = Instance.new("TextLabel")
PingLabel.Parent = MiniFrame
PingLabel.BackgroundTransparency = 1
PingLabel.Position = UDim2.new(0, 80, 0, 20)
PingLabel.Size = UDim2.new(0, 45, 0, 18)
PingLabel.Font = Enum.Font.GothamMedium
PingLabel.Text = "Ping: 0"
PingLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
PingLabel.TextSize = 10
PingLabel.TextXAlignment = Enum.TextXAlignment.Left

local frameCount = 0
local lastFpsUpdate = tick()
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = tick()
    if now - lastFpsUpdate >= 0.5 then
        local fps = math.floor(frameCount / (now - lastFpsUpdate))
        local ping = math.floor(LocalPlayer:GetNetworkPing() * 100)
        FpsLabel.Text = "FPS: " .. fps
        PingLabel.Text = "Ping: " .. ping
        frameCount = 0
        lastFpsUpdate = now
    end
end)

local dragging, dragInput, dragStart, startPos
MiniFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MiniFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
MiniFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MiniFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Localization
local currentLanguage = "RU"
local Languages = {
    ["RU"] = {
        Activate = "Активировать",
        Search = "Поиск...",
        SubTerm = "Срок: ",
        EnterKey = "Ключ подписки...",
        ModuleDisabled = "Модуль отключен",
        ModuleEnabled = "Включено: ",
        AuthTitle = "Авторизация FastClient",
        AuthPlaceholder = "Введите лицензионный ключ...",
        AuthLogin = "Активировать и Войти",
        OwnerTitle = "Панель Владельца 👑",
        GenTitle = "Генерация Ключей:",
        Cat_Combat = "⚔️ Combat",
        Cat_Visuals = "👁️ Visuals",
        Cat_Movement = "🏃 Movement",
        Cat_HUD = "📊 HUD",
        Cat_Settings = "⚙️ Settings",
        Cat_Configs = "📂 Configs",
        Role_Owner = "Владелец 👑",
        Role_Admin = "Админ ⚡",
        Role_Premium = "Премиум ⭐",
        Role_Player = "Игрок",
        PermSub = "Навсегда ♾️",
        NotActive = "Не активировано",
        Expired = "Истёк",
        On = "Вкл",
        Off = "Выкл",
        Active = "Активен",
        Inactive = "Неактивен",
        BindNone = "Нет",
        BindDelete = "Удалить (Delete)",
        ColorLabel = "Цвет:",
        SpeedLabel = "Скорость",
        AmountLabel = "Кол-во",
        DistanceLabel = "Дистанция",
        SmoothnessLabel = "Плавность",
        RangeLabel = "Радиус",
        IntensityLabel = "Интенсивность",
        RechargeBtn = "Пополнить",
        RechargeInfo = "По поводу оплаты - fast1kk1 (дискорд)",
        ActivateKey = "Активировать ключ",
        EnterKeyLabel = "Введите ключ...",
        KeyInvalid = "Неверный ключ!",
        KeyActivated = "Ключ активирован!",
        KeyAlreadyUsed = "Этот ключ уже использован!",
        KeySuccess = "✅ Активирован! Роль: ",
        KeyYoutuber = "🔴 Активирован YOUTUBER!",
        KeyAdmin = "👑 Активирован Админ",
        KeyOwner = "👑 Активирован Владелец!",
        ModulePremium = "❌ Premium модуль!",
        ModuleAuth = "🔒 Активируйте ключ!",
        ModuleOn = "✅ включен",
        ModuleOff = "❌ выключен",
        ThemeApply = "🎨 Тема применена: ",
        LangSet = "🌍 Язык установлен: ",
        ConfigSaved = "✅ Конфиг сохранён!",
        ConfigLoaded = "✅ Конфиг загружен!",
        ConfigDeleted = "🗑️ Конфиг удалён!",
        ConfigExported = "📤 Конфиг экспортирован!",
        ConfigImported = "📥 Конфиг импортирован!",
        ConfigNameEmpty = "❌ Имя не может быть пустым!",
        ConfigExists = "❌ Конфиг с таким именем уже существует!",
        ConfigNotFound = "❌ Конфиг не найден!",
        ConfigInvalid = "❌ Неверный формат данных!",
        ConfigList = "📋 Сохранённые конфиги:",
        ConfigEmpty = "📭 Нет сохранённых конфигов",
        NoPlayers = "❌ Нет других игроков!",
        PlayerNotFound = "❌ Игрок не найден!",
        EnterAmount = "❌ Введите сумму!",
        EnterNick = "❌ Введите ник игрока!"
    },
    ["EN"] = {
        Activate = "Activate",
        Search = "Search...",
        SubTerm = "Term: ",
        EnterKey = "Subscription key...",
        ModuleDisabled = "Module disabled",
        ModuleEnabled = "Enabled: ",
        AuthTitle = "FastClient Authorization",
        AuthPlaceholder = "Enter license key...",
        AuthLogin = "Activate & Login",
        OwnerTitle = "Owner Panel 👑",
        GenTitle = "Key Generation:",
        Cat_Combat = "⚔️ Combat",
        Cat_Visuals = "👁️ Visuals",
        Cat_Movement = "🏃 Movement",
        Cat_HUD = "📊 HUD",
        Cat_Settings = "⚙️ Settings",
        Cat_Configs = "📂 Configs",
        Role_Owner = "Owner 👑",
        Role_Admin = "Admin ⚡",
        Role_Premium = "Premium ⭐",
        Role_Player = "Player",
        PermSub = "Forever ♾️",
        NotActive = "Not activated",
        Expired = "Expired",
        On = "On",
        Off = "Off",
        Active = "Active",
        Inactive = "Inactive",
        BindNone = "None",
        BindDelete = "Delete (Delete)",
        ColorLabel = "Color:",
        SpeedLabel = "Speed",
        AmountLabel = "Amount",
        DistanceLabel = "Distance",
        SmoothnessLabel = "Smoothness",
        RangeLabel = "Range",
        IntensityLabel = "Intensity",
        RechargeBtn = "Recharge",
        RechargeInfo = "For payment - fast1kk1 (discord)",
        ActivateKey = "Activate key",
        EnterKeyLabel = "Enter key...",
        KeyInvalid = "Invalid key!",
        KeyActivated = "Key activated!",
        KeyAlreadyUsed = "This key is already used!",
        KeySuccess = "✅ Activated! Role: ",
        KeyYoutuber = "🔴 YOUTUBER activated!",
        KeyAdmin = "👑 Admin activated",
        KeyOwner = "👑 Owner activated!",
        ModulePremium = "❌ Premium module!",
        ModuleAuth = "🔒 Activate the key!",
        ModuleOn = "✅ enabled",
        ModuleOff = "❌ disabled",
        ThemeApply = "🎨 Theme applied: ",
        LangSet = "🌍 Language set: ",
        ConfigSaved = "✅ Config saved!",
        ConfigLoaded = "✅ Config loaded!",
        ConfigDeleted = "🗑️ Config deleted!",
        ConfigExported = "📤 Config exported!",
        ConfigImported = "📥 Config imported!",
        ConfigNameEmpty = "❌ Name cannot be empty!",
        ConfigExists = "❌ Config with this name already exists!",
        ConfigNotFound = "❌ Config not found!",
        ConfigInvalid = "❌ Invalid data format!",
        ConfigList = "📋 Saved configs:",
        ConfigEmpty = "📭 No saved configs",
        NoPlayers = "❌ No other players!",
        PlayerNotFound = "❌ Player not found!",
        EnterAmount = "❌ Enter amount!",
        EnterNick = "❌ Enter player nickname!"
    }
}

local function L(key)
    return Languages[currentLanguage][key] or key
end

function SetLanguage(langKey)
    if Languages[langKey] then
        currentLanguage = langKey
        if SearchBox then SearchBox.PlaceholderText = L("Search") end
        if ActivateModalBtn then ActivateModalBtn.Text = L("Activate") end
        if ActivateKeyBtn then ActivateKeyBtn.Text = L("Activate") end
        if SubKeyBox then SubKeyBox.PlaceholderText = L("EnterKey") end
        if KeyBtn then KeyBtn.Text = "🔑 " .. L("Activate") .. " " .. (currentLanguage == "RU" and "ключ" or "key") end
        if BindTitle then BindTitle.Text = "⌨  " .. U("KeyBinds") end
        if AuthStatusLabel then AuthStatusLabel.Text = isAuthenticated and U("АКТИВИРОВАН") or U("НЕ АКТИВИРОВАН") end
        if UserRoleLabel then UserRoleLabel.Text = getRoleTitle(userRole) end
        if SubTimeLabel then SubTimeLabel.Text = "⏱ " .. getTimeRemaining() end
        renderCategories()
        renderModules(currentCategory, SearchBox.Text)
        UpdateBindList()
    end
end

-- Full UI localization map. Internal module/category IDs stay stable while every
-- visible label is rendered from the current language.
local UI_TRANSLATIONS = {
    RU = {
        ["AutoClicker"]="Автокликер", ["Hitboxes"]="Хитбоксы", ["AimAssist"]="Помощь прицелу", ["KickAura"]="KickAura",
        ["NameTags"]="Неймтеги", ["Chams"]="Чамсы", ["ESP Outlines"]="Контуры ESP", ["ESP Commands"]="ESP Команд", ["Tracers"]="Трейсеры",
        ["Skeleton"]="Скелет", ["Arrows"]="Стрелки", ["Particles"]="Частицы", ["Particles Count"]="Количество частиц",
        ["Particles Speed"]="Скорость частиц", ["Third Person"]="Вид от третьего лица", ["MotionBlur"]="Размытие движения",
        ["Speed"]="Скорость", ["Flight"]="Полёт", ["NoClip"]="NoClip", ["Spider"]="Паук", ["Strafe"]="Стрейф",
        ["TargetStrafe"]="TargetStrafe", ["TargetStrafe Dist"]="Дистанция TargetStrafe", ["Anti Aim"]="Анти-аим",
        ["Bind List"]="Список биндов", ["AutoFarm"]="Автофарм", ["Optimization"]="Оптимизация", ["NoPush"]="Без толчков",
        ["4K GRAPHICS"]="4K ГРАФИКА", ["🎰 Кейс с Ключами"]="🎰 Кейс с ключами", ["💀 Всё или ничего"]="💀 Всё или ничего",
        ["💰 Пополнить баланс"]="💰 Пополнить баланс", ["🎨 Purple Theme"]="🎨 Фиолетовая тема", ["🎨 Red Theme"]="🎨 Красная тема",
        ["🎨 Green Theme"]="🎨 Зелёная тема", ["🎨 Blue Theme"]="🎨 Синяя тема", ["🌍 RU Language"]="🌍 Русский язык",
        ["🌍 EN Language"]="🌍 Английский язык", ["💾 Сохранить конфиг"]="💾 Сохранить конфиг", ["📂 Загрузить конфиг"]="📂 Загрузить конфиг",
        ["🗑️ Удалить конфиг"]="🗑️ Удалить конфиг", ["📤 Экспорт конфига"]="📤 Экспорт конфига", ["📥 Импорт конфига"]="📥 Импорт конфига",
        ["📋 Список конфигов"]="📋 Список конфигов", ["CPS"]="CPS", ["Размер"]="Размер", ["Резкость"]="Резкость",
        ["Дистанция"]="Дистанция", ["Скорость"]="Скорость", ["Кол-во"]="Количество", ["Интенсивность"]="Интенсивность",
        ["Цвет:"]="Цвет:", ["Применить"]="Применить", ["Переключить"]="Переключить", ["Открыть"]="Открыть",
        ["ЗАБРАТЬ"]="ЗАБРАТЬ", ["🎰 КРУТИМ... 🎰"]="🎰 КРУТИМ... 🎰", ["Нет активных биндов"]="Нет назначенных биндов",
        ["None"]="Нет", ["On"]="Вкл", ["Off"]="Выкл", ["ACTIVE"]="АКТИВЕН", ["INACTIVE"]="НЕАКТИВЕН",
        ["KeyBinds"]="KeyBinds", ["Ключ"]="Ключ", ["АКТИВИРОВАН"]="АКТИВИРОВАН", ["НЕ АКТИВИРОВАН"]="НЕ АКТИВИРОВАН",
        ["Введите ключ..."]="Введите ключ...", ["Активируйте ключ!"]="Активируйте ключ!", ["Premium модуль!"]="Premium-модуль!",
        ["Язык установлен: "]="Язык установлен: ", ["Тема применена: "]="Тема применена: ", ["Срок истёк"]="Срок истёк",
        ["Истек"]="Истёк", ["🎨 Тема"]="🎨 Тема", ["Ошибка"]="Ошибка", ["ключ"]="ключ", ["7 дней"]="7 дней", ["30 дней"]="30 дней", ["90 дней"]="90 дней", ["180 дней"]="180 дней", ["1 час"]="1 час", ["Премиум 67 дней"]="Премиум 67 дней", ["Ничего"]="Ничего", ["14 дней"]="14 дней"
    },
    EN = {
        ["AutoClicker"]="AutoClicker", ["Hitboxes"]="Hitboxes", ["AimAssist"]="Aim Assist", ["KickAura"]="KickAura",
        ["NameTags"]="NameTags", ["Chams"]="Chams", ["ESP Outlines"]="ESP Outlines", ["ESP Commands"]="ESP Commands", ["Tracers"]="Tracers",
        ["Skeleton"]="Skeleton", ["Arrows"]="Arrows", ["Particles"]="Particles", ["Particles Count"]="Particles Count",
        ["Particles Speed"]="Particles Speed", ["Third Person"]="Third Person", ["MotionBlur"]="Motion Blur",
        ["Speed"]="Speed", ["Flight"]="Flight", ["NoClip"]="NoClip", ["Spider"]="Spider", ["Strafe"]="Strafe",
        ["TargetStrafe"]="Target Strafe", ["TargetStrafe Dist"]="Target Strafe Distance", ["Anti Aim"]="Anti Aim",
        ["Bind List"]="Bind List", ["AutoFarm"]="AutoFarm", ["Optimization"]="Optimization", ["NoPush"]="No Push",
        ["4K GRAPHICS"]="4K GRAPHICS", ["🎰 Кейс с Ключами"]="🎰 Key Case", ["💀 Всё или ничего"]="💀 All or Nothing", ["🎨 Purple Theme"]="🎨 Purple Theme", ["🎨 Red Theme"]="🎨 Red Theme",
        ["🎨 Green Theme"]="🎨 Green Theme", ["🎨 Blue Theme"]="🎨 Blue Theme", ["🌍 RU Language"]="🌍 Russian Language",
        ["🌍 EN Language"]="🌍 English Language", ["💾 Сохранить конфиг"]="💾 Save Config", ["📂 Загрузить конфиг"]="📂 Load Config",
        ["🗑️ Удалить конфиг"]="🗑️ Delete Config", ["📤 Экспорт конфига"]="📤 Export Config", ["📥 Импорт конфига"]="📥 Import Config",
        ["📋 Список конфигов"]="📋 Config List", ["CPS"]="CPS", ["Размер"]="Size", ["Резкость"]="Smoothness",
        ["Дистанция"]="Distance", ["Скорость"]="Speed", ["Кол-во"]="Count", ["Интенсивность"]="Intensity",
        ["Цвет:"]="Color:", ["Применить"]="Apply", ["Переключить"]="Toggle", ["Открыть"]="Open",
        ["ЗАБРАТЬ"]="CLAIM", ["🎰 КРУТИМ... 🎰"]="🎰 ROLLING... 🎰", ["Нет активных биндов"]="No assigned binds",
        ["None"]="None", ["On"]="On", ["Off"]="Off", ["ACTIVE"]="ACTIVE", ["INACTIVE"]="INACTIVE",
        ["KeyBinds"]="KeyBinds", ["Ключ"]="Key", ["АКТИВИРОВАН"]="ACTIVATED", ["НЕ АКТИВИРОВАН"]="NOT ACTIVATED",
        ["Введите ключ..."]="Enter key...", ["Активируйте ключ!"]="Activate your key!", ["Premium модуль!"]="Premium module!",
        ["Язык установлен: "]="Language set: ", ["Тема применена: "]="Theme applied: ", ["Срок истёк"]="Subscription expired",
        ["Истек"]="Expired", ["🎨 Тема"]="🎨 Theme", ["Ошибка"]="Error", ["ключ"]="key", ["7 дней"]="7 days", ["30 дней"]="30 days", ["90 дней"]="90 days", ["180 дней"]="180 days", ["1 час"]="1 hour", ["Премиум 67 дней"]="Premium 67 days", ["Ничего"]="Nothing", ["14 дней"]="14 days"
    }
}

local function U(text)
    local pack = UI_TRANSLATIONS[currentLanguage] or UI_TRANSLATIONS.RU
    return pack[text] or text
end

local function CategoryText(id)
    return L("Cat_" .. id)
end

-- Data and Keys
local generatedKeys = {}
local isAuthenticated = false
local userRole = "Player"
local subTimeRemaining = L("NotActive")
local subExpiryTime = nil
local listeningKeyMod = nil
local usedKeys = {}
local keyExpiries = {} -- license -> absolute os.time() expiry; "∞" for lifetime

-- YOUTUBER KEYS (5 ШТУК)
local YOUTUBER_KEYS = {
    ["FAST-YT-ZEDD-2026-PERM"] = {Days = 9999, Label = "YOUTUBER ∞", Role = "YOUTUBER"},
    ["FAST-YT-REAPER-2026-PERM"] = {Days = 9999, Label = "YOUTUBER ∞", Role = "YOUTUBER"},
    ["FAST-YT-SHADOW-2026-PERM"] = {Days = 9999, Label = "YOUTUBER ∞", Role = "YOUTUBER"},
    ["FAST-YT-VIPER-2026-PERM"] = {Days = 9999, Label = "YOUTUBER ∞", Role = "YOUTUBER"},
    ["FAST-YT-PHOENIX-2026-PERM"] = {Days = 9999, Label = "YOUTUBER ∞", Role = "YOUTUBER"}
}

-- ONE-TIME KEYS
local ONE_TIME_KEYS = {
    ["ZEDD-YT-TOP4i8-9819781"] = true,
    ["ZEDD-ADMIN-PRAVA-927198014827"] = true
}

-- FIXED KEYS (ВСЕ АДМИН И YOUTUBER КЛЮЧИ)
local FIXED_KEYS = {
    ["FAST-OWNER-KEY-017318236"] = {Days = 9999, Label = "Owner ∞", Role = "Owner", OneTime = false},
    ["ADMIN-PERM-A7B3-C9D1-E2F4-G5H6-I7J8-K9L0"] = {Days = 9999, Label = "Админ ∞", Role = "Admin", OneTime = true},
    ["ADMIN-PERM-M1N2-O3P4-Q5R6-S7T8-U9V0-W1X2"] = {Days = 9999, Label = "Админ ∞", Role = "Admin", OneTime = true},
    ["ADMIN-PERM-Y3Z4-A5B6-C7D8-E9F0-G1H2-I3J4"] = {Days = 9999, Label = "Админ ∞", Role = "Admin", OneTime = true},
    ["ADMIN-PERM-K5L6-M7N8-O9P0-Q1R2-S3T4-U5V6"] = {Days = 9999, Label = "Админ ∞", Role = "Admin", OneTime = true},
    ["ADMIN-PERM-W7X8-Y9Z0-A1B2-C3D4-E5F6-G7H8"] = {Days = 9999, Label = "Админ ∞", Role = "Admin", OneTime = true},
    ["YOUTUBER-PERM-I9J0-K1L2-M3N4-O5P6-Q7R8-S9T0"] = {Days = 9999, Label = "YOUTUBER ∞", Role = "YOUTUBER", OneTime = true},
    ["YOUTUBER-PERM-U1V2-W3X4-Y5Z6-A7B8-C9D0-E1F2"] = {Days = 9999, Label = "YOUTUBER ∞", Role = "YOUTUBER", OneTime = true},
    ["YOUTUBER-PERM-G3H4-I5J6-K7L8-M9N0-O1P2-Q3R4"] = {Days = 9999, Label = "YOUTUBER ∞", Role = "YOUTUBER", OneTime = true},
    ["YOUTUBER-PERM-S5T6-U7V8-W9X0-Y1Z2-A3B4-C5D6"] = {Days = 9999, Label = "YOUTUBER ∞", Role = "YOUTUBER", OneTime = true},
    ["YOUTUBER-PERM-E7F8-G9H0-I1J2-K3L4-M5N6-O7P8"] = {Days = 9999, Label = "YOUTUBER ∞", Role = "YOUTUBER", OneTime = true},
    ["ADMIN-365D-Q9R0-S1T2-U3V4-W5X6-Y7Z8-A9B0"] = {Days = 365, Label = "Админ 365 дней", Role = "Admin", OneTime = true},
    ["ADMIN-180D-C1D2-E3F4-G5H6-I7J8-K9L0-M1N2"] = {Days = 180, Label = "Админ 180 дней", Role = "Admin", OneTime = true},
    ["ADMIN-90D-O3P4-Q5R6-S7T8-U9V0-W1X2-Y3Z4"] = {Days = 90, Label = "Админ 90 дней", Role = "Admin", OneTime = true},
    ["ADMIN-30D-A5B6-C7D8-E9F0-G1H2-I3J4-K5L6"] = {Days = 30, Label = "Админ 30 дней", Role = "Admin", OneTime = true},
    ["ADMIN-14D-M7N8-O9P0-Q1R2-S3T4-U5V6-W7X8"] = {Days = 14, Label = "Админ 14 дней", Role = "Admin", OneTime = true},
    ["ADMIN-7D-Y9Z0-A1B2-C3D4-E5F6-G7H8-I9J0"] = {Days = 7, Label = "Админ 7 дней", Role = "Admin", OneTime = true}
}

-- ============================================================
-- FASTCLIENT 3.0 LICENSE INVENTORY
-- 100 x 14d, 100 x 30d, 100 x 90d, 100 x LifeTime
-- 50 x Premium LifeTime, 10 x Admin 7d
-- ============================================================
local LICENSE_KEYS = {
    ["FAST-14D-001-A49C-6920"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-002-08DA-4C81"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-003-941C-5260"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-004-4507-D254"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-005-6CED-D39E"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-006-C61E-3454"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-007-C73B-C4C4"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-008-6AF5-4EBB"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-009-4FCB-025A"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-010-A654-E580"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-011-0494-D218"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-012-9FF0-5223"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-013-0EEF-AC55"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-014-A26D-0DC2"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-015-6DCE-D41F"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-016-9B78-BD44"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-017-EED3-B0A9"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-018-EE6C-DB25"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-019-8058-D696"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-020-3303-111F"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-021-D78C-6591"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-022-0A7C-75BB"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-023-5C7A-514D"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-024-0297-F807"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-025-5D30-9797"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-026-A9E2-5D2C"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-027-F730-531D"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-028-0E35-43C7"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-029-00AF-120D"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-030-CE31-D144"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-031-7586-5A34"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-032-68C9-E853"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-033-9BA0-FC10"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-034-F382-C7BF"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-035-AD72-7BEC"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-036-FD84-BDCF"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-037-00F8-602C"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-038-86CA-5F78"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-039-1CA0-8A1C"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-040-F993-9ABF"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-041-88C9-B96C"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-042-61DB-9525"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-043-0088-0F15"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-044-098D-697F"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-045-7580-71DA"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-046-F3B5-526B"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-047-1293-9FAF"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-048-BCB4-A9F3"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-049-D0AA-1BA0"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-050-73E3-3639"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-051-F0CB-37A7"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-052-78EC-4239"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-053-43A1-0D12"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-054-F027-7273"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-055-9904-7008"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-056-B92D-232E"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-057-4873-ECFF"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-058-EE62-583B"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-059-A673-C4CB"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-060-9F00-1AB5"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-061-042F-BFB2"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-062-FC36-EE7D"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-063-73C7-E6C0"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-064-EECF-1ECD"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-065-6629-8DD9"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-066-A38B-9C4B"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-067-6C16-BDD5"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-068-C86B-4AE1"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-069-ABBC-15CC"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-070-50AE-0062"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-071-2E49-6671"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-072-FDBE-1E13"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-073-F63C-5274"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-074-A4C7-D909"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-075-C51B-4D1C"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-076-208E-49A0"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-077-D7FA-5DF7"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-078-1AFA-D454"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-079-6707-2DF1"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-080-EFFA-84F0"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-081-1006-2C16"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-082-CF07-7477"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-083-4238-83DC"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-084-BB5E-8F11"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-085-5694-53D1"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-086-B9A5-23A7"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-087-EFCD-5202"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-088-1A3B-E40A"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-089-7CA2-5C1E"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-090-1646-88AE"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-091-26B2-B32F"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-092-D86E-6AC5"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-093-2E3B-4AE1"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-094-AC9F-7762"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-095-80B9-AB9A"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-096-0C89-6F58"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-097-09FA-6B3F"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-098-831F-9318"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-099-B9B8-DEE6"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-14D-100-2B52-9A08"] = {Days = 14, Label = "14 дней", Role = "Subscriber"},
    ["FAST-30D-001-58E6-D294"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-002-1D08-2769"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-003-3878-A59D"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-004-8904-2112"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-005-3DDA-2126"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-006-8F28-B2F9"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-007-E2D0-B670"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-008-701C-65BF"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-009-3EF3-6790"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-010-58EA-2F39"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-011-4453-66C9"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-012-C85D-6A71"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-013-2F97-2A60"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-014-4A35-CF51"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-015-64A4-3038"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-016-360C-1941"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-017-C2E8-EDDE"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-018-7BF6-CADC"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-019-9C30-FDB2"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-020-8A97-C79F"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-021-A0D0-A5B2"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-022-48E4-E955"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-023-8EC9-1DBB"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-024-F06C-1B3F"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-025-DAC0-39FE"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-026-1BAE-FBAC"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-027-C75C-6C1A"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-028-4191-643A"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-029-750B-E6F4"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-030-3975-FB21"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-031-66F4-FB11"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-032-D5B2-D6F2"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-033-6CBE-D966"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-034-4AB3-6042"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-035-F7C5-1D77"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-036-8CF7-AD03"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-037-D623-EA25"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-038-09E7-C910"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-039-5EBB-254B"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-040-9E75-B6BE"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-041-98F5-3ADF"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-042-0978-34E3"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-043-BC16-7546"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-044-D36F-BB4E"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-045-0012-F220"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-046-1CE3-2094"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-047-5D9D-D3F8"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-048-FA4D-5CE4"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-049-CEA4-78D3"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-050-92B4-FC6B"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-051-7AE3-2103"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-052-3981-0D8E"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-053-4EDB-593B"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-054-23F3-7D00"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-055-4761-3EA0"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-056-0BE4-06D6"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-057-2187-7C50"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-058-989B-F622"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-059-4803-43E7"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-060-3CF5-9A67"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-061-2DD2-C6C6"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-062-B298-A9FE"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-063-C3BB-A0AD"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-064-5954-222E"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-065-A6F1-9786"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-066-6F9E-7BA0"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-067-4B7B-C04D"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-068-3410-5056"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-069-EF66-B3D6"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-070-5477-B6DF"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-071-07CC-4594"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-072-1678-98C7"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-073-286A-7A89"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-074-D278-0F01"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-075-D875-F927"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-076-7141-AB80"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-077-87FB-A581"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-078-0AF3-FF36"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-079-DCF1-AF19"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-080-A926-818D"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-081-7188-E26B"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-082-FD4B-3E21"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-083-6D1D-6A2E"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-084-6DBE-1CF2"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-085-B9FD-08EC"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-086-2D11-07AC"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-087-9E29-2A1F"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-088-499F-34D8"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-089-CB15-D590"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-090-1854-5ABC"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-091-C0CF-8D71"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-092-4539-A4DA"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-093-31F7-20FF"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-094-FF6E-3791"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-095-3011-39DC"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-096-E9BD-CC3E"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-097-F004-5015"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-098-FA70-0EB6"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-099-1810-C95F"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-30D-100-1C83-583F"] = {Days = 30, Label = "30 дней", Role = "Subscriber"},
    ["FAST-90D-001-E300-F544"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-002-9B29-3B86"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-003-3D26-88ED"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-004-2D2C-62CF"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-005-90D8-043B"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-006-FCC1-2EE8"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-007-CA2F-649C"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-008-44F9-8B80"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-009-27EE-A9AB"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-010-A7C0-2D8D"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-011-93DB-E40C"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-012-2AA8-58E9"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-013-6A45-1804"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-014-E2C9-DD0D"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-015-6F45-4758"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-016-F6F7-DE06"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-017-008E-891D"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-018-EB6E-A8E1"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-019-608A-58D5"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-020-0753-F092"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-021-DA4F-6DF9"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-022-73F2-6802"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-023-71C7-3A2E"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-024-394C-96AE"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-025-090E-3886"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-026-0125-9FAF"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-027-FE94-4708"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-028-C850-D507"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-029-A838-8642"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-030-6DD8-2704"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-031-BCB8-AB0C"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-032-0A13-724F"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-033-37E4-C041"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-034-36AF-600C"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-035-0104-D056"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-036-ABEC-E7E4"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-037-A5E2-ED8E"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-038-D6F6-25F3"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-039-A18C-E655"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-040-1B19-B824"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-041-9EE6-37D8"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-042-EBDB-DFA1"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-043-C4FB-09D9"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-044-5512-3E28"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-045-C521-A542"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-046-917F-0CDC"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-047-3F43-B90D"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-048-8E97-20AC"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-049-9EEB-E667"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-050-71B4-4D09"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-051-7930-2628"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-052-547B-C51B"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-053-2C0A-58BE"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-054-6CE3-CAFD"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-055-DE87-FC7F"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-056-180A-04AB"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-057-EF52-8B85"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-058-B0F2-4D74"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-059-638A-70FA"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-060-0BEB-E1C8"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-061-3756-CBE8"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-062-E50E-DFE8"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-063-9F8D-11E8"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-064-38DA-E4D3"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-065-8957-3F32"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-066-3EEF-3AA4"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-067-8BBF-32DA"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-068-1706-AA2B"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-069-F5B5-DF12"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-070-3785-FE83"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-071-F94C-DC56"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-072-4939-BABD"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-073-A0AB-7E1C"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-074-A794-A3B9"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-075-0AAE-66A2"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-076-834C-59CC"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-077-1654-ABEA"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-078-574D-E9D4"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-079-7E10-ECC5"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-080-AC96-D2D1"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-081-559E-4E77"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-082-EAA6-0711"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-083-DE6F-3DDF"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-084-791E-CB86"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-085-A8C4-ED0A"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-086-499D-CE65"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-087-896F-D502"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-088-7165-599C"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-089-DA0F-BF79"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-090-66EE-FDA0"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-091-5A4F-759F"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-092-8B86-6CED"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-093-819C-968C"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-094-2444-F8DD"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-095-7CCA-7233"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-096-BB6B-E6A0"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-097-514F-D698"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-098-6B9F-A40D"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-099-D75B-3B57"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-90D-100-770B-E38F"] = {Days = 90, Label = "90 дней", Role = "Subscriber"},
    ["FAST-LIFE-001-5E06-005C"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-002-A0D9-B320"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-003-CEA2-348B"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-004-3BC3-82EF"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-005-220B-9A3B"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-006-C210-A278"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-007-F31B-415D"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-008-3308-E496"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-009-A119-3A37"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-010-AD41-0019"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-011-2F3A-EECE"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-012-7027-E26F"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-013-6D9D-3468"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-014-182F-0029"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-015-3E64-C11A"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-016-89A9-B8CF"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-017-CF66-5B56"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-018-5972-A1DD"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-019-5909-D4FD"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-020-A381-3AEA"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-021-8895-31C0"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-022-422D-5BB7"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-023-8F73-461A"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-024-7568-C1B4"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-025-4F55-7E0F"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-026-F926-C975"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-027-FCC5-18A3"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-028-DCCC-B052"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-029-219D-CCDE"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-030-644D-4FEB"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-031-5242-D588"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-032-0596-E5C9"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-033-9903-7841"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-034-4162-2B38"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-035-FA47-0E61"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-036-F241-9218"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-037-5AED-045F"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-038-2609-664D"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-039-AEE0-9449"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-040-1D5A-A0CE"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-041-AB18-9FBD"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-042-2078-9FD3"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-043-56DB-EA34"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-044-4242-D949"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-045-1EC8-88CE"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-046-A352-B9EB"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-047-D321-9A5D"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-048-0282-406B"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-049-E433-9D81"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-050-34FD-7C9B"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-051-54F5-9B17"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-052-200E-EE26"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-053-2DD7-B000"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-054-BEE4-C2C9"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-055-253D-700A"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-056-3DB2-61CB"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-057-133D-9539"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-058-B5AB-9754"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-059-C076-2B67"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-060-40B2-CB2E"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-061-7137-FD30"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-062-F23A-AC62"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-063-803B-301A"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-064-0815-CA14"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-065-5EB3-2B2E"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-066-DB31-BAB5"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-067-A6D9-6714"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-068-FEB3-BC58"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-069-92AA-60CB"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-070-36DF-5211"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-071-A997-CCF3"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-072-68A8-682C"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-073-02DE-6996"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-074-E384-CA87"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-075-A122-314D"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-076-F955-B8A5"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-077-3B80-4E5E"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-078-89CF-180C"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-079-612C-F162"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-080-F0E6-D4F3"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-081-FCAC-C67C"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-082-AD8C-CBB8"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-083-6077-246D"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-084-26E4-24DD"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-085-E735-E269"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-086-930F-05AF"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-087-0566-5736"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-088-3507-AE5D"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-089-A9FB-2B9D"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-090-2113-91E6"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-091-5770-408D"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-092-DB0F-91FA"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-093-4B7E-8EDA"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-094-0D48-C917"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-095-16CE-C427"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-096-A8C7-10EB"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-097-D7C0-7994"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-098-B60F-2461"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-099-AC3C-F86C"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-LIFE-100-A14C-1D86"] = {Days = 9999, Label = "LifeTime ∞", Role = "Subscriber"},
    ["FAST-PREMIUM-001-16A0-BDA1"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-002-2AB7-2ADF"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-003-08D6-0D6E"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-004-D65C-D984"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-005-07F0-3CAF"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-006-AE22-A8F1"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-007-B9EC-A8AB"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-008-0B39-5170"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-009-8C1E-BE42"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-010-CCD4-C154"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-011-546A-AAF1"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-012-DDD8-32D0"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-013-A3C3-0108"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-014-CE90-1416"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-015-C83C-99D2"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-016-EBBA-7CF1"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-017-B043-2ABC"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-018-BC56-AD6B"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-019-7AEE-23B6"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-020-90FC-5481"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-021-2C84-946D"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-022-4840-98FF"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-023-2AAD-21B7"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-024-9B92-4A03"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-025-0889-0CC9"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-026-E41D-FE9B"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-027-E6DF-C460"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-028-8C15-B3F5"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-029-9B4F-DB01"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-030-3271-A0A4"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-031-5F6A-768E"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-032-4228-ED91"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-033-2C9F-9DC1"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-034-0D65-EFE8"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-035-4695-C415"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-036-9104-374C"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-037-42BE-EA95"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-038-261A-A3CF"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-039-6A95-BB24"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-040-C5BC-3907"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-041-5716-24B5"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-042-51D7-5F54"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-043-84FB-2C96"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-044-010A-1734"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-045-93F2-7DDA"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-046-B556-45E3"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-047-82D0-3A87"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-048-D29B-E1DF"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-049-E242-D910"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-050-25F7-9B65"] = {Days = 9999, Label = "Premium ∞", Role = "Premium"},
    ["FAST-PREMIUM-14D-001-3211-A39E"] = {Days = 14, Label = "Premium 14 дней", Role = "Premium"},
    ["FAST-PREMIUM-14D-002-6616-94F3"] = {Days = 14, Label = "Premium 14 дней", Role = "Premium"},
    ["FAST-PREMIUM-14D-003-42CC-EE9F"] = {Days = 14, Label = "Premium 14 дней", Role = "Premium"},
    ["FAST-PREMIUM-14D-004-B00D-CBC8"] = {Days = 14, Label = "Premium 14 дней", Role = "Premium"},
    ["FAST-PREMIUM-14D-005-77C4-E485"] = {Days = 14, Label = "Premium 14 дней", Role = "Premium"},
    ["FAST-PREMIUM-14D-006-1445-B90C"] = {Days = 14, Label = "Premium 14 дней", Role = "Premium"},
    ["FAST-PREMIUM-14D-007-1FA0-64F3"] = {Days = 14, Label = "Premium 14 дней", Role = "Premium"},
    ["FAST-PREMIUM-14D-008-F9E7-709F"] = {Days = 14, Label = "Premium 14 дней", Role = "Premium"},
    ["FAST-PREMIUM-14D-009-680A-2515"] = {Days = 14, Label = "Premium 14 дней", Role = "Premium"},
    ["FAST-PREMIUM-14D-010-6773-492B"] = {Days = 14, Label = "Premium 14 дней", Role = "Premium"},
    ["FAST-PREMIUM-30D-001-1E8A-336B"] = {Days = 30, Label = "Premium 30 дней", Role = "Premium"},
    ["FAST-PREMIUM-30D-002-E7B6-923A"] = {Days = 30, Label = "Premium 30 дней", Role = "Premium"},
    ["FAST-PREMIUM-30D-003-7F1E-CFE7"] = {Days = 30, Label = "Premium 30 дней", Role = "Premium"},
    ["FAST-PREMIUM-30D-004-33F2-BC27"] = {Days = 30, Label = "Premium 30 дней", Role = "Premium"},
    ["FAST-PREMIUM-30D-005-060C-5F1B"] = {Days = 30, Label = "Premium 30 дней", Role = "Premium"},
    ["FAST-PREMIUM-30D-006-49F0-CB16"] = {Days = 30, Label = "Premium 30 дней", Role = "Premium"},
    ["FAST-PREMIUM-30D-007-C3D1-51F6"] = {Days = 30, Label = "Premium 30 дней", Role = "Premium"},
    ["FAST-PREMIUM-30D-008-EBD5-984F"] = {Days = 30, Label = "Premium 30 дней", Role = "Premium"},
    ["FAST-PREMIUM-30D-009-5DA9-71F2"] = {Days = 30, Label = "Premium 30 дней", Role = "Premium"},
    ["FAST-PREMIUM-30D-010-D2F2-D98F"] = {Days = 30, Label = "Premium 30 дней", Role = "Premium"},
    ["FAST-PREMIUM-90D-001-37FD-B3A6"] = {Days = 90, Label = "Premium 90 дней", Role = "Premium"},
    ["FAST-PREMIUM-90D-002-3018-3354"] = {Days = 90, Label = "Premium 90 дней", Role = "Premium"},
    ["FAST-PREMIUM-90D-003-9691-3866"] = {Days = 90, Label = "Premium 90 дней", Role = "Premium"},
    ["FAST-PREMIUM-90D-004-B47B-8E1C"] = {Days = 90, Label = "Premium 90 дней", Role = "Premium"},
    ["FAST-PREMIUM-90D-005-D0F0-F871"] = {Days = 90, Label = "Premium 90 дней", Role = "Premium"},
    ["FAST-PREMIUM-90D-006-BF76-B299"] = {Days = 90, Label = "Premium 90 дней", Role = "Premium"},
    ["FAST-PREMIUM-90D-007-DBB9-B737"] = {Days = 90, Label = "Premium 90 дней", Role = "Premium"},
    ["FAST-PREMIUM-90D-008-B6A7-D388"] = {Days = 90, Label = "Premium 90 дней", Role = "Premium"},
    ["FAST-PREMIUM-90D-009-841B-6516"] = {Days = 90, Label = "Premium 90 дней", Role = "Premium"},
    ["FAST-PREMIUM-90D-010-9601-A57C"] = {Days = 90, Label = "Premium 90 дней", Role = "Premium"},
    ["FAST-ADMIN-7D-001-1A21-712D"] = {Days = 7, Label = "Админ 7 дней", Role = "Admin"},
    ["FAST-ADMIN-7D-002-CA6A-FC33"] = {Days = 7, Label = "Админ 7 дней", Role = "Admin"},
    ["FAST-ADMIN-7D-003-B87A-6D74"] = {Days = 7, Label = "Админ 7 дней", Role = "Admin"},
    ["FAST-ADMIN-7D-004-7158-D9AC"] = {Days = 7, Label = "Админ 7 дней", Role = "Admin"},
    ["FAST-ADMIN-7D-005-7A55-0674"] = {Days = 7, Label = "Админ 7 дней", Role = "Admin"},
    ["FAST-ADMIN-7D-006-928F-B12E"] = {Days = 7, Label = "Админ 7 дней", Role = "Admin"},
    ["FAST-ADMIN-7D-007-FDBC-7D84"] = {Days = 7, Label = "Админ 7 дней", Role = "Admin"},
    ["FAST-ADMIN-7D-008-63F7-D163"] = {Days = 7, Label = "Админ 7 дней", Role = "Admin"},
    ["FAST-ADMIN-7D-009-CD15-57C1"] = {Days = 7, Label = "Админ 7 дней", Role = "Admin"},
    ["FAST-ADMIN-7D-010-037A-5282"] = {Days = 7, Label = "Админ 7 дней", Role = "Admin"},
    ["FAST-OWNER-KEY-017318236"] = {Days = 9999, Label = "Owner ∞", Role = "Owner"}
}


-- MODULES (ПОЛНЫЙ СПИСОК)
local ModulesState = {
    Speed = {Active = false, Value = 50, Key = nil},
    Flight = {Active = false, Speed = 50, Key = nil},
    NoClip = {Active = false, Key = nil},
    Spider = {Active = false, Speed = 25, Key = nil},
    Strafe = {Active = false, Speed = 60, Key = nil},
    TargetStrafe = {Active = false, Speed = 150, Distance = 8, StickToPlayer = false, JumpOnTarget = false, Key = nil},
    AntiAim = {Active = false, Speed = 30, Key = nil},
    MotionBlur = {Active = false, Intensity = 15, Key = nil},
    NameTags = {Active = false, Color = Color3.fromRGB(255, 255, 255), Key = nil},
    ESPOutlines = {Active = false, Key = nil},
    ESPCommands = {Active = false, Key = nil},
    Chams = {Active = false, Key = nil},
    Tracers = {Active = false, Key = nil},
    Skeleton = {Active = false, Key = nil},
    Hitboxes = {Active = false, Size = 3, Key = nil},
    Arrows = {Active = false, Key = nil},
    Particles = {Active = false, Key = nil, Color = Color3.fromRGB(175, 100, 255), Count = 30, Speed = 10},
    ThirdPerson = {Active = false, Key = nil},
    Optimization = {Active = false, Key = nil},
    NoPush = {Active = false, Key = nil},
    ClientSound = {Active = true, Key = nil},
    BindList = {Active = true, Key = nil},
    InterfaceHUD = {Active = true, Key = nil},
    AutoClicker = {Active = false, CPS = 12, Key = nil},
    AutoFarm = {Active = false, Key = nil},
    AimAssist = {Active = false, Smoothness = 0.15, Key = nil},
    KickAura = {Active = false, Range = 15, CPS = 10, Key = nil},
    ["4KGraphics"] = {Active = false, Quality = "Ultra", Bloom = 0.35, Contrast = 0.12, Saturation = 0.08, SunRays = 0.08, DepthOfField = false, Atmosphere = true, Key = nil}
}

-- Config System
local Configs = {}
local CONFIG_FILE = "FastClient_Configs.json"

local function LoadConfigs()
    if readfile and isfile and isfile(CONFIG_FILE) then
        pcall(function()
            local raw = readfile(CONFIG_FILE)
            local data = HttpService:JSONDecode(raw)
            if type(data) == "table" then
                Configs = data
            end
        end)
    end
end

local function SaveConfigs()
    if writefile then
        pcall(function()
            writefile(CONFIG_FILE, HttpService:JSONEncode(Configs))
        end)
    end
end

local function GetCurrentConfig()
    local config = {}
    for name, mod in pairs(ModulesState) do
        if type(mod) == "table" then
            config[name] = {}
            for k, v in pairs(mod) do
                if type(v) ~= "function" and type(v) ~= "userdata" then
                    config[name][k] = v
                end
            end
        end
    end
    config._meta = {
        role = userRole,
        subExpiry = subExpiryTime,
        isAuthenticated = isAuthenticated
    }
    return config
end

local function ApplyConfig(config)
    if not config then return false end
    for name, modData in pairs(config) do
        if name ~= "_meta" and ModulesState[name] then
            for k, v in pairs(modData) do
                if ModulesState[name][k] ~= nil then
                    ModulesState[name][k] = v
                end
            end
        end
    end
    if config._meta then
        if config._meta.role then userRole = config._meta.role end
        if config._meta.subExpiry then subExpiryTime = config._meta.subExpiry end
        if config._meta.isAuthenticated ~= nil then isAuthenticated = config._meta.isAuthenticated end
        if UserRoleLabel then
            UserRoleLabel.Text = getRoleTitle(userRole)
            UserRoleLabel.TextColor3 = getRoleColor(userRole)
        end
        if SubTimeLabel then
            SubTimeLabel.Text = "⏱ " .. getTimeRemaining()
        end
        if AuthStatusLabel then
            AuthStatusLabel.Text = isAuthenticated and "✅ " .. U("АКТИВИРОВАН") or "🔒 " .. U("НЕ АКТИВИРОВАН")
            AuthStatusLabel.TextColor3 = isAuthenticated and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(255, 80, 80)
        end
        saveData()
    end
    renderModules(currentCategory, SearchBox.Text)
    RefreshBindList()
    return true
end

local function SaveConfig(name)
    name = string.gsub(name, "^%s*(.-)%s*$", "%1")
    if name == "" then return false, "❌ Имя не может быть пустым!" end
    if Configs[name] then
        return false, "❌ Конфиг с таким именем уже существует!"
    end
    Configs[name] = GetCurrentConfig()
    SaveConfigs()
    return true, "✅ Конфиг '" .. name .. "' сохранён!"
end

local function LoadConfig(name)
    if not Configs[name] then
        return false, "❌ Конфиг '" .. name .. "' не найден!"
    end
    ApplyConfig(Configs[name])
    return true, "✅ Конфиг '" .. name .. "' загружен!"
end

local function DeleteConfig(name)
    if not Configs[name] then
        return false, "❌ Конфиг не найден!"
    end
    Configs[name] = nil
    SaveConfigs()
    return true, "🗑️ Конфиг '" .. name .. "' удалён!"
end

local function ExportConfig(name)
    if not Configs[name] then
        return false, "❌ Конфиг не найден!"
    end
    local json = HttpService:JSONEncode(Configs[name])
    return true, json
end

local function ImportConfig(name, jsonString)
    name = string.gsub(name, "^%s*(.-)%s*$", "%1")
    if name == "" then return false, "❌ Имя не может быть пустым!" end
    if Configs[name] then
        return false, "❌ Конфиг с таким именем уже существует!"
    end
    local success, data = pcall(function()
        return HttpService:JSONDecode(jsonString)
    end)
    if not success or type(data) ~= "table" then
        return false, "❌ Неверный формат данных!"
    end
    Configs[name] = data
    SaveConfigs()
    return true, "✅ Конфиг '" .. name .. "' импортирован!"
end

LoadConfigs()

-- Helper Functions
local function loadData()
    if readfile and isfile and isfile("FastClient_Data.json") then
        pcall(function()
            local raw = readfile("FastClient_Data.json")
            local data = HttpService:JSONDecode(raw)
            if data then
                if data.Keys ~= nil then generatedKeys = data.Keys end
                if data.SubExpiry ~= nil then subExpiryTime = data.SubExpiry end
                if data.Role ~= nil then userRole = data.Role end
                if data.Authenticated ~= nil then isAuthenticated = data.Authenticated end
                if data.UsedKeys ~= nil then usedKeys = data.UsedKeys end
                if data.KeyExpiries ~= nil then keyExpiries = data.KeyExpiries end
            end
        end)
    end
end

local function saveData()
    if writefile then
        pcall(function()
            local data = {
                Keys = generatedKeys,
                SubExpiry = subExpiryTime,
                Role = userRole,
                Authenticated = isAuthenticated,
                UsedKeys = usedKeys,
                KeyExpiries = keyExpiries
            }
            writefile("FastClient_Data.json", HttpService:JSONEncode(data))
        end)
    end
end

local function generateRandomKey(days, prefix, format)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local parts = {}
    for i = 1, 3 do
        local part = ""
        for j = 1, 4 do
            part = part .. string.sub(chars, math.random(1, #chars), math.random(1, #chars))
        end
        parts[i] = part
    end
    if format == "subscriber" then
        return "FAST-" .. parts[1] .. "-" .. parts[2] .. "-" .. parts[3]
    elseif format == "premium" then
        return "FAST-PRM-" .. parts[1] .. "-" .. parts[2] .. "-" .. parts[3]
    else
        return prefix .. days .. "D-" .. parts[1] .. parts[2]:sub(1,2)
    end
end

-- ГЕНЕРАЦИЯ 231+ КЛЮЧЕЙ
local function generateAllKeys()
    local keys = {}
    
    -- Subscriber Keys (30+20+20+20+15+10+5 = 120 ключей)
    local subDays = {}
    for i = 1, 30 do table.insert(subDays, 1) end
    for i = 1, 20 do table.insert(subDays, 3) end
    for i = 1, 20 do table.insert(subDays, 7) end
    for i = 1, 20 do table.insert(subDays, 14) end
    for i = 1, 15 do table.insert(subDays, 30) end
    for i = 1, 10 do table.insert(subDays, 90) end
    for i = 1, 5 do table.insert(subDays, 180) end
    
    for i = 1, #subDays do
        local days = subDays[i]
        local key = generateRandomKey(days, "", "subscriber")
        keys[key] = {Days = days, Label = days .. " дней", Role = "Subscriber"}
    end
    
    -- Premium Keys: 14d / 30d / 90d / LifeTime
    local premDays = {}
    for i = 1, 25 do table.insert(premDays, 14) end
    for i = 1, 25 do table.insert(premDays, 30) end
    for i = 1, 25 do table.insert(premDays, 90) end
    for i = 1, 25 do table.insert(premDays, 9999) end

    for i = 1, #premDays do
        local days = premDays[i]
        local key = generateRandomKey(days, "", "premium")
        local label = (days == 9999) and "Premium LifeTime" or (days .. " дней (Premium)")
        keys[key] = {Days = days, Label = label, Role = "Premium"}
    end
    
    -- Admin Keys (20 случайных + 5 вечных = 25 ключей)
    for i = 1, 20 do
        local days = math.random(7, 365)
        local key = "ADMIN-" .. days .. "D-" .. string.upper(HttpService:GenerateGUID(false)):sub(1, 8)
        keys[key] = {Days = days, Label = "Админ " .. days .. " дней", Role = "Admin"}
    end
    
    for i = 1, 5 do
        keys["ADMIN-PERM-" .. string.upper(HttpService:GenerateGUID(false)):sub(1, 8)] = {Days = 9999, Label = "Админ ∞", Role = "Admin"}
    end
    
    return keys
end

loadData()

-- The distributable license inventory is deterministic and always present.
for licenseKey, licenseData in pairs(LICENSE_KEYS) do
    generatedKeys[licenseKey] = licenseData
end
saveData()

-- Require the license screen on every fresh script load.
-- Existing expiry timestamps are preserved, so re-entering the same key
-- does not silently extend its subscription.
isAuthenticated = false
userRole = "Player"

function getTimeRemaining()
    if not subExpiryTime then return L("NotActive") end
    if subExpiryTime == "∞" or subExpiryTime == 9999 then return "∞" end
    local remaining = math.max(0, math.floor(subExpiryTime - os.time()))
    if remaining <= 0 then return L("Expired") end
    local days = math.floor(remaining / 86400)
    local hours = math.floor((remaining % 86400) / 3600)
    local minutes = math.floor((remaining % 3600) / 60)
    local seconds = remaining % 60
    if currentLanguage == "EN" then
        return string.format("%dd %02dh %02dm %02ds", days, hours, minutes, seconds)
    end
    return string.format("%d дн. %02d ч. %02d мин. %02d сек.", days, hours, minutes, seconds)
end

-- Global elements
AuthStatusLabel = AuthStatusLabel
SearchBox = SearchBox
ActivateModalBtn = ActivateModalBtn
ActivateKeyBtn = ActivateKeyBtn
SubKeyBox = SubKeyBox
EnabledStatusLabel = EnabledStatusLabel
BindListFrame = BindListFrame
BindListContainer = BindListContainer
UserRoleLabel = UserRoleLabel
SubTimeLabel = SubTimeLabel

-- processKeyActivation
local function processKeyActivation(key)
    key = string.gsub(key, "^%s*(.-)%s*$", "%1")
    if key == "" then 
        return false, "❌ Введите ключ!"
    end

    if YOUTUBER_KEYS[key] then
        local data = YOUTUBER_KEYS[key]
        if usedKeys[key] then
            return false, "❌ Этот ключ уже использован!"
        end
        userRole = data.Role
        subTimeRemaining = data.Label
        subExpiryTime = "∞"
        isAuthenticated = true
        usedKeys[key] = true
        saveData()
        if AuthStatusLabel then
            AuthStatusLabel.Text = "✅ " .. U("АКТИВИРОВАН")
            AuthStatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
        end
        return true, "🔴 Активирован YOUTUBER!"
    end

    if ONE_TIME_KEYS[key] and usedKeys[key] then
        return false, "❌ Этот ключ уже был активирован!"
    end

    if FIXED_KEYS[key] then
        local data = FIXED_KEYS[key]
        
        if data.OneTime and usedKeys[key] then
            return false, "❌ Этот ключ уже использован!"
        end
        
        userRole = data.Role
        subTimeRemaining = data.Label
        if data.Days == 9999 then
            subExpiryTime = "∞"
        else
            subExpiryTime = os.time() + (data.Days * 86400)
        end
        isAuthenticated = true
        
        if data.OneTime then
            usedKeys[key] = true
        end
        
        saveData()
        if AuthStatusLabel then
            AuthStatusLabel.Text = "✅ " .. U("АКТИВИРОВАН")
            AuthStatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
        end
        return true, "✅ Активирован! Роль: " .. data.Label
    end

    if LICENSE_KEYS[key] then
        local data = LICENSE_KEYS[key]
        local savedExpiry = keyExpiries[key]

        if data.Days == 9999 then
            subExpiryTime = "∞"
            keyExpiries[key] = "∞"
        else
            if savedExpiry and savedExpiry ~= "∞" then
                if tonumber(savedExpiry) and tonumber(savedExpiry) <= os.time() then
                    return false, "❌ Срок действия этого ключа уже истёк!"
                end
                subExpiryTime = tonumber(savedExpiry)
            else
                subExpiryTime = os.time() + (data.Days * 86400)
                keyExpiries[key] = subExpiryTime
            end
        end

        userRole = data.Role
        subTimeRemaining = data.Label
        isAuthenticated = true
        saveData()

        if AuthStatusLabel then
            AuthStatusLabel.Text = "✅ " .. U("АКТИВИРОВАН")
            AuthStatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
        end
        return true, "✅ Активирован! Роль: " .. data.Label
    end

    if generatedKeys and generatedKeys[key] then
        local data = generatedKeys[key]
        userRole = data.Role or "Premium"
        subTimeRemaining = data.Label or "Активирован"
        if data.Days == 9999 then
            subExpiryTime = "∞"
        else
            subExpiryTime = os.time() + (data.Days * 86400)
        end
        generatedKeys[key] = nil
        isAuthenticated = true
        saveData()
        if AuthStatusLabel then
            AuthStatusLabel.Text = "✅ " .. U("АКТИВИРОВАН")
            AuthStatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
        end
        return true, "✅ Активирован! Роль: " .. data.Label
    end

    if key:match("^ADMIN%-%d+%-%w+%-%w+$") then
        local days = tonumber(key:match("ADMIN%-(%d+)"))
        if days and days > 0 then
            userRole = "Admin"
                subTimeRemaining = "Админ " .. days .. " дней"
            subExpiryTime = os.time() + (days * 86400)
            isAuthenticated = true
            saveData()
            if AuthStatusLabel then
                AuthStatusLabel.Text = "✅ " .. U("АКТИВИРОВАН")
                AuthStatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
            end
            return true, "👑 Активирован Админ (" .. days .. " дней)!"
        end
    end

    for _, ytKey in ipairs({"FAST-YT-2026-PERM", "FAST-YT-777-OMG", "FAST-YT-999-ULTRA", "FAST-YT-888-PRO", "FAST-YT-666-MEGA"}) do
        if string.upper(key) == string.upper(ytKey) then
            if usedKeys[key] then
                return false, "❌ Этот ключ уже использован!"
            end
            userRole = "YOUTUBER"
                subTimeRemaining = "YOUTUBER ∞"
            subExpiryTime = "∞"
            isAuthenticated = true
            usedKeys[key] = true
            saveData()
            if AuthStatusLabel then
                AuthStatusLabel.Text = "✅ " .. U("АКТИВИРОВАН")
                AuthStatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
            end
            return true, "🔴 Активирован YOUTUBER!"
        end
    end

    return false, "❌ Неверный ключ!"
end

local function checkSubscription()
    if not isAuthenticated then
        for _, m in pairs(ModulesState) do
            if type(m) == "table" and m.Active ~= nil then
                m.Active = false
            end
        end
        if AuthStatusLabel then
            AuthStatusLabel.Text = "🔒 " .. U("НЕ АКТИВИРОВАН")
            AuthStatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        end
        return
    end

    if subExpiryTime and subExpiryTime ~= "∞" and subExpiryTime ~= 9999 then
        if os.time() > subExpiryTime then
            isAuthenticated = false
            userRole = "Player"
            subExpiryTime = nil
            saveData()
            for _, m in pairs(ModulesState) do
                if type(m) == "table" and m.Active ~= nil then
                    m.Active = false
                end
            end
            if AuthStatusLabel then
                AuthStatusLabel.Text = "🔒 " .. U("НЕ АКТИВИРОВАН")
                AuthStatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            end
            print("⛔ Подписка истекла! Все модули отключены.")
        end
    end
end

task.spawn(function()
    while true do
        checkSubscription()
        task.wait(5)
    end
end)

-- Roles & Colors
local RoleRanks = {
    ["Player"] = 1,
    ["Subscriber"] = 2,
    ["Premium"] = 3,
    ["YOUTUBER"] = 4,
    ["Admin"] = 5,
    ["Owner"] = 6
}

local ColorBgMain = Color3.fromRGB(30, 15, 40)
local ColorSidebar = Color3.fromRGB(45, 20, 60)
local ColorAccent = Color3.fromRGB(175, 100, 255)
local ColorText = Color3.fromRGB(230, 230, 240)
local ColorSubText = Color3.fromRGB(150, 130, 170)

local ModuleColors = {
    Hitbox = Color3.fromRGB(255, 0, 100),
    Chams = Color3.fromRGB(175, 100, 255),
    ESPOutlines = Color3.fromRGB(0, 255, 200),
    Skeleton = Color3.fromRGB(255, 255, 255),
    Tracers = Color3.fromRGB(255, 200, 0),
    Particles = Color3.fromRGB(175, 100, 255),
    NameTags = Color3.fromRGB(255, 255, 255)
}

-- ESP Colors (4 круга: Зелёный, Красный, Синий, Фиолетовый)
local ESP_PRESET_COLORS = {
    Color3.fromRGB(50, 255, 120),   -- Зелёный
    Color3.fromRGB(255, 50, 50),    -- Красный
    Color3.fromRGB(50, 150, 255),   -- Синий
    Color3.fromRGB(175, 100, 255)   -- Фиолетовый
}

local function getRoleColor(role)
    if role == "Owner" then return Color3.fromRGB(255, 215, 0)
    elseif role == "Admin" then return Color3.fromRGB(255, 50, 80)
    elseif role == "YOUTUBER" then return Color3.fromRGB(255, 0, 0)
    elseif role == "Premium" then return Color3.fromRGB(255, 220, 0)
    elseif role == "Subscriber" then return Color3.fromRGB(100, 200, 255)
    else return Color3.fromRGB(180, 180, 180) end
end

local function getRoleTitle(role)
    if currentLanguage == "EN" then
        if role == "Owner" then return "Owner 👑"
        elseif role == "Admin" then return "Admin ⚡"
        elseif role == "YOUTUBER" then return "YOUTUBER 🟥"
        elseif role == "Premium" then return "Premium ⭐"
        elseif role == "Subscriber" then return "Subscriber 🎯"
        else return "Player" end
    end
    if role == "Owner" then return "Владелец 👑"
    elseif role == "Admin" then return "Админ ⚡"
    elseif role == "YOUTUBER" then return "YOUTUBER 🟥"
    elseif role == "Premium" then return "Премиум ⭐"
    elseif role == "Subscriber" then return "Subscriber 🎯"
    else return "Игрок" end
end

-- Premium Star
local function createPremiumStar(parent)
    local label = Instance.new("TextLabel")
    label.Name = "PremiumBadge"
    label.Parent = parent
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 4, 0, 16)
    label.Size = UDim2.new(0, 82, 0, 16)
    label.Font = Enum.Font.GothamBold
    label.Text = "⭐ PREMIUM"
    label.TextSize = 9
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextColor3 = Color3.fromRGB(255, 220, 40)

    local gradient = Instance.new("UIGradient")
    gradient.Name = "PremiumYellowBlackSweep"
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 235, 70)),
        ColorSequenceKeypoint.new(0.30, Color3.fromRGB(255, 195, 20)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(5, 5, 5)),
        ColorSequenceKeypoint.new(0.70, Color3.fromRGB(255, 195, 20)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 235, 70))
    })
    gradient.Offset = Vector2.new(-1, 0)
    gradient.Enabled = true
    gradient.Parent = label

    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextStrokeTransparency = 0.15

    task.spawn(function()
        local offset = -1
        while label and label.Parent do
            offset = offset + 0.022
            if offset > 1 then offset = -1 end
            gradient.Offset = Vector2.new(offset, 0)
            task.wait(0.016)
        end
    end)

    return label
end

-- ============================================================
-- ==== NAMETAGS (ПОКАЗЫВАЕТ НИК И HP) ====
-- ============================================================
local function GetNameTagText(player)
    return player.Name
end

local nameTagGuis = {}

local function createNameTag(player)
    local gui = Instance.new("BillboardGui")
    gui.Name = "FastClientNameTag"
    gui.Size = UDim2.new(0, 200, 0, 44)
    gui.AlwaysOnTop = true
    gui.StudsOffset = Vector3.new(0, 2.5, 0)
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Enabled = false
    gui.Parent = ScreenGui
    
    local frame = Instance.new("Frame")
    frame.Parent = gui
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BorderSizePixel = 0
    local fCorner = Instance.new("UICorner") 
    fCorner.CornerRadius = UDim.new(0, 4) 
    fCorner.Parent = frame
    
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Name = "NameLabel"
    nameLbl.Parent = frame
    nameLbl.BackgroundTransparency = 1
    nameLbl.Position = UDim2.new(0, 0, 0, 0)
    nameLbl.Size = UDim2.new(1, 0, 0, 20)
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.Text = GetNameTagText(player)
    nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLbl.TextSize = 14
    nameLbl.TextXAlignment = Enum.TextXAlignment.Center
    nameLbl.TextYAlignment = Enum.TextYAlignment.Center
    
    local healthBarBg = Instance.new("Frame")
    healthBarBg.Parent = frame
    healthBarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    healthBarBg.Position = UDim2.new(0, 5, 0, 20)
    healthBarBg.Size = UDim2.new(1, -10, 0, 4)
    healthBarBg.BorderSizePixel = 0
    local hbbCorner = Instance.new("UICorner")
    hbbCorner.CornerRadius = UDim.new(1, 0)
    hbbCorner.Parent = healthBarBg
    
    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBar"
    healthBar.Parent = healthBarBg
    healthBar.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BorderSizePixel = 0
    local hbCorner = Instance.new("UICorner")
    hbCorner.CornerRadius = UDim.new(1, 0)
    hbCorner.Parent = healthBar
    
    local hpText = Instance.new("TextLabel")
    hpText.Name = "HpText"
    hpText.Parent = frame
    hpText.BackgroundTransparency = 1
    hpText.Position = UDim2.new(0, 0, 0, 24)
    hpText.Size = UDim2.new(1, 0, 0, 18)
    hpText.Font = Enum.Font.GothamBold
    hpText.Text = "HP: ..."
    hpText.TextColor3 = Color3.fromRGB(255, 255, 255)
    hpText.TextSize = 10
    hpText.TextXAlignment = Enum.TextXAlignment.Center
    hpText.TextYAlignment = Enum.TextYAlignment.Center
    
    return gui
end

-- Надёжное чтение HP: сначала Humanoid, затем игровые Attributes/Value-объекты.
-- Это нужно для игр, где визуальное/сетевое здоровье хранится отдельно от Humanoid.Health.
local function ReadPlayerHealth(player)
    local char = player and player.Character
    if not char then return 0, 100 end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local humHp = hum and tonumber(hum.Health) or nil
    local humMax = hum and tonumber(hum.MaxHealth) or nil

    local healthNames = {
        health = true, hp = true, currenthealth = true, currenthp = true,
        healthvalue = true, current_health = true, current_hp = true
    }
    local maxNames = {
        maxhealth = true, maxhp = true, maximumhealth = true, healthmax = true,
        max_health = true, max_hp = true
    }

    local function numberFromValue(obj)
        if not obj then return nil end
        if obj:IsA("NumberValue") or obj:IsA("IntValue") then
            return tonumber(obj.Value)
        end
        if obj:IsA("StringValue") then
            return tonumber(obj.Value)
        end
        return nil
    end

    local function scan(container)
        local hp, maxHp
        if not container then return hp, maxHp end

        for name, _ in pairs(healthNames) do
            local v = container:GetAttribute(name)
            if typeof(v) == "number" then hp = v; break end
        end
        for name, _ in pairs(maxNames) do
            local v = container:GetAttribute(name)
            if typeof(v) == "number" then maxHp = v; break end
        end

        for _, obj in ipairs(container:GetDescendants()) do
            local n = string.lower(obj.Name):gsub("%s+", "")
            local value = numberFromValue(obj)
            if value ~= nil then
                if healthNames[n] and hp == nil then hp = value end
                if maxNames[n] and maxHp == nil then maxHp = value end
            end
            if hp ~= nil and maxHp ~= nil then break end
        end
        return hp, maxHp
    end

    -- Character is checked first because Lost Front-style games commonly replicate
    -- custom health values beneath the character while Humanoid.Health can stay stale.
    local customHp, customMax = scan(char)
    if customHp == nil or customHp <= 0 then
        local playerHp, playerMax = scan(player)
        if playerHp ~= nil and playerHp > 0 then customHp = playerHp end
        if customMax == nil then customMax = playerMax end
    end

    local hp = customHp
    local maxHp = customMax
    if hp == nil then hp = humHp end
    if maxHp == nil then maxHp = humMax end

    hp = tonumber(hp)
    maxHp = tonumber(maxHp)
    if maxHp == nil or maxHp <= 0 then maxHp = 100 end
    if hp == nil then hp = 0 end
    hp = math.clamp(hp, 0, maxHp)
    return hp, maxHp
end

-- Функция обновления всех NameTags
local function UpdateAllNameTags()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                local gui = nameTagGuis[player]
                if gui then
                    local frame = gui:FindFirstChildOfClass("Frame")
                    if frame then
                        local healthBar = frame:FindFirstChild("HealthBar")
                        local hpText = frame:FindFirstChild("HpText")
                        if healthBar and hpText then
                            local hp, maxHp = ReadPlayerHealth(player)
                            local hpPercent = math.clamp(hp / maxHp, 0, 1)
                            healthBar.Size = UDim2.new(hpPercent, 0, 1, 0)
                            hpText.Text = string.format("HP: %d/%d", math.floor(hp + 0.5), math.floor(maxHp + 0.5))
                            if hpPercent > 0.5 then
                                healthBar.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
                                hpText.TextColor3 = Color3.fromRGB(50, 255, 50)
                            elseif hpPercent > 0.25 then
                                healthBar.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
                                hpText.TextColor3 = Color3.fromRGB(255, 200, 0)
                            else
                                healthBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                                hpText.TextColor3 = Color3.fromRGB(255, 50, 50)
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Подключаем обновление HP при изменении здоровья
local function HookHumanoidHealth(player)
    if player ~= LocalPlayer and player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:GetPropertyChangedSignal("Health"):Connect(function()
                UpdateAllNameTags()
            end)
        end
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    HookHumanoidHealth(player)
end

Players.PlayerAdded:Connect(function(player)
    HookHumanoidHealth(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.15)
        HookHumanoidHealth(player)
        UpdateAllNameTags()
    end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function()
        task.wait(0.15)
        HookHumanoidHealth(player)
        UpdateAllNameTags()
    end)
end

RunService.RenderStepped:Connect(function()
    if not isAuthenticated or not ModulesState.NameTags.Active then
        for _, gui in pairs(nameTagGuis) do
            if gui then gui.Enabled = false end
        end
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if not nameTagGuis[player] then
                nameTagGuis[player] = createNameTag(player)
            end
            local gui = nameTagGuis[player]
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")

            if hrp and hum then
                gui.Parent = hrp
                gui.Enabled = true
                local frame = gui:FindFirstChildOfClass("Frame")
                if frame then
                    local nameLbl = frame:FindFirstChild("NameLabel")
                    local healthBar = frame:FindFirstChild("HealthBar")
                    local hpText = frame:FindFirstChild("HpText")
                    if nameLbl then
                        nameLbl.Text = GetNameTagText(player)
                        nameLbl.TextColor3 = ModulesState.NameTags.Color
                    end
                    -- Читаем Humanoid.Health каждый кадр, поэтому старое 100%
                    -- не может остаться после получения урона или смерти.
                    if healthBar and hpText then
                        local hp, maxHp = ReadPlayerHealth(player)
                        local hpPercent = math.clamp(hp / maxHp, 0, 1)
                        healthBar.Size = UDim2.new(hpPercent, 0, 1, 0)
                        hpText.Text = string.format("HP: %d/%d", math.floor(hp + 0.5), math.floor(maxHp + 0.5))
                        if hpPercent > 0.5 then
                            healthBar.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
                            hpText.TextColor3 = Color3.fromRGB(50, 255, 50)
                        elseif hpPercent > 0.25 then
                            healthBar.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
                            hpText.TextColor3 = Color3.fromRGB(255, 200, 0)
                        else
                            healthBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                            hpText.TextColor3 = Color3.fromRGB(255, 50, 50)
                        end
                    end
                end
            else
                gui.Enabled = false
                gui.Parent = nil
            end
        end
    end
end)

-- ============================================================
-- ==== ARROWS (СТРЕЛКИ + РАССТОЯНИЕ) ====
-- ============================================================
local arrowsCache = {}
local arrowsDistanceText = {}

local function CreateArrow(player)
    local arrow = Drawing.new("Triangle")
    arrow.Thickness = 2
    arrow.Color = ModuleColors.Tracers or Color3.fromRGB(255, 200, 0)
    arrow.Transparency = 0.8
    arrow.Filled = true
    arrow.Visible = false
    arrowsCache[player] = arrow
    
    local distText = Drawing.new("Text")
    distText.Size = 14
    distText.Center = true
    distText.Outline = true
    distText.OutlineColor = Color3.fromRGB(0, 0, 0)
    distText.Color = Color3.fromRGB(255, 255, 255)
    distText.Transparency = 1
    distText.Visible = false
    arrowsDistanceText[player] = distText
    
    return arrow
end

local function UpdateArrows()
    if not isAuthenticated or not ModulesState.Arrows.Active then
        for _, arrow in pairs(arrowsCache) do
            if arrow then arrow.Visible = false end
        end
        for _, text in pairs(arrowsDistanceText) do
            if text then text.Visible = false end
        end
        return
    end

    Camera = Workspace.CurrentCamera or Camera
    local viewportSize = Camera.ViewportSize
    local center = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    local localChar = LocalPlayer.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end
    local playerPos = localRoot.Position

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local arrow = arrowsCache[player]
            local distText = arrowsDistanceText[player]
            if not arrow then arrow = CreateArrow(player) end
            if not distText then
                distText = Drawing.new("Text")
                distText.Size = 14
                distText.Center = true
                distText.Outline = true
                distText.OutlineColor = Color3.fromRGB(0, 0, 0)
                distText.Color = Color3.fromRGB(255, 255, 255)
                distText.Transparency = 1
                distText.Visible = false
                arrowsDistanceText[player] = distText
            end

            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and hum and hum.Health > 0 then
                local distance = (hrp.Position - playerPos).Magnitude
                local distString = string.format("%.1fм", distance)
                local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                local pos

                if onScreen and vector.Z > 0 then
                    pos = Vector2.new(vector.X, vector.Y)
                else
                    -- Project the target direction into camera screen-space. This also works
                    -- when the player is behind the camera, unlike WorldToViewportPoint alone.
                    local rel = hrp.Position - Camera.CFrame.Position
                    local right = Camera.CFrame.RightVector
                    local up = Camera.CFrame.UpVector
                    local x = rel:Dot(right)
                    local y = rel:Dot(up)
                    if vector.Z < 0 then
                        x = -x
                        y = -y
                    end
                    local dir2 = Vector2.new(x, -y)
                    if dir2.Magnitude < 0.001 then
                        dir2 = Vector2.new(0, -1)
                    else
                        dir2 = dir2.Unit
                    end
                    local margin = 34
                    local halfW = viewportSize.X / 2 - margin
                    local halfH = viewportSize.Y / 2 - margin
                    local tx = math.huge
                    local ty = math.huge
                    if math.abs(dir2.X) > 0.001 then tx = halfW / math.abs(dir2.X) end
                    if math.abs(dir2.Y) > 0.001 then ty = halfH / math.abs(dir2.Y) end
                    local scale = math.min(tx, ty)
                    pos = center + dir2 * scale
                end

                local size = onScreen and 16 or 15
                arrow.PointA = pos + Vector2.new(0, -size)
                arrow.PointB = pos + Vector2.new(-size / 1.8, size / 1.5)
                arrow.PointC = pos + Vector2.new(size / 1.8, size / 1.5)
                arrow.Color = ModuleColors.Tracers or Color3.fromRGB(255, 200, 0)
                arrow.Visible = true

                distText.Position = Vector2.new(pos.X, pos.Y + size + 8)
                distText.Text = distString
                distText.Color = Color3.fromRGB(255, 255, 255)
                distText.Visible = true
            else
                arrow.Visible = false
                distText.Visible = false
            end
        end
    end
end

RunService.RenderStepped:Connect(UpdateArrows)

-- PARTICLES (улучшенные)
local particleConnection = nil

local function CreateWorldParticle()
    local part = Instance.new("Part")
    part.Size = Vector3.new(0.4, 0.4, 0.4)
    part.Shape = Enum.PartType.Ball
    part.Material = Enum.Material.Neon
    part.Color = ModulesState.Particles.Color or ModuleColors.Particles or Color3.fromRGB(175, 100, 255)
    part.Transparency = 0.25
    part.CanCollide = false
    part.Anchored = false
    part.Parent = Workspace
    
    local char = LocalPlayer.Character
    local radius = math.random(30, 150)
    local angle = math.random() * 2 * math.pi
    local height = math.random(0, 80)
    
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        part.Position = hrp.Position + Vector3.new(math.cos(angle) * radius, height, math.sin(angle) * radius)
    else
        part.Position = Vector3.new(math.random(-100, 100), math.random(5, 80), math.random(-100, 100))
    end
    
    local speed = ModulesState.Particles.Speed or 10
    local vel = Vector3.new(
        math.random(-speed, speed),
        math.random(-speed/3, speed),
        math.random(-speed, speed)
    )
    part.Velocity = vel
    
    game:GetService("Debris"):AddItem(part, 60)
    return part
end

local function StartParticles()
    if particleConnection then return end
    
    local count = ModulesState.Particles.Count or 30
    for i = 1, math.min(count, 100) do
        task.wait(0.02)
        CreateWorldParticle()
    end
    
    particleConnection = RunService.Heartbeat:Connect(function()
        if not isAuthenticated or not ModulesState.Particles.Active then
            StopParticles()
            return
        end
        if math.random(1, 2) == 1 then
            CreateWorldParticle()
        end
    end)
end

local function StopParticles()
    if particleConnection then
        particleConnection:Disconnect()
        particleConnection = nil
    end
    for _, part in ipairs(Workspace:GetChildren()) do
        if part:IsA("BasePart") and part.Size == Vector3.new(0.4, 0.4, 0.4) and part.Material == Enum.Material.Neon then
            part:Destroy()
        end
    end
end

RunService.Heartbeat:Connect(function()
    if ModulesState.Particles.Active and isAuthenticated then
        if not particleConnection then
            StartParticles()
        end
    else
        if particleConnection then
            StopParticles()
        end
    end
end)

-- ============================================================
-- ==== SPIDER — АККУРАТНОЕ ЛАЗАНИЕ ПО СТЕНАМ ====
-- Space near a wall climbs like a ladder. At the top edge the player
-- gets a short hop and is released instead of being pinned to the edge.
-- ============================================================
local spiderConnection = nil
local spiderReleaseUntil = 0

local function StopSpider()
    if spiderConnection then
        spiderConnection:Disconnect()
        spiderConnection = nil
    end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = true
        hum.PlatformStand = false
        if not ModulesState.Speed.Active then hum.WalkSpeed = 16 end
    end
end

local function StartSpider()
    StopSpider()
    spiderConnection = RunService.Heartbeat:Connect(function()
        if not isAuthenticated or not ModulesState.Spider.Active then
            StopSpider()
            return
        end

        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hum or not hrp then return end

        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {char}

        local look = hrp.CFrame.LookVector
        local flatLook = Vector3.new(look.X, 0, look.Z)
        if flatLook.Magnitude < 0.05 then flatLook = Vector3.new(0, 0, -1) end
        flatLook = flatLook.Unit

        -- Find a wall directly in front and slightly around the character.
        local wall = Workspace:Raycast(hrp.Position + Vector3.new(0, 0.8, 0), flatLook * 3.2, params)
        if not wall then
            wall = Workspace:Raycast(hrp.Position + Vector3.new(0, 1.8, 0), flatLook * 3.2, params)
        end

        local floor = Workspace:Raycast(hrp.Position, Vector3.new(0, -3.5, 0), params)
        local speed = math.clamp(tonumber(ModulesState.Spider.Speed) or 25, 16, 50)

        if wall and wall.Instance and wall.Instance.CanCollide then
            -- Stay glued to the wall instead of dropping to the ground.
            local normal = wall.Normal
            local tangent = Vector3.new(-normal.Z, 0, normal.X)
            local climbY = 0

            if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                climbY = speed
            elseif UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                climbY = -speed
            end

            local side = 0
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then side -= 1 end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then side += 1 end

            -- A small inward velocity keeps the character attached to the surface.
            local stick = -normal * 4
            local velocity = tangent * (side * speed * 0.65) + Vector3.new(0, climbY, 0) + stick
            hrp.AssemblyLinearVelocity = velocity
            hum.AutoRotate = false
            hum:ChangeState(Enum.HumanoidStateType.Climbing)

            -- Once the player reaches the ground, release the wall naturally.
            if floor and climbY <= 0 and math.abs(hrp.AssemblyLinearVelocity.Y) < 1.5 then
                hum.AutoRotate = true
                hum:ChangeState(Enum.HumanoidStateType.Landed)
                hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
            end
            return
        end

        -- No wall: do not force Climbing; normal gravity takes over.
        hum.AutoRotate = true
        if hum:GetState() == Enum.HumanoidStateType.Climbing then
            hum:ChangeState(Enum.HumanoidStateType.Freefall)
        end
    end)
end

RunService.Heartbeat:Connect(function()
    if ModulesState.Spider.Active and isAuthenticated then
        if not spiderConnection then StartSpider() end
    elseif spiderConnection then
        StopSpider()
    end
end)

-- ============================================================
-- ==== AIMASSIST (ЖЁСТКИЙ LOCK-ON НА ВЫБРАННУЮ ЦЕЛЬ) ====
-- ============================================================
local AIM_MAX_DISTANCE = 100
local AIM_FOV_PIXELS = 450
local lockedAimPlayer = nil

local function ClearAimLock()
    lockedAimPlayer = nil
end

local function GetClosestHead()
    local bestHead = nil
    local bestWorldDistance = math.huge
    local bestScreenDistance = math.huge
    local mousePos = UserInputService:GetMouseLocation()
    local localChar = LocalPlayer.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
    if not localRoot then return nil end

    Camera = Workspace.CurrentCamera or Camera
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local character = player.Character
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local head = character:FindFirstChild("Head")
            local root = character:FindFirstChild("HumanoidRootPart")
            if humanoid and head and root and humanoid.Health > 0 then
                local worldDistance = (root.Position - localRoot.Position).Magnitude
                if worldDistance <= AIM_MAX_DISTANCE then
                    local screenPoint, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen and screenPoint.Z > 0 then
                        local screenDistance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                        if screenDistance <= AIM_FOV_PIXELS then
                            -- Реальная 3D-дистанция имеет приоритет: 2м цель
                            -- не будет заменена целью в 100м только из-за прицела.
                            if worldDistance < bestWorldDistance or
                               (math.abs(worldDistance - bestWorldDistance) < 0.01 and screenDistance < bestScreenDistance) then
                                bestWorldDistance = worldDistance
                                bestScreenDistance = screenDistance
                                bestHead = head
                            end
                        end
                    end
                end
            end
        end
    end
    return bestHead
end

local function GetLockedAimHead()
    -- После первого захвата цель больше НЕ зависит от положения мыши/FOV.
    -- Вращение мышью не сбрасывает lock и не заставляет AimAssist искать другую цель.
    if lockedAimPlayer then
        local character = lockedAimPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local head = character and character:FindFirstChild("Head")
        if humanoid and head and humanoid.Health > 0 then
            return head
        end
        ClearAimLock()
    end

    local firstHead = GetClosestHead()
    if firstHead then
        lockedAimPlayer = Players:GetPlayerFromCharacter(firstHead.Parent)
        return firstHead
    end
    return nil
end

RunService.RenderStepped:Connect(function(dt)
    if not isAuthenticated then
        ClearAimLock()
        return
    end

    if ModulesState.AimAssist.Active and RoleRanks[userRole] >= RoleRanks["Premium"] then
        local targetHead = GetLockedAimHead()
        if targetHead and targetHead.Parent then
            local smoothness = math.clamp(ModulesState.AimAssist.Smoothness or 0.15, 0.01, 1)
            local smooth = 1 - ((1 - smoothness) ^ (60 * dt))
            local targetCF = CFrame.new(Camera.CFrame.Position, targetHead.Position)
            -- Постоянно возвращаем камеру к ЗАФИКСИРОВАННОЙ цели.
            -- Поэтому ручное вращение мышью не срывает захват.
            Camera.CFrame = Camera.CFrame:Lerp(targetCF, smooth)
        end
    else
        ClearAimLock()
    end
end)

-- MOTIONBLUR (camera turn + actual movement speed)
local lastCameraCFrame = Camera.CFrame
local lastCameraPosition = Camera.CFrame.Position
local blurEffect = Lighting:FindFirstChild("FastClientMotionBlur")
if not blurEffect then
    blurEffect = Instance.new("BlurEffect")
    blurEffect.Name = "FastClientMotionBlur"
    blurEffect.Parent = Lighting
end

RunService.RenderStepped:Connect(function(dt)
    Camera = Workspace.CurrentCamera or Camera
    if not isAuthenticated or not ModulesState.MotionBlur.Active then
        blurEffect.Size = 0
        lastCameraCFrame = Camera.CFrame
        lastCameraPosition = Camera.CFrame.Position
        return
    end

    local currentCF = Camera.CFrame
    local dot = math.clamp(currentCF.LookVector:Dot(lastCameraCFrame.LookVector), -1, 1)
    local angle = math.acos(dot)
    local cameraTravel = (currentCF.Position - lastCameraPosition).Magnitude
    local charTravel = 0
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        charTravel = root.AssemblyLinearVelocity.Magnitude * dt
    end

    lastCameraCFrame = currentCF
    lastCameraPosition = currentCF.Position

    local intensity = math.clamp(tonumber(ModulesState.MotionBlur.Intensity) or 15, 1, 40)
    local rotationalBlur = angle * intensity * 75
    local movementBlur = math.clamp((cameraTravel + charTravel) / math.max(dt, 1 / 240) * 0.055 * intensity, 0, 36)
    local targetBlur = math.clamp(rotationalBlur + movementBlur, 0, 48)
    local smooth = math.clamp(dt * 14, 0, 1)
    blurEffect.Size = blurEffect.Size + (targetBlur - blurEffect.Size) * smooth
end)

-- THIRD PERSON
RunService.RenderStepped:Connect(function()
    if ModulesState.ThirdPerson.Active and isAuthenticated then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            local offset = hrp.CFrame.LookVector * -8 + Vector3.new(0, 3, 0)
            Camera.CFrame = CFrame.new(hrp.Position + offset, hrp.Position)
        end
    end
end)

-- OPTIMIZATION
RunService.Heartbeat:Connect(function()
    if ModulesState.Optimization.Active then
        settings().Rendering.QualityLevel = 1
    else
        settings().Rendering.QualityLevel = 21
    end
end)

-- ============================================================
-- ==== NOPUSH (ОТТАЛКИВАНИЕ ОТ ИГРОКОВ ОТКЛЮЧЕНО) ====
-- ============================================================
local noPushConstraints = {}

local function ClearNoPushConstraints()
    for plrId, constraint in pairs(noPushConstraints) do
        if constraint and constraint.Parent then
            pcall(function() constraint:Destroy() end)
        end
    end
    noPushConstraints = {}
end

RunService.Heartbeat:Connect(function()
    if not isAuthenticated or not ModulesState.NoPush.Active then
        ClearNoPushConstraints()
        return
    end
    
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not root then return end
    
    for _, otherPlr in ipairs(Players:GetPlayers()) do
        if otherPlr ~= LocalPlayer and otherPlr.Character then
            local otherRoot = otherPlr.Character:FindFirstChild("HumanoidRootPart")
            if otherRoot then
                local pId = otherPlr.UserId
                if not noPushConstraints[pId] or not noPushConstraints[pId].Parent then
                    local noCol = Instance.new("NoCollisionConstraint")
                    noCol.Part0 = root
                    noCol.Part1 = otherRoot
                    noCol.Parent = root
                    noPushConstraints[pId] = noCol
                end
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if noPushConstraints[plr.UserId] then
        pcall(function() noPushConstraints[plr.UserId]:Destroy() end)
        noPushConstraints[plr.UserId] = nil
    end
end)

-- ============================================================
-- ==== TARGET HUD (УДАЛЁН) ====
-- ============================================================
-- (Код TargetHUD полностью удалён)

-- ============================================================
-- ============================================================
-- ==== HITBOXES (ВОЗВРАТ СТАРОЙ ВЕРСИИ) ====
-- ============================================================
local function ApplyHitboxes()
    if not isAuthenticated or not ModulesState.Hitboxes.Active then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                if root and root:IsA("BasePart") then
                    root.Size = Vector3.new(2, 1, 1)
                    root.Transparency = 0
                    root.CanCollide = false
                end
            end
        end
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root and root:IsA("BasePart") then
                local size = math.clamp(tonumber(ModulesState.Hitboxes.Size) or 3, 2, 200)
                root.Size = Vector3.new(size, size, size)
                root.Transparency = 0.3
                root.CanCollide = false
            end
        end
    end
end

RunService.Heartbeat:Connect(ApplyHitboxes)

-- ============================================================
-- ==== SPEED (РАБОЧИЙ) ====
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not isAuthenticated or not ModulesState.Speed.Active then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = ModulesState.Speed.Value end
end)

-- ============================================================
-- ==== KICK AURA ====
-- Best-effort client-side launch. The local player is never a target.
-- In Roblox, a LocalScript cannot force server-owned player physics;
-- this uses every client-side physics route that is available.
-- ============================================================
local lastAttackTime = 0

local function getKickDirection(origin, target)
    local delta = target - origin
    if delta.Magnitude < 0.001 then
        return Vector3.new(0, 1, 0)
    end
    return delta.Unit
end

local function tryKickTarget(targetCharacter, sourceRoot)
    if not targetCharacter or not sourceRoot then return false end
    if targetCharacter == LocalPlayer.Character then return false end

    local targetHumanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
    local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
    if not targetHumanoid or not targetRoot or targetHumanoid.Health <= 0 then
        return false
    end

    local distance = (targetRoot.Position - sourceRoot.Position).Magnitude
    if distance > ModulesState.KickAura.Range then
        return false
    end

    local direction = getKickDirection(sourceRoot.Position, targetRoot.Position)
    -- Fixed KickAura range: 15 studs. No distance slider.
    local launch = direction * 115 + Vector3.new(0, 165, 0)

    -- Best-effort client-side physics kick. Server-owned assemblies may ignore this.
    pcall(function()
        targetRoot.AssemblyLinearVelocity = launch
        targetRoot.AssemblyAngularVelocity = Vector3.new(0, 45, 0)
    end)

    pcall(function()
        targetRoot:ApplyImpulse(
            (direction * 7000 + Vector3.new(0, 11000, 0)) * targetRoot.AssemblyMass
        )
    end)

    pcall(function()
        targetHumanoid:ChangeState(Enum.HumanoidStateType.FallingDown)
    end)

    if type(setscriptable) == "function" then
        pcall(function()
            setscriptable(targetRoot, "AssemblyLinearVelocity", true)
            targetRoot.AssemblyLinearVelocity = launch
        end)
    end

    return true
end

RunService.Heartbeat:Connect(function()
    if not isAuthenticated or not ModulesState.KickAura.Active then return end
    if (RoleRanks[userRole] or 0) < RoleRanks["Premium"] then return end

    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local nearestRoot, nearestDist = nil, ModulesState.KickAura.Range + 0.001
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetHum = player.Character:FindFirstChildOfClass("Humanoid")
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if targetHum and targetRoot and targetHum.Health > 0 then
                local d = (targetRoot.Position - root.Position).Magnitude
                if d <= ModulesState.KickAura.Range and d < nearestDist then
                    nearestRoot, nearestDist = targetRoot, d
                end
            end
        end
    end
    if not nearestRoot then return end

    -- Fast orbit around the target. The local character physically spins around them.
    local offset = root.Position - nearestRoot.Position
    local flat = Vector3.new(offset.X, 0, offset.Z)
    if flat.Magnitude < 0.05 then flat = Vector3.new(1,0,0) end
    local tangent = Vector3.new(-flat.Z, 0, flat.X).Unit
    local spinSpeed = 70 + math.clamp(ModulesState.KickAura.CPS or 10, 1, 30) * 5
    local radial = flat.Unit * ((math.clamp(nearestDist, 2.5, 7) - nearestDist) * 12)
    root.AssemblyLinearVelocity = tangent * spinSpeed + radial
    root.CFrame = CFrame.lookAt(root.Position, nearestRoot.Position)

    local now = os.clock()
    local interval = 1 / math.max(1, ModulesState.KickAura.CPS or 10)
    if now - lastAttackTime >= interval then
        lastAttackTime = now
        pcall(function()
            local dir = nearestRoot.Position - root.Position
            dir = dir.Magnitude > 0.05 and dir.Unit or Vector3.new(0,1,0)
            nearestRoot:ApplyImpulse((dir * 110 + Vector3.new(0,145,0)) * nearestRoot.AssemblyMass)
            nearestRoot.AssemblyLinearVelocity = dir * 105 + Vector3.new(0,120,0)
        end)
    end
end)


-- ============================================================
-- 4K GRAPHICS CONTROLLER
-- Uses Roblox post-processing/lighting effects rather than fake UI-only graphics.
-- ============================================================
local FourKGraphicsController = {
    Saved = {},
    Active = false
}

local function findOrCreateEffect(className, name)
    local existing = Lighting:FindFirstChild(name)
    if existing and existing:IsA(className) then
        return existing, false
    end
    local effect = Instance.new(className)
    effect.Name = name
    effect.Parent = Lighting
    return effect, true
end

local function enable4KGraphics()
    if FourKGraphicsController.Active then return end
    FourKGraphicsController.Active = true

    local bloom, bloomCreated = findOrCreateEffect("BloomEffect", "FastClient_4K_Bloom")
    local cc, ccCreated = findOrCreateEffect("ColorCorrectionEffect", "FastClient_4K_Color")
    local rays, raysCreated = findOrCreateEffect("SunRaysEffect", "FastClient_4K_SunRays")
    local dof, dofCreated = findOrCreateEffect("DepthOfFieldEffect", "FastClient_4K_DOF")
    local atmosphere, atmosphereCreated = findOrCreateEffect("Atmosphere", "FastClient_4K_Atmosphere")

    FourKGraphicsController.Saved = {
        GlobalShadows = Lighting.GlobalShadows,
        Technology = Lighting.Technology,
        Brightness = Lighting.Brightness,
        ExposureCompensation = Lighting.ExposureCompensation,
        ClockTime = Lighting.ClockTime,
        FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart,
        ShadowSoftness = Lighting.ShadowSoftness,
        EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
        Effects = {
            bloom = {obj = bloom, created = bloomCreated, Intensity = bloom.Intensity, Size = bloom.Size, Threshold = bloom.Threshold, Enabled = bloom.Enabled},
            cc = {obj = cc, created = ccCreated, Brightness = cc.Brightness, Contrast = cc.Contrast, Saturation = cc.Saturation, TintColor = cc.TintColor, Enabled = cc.Enabled},
            rays = {obj = rays, created = raysCreated, Intensity = rays.Intensity, Spread = rays.Spread, Enabled = rays.Enabled},
            dof = {obj = dof, created = dofCreated, FarIntensity = dof.FarIntensity, FocusDistance = dof.FocusDistance, InFocusRadius = dof.InFocusRadius, NearIntensity = dof.NearIntensity, Enabled = dof.Enabled},
            atmosphere = {obj = atmosphere, created = atmosphereCreated, Density = atmosphere.Density, Offset = atmosphere.Offset, Color = atmosphere.Color, Decay = atmosphere.Decay, Glare = atmosphere.Glare, Haze = atmosphere.Haze}
        }
    }

    -- Real-time shadow pipeline: Future + GlobalShadows + soft shadow tuning.
    -- This is the part that makes 4K GRAPHICS visibly change the scene lighting.
    pcall(function() Lighting.GlobalShadows = true end)
    pcall(function() Lighting.Technology = Enum.Technology.Future end)
    pcall(function() Lighting.ShadowSoftness = 0.08 end)
    pcall(function() Lighting.EnvironmentDiffuseScale = 0.72 end)
    pcall(function() Lighting.EnvironmentSpecularScale = 1.0 end)
    pcall(function() Lighting.Brightness = 2.0 end)
    pcall(function() Lighting.ExposureCompensation = 0.08 end)

    bloom.Intensity = ModulesState["4KGraphics"].Bloom
    bloom.Size = 32
    bloom.Threshold = 0.65
    bloom.Enabled = true

    cc.Brightness = 0.02
    cc.Contrast = ModulesState["4KGraphics"].Contrast
    cc.Saturation = ModulesState["4KGraphics"].Saturation
    cc.TintColor = Color3.fromRGB(255, 248, 255)
    cc.Enabled = true

    rays.Intensity = ModulesState["4KGraphics"].SunRays
    rays.Spread = 0.75
    rays.Enabled = true

    dof.Enabled = ModulesState["4KGraphics"].DepthOfField
    dof.FarIntensity = 0.08
    dof.NearIntensity = 0.02
    dof.FocusDistance = 35
    dof.InFocusRadius = 45

    atmosphere.Density = ModulesState["4KGraphics"].Atmosphere and 0.22 or 0.05
    atmosphere.Offset = 0.1
    atmosphere.Color = Color3.fromRGB(205, 215, 255)
    atmosphere.Decay = Color3.fromRGB(120, 125, 150)
    atmosphere.Glare = 0.08
    atmosphere.Haze = 0.35
end

local function disable4KGraphics()
    if not FourKGraphicsController.Active then return end
    FourKGraphicsController.Active = false

    local saved = FourKGraphicsController.Saved
    pcall(function() Lighting.GlobalShadows = saved.GlobalShadows end)
    pcall(function() Lighting.Technology = saved.Technology end)
    pcall(function() Lighting.Brightness = saved.Brightness end)
    pcall(function() Lighting.ExposureCompensation = saved.ExposureCompensation end)
    pcall(function() Lighting.ClockTime = saved.ClockTime end)
    pcall(function() Lighting.FogEnd = saved.FogEnd end)
    pcall(function() Lighting.FogStart = saved.FogStart end)
    pcall(function() Lighting.ShadowSoftness = saved.ShadowSoftness end)
    pcall(function() Lighting.EnvironmentDiffuseScale = saved.EnvironmentDiffuseScale end)
    pcall(function() Lighting.EnvironmentSpecularScale = saved.EnvironmentSpecularScale end)

    if saved.Effects then
        for _, data in pairs(saved.Effects) do
            local obj = data.obj
            if obj and obj.Parent then
                pcall(function()
                    for property, value in pairs(data) do
                        if property ~= "obj" and property ~= "created" and property ~= "Enabled" then
                            obj[property] = value
                        end
                    end
                    if data.Enabled ~= nil then obj.Enabled = data.Enabled end
                end)
                if data.created then
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end
    FourKGraphicsController.Saved = {}
end

RunService.RenderStepped:Connect(function()
    if not isAuthenticated then return end
    local state = ModulesState["4KGraphics"]
    if not state then return end
    if state.Active then
        if not FourKGraphicsController.Active then
            enable4KGraphics()
        end
    elseif FourKGraphicsController.Active then
        disable4KGraphics()
    end
end)

-- MAIN UI
-- renderModules/renderCategories are assigned below and intentionally global so language/theme refreshes can call them.
-- Forward references are resolved as globals in the functions above.
renderModules = renderModules
renderCategories = renderCategories

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 13, 25)
MainFrame.BackgroundTransparency = 0.02
MainFrame.Position = UDim2.new(0.5, -320, 0.5, -220)
MainFrame.Size = UDim2.new(0, 640, 0, 440)
MainFrame.Visible = true
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner") MainCorner.CornerRadius = UDim.new(0, 12) MainCorner.Parent = MainFrame
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(118, 78, 165)
MainStroke.Thickness = 1
MainStroke.Transparency = 0.28
MainStroke.Parent = MainFrame
local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 18, 39)),
    ColorSequenceKeypoint.new(0.55, Color3.fromRGB(19, 14, 27)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 10, 17))
})
MainGradient.Rotation = 18
MainGradient.Parent = MainFrame

local TopHeaderBar = Instance.new("Frame")
TopHeaderBar.Name = "TopHeaderBar"
TopHeaderBar.Parent = MainFrame
TopHeaderBar.BackgroundColor3 = Color3.fromRGB(30, 20, 41)
TopHeaderBar.BackgroundTransparency = 0.08
TopHeaderBar.Size = UDim2.new(1, 0, 0, 36)
TopHeaderBar.ZIndex = 50
local thbc = Instance.new("UICorner") thbc.CornerRadius = UDim.new(0, 12) thbc.Parent = TopHeaderBar
local HeaderLine = Instance.new("Frame")
HeaderLine.Parent = TopHeaderBar
HeaderLine.BackgroundColor3 = ColorAccent
HeaderLine.BackgroundTransparency = 0.55
HeaderLine.BorderSizePixel = 0
HeaderLine.Position = UDim2.new(0, 54, 1, -1)
HeaderLine.Size = UDim2.new(1, -70, 0, 1)

local FastLogo = Instance.new("TextLabel")
FastLogo.Name = "FastLogo"
FastLogo.Parent = TopHeaderBar
FastLogo.BackgroundTransparency = 1
FastLogo.Position = UDim2.new(0, 10, 0, 0)
FastLogo.Size = UDim2.new(0, 28, 0, 36)
FastLogo.Font = Enum.Font.GothamBold
FastLogo.Text = "F"
FastLogo.TextColor3 = ColorAccent
FastLogo.TextSize = 28
FastLogo.TextXAlignment = Enum.TextXAlignment.Left
FastLogo.Rotation = 0

-- Only the single header F animates: smooth left swing up to -35° and returns to 0°.
task.spawn(function()
    while FastLogo and FastLogo.Parent do
        local phase = (tick() * 1.35) % (math.pi * 2)
        local swing = (math.sin(phase) + 1) * 0.5
        FastLogo.Rotation = -35 * swing
        task.wait(0.016)
    end
end)

-- ============================================================
-- ==== STATIC HEADER TITLE ====
-- ============================================================
local FastLettersContainer = Instance.new("Frame")
FastLettersContainer.Parent = TopHeaderBar
FastLettersContainer.BackgroundTransparency = 1
FastLettersContainer.Position = UDim2.new(0, 82, 0, 0)
FastLettersContainer.Size = UDim2.new(0, 300, 0, 36)
FastLettersContainer.ZIndex = 10

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Name = "HeaderTitle"
HeaderTitle.Parent = FastLettersContainer
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Position = UDim2.new(0, 0, 0, 0)
HeaderTitle.Size = UDim2.new(1, 0, 1, 0)
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.Text = "FAST CLIENT 2.1"
HeaderTitle.TextColor3 = Color3.fromRGB(238, 228, 255)
HeaderTitle.TextSize = 15
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.TextYAlignment = Enum.TextYAlignment.Center

local HeaderVersion = Instance.new("TextLabel")
HeaderVersion.Parent = FastLettersContainer
HeaderVersion.BackgroundTransparency = 1
HeaderVersion.Position = UDim2.new(0, 128, 0, 0)
HeaderVersion.Size = UDim2.new(0, 80, 1, 0)
HeaderVersion.Font = Enum.Font.GothamMedium
HeaderVersion.Text = "BETA"
HeaderVersion.TextColor3 = ColorAccent
HeaderVersion.TextSize = 10
HeaderVersion.TextXAlignment = Enum.TextXAlignment.Left
HeaderVersion.TextYAlignment = Enum.TextYAlignment.Center

-- ============================================================
-- ==== СНЕГ ПАДАЕТ СВЕРХУ ВНИЗ ====
-- ============================================================
local function createSnowParticle(container)
    local particle = Instance.new("Frame")
    particle.Parent = container
    particle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    particle.BackgroundTransparency = 0.3
    local size = math.random(2, 5)
    particle.Size = UDim2.new(0, size, 0, size)
    local posX = math.random(0, 100) / 100
    particle.Position = UDim2.new(posX, 0, 0, -10)
    local pCorner = Instance.new("UICorner")
    pCorner.CornerRadius = UDim.new(1, 0)
    pCorner.Parent = particle
    
    task.spawn(function()
        local speed = math.random(15, 40) / 100
        local drift = math.random(-20, 20) / 100
        local xPos = posX
        local yPos = -10
        
        while particle and particle.Parent do
            yPos = yPos + speed
            xPos = xPos + drift / 10
            if xPos > 1 then xPos = 0 end
            if xPos < 0 then xPos = 1 end
            particle.Position = UDim2.new(xPos, 0, 0, yPos)
            particle.Rotation = particle.Rotation + math.random(-2, 2)
            if yPos > 100 then
                particle:Destroy()
                break
            end
            task.wait(0.05)
        end
    end)
    
    return particle
end

-- Снежинки на всё меню
local SnowContainer = Instance.new("Frame")
SnowContainer.Parent = MainFrame
SnowContainer.BackgroundTransparency = 1
SnowContainer.Position = UDim2.new(0, 0, 0, 0)
SnowContainer.Size = UDim2.new(1, 0, 1, 0)
SnowContainer.ZIndex = 100
SnowContainer.ClipsDescendants = false

task.spawn(function()
    while true do
        if math.random(1, 3) == 1 then
            createSnowParticle(SnowContainer)
        end
        task.wait(0.08)
    end
end)

local function MakeDraggable(guiElement, handleElement)
    local handle = handleElement or guiElement
    local dragging, dragInput, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiElement.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            guiElement.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

MakeDraggable(MainFrame, TopHeaderBar)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = ColorSidebar
Sidebar.BackgroundTransparency = 0.2
Sidebar.Position = UDim2.new(0, 0, 0, 36)
Sidebar.Size = UDim2.new(0, 180, 1, -36)
Sidebar.ZIndex = 2

local UserFrame = Instance.new("Frame")
UserFrame.Parent = Sidebar
UserFrame.BackgroundTransparency = 1
UserFrame.Position = UDim2.new(0, 8, 0, 8)
UserFrame.Size = UDim2.new(1, -16, 0, 55)

local UserName = Instance.new("TextLabel")
UserName.Parent = UserFrame
UserName.BackgroundTransparency = 1
UserName.Size = UDim2.new(1, 0, 0, 18)
UserName.Font = Enum.Font.GothamBold
UserName.Text = LocalPlayer.Name
UserName.TextColor3 = ColorText
UserName.TextSize = 12
UserName.TextXAlignment = Enum.TextXAlignment.Left

UserRoleLabel = Instance.new("TextLabel")
UserRoleLabel.Parent = UserFrame
UserRoleLabel.BackgroundTransparency = 1
UserRoleLabel.Position = UDim2.new(0, 0, 0, 18)
UserRoleLabel.Size = UDim2.new(1, 0, 0, 16)
UserRoleLabel.Font = Enum.Font.GothamMedium
UserRoleLabel.Text = getRoleTitle(userRole)
UserRoleLabel.TextColor3 = getRoleColor(userRole)
UserRoleLabel.TextSize = 10
UserRoleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Animated privilege badge: the whole role text (Premium/Admin/Owner) shimmers.
local RoleSweepGradient = Instance.new("UIGradient")
RoleSweepGradient.Name = "RoleYellowBlackSweep"
RoleSweepGradient.Parent = UserRoleLabel
RoleSweepGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 235, 70)),
    ColorSequenceKeypoint.new(0.30, Color3.fromRGB(255, 195, 20)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(8, 8, 8)),
    ColorSequenceKeypoint.new(0.70, Color3.fromRGB(255, 195, 20)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 235, 70))
})
RoleSweepGradient.Offset = Vector2.new(-1, 0)
UserRoleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
UserRoleLabel.TextStrokeTransparency = 0.12

task.spawn(function()
    local offset = -1
    while UserRoleLabel and UserRoleLabel.Parent do
        local activeRole = userRole
        if activeRole == "Premium" or activeRole == "Admin" or activeRole == "Owner" then
            if activeRole == "Admin" then
                RoleSweepGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 110, 120)),
                    ColorSequenceKeypoint.new(0.30, Color3.fromRGB(255, 45, 65)),
                    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(5, 5, 5)),
                    ColorSequenceKeypoint.new(0.70, Color3.fromRGB(255, 45, 65)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 110, 120))
                })
            else
                RoleSweepGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 235, 70)),
                    ColorSequenceKeypoint.new(0.30, Color3.fromRGB(255, 195, 20)),
                    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(8, 8, 8)),
                    ColorSequenceKeypoint.new(0.70, Color3.fromRGB(255, 195, 20)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 235, 70))
                })
            end
            RoleSweepGradient.Enabled = true
            offset = offset + 0.014
            if offset > 1 then offset = -1 end
            RoleSweepGradient.Offset = Vector2.new(offset, 0)
        else
            RoleSweepGradient.Enabled = false
            UserRoleLabel.TextColor3 = getRoleColor(activeRole)
        end
        task.wait(0.03)
    end
end)

SubTimeLabel = Instance.new("TextLabel")
SubTimeLabel.Parent = UserFrame
SubTimeLabel.BackgroundTransparency = 1
SubTimeLabel.Position = UDim2.new(0, 0, 0, 34)
SubTimeLabel.Size = UDim2.new(1, 0, 0, 16)
SubTimeLabel.Font = Enum.Font.GothamMedium
SubTimeLabel.Text = "⏱ " .. getTimeRemaining()
SubTimeLabel.TextColor3 = ColorSubText
SubTimeLabel.TextSize = 10
SubTimeLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Robust live countdown: recomputes from the absolute expiry timestamp.
task.spawn(function()
    while SubTimeLabel and SubTimeLabel.Parent do
        local ok, remainingText = pcall(getTimeRemaining)
        if ok then
            SubTimeLabel.Text = "⏱ " .. tostring(remainingText)
        end
        task.wait(0.25)
    end
end)


local CatContainer = Instance.new("ScrollingFrame")
CatContainer.Parent = Sidebar
CatContainer.BackgroundTransparency = 1
CatContainer.Position = UDim2.new(0, 8, 0, 68)
CatContainer.Size = UDim2.new(1, -16, 0, 200)
CatContainer.CanvasSize = UDim2.new(0, 0, 0, 300)
CatContainer.ScrollBarThickness = 2

local CatLayout = Instance.new("UIListLayout") CatLayout.Parent = CatContainer CatLayout.Padding = UDim.new(0, 4)

local categoryKeys = {"Combat", "Visuals", "Movement", "HUD", "Settings", "Configs"}
local currentCategory = "Combat"

SearchBox = Instance.new("TextBox")
SearchBox.Parent = Sidebar
SearchBox.BackgroundColor3 = ColorBgMain
SearchBox.Position = UDim2.new(0, 8, 1, -88)
SearchBox.Size = UDim2.new(1, -16, 0, 26)
SearchBox.Font = Enum.Font.Gotham
SearchBox.PlaceholderText = L("Search")
SearchBox.Text = ""
SearchBox.TextColor3 = ColorText
SearchBox.TextSize = 10
local SearchCorner = Instance.new("UICorner") SearchCorner.CornerRadius = UDim.new(0, 6) SearchCorner.Parent = SearchBox

AuthStatusLabel = Instance.new("TextLabel")
AuthStatusLabel.Name = "AuthStatusLabel"
AuthStatusLabel.Parent = Sidebar
AuthStatusLabel.BackgroundTransparency = 1
AuthStatusLabel.Position = UDim2.new(0, 8, 1, -60)
AuthStatusLabel.Size = UDim2.new(1, -16, 0, 18)
AuthStatusLabel.Font = Enum.Font.GothamBold
AuthStatusLabel.Text = isAuthenticated and "✅ " .. U("АКТИВИРОВАН") or "🔒 " .. U("НЕ АКТИВИРОВАН")
AuthStatusLabel.TextColor3 = isAuthenticated and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(255, 80, 80)
AuthStatusLabel.TextSize = 11
AuthStatusLabel.TextXAlignment = Enum.TextXAlignment.Center

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    renderModules(currentCategory, SearchBox.Text)
end)

KeyBtn = Instance.new("TextButton")
KeyBtn.Parent = Sidebar
KeyBtn.BackgroundColor3 = ColorAccent
KeyBtn.BackgroundTransparency = 0.3
KeyBtn.Position = UDim2.new(0, 15, 0.93, 0)
KeyBtn.Size = UDim2.new(0, 150, 0, 26)
KeyBtn.Font = Enum.Font.GothamBold
KeyBtn.Text = "🔑 " .. L("Activate") .. " " .. (currentLanguage == "RU" and "ключ" or "key")
KeyBtn.TextColor3 = ColorText
KeyBtn.TextSize = 10
local kbCorner = Instance.new("UICorner") kbCorner.CornerRadius = UDim.new(0, 6) kbCorner.Parent = KeyBtn

-- Activation Modal
local ActivateModal = Instance.new("Frame")
ActivateModal.Parent = ScreenGui
ActivateModal.BackgroundColor3 = Color3.fromRGB(19, 14, 27)
ActivateModal.Position = UDim2.new(0.5, -170, 0.5, -105)
ActivateModal.Size = UDim2.new(0, 340, 0, 210)
ActivateModal.Visible = false
ActivateModal.ZIndex = 1000
local amc = Instance.new("UICorner") amc.CornerRadius = UDim.new(0, 12) amc.Parent = ActivateModal
local ams = Instance.new("UIStroke") ams.Color = Color3.fromRGB(112, 76, 151) ams.Thickness = 1 ams.Transparency = 0.2 ams.Parent = ActivateModal
local amg = Instance.new("UIGradient")
amg.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 22, 47)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 12, 23))
})
amg.Rotation = 90
amg.Parent = ActivateModal

AmTitle = Instance.new("TextLabel")
AmTitle.Parent = ActivateModal
AmTitle.BackgroundTransparency = 1
AmTitle.Position = UDim2.new(0, 15, 0, 15)
AmTitle.Size = UDim2.new(1, -30, 0, 24)
AmTitle.Font = Enum.Font.GothamBold
AmTitle.Text = "🔑 " .. L("AuthTitle")
AmTitle.TextColor3 = ColorText
AmTitle.TextSize = 15
AmTitle.TextXAlignment = Enum.TextXAlignment.Left

local KeyInputBox = Instance.new("TextBox")
KeyInputBox.Parent = ActivateModal
KeyInputBox.BackgroundColor3 = ColorSidebar
KeyInputBox.Position = UDim2.new(0, 15, 0, 55)
KeyInputBox.Size = UDim2.new(1, -30, 0, 35)
KeyInputBox.Font = Enum.Font.Gotham
KeyInputBox.PlaceholderText = L("AuthPlaceholder")
KeyInputBox.Text = ""
KeyInputBox.TextColor3 = ColorText
KeyInputBox.PlaceholderColor3 = ColorSubText
KeyInputBox.TextSize = 13
KeyInputBox.ClearTextOnFocus = false
local kibc = Instance.new("UICorner") kibc.CornerRadius = UDim.new(0, 6) kibc.Parent = KeyInputBox

ActivateModalBtn = Instance.new("TextButton")
ActivateModalBtn.Parent = ActivateModal
ActivateModalBtn.BackgroundColor3 = ColorAccent
ActivateModalBtn.Position = UDim2.new(0, 15, 0, 105)
ActivateModalBtn.Size = UDim2.new(1, -30, 0, 32)
ActivateModalBtn.Font = Enum.Font.GothamBold
ActivateModalBtn.Text = L("Activate")
ActivateModalBtn.TextColor3 = ColorBgMain
ActivateModalBtn.TextSize = 13
local abcc = Instance.new("UICorner") abcc.CornerRadius = UDim.new(0, 6) abcc.Parent = ActivateModalBtn

local CloseAmBtn = Instance.new("TextButton")
CloseAmBtn.Parent = ActivateModal
CloseAmBtn.BackgroundTransparency = 1
CloseAmBtn.Position = UDim2.new(1, -30, 0, 10)
CloseAmBtn.Size = UDim2.new(0, 20, 0, 20)
CloseAmBtn.Font = Enum.Font.GothamBold
CloseAmBtn.Text = "X"
CloseAmBtn.TextColor3 = ColorSubText
CloseAmBtn.TextSize = 14

CloseAmBtn.MouseButton1Click:Connect(function()
    if isAuthenticated then ActivateModal.Visible = false end
end)

ActivateModalBtn.MouseButton1Click:Connect(function()
    local key = KeyInputBox.Text
    local success, msg = processKeyActivation(key)
    if success then
        ActivateModalBtn.Text = "✅ " .. msg
        ActivateModalBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
        UserRoleLabel.Text = getRoleTitle(userRole)
        UserRoleLabel.TextColor3 = getRoleColor(userRole)
        SubTimeLabel.Text = "⏱ " .. getTimeRemaining()
        task.wait(1.5)
        ActivateModal.Visible = false
        MainFrame.Visible = true
        ActivateModalBtn.Text = L("Activate")
        ActivateModalBtn.BackgroundColor3 = ColorAccent
        renderModules(currentCategory, SearchBox.Text)
    else
        ActivateModalBtn.Text = msg
        ActivateModalBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        task.wait(1.5)
        ActivateModalBtn.Text = L("Activate")
        ActivateModalBtn.BackgroundColor3 = ColorAccent
    end
end)

KeyBtn.MouseButton1Click:Connect(function()
    ActivateModal.Visible = true
    KeyInputBox.Text = ""
    ActivateModalBtn.Text = L("Activate")
    ActivateModalBtn.BackgroundColor3 = ColorAccent
    task.wait(0.1)
    KeyInputBox:CaptureFocus()
end)

-- Content
local ContentPanel = Instance.new("ScrollingFrame")
ContentPanel.Parent = MainFrame
ContentPanel.BackgroundTransparency = 1
ContentPanel.Position = UDim2.new(0, 190, 0, 44)
ContentPanel.Size = UDim2.new(1, -380, 1, -52)
ContentPanel.CanvasSize = UDim2.new(0, 0, 0, 1200)
ContentPanel.ScrollBarThickness = 3

local ContentLayout = Instance.new("UIListLayout") ContentLayout.Parent = ContentPanel ContentLayout.Padding = UDim.new(0, 6)

-- Deco Panel
local DecoPanel = Instance.new("Frame")
DecoPanel.Parent = MainFrame
DecoPanel.BackgroundColor3 = ColorSidebar
DecoPanel.BackgroundTransparency = 0.2
DecoPanel.Position = UDim2.new(1, -190, 0, 36)
DecoPanel.Size = UDim2.new(0, 190, 1, -36)
DecoPanel.ClipsDescendants = true
DecoPanel.ZIndex = 2

local fastLettersDeco = {}
local fastLettersDataDeco = {
    {Char = "F", Y = 20},
    {Char = "A", Y = 65},
    {Char = "S", Y = 110},
    {Char = "T", Y = 155}
}

for _, lInfo in ipairs(fastLettersDataDeco) do
    local lLabel = Instance.new("TextLabel")
    lLabel.Parent = DecoPanel
    lLabel.BackgroundTransparency = 1
    lLabel.Position = UDim2.new(0.5, -30, 0, lInfo.Y)
    lLabel.Size = UDim2.new(0, 60, 0, 50)
    lLabel.Font = Enum.Font.GothamBold
    lLabel.Text = lInfo.Char
    lLabel.TextColor3 = ColorText
    lLabel.TextSize = 40
    lLabel.TextTransparency = 0.5
    lLabel.ZIndex = 10
    lLabel.TextXAlignment = Enum.TextXAlignment.Center
    table.insert(fastLettersDeco, lLabel)
end

for _, lbl in ipairs(fastLettersDeco) do
    lbl.Rotation = 0
    lbl.TextTransparency = 0.58
end

-- Existing F A S T letters only: smooth sway and continuous black <-> white sweep.
task.spawn(function()
    local t = 0
    while DecoPanel and DecoPanel.Parent do
        t = t + 0.016
        for i, lbl in ipairs(fastLettersDeco) do
            local phase = t * 1.45 + (i - 1) * 0.72
            lbl.Position = UDim2.new(0.5, -30 + math.sin(phase) * 14, 0, fastLettersDataDeco[i].Y)
            lbl.Rotation = math.sin(phase * 0.95) * 35
            local wave = (math.sin(phase * 0.72) + 1) * 0.5
            local gray = math.floor(4 + wave * 251)
            lbl.TextColor3 = Color3.fromRGB(gray, gray, gray)
            lbl.TextTransparency = 0.08 + (1 - wave) * 0.22
        end
        task.wait(0.016)
    end
end)

SubKeyBox = Instance.new("TextBox") 
SubKeyBox.Parent = DecoPanel 
SubKeyBox.BackgroundColor3 = ColorBgMain 
SubKeyBox.Position = UDim2.new(0, 12, 0.6, 0) 
SubKeyBox.Size = UDim2.new(1, -24, 0, 26) 
SubKeyBox.Font = Enum.Font.Gotham 
SubKeyBox.PlaceholderText = "🔑 " .. L("EnterKey") 
SubKeyBox.Text = "" 
SubKeyBox.TextColor3 = ColorText 
SubKeyBox.TextSize = 10
local skbc = Instance.new("UICorner") skbc.CornerRadius = UDim.new(0, 5) skbc.Parent = SubKeyBox

ActivateKeyBtn = Instance.new("TextButton") 
ActivateKeyBtn.Parent = DecoPanel 
ActivateKeyBtn.BackgroundColor3 = ColorAccent 
ActivateKeyBtn.Position = UDim2.new(0, 12, 0.7, 0) 
ActivateKeyBtn.Size = UDim2.new(1, -24, 0, 26) 
ActivateKeyBtn.Font = Enum.Font.GothamBold 
ActivateKeyBtn.Text = L("Activate") 
ActivateKeyBtn.TextColor3 = ColorBgMain 
ActivateKeyBtn.TextSize = 11
SubKeyBox.Visible = false
ActivateKeyBtn.Visible = false
local akbc = Instance.new("UICorner") akbc.CornerRadius = UDim.new(0, 5) akbc.Parent = ActivateKeyBtn

EnabledStatusLabel = Instance.new("TextLabel") 
EnabledStatusLabel.Parent = DecoPanel 
EnabledStatusLabel.BackgroundTransparency = 1 
EnabledStatusLabel.Position = UDim2.new(0, 10, 0.82, 0) 
EnabledStatusLabel.Size = UDim2.new(1, -20, 0, 30) 
EnabledStatusLabel.Font = Enum.Font.GothamMedium 
EnabledStatusLabel.Text = L("ModuleDisabled") 
EnabledStatusLabel.TextColor3 = ColorSubText 
EnabledStatusLabel.TextSize = 10 
EnabledStatusLabel.TextWrapped = true

ActivateKeyBtn.MouseButton1Click:Connect(function()
    local key = SubKeyBox.Text
    local success, msg = processKeyActivation(key)
    if success then
        EnabledStatusLabel.Text = msg
        SubKeyBox.Text = ""
        UserRoleLabel.Text = getRoleTitle(userRole)
        UserRoleLabel.TextColor3 = getRoleColor(userRole)
        SubTimeLabel.Text = "⏱ " .. getTimeRemaining()
        renderModules(currentCategory, SearchBox.Text)
    else
        EnabledStatusLabel.Text = msg
    end
end)


-- License gate: after the script finishes loading, the key menu is the first screen.
-- The main menu stays hidden until a valid license is accepted.
MainFrame.Visible = false
ActivateModal.Visible = false
CloseAmBtn.Visible = false
KeyInputBox.Visible = true
KeyInputBox.Text = ""

-- Loading screen finishes first; then the license window is shown.
task.delay(2.15, function()
    if not ScreenGui.Parent then return end
    MainFrame.Visible = false
    ActivateModal.Visible = true
    KeyInputBox.Text = ""
    pcall(function()
        KeyInputBox:CaptureFocus()
    end)
end)

-- KeyBinds panel - compact Zenith-style layout.
local BindListGUI = Instance.new("ScreenGui")
BindListGUI.Name = "BindListGUI"
BindListGUI.Parent = CoreGui
BindListGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

BindListFrame = Instance.new("Frame")
BindListFrame.Name = "KeyBindsPanel"
BindListFrame.Parent = BindListGUI
BindListFrame.Size = UDim2.new(0, 205, 0, 178)
BindListFrame.Position = UDim2.new(1, -220, 0, 12)
BindListFrame.BackgroundColor3 = ColorBgMain
BindListFrame.BackgroundTransparency = 0.08
BindListFrame.Visible = true
BindListFrame.ZIndex = 100
BindListFrame.ClipsDescendants = true
local blCorner = Instance.new("UICorner") blCorner.CornerRadius = UDim.new(0, 8) blCorner.Parent = BindListFrame
local blStroke = Instance.new("UIStroke") blStroke.Color = ColorAccent blStroke.Thickness = 1 blStroke.Transparency = 0.3 blStroke.Parent = BindListFrame
local blGradient = Instance.new("UIGradient")
blGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 19, 31)), ColorSequenceKeypoint.new(1, Color3.fromRGB(13, 11, 18))})
blGradient.Rotation = 90
blGradient.Parent = BindListFrame

BindTitle = Instance.new("TextLabel")
BindTitle.Parent = BindListFrame
BindTitle.BackgroundTransparency = 1
BindTitle.Position = UDim2.new(0, 10, 0, 6)
BindTitle.Size = UDim2.new(1, -42, 0, 18)
BindTitle.Font = Enum.Font.GothamBold
BindTitle.Text = "⌨  " .. U("KeyBinds")
BindTitle.TextColor3 = ColorText
BindTitle.TextSize = 11
BindTitle.TextXAlignment = Enum.TextXAlignment.Left

local BindIcon = Instance.new("TextLabel")
BindIcon.Parent = BindListFrame
BindIcon.BackgroundColor3 = ColorAccent
BindIcon.BackgroundTransparency = 0.15
BindIcon.Position = UDim2.new(1, -28, 0, 6)
BindIcon.Size = UDim2.new(0, 18, 0, 18)
BindIcon.Font = Enum.Font.GothamBold
BindIcon.Text = "⌨"
BindIcon.TextColor3 = Color3.fromRGB(255,255,255)
BindIcon.TextSize = 9
local bic = Instance.new("UICorner") bic.CornerRadius = UDim.new(0, 4) bic.Parent = BindIcon

local BindHeaderLine = Instance.new("Frame")
BindHeaderLine.Parent = BindListFrame
BindHeaderLine.BackgroundColor3 = ColorAccent
BindHeaderLine.BackgroundTransparency = 0.55
BindHeaderLine.BorderSizePixel = 0
BindHeaderLine.Position = UDim2.new(0, 10, 0, 28)
BindHeaderLine.Size = UDim2.new(1, -20, 0, 1)

BindListContainer = Instance.new("ScrollingFrame")
BindListContainer.Parent = BindListFrame
BindListContainer.BackgroundTransparency = 1
BindListContainer.BorderSizePixel = 0
BindListContainer.Position = UDim2.new(0, 7, 0, 34)
BindListContainer.Size = UDim2.new(1, -14, 1, -40)
BindListContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
BindListContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
BindListContainer.ScrollBarThickness = 2
BindListContainer.ScrollBarImageColor3 = ColorAccent
BindListContainer.ScrollingDirection = Enum.ScrollingDirection.Y

local BindListLayout = Instance.new("UIListLayout")
BindListLayout.Parent = BindListContainer
BindListLayout.Padding = UDim.new(0, 3)

function UpdateBindList()
    for _, child in ipairs(BindListContainer:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then child:Destroy() end
    end

    local bound = {}
    for name, state in pairs(ModulesState) do
        if type(state) == "table" and state.Key then
            table.insert(bound, {name = name, key = state.Key.Name, active = state.Active == true})
        end
    end
    table.sort(bound, function(a,b) return a.name < b.name end)

    if #bound == 0 then
        local empty = Instance.new("TextLabel")
        empty.Parent = BindListContainer
        empty.Size = UDim2.new(1, 0, 0, 28)
        empty.BackgroundTransparency = 1
        empty.Font = Enum.Font.GothamMedium
        empty.Text = U("Нет активных биндов")
        empty.TextColor3 = ColorSubText
        empty.TextSize = 9
        empty.TextXAlignment = Enum.TextXAlignment.Center
        return
    end

    for _, item in ipairs(bound) do
        local row = Instance.new("Frame")
        row.Parent = BindListContainer
        row.Size = UDim2.new(1, -2, 0, 21)
        row.BackgroundColor3 = item.active and ColorAccent or ColorBgMain
        row.BackgroundTransparency = item.active and 0.78 or 0.35
        local rc = Instance.new("UICorner") rc.CornerRadius = UDim.new(0, 4) rc.Parent = row

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Parent = row
        nameLabel.BackgroundTransparency = 1
        nameLabel.Position = UDim2.new(0, 7, 0, 0)
        nameLabel.Size = UDim2.new(1, -58, 1, 0)
        nameLabel.Font = Enum.Font.GothamMedium
        nameLabel.Text = U(item.name)
        nameLabel.TextColor3 = item.active and ColorText or ColorSubText
        nameLabel.TextSize = 9
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.TextTruncate = Enum.TextTruncate.AtEnd

        local keyPill = Instance.new("TextLabel")
        keyPill.Parent = row
        keyPill.BackgroundColor3 = item.active and ColorAccent or Color3.fromRGB(45, 40, 52)
        keyPill.BackgroundTransparency = item.active and 0.05 or 0.15
        keyPill.Position = UDim2.new(1, -51, 0, 3)
        keyPill.Size = UDim2.new(0, 44, 0, 15)
        keyPill.Font = Enum.Font.GothamBold
        keyPill.Text = item.key
        keyPill.TextColor3 = Color3.fromRGB(245,245,250)
        keyPill.TextSize = 7
        keyPill.TextXAlignment = Enum.TextXAlignment.Center
        keyPill.TextTruncate = Enum.TextTruncate.AtEnd
        local kpc = Instance.new("UICorner") kpc.CornerRadius = UDim.new(0, 4) kpc.Parent = keyPill
    end
end

MakeDraggable(BindListFrame, BindListFrame)

local function RefreshBindList()
    UpdateBindList()
end

-- Themes
local function applyTheme(themeName)
    local Themes = {
        Purple = {Bg = Color3.fromRGB(30, 15, 40), Sidebar = Color3.fromRGB(45, 20, 60), Accent = Color3.fromRGB(175, 100, 255), Text = Color3.fromRGB(235, 230, 245), SubText = Color3.fromRGB(160, 145, 175), Fog = Color3.fromRGB(40, 25, 55), Particle = Color3.fromRGB(175, 100, 255), Chams = Color3.fromRGB(175, 100, 255), ESPOutlines = Color3.fromRGB(0, 255, 200), Skeleton = Color3.fromRGB(255, 255, 255), Tracers = Color3.fromRGB(255, 200, 0), NameTags = Color3.fromRGB(255, 255, 255)},
        Red = {Bg = Color3.fromRGB(40, 10, 10), Sidebar = Color3.fromRGB(60, 15, 15), Accent = Color3.fromRGB(255, 65, 65), Text = Color3.fromRGB(245, 228, 228), SubText = Color3.fromRGB(180, 145, 145), Fog = Color3.fromRGB(60, 20, 20), Particle = Color3.fromRGB(255, 65, 65), Chams = Color3.fromRGB(255, 65, 65), ESPOutlines = Color3.fromRGB(255, 200, 100), Skeleton = Color3.fromRGB(255, 200, 200), Tracers = Color3.fromRGB(255, 100, 50), NameTags = Color3.fromRGB(255, 255, 255)},
        Green = {Bg = Color3.fromRGB(10, 30, 15), Sidebar = Color3.fromRGB(15, 50, 25), Accent = Color3.fromRGB(55, 255, 125), Text = Color3.fromRGB(225, 245, 230), SubText = Color3.fromRGB(145, 180, 155), Fog = Color3.fromRGB(20, 50, 30), Particle = Color3.fromRGB(55, 255, 125), Chams = Color3.fromRGB(55, 255, 125), ESPOutlines = Color3.fromRGB(100, 255, 200), Skeleton = Color3.fromRGB(200, 255, 200), Tracers = Color3.fromRGB(50, 255, 100), NameTags = Color3.fromRGB(255, 255, 255)},
        Blue = {Bg = Color3.fromRGB(10, 15, 40), Sidebar = Color3.fromRGB(15, 25, 60), Accent = Color3.fromRGB(55, 155, 255), Text = Color3.fromRGB(225, 230, 248), SubText = Color3.fromRGB(145, 160, 190), Fog = Color3.fromRGB(20, 30, 60), Particle = Color3.fromRGB(55, 155, 255), Chams = Color3.fromRGB(55, 155, 255), ESPOutlines = Color3.fromRGB(0, 200, 255), Skeleton = Color3.fromRGB(200, 200, 255), Tracers = Color3.fromRGB(100, 200, 255), NameTags = Color3.fromRGB(255, 255, 255)}
    }
    local theme = Themes[themeName]
    if not theme then return end

    ColorBgMain = theme.Bg
    ColorSidebar = theme.Sidebar
    ColorAccent = theme.Accent
    ColorText = theme.Text
    ColorSubText = theme.SubText
    ModuleColors.Particles = theme.Particle
    ModuleColors.Chams = theme.Chams
    ModuleColors.ESPOutlines = theme.ESPOutlines
    ModuleColors.Skeleton = theme.Skeleton
    ModuleColors.Tracers = theme.Tracers
    ModuleColors.NameTags = theme.NameTags

    -- Static UI
    MainFrame.BackgroundColor3 = ColorBgMain
    MainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(math.clamp(theme.Bg.R + 0.035, 0, 1), math.clamp(theme.Bg.G + 0.025, 0, 1), math.clamp(theme.Bg.B + 0.045, 0, 1))),
        ColorSequenceKeypoint.new(0.55, theme.Bg),
        ColorSequenceKeypoint.new(1, Color3.new(math.clamp(theme.Bg.R * 0.55, 0, 1), math.clamp(theme.Bg.G * 0.55, 0, 1), math.clamp(theme.Bg.B * 0.55, 0, 1)))
    })
    Sidebar.BackgroundColor3 = ColorSidebar
    DecoPanel.BackgroundColor3 = ColorSidebar
    TopHeaderBar.BackgroundColor3 = ColorSidebar
    MiniFrame.BackgroundColor3 = ColorBgMain
    MiniLogo.TextColor3 = ColorAccent
    SearchBox.BackgroundColor3 = ColorBgMain
    SearchBox.TextColor3 = ColorText
    SearchBox.PlaceholderColor3 = ColorSubText
    KeyBtn.BackgroundColor3 = ColorAccent
    KeyBtn.TextColor3 = ColorText
    MainStroke.Color = ColorAccent
    mfStroke.Color = ColorAccent
    blStroke.Color = ColorAccent
    BindHeaderLine.BackgroundColor3 = ColorAccent
    BindIcon.BackgroundColor3 = ColorAccent
    BindListContainer.ScrollBarImageColor3 = ColorAccent
    BindListFrame.BackgroundColor3 = ColorBgMain
    BindHeaderLine.BackgroundColor3 = ColorAccent
    BindIcon.BackgroundColor3 = ColorAccent
    BindTitle.TextColor3 = ColorText
    FastLogo.TextColor3 = ColorAccent
    HeaderLine.BackgroundColor3 = ColorAccent
    HeaderVersion.TextColor3 = ColorAccent
    -- Keep the existing vertical F A S T animation black/white; do not recolor it to the theme accent.
    for _, letter in ipairs(fastLettersDeco) do letter.TextColor3 = Color3.fromRGB(220,220,220) end
    AuthStatusLabel.TextColor3 = isAuthenticated and Color3.fromRGB(100,255,150) or Color3.fromRGB(255,80,80)
    AmTitle.TextColor3 = ColorText
    KeyInputBox.BackgroundColor3 = ColorSidebar
    KeyInputBox.TextColor3 = ColorText
    KeyInputBox.PlaceholderColor3 = ColorSubText
    ActivateModalBtn.BackgroundColor3 = ColorAccent
    SubKeyBox.BackgroundColor3 = ColorBgMain
    SubKeyBox.TextColor3 = ColorText
    EnabledStatusLabel.TextColor3 = ColorSubText

    Lighting.FogColor = theme.Fog
    Lighting.FogEnd = 700
    Lighting.FogStart = 40

    -- Dense theme fog/atmosphere: reaches the sky instead of only the ground horizon.
    local themeAtmosphere = Lighting:FindFirstChild("FastClientThemeAtmosphere")
    if not themeAtmosphere then
        themeAtmosphere = Instance.new("Atmosphere")
        themeAtmosphere.Name = "FastClientThemeAtmosphere"
        themeAtmosphere.Parent = Lighting
    end
    themeAtmosphere.Color = theme.Fog
    themeAtmosphere.Decay = theme.Sidebar
    themeAtmosphere.Density = 0.20
    themeAtmosphere.Offset = 0.05
    themeAtmosphere.Haze = 1.35
    themeAtmosphere.Glare = 0.05

    renderCategories()
    renderModules(currentCategory, SearchBox.Text)
    UpdateBindList()
end

-- Render functions
renderCategories = function()
    for _, child in ipairs(CatContainer:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, catKey in ipairs(categoryKeys) do
        local btn = Instance.new("TextButton")
        btn.Parent = CatContainer
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.BackgroundColor3 = (catKey == currentCategory) and ColorAccent or ColorBgMain
        btn.BackgroundTransparency = (catKey == currentCategory) and 0.03 or 0.18
        btn.AutoButtonColor = false
        btn.Font = Enum.Font.GothamMedium
        btn.Text = CategoryText(catKey)
        btn.TextColor3 = (catKey == currentCategory) and Color3.fromRGB(255,255,255) or ColorSubText
        btn.TextSize = 10
        btn.TextXAlignment = Enum.TextXAlignment.Left
        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 11)
        pad.Parent = btn
        local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 7) c.Parent = btn
        local st = Instance.new("UIStroke")
        st.Color = ColorAccent
        st.Thickness = 1
        st.Transparency = (catKey == currentCategory) and 0.25 or 0.8
        st.Parent = btn

        btn.MouseEnter:Connect(function()
            if catKey ~= currentCategory then
                TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 0.04, TextColor3 = ColorText}):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if catKey ~= currentCategory then
                TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 0.18, TextColor3 = ColorSubText}):Play()
            end
        end)

        btn.MouseButton1Click:Connect(function()
            currentCategory = catKey
            renderCategories()
            renderModules(currentCategory, SearchBox.Text)
        end)
    end
end

local function createColorCircle(parent, color, callback)
    local circle = Instance.new("TextButton")
    circle.Parent = parent
    circle.BackgroundColor3 = color
    circle.BackgroundTransparency = 0
    circle.Size = UDim2.new(0, 18, 0, 18)
    circle.Text = ""
    circle.AutoButtonColor = false
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(1, 0)
    cCorner.Parent = circle
    circle.BorderSizePixel = 1
    circle.BorderColor3 = Color3.fromRGB(255, 255, 255)
    
    circle.MouseButton1Click:Connect(function()
        local newColor = Color3.fromRGB(math.random(50, 255), math.random(50, 255), math.random(50, 255))
        circle.BackgroundColor3 = newColor
        if callback then callback(newColor) end
    end)
    
    return circle
end

renderModules = function(category, filter)
    for _, child in ipairs(ContentPanel:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local modulesData = {
        ["Combat"] = {
            {Name = "AutoClicker", State = "AutoClicker", Slider = true, Label = "CPS", Min = 1, Max = 30, Get = function() return ModulesState.AutoClicker.CPS end, Set = function(v) ModulesState.AutoClicker.CPS = v end},
            {Name = "Hitboxes", State = "Hitboxes", Slider = true, Label = "Размер", Min = 2, Max = 200, Get = function() return ModulesState.Hitboxes.Size end, Set = function(v) ModulesState.Hitboxes.Size = math.clamp(tonumber(v) or 2, 2, 200) end},
            {Name = "AimAssist", State = "AimAssist", Premium = true, Slider = true, Label = "Резкость", Min = 0, Max = 100, Get = function() return ModulesState.AimAssist.Smoothness * 100 end, Set = function(v) ModulesState.AimAssist.Smoothness = v / 100 end},
            {Name = "KickAura", State = "KickAura", Premium = true}
        },
        ["Visuals"] = {
            {Name = "NameTags", State = "NameTags", TargetColor = true},
            {Name = "Chams", State = "Chams", HasColor = "Chams"},
            {Name = "ESP Outlines", State = "ESPOutlines", HasColor = "ESPOutlines"},
            {Name = "ESP Commands", State = "ESPCommands"},
            {Name = "Tracers", State = "Tracers", HasColor = "Tracers"},
            {Name = "Skeleton", State = "Skeleton", HasColor = "Skeleton"},
            {Name = "Arrows", State = "Arrows", HasColor = "Tracers"},
            {Name = "Particles", State = "Particles", HasColor = "Particles"},
            {Name = "Particles Count", State = "Particles", Slider = true, Label = "Кол-во", Min = 5, Max = 100, Get = function() return ModulesState.Particles.Count end, Set = function(v) ModulesState.Particles.Count = v end},
            {Name = "Particles Speed", State = "Particles", Slider = true, Label = "Скорость", Min = 1, Max = 50, Get = function() return ModulesState.Particles.Speed end, Set = function(v) ModulesState.Particles.Speed = v end},
            {Name = "Third Person", State = "ThirdPerson"},
            {Name = "MotionBlur", State = "MotionBlur", Premium = true, Slider = true, Label = "Интенсивность", Min = 1, Max = 40, Get = function() return ModulesState.MotionBlur.Intensity end, Set = function(v) ModulesState.MotionBlur.Intensity = v end}
        },
        ["Movement"] = {
            {Name = "Speed", State = "Speed", Slider = true, Label = "Скорость", Min = 16, Max = 250, Get = function() return ModulesState.Speed.Value end, Set = function(v) ModulesState.Speed.Value = v end},
            {Name = "Flight", State = "Flight", Slider = true, Label = "Скорость", Min = 10, Max = 200, Get = function() return ModulesState.Flight.Speed end, Set = function(v) ModulesState.Flight.Speed = v end},
            {Name = "NoClip", State = "NoClip"},
            {Name = "Spider", State = "Spider", Slider = true, Label = "Скорость", Min = 16, Max = 50, Get = function() return ModulesState.Spider.Speed end, Set = function(v) ModulesState.Spider.Speed = v end},
            {Name = "Strafe", State = "Strafe", Premium = true, Slider = true, Label = "Скорость", Min = 16, Max = 300, Get = function() return ModulesState.Strafe.Speed end, Set = function(v) ModulesState.Strafe.Speed = v end},
            {Name = "TargetStrafe", State = "TargetStrafe", Premium = true, Slider = true, Label = "Скорость", Min = 50, Max = 850, Get = function() return ModulesState.TargetStrafe.Speed end, Set = function(v) ModulesState.TargetStrafe.Speed = v end},
            {Name = "TargetStrafe Dist", State = "TargetStrafe", Slider = true, Label = "Дистанция", Min = 2, Max = 20, Get = function() return ModulesState.TargetStrafe.Distance end, Set = function(v) ModulesState.TargetStrafe.Distance = v end},
            {Name = "Anti Aim", State = "AntiAim"}
        },
        ["HUD"] = {
            {Name = "Bind List", State = "BindList"},
            {Name = "AutoFarm", State = "AutoFarm"},
            {Name = "Optimization", State = "Optimization"},
            {Name = "NoPush", State = "NoPush"},
            {Name = "4K GRAPHICS", State = "4KGraphics", Premium = true}
        },
        ["Settings"] = {
            {Name = "🎨 Purple Theme", Theme = "Purple"},
            {Name = "🎨 Red Theme", Theme = "Red"},
            {Name = "🎨 Green Theme", Theme = "Green"},
            {Name = "🎨 Blue Theme", Theme = "Blue"},
            {Name = "🌍 RU Language", Action = "LangRU"},
            {Name = "🌍 EN Language", Action = "LangEN"}
        },
        ["Configs"] = {
            {Name = "💾 Сохранить конфиг", Type = "config_save"},
            {Name = "📂 Загрузить конфиг", Type = "config_load"},
            {Name = "🗑️ Удалить конфиг", Type = "config_delete"},
            {Name = "📤 Экспорт конфига", Type = "config_export"},
            {Name = "📥 Импорт конфига", Type = "config_import"},
            {Name = "📋 Список конфигов", Type = "config_list"}
        }
    }

    local mods = modulesData[category] or {}
    if filter and string.gsub(filter, "%s+", "") ~= "" then
        mods = {}
        for _, catKey in ipairs(categoryKeys) do
            for _, mod in ipairs(modulesData[catKey] or {}) do
                table.insert(mods, mod)
            end
        end
    end
    for _, mod in ipairs(mods) do
        local displayName = U(mod.Name)
        if not filter or filter == "" or string.find(string.lower(displayName), string.lower(filter)) or string.find(string.lower(mod.Name), string.lower(filter)) then
            local cardHeight = 32
            if mod.Slider then cardHeight = cardHeight + 32 end
            if mod.Premium then cardHeight = cardHeight + 16 end
            if mod.TargetColor then cardHeight = cardHeight + 20 end
            if mod.HasColor then cardHeight = cardHeight + 26 end
            if mod.Type and string.find(mod.Type, "config") then cardHeight = 80 end

            local card = Instance.new("Frame")
            card.Parent = ContentPanel
            card.Size = UDim2.new(1, -4, 0, cardHeight)
            card.BackgroundColor3 = ColorSidebar
            card.BackgroundTransparency = 0.06
            local cc = Instance.new("UICorner") cc.CornerRadius = UDim.new(0, 8) cc.Parent = card
            local cardStroke = Instance.new("UIStroke")
            cardStroke.Color = ColorAccent
            cardStroke.Thickness = 1
            cardStroke.Transparency = 0.62
            cardStroke.Parent = card

            if mod.Premium then
                createPremiumStar(card)
            end
            
            local titleY = mod.Premium and 2 or 2
            local title = Instance.new("TextLabel")
            title.Parent = card
            title.BackgroundTransparency = 1
            title.Position = UDim2.new(0, 8, 0, titleY)
            title.Size = UDim2.new(0, 140, 0, 16)
            title.Font = Enum.Font.GothamBold
            title.Text = displayName
            title.TextColor3 = ColorText
            title.TextSize = 11
            title.TextXAlignment = Enum.TextXAlignment.Left

            if mod.State then
                local state = ModulesState[mod.State]
                local status = Instance.new("TextLabel")
                status.Parent = card
                status.BackgroundTransparency = 1
                status.Position = UDim2.new(0, 145, 0, 2)
                status.Size = UDim2.new(0, 70, 0, 22)
                status.Font = Enum.Font.GothamBold
                status.Text = state.Active and U("ACTIVE") or U("INACTIVE")
                status.TextColor3 = state.Active and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(180, 80, 80)
                status.TextSize = 10
                status.TextXAlignment = Enum.TextXAlignment.Left

                local bindBtn = Instance.new("TextButton")
                bindBtn.Parent = card
                bindBtn.Position = UDim2.new(1, -65, 0, 3)
                bindBtn.Size = UDim2.new(0, 28, 0, 18)
                bindBtn.BackgroundColor3 = ColorBgMain
                bindBtn.Font = Enum.Font.GothamMedium
                local kName = state.Key and state.Key.Name or U("None")
                bindBtn.Text = kName
                bindBtn.TextColor3 = state.Active and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(255, 255, 255)
                bindBtn.TextSize = 8
                local bCorner = Instance.new("UICorner") bCorner.CornerRadius = UDim.new(0, 4) bCorner.Parent = bindBtn

                bindBtn.MouseButton1Click:Connect(function()
                    bindBtn.Text = "..."
                    listeningKeyMod = mod.State
                end)

                local toggle = Instance.new("TextButton")
                toggle.Parent = card
                toggle.Position = UDim2.new(1, -35, 0, 3)
                toggle.Size = UDim2.new(0, 28, 0, 18)
                toggle.BackgroundColor3 = state.Active and ColorAccent or ColorBgMain
                toggle.Font = Enum.Font.GothamBold
                toggle.Text = state.Active and U("On") or U("Off")
                toggle.TextColor3 = state.Active and Color3.fromRGB(255, 255, 255) or ColorSubText
                toggle.TextSize = 8
                local tc = Instance.new("UICorner") tc.CornerRadius = UDim.new(0, 4) tc.Parent = toggle

                toggle.MouseButton1Click:Connect(function()
                    if not isAuthenticated then
                        EnabledStatusLabel.Text = "🔒 " .. U("Активируйте ключ!")
                        ShowNotification("🔒 " .. U("Активируйте ключ!"), Color3.fromRGB(255, 80, 80))
                        return
                    end
                    
                    if mod.Premium and RoleRanks[userRole] < RoleRanks["Premium"] and userRole ~= "Owner" and userRole ~= "Admin" then
                        EnabledStatusLabel.Text = U("Premium модуль!")
                        ShowNotification(U("Premium модуль!"), Color3.fromRGB(255, 80, 80))
                        return
                    end
                    
                    state.Active = not state.Active
                    if mod.State == "AimAssist" and not state.Active then
                        ClearAimLock()
                    end
                    toggle.BackgroundColor3 = state.Active and ColorAccent or ColorBgMain
                    toggle.Text = state.Active and U("On") or U("Off")
                    toggle.TextColor3 = state.Active and Color3.fromRGB(255, 255, 255) or ColorSubText
                    
                    bindBtn.TextColor3 = state.Active and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(255, 255, 255)
                    
                    for _, child in ipairs(card:GetChildren()) do
                        if child:IsA("TextLabel") and child.Text:find("%[") then
                            child.Text = state.Active and "ACTIVE" or "INACTIVE"
                            child.TextColor3 = state.Active and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(180, 80, 80)
                        end
                    end
                    
                    local msg = state.Active and "✅ " .. displayName .. (currentLanguage == "RU" and " включен" or " enabled") or "❌ " .. displayName .. (currentLanguage == "RU" and " выключен" or " disabled")
                    EnabledStatusLabel.Text = msg
                    ShowNotification(msg, state.Active and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(255, 80, 80))
                    
                    RefreshBindList()
                end)
            end

            if mod.Slider and mod.State then
                local yPos = mod.Premium and 40 or 26
                
                local sliderLabel = Instance.new("TextLabel")
                sliderLabel.Parent = card
                sliderLabel.BackgroundTransparency = 1
                sliderLabel.Position = UDim2.new(0, 8, 0, yPos)
                sliderLabel.Size = UDim2.new(1, -16, 0, 14)
                sliderLabel.Font = Enum.Font.GothamMedium
                sliderLabel.Text = U(mod.Label) .. ": " .. tostring(mod.Get())
                sliderLabel.TextColor3 = ColorSubText
                sliderLabel.TextSize = 10
                
                local sliderFrame = Instance.new("Frame")
                sliderFrame.Parent = card
                sliderFrame.BackgroundColor3 = ColorBgMain
                sliderFrame.Position = UDim2.new(0, 8, 0, yPos + 14)
                sliderFrame.Size = UDim2.new(1, -48, 0, 12)
                local sc = Instance.new("UICorner") sc.CornerRadius = UDim.new(0, 4) sc.Parent = sliderFrame
                
                local pct = math.clamp((mod.Get() - mod.Min) / (mod.Max - mod.Min), 0, 1)
                local sliderFill = Instance.new("Frame")
                sliderFill.Parent = sliderFrame
                sliderFill.BackgroundColor3 = ColorAccent
                sliderFill.Size = UDim2.new(pct, 0, 1, 0)
                local sfc = Instance.new("UICorner") sfc.CornerRadius = UDim.new(0, 4) sfc.Parent = sliderFill
                
                local isDragging = false
                sliderFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        isDragging = true
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        isDragging = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement) then
                        local mouseX = UserInputService:GetMouseLocation().X
                        local relX = math.clamp(mouseX - sliderFrame.AbsolutePosition.X, 0, sliderFrame.AbsoluteSize.X)
                        local p = relX / sliderFrame.AbsoluteSize.X
                        local val = math.floor(mod.Min + (mod.Max - mod.Min) * p)
                        mod.Set(val)
                        sliderFill.Size = UDim2.new(p, 0, 1, 0)
                        sliderLabel.Text = mod.Label .. ": " .. tostring(val)
                    end
                end)
            end

            if mod.HasColor then
                local yPos = mod.Premium and 40 or 26
                
                local colorLabel = Instance.new("TextLabel")
                colorLabel.Parent = card
                colorLabel.BackgroundTransparency = 1
                colorLabel.Position = UDim2.new(0, 8, 0, yPos)
                colorLabel.Size = UDim2.new(0, 60, 0, 16)
                colorLabel.Font = Enum.Font.GothamMedium
                colorLabel.Text = U("Цвет:")
                colorLabel.TextColor3 = ColorSubText
                colorLabel.TextSize = 10
                colorLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local circle = createColorCircle(card, ModuleColors[mod.HasColor] or Color3.fromRGB(255, 255, 255), function(newColor)
                    ModuleColors[mod.HasColor] = newColor
                    if mod.State == "Particles" then
                        ModulesState.Particles.Color = newColor
                    end
                end)
                circle.Position = UDim2.new(0, 70, 0, yPos - 1)
            end
            
            if mod.TargetColor then
                local yPos = 26
                
                local colorLabel = Instance.new("TextLabel")
                colorLabel.Parent = card
                colorLabel.BackgroundTransparency = 1
                colorLabel.Position = UDim2.new(0, 8, 0, yPos)
                colorLabel.Size = UDim2.new(0, 60, 0, 16)
                colorLabel.Font = Enum.Font.GothamMedium
                colorLabel.Text = U("Цвет:")
                colorLabel.TextColor3 = ColorSubText
                colorLabel.TextSize = 10
                colorLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local circle = createColorCircle(card, ModulesState.NameTags.Color, function(newColor)
                    ModulesState.NameTags.Color = newColor
                end)
                circle.Position = UDim2.new(0, 70, 0, yPos - 1)
            end

            if mod.Theme then
                local themeBtn = Instance.new("TextButton")
                themeBtn.Parent = card
                themeBtn.BackgroundColor3 = ColorAccent
                themeBtn.Position = UDim2.new(1, -70, 0, 4)
                themeBtn.Size = UDim2.new(0, 60, 0, 22)
                themeBtn.Font = Enum.Font.GothamBold
                themeBtn.Text = U("Применить")
                themeBtn.TextColor3 = ColorBgMain
                themeBtn.TextSize = 9
                local tbc = Instance.new("UICorner") tbc.CornerRadius = UDim.new(0, 4) tbc.Parent = themeBtn
                
                themeBtn.MouseButton1Click:Connect(function()
                    applyTheme(mod.Theme)
                    EnabledStatusLabel.Text = U("🎨 Тема") .. ": " .. U(mod.Name)
                    ShowNotification(U("🎨 Тема") .. ": " .. U(mod.Name), Color3.fromRGB(175, 100, 255))
                end)
            end
            
            if mod.Action then
                local actionBtn = Instance.new("TextButton")
                actionBtn.Parent = card
                actionBtn.BackgroundColor3 = ColorAccent
                actionBtn.Position = UDim2.new(1, -80, 0, 4)
                actionBtn.Size = UDim2.new(0, 70, 0, 22)
                actionBtn.Font = Enum.Font.GothamBold
                actionBtn.Text = U("Переключить")
                actionBtn.TextColor3 = ColorBgMain
                actionBtn.TextSize = 9
                local abCorner = Instance.new("UICorner") abCorner.CornerRadius = UDim.new(0, 4) abCorner.Parent = actionBtn
                
                if mod.Action == "LangRU" then
                    actionBtn.MouseButton1Click:Connect(function()
                        SetLanguage("RU")
                        EnabledStatusLabel.Text = "🌍 " .. (currentLanguage == "RU" and "Русский язык установлен" or "Russian language set")
                        ShowNotification(EnabledStatusLabel.Text, Color3.fromRGB(100, 200, 255))
                        renderCategories()
                        renderModules(currentCategory, SearchBox.Text)
                    end)
                elseif mod.Action == "LangEN" then
                    actionBtn.MouseButton1Click:Connect(function()
                        SetLanguage("EN")
                        EnabledStatusLabel.Text = "🌍 " .. (currentLanguage == "RU" and "Английский язык установлен" or "English language set")
                        ShowNotification(EnabledStatusLabel.Text, Color3.fromRGB(100, 200, 255))
                        renderCategories()
                        renderModules(currentCategory, SearchBox.Text)
                    end)
                end
            end

            -- Configs handling
            if mod.Type == "config_save" or mod.Type == "config_load" or mod.Type == "config_delete" or mod.Type == "config_export" or mod.Type == "config_import" or mod.Type == "config_list" then
                local yPos = 4
                local actionBtn = Instance.new("TextButton")
                actionBtn.Parent = card
                actionBtn.BackgroundColor3 = ColorAccent
                actionBtn.Position = UDim2.new(1, -90, 0, yPos)
                actionBtn.Size = UDim2.new(0, 80, 0, 24)
                actionBtn.Font = Enum.Font.GothamBold
                actionBtn.TextColor3 = ColorBgMain
                actionBtn.TextSize = 10
                local abCorner = Instance.new("UICorner") abCorner.CornerRadius = UDim.new(0, 4) abCorner.Parent = actionBtn

                local inputBox = Instance.new("TextBox")
                inputBox.Parent = card
                inputBox.BackgroundColor3 = ColorBgMain
                inputBox.Position = UDim2.new(0, 8, 0, yPos + 28)
                inputBox.Size = UDim2.new(1, -16, 0, 24)
                inputBox.Font = Enum.Font.Gotham
                inputBox.PlaceholderText = currentLanguage == "RU" and "Имя конфига..." or "Config name..."
                inputBox.Text = ""
                inputBox.TextColor3 = ColorText
                inputBox.TextSize = 10
                local ibCorner = Instance.new("UICorner") ibCorner.CornerRadius = UDim.new(0, 4) ibCorner.Parent = inputBox
                inputBox.Visible = (mod.Type ~= "config_list")

                local resultLabel = Instance.new("TextLabel")
                resultLabel.Parent = card
                resultLabel.BackgroundTransparency = 1
                resultLabel.Position = UDim2.new(0, 8, 0, yPos + 56)
                resultLabel.Size = UDim2.new(1, -16, 0, 18)
                resultLabel.Font = Enum.Font.GothamMedium
                resultLabel.Text = ""
                resultLabel.TextColor3 = ColorSubText
                resultLabel.TextSize = 9
                resultLabel.TextWrapped = true

                if mod.Type == "config_save" then
                    actionBtn.Text = "💾 " .. (currentLanguage == "RU" and "Сохранить" or "Save")
                    actionBtn.MouseButton1Click:Connect(function()
                        local name = inputBox.Text
                        local ok, msg = SaveConfig(name)
                        resultLabel.Text = msg
                        resultLabel.TextColor3 = ok and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(255, 80, 80)
                        if ok then inputBox.Text = "" end
                        ShowNotification(msg, ok and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(255, 80, 80))
                        renderModules(currentCategory, SearchBox.Text)
                    end)
                elseif mod.Type == "config_load" then
                    actionBtn.Text = "📂 " .. (currentLanguage == "RU" and "Загрузить" or "Load")
                    actionBtn.MouseButton1Click:Connect(function()
                        local name = inputBox.Text
                        local ok, msg = LoadConfig(name)
                        resultLabel.Text = msg
                        resultLabel.TextColor3 = ok and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(255, 80, 80)
                        if ok then inputBox.Text = "" end
                        ShowNotification(msg, ok and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(255, 80, 80))
                    end)
                elseif mod.Type == "config_delete" then
                    actionBtn.Text = "🗑️ " .. (currentLanguage == "RU" and "Удалить" or "Delete")
                    actionBtn.MouseButton1Click:Connect(function()
                        local name = inputBox.Text
                        local ok, msg = DeleteConfig(name)
                        resultLabel.Text = msg
                        resultLabel.TextColor3 = ok and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(255, 80, 80)
                        if ok then inputBox.Text = "" end
                        ShowNotification(msg, ok and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(255, 80, 80))
                        renderModules(currentCategory, SearchBox.Text)
                    end)
                elseif mod.Type == "config_export" then
                    actionBtn.Text = "📤 " .. (currentLanguage == "RU" and "Экспорт" or "Export")
                    actionBtn.MouseButton1Click:Connect(function()
                        local name = inputBox.Text
                        local ok, data = ExportConfig(name)
                        if ok then
                            if setclipboard then
                                setclipboard(data)
                                resultLabel.Text = "✅ " .. (currentLanguage == "RU" and "Экспортировано в буфер обмена!" or "Exported to clipboard!")
                                resultLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
                                ShowNotification("📤 " .. (currentLanguage == "RU" and "Конфиг скопирован в буфер!" or "Config copied to clipboard!"), Color3.fromRGB(100, 200, 255))
                            else
                                resultLabel.Text = "❌ " .. (currentLanguage == "RU" and "setclipboard не доступен!" or "setclipboard is unavailable!")
                                resultLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
                            end
                        else
                            resultLabel.Text = data
                            resultLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
                        end
                    end)
                elseif mod.Type == "config_import" then
                    actionBtn.Text = "📥 " .. (currentLanguage == "RU" and "Импорт" or "Import")
                    actionBtn.MouseButton1Click:Connect(function()
                        local name = inputBox.Text
                        local clipboardData = getclipboard and getclipboard() or ""
                        if clipboardData == "" then
                            resultLabel.Text = "❌ " .. (currentLanguage == "RU" and "Буфер обмена пуст!" or "Clipboard is empty!")
                            resultLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
                            return
                        end
                        local ok, msg = ImportConfig(name, clipboardData)
                        resultLabel.Text = msg
                        resultLabel.TextColor3 = ok and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(255, 80, 80)
                        if ok then inputBox.Text = "" end
                        ShowNotification(msg, ok and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(255, 80, 80))
                        renderModules(currentCategory, SearchBox.Text)
                    end)
                elseif mod.Type == "config_list" then
                    inputBox.Visible = false
                    actionBtn.Visible = false
                    card.Size = UDim2.new(1, -4, 0, 32 + #Configs * 18)
                    
                    local listLabel = Instance.new("TextLabel")
                    listLabel.Parent = card
                    listLabel.BackgroundTransparency = 1
                    listLabel.Position = UDim2.new(0, 8, 0, 4)
                    listLabel.Size = UDim2.new(1, -16, 0, 24)
                    listLabel.Font = Enum.Font.GothamBold
                    listLabel.Text = "📋 " .. (currentLanguage == "RU" and "Сохранённые конфиги:" or "Saved configs:")
                    listLabel.TextColor3 = ColorText
                    listLabel.TextSize = 11
                    listLabel.TextXAlignment = Enum.TextXAlignment.Left

                    local yOff = 28
                    local names = {}
                    for name, _ in pairs(Configs) do
                        table.insert(names, name)
                    end
                    table.sort(names)
                    for _, name in ipairs(names) do
                        local lbl = Instance.new("TextLabel")
                        lbl.Parent = card
                        lbl.BackgroundTransparency = 1
                        lbl.Position = UDim2.new(0, 16, 0, yOff)
                        lbl.Size = UDim2.new(1, -32, 0, 16)
                        lbl.Font = Enum.Font.GothamMedium
                        lbl.Text = "• " .. name
                        lbl.TextColor3 = ColorSubText
                        lbl.TextSize = 10
                        lbl.TextXAlignment = Enum.TextXAlignment.Left
                        yOff = yOff + 18
                    end
                    if #names == 0 then
                        local lbl = Instance.new("TextLabel")
                        lbl.Parent = card
                        lbl.BackgroundTransparency = 1
                        lbl.Position = UDim2.new(0, 16, 0, 28)
                        lbl.Size = UDim2.new(1, -32, 0, 16)
                        lbl.Font = Enum.Font.GothamMedium
                        lbl.Text = "📭 " .. (currentLanguage == "RU" and "Нет сохранённых конфигов" or "No saved configs")
                        lbl.TextColor3 = ColorSubText
                        lbl.TextSize = 10
                        lbl.TextXAlignment = Enum.TextXAlignment.Left
                    end
                end
            end
        end
    end
end

renderCategories()
renderModules("Combat", "")

-- Binds (С Delete для разбиндивания)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if listeningKeyMod then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.Delete then
                ModulesState[listeningKeyMod].Key = nil
                listeningKeyMod = nil
                renderModules(currentCategory, SearchBox.Text)
                RefreshBindList()
                ShowNotification("🗑️ " .. (currentLanguage == "RU" and "Бинд удалён!" or "Bind removed!"), Color3.fromRGB(255, 200, 50))
                return
            end
            ModulesState[listeningKeyMod].Key = input.KeyCode
            listeningKeyMod = nil
            renderModules(currentCategory, SearchBox.Text)
            RefreshBindList()
        end
        return
    end

    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.Insert then
            if isAuthenticated then
                MainFrame.Visible = not MainFrame.Visible
            else
                ActivateModal.Visible = true
                KeyInputBox:CaptureFocus()
            end
        end
        
        for name, state in pairs(ModulesState) do
            if state.Key and input.KeyCode == state.Key then
                if isAuthenticated then
                    state.Active = not state.Active
                    if name == "AimAssist" and not state.Active then
                        ClearAimLock()
                    end
                    local msg = state.Active and ("✅ " .. name .. " включен") or ("❌ " .. name .. " выключен")
                    EnabledStatusLabel.Text = msg
                    ShowNotification(msg, state.Active and Color3.fromRGB(100, 255, 150) or Color3.fromRGB(255, 80, 80))
                    renderModules(currentCategory, SearchBox.Text)
                    RefreshBindList()
                end
            end
        end
    end
end)

-- AutoClicker (стабильный клик без блокирующего task.wait)
local clickCooldown = 0
local VirtualInputManager = nil
pcall(function()
    VirtualInputManager = game:GetService("VirtualInputManager")
end)

local function PerformAutoClick()
    local clicked = false

    if type(mouse1click) == "function" then
        clicked = pcall(mouse1click)
    end

    if not clicked and VirtualInputManager then
        clicked = pcall(function()
            local pos = UserInputService:GetMouseLocation()
            VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 0)
            VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0)
        end)
    end

    if not clicked then
        clicked = pcall(function()
            VirtualUser:Button1Down(Vector2.new(0, 0))
            VirtualUser:Button1Up(Vector2.new(0, 0))
        end)
    end

    return clicked
end

RunService.Heartbeat:Connect(function(dt)
    if not isAuthenticated then
        clickCooldown = 0
        return
    end

    if not ModulesState.AutoClicker.Active then
        clickCooldown = 0
        return
    end

    local cps = math.clamp(tonumber(ModulesState.AutoClicker.CPS) or 12, 1, 30)
    clickCooldown = clickCooldown - dt
    if clickCooldown <= 0 then
        PerformAutoClick()
        clickCooldown = 1 / cps
    end
end)

-- NoClip
local noclipConnection = nil

local function SetNoclip(state)
    if state then
        if noclipConnection then noclipConnection:Disconnect() end
        noclipConnection = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if ModulesState.NoClip.Active and isAuthenticated then
        SetNoclip(true)
    else
        SetNoclip(false)
    end
end)

-- Skeleton
local skeletonCache = {}
local bones = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
    {"RightLowerLeg", "RightFoot"}
}

local function UpdateSkeletons()
    if not isAuthenticated or not ModulesState.Skeleton.Active then
        for _, lines in pairs(skeletonCache) do
            for _, line in ipairs(lines) do
                line.Visible = false
            end
        end
        return
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if not skeletonCache[player] then
                local lines = {}
                for _ = 1, #bones do
                    local l = Drawing.new("Line")
                    l.Thickness = 1.5
                    l.Color = ModuleColors.Skeleton or Color3.fromRGB(255, 255, 255)
                    l.Visible = false
                    table.insert(lines, l)
                end
                skeletonCache[player] = lines
            end
            
            local lines = skeletonCache[player]
            local char = player.Character
            local isValid = char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0
            
            if isValid then
                for i, bone in ipairs(bones) do
                    local part1 = char:FindFirstChild(bone[1])
                    local part2 = char:FindFirstChild(bone[2])
                    local line = lines[i]
                    
                    if part1 and part2 then
                        local p1, onScreen1 = Camera:WorldToViewportPoint(part1.Position)
                        local p2, onScreen2 = Camera:WorldToViewportPoint(part2.Position)
                        
                        if onScreen1 or onScreen2 then
                            line.From = Vector2.new(p1.X, p1.Y)
                            line.To = Vector2.new(p2.X, p2.Y)
                            line.Visible = true
                            line.Color = ModuleColors.Skeleton or Color3.fromRGB(255, 255, 255)
                        else
                            line.Visible = false
                        end
                    else
                        line.Visible = false
                    end
                end
            else
                for _, line in ipairs(lines) do
                    line.Visible = false
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(UpdateSkeletons)

-- Tracers
local tracersCache = {}

local function UpdateTracers()
    if not isAuthenticated or not ModulesState.Tracers.Active then
        for _, line in pairs(tracersCache) do
            line.Visible = false
        end
        return
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if not tracersCache[player] then
                local line = Drawing.new("Line")
                line.Thickness = 1.5
                line.Color = ModuleColors.Tracers or Color3.fromRGB(255, 200, 0)
                line.Transparency = 0.8
                tracersCache[player] = line
            end
            
            local line = tracersCache[player]
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") and char.Humanoid.Health > 0 then
                local hrp = char.HumanoidRootPart
                local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                
                if onScreen then
                    line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    line.To = Vector2.new(vector.X, vector.Y)
                    line.Visible = true
                    line.Color = ModuleColors.Tracers or Color3.fromRGB(255, 200, 0)
                else
                    line.Visible = false
                end
            else
                line.Visible = false
            end
        end
    end
end

RunService.RenderStepped:Connect(UpdateTracers)

-- ============================================================
-- ==== MOVEMENT AND COMBAT LOGIC (С FIX-АМИ) ====
-- ============================================================
local lastAuraAttack = 0
local autoWalkActive = false

RunService.Heartbeat:Connect(function(dt)
    if not isAuthenticated then
        for _, m in pairs(ModulesState) do
            if type(m) == "table" and m.Active ~= nil then
                m.Active = false
            end
        end
        return
    end

    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    -- SPEED
    if ModulesState.Speed.Active then
        hum.WalkSpeed = ModulesState.Speed.Value
    else
        if hum.WalkSpeed ~= 16 then
            hum.WalkSpeed = 16
        end
    end

    -- FLIGHT
    if ModulesState.Flight.Active then
        local moveVector = Vector3.zero
        local camCF = Camera.CFrame
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVector = moveVector - Vector3.new(0, 1, 0) end
        if moveVector.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + moveVector.Unit * (ModulesState.Flight.Speed * dt)
            hrp.Velocity = Vector3.zero
        else
            hrp.Velocity = Vector3.zero
        end
        hum.PlatformStand = true
    else
        hum.PlatformStand = false
    end

    -- ============================================================
    -- ==== STRAFE (РАБОТАЕТ В ПРЫЖКЕ) ====
    -- ============================================================
    if ModulesState.Strafe.Active and RoleRanks[userRole] >= RoleRanks["Premium"] then
        local moveVector = Vector3.zero
        local camLook = Camera.CFrame.LookVector * Vector3.new(1, 0, 1)
        local camRight = Camera.CFrame.RightVector * Vector3.new(1, 0, 1)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + camLook.Unit end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - camLook.Unit end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - camRight.Unit end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + camRight.Unit end
        
        if moveVector.Magnitude > 0 and hum and hum.Parent then
            local speed = ModulesState.Strafe.Speed * dt * 2.5
            local newPos = hrp.Position + moveVector.Unit * speed
            hrp.CFrame = CFrame.new(newPos, hrp.Position + hrp.CFrame.LookVector)
            hrp.Velocity = Vector3.zero
            if hum:GetState() == Enum.HumanoidStateType.Jumping or hum:GetState() == Enum.HumanoidStateType.Freefall then
                hum.PlatformStand = true
            end
        end
    else
        if hum and hum.Parent then
            if not ModulesState.Speed.Active then hum.WalkSpeed = 16 end
            hum.PlatformStand = false
        end
    end

    -- ============================================================
    -- ==== TARGET STRAFE (БЫСТРЫЙ НА 850) ====
    -- ============================================================
    if ModulesState.TargetStrafe.Active and RoleRanks[userRole] >= RoleRanks["Premium"] and hrp then
        local nearest, minDist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if d < minDist and d < 60 then
                    minDist = d
                    nearest = p.Character.HumanoidRootPart
                end
            end
        end
        if nearest then
            local speedVal = math.clamp(ModulesState.TargetStrafe.Speed, 50, 850)
            local distVal = ModulesState.TargetStrafe.Distance or 8
            local t = tick() * (speedVal / 25)
            local offset = Vector3.new(math.cos(t) * distVal, 0, math.sin(t) * distVal)
            local newPos = nearest.Position + offset
            hrp.CFrame = CFrame.new(newPos, nearest.Position)
            
            if ModulesState.TargetStrafe.JumpOnTarget and hum and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                if hum.FloorMaterial ~= Enum.Material.Air then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
    end

    -- ANTI AIM
    if ModulesState.AntiAim.Active and isAuthenticated then
        local angle = tick() * (ModulesState.AntiAim.Speed / 20)
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, angle * dt, 0)
    end

    -- KICK AURA is handled by the dedicated orbit controller above.

    -- HITBOXES are handled by ApplyHitboxes() above.

    -- AUTOFARM
    if ModulesState.AutoFarm.Active and isAuthenticated then
        if not autoWalkActive then
            autoWalkActive = true
            task.spawn(function()
                while ModulesState.AutoFarm.Active and isAuthenticated do
                    local camLook = Camera.CFrame.LookVector * Vector3.new(1, 0, 1)
                    if camLook.Magnitude > 0 then
                        local speed = hum.WalkSpeed * 0.5
                        local newPos = hrp.Position + camLook.Unit * speed * 0.06
                        hrp.CFrame = CFrame.new(newPos, hrp.Position + hrp.CFrame.LookVector)
                    end
                    task.wait(0.08)
                end
                autoWalkActive = false
            end)
        end
    else
        autoWalkActive = false
    end
end)

-- Visuals (Chams & ESP Outlines)
RunService.RenderStepped:Connect(function()
    if not isAuthenticated then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hl = player.Character:FindFirstChild("FastClientHighlight")
                if hl then hl:Destroy() end
            end
        end
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hl = char:FindFirstChild("FastClientHighlight")
            
            local chamsActive = ModulesState.Chams.Active
            local espActive = ModulesState.ESPOutlines.Active
            local commandsActive = ModulesState.ESPCommands.Active

            -- Lost Front team ESP: resolve the replicated red/blue team from the
            -- player's Team/TeamColor first, then common replicated attributes/values.
            local teamColor = Color3.fromRGB(255, 255, 255)
            local teamKind = "unknown"
            if commandsActive then
                local function classify(text)
                    text = string.lower(tostring(text or ""))
                    if text:find("red") or text:find("крас") then return "red" end
                    if text:find("blue") or text:find("син") then return "blue" end
                    return nil
                end

                local candidates = {
                    player.Team and player.Team.Name,
                    player.TeamColor and player.TeamColor.Name,
                    player:GetAttribute("Team"),
                    player:GetAttribute("TeamName"),
                    player:GetAttribute("TeamColor"),
                    player.Character and player.Character:GetAttribute("Team"),
                    player.Character and player.Character:GetAttribute("TeamName"),
                    player.Character and player.Character:GetAttribute("TeamColor")
                }
                for _, value in ipairs(candidates) do
                    local kind = classify(value)
                    if kind then teamKind = kind; break end
                end

                if teamKind == "unknown" and player.TeamColor then
                    local c = player.TeamColor.Color
                    if c then
                        if c.R > c.B * 1.35 then teamKind = "red"
                        elseif c.B > c.R * 1.35 then teamKind = "blue" end
                    end
                end

                if teamKind == "unknown" and player.Character then
                    for _, obj in ipairs(player.Character:GetDescendants()) do
                        if obj:IsA("StringValue") or obj:IsA("BrickColorValue") then
                            local kind = classify(obj.Value)
                            if kind then teamKind = kind; break end
                        end
                    end
                end

                if teamKind == "red" then
                    teamColor = Color3.fromRGB(255, 65, 65)
                elseif teamKind == "blue" then
                    teamColor = Color3.fromRGB(65, 135, 255)
                elseif player.TeamColor then
                    teamColor = player.TeamColor.Color
                end
            end

            if chamsActive or espActive or commandsActive then
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "FastClientHighlight"
                    hl.Parent = char
                    hl.Adornee = char
                end
                hl.Enabled = true
                
                if chamsActive then
                    hl.FillColor = ModuleColors.Chams
                    hl.FillTransparency = 0.3
                elseif commandsActive then
                    hl.FillColor = teamColor
                    hl.FillTransparency = 0.88
                else
                    hl.FillTransparency = 1
                end
                
                if commandsActive then
                    hl.OutlineColor = teamColor
                    hl.OutlineTransparency = 0
                elseif espActive then
                    hl.OutlineColor = ModuleColors.ESPOutlines
                    hl.OutlineTransparency = 0
                else
                    hl.OutlineTransparency = 1
                end
            else
                if hl then 
                    hl.Enabled = false
                end
            end
        end
    end
end)

-- ============================================================
-- ==== ESP COMMANDS LABELS (RED / BLUE TEAM) ====
-- ============================================================
local teamEspGuis = {}
local function GetCommandTeamColor(player)
    local function classify(text)
        text = string.lower(tostring(text or ""))
        if text:find("red") or text:find("крас") then return Color3.fromRGB(255, 65, 65) end
        if text:find("blue") or text:find("син") then return Color3.fromRGB(65, 135, 255) end
    end
    local values = {
        player.Team and player.Team.Name,
        player.TeamColor and player.TeamColor.Name,
        player:GetAttribute("Team"), player:GetAttribute("TeamName"), player:GetAttribute("TeamColor"),
        player.Character and player.Character:GetAttribute("Team"),
        player.Character and player.Character:GetAttribute("TeamName"),
        player.Character and player.Character:GetAttribute("TeamColor")
    }
    for _, v in ipairs(values) do
        local c = classify(v)
        if c then return c end
    end
    if player.TeamColor then return player.TeamColor.Color end
    return Color3.fromRGB(255,255,255)
end

RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local old = teamEspGuis[player]
            if not ModulesState.ESPCommands.Active or not isAuthenticated or not player.Character then
                if old then old.Enabled = false end
            else
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local gui = old
                    if not gui then
                        gui = Instance.new("BillboardGui")
                        gui.Name = "FastClientCommandESP"
                        gui.Size = UDim2.new(0, 120, 0, 24)
                        gui.StudsOffset = Vector3.new(0, 3.2, 0)
                        gui.AlwaysOnTop = true
                        gui.MaxDistance = 1000
                        gui.Parent = hrp
                        local label = Instance.new("TextLabel")
                        label.Name = "TeamLabel"
                        label.Size = UDim2.new(1,0,1,0)
                        label.BackgroundTransparency = 1
                        label.Font = Enum.Font.GothamBold
                        label.TextSize = 12
                        label.TextStrokeTransparency = 0.25
                        label.Parent = gui
                        teamEspGuis[player] = gui
                    end
                    gui.Parent = hrp
                    gui.Enabled = true
                    local label = gui:FindFirstChild("TeamLabel")
                    if label then
                        local c = GetCommandTeamColor(player)
                        label.TextColor3 = c
                        local teamName = player.Team and player.Team.Name or "TEAM"
                        label.Text = string.upper(teamName)
                    end
                end
            end
        end
    end
end)

RefreshBindList()

print("✅ FAST CLIENT 3.0 ЗАГРУЖЕН!")
print("📊 LICENSE SYSTEM READY")
print("🔴 YOUTUBER КЛЮЧИ: 5 ШТУК")
print("⌨️ BIND LIST ВСЕГДА ВИДИМ")
print("🕷️ SPIDER - ЛАЗАНИЕ ПО СТЕНАМ И ПОТОЛКУ (скорость 16-50)")
print("👁️ TARGET HUD - УДАЛЁН")
print("🚫 NOPUSH - ОТТАЛКИВАНИЕ ОТКЛЮЧЕНО (вкладка HUD)")
print("💡 Для разбиндивания клавиши нажми Delete")
