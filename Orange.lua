-- 橙C美式UI - 基于你的WindUI脚本重写
local OrangeUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/juziluguan/7891/main/Orange.lua"))()

local ui = OrangeUI:Init({
    Title = "橙C美式 2.0",
    Size = UDim2.fromOffset(580, 440),
    Theme = "Dark"
})

-- 其他代码保持不变...
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Plr = game:GetService("Players")
local LP = Plr.LocalPlayer

local Part = Instance.new("Part", workspace)
Part.Material = Enum.Material.ForceField
Part.Anchored = true
Part.CanCollide = false
Part.CastShadow = false
Part.Shape = Enum.PartType.Ball
Part.Color = Color3.fromRGB(132, 0, 255)
Part.Transparency = 0.5

local BaseGui = Instance.new("ScreenGui", game.CoreGui)
BaseGui.Name = "BaseGui"

local TL = Instance.new("TextLabel", BaseGui)
TL.Name = "TL"
TL.Parent = BaseGui
TL.BackgroundColor3 = Color3.new(1, 1, 1)
TL.BackgroundTransparency = 1
TL.BorderColor3 = Color3.new(0, 0, 0)
TL.Position = UDim2.new(0.95, -300, 0.85, 0)
TL.Size = UDim2.new(0, 300, 0, 50)
TL.FontFace = Font.new("rbxassetid://12187370000", Enum.FontWeight.Bold)
TL.Text = ""
TL.TextColor3 = Color3.new(1, 1, 1)
TL.TextScaled = true
TL.TextSize = 14
TL.TextWrapped = true
TL.Visible = true
TL.RichText = true

local function rainbowColor(hue)
  return Color3.fromHSV(hue, 1, 1)
end

local function updateRainbowText(distance, ballSpeed, spamRadius, minDistance)
  local hue = (tick() * 0.1) % 1
  local color1 = rainbowColor(hue)
  local color2 = rainbowColor((hue + 0.3) % 1)
  local color3 = rainbowColor((hue + 0.6) % 1)
  local color4 = rainbowColor((hue + 0.9) % 1)

  TL.Text = string.format(
  "<font color='#%s'>distance: %s</font>\n"..
  "<font color='#%s'>ballSpeed: %s</font>\n"..
  "<font color='#%s'>spamRadius: %s</font>\n"..
  "<font color='#%s'>minDistance: %s</font>",
  color1:ToHex(), tostring(distance),
  color2:ToHex(), tostring(ballSpeed),
  color3:ToHex(), tostring(spamRadius),
  color4:ToHex(), tostring(minDistance)
  )
end

-- 创建标签页 - 使用橙C美式UI的写法
local MainTab = ui:cz("稳定功能", "shield")
local FunTab = ui:cz("娱乐功能", "zap")

-- 稳定功能页的按钮
ui:btn(MainTab, "当前玩家基地: " .. LP.Team.Name, "显示当前基地", function()
    -- 空功能
end)

-- 传送基地下拉选择
local bases = {"Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", "Juliet", "Kilo", "Lima", "Omega", "Romeo", "Sierra", "Tango", "Victor", "Yankee", "Zulu"}
ui:dropdown(MainTab, "传送基地", "选择要传送的基地", bases, "Alpha", function(selected)
    local Positions = {
        ["Alpha"] = CFrame.new(-1197, 65, -4790),
        ["Bravo"] = CFrame.new(-220, 65, -4919),
        -- ... 其他位置
    }
    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        LP.Character:FindFirstChild("HumanoidRootPart").CFrame = Positions[selected]
    end
end)

-- 自动功能
ui:toggle(MainTab, "自动箱子", "自动收集箱子", false, function(value)
    getgenv().auto = value
end)

ui:toggle(MainTab, "自动升级", "自动升级基地", false, function(value)
    getgenv().autoTeleport = value
end)

-- 透视功能
ui:toggle(MainTab, "透视开启", "开启玩家透视", false, function(value)
    getgenv().ESPEnabled = value
end)

ui:toggle(MainTab, "模型透视", "显示骨骼透视", false, function(value)
    getgenv().ShowSkeleton = value
end)

-- 娱乐功能页
ui:btn(FunTab, "获取RPG", "快速获取RPG武器", function()
    -- 获取RPG的代码
end)

ui:toggle(FunTab, "RPG轰炸", "自动RPG攻击", false, function(value)
    -- RPG轰炸代码
end)

ui:toggle(FunTab, "护盾攻击", "攻击基地护盾", false, function(value)
    -- 护盾攻击代码
end)

-- 添加橙黑渐变流动效果
task.spawn(function()
    task.wait(2)
    
    if ui.Window and ui.Window.Instance then
        local mainFrame = ui.Window.Instance
        
        -- 主窗口橙黑流动描边
        local windowStroke = Instance.new("UIStroke")
        windowStroke.Thickness = 3
        windowStroke.Transparency = 0
        
        local orangeBlackGradient = Instance.new("UIGradient")
        orangeBlackGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("FF6B00")),
            ColorSequenceKeypoint.new(0.3, Color3.fromHex("000000")),
            ColorSequenceKeypoint.new(0.7, Color3.fromHex("FF8C00")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("000000"))
        })
        orangeBlackGradient.Parent = windowStroke
        windowStroke.Parent = mainFrame
        
        -- 流动效果
        task.spawn(function()
            local offset = 0
            while true do
                offset = (offset + 0.015) % 1
                orangeBlackGradient.Offset = Vector2.new(offset, 0)
                task.wait(0.06)
            end
        end)
        
        print("✅ 橙C美式UI加载完成！橙黑流动效果已应用")
    end
end)

-- 显示欢迎消息
ui:notify("橙C美式", "脚本加载完成！", "star")
