-- ShadowDarkness UI Library
-- GitHub: https://github.com/TynaRan/ShadowDarkness
--------------------------------------------------------------------------

local ShadowDarkness = {}
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

ShadowDarkness.AccentColor = Color3.fromRGB(255, 255, 255)
ShadowDarkness.Theme = {
    Background = Color3.fromRGB(30, 30, 30),
    TopBar = Color3.fromRGB(25, 25, 25),
    Section = Color3.fromRGB(35, 35, 35),
    Element = Color3.fromRGB(40, 40, 40),
    Text = Color3.fromRGB(220, 220, 220),
    Divider = Color3.fromRGB(255, 255, 255)
}

local function createElement(type, parent, props)
    local element = Instance.new(type)
    for k, v in pairs(props) do
        element[k] = v
    end
    element.Parent = parent
    return element
end

ShadowDarkness.Window = {}
function ShadowDarkness.Window.new(title)
    local self = {}

    self.ScreenGui = createElement("ScreenGui", game.CoreGui, {
        Name = "ShadowDarknessUI"
    })

    self.MainFrame = createElement("Frame", self.ScreenGui, {
        Name = "MainFrame",
        BackgroundColor3 = ShadowDarkness.Theme.Background,
        Position = UDim2.new(0.3, 0, 0.3, 0),
        Size = UDim2.new(0, 550, 0, 685),
        BorderSizePixel = 0
    })

    self.TopBar = createElement("Frame", self.MainFrame, {
        Name = "TopBar",
        BackgroundColor3 = ShadowDarkness.Theme.TopBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30)
    })

    self.divider = createElement("Frame", self.MainFrame, {  
        Name = "Divider",  
        BackgroundColor3 = ShadowDarkness.Theme.Divider,  
        BorderSizePixel = 0,  
        Position = UDim2.new(0, 0, 0, 25),  
        Size = UDim2.new(1, 0, 0, 1)  
    })

    createElement("TextLabel", self.TopBar, {
        Name = "Title",
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0, 200, 1, 0),
        Font = Enum.Font.Code,
        Text = title or "ShadowDarkness",
        TextColor3 = ShadowDarkness.Theme.Text,
        TextSize = 14,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    self.TabContainer = createElement("Frame", self.MainFrame, {
        Name = "TabContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(1, 0, 0, 30)
    })

    self.ContentContainer = createElement("Frame", self.MainFrame, {
        Name = "ContentContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 60),
        Size = UDim2.new(1, 0, 1, -60)
    })

    function self:AddTab(name)
        local tab = {}

        tab.Button = createElement("TextButton", self.TabContainer, {
            Name = name,
            BackgroundColor3 = ShadowDarkness.Theme.TopBar,
            Size = UDim2.new(0, 100, 1, 0),
            Font = Enum.Font.Code,
            Text = name,
            TextColor3 = ShadowDarkness.Theme.Text,
            TextSize = 12,
            BorderSizePixel = 0
        })

        tab.Container = createElement("Frame", self.ContentContainer, {
            Name = "Container",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false
        })

        tab.LeftColumn = createElement("ScrollingFrame", tab.Container, {
            Name = "LeftColumn",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(0.5, -15, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 4
        })

        tab.RightColumn = createElement("ScrollingFrame", tab.Container, {
            Name = "RightColumn",
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 5, 0, 0),
            Size = UDim2.new(0.5, -15, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 4
        })

        tab.LeftLayout = createElement("UIListLayout", tab.LeftColumn, {
            Padding = UDim.new(0, 10)
        })

        tab.RightLayout = createElement("UIListLayout", tab.RightColumn, {
            Padding = UDim.new(0, 10)
        })

        tab.Button.MouseButton1Click:Connect(function()
            for _, otherTab in pairs(self.Tabs) do
                otherTab.Container.Visible = false
            end
            tab.Container.Visible = true
        end)

        self.Tabs = self.Tabs or {}
        self.Tabs[name] = tab

        if not self.CurrentTab then
            self.CurrentTab = name
            tab.Container.Visible = true
        end

        function tab:AddSection(side, dividerText)
            local section = {}
            local parent = side == "right" and tab.RightColumn or tab.LeftColumn
            local layout = side == "right" and tab.RightLayout or tab.LeftLayout

            section.Frame = createElement("Frame", parent, {
                Name = "Section",
                BackgroundColor3 = ShadowDarkness.Theme.Section,
                Size = UDim2.new(1, 0, 0, 0),
                BorderSizePixel = 0
            })

            section.Container = createElement("Frame", section.Frame, {
                Name = "Container",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0)
            })

            section.Layout = createElement("UIListLayout", section.Container, {
                Padding = UDim.new(0, 5)
            })

            if dividerText and dividerText ~= "" then
                createElement("TextLabel", section.Container, {
                    Name = "Divider",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = Enum.Font.Code,
                    Text = dividerText,
                    TextColor3 = ShadowDarkness.Theme.Text,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            end

            section.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                section.Container.Size = UDim2.new(1, 0, 0, section.Layout.AbsoluteContentSize.Y)
                section.Frame.Size = UDim2.new(1, 0, 0, section.Layout.AbsoluteContentSize.Y)
                parent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
            end)

            function section:AddLabel(text)
                return createElement("TextLabel", section.Container, {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = Enum.Font.Code,
                    Text = text,
                    TextColor3 = ShadowDarkness.Theme.Text,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            end

            function section:AddButton(text, callback)
                local button = createElement("TextButton", section.Container, {
                    Name = "Button",
                    BackgroundColor3 = ShadowDarkness.Theme.Element,
                    Size = UDim2.new(1, 0, 0, 25),
                    Font = Enum.Font.Code,
                    Text = text,
                    TextColor3 = ShadowDarkness.Theme.Text,
                    TextSize = 12,
                    BorderSizePixel = 0,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                button.MouseButton1Click:Connect(function()
                    if callback then callback() end
                end)
                return button
            end

            function section:AddTextbox(text, placeholder, callback)
                local frame = createElement("Frame", section.Container, {
                    Name = "TextBox",
                    BackgroundColor3 = ShadowDarkness.Theme.Element,
                    Size = UDim2.new(1, 0, 0, 25),
                    BorderSizePixel = 0
                })
                createElement("TextLabel", frame, {
                    Name = "Label",
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(0, 150, 1, 0),
                    Font = Enum.Font.Code,
                    Text = text,
                    TextColor3 = ShadowDarkness.Theme.Text,
                    TextSize = 12,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                local box = createElement("TextBox", frame, {
                    Name = "Box",
                    BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                    Position = UDim2.new(1, -150, 0.5, -10),
                    Size = UDim2.new(0, 140, 0, 20),
                    Font = Enum.Font.Code,
                    PlaceholderText = placeholder,
                    Text = "",
                    TextColor3 = ShadowDarkness.Theme.Text,
                    TextSize = 12,
                    BorderSizePixel = 0
                })
                box.FocusLost:Connect(function()
                    if callback then callback(box.Text) end
                end)
                return frame
            end

            function section:AddToggle(text, default, callback)
                local frame = createElement("Frame", section.Container, {
                    Name = "Toggle",
                    BackgroundColor3 = ShadowDarkness.Theme.Element,
                    Size = UDim2.new(1, 0, 0, 25),
                    BorderSizePixel = 0
                })
                createElement("TextLabel", frame, {
                    Name = "Label",
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(0, 150, 1, 0),
                    Font = Enum.Font.Code,
                    Text = text,
                    TextColor3 = ShadowDarkness.Theme.Text,
                    TextSize = 12,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                local button = createElement("TextButton", frame, {
                    Name = "Button",
                    BackgroundColor3 = default and ShadowDarkness.AccentColor or Color3.fromRGB(60, 60, 60),
                    Position = UDim2.new(1, -30, 0.5, -10),
                    Size = UDim2.new(0, 20, 0, 20),
                    Font = Enum.Font.Code,
                    Text = "",
                    TextColor3 = ShadowDarkness.Theme.Text,
                    TextSize = 12,
                    BorderSizePixel = 0
                })
                local value = default
                button.MouseButton1Click:Connect(function()
                    value = not value
                    button.BackgroundColor3 = value and ShadowDarkness.AccentColor or Color3.fromRGB(60, 60 ,60)
                    if callback then callback(value) end
                end)
                return frame
            end

            return section
        end

        return tab
    end

    
    local dragging, dragStart, startPos
    self.TopBar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = inp.Position
            startPos = self.MainFrame.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local delta = inp.Position - dragStart
            local pos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(self.MainFrame, TweenInfo.new(0.25), {Position = pos}):Play()
        end
    end)

    return self
end
return ShadowDarkness
