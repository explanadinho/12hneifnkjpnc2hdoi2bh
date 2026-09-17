
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Settings = {
    MenuVisible = true,
    FlyEnabled = false,
    ESPEnabled = false,
    TargetName = "",
    Speed = 50
}

local Core = {}

function Core:Teleport(targetName)
    local target = nil
    for _, p in pairs(Players:GetPlayers()) do
        if string.find(p.Name:lower(), targetName:lower()) then
            target = p
            break
        end
    end
    
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local char = Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -10)
            print("[DeepHat] Teleportado para: " .. target.Name)
        end
    else
        warn("[DeepHat] Player não encontrado.")
    end
end

function Core:ToggleFly()
    Settings.FlyEnabled = not Settings.FlyEnabled
    print("[DeepHat] Voo: " .. (Settings.FlyEnabled and "ON" or "OFF"))
end

local UI = {}

function UI:CreateMenu()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DeepHat_Main"
    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 250, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "DEEPHAT HUB"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = MainFrame

    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0.8, 0, 0, 30)
    TextBox.Position = UDim2.new(0.1, 0, 0.2, 0)
    TextBox.PlaceholderText = "Nome do Alvo..."
    TextBox.Text = ""
    TextBox.Parent = MainFrame

    local TeleportBtn = Instance.new("TextButton")
    TeleportBtn.Size = UDim2.new(0.8, 0, 0, 35)
    TeleportBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
    TeleportBtn.Text = "Teleportar"
    TeleportBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    TeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleportBtn.Parent = MainFrame
    
    TeleportBtn.MouseButton1Click:Connect(function()
        Core:Teleport(TextBox.Text)
    end)

    local FlyBtn = Instance.new("TextButton")
    FlyBtn.Size = UDim2.new(0.8, 0, 0, 35)
    FlyBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
    FlyBtn.Text = "Ativar Voo"
    FlyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    FlyBtn.Parent = MainFrame

    FlyBtn.MouseButton1Click:Connect(function()
        Core:ToggleFly()
    end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if input.KeyCode == Enum.KeyCode.F4 and not processed then
            Settings.MenuVisible = not Settings.MenuVisible
            MainFrame.Visible = Settings.MenuVisible
            print("[DeepHat] Menu: " .. (Settings.MenuVisible and "ON" or "OFF"))
        end
    end)

    return MainFrame
end

print("[DeepHat] Inicializando sistema...")
local MainFrame = UI:CreateMenu()
print("[DeepHat] Pronto! Pressione F4 para abrir/fechar.")
