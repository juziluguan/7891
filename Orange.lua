-- 橙c美式UI库 v1.0 - 完整功能版
local OrangeUI = {}

function OrangeUI:Init(config)
    config = config or {}
    
    self.WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
    
    self.Window = self.WindUI:CreateWindow({
        Title = config.Title or "橙c美式",
        Size = config.Size or UDim2.fromOffset(400, 300),
        Folder = config.Folder or "橙c美式UI",
        Theme = config.Theme or "Dark",
        ToggleKey = config.ToggleKey or Enum.KeyCode.RightShift,
        Resizable = config.Resizable or false,
        Background = config.Background,
        BackgroundImageTransparency = config.BackgroundImageTransparency,
        Transparent = config.Transparent,
        Acrylic = config.Acrylic,
        HideSearchBar = config.HideSearchBar,
        ScrollBarEnabled = config.ScrollBarEnabled,
        SideBarWidth = config.SideBarWidth,
        User = config.User or {}
    })
    
    -- 保存原始关闭函数供后续使用
    self.originalCloseFunction = self.Window.Close
    
    self.Tabs = {}
    return self
end

-- 创建标签页 (cz = 功能栏)
function OrangeUI:cz(title, icon, desc, locked)
    local tab = self.Window:Tab({
        Title = title or "功能",
        Icon = icon or "zap",
        Desc = desc,
        Locked = locked or false
    })
    self.Tabs[title or "功能"] = tab
    return tab
end

-- 创建设置标签页
function OrangeUI:settings(title, icon, desc, locked)
    local tab = self.Window:Tab({
        Title = title or "设置", 
        Icon = icon or "settings",
        Desc = desc,
        Locked = locked or false
    })
    self.Tabs[title or "设置"] = tab
    return tab
end

-- 创建分区
function OrangeUI:section(tab, title, icon, textAlignment, textSize)
    return tab:Section({
        Title = title,
        Icon = icon,
        TextXAlignment = textAlignment or "Left",
        TextSize = textSize or 19
    })
end

-- 添加按钮
function OrangeUI:btn(tab, title, desc, callback, locked)
    tab:Button({
        Title = title,
        Desc = desc,
        Callback = callback,
        Locked = locked or false
    })
end

-- 添加开关
function OrangeUI:toggle(tab, title, desc, value, callback, icon, toggleType, locked)
    tab:Toggle({
        Title = title,
        Desc = desc,
        Value = value or false,
        Callback = callback,
        Icon = icon,
        Type = toggleType or "Toggle",
        Locked = locked or false
    })
end

-- 添加滑块
function OrangeUI:slider(tab, title, desc, value, min, max, callback, step, locked)
    tab:Slider({
        Title = title,
        Desc = desc,
        Value = {Default = value or 50, Min = min or 0, Max = max or 100},
        Callback = callback,
        Step = step or 1,
        Locked = locked or false
    })
end

-- 添加输入框
function OrangeUI:input(tab, title, desc, placeholder, callback, inputType, inputIcon, clearTextOnFocus, locked)
    tab:Input({
        Title = title,
        Desc = desc,
        Placeholder = placeholder or "请输入...",
        Callback = callback,
        Type = inputType or "Input",
        InputIcon = inputIcon,
        ClearTextOnFocus = clearTextOnFocus or false,
        Locked = locked or false
    })
end

-- 添加下拉框
function OrangeUI:dropdown(tab, title, desc, options, default, callback, multi, allowNone, menuWidth, locked)
    tab:Dropdown({
        Title = title,
        Desc = desc,
        Values = options or {},
        Value = default,
        Callback = callback,
        Multi = multi or false,
        AllowNone = allowNone or false,
        MenuWidth = menuWidth or 170,
        Locked = locked or false
    })
end

-- 添加颜色选择器
function OrangeUI:color(tab, title, desc, default, callback, transparency, locked)
    tab:Colorpicker({
        Title = title,
        Desc = desc,
        Default = default or Color3.fromRGB(255, 165, 0),
        Callback = callback,
        Transparency = transparency,
        Locked = locked or false
    })
end

