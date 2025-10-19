-- 橙c美式UI库 - 内置橙色描边版
local OrangeUI = {}

function OrangeUI:Init(config)
    config = config or {}
    
    self.WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
    
    -- 存储配置
    self.Config = config
    
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
    
    -- 在窗口创建后立即添加橙色描边
    self:addOrangeStroke()
    
    -- 创建时间标签
    self.TimeTag = self.Window:Tag({
        Title = "00:00:00",
        Color = Color3.fromHex("#FFA500")
    })
    
    -- 创建版本标签
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
    return self
end

-- 添加橙色描边到UI
function OrangeUI:addOrangeStroke()
    task.spawn(function()
        -- 等待窗口完全加载
        task.wait(0.5)
        
        if self.Window and self.Window.Instance then
            local mainFrame = self.Window.Instance
            
            -- 给主窗口添加橙色描边
            local mainStroke = Instance.new("UIStroke")
            mainStroke.Color = Color3.fromRGB(255, 107, 0)  -- 橙色
            mainStroke.Thickness = 3
            mainStroke.Transparency = 0
            mainStroke.LineJoinMode = Enum.LineJoinMode.Round
            mainStroke.Parent = mainFrame
            
            print("✅ 主窗口橙色描边已添加")
            
            -- 给所有标签添加描边
            task.wait(1)
            self:addStrokeToAllTags()
            
            -- 给侧边栏添加描边
            self:addStrokeToSidebar()
        end
    end)
end

-- 给所有标签添加描边
function OrangeUI:addStrokeToAllTags()
    if not self.Window then return end
    
    task.spawn(function()
        task.wait(1)
        
        local function addTagStrokes(obj)
            for _, child in ipairs(obj:GetDescendants()) do
                if child:IsA("Frame") then
                    -- 判断是否是标签（有圆角和文本）
                    if child:FindFirstChildWhichIsA("UICorner") and child:FindFirstChildWhichIsA("TextLabel") then
                        if not child:FindFirstChild("OrangeStroke") then
                            local stroke = Instance.new("UIStroke")
                            stroke.Name = "OrangeStroke"
                            stroke.Color = Color3.fromRGB(255, 107, 0)
                            stroke.Thickness = 1.5
                            stroke.Transparency = 0
                            stroke.LineJoinMode = Enum.LineJoinMode.Round
                            stroke.Parent = child
                        end
                    end
                end
            end
        end
        
        if self.Window.Instance then
            addTagStrokes(self.Window.Instance)
        end
    end)
end

-- 给侧边栏添加描边
function OrangeUI:addStrokeToSidebar()
    if not self.Window then return end
    
    task.spawn(function()
        task.wait(1)
        
        local function findSidebar(obj)
            for _, child in ipairs(obj:GetDescendants()) do
                if child:IsA("Frame") and (child.Name == "SideBar" or child.Name == "TabHolder" or child.Size.X.Scale == 0) then
                    return child
                end
            end
            return nil
        end
        
        if self.Window.Instance then
            local sidebar = findSidebar(self.Window.Instance)
            if sidebar and not sidebar:FindFirstChild("OrangeStroke") then
                local stroke = Instance.new("UIStroke")
                stroke.Name = "OrangeStroke"
                stroke.Color = Color3.fromRGB(255, 107, 0)
                stroke.Thickness = 2
                stroke.Transparency = 0
                stroke.LineJoinMode = Enum.LineJoinMode.Round
                stroke.Parent = sidebar
                print("✅ 侧边栏橙色描边已添加")
            end
        end
    end)
end

-- 创建标签（自动添加描边）
function OrangeUI:tag(position, title, color)
    position = position or "right"
    
    local tagObj = self.Window:Tag({
        Title = title,
        Color = color or Color3.fromHex("#FFA500")
    })
    
    table.insert(self.Tags[position], tagObj)
    
    -- 为新标签添加描边
    task.spawn(function()
        task.wait(0.5)
        if tagObj and tagObj.Instance then
            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(255, 107, 0)
            stroke.Thickness = 1.5
            stroke.Transparency = 0
            stroke.LineJoinMode = Enum.LineJoinMode.Round
            stroke.Parent = tagObj.Instance
        end
    end)
    
    return tagObj
end

-- 其他函数保持不变...
function OrangeUI:createTimeTag()
    return self.TimeTag
end

function OrangeUI:createVersionTag(version)
    if version and self.VersionTag then
        self.VersionTag:SetTitle(version)
    end
    return self.VersionTag
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

function OrangeUI:dropdown(tab, title, desc, options, default, callback)
    tab:Dropdown({
        Title = title,
        Desc = desc,
        Values = options or {},
        Value = default,
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
