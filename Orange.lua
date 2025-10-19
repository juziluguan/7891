-- 橙c美式UI库 - 仿WindUI结构版
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
        Size = UDim2.fromOffset(400, 300),
        Transparent = false,
        Theme = "Dark",
        BackgroundColor = Color3.fromRGB(25, 25, 35),
        User = {
            Enabled = true,
            Callback = function() print("点击了用户信息") end,
            Anonymous = false
        },
        SideBarWidth = 200,
        ScrollBarEnabled = true,
    })
    
    -- 时间标签
    self.TimeTag = self.Window:Tag({
        Title = "00:00:00",
        Color = Color3.fromHex("#FFA500")
    })
    
    -- 版本标签
    self.VersionTag = self.Window:Tag({
        Title = "v1.0",
        Color = Color3.fromHex("#FFA500")
    })
    
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

    -- 橙黑渐变打开按钮
    self.Window:EditOpenButton({
        Title = "橙C美式脚本中心",
        Icon = "crown",
        CornerRadius = UDim.new(0,16),
        StrokeThickness = 2,
        Color = ColorSequence.new(
            Color3.fromHex("FF6B00"),
            Color3.fromHex("FFA500")
        ),
        Draggable = true,
    })
    
    -- 标签容器
    self.Tags = {
        left = {},
        right = {}
    }
    
    self.Tabs = {}
    return self
end

-- 创建标签
function OrangeUI:tag(position, title, color)
    position = position or "right"
    
    local tagObj = self.Window:Tag({
        Title = title,
        Color = color or Color3.fromHex("#FFA500")
    })
    
    table.insert(self.Tags[position], tagObj)
    return tagObj
end

-- 创建时间标签
function OrangeUI:createTimeTag()
    return self.TimeTag
end

-- 创建版本标签
function OrangeUI:createVersionTag(version)
    if version and self.VersionTag then
        self.VersionTag:SetTitle(version)
    end
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

-- 控件函数
function OrangeUI:btn(tab, title, desc, callback)
    tab:Button({
        Title = title,
        Desc = desc,
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

function OrangeUI:paragraph(tab, title, desc)
    tab:Paragraph({
        Title = title,
        Desc = desc
    })
end

-- 通知
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
