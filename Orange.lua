-- 橙c美式UI库 - 充分利用WindUI功能版
local OrangeUI = {}

function OrangeUI:Init(config)
    config = config or {}
    
    self.WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
    
    -- 存储配置
    self.Config = config
    
    -- 显示欢迎弹窗（使用WindUI的高级弹窗功能）
    self.WindUI:Popup({
        Title = config.Title or "橙C美式",
        Subtitle = config.Subtitle or "多功能脚本管理器", -- 副标题
        Icon = "sparkles",
        Content = config.Description or "感谢使用橙C美式脚本",
        Duration = 5, -- 显示时间
        Buttons = {
            {
                Title = "进入脚本",
                Icon = "arrow-right",
                Variant = "Primary",
                Callback = function() 
                    self:createMainWindow(config)
                end
            },
            {
                Title = "取消",
                Icon = "x",
                Variant = "Secondary",
                Callback = function()
                    self.WindUI:Notify({Title = "提示", Content = "已取消加载", Icon = "info"})
                end
            }
        }
    })
    
    return self
end

function OrangeUI:createMainWindow(config)
    -- 使用WindUI的完整窗口配置
    self.Window = self.WindUI:CreateWindow({
        Title = config.Title or "橙C美式",
        Subtitle = config.Subtitle or "by 橙C", -- 副标题！
        Size = config.Size or UDim2.fromOffset(500, 450),
        Position = config.Position, -- 窗口位置
        Folder = config.Folder or "橙C美式UI",
        Theme = config.Theme or "Dark",
        ToggleKey = config.ToggleKey or Enum.KeyCode.RightShift,
        Resizable = config.Resizable or true, -- 允许调整大小
        MinSize = config.MinSize or UDim2.fromOffset(400, 350),
        MaxSize = config.MaxSize or UDim2.fromOffset(800, 600),
        Acrylic = config.Acrylic or true, -- 亚克力效果
        AcrylicColor = config.AcrylicColor or Color3.fromHex("#1a1a1a"),
        AcrylicTransparency = config.AcrylicTransparency or 0.8
    })
    
    -- 创建左下角用户信息（使用WindUI的标签功能）
    self:createUserInfo()
    
    -- 标签容器
    self.Tags = {
        left = {},
        right = {}
    }
    
    self.Tabs = {}
    
    -- 应用自定义字体
    self:applyCustomFonts()
    
    return self
end

-- 创建用户信息（左下角）
function OrangeUI:createUserInfo()
    task.spawn(function()
        task.wait(1)
        
        local player = game:GetService("Players").LocalPlayer
        local playerName = player.Name
        local displayName = player.DisplayName
        
        -- 使用WindUI创建左下角信息标签
        self.UserInfoTag = self.Window:Tag({
            Title = "👤 " .. (displayName ~= playerName and displayName or playerName),
            Color = Color3.fromHex("#333333"),
            Radius = 8,
            Transparent = true
        })
        
        -- 设置位置到左下角
        if self.UserInfoTag and self.UserInfoTag.Instance then
            task.wait(0.5)
            local frame = self.UserInfoTag.Instance
            frame.Position = UDim2.new(0, 15, 1, -40)
        end
    end)
end

