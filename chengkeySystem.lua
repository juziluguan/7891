-- 卡密验证系统 - 最终版
print("=== 巨子卡密系统启动 ===")

-- 检查卡密
local userKey = _G.ADittoKey or getgenv().ADittoKey or shared.ADittoKey
if not userKey then
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "错误",
        Text = "请设置: _G.ADittoKey = '你的卡密'",
        Duration = 10
    })
    return
end

print("用户卡密:", userKey)

-- 获取卡密数据
local keyDatabaseURL = "https://raw.githubusercontent.com/juziluguan/7891/refs/heads/main/chengkeys.txt"
local success, keyData = pcall(function()
    return game:HttpGet(keyDatabaseURL)
end)

if not success then
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "错误",
        Text = "网络连接失败",
        Duration = 10
    })
    return
end

print("获取到的卡密数据:", keyData)

-- 验证卡密
if keyData:find("VALID_KEYS=") then
    local validKeysString = keyData:match("VALID_KEYS=([^\r\n]*)") or ""
    print("有效卡密字符串:", validKeysString)
    
    -- 精确匹配卡密
    local isValid = false
    for key in validKeysString:gmatch("([^,]+)") do
        local cleanKey = key:match("^%s*(.-)%s*$") or ""
        if cleanKey == userKey then
            isValid = true
            break
        end
    end
    
    if isValid then
        print("卡密验证成功!")
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "成功",
            Text = "卡密验证成功！",
            Duration = 5
        })
        
        -- 加载主脚本
        loadstring(game:HttpGet("https://raw.githubusercontent.com/juziluguan/juziniubi/refs/heads/main/chengcmeishitongyong666666666666.lua"))()
    else
        print("卡密验证失败")
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "失败",
            Text = "卡密无效",
            Duration = 10
        })
    end
else
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "错误", 
        Text = "卡密数据库格式错误",
        Duration = 10
    })
end
