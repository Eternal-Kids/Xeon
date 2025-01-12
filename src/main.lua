local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Eternal-Kids/Xeon/refs/heads/main/src/xsxlib.lua"))() -- Ps by EKid: This is saved version of lib!
local version = "1.1721"
local Notif = library:InitNotifications()
local Wm = library:Watermark("Xeon by EKid01 | v" .. version ..  " | " .. library:GetUsername())
local FpsWm = Wm:AddWatermark("fps: " .. library.fps)
coroutine.wrap(function()
    while wait(.75) do
        FpsWm:Text("fps: " .. library.fps)
    end
end)()
library.title = "Xeon by EKid01 v"..version
Notif:Notify("Loading a xeon...", 3, "alert")

local silentAimActive = false
local esp = loadstring(game:HttpGet('https://raw.githubusercontent.com/0f76/seere_v3/main/ESP/v3_esp.lua'))()
esp.enabled = false
esp.teamcheck = false
esp.outlines = true
esp.shortnames = true
esp.team_boxes = {true,Color3.fromRGB(255,255,255),Color3.fromRGB(1,1,1),0}
esp.team_chams = {true,Color3.fromRGB(255, 255, 255),Color3.fromRGB(138, 139, 194),.25,.75,true}
esp.team_names = {true,Color3.fromRGB(255,255,255)}
esp.team_healthbar = {true, Color3.new(0,255,0), Color3.new(255,0,0)}
esp.team_arrow = {false, Color3.new(255,255,255), 0.5}
esp.team_distance = true
esp.team_health = true
 
local noClip = false

local function applyNoClip(character)
    if not character then return end
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.CanCollide = not noClip
        end
    end
    if character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CanCollide = not noClip
    end
end
local function setNoClip(enabled)
    noClip = enabled
    applyNoClip(LocalPlayer.Character)
end
 
function toggleNoClip()
    setNoClip(not noClip)
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local flying = false
local flySpeed = 100 --Set up it to for yourself
local maxFlySpeed = 1000 --Set up it to for yourself
local speedIncrement = 0.4 --Set up it to for yourself
local originalGravity = workspace.Gravity

LocalPlayer.CharacterAdded:Connect(function(newCharacter) 
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

local function randomizeValue(value, range)
    return value + (value * (math.random(-range, range) / 100))
end

local function fly()
    while flying do
        local MoveDirection = Vector3.new()
        local cameraCFrame = workspace.CurrentCamera.CFrame

        MoveDirection = MoveDirection + (UserInputService:IsKeyDown(Enum.KeyCode.W) and cameraCFrame.LookVector or Vector3.new())
        MoveDirection = MoveDirection - (UserInputService:IsKeyDown(Enum.KeyCode.S) and cameraCFrame.LookVector or Vector3.new())
        MoveDirection = MoveDirection - (UserInputService:IsKeyDown(Enum.KeyCode.A) and cameraCFrame.RightVector or Vector3.new())
        MoveDirection = MoveDirection + (UserInputService:IsKeyDown(Enum.KeyCode.D) and cameraCFrame.RightVector or Vector3.new())
        MoveDirection = MoveDirection + (UserInputService:IsKeyDown(Enum.KeyCode.Space) and Vector3.new(0, 1, 0) or Vector3.new())
        MoveDirection = MoveDirection - (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and Vector3.new(0, 1, 0) or Vector3.new())

        if MoveDirection.Magnitude > 0 then
            flySpeed = math.min(flySpeed + speedIncrement, maxFlySpeed) 
            MoveDirection = MoveDirection.Unit * math.min(randomizeValue(flySpeed, 10), maxFlySpeed)
            HumanoidRootPart.Velocity = MoveDirection * 0.5
        else
            HumanoidRootPart.Velocity = Vector3.new(0, 0, 0) 
        end

        RunService.RenderStepped:Wait() 
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.P then
        flying = not flying
        if flying then
            workspace.Gravity = 0 
            fly() 
        else
            flySpeed = 100 
            HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            workspace.Gravity = originalGravity
        end
    end
end)

function GetPlayerViewModels()
    if workspace:FindFirstChild("ViewModels") then
        local ViewModelsObject = workspace.ViewModels
        if ViewModelsObject.FirstPerson:GetChildren()[1] ~= nil then
            local PlayerViewModels = ViewModelsObject.FirstPerson:GetChildren()[1]
            return PlayerViewModels
        else
            return nil
        end
    else
        return nil
    end
end

function MakeWorldReflectance(value)
    for _, obj : Part in game:GetDescendants() do
        if true then
            pcall(function()
                if obj.Reflectance == 0 then
                    obj.Reflectance = 0.15
                end
            end)
        else
            pcall(function()
                obj.Reflectance = 0.15
            end)
        end
    end
end

function ChangeWorldColor(value)
    while task.wait(.1) do
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        Lighting.ClockTime = 0
    end
end

function CustomGunMaterial()
    while task.wait(.1) do
        local PlayerViewModels = GetPlayerViewModels()
        if PlayerViewModels ~= nil then
            if true then
                for _, obj in PlayerViewModels:GetDescendants() do
                    if obj:IsA("MeshPart") or obj:IsA("Part") or obj:IsA("UnionOperation") then
                        obj.Material = "Neon"
                        obj.Color = Color3.fromRGB(255, 0, 0)
                    end
                end
            end
        end
    end
