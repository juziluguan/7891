-- Orange C American Style Verification System
local userKey = _G.ADittoKey or getgenv().ADittoKey

print("用户输入的卡密:", userKey)

if not userKey or type(userKey) ~= "string" then
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Error", 
        Text = "Please set: getgenv().ADittoKey = 'your key'", 
        Duration = 8
    })
    return
end

userKey = string.gsub(tostring(userKey), "^%s*(.-)%s*$", "%1")
print("清理后的卡密:", userKey)

local success, keyData = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/juziluguan/7891/refs/heads/main/chengkeys.txt")
end)

print("网络请求结果:", success)
print("获取到的数据:", keyData)

if not success then
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Error", 
        Text = "Network connection failed", 
        Duration = 8
    })
    return
end

if keyData and string.find(keyData, "VALID_KEYS=") then
    local validKeys = string.match(keyData, "VALID_KEYS=([^\r\n]*)")
    print("解析出的有效卡密字符串:", validKeys)
    
    if validKeys then
        for key in string.gmatch(validKeys, "([^,]+)") do
            local cleanKey = string.gsub(key, "^%s*(.-)%s*$", "%1")
            print("对比: '" .. userKey .. "' vs '" .. cleanKey .. "'")
            if userKey == cleanKey then
                print("匹配成功!")
                game:GetService("StarterGui"):SetCore("SendNotification",{
                    Title = "Success", 
                    Text = "Verification passed!", 
                    Duration = 5
                })
                loadstring(game:HttpGet("https://raw.githubusercontent.com/juziluguan/juziniubi/refs/heads/main/chengcmeishitongyong666666666666.lua"))()
                return
            end
        end
    end
end

print("所有对比都失败了")
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Failed", 
    Text = "Invalid key", 
    Duration = 8
})