-- 添加快捷键
function OrangeUI:keybind(tab, title, desc, default, callback, canChange, locked)
    tab:Keybind({
        Title = title,
        Desc = desc,
        Value = default or "RightShift",
        Callback = callback,
        CanChange = canChange or true,
        Locked = locked or false
    })
end

-- 添加代码框
function OrangeUI:code(tab, title, code, onCopy, locked)
    tab:Code({
        Title = title,
        Code = code,
        OnCopy = onCopy,
        Locked = locked or false
    })
end

-- 添加段落
function OrangeUI:paragraph(tab, title, desc, buttons, locked)
    tab:Paragraph({
        Title = title,
        Desc = desc,
        Buttons = buttons,
        Locked = locked or false
    })
end

-- 添加分割线
function OrangeUI:divider(tab)
    tab:Divider()
end

-- 显示通知
function OrangeUI:notify(title, content, icon, duration, background, backgroundImageTransparency, buttons, canClose)
    self.WindUI:Notify({
        Title = title,
        Content = content,
        Icon = icon or "info",
        Duration = duration or 5,
        Background = background,
        BackgroundImageTransparency = backgroundImageTransparency,
        Buttons = buttons,
        CanClose = canClose
    })
end

-- 切换主题
function OrangeUI:setTheme(theme)
    self.WindUI:SetTheme(theme)
    self:notify("主题切换", "已切换到 " .. theme .. " 主题", "palette")
end

-- 显示对话框
function OrangeUI:dialog(title, content, buttons, icon, thumbnail)
    self.Window:Dialog({
        Title = title,
        Content = content,
        Buttons = buttons or {
            {Title = "确定", Variant = "Primary"}
        },
        Icon = icon,
        Thumbnail = thumbnail
    })
end

-- 关闭UI（带确认）
function OrangeUI:closeUI()
    self:dialog("关闭橙c美式", "确定要关闭橙c美式UI吗？关闭后将无法再次打开。", {
        {
            Title = "取消",
            Callback = function()
                self:notify("提示", "取消关闭", "x")
            end
        },
        {
            Title = "确定关闭", 
            Callback = function()
                if self.originalCloseFunction then
                    self.originalCloseFunction(self.Window)
                end
                self:notify("提示", "橙c美式UI已关闭", "power")
            end
        }
    })
end

-- 设置字体
function OrangeUI:setFont(font)
    self.WindUI:SetFont(font)
end

-- 设置语言
function OrangeUI:setLanguage(language)
    self.WindUI:SetLanguage(language)
end

-- 获取当前主题
function OrangeUI:getCurrentTheme()
    return self.WindUI:GetCurrentTheme()
end

-- 获取透明度状态
function OrangeUI:getTransparency()
    return self.WindUI:GetTransparency()
end

-- 获取窗口尺寸
function OrangeUI:getWindowSize()
    return self.WindUI:GetWindowSize()
end

-- 创建标签
function OrangeUI:tag(title, color, radius)
    return self.Window:Tag({
        Title = title,
        Color = color,
        Radius = radius or 999
    })
end

-- 窗口操作
function OrangeUI:openWindow()
    self.Window:Open()
end

function OrangeUI:closeWindow()
    self:closeUI()
end

function OrangeUI:destroyWindow()
    self.Window:Destroy()
end

function OrangeUI:setWindowTitle(title)
    self.Window:SetTitle(title)
end

function OrangeUI:setWindowSize(size)
    self.Window:SetSize(size)
end

function OrangeUI:setToggleKey(key)
    self.Window:SetToggleKey(key)
end

function OrangeUI:setBackgroundImage(image)
    self.Window:SetBackgroundImage(image)
end

function OrangeUI:setBackgroundImageTransparency(transparency)
    self.Window:SetBackgroundImageTransparency(transparency)
end

function OrangeUI:setAuthor(author)
    self.Window:SetAuthor(author)
end

function OrangeUI:toggleFullscreen()
    self.Window:ToggleFullscreen()
end

function OrangeUI:setUIScale(scale)
    self.Window:SetUIScale(scale)
end

function OrangeUI:isResizable(resizable)
    self.Window:IsResizable(resizable)
end

function OrangeUI:disableTopbarButtons(buttons)
    self.Window:DisableTopbarButtons(buttons)
end

return OrangeUI
