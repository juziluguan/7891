-- 橙C美式UI - 简化版
local OrangeUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/juziluguan/7891/main/Orange.lua"))()

local ui = OrangeUI:Init({
    Title = "橙C美式 1.0"
})

-- 等待窗口创建完成
task.wait(2)

-- 为标签页添加橙黑渐变效果
task.spawn(function()
    task.wait(1)
    
    if ui.Window and ui.Window.Instance then
        -- 查找所有标签页文本
        local function findTabLabels(obj)
            local tabLabels = {}
            for _, child in ipairs(obj:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("TextButton") then
                    -- 只查找"主页"和"设置"标签
                    local tabNames = {"主页", "设置"}
                    for _, name in ipairs(tabNames) do
                        if child.Text and string.find(child.Text, name) then
                            table.insert(tabLabels, child)
                            break
                        end
                    end
                end
            end
            return tabLabels
        end
        
        local tabLabels = findTabLabels(ui.Window.Instance)
        
        for _, label in ipairs(tabLabels) do
            -- 为每个标签页文本添加橙黑渐变
            local gradient = Instance.new("UIGradient")
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromHex("FF6B00")),  -- 橙色
                ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF8C00")), -- 亮橙色
                ColorSequenceKeypoint.new(1, Color3.fromHex("000000"))   -- 黑色
            })
            gradient.Rotation = 90
            gradient.Parent = label
            
            -- 添加文字描边
            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromHex("FF6B00")
            stroke.Thickness = 1
            stroke.Transparency = 0.3
            stroke.Parent = label
        end
    end
end)

-- 主页
local MainTab = ui:cz("主页", "user")

MainTab:Paragraph({
    Title = "欢迎使用橙C美式",
    Desc = "感谢您的使用！",
})

-- 输入框：自定义标签
ui:input(MainTab, "自定义标签", "输入要显示的标签文字", "例如: 管理员", function(text)
    if text and text ~= "" then
        ui:tag("right", text, Color3.fromHex("#FF6B35"))
        ui:notify("标签更新", "标签已显示: " .. text, "tag")
    end
end)

-- 添加初始标签
ui:tag("right", "已加载", Color3.fromHex("#4ECDC4"))
ui:tag("right", "稳定版", Color3.fromHex("#96CEB4"))

-- 设置页面
local SettingsTab = ui:settings("设置")

ui:dropdown(SettingsTab, "选择主题", "切换UI主题颜色", 
    {"Dark", "Light"}, 
    "Dark", 
    function(theme)
        ui:setTheme(theme)
    end
)

ui:notify("橙C美式", "脚本加载完成", "check-circle")
