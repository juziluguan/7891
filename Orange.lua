-- 橙c美式UI库 v1.0 - 带可拖动标签
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
    self.Tags = {}
    self.DraggableTags = {} -- 存储可拖动的标签
    
    self.Tabs = {}
    return self
end

-- 创建可拖动的标签
function OrangeUI:tag(position, title, color, radius)
    local tagObj = self.Window:Tag({
        Title = title,
        Color = color or Color3.fromHex("#FFA500"),
        Radius = radius or 999
    })
    
    -- 存储标签对象
    table.insert(self.Tags, tagObj)
    
    -- 使标签可拖动
    self:makeTagDraggable(tagObj)
    
    return tagObj
end

-- 使标签可拖动
function OrangeUI:makeTagDraggable(tagObj)
    local frame = tagObj.Instance -- 获取标签的实际Frame
    if not frame then return end
    
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
    
    -- 存储为可拖动标签
    table.insert(self.DraggableTags, tagObj)
end

-- 创建时间标签
function OrangeUI:createTimeTag()
    self.TimeTag = self:tag("时间", "00:00:00", Color3.fromHex("#FFA500"))
    
    -- 更新时间
    task.spawn(function()
        while true do
            local now = os.date("*t")
            local hours = string.format("%02d", now.hour)
            local minutes = string.format("%02d", now.min)
            local seconds = string.format("%02d", now.sec)
            
            self.TimeTag:SetTitle(hours .. ":" .. minutes .. ":" .. seconds)
            task.wait(1)
        end
    end)
    
    return self.TimeTag
end

-- 创建版本标签
function OrangeUI:createVersionTag(version)
    self.VersionTag = self:tag("版本", version or "v2.0", Color3.fromHex("#FFA500"))
    return self.VersionTag
end

-- 创建脚本名称标签
function OrangeUI:createScriptNameTag()
    self.ScriptNameTag = self:tag("脚本名称", "橙C美式 2.0", Color3.fromHex("#FF6B35"))
    return self.ScriptNameTag
end

-- 修复：正确清除所有标签
function OrangeUI:clearTags()
    for i, tag in ipairs(self.Tags) do
        pcall(function() 
            if tag and tag.Instance then
                tag.Instance:Destroy()
            end
        end)
    end
    
    -- 清空标签表
    self.Tags = {}
    self.DraggableTags = {}
    
    -- 重新创建固定标签
    self:createTimeTag()
    self:createVersionTag("v2.0")
    self:createScriptNameTag()
end

-- 清除特定标签
function OrangeUI:removeTag(tagToRemove)
    for i, tag in ipairs(self.Tags) do
        if tag == tagToRemove then
            pcall(function() 
                if tag and tag.Instance then
                    tag.Instance:Destroy()
                end
            end)
            table.remove(self.Tags, i)
            break
        end
    end
    
    -- 也从可拖动标签中移除
    for i, tag in ipairs(self.DraggableTags) do
        if tag == tagToRemove then
            table.remove(self.DraggableTags, i)
            break
        end
    end
end

-- 初始化所有固定标签
function OrangeUI:initFixedTags()
    self:createTimeTag()
    self:createVersionTag("v2.0")
    self:createScriptNameTag()
end

-- 批量创建标签
function OrangeUI:createTags(tagList)
    for _, tagInfo in ipairs(tagList) do
        self:tag(tagInfo.position, tagInfo.title, tagInfo.color, tagInfo.radius)
    end
end

-- 获取所有标签
function OrangeUI:getTags()
    return self.Tags
end

-- 原有的其他函数保持不变
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
