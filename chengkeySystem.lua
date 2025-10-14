-- 卡密验证系统 - 调试版
print("=== 巨子卡密系统启动 ===")

local function validateKey(key)
    if not key or key == "" then
        return false, "卡密不能为空"
    end
    
    local keyDatabaseURL = "https://raw.githubusercontent.com/juziluguan/7891/refs/heads/main/chengkeys.txt"
    print("正在获取卡密数据库...")
    
    local success, keyData = pcall(function()
        return game:HttpGet(keyDatabaseURL)
    end)
    
    if not success then
        return false, "网络连接失败，请检查网络"
    end
    
    print("卡密数据获取成功")
    
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
    
    print("找到有效卡密:", table.concat(validKeys, ", "))
    
    -- 检查卡密是否有效
    for _, validKey in ipairs(validKeys) do
        if key == validKey then
            print("卡密验证成功!")
            return true, "卡密验证成功！"
        end
    end
    
    return false, "卡密无效或已过期"
end

-- 主验证流程
if _G.ADittoKey then
    print("用户卡密:", _G.ADittoKey)
    local isValid, message = validateKey(_G.ADittoKey)
    
    if isValid then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "成功",
            Text = "卡密验证成功！正在加载主脚本...",
            Duration = 5
        })
        
        print("开始加载主脚本...")
        
        -- 加载主脚本（添加详细错误处理）
        local mainScriptURL = "https://raw.githubusercontent.com/juziluguan/juziniubi/refs/heads/main/chengcmeishitongyong666666666666.lua"
        print("主脚本URL:", mainScriptURL)
        
        local loadSuccess, loadError = pcall(function()
            local scriptContent = game:HttpGet(mainScriptURL)
            print("主脚本内容获取成功，长度:", #scriptContent)
            loadstring(scriptContent)()
        end)
        
        if loadSuccess then
            print("主脚本加载执行成功！")
            game:GetService("StarterGui"):SetCore("SendNotification",{
                Title = "加载完成",
                Text = "巨子脚本已成功加载！",
                Duration = 5
            })
        else
            print("主脚本加载失败:", loadError)
            game:GetService("StarterGui"):SetCore("SendNotification",{
                Title = "加载错误",
                Text = "主脚本加载失败，请检查网络",
                Duration = 10
            })
        end
        
    else
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
