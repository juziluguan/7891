-- 橙c美式UI库 v1.0 - 修复标签拖动问题
local OrangeUI = {}

function OrangeUI:Init(config)
    config = config or {}
    
    self.WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
    
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
    
    -- 标签容器
    self.Tags = {
        left = {},
        right = {}
    }
    
    self.Tabs = {}
    return self
end

-- 定义标签位置（修复拖动问题）
function OrangeUI:tag(position, title, color, radius)
    position = position or "right" -- 默认在右侧
    
    local tagObj = self.Window:Tag({
        Title = title,
        Color = color or Color3.fromHex("#FFA500"),
        Radius = radius or 999
    })
    
    -- 存储标签对象
    table.insert(self.Tags[position], tagObj)
    
    -- 立即添加拖动功能（修复版）
    self:makeTagDraggable(tagObj)
    
    return tagObj
end

-- 使标签可拖动（修复版）
function OrangeUI:makeTagDraggable(tagObj)
    task.spawn(function()
        local maxAttempts = 20
        local attempt = 0
        
        while attempt < maxAttempts do
            attempt = attempt + 1
            
            if tagObj and tagObj.Instance and tagObj.Instance:FindFirstChildWhichIsA("TextButton") then
                local frame = tagObj.Instance
                local textButton = frame:FindFirstChildWhichIsA("TextButton")
                
                if textButton then
                    local dragToggle = false
                    local dragInput, dragStart, startPos
                    
                    -- 在TextButton上添加拖动事件
                    textButton.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragToggle = true
                            dragStart = input.Position
                            startPos = frame.Position
                            
                            -- 提高标签层级
                            frame.ZIndex = 10
                            
                            input.Changed:Connect(function()
                                if input.UserInputState == Enum.UserInputState.End then
                                    dragToggle = false
                                    frame.ZIndex = 1
                                end
                            end)
                        end
                    end)
                    
                    textButton.InputChanged:Connect(function(input)
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
                    
                    break -- 成功添加拖动功能，退出循环
                end
            end
            
            task.wait(0.1) -- 等待标签完全创建
        end
    end)
end

-- 创建时间标签
function OrangeUI:createTimeTag()
    self.TimeTag = self:tag("right", "00:00:00", Color3.fromHex("#FFA500"))
    
    -- 更新时间
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
        -- 清除所有标签
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
