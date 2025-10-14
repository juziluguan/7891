-- 卡密验证系统
local function validateKey(key)
    if not key or key == "" then
        return false, "卡密不能为空"
    end
    
    -- 使用你的仓库地址
    https://raw.githubusercontent.com/juziluguan/7891/refs/heads/main/chengkeys.txt
    
    -- 从云端获取有效卡密列表
    local success, keyData = pcall(function()
        return game:HttpGet(keyDatabaseURL)
    end)
    
    if not success then
        return false, "网络连接失败，请检查网络"
    end
    
    -- 解析卡密数据
    local validKeys = {}
    for line in keyData:gmatch("[^\r\n]+") do
        if line:find("VALID_KEYS=") then
            local keysStr = line:gsub("VALID_KEYS=", "")
            for validKey in keysStr:gmatch("[^,]+") do
                table.insert(validKeys, validKey:gsub("^%s*(.-)%s*$", "%1"))
            end
        end
    end
    
    -- 检查卡密是否有效
    for _, validKey in ipairs(validKeys) do
        if key == validKey then
            return true, "卡密验证成功！"
        end
    end
    
    return false, "卡密无效或已过期"
end

-- 主验证流程
if _G.ADittoKey then
    local isValid, message = validateKey(_G.ADittoKey)
    
    if isValid then
        -- 验证成功，加载主脚本
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "成功",
            Text = "卡密验证成功！",
            Duration = 5
        })
        
        -- 加载你的主脚本
        loadstring(game:HttpGet("https://raw.githubusercontent.com/juziluguan/juziniubi/refs/heads/main/chengcmeishitongyong666666666666.lua"))()
    else
        -- 验证失败
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "卡密验证失败",
            Text = message,
            Duration = 10
        })
    end
else
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "错误",
        Text = "请先设置 _G.ADittoKey",
        Duration = 10
    })
end
