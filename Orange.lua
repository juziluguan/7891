-- 橙c美式UI库 v1.0 - 字符串替换版
local OrangeUI = {}

-- 关闭对话框文字替换表
local closeTextReplacements = {
    ["Close Window"] = "关闭橙c美式",
    ["Do you want to close this window? You will not be able to open it again."] = "确定要关闭橙c美式UI吗？关闭后将无法再次打开。",
    ["Cancel"] = "取消",
    ["Close Window"] = "确定关闭"
}

function OrangeUI:Init(config)
    config = config or {}
    
    -- 在加载WindUI前设置替换函数
    local originalRequest = http_request or request or syn.request
    local function hookedRequest(options)
        if options and options.Url and string.find(options.Url, "WindUI") then
            local response = originalRequest(options)
            if response and response.Body then
                -- 替换关闭对话框文字
                local modifiedBody = response.Body
                for oldText, newText in pairs(closeTextReplacements) do
                    modifiedBody = string.gsub(modifiedBody, oldText, newText)
                end
                response.Body = modifiedBody
            end
            return response
        end
        return originalRequest(options)
    end
    
    -- 临时替换请求函数
    if syn then
        syn.request = hookedRequest
    else
        http_request = hookedRequest
    end
    
    self.WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
    
    -- 恢复原始请求函数
    if syn then
        syn.request = originalRequest
    else
        http_request = originalRequest
    end
    
    self.Window = self.WindUI:CreateWindow({
        Title = config.Title or "橙c美式",
        Size = config.Size or UDim2.fromOffset(400, 300),
        Folder = config.Folder or "橙c美式UI",
        Theme = config.Theme or "Dark",
        ToggleKey = config.ToggleKey or Enum.KeyCode.RightShift,
        Resizable = config.Resizable or false
    })
    
    self.Tabs = {}
    return self
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
