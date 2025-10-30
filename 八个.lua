local WindUI
pcall(function()
    WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
    if not WindUI then
        warn("无法加载WindUI库，请检查网络连接")
    end
end)

function createBilliardsWindow()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local HttpService = game:GetService("HttpService")

    local aimLineEnabled = false
    local aimLine, aimBeam, renderConnection
    local lineDistance = 100
    local lineThickness = 0.02
    local lineColor = Color3.fromRGB(255, 100, 100)

    local function createAimLine()
        if aimLine then
            aimLine:Destroy()
        end

        aimLine = Instance.new("Part")
        aimLine.Name = "BilliardsAimLine"
        aimLine.Anchored = true
        aimLine.CanCollide = false
        aimLine.Material = Enum.Material.Neon
        aimLine.Color = lineColor
        aimLine.Size = Vector3.new(lineThickness, lineThickness, 1)
        aimLine.Parent = Workspace
        aimLine.Transparency = 0.2

        aimBeam = Instance.new("Beam")
        aimBeam.Color = ColorSequence.new(lineColor)
        aimBeam.Width0 = lineThickness
        aimBeam.Width1 = lineThickness
        aimBeam.FaceCamera = true
        aimBeam.Brightness = 2
        aimBeam.Parent = aimLine

        local attachment0 = Instance.new("Attachment")
        local attachment1 = Instance.new("Attachment")
        attachment0.Parent = aimLine
        attachment1.Parent = aimLine

        aimBeam.Attachment0 = attachment0
        aimBeam.Attachment1 = attachment1
    end

    local function updateAimLine()
        if not aimLineEnabled or not aimLine then return end

        local hitTrajectory
        local tables = Workspace:FindFirstChild("Tables")
        if tables then
            local table1 = tables:FindFirstChild("Table1")
            if table1 then
                local guides = table1:FindFirstChild("Guides")
                if guides then
                    hitTrajectory = guides:FindFirstChild("HitTrajectory")
                end
            end
        end

        if hitTrajectory then
            local direction = hitTrajectory.CFrame.LookVector
            local startPos = hitTrajectory.Position
            local endPos = startPos + direction * lineDistance

            local lineDir = (endPos - startPos).Unit
            local length = (endPos - startPos).Magnitude

            aimLine.Size = Vector3.new(lineThickness, lineThickness, length)
            aimLine.CFrame = CFrame.lookAt(startPos + lineDir * length / 2, endPos)

            if aimBeam then
                aimBeam.Attachment0.Position = Vector3.New(0, 0, length/2)
                aimBeam.Attachment1.Position = Vector3.New(0, 0, -length/2)
            end

            aimLine.Transparency = 0.2
        else
            aimLine.Transparency = 1
        end
    end

    local Window = WindUI:CreateWindow({
        Title = "橙C美式 8个球池经典",
        IconTransparency = 0.5,
        IconThemed = true,
        Author = "作者: 橙子",
        Folder = "橙C美式",
        Size = UDim2.fromOffset(450, 400),
        Transparent = false,
        Theme = "Dark",
        BackgroundColor = Color3.fromRGB(25, 25, 35),
        User = {
            Enabled = true,
            Callback = function() print("点击了用户信息") end,
            Anonymous = false
        },
        SideBarWidth = 200,
        ScrollBarEnabled = true,
    })

    local TimeTag = Window:Tag({
        Title = "00:00:00",
        Color = Color3.fromHex("#FFA500")
    })

    Window:Tag({
        Title = "8个球池经典",
        Color = Color3.fromHex("#FFA500")
    })

    task.spawn(function()
        while true do
            local now = os.date("*t")
            local hours = string.format("%02d", now.hour)
            local minutes = string.format("%02d", now.min)
            local seconds = string.format("%02d", now.sec)

            TimeTag:SetTitle(hours .. ":" .. minutes .. ":" .. seconds)
            task.wait(1)
        end
    end)

    Window:EditOpenButton({
        Title = "8个球池经典",
        Icon = "target",
        CornerRadius = UDim.new(0,16),
        StrokeThickness = 2,
        Color = ColorSequence.new(
            Color3.fromHex("FF6B00"),
            Color3.fromHex("FFA500")
        ),
        Draggable = true,
    })

    local MainTab = Window:Tab({
        Title = "主要功能",
        Icon = "target",  
        Locked = false,
    })

    MainTab:Paragraph({
        Title = "功能",
        Desc = "如果延长辅助线没有用就多开几遍",
    })

    MainTab:Toggle({
        Title = "开启辅助线",
        Desc = "显示击球轨迹延长线",
        Callback = function(state)
            aimLineEnabled = state
            if state then
                createAimLine()
                if not renderConnection then
                    renderConnection = RunService.RenderStepped:Connect(updateAimLine)
                end
                print("辅助线已开启")
            else
                if aimLine then
                    aimLine:Destroy()
                    aimLine = nil
                end
                if renderConnection then
                    renderConnection:Disconnect()
                    renderConnection = nil
                end
                print("辅助线已关闭")
            end
        end
    })

    local optionMap = {
        ["极细"] = 0.01, ["超细"] = 0.02, ["标准"] = 0.03, ["明显"] = 0.05,
        ["短距离"] = 50, ["中距离"] = 80, ["长距离"] = 120, ["超长距离"] = 200
    }

    local function createDropdown(title, desc, options, updateFunc)
        MainTab:Dropdown({
            Title = title,
            Desc = desc,
            Values = options,
            Callback = function(option)
                local value = optionMap[option]
                if value then
                    updateFunc(value)
                end
            end
        })
    end

    createDropdown("线条粗细", "选择辅助线粗细", {"极细", "超细", "标准", "明显"}, 
        function(thickness)
            lineThickness = thickness
            if aimLine then
                aimLine.Size = Vector3.new(thickness, thickness, aimLine.Size.Z)
                aimBeam.Width0 = thickness
                aimBeam.Width1 = thickness
            end
        end
    )

    createDropdown("延长距离", "选择辅助线长度", {"短距离", "中距离", "长距离", "超长距离"},
        function(distance)
            lineDistance = distance
            if aimLine then
                updateAimLine()
            end
        end
    )

    MainTab:Dropdown({
        Title = "线条颜色",
        Desc = "选择辅助线颜色",
        Values = {"红色", "绿色", "蓝色", "黄色", "白色"},
        Callback = function(option)
            local colors = {
                ["红色"] = Color3.fromRGB(255, 100, 100),
                ["绿色"] = Color3.fromRGB(100, 255, 100),
                ["蓝色"] = Color3.fromRGB(100, 150, 255),
                ["黄色"] = Color3.fromRGB(255, 255, 100),
                ["白色"] = Color3.fromRGB(240, 240, 240)
            }

            lineColor = colors[option] or lineColor
            if aimLine then
                aimLine.Color = lineColor
                aimBeam.Color = ColorSequence.new(lineColor)
            end
        end
    })

    MainTab:Button({
        Title = "重置辅助线",
        Desc = "重新创建辅助线",
        Callback = function()
            if aimLineEnabled then
                createAimLine()
                print("辅助线已重置")
            end
        end
    })

    MainTab:Button({
        Title = "清理所有线条",
        Desc = "清除场景中的辅助线",
        Callback = function()
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj.Name == "BilliardsAimLine" then
                    obj:Destroy()
                end
            end
            aimLine = nil
            print("所有辅助线已清理")
        end
    })

    print(" 橙C美式 8个球池经典 加载完成！")
end

if WindUI then
    createBilliardsWindow()
else
    warn("WindUI加载失败，无法初始化界面")
end
