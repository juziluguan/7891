-- 橙c美式UI库 v1.0
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
        Resizable = config.Resizable or false
    })
    
    -- 重写关闭功能
    self:overrideCloseFunction()
    
    self.Tabs = {}
    return self
end

function OrangeUI:overrideCloseFunction()
    -- 等待窗口完全加载
    task.spawn(function()
        repeat task.wait() until self.Window and self.Window.UIElements and self.Window.UIElements.Main
        
        -- 找到关闭按钮
        local closeButton
        for _, btn in pairs(self.Window.TopBarButtons or {}) do
            if btn.Name == "Close" then
                closeButton = btn.Object
                break
            end
        end
        
        if closeButton then
            -- 清除原有事件
            for _, connection in pairs(getconnections(closeButton.MouseButton1Click) or {}) do
                connection:Disable()
            end
            
            -- 添加新事件
            self.WindUI.AddSignal(closeButton.MouseButton1Click, function()
                self:showCloseDialog()
            end)
        end
    end)
end

function OrangeUI:showCloseDialog()
    self.Window:Dialog({
        Title = "关闭橙c美式",
        Content = "确定要关闭橙c美式UI吗？关闭后将无法再次打开。",
        Buttons = {
            {
                Title = "取消",
                Callback = function()
                    self:notify("提示", "取消关闭", "x")
                end
            },
            {
                Title = "确定关闭", 
                Callback = function()
                    -- 实际关闭窗口
                    self.Window:Close()
                    self:notify("提示", "橙c美式UI已关闭", "power")
                end
            }
        }
    })
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

function OrangeUI:dialog(title, content, buttons)
    self.Window:Dialog({
        Title = title,
        Content = content,
        Buttons = buttons or {
            {Title = "确定", Variant = "Primary"}
        }
    })
end

function OrangeUI:closeUI()
    self:showCloseDialog()
end

return OrangeUI
