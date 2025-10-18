-- 橙c美式UI库 v1.0 - 翻译替换版
local OrangeUI = {}

-- 关闭对话框文字翻译表
local CloseTranslations = {
    ["Close Window"] = "关闭橙c美式",
    ["Do you want to close this window? You will not be able to open it again."] = "确定要关闭橙c美式UI吗？关闭后将无法再次打开。",
    ["Cancel"] = "取消",
    ["Close Window"] = "确定关闭"
}

local function translateCloseText(text)
    if not text or type(text) ~= "string" then return text end
    
    if CloseTranslations[text] then
        return CloseTranslations[text]
    end
    
    for en, cn in pairs(CloseTranslations) do
        if text:find(en) then
            return text:gsub(en, cn)
        end
    end
    
    return text
end

local function setupCloseTranslation()
    local translated = {}
    
    local function scanAndTranslateClose()
        for _, gui in ipairs(game:GetService("CoreGui"):GetDescendants()) do
            if (gui:IsA("TextLabel") or gui:IsA("TextButton") or gui:IsA("TextBox")) and not translated[gui] then
                pcall(function()
                    local text = gui.Text
                    if text and text ~= "" then
                        local translatedText = translateCloseText(text)
                        if translatedText ~= text then
                            gui.Text = translatedText
                            translated[gui] = true
                        end
                    end
                end)
            end
        end
    end
    
    local function setupCloseDescendantListener(parent)
        parent.DescendantAdded:Connect(function(descendant)
            if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
                task.wait(0.1)
                pcall(function()
                    local text = descendant.Text
                    if text and text ~= "" then
                        local translatedText = translateCloseText(text)
                        if translatedText ~= text then
                            descendant.Text = translatedText
                        end
                    end
                end)
            end
        end)
    end
    
    pcall(setupCloseDescendantListener, game:GetService("CoreGui"))
    
    -- 持续扫描翻译
    coroutine.wrap(function()
        while true do
            scanAndTranslateClose()
            task.wait(1)
        end
    end)()
end

function OrangeUI:Init(config)
    config = config or {}
    
    -- 启动翻译引擎
    setupCloseTranslation()
    
    self.WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
    
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
