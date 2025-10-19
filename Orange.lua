-- 橙c美式UI库 v1.0 - 支持自定义字体
local OrangeUI = {}

function OrangeUI:Init(config)
    config = config or {}
    
    self.WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
    
    -- 存储自定义字体设置
    self.CustomFonts = config.Font or {
        Title = Enum.Font.GothamBold,
        Content = Enum.Font.Gotham,
        Button = Enum.Font.GothamMedium
    }
    
    -- 显示欢迎弹窗
    self.WindUI:Popup({
        Title = "欢迎使用橙C美式",
        Icon = "sparkles",
        Content = "我的一个半缝合脚本",
        Buttons = {
            {
                Title = "进入脚本",
                Icon = "arrow-right",
                Variant = "Primary",
                Callback = function() 
                    print("进入脚本")
                    self:createMainWindow(config)
                end
            }
        }
    })
    
    return self
end

function OrangeUI:createMainWindow(config)
    self.Window = self.WindUI:CreateWindow({
        Title = config.Title or "橙c美式",
        Size = config.Size or UDim2.fromOffset(400, 300),
        Folder = config.Folder or "橙c美式UI",
        Theme = config.Theme or "Dark",
        ToggleKey = config.ToggleKey or Enum.KeyCode.RightShift,
        Resizable = config.Resizable or false
    })
    
    -- 应用自定义字体到窗口
    self:applyCustomFonts()
    
    -- 标签容器
    self.Tags = {
        left = {},
        right = {}
    }
    
    self.Tabs = {}
    return self
end

-- 应用自定义字体
function OrangeUI:applyCustomFonts()
    if not self.Window then return end
    
    -- 递归遍历所有UI元素并应用字体
    local function applyFontsToDescendants(obj)
        for _, child in ipairs(obj:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                -- 根据元素类型应用不同字体
                if string.find(string.lower(child.Name), "title") then
                    child.FontFace = self.CustomFonts.Title
                elseif child:IsA("TextButton") then
                    child.FontFace = self.CustomFonts.Button
                else
                    child.FontFace = self.CustomFonts.Content
                end
            end
        end
    end
    
    -- 应用到窗口
    applyFontsToDescendants(self.Window.Instance)
end

-- 设置自定义字体
function OrangeUI:setFont(fontType, font)
    if self.CustomFonts[fontType] then
        self.CustomFonts[fontType] = font
        self:applyCustomFonts()
    end
end

-- 设置所有字体
function OrangeUI:setAllFonts(fonts)
    if fonts.Title then self.CustomFonts.Title = fonts.Title end
    if fonts.Content then self.CustomFonts.Content = fonts.Content end
    if fonts.Button then self.CustomFonts.Button = fonts.Button end
    self:applyCustomFonts()
end

-- 定义标签位置
function OrangeUI:tag(position, title, color, radius)
    position = position or "right" -- 默认在右侧
    
    local tagObj = self.Window:Tag({
        Title = title,
        Color = color or Color3.fromHex("#FFA500"),
        Radius = radius or 999
    })
    
    -- 存储标签对象
    table.insert(self.Tags[position], tagObj)
    
    -- 添加拖动功能
    self:makeTagDraggableWithSmallArea(tagObj)
    
    return tagObj
end

-- 使标签可拖动（缩小移动区域版本）
function OrangeUI:makeTagDraggableWithSmallArea(tagObj)
    task.spawn(function()
        local maxAttempts = 20
        local attempt = 0
        
        while attempt < maxAttempts do
            attempt = attempt + 1
            
            if tagObj and tagObj.Instance then
                local frame = tagObj.Instance
                
                -- 创建一个小的拖动区域
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

-- 创建时间标签
function OrangeUI:createTimeTag()
    self.TimeTag = self:tag("right", "00:00:00", Color3.fromHex("#FFA500"))
    
    task.spawn(function()
        while self.TimeTag do
            local now = os.date("*t")
            local hours = string.format("%02d", now.hour)
            local minutes = string.format("%02d", now.min)
            local seconds = string.format("%02d", now.sec)
            
            if self.TimeTag and self.TimeTag.SetTitle then
                pcall(function()
                    self.TimeTag:SetTitle(hours .. ":" .. minutes .. ":" .. seconds)
                end)
            end
            task.wait(1)
        end
    end)
    
    return self.TimeTag
end

-- 创建版本标签
function OrangeUI:createVersionTag(version)
    self.VersionTag = self:tag("right", version or "v1.0", Color3.fromHex("#FFA500"))
    return self.VersionTag
end

-- 批量创建标签
function OrangeUI:createTags(tagList)
    for _, tagInfo in ipairs(tagList) do
        self:tag(tagInfo.position, tagInfo.title, tagInfo.color, tagInfo.radius)
    end
end

-- 获取特定位置的所有标签
function OrangeUI:getTags(position)
    return self.Tags[position] or {}
end

-- 清除特定位置的所有标签
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

function OrangeUI:cz(title)
    local tab = self.Window:Tab({
        Title = title or "功能",
        Icon = "zap"
    })
    self.Tabs[title or "功能"] = tab
    return tab
end

function OrangeUI:settings(title)
    local tab = self.Window:Tab({
        Title = title or "设置", 
        Icon = "settings"
    })
    self.Tabs[title or "设置"] = tab
    return tab
end

function OrangeUI:btn(tab, title, desc, callback)
    tab:Button({
        Title = title,
        Desc = desc,
        Callback = callback
    })
end

function OrangeUI:toggle(tab, title, desc, value, callback)
    tab:Toggle({
        Title = title,
        Desc = desc,
        Value = value or false,
        Callback = callback
    })
end

function OrangeUI:slider(tab, title, desc, value, min, max, callback)
    tab:Slider({
        Title = title,
        Desc = desc,
        Value = {Default = value or 50, Min = min or 0, Max = max or 100},
        Callback = callback
    })
end

function OrangeUI:input(tab, title, desc, placeholder, callback)
    tab:Input({
        Title = title,
        Desc = desc,
        Placeholder = placeholder or "请输入...",
        Callback = callback
    })
end

function OrangeUI:dropdown(tab, title, desc, options, default, callback)
    tab:Dropdown({
        Title = title,
        Desc = desc,
        Values = options or {},
        Value = default,
        Callback = callback
    })
end

function OrangeUI:color(tab, title, desc, default, callback)
    tab:Colorpicker({
        Title = title,
        Desc = desc,
        Default = default or Color3.fromRGB(255, 165, 0),
        Callback = callback
    })
end

function OrangeUI:keybind(tab, title, desc, default, callback)
    tab:Keybind({
        Title = title,
        Desc = desc,
        Value = default or "RightShift",
        Callback = callback
    })
end

function OrangeUI:notify(title, content, icon)
    self.WindUI:Notify({
        Title = title,
        Content = content,
        Icon = icon or "info"
    })
end

function OrangeUI:setTheme(theme)
    self.WindUI:SetTheme(theme)
    self:notify("主题切换", "已切换到 " .. theme .. " 主题", "palette")
end

return OrangeUI
