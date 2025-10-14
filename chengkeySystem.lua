-- 测试版本 - 橙c美式验证系统
print("=== 测试模式启动 ===")

local userKey = getgenv().ADittoKey
print("1. 用户卡密:", userKey)

if not userKey then
    print("❌ 错误: 未设置卡密")
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "错误", Text = "请设置卡密", Duration = 8
    })
    return
end

print("2. 开始获取云端数据...")
local success, keyData = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/juziluguan/7891/refs/heads/main/chengkeys.txt")
end)

print("3. 网络请求:", success)
print("4. 云端数据:", keyData)

if not success then
    print("❌ 网络错误")
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "错误", Text = "网络连接失败", Duration = 8
    })
    return
end

if keyData and string.find(keyData, "VALID_KEYS=") then
    local validKeys = string.match(keyData, "VALID_KEYS=([^\r\n]*)")
    print("5. 解析出的卡密字符串:", validKeys)
    
    if validKeys then
        for key in string.gmatch(validKeys, "([^,]+)") do
            local cleanKey = string.gsub(key, "^%s*(.-)%s*$", "%1")
            print("6. 对比: '" .. userKey .. "' == '" .. cleanKey .. "' ?")
            if userKey == cleanKey then
                print("✅ 匹配成功!")
                game:GetService("StarterGui"):SetCore("SendNotification",{
                    Title = "成功", Text = "验证通过!", Duration = 5
                })
                print("7. 正在加载主脚本...")
                loadstring(game:HttpGet("https://raw.githubusercontent.com/juziluguan/juziniubi/refs/heads/main/chengcmeishitongyong666666666666.lua"))()
                return
            end
        end
    end
end

print("❌ 所有对比失败")
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "失败", Text = "卡密无效", Duration = 8
})
