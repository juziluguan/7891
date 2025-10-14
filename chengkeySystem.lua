
-- 卡密验证系统 - 超级简化版
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

-- 直接验证卡密（跳过复杂的解析）
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

-- 简单直接的验证方法
if keyData:find("VALID_KEYS=") then
    local validKeysString = keyData:match("VALID_KEYS=([^\r\n]*)") or ""
    print("有效卡密字符串:", validKeysString)
    
    -- 直接检查是否包含用户卡密
    if validKeysString:find(userKey) then
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
