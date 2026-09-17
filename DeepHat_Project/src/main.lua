
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = um = RunService or game:GetService("RunService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local Settings = {
    MenuVisible = true,
    SpeedValue = 50,
    JumpValue = 50,
    ESPEnabled = false
}

local Core = {}

function Core:SetSpeed(value)
    local char = Player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = value
        print("[DeepHat] Speed: " .. value)
    end
end

function Core:SetJump(value)
    local char = Player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = value
        print("[DeepHat] Jump: " .. value)
    end
end

function Core:Teleport(targetName)
    local target = nil
    for _, p in pairs(Players:GetPlayers()) do
        if string.find(p.Name:lower(), targetName:lower()) then
            target = p
            break
        end
    end
    
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local myChar = Player.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            myChar.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -10)
            print("[DeepHat] Teleportado para: " .. target.Name)
        end
    else
        warn("[DeepHat] Player não encontrado.")
    end
end

local function MakeDraggable(guiObject)
    local dragging, dragInput, dragStart, startPos

    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input involvement and input == dragInput and dragging then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DeepHat_UI"
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 250, 0, 320)
    MainFrame.Position = UDim2.new(0.5, -125, 0.5, -160)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Title.Text = "DEEPHAT HUB"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = MainFrame

    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0.8, 0, 0, 30)
    TextBox.Position = UDim2.new(0.1, 0, 0.2, 0)
    TextBox.PlaceholderText = "Nome do Alvo..."
    TextBox.Text = ""
    TextBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.Parent = MainFrame

    local TPBtn = Instance.new("TextButton")
    TPBtn.Size = UDim2.new(0.8, 0, 0, 35)
    TPBtn.Position = UDim2.new(0.1, 0, 0.35, 0)
    TPBtn.Text = "Teleportar"
    TPBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 120)
    TPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TPBtn.Parent = MainFrame
    TPBtn.MouseButton1Click:Connect(function()
        Core:Teleport(TextBox.Text)
    end)

    local SpeedBtn = Instance.new("TextButton")
    SpeedBtn.Size = UDim2.new(0.8, 0, 0, 35)
    SpeedBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
    SpeedBtn.Text = "Speed Hack"
    SpeedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedBtn.Parent = MainFrame
    SpeedBtn.MouseButton1Click:Connect(function()
        Core:SetSpeed(Settings.SpeedValue)
    end)

    local JumpBtn = Instance.new("TextButton")
    JumpBtn.Size = UDim2.new(0.8, 0, 0, 35)
    JumpBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
    JumpBtn.Text = "Jump Hack"
    JumpBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    JumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    JumpBtn.Parent = MainFrame
    JumpBtn.MouseButton1Click:Connect(function()
        Core:SetJump(Settings.JumpValue)
    end)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.Text = "X"
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Parent = MainFrame
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    MakeDraggable(MainFrame)

    UserInputService.InputBegan:Connect(function(input, processed)
        if input.KeyCode == Enum.KeyCode.F4 and not processed then
            Settings.MenuVisible = not Settings.MenuVisible
            MainFrame.Visible = Settings.MenuVisible
        end
    end)
end

task.spawn(function()
    CreateUI()
    print("[DeepHat] Sistema Carregado com Sucesso!")
end)
