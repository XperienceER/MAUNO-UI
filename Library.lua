local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ฟังก์ชันตรวจสอบที่เก็บ UI (รองรับทั้ง PlayerGui และสภาพแวดล้อมอื่น)
local function GetGuiParent()
    if gethui then
        return gethui()
    elseif syn and syn.protect_gui then
        local gui = Instance.new("Folder")
        syn.protect_gui(gui)
        gui.Parent = game:GetService("CoreGui")
        return gui
    end
    return PlayerGui
end

local Library = {}
Library.__index = Library

-- ฟังก์ชันสร้างเงา (Drop Shadow / Glow)
local function CreateShadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "DropShadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Image = "rbxassetid://6015897843" -- Soft glow/shadow texture
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.4
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Parent = parent
    return shadow
end

-- // CREATE WINDOW
function Library:CreateWindow(config)
    config = config or {}
    local Title = config.Title or "Xperienceer Hub"
    local SubTitle = config.SubTitle or "GameName"

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XperienceerHub_UI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = GetGuiParent()

    -- Notification Container
    local NotifContainer = Instance.new("Frame")
    NotifContainer.Name = "Notifications"
    NotifContainer.Size = UDim2.new(0, 260, 1, -20)
    NotifContainer.Position = UDim2.new(1, -270, 0, 10)
    NotifContainer.BackgroundTransparency = 1
    NotifContainer.Parent = ScreenGui

    local NotifLayout = Instance.new("UIListLayout")
    NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifLayout.Padding = UDim.new(0, 8)
    NotifLayout.Parent = NotifContainer

    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 420, 0, 520)
    Main.Position = UDim2.new(0.5, -210, 0.5, -260)
    Main.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = false
    Main.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = Main

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(45, 45, 45)
    MainStroke.Thickness = 1.2
    MainStroke.Parent = Main

    CreateShadow(Main)

    -- Topbar
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, 42)
    Topbar.BackgroundTransparency = 1
    Topbar.Parent = Main

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, -90, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = string.format("<font color='#ff2b2b'><b>%s</b></font> <font color='#666'>|</font> <font color='#ff4d4d'>%s</font>", Title, SubTitle)
    TitleLabel.RichText = true
    TitleLabel.Font = Enum.Font.GothamMedium
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Topbar

    -- Window Controls (Minimize / Close)
    local ControlHolder = Instance.new("Frame")
    ControlHolder.Size = UDim2.new(0, 70, 1, 0)
    ControlHolder.Position = UDim2.new(1, -75, 0, 0)
    ControlHolder.BackgroundTransparency = 1
    ControlHolder.Parent = Topbar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position = UDim2.new(1, -30, 0.5, -14)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 43, 43)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 13
    CloseBtn.AutoButtonColor = false
    CloseBtn.Parent = ControlHolder

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 28, 0, 28)
    MinBtn.Position = UDim2.new(0, 4, 0.5, -14)
    MinBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MinBtn.Text = "—"
    MinBtn.TextColor3 = Color3.fromRGB(255, 43, 43)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 13
    MinBtn.AutoButtonColor = false
    MinBtn.Parent = ControlHolder

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 6)
    MinCorner.Parent = MinBtn

    -- Line Divider
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -24, 0, 1.5)
    Divider.Position = UDim2.new(0, 12, 0, 42)
    Divider.BackgroundColor3 = Color3.fromRGB(255, 43, 43)
    Divider.BorderSizePixel = 0
    Divider.Parent = Main

    -- Tab Container (Scrolling Horizontal)
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Name = "TabScroll"
    TabScroll.Size = UDim2.new(1, -24, 0, 32)
    TabScroll.Position = UDim2.new(0, 12, 0, 46)
    TabScroll.BackgroundTransparency = 1
    TabScroll.ScrollBarThickness = 0
    TabScroll.ScrollingDirection = Enum.ScrollingDirection.X
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.Parent = Main

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 14)
    TabLayout.Parent = TabScroll

    -- Container for Tab Contents
    local ContentHolder = Instance.new("Frame")
    ContentHolder.Name = "ContentHolder"
    ContentHolder.Size = UDim2.new(1, -24, 1, -90)
    ContentHolder.Position = UDim2.new(0, 12, 0, 82)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.Parent = Main

    -- Window Dragging Logic
    local dragging, dragStart, startPos
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local function stopDrag() dragging = false end
    Topbar.InputEnded:Connect(stopDrag)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            stopDrag()
        end
    end)

    -- Window Minimize / Close
    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        ContentHolder.Visible = not minimized
        TabScroll.Visible = not minimized
        Divider.Visible = not minimized
        TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Size = minimized and UDim2.new(0, 420, 0, 44) or UDim2.new(0, 420, 0, 520)
        }):Play()
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Window Methods
    local Window = {
        ScreenGui = ScreenGui,
        Main = Main,
        Tabs = {},
        ActiveTab = nil,
        NotifContainer = NotifContainer
    }

    function Window:SetNotification(options)
        options = options or {}
        local nTitle = options.Title or "Notification"
        local nText = options.Description or ""
        local nDuration = options.Duration or 3

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 56)
        card.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        card.BackgroundTransparency = 1
        card.Parent = NotifContainer

        local cCorner = Instance.new("UICorner")
        cCorner.CornerRadius = UDim.new(0, 6)
        cCorner.Parent = card

        local cStroke = Instance.new("UIStroke")
        cStroke.Color = Color3.fromRGB(255, 43, 43)
        cStroke.Thickness = 1
        cStroke.Transparency = 1
        cStroke.Parent = card

        local tLabel = Instance.new("TextLabel")
        tLabel.Size = UDim2.new(1, -16, 0, 20)
        tLabel.Position = UDim2.new(0, 8, 0, 6)
        tLabel.BackgroundTransparency = 1
        tLabel.Text = nTitle
        tLabel.Font = Enum.Font.GothamBold
        tLabel.TextSize = 13
        tLabel.TextColor3 = Color3.fromRGB(255, 43, 43)
        tLabel.TextXAlignment = Enum.TextXAlignment.Left
        tLabel.Parent = card

        local dLabel = Instance.new("TextLabel")
        dLabel.Size = UDim2.new(1, -16, 0, 24)
        dLabel.Position = UDim2.new(0, 8, 0, 26)
        dLabel.BackgroundTransparency = 1
        dLabel.Text = nText
        dLabel.Font = Enum.Font.Gotham
        dLabel.TextSize = 11
        dLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        dLabel.TextXAlignment = Enum.TextXAlignment.Left
        dLabel.TextWrapped = true
        dLabel.Parent = card

        TweenService:Create(card, TweenInfo.new(0.25), {BackgroundTransparency = 0.05}):Play()
        TweenService:Create(cStroke, TweenInfo.new(0.25), {Transparency = 0}):Play()

        task.delay(nDuration, function()
            local fadeOut = TweenService:Create(card, TweenInfo.new(0.3), {BackgroundTransparency = 1})
            TweenService:Create(cStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
            TweenService:Create(tLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(dLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            fadeOut:Play()
            fadeOut.Completed:Connect(function()
                card:Destroy()
            end)
        end)
    end

    function Window:CreateTab(name)
        name = name or "Tab"
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = name .. "_Button"
        TabBtn.Size = UDim2.new(0, 0, 1, 0)
        TabBtn.AutomaticSize = Enum.AutomaticSize.X
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = name
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 13
        TabBtn.TextColor3 = Color3.fromRGB(150, 40, 40)
        TabBtn.Parent = TabScroll

        -- ขีดเส้นใต้แท็บเมื่อเลือก
        local Underline = Instance.new("Frame")
        Underline.Name = "Underline"
        Underline.Size = UDim2.new(1, 0, 0, 2)
        Underline.Position = UDim2.new(0, 0, 1, -2)
        Underline.BackgroundColor3 = Color3.fromRGB(255, 43, 43)
        Underline.BorderSizePixel = 0
        Underline.Visible = false
        Underline.Parent = TabBtn

        -- Container สำหรับองค์ประกอบในแต่ละแท็บ
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "_Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(255, 43, 43)
        TabContent.Visible = false
        TabContent.Parent = ContentHolder

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 8)
        ContentLayout.Parent = TabContent

        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
        end)

        TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabScroll.CanvasSize = UDim2.new(0, TabLayout.AbsoluteContentSize.X + 15, 0, 0)
        end)

        local Tab = {Content = TabContent}

        local function Select()
            for _, t in pairs(Window.Tabs) do
                t.Button.TextColor3 = Color3.fromRGB(150, 40, 40)
                t.Underline.Visible = false
                t.Content.Visible = false
            end
            TabBtn.TextColor3 = Color3.fromRGB(255, 43, 43)
            Underline.Visible = true
            TabContent.Visible = true
            Window.ActiveTab = Tab
        end

        TabBtn.MouseButton1Click:Connect(Select)
        table.insert(Window.Tabs, {Button = TabBtn, Underline = Underline, Content = TabContent})

        if #Window.Tabs == 1 then
            Select()
        end

        -- // COMPONENTS
        function Tab:AddParagraph(title, desc)
            local pFrame = Instance.new("Frame")
            pFrame.Size = UDim2.new(1, -6, 0, 0)
            pFrame.AutomaticSize = Enum.AutomaticSize.Y
            pFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            pFrame.BorderSizePixel = 0
            pFrame.Parent = TabContent

            local pCorner = Instance.new("UICorner")
            pCorner.CornerRadius = UDim.new(0, 6)
            pCorner.Parent = pFrame

            local pPadding = Instance.new("UIPadding")
            pPadding.PaddingTop = UDim.new(0, 8)
            pPadding.PaddingBottom = UDim.new(0, 8)
            pPadding.PaddingLeft = UDim.new(0, 10)
            pPadding.PaddingRight = UDim.new(0, 10)
            pPadding.Parent = pFrame

            local pTitle = Instance.new("TextLabel")
            pTitle.Size = UDim2.new(1, 0, 0, 18)
            pTitle.BackgroundTransparency = 1
            pTitle.Text = title or "Paragraph"
            pTitle.TextColor3 = Color3.fromRGB(255, 70, 70)
            pTitle.Font = Enum.Font.GothamBold
            pTitle.TextSize = 13
            pTitle.TextXAlignment = Enum.TextXAlignment.Left
            pTitle.Parent = pFrame

            local pDesc = Instance.new("TextLabel")
            pDesc.Size = UDim2.new(1, 0, 0, 0)
            pDesc.AutomaticSize = Enum.AutomaticSize.Y
            pDesc.Position = UDim2.new(0, 0, 0, 20)
            pDesc.BackgroundTransparency = 1
            pDesc.Text = desc or ""
            pDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
            pDesc.Font = Enum.Font.Gotham
            pDesc.TextSize = 11
            pDesc.TextWrapped = true
            pDesc.TextXAlignment = Enum.TextXAlignment.Left
            pDesc.Parent = pFrame
        end

        function Tab:AddButton(text, callback)
            callback = callback or function() end
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -6, 0, 34)
            btn.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
            btn.Text = text or "Button"
            btn.TextColor3 = Color3.fromRGB(235, 235, 235)
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 12
            btn.AutoButtonColor = false
            btn.Parent = TabContent

            local bCorner = Instance.new("UICorner")
            bCorner.CornerRadius = UDim.new(0, 6)
            bCorner.Parent = btn

            local bStroke = Instance.new("UIStroke")
            bStroke.Color = Color3.fromRGB(50, 50, 50)
            bStroke.Thickness = 1
            bStroke.Parent = btn

            btn.MouseButton1Click:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(255, 43, 43)}):Play()
                task.wait(0.08)
                TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(32, 32, 32)}):Play()
                callback()
            end)
        end

        function Tab:AddToggle(text, default, callback)
            default = default or false
            callback = callback or function() end
            local state = default

            local tFrame = Instance.new("TextButton")
            tFrame.Size = UDim2.new(1, -6, 0, 34)
            tFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            tFrame.Text = ""
            tFrame.AutoButtonColor = false
            tFrame.Parent = TabContent

            local tCorner = Instance.new("UICorner")
            tCorner.CornerRadius = UDim.new(0, 6)
            tCorner.Parent = tFrame

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -50, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text or "Toggle"
            label.TextColor3 = Color3.fromRGB(220, 220, 220)
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = tFrame

            local switch = Instance.new("Frame")
            switch.Size = UDim2.new(0, 36, 0, 18)
            switch.Position = UDim2.new(1, -44, 0.5, -9)
            switch.BackgroundColor3 = state and Color3.fromRGB(255, 43, 43) or Color3.fromRGB(45, 45, 45)
            switch.Parent = tFrame

            local sCorner = Instance.new("UICorner")
            sCorner.CornerRadius = UDim.new(1, 0)
            sCorner.Parent = switch

            local dot = Instance.new("Frame")
            dot.Size = UDim2.new(0, 14, 0, 14)
            dot.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            dot.Parent = switch

            local dCorner = Instance.new("UICorner")
            dCorner.CornerRadius = UDim.new(1, 0)
            dCorner.Parent = dot

            tFrame.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(switch, TweenInfo.new(0.15), {
                    BackgroundColor3 = state and Color3.fromRGB(255, 43, 43) or Color3.fromRGB(45, 45, 45)
                }):Play()
                TweenService:Create(dot, TweenInfo.new(0.15), {
                    Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                }):Play()
                callback(state)
            end)
        end

        function Tab:AddSlider(text, min, max, default, callback)
            min = min or 0
            max = max or 100
            default = default or min
            callback = callback or function() end

            local sFrame = Instance.new("Frame")
            sFrame.Size = UDim2.new(1, -6, 0, 44)
            sFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            sFrame.Parent = TabContent

            local sCorner = Instance.new("UICorner")
            sCorner.CornerRadius = UDim.new(0, 6)
            sCorner.Parent = sFrame

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -60, 0, 20)
            label.Position = UDim2.new(0, 10, 0, 4)
            label.BackgroundTransparency = 1
            label.Text = text or "Slider"
            label.TextColor3 = Color3.fromRGB(220, 220, 220)
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = sFrame

            local valLabel = Instance.new("TextLabel")
            valLabel.Size = UDim2.new(0, 50, 0, 20)
            valLabel.Position = UDim2.new(1, -55, 0, 4)
            valLabel.BackgroundTransparency = 1
            valLabel.Text = tostring(default)
            valLabel.TextColor3 = Color3.fromRGB(255, 43, 43)
            valLabel.Font = Enum.Font.GothamBold
            valLabel.TextSize = 12
            valLabel.TextXAlignment = Enum.TextXAlignment.Right
            valLabel.Parent = sFrame

            local barBack = Instance.new("Frame")
            barBack.Size = UDim2.new(1, -20, 0, 6)
            barBack.Position = UDim2.new(0, 10, 0, 28)
            barBack.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            barBack.BorderSizePixel = 0
            barBack.Parent = sFrame

            local bCorner = Instance.new("UICorner")
            bCorner.CornerRadius = UDim.new(1, 0)
            bCorner.Parent = barBack

            local barFill = Instance.new("Frame")
            barFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            barFill.BackgroundColor3 = Color3.fromRGB(255, 43, 43)
            barFill.BorderSizePixel = 0
            barFill.Parent = barBack

            local fCorner = Instance.new("UICorner")
            fCorner.CornerRadius = UDim.new(1, 0)
            fCorner.Parent = barFill

            local sliding = false
            local function update(input)
                local ratio = math.clamp((input.Position.X - barBack.AbsolutePosition.X) / barBack.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + ((max - min) * ratio))
                barFill.Size = UDim2.new(ratio, 0, 1, 0)
                valLabel.Text = tostring(value)
                callback(value)
            end

            barBack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    update(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    update(input)
                end
            end)
        end

        function Tab:AddInput(text, placeholder, callback)
            callback = callback or function() end

            local iFrame = Instance.new("Frame")
            iFrame.Size = UDim2.new(1, -6, 0, 34)
            iFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            iFrame.Parent = TabContent

            local iCorner = Instance.new("UICorner")
            iCorner.CornerRadius = UDim.new(0, 6)
            iCorner.Parent = iFrame

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.5, 0, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text or "Input"
            label.TextColor3 = Color3.fromRGB(220, 220, 220)
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = iFrame

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(0.45, 0, 0, 24)
            box.Position = UDim2.new(0.53, 0, 0.5, -12)
            box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            box.PlaceholderText = placeholder or "Type..."
            box.Text = ""
            box.TextColor3 = Color3.fromRGB(255, 255, 255)
            box.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
            box.Font = Enum.Font.Gotham
            box.TextSize = 11
            box.ClearTextOnFocus = false
            box.Parent = iFrame

            local bCorner = Instance.new("UICorner")
            bCorner.CornerRadius = UDim.new(0, 4)
            bCorner.Parent = box

            box.FocusLost:Connect(function(enterPressed)
                callback(box.Text, enterPressed)
            end)
        end

        function Tab:AddKeybind(text, defaultKey, callback)
            local currentKey = defaultKey or Enum.KeyCode.E
            callback = callback or function() end
            local binding = false

            local kFrame = Instance.new("Frame")
            kFrame.Size = UDim2.new(1, -6, 0, 34)
            kFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            kFrame.Parent = TabContent

            local kCorner = Instance.new("UICorner")
            kCorner.CornerRadius = UDim.new(0, 6)
            kCorner.Parent = kFrame

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -90, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text or "Keybind"
            label.TextColor3 = Color3.fromRGB(220, 220, 220)
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = kFrame

            local bindBtn = Instance.new("TextButton")
            bindBtn.Size = UDim2.new(0, 75, 0, 22)
            bindBtn.Position = UDim2.new(1, -82, 0.5, -11)
            bindBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            bindBtn.Text = currentKey.Name
            bindBtn.TextColor3 = Color3.fromRGB(255, 43, 43)
            bindBtn.Font = Enum.Font.GothamBold
            bindBtn.TextSize = 11
            bindBtn.Parent = kFrame

            local bCorner = Instance.new("UICorner")
            bCorner.CornerRadius = UDim.new(0, 4)
            bCorner.Parent = bindBtn

            bindBtn.MouseButton1Click:Connect(function()
                binding = true
                bindBtn.Text = "..."
            end)

            UserInputService.InputBegan:Connect(function(input, gpe)
                if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode
                    bindBtn.Text = currentKey.Name
                    binding = false
                elseif not gpe and input.KeyCode == currentKey then
                    callback(currentKey)
                end
            end)
        end

        function Tab:AddDropdown(text, list, callback)
            list = list or {}
            callback = callback or function() end
            local opened = false

            local dFrame = Instance.new("Frame")
            dFrame.Size = UDim2.new(1, -6, 0, 34)
            dFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            dFrame.ClipsDescendants = true
            dFrame.Parent = TabContent

            local dCorner = Instance.new("UICorner")
            dCorner.CornerRadius = UDim.new(0, 6)
            dCorner.Parent = dFrame

            local topBtn = Instance.new("TextButton")
            topBtn.Size = UDim2.new(1, 0, 0, 34)
            topBtn.BackgroundTransparency = 1
            topBtn.Text = ""
            topBtn.Parent = dFrame

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -40, 0, 34)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text or "Dropdown"
            label.TextColor3 = Color3.fromRGB(220, 220, 220)
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = topBtn

            local arrow = Instance.new("TextLabel")
            arrow.Size = UDim2.new(0, 20, 0, 34)
            arrow.Position = UDim2.new(1, -25, 0, 0)
            arrow.BackgroundTransparency = 1
            arrow.Text = "▼"
            arrow.TextColor3 = Color3.fromRGB(255, 43, 43)
            arrow.Font = Enum.Font.Gotham
            arrow.TextSize = 10
            arrow.Parent = topBtn

            local itemContainer = Instance.new("Frame")
            itemContainer.Size = UDim2.new(1, -16, 0, #list * 26)
            itemContainer.Position = UDim2.new(0, 8, 0, 36)
            itemContainer.BackgroundTransparency = 1
            itemContainer.Parent = dFrame

            local iLayout = Instance.new("UIListLayout")
            iLayout.Padding = UDim.new(0, 3)
            iLayout.Parent = itemContainer

            for _, opt in ipairs(list) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 23)
                optBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
                optBtn.Text = opt
                optBtn.TextColor3 = Color3.fromRGB(190, 190, 190)
                optBtn.Font = Enum.Font.Gotham
                optBtn.TextSize = 11
                optBtn.Parent = itemContainer

                local oCorner = Instance.new("UICorner")
                oCorner.CornerRadius = UDim.new(0, 4)
                oCorner.Parent = optBtn

                optBtn.MouseButton1Click:Connect(function()
                    label.Text = text .. " : " .. opt
                    opened = false
                    TweenService:Create(dFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -6, 0, 34)}):Play()
                    arrow.Text = "▼"
                    callback(opt)
                end)
            end

            topBtn.MouseButton1Click:Connect(function()
                opened = not opened
                arrow.Text = opened and "▲" or "▼"
                local targetHeight = opened and (42 + (#list * 26)) or 34
                TweenService:Create(dFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -6, 0, targetHeight)}):Play()
            end)
        end

        function Tab:AddMultiDropdown(text, list, callback)
            list = list or {}
            callback = callback or function() end
            local opened = false
            local selected = {}

            local dFrame = Instance.new("Frame")
            dFrame.Size = UDim2.new(1, -6, 0, 34)
            dFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            dFrame.ClipsDescendants = true
            dFrame.Parent = TabContent

            local dCorner = Instance.new("UICorner")
            dCorner.CornerRadius = UDim.new(0, 6)
            dCorner.Parent = dFrame

            local topBtn = Instance.new("TextButton")
            topBtn.Size = UDim2.new(1, 0, 0, 34)
            topBtn.BackgroundTransparency = 1
            topBtn.Text = ""
            topBtn.Parent = dFrame

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -40, 0, 34)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text or "Multi-Dropdown"
            label.TextColor3 = Color3.fromRGB(220, 220, 220)
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = topBtn

            local arrow = Instance.new("TextLabel")
            arrow.Size = UDim2.new(0, 20, 0, 34)
            arrow.Position = UDim2.new(1, -25, 0, 0)
            arrow.BackgroundTransparency = 1
            arrow.Text = "▼"
            arrow.TextColor3 = Color3.fromRGB(255, 43, 43)
            arrow.Font = Enum.Font.Gotham
            arrow.TextSize = 10
            arrow.Parent = topBtn

            local itemContainer = Instance.new("Frame")
            itemContainer.Size = UDim2.new(1, -16, 0, #list * 26)
            itemContainer.Position = UDim2.new(0, 8, 0, 36)
            itemContainer.BackgroundTransparency = 1
            itemContainer.Parent = dFrame

            local iLayout = Instance.new("UIListLayout")
            iLayout.Padding = UDim.new(0, 3)
            iLayout.Parent = itemContainer

            for _, opt in ipairs(list) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 23)
                optBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
                optBtn.Text = opt
                optBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
                optBtn.Font = Enum.Font.Gotham
                optBtn.TextSize = 11
                optBtn.Parent = itemContainer

                local oCorner = Instance.new("UICorner")
                oCorner.CornerRadius = UDim.new(0, 4)
                oCorner.Parent = optBtn

                optBtn.MouseButton1Click:Connect(function()
                    if table.find(selected, opt) then
                        table.remove(selected, table.find(selected, opt))
                        optBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
                    else
                        table.insert(selected, opt)
                        optBtn.TextColor3 = Color3.fromRGB(255, 43, 43)
                    end
                    callback(selected)
                end)
            end

            topBtn.MouseButton1Click:Connect(function()
                opened = not opened
                arrow.Text = opened and "▲" or "▼"
                local targetHeight = opened and (42 + (#list * 26)) or 34
                TweenService:Create(dFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -6, 0, targetHeight)}):Play()
            end)
        end

        return Tab
    end

    return Window
end

return Library