-- 应用自定义字体
function OrangeUI:applyCustomFonts()
    if not self.Window then return end
    
    task.spawn(function()
        task.wait(1.5)
        
        local function applyFonts(obj)
            for _, child in ipairs(obj:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                    -- 根据元素特征设置不同字体
                    if child.TextSize >= 20 or string.find(string.lower(child.Name or ""), "title") then
                        child.FontFace = Enum.Font.GothamBold
                    elseif child:IsA("TextButton") then
                        child.FontFace = Enum.Font.GothamMedium
                    elseif child.TextSize <= 14 then
                        child.FontFace = Enum.Font.Gotham
                    else
                        child.FontFace = Enum.Font.Gotham
                    end
                end
            end
        end
        
        if self.Window.Instance then
            applyFonts(self.Window.Instance)
        end
    end)
end

-- 创建标签（充分利用WindUI标签功能）
function OrangeUI:tag(position, title, color, radius, transparent)
    position = position or "right"
    
    local tagObj = self.Window:Tag({
        Title = title,
        Color = color or Color3.fromHex("#FFA500"),
        Radius = radius or 8, -- 圆角
        Transparent = transparent or false,
        StrokeColor = Color3.fromHex("#ffffff"),
        StrokeTransparency = 0.8
    })
    
    table.insert(self.Tags[position], tagObj)
    
    -- 设置标签位置
    self:setTagPosition(tagObj, #self.Tags[position] - 1)
    
    -- 添加拖动功能
    self:makeTagDraggable(tagObj)
    
    return tagObj
end

-- 设置标签位置
function OrangeUI:setTagPosition(tagObj, positionIndex)
    task.spawn(function()
        local maxAttempts = 10
        local attempt = 0
        
        while attempt < maxAttempts do
            attempt = attempt + 1
            
            if tagObj and tagObj.Instance then
                local frame = tagObj.Instance
                local screenWidth = game:GetService("CoreGui").AbsoluteSize.X
                local tagWidth = frame.AbsoluteSize.X
                
                -- 专业布局：标签离标题更远
                local rightMargin = 25
                local topMargin = 80 -- 离顶部更远
                local spacing = 10
                local xPosition = screenWidth - tagWidth - rightMargin - (positionIndex * (tagWidth + spacing))
                
                frame.Position = UDim2.new(0, xPosition, 0, topMargin)
                break
            end
            task.wait(0.1)
        end
    end)
end

-- 创建时间标签
function OrangeUI:createTimeTag()
    self.TimeTag = self:tag("right", "🕒 00:00:00", Color3.fromHex("#FFA500"), 8, true)
    
    task.spawn(function()
        while self.TimeTag do
            local now = os.date("*t")
            local hours = string.format("%02d", now.hour)
            local minutes = string.format("%02d", now.min)
            local seconds = string.format("%02d", now.sec)
            
            if self.TimeTag and self.TimeTag.SetTitle then
                pcall(function()
                    self.TimeTag:SetTitle("🕒 " .. hours .. ":" .. minutes .. ":" .. seconds)
                end)
            end
            task.wait(1)
        end
    end)
    
    return self.TimeTag
end

-- 创建版本标签
function OrangeUI:createVersionTag(version)
    self.VersionTag = self:tag("right", "🚀 " .. (version or "v1.0"), Color3.fromHex("#4ECDC4"), 8, true)
    return self.VersionTag
end

-- 创建脚本状态标签
function OrangeUI:createStatusTag(status, color)
    self.StatusTag = self:tag("right", status or "✅ 已加载", color or Color3.fromHex("#96CEB4"), 8, true)
    return self.StatusTag
end

-- 使标签可拖动
function OrangeUI:makeTagDraggable(tagObj)
    task.spawn(function()
        local maxAttempts = 20
        local attempt = 0
        
        while attempt < maxAttempts do
            attempt = attempt + 1
            
            if tagObj and tagObj.Instance then
                local frame = tagObj.Instance
                
                local dragArea = Instance.new("TextButton")
                dragArea.Name = "DragArea"
                dragArea.Size = UDim2.new(0, 20, 0, 20)
                dragArea.Position = UDim2.new(1, -25, 0, 5)
                dragArea.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                dragArea.BackgroundTransparency = 0.8
                dragArea.Text = "⤢"
                dragArea.TextColor3 = Color3.fromRGB(0, 0, 0)
                dragArea.TextSize = 12
                dragArea.BorderSizePixel = 0
                dragArea.ZIndex = frame.ZIndex + 1
                dragArea.Parent = frame
                
                local dragToggle = false
                local dragInput, dragStart, startPos
                
                dragArea.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragToggle = true
                        dragStart = input.Position
                        startPos = frame.Position
                        frame.ZIndex = 10
                        dragArea.ZIndex = 11
                        
                        input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                dragToggle = false
                                frame.ZIndex = 1
                                dragArea.ZIndex = 2
                            end
                        end)
                    end
                end)
                
                dragArea.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        dragInput = input
                    end
                end)
                
                game:GetService("UserInputService").InputChanged:Connect(function(input)
                    if input == dragInput and dragToggle then
                        local delta = input.Position - dragStart
                        frame.Position = UDim2.new(
                            startPos.X.Scale, 
                            startPos.X.Offset + delta.X,
                            startPos.Y.Scale, 
                            startPos.Y.Offset + delta.Y
                        )
                    end
                end)
                
                break
            end
            task.wait(0.1)
        end
    end)
