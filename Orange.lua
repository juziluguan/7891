-- 橙c美式UI库 - 完整功能版
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
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    self.Window = self.WindUI:CreateWindow({
        Title = config.Title or "橙C美式 1.0",
        IconTransparency = 0.5,
        IconThemed = true,
        Author = "作者: 橙子",
        Folder = "橙C美式",
        Size = config.Size or UDim2.fromOffset(400, 300),
        Transparent = config.Transparent or false,
        Theme = config.Theme or "Dark",
        BackgroundColor = config.BackgroundColor or Color3.fromRGB(25, 25, 35),
        User = {
            Enabled = true,
            Callback = function() print("点击了用户信息") end,
            Anonymous = false
        },
        SideBarWidth = 200,
        ScrollBarEnabled = true,
    })
    
    -- 橙黑渐变打开按钮
    self.Window:EditOpenButton({
        Title = "橙C美式",
        Icon = "crown",
        CornerRadius = UDim.new(0,16),
        StrokeThickness = 2,
        Color = ColorSequence.new(
            Color3.fromHex("FF6B00"),  -- 橙色
            Color3.fromHex("000000")   -- 黑色
        ),
        Draggable = true,
    })
    
    -- 标签容器
    self.Tags = {
        left = {},
        right = {}
    }
    
    self.Tabs = {}
    
    -- 创建时间标签
    self:createTimeTag()
    -- 创建版本标签
    self:createVersionTag(config.Version or "v1.0")
    
    return self
end

-- 创建标签
function OrangeUI:tag(position, title, color, radius, transparent)
    position = position or "right"
    
    local tagObj = self.Window:Tag({
        Title = title,
        Color = color or Color3.fromHex("#FFA500"),
        Radius = radius or 999,
        Transparent = transparent or false
    })
    
    table.insert(self.Tags[position], tagObj)
    return tagObj
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

-- 清除标签
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

-- 创建标签页
function OrangeUI:cz(title, icon, locked)
    local tab = self.Window:Tab({
        Title = title or "主页",
        Icon = icon or "user",
        Locked = locked or false
    })
    self.Tabs[title] = tab
    return tab
end

function OrangeUI:settings(title)
    local tab = self.Window:Tab({
        Title = title or "设置",
        Icon = "settings",
        Locked = false
    })
    self.Tabs[title] = tab
    return tab
end

-- 完整控件函数
function OrangeUI:btn(tab, title, desc, callback, variant, icon)
    return tab:Button({
        Title = title,
        Desc = desc,
        Callback = callback,
        Variant = variant or "Primary",
        Icon = icon
    })
end

function OrangeUI:toggle(tab, title, desc, value, callback, icon)
    return tab:Toggle({
        Title = title,
        Desc = desc,
        Value = value or false,
        Callback = callback,
        Icon = icon
    })
end

function UI:slider(tab, title, desc, value, min, max, callback, suffix)
    return tab:Slider({
        Title = title,
        Desc = desc,
        Value = {Default = value or 50, Min = min or 0, Max = max or 100},
        Callback = callback,
        Suffix = suffix or ""
    })
end

function OrangeUI:input(tab, title, desc, placeholder, callback, icon)
    return tab:Input({
        Title = title,
        Desc = desc,
        Placeholder = placeholder or "请输入...",
        Callback = callback,
        Icon = icon
    })
end

function OrangeUI:dropdown(tab, title, desc, options, default, callback, icon)
    return tab:Dropdown({
        Title = title,
        Desc = desc,
        Values = options or {},
        Value = default,
        Callback = callback,
        Icon = icon
    })
end

function OrangeUI:color(tab, title, desc, default, callback, icon)
    return tab:Colorpicker({
        Title = title,
        Desc = desc,
        Default = default or Color3.fromRGB(255, 165, 0),
        Callback = callback,
        Icon = icon
    })
end

function OrangeUI:keybind(tab, title, desc, default, callback, icon)
    return tab:Keybind({
        Title = title,
        Desc = desc,
        Value = default or "RightShift",
        Callback = callback,
        Icon = icon
    })
end

function OrangeUI:paragraph(tab, title, desc)
    return tab:Paragraph({
        Title = title,
        Desc = desc
    })
end

function OrangeUI:section(tab, title, opened)
    return tab:Section({
        Title = title,
        Opened = opened or true
    })
end

-- 通知
function OrangeUI:notify(title, content, icon, duration)
    self.WindUI:Notify({
        Title = title,
        Content = content,
        Icon = icon or "info",
        Duration = duration or 5
    })
end

function OrangeUI:setTheme(theme)
    self.WindUI:SetTheme(theme)
    self:notify("主题切换", "已切换到 " .. theme .. " 主题", "palette", 3)
end

return OrangeUI
