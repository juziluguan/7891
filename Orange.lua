-- 橙c美式UI库 v1.0 - 带可拖动标签功能
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
    
    -- 存储所有标签实例
    self.AllTags = {}
    
    self.Tabs = {}
    return self
end

-- 定义标签位置（添加可拖动功能）
function OrangeUI:tag(position, title, color, radius)
    position = position or "right" -- 默认在右侧
    
    local tagObj = self.Window:Tag({
        Title = title,
        Color = color or Color3.fromHex("#FFA500"),
        Radius = radius or 999
    })
    
    -- 存储标签对象
    table.insert(self.Tags[position], tagObj)
    table.insert(self.AllTags, tagObj)
    
    -- 添加可拖动功能
    self:makeTagDraggable(tagObj)
    
    return tagObj
end

-- 使标签可拖动
function OrangeUI:makeTagDraggable(tagObj)
    -- 等待标签实例创建
    task.spawn(function()
        local maxWait = 50 -- 最大等待次数
        local waitCount = 0
        
        while not tagObj.Instance and waitCount < maxWait do
            waitCount = waitCount + 1
            task.wait(0.1)
        end
        
        if tagObj.Instance then
            local frame = tagObj.Instance
            local dragToggle = false
            local dragInput, dragStart, startPos
            
            -- 鼠标按下事件
            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragToggle = true
                    dragStart = input.Position
                    startPos = frame.Position
                    
                    -- 提高标签层级
                    frame.ZIndex = 10
                    
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragToggle = false
                            frame.ZIndex = 1 -- 恢复层级
                        end
                    end)
                end
            end)
            
            -- 鼠标移动事件
            frame.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    dragInput = input
                end
            end)
            
            -- 更新位置
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
        end
    end)
end

-- 创建脚本名称标签（固定位置）
function OrangeUI:createScriptNameTag()
    self.ScriptNameTag = self:tag("right", "橙C美式 2.0", Color3.fromHex("#FF6B35"))
    return self.ScriptNameTag
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

-- 获取所有标签
function OrangeUI:getAllTags()
    return self.AllTags
end

-- 清除特定位置的所有标签（修复版）
function OrangeUI:clearTags(position)
    if position then
        for i, tag in ipairs(self.Tags[position] or {}) do
            -- 从AllTags中移除
            for j, allTag in ipairs(self.AllTags) do
                if allTag == tag then
                    table.remove(self.AllTags, j)
                    break
                end
            end
            pcall(function() 
                if tag and tag.Instance then
                    tag.Instance:Destroy() 
                end
            end)
        end
        self.Tags[position] = {}
    else
        -- 清除所有标签
        for pos, tags in pairs(self.Tags) do
            for i, tag in ipairs(tags) do
                pcall(function() 
                    if tag and tag.Instance then
                        tag.Instance:Destroy() 
                    end
                end)
            end
            self.Tags[pos] = {}
        end
        self.AllTags = {}
    end
end

-- 清除所有自定义标签（保留固定标签）
function OrangeUI:clearCustomTags()
    local fixedTags = {
        self.TimeTag,
        self.VersionTag, 
        self.ScriptNameTag
    }
    
    local tagsToRemove = {}
    
    -- 找出所有非固定标签
    for i, tag in ipairs(self.AllTags) do
        local isFixed = false
        for _, fixedTag in ipairs(fixedTags) do
            if tag == fixedTag then
                isFixed = true
                break
            end
        end
        
        if not isFixed then
            table.insert(tagsToRemove, tag)
        end
    end
    
    -- 删除非固定标签
    for _, tag in ipairs(tagsToRemove) do
        -- 从位置容器中移除
        for pos, tags in pairs(self.Tags) do
            for i, posTag in ipairs(tags) do
                if posTag == tag then
                    table.remove(tags, i)
                    break
                end
            end
        end
        
        -- 从AllTags中移除
        for i, allTag in ipairs(self.AllTags) do
            if allTag == tag then
                table.remove(self.AllTags, i)
                break
            end
        end
        
        -- 销毁实例
        pcall(function() 
            if tag and tag.Instance then
                tag.Instance:Destroy()
            end
        end)
    end
end

-- 创建时间标签（右侧）
function OrangeUI:createTimeTag()
    self.TimeTag = self:tag("right", "00:00:00", Color3.fromHex("#FFA500"))
    
    -- 更新时间
    task.spawn(function()
        while self.TimeTag and (not self.TimeTag.Instance or self.TimeTag.Instance.Parent) do
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

-- 创建版本标签（右侧）
function OrangeUI:createVersionTag(version)
    self.VersionTag = self:tag("right", version or "v1.0", Color3.fromHex("#FFA500"))
    return self.VersionTag
end

-- 初始化固定标签
function OrangeUI:initFixedTags()
    self:createTimeTag()
    self:createVersionTag("v2.0")
    self:createScriptNameTag()
end

-- 排列所有标签
function OrangeUI:arrangeTags()
    local startX = 10
    local yPosition = 10
    
    for i, tag in ipairs(self.AllTags) do
        if tag and tag.Instance then
            pcall(function()
                tag.Instance.Position = UDim2.new(0, startX, 0, yPosition)
                startX = startX + tag.Instance.AbsoluteSize.X + 5
            end)
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