end

-- 重新排列标签
function OrangeUI:arrangeRightTags()
    local rightTags = self:getTags("right")
    for i, tag in ipairs(rightTags) do
        self:setTagPosition(tag, i - 1)
    end
end

-- 标签管理函数
function OrangeUI:getTags(position)
    return self.Tags[position] or {}
end

function OrangeUI:clearTags(position)
    if position then
        for _, tag in ipairs(self.Tags[position] or {}) do
            pcall(function() tag:Destroy() end)
        end
        self.Tags[position] = {}
    else
        for pos, tags in pairs(self.Tags) do
            for _, tag in ipairs(tags) do
                pcall(function() tag:Destroy() end)
            end
            self.Tags[pos] = {}
        end
    end
end

-- 页面创建函数
function OrangeUI:cz(title, icon, locked)
    local tab = self.Window:Tab({
        Title = title or "功能",
        Icon = icon or "zap",
        Locked = locked or false
    })
    self.Tabs[title or "功能"] = tab
    return tab
end

function OrangeUI:settings(title)
    local tab = self.Window:Tab({
        Title = title or "设置", 
        Icon = "settings",
        Locked = false
    })
    self.Tabs[title or "设置"] = tab
    return tab
end

-- 控件创建函数
function OrangeUI:btn(tab, title, desc, callback, variant, icon)
    return tab:Button({
        Title = title,
        Desc = desc,
        Callback = callback,
        Variant = variant or "Primary",
        Icon = icon
    })
end

function OrangeUI:toggle(tab, title, desc, value, callback)
    return tab:Toggle({
        Title = title,
        Desc = desc,
        Value = value or false,
        Callback = callback
    })
end

function OrangeUI:slider(tab, title, desc, value, min, max, callback, suffix)
    return tab:Slider({
        Title = title,
        Desc = desc,
        Value = {Default = value or 50, Min = min or 0, Max = max or 100},
        Callback = callback,
        Suffix = suffix or ""
    })
end

function OrangeUI:input(tab, title, desc, placeholder, callback)
    return tab:Input({
        Title = title,
        Desc = desc,
        Placeholder = placeholder or "请输入...",
        Callback = callback
    })
end

function OrangeUI:dropdown(tab, title, desc, options, default, callback)
    return tab:Dropdown({
        Title = title,
        Desc = desc,
        Values = options or {},
        Value = default,
        Callback = callback
    })
end

function OrangeUI:color(tab, title, desc, default, callback)
    return tab:Colorpicker({
        Title = title,
        Desc = desc,
        Default = default or Color3.fromRGB(255, 165, 0),
        Callback = callback
    })
end

function OrangeUI:keybind(tab, title, desc, default, callback)
    return tab:Keybind({
        Title = title,
        Desc = desc,
        Value = default or "RightShift",
        Callback = callback
    })
end

function OrangeUI:paragraph(tab, title, desc)
    return tab:Paragraph({
        Title = title,
        Desc = desc
    })
end

-- 通知功能
function OrangeUI:notify(title, content, icon, duration)
    self.WindUI:Notify({
        Title = title,
        Content = content,
        Icon = icon or "info",
        Duration = duration or 5
    })
end

-- 主题设置
function OrangeUI:setTheme(theme)
    self.WindUI:SetTheme(theme)
    self:notify("主题切换", "已切换到 " .. theme .. " 主题", "palette", 3)
end

return OrangeUI
