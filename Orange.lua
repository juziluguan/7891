-- 橙c美式UI库 v1.0 - 带可移动标签位置
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
    
    -- 标签容器 - 现在支持多个位置
    self.Tags = {
        left = {},
        center_left = {},
        center = {},
        center_right = {},
        right = {},
        far_right = {}
    }
    
    self.Tabs = {}
    return self
end

-- 增强的标签位置定义
function OrangeUI:tag(position, title, color, radius)
    position = position or "right" -- 默认在右侧
    
    local tagObj = self.Window:Tag({
        Title = title,
        Color = color or Color3.fromHex("#FFA500"),
        Radius = radius or 999
    })
    
    -- 存储标签对象
    table.insert(self.Tags[position], tagObj)
    
    return tagObj
end

-- 创建脚本名称标签（固定在右侧）
function OrangeUI:createScriptNameTag()
    self.ScriptNameTag = self:tag("far_right", "橙C美式 2.0", Color3.fromHex("#FF6B35"))
    return self.ScriptNameTag
end

-- 创建时间标签（在脚本名称左边）
function OrangeUI:createTimeTag()
    self.TimeTag = self:tag("center_right", "00:00:00", Color3.fromHex("#FFA500"))
    
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

-- 创建版本标签（在时间标签左边）
function OrangeUI:createVersionTag(version)
    self.VersionTag = self:tag("center", version or "v2.0", Color3.fromHex("#FFA500"))
    return self.VersionTag
end

-- 创建可移动的用户标签（在版本标签左边）
function OrangeUI:createUserTag(text, color)
    return self:tag("center_left", text or "用户标签", color or Color3.fromHex("#4ECDC4"))
end

-- 创建左侧标签
function OrangeUI:createLeftTag(text, color)
    return self:tag("left", text or "左侧标签", color or Color3.fromHex("#96CEB4"))
end

-- 清除特定位置的所有标签（除了受保护的位置）
function OrangeUI:clearTags(position)
    if position and self.Tags[position] then
        -- 不清除固定的标签位置
        local protectedPositions = {"far_right", "center_right", "center"} -- 脚本名称、时间、版本标签的位置
        
        if not table.find(protectedPositions, position) then
            for _, tag in ipairs(self.Tags[position]) do
                pcall(function() tag:Destroy() end)
            end
            self.Tags[position] = {}
        end
    else
        -- 清除所有非固定位置的标签
        for pos, tags in pairs(self.Tags) do
            local protectedPositions = {"far_right", "center_right", "center"}
            if not table.find(protectedPositions, pos) then
                for _, tag in ipairs(tags) do
                    pcall(function() tag:Destroy() end)
                end
                self.Tags[pos] = {}
            end
        end
    end
end

-- 移动标签到不同位置
function OrangeUI:moveTag(tag, newPosition)
    if tag and self.Tags[newPosition] then
        -- 从原位置移除
        for pos, tags in pairs(self.Tags) do
            for i, existingTag in ipairs(tags) do
                if existingTag == tag then
                    table.remove(tags, i)
                    break
                end
            end
        end
        
        -- 添加到新位置
        table.insert(self.Tags[newPosition], tag)
    end
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

-- 初始化所有固定标签
function OrangeUI:initFixedTags()
    self:createTimeTag()
    self:createVersionTag("v2.0")
    self:createScriptNameTag()
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