end

local activeWeapons = {} local playerName = game:GetService("Players").LocalPlayer.Name local assetFolder = game:GetService("Players").LocalPlayer.PlayerScripts.Assets.ViewModels local skinlib = {}
function skinlib:change(normalWeaponName, skinName)
    if not normalWeaponName then return end
    local normalWeapon = assetFolder:FindFirstChild(normalWeaponName)
    if not normalWeapon then return end
    if true then
        if skinName then
            local skin = assetFolder:FindFirstChild(skinName)
            if not skin then
                return
            end
 
            normalWeapon:ClearAllChildren()
            for _, child in pairs(skin:GetChildren()) do
                local newChild = child:Clone()
                newChild.Parent = normalWeapon
            end
            activeWeapons[normalWeaponName] = true
        end
    else
        activeWeapons[normalWeaponName] = nil
    end
end

local function getNearestHead()
local closestPlayer = nil
local shortestDistance = math.huge
 
for _, player in pairs(Players:GetPlayers()) do
if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
if distance < shortestDistance then
shortestDistance = distance
closestPlayer = player
end
end
end
 
if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
return closestPlayer.Character.Head
end
 
return nil
end
 
 
UserInputService.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 and silentAimActive then
local targetHead = getNearestHead()
if targetHead then
local aimPosition = targetHead.Position
Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPosition)
ReplicatedStorage.Remotes.Attack:FireServer(targetHead)
end
end
end)

library:Introduction()
wait(0.1)
local Init = library:Init()

local AimTab = Init:NewTab("Aim")
local VisualTab = Init:NewTab("Visual")
local SkinTab = Init:NewTab("Skinchanger")
local PlayerTab = Init:NewTab("Player")

AimTab:NewLabel("Aim", "center")
local SilentAimToggle = AimTab:NewToggle("Enable", false, function(value)
    silentAimActive = value
end)

VisualTab:NewLabel("ESP", "center")
local ESPToggle = VisualTab:NewToggle("Enable", false, function(value)
    esp.enabled = value
end)
local ESP_ArrowsToggle = VisualTab:NewToggle("Arrows", false, function(value)
    esp.team_arrow = {value, Color3.new(255,255,255), 0.5}
end)
VisualTab:NewLabel("Fun", "center")
local SkyboxA = VisualTab:NewToggle("Meme Skybox", false, function(value)
    Notif:Notify("Skybox in dev", 4, "error")
end)
local NeonAVisual = VisualTab:NewButton("Neon Weapon", function(value)
    CustomGunMaterial()
end)
local NightVisual = VisualTab:NewButton("Night", function(value)
    MakeWorldReflectance()
    ChangeWorldColor()
end)

PlayerTab:NewLabel("Player", "center")
PlayerTab:NewLabel("Press P to activate fly!", "left")
local Slider1 = PlayerTab:NewSlider("Flying Speed", "", true, "/", {min = 50, max = 1000, default = 100}, function(value)
    flySpeed = value
end)
local NoclipToggle = PlayerTab:NewToggle("Noclip", false, function(value)
    setNoClip(not noClip)
end)
SkinTab:NewLabel("Primary", "center")
local ARSkin = SkinTab:NewSelector("Assault Rifle", "None", {"AK-47", "AKEY-47", "Boneclaw Rifle"}, function(skin)
    skinlib:change("Assault Rifle", skin)
end)
local SniperSkin = SkinTab:NewSelector("Sniper", "None", {"Pixel Sniper", "Keyper", "Gingerbread Sniper", "Hyper Sniper"}, function(skin)
    skinlib:change("Sniper", skin)
end)
local CrossbowSkin = SkinTab:NewSelector("Crossbow", "None", {"Pixel Crossbow", "Frosty Crossbow"}, function(skin)
    skinlib:change("Crossbow", skin)
end)
SkinTab:NewLabel("Secondary", "center")
local HandGunSkin = SkinTab:NewSelector("Handgun", "None", {"Pixel Handgun", "Blaster", "Gingerbread Handgun", "Pumpkin Handgun", "Chainsaw"}, function(skin)
    skinlib:change("Handgun", skin)
end)
local RevolverSkin = SkinTab:NewSelector("Revolver", "None", {"Boneclaw Revolver", ""}, function(skin)
    skinlib:change("Revolver", skin)
end)
SkinTab:NewLabel("Melee", "center")
local KatanaSkin = SkinTab:NewSelector("Katana", "None", {"Pixel Katana", "Saber", "2025 Katana"}, function(skin)
    skinlib:change("Katana", skin)
end)
local KnifeSkin = SkinTab:NewSelector("Knife", "None", {"Candy Cane", "Karambit", "Chancla", "Machete", "Invisible"}, function(skin)
    skinlib:change("Knife", skin)
end)
SkinTab:NewLabel("Utility", "center")
SkinTab:NewLabel("Skinchanger by ??? moded by EKid01", "left")
SkinTab:NewLabel("Use skinlib by EKid01", "left")

Notif:Notify("Xeon is loaded! Version "..version, 4, "success")
