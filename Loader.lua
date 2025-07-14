local CartoWare = {}
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

CartoWare.AccentColor = Color3.fromRGB(0, 120, 215)
CartoWare.Theme = {
    Background = Color3.fromRGB(30, 30, 30),
    TopBar = Color3.fromRGB(25, 25, 25),
    Section = Color3.fromRGB(35, 35, 35),
    Element = Color3.fromRGB(40, 40, 40),
    Text = Color3.fromRGB(220, 220, 220),
    Divider = Color3.fromRGB(60, 60, 60)
}

local function createElement(type, parent, props)
    local element = Instance.new(type)
    for k, v in pairs(props) do
        element[k] = v
    end
    element.Parent = parent
    return element
end

CartoWare.Window = {}
function CartoWare.Window.new(title)
    local self = {}

    self.ScreenGui = createElement("ScreenGui", game.CoreGui, {
        Name = "CartoWareUI"
    })

    self.MainFrame = createElement("Frame", self.ScreenGui, {
        Name = "MainFrame",
        BackgroundColor3 = CartoWare.Theme.Background,
        Position = UDim2.new(0.3, 0, 0.3, 0),
        Size = UDim2.new(0, 550, 0, 500)
    })

    self.TopBar = createElement("Frame", self.MainFrame, {
        Name = "TopBar",
        BackgroundColor3 = CartoWare.Theme.TopBar,
        Size = UDim2.new(1, 0, 0, 30)
    })

    createElement("TextLabel", self.TopBar, {
        Name = "Title",
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0, 200, 1, 0),
        Font = Enum.Font.Code,
        Text = title or "CartoWare",
        TextColor3 = CartoWare.Theme.Text,
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
            BackgroundColor3 = CartoWare.Theme.TopBar,
            Size = UDim2.new(0, 100, 1, 0),
            Font = Enum.Font.Code,
            Text = name,
            TextColor3 = CartoWare.Theme.Text,
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
                BackgroundColor3 = CartoWare.Theme.Section,
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
                    TextColor3 = CartoWare.Theme.Text,
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
                    TextColor3 = CartoWare.Theme.Text,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            end

            function section:AddButton(text, callback)
                local button = createElement("TextButton", section.Container, {
                    Name = "Button",
                    BackgroundColor3 = CartoWare.Theme.Element,
                    Size = UDim2.new(1, 0, 0, 25),
                    Font = Enum.Font.Code,
                    Text = text,
                    TextColor3 = CartoWare.Theme.Text,
                    TextSize = 12,
                    BorderSizePixel = 0
                })
                button.MouseButton1Click:Connect(function()
                    if callback then callback() end
                end)
                return button
            end

            function section:AddTextbox(text, placeholder, callback)
                local frame = createElement("Frame", section.Container, {
                    Name = "TextBox",
                    BackgroundColor3 = CartoWare.Theme.Element,
                    Size = UDim2.new(1, 0, 0, 25),
                    BorderSizePixel = 0
                })
                createElement("TextLabel", frame, {
                    Name = "Label",
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(0, 150, 1, 0),
                    Font = Enum.Font.Code,
                    Text = text,
                    TextColor3 = CartoWare.Theme.Text,
                    TextSize = 12,
                    BackgroundTransparency = 1
                })
                local box = createElement("TextBox", frame, {
                    Name = "Box",
                    BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                    Position = UDim2.new(1, -150, 0.5, -10),
                    Size = UDim2.new(0, 140, 0, 20),
                    Font = Enum.Font.Code,
                    PlaceholderText = placeholder,
                    Text = "",
                    TextColor3 = CartoWare.Theme.Text,
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
                    BackgroundColor3 = CartoWare.Theme.Element,
                    Size = UDim2.new(1, 0, 0, 25),
                    BorderSizePixel = 0
                })
                createElement("TextLabel", frame, {
                    Name = "Label",
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(0, 150, 1, 0),
                    Font = Enum.Font.Code,
                    Text = text,
                    TextColor3 = CartoWare.Theme.Text,
                    TextSize = 12,
                    BackgroundTransparency = 1
                })
                local button = createElement("TextButton", frame, {
                    Name = "Button",
                    BackgroundColor3 = default and CartoWare.AccentColor or Color3.fromRGB(60, 60, 60),
                    Position = UDim2.new(1, -30, 0.5, -10),
                    Size = UDim2.new(0, 20, 0, 20),
                    Font = Enum.Font.Code,
                    Text = "",
                    TextColor3 = CartoWare.Theme.Text,
                    TextSize = 12,
                    BorderSizePixel = 0
                })
                local value = default
                button.MouseButton1Click:Connect(function()
    value = not value
    button.BackgroundColor3 = value and CartoWare.AccentColor or Color3.fromRGB(60, 60, 60)
    if callback then callback(value) end
end)
return frame
end
return section
end
return tab
end
return self
end
