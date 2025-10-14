-- 卡密验证系统 - 最终修复版
print("=== 巨子卡密系统启动 ===")

-- 检查各种可能的环境变量
local userKey = _G.ADittoKey or getgenv().ADittoKey or shared.ADittoKey
print("检测到的卡密:", userKey)

if not userKey then
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "错误",
        Text = "请设置卡密: _G.ADittoKey = '你的卡密'",
        Duration = 10
    })
    print("未检测到卡密设置")
    return
end

local function validateKey(key)
    print("开始验证卡密:", key)
    
    if not key or key == "" then
        return false, "卡密不能为空"
    end
    
    local keyDatabaseURL = "https://raw.githubusercontent.com/juziluguan/7891/refs/heads/main/chengkeys.txt"
    print("正在获取卡密数据库...")
    
    local success, keyData = pcall(function()
        return game:HttpGet(keyDatabaseURL)
    end)
    
    if not success then
        print("网络请求失败")
        return false, "网络连接失败，请检查网络"
    end
    
    print("卡密数据获取成功")
    print("原始卡密数据:", keyData)
    
    -- 解析卡密数据 - 修复版
    local validKeys = {}
    for line in keyData:gmatch("[^\r\n]+") do
        if line:find("VALID_KEYS=") then
            local keysStr = line:gsub("VALID_KEYS=", "")
            for validKey in keysStr:gmatch("([^,]+)") do
                if validKey and type(validKey) == "string" then
                    local cleanKey = validKey:match("^%s*(.-)%s*$") or ""
                    if cleanKey ~= "" then
                        table.insert(validKeys, cleanKey)
                        print("添加卡密到列表:", cleanKey)
                    end
                end
            end
        end
    end
    
    print("找到有效卡密:", table.concat(validKeys, ", "))
    print("总共找到", #validKeys, "个有效卡密")
    
    -- 检查卡密是否有效
    for _, validKey in ipairs(validKeys) do
        if key == validKey then
            print("卡密验证成功!")
            return true, "卡密验证成功！"
        end
    end
    
    print("卡密验证失败，输入的卡密不在有效列表中")
    return false, "卡密无效或已过期"
end

-- 主验证流程
print("用户卡密:", userKey)
local isValid, message = validateKey(userKey)

if isValid then
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "成功",
        Text = "卡密验证成功！正在加载主脚本...",
        Duration = 5
    })
    
    print("开始加载主脚本...")
    
    -- 加载主脚本
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
            Text = "主脚本加载失败: " .. tostring(loadError),
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

print("=== 巨子卡密系统结束 ===")
