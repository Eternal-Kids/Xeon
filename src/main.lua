--[[
    Xeon by EKid (discord: ekid.dev)
    Please dont fork whithout credit me
    Sorry bungie#0001 i am just moded lib!
]]
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Eternal-Kids/Xeon/refs/heads/main/src/xsxlib.lua"))() -- Ps by EKid: This is saved version of lib!
local version = "1.18"
local Notif = library:InitNotifications()
local Wm = library:Watermark("Xeon by EKid01 | v" .. version ..  " | " .. library:GetUsername())
local FpsWm = Wm:AddWatermark("fps: " .. library.fps)
local rankchecker_name = library:GetUsername()
coroutine.wrap(function()
    while wait(.75) do
        FpsWm:Text("fps: " .. library.fps)
    end
end)()
library.rank = "Guest"
Notif:Notify("Loading a xeon...", 3, "alert")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")

-- rank database (luaobfuscator)
local v0=string.char;local v1=string.byte;local v2=string.sub;local v3=bit32 or bit ;local v4=v3.bxor;local v5=table.concat;local v6=table.insert;local function v7(v8,v9) local v10={};for v11=1, #v8 do v6(v10,v0(v4(v1(v2(v8,v11,v11 + 1 )),v1(v2(v9,1 + (v11% #v9) ,1 + (v11% #v9) + 1 )))%256 ));end return v5(v10);end if (rankchecker_name==v7("\225\219\242\61\194\163\232\6\227\219\250\61\213","\126\177\163\187\69\134\219\167")) then library.rank=v7("\7\200\60","\156\67\173\74\165");elseif (rankchecker_name==v7("\19\152\99\57\166\41\80\96\229","\38\84\215\41\118\220\70")) then library.rank=v7("\116\19\52","\158\48\118\66\114");elseif (rankchecker_name==v7("\140\11\57\18\82\159\212\157\117\72","\155\203\68\112\86\19\197")) then library.rank=v7("\98\212\55\241\79\118\225","\152\38\189\86\156\32\24\133");end

local silentAimActive = false
local skinAcess = false
if library.rank == "Dev" then
    Notif:Notify("Now you are dev", 3, "alert")
    skinAcess = true
elseif library.rank == "Diamond" then
    Notif:Notify("You gifted a diamond subscripe!", 3, "alert")
    skinAcess = true
end

local esp = loadstring(game:HttpGet('https://raw.githubusercontent.com/Eternal-Kids/Xeon/refs/heads/main/src/esp.lua'))()
esp.enabled = false
 
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
local flySpeed = 100
local maxFlySpeed = 1000
local speedIncrement = 0.4
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
    if not gameProcessed and input.KeyCode == Enum.KeyCode.X then
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


library.title = "Xeon by EKid01 v"..version .." | " ..library.rank
library:Introduction()
wait(0.1)
local Init = library:Init()

local AimTab = Init:NewTab("Aim")
local VisualTab = Init:NewTab("Visual")
local SkinTab = Init:NewTab("Skinchanger")
local PlayerTab = Init:NewTab("Player")

if library.rank == "Dev" then
    local DeletedPage = Init:NewTab("Deleted Tab")
    local ExpFunctions = Init:NewTab("Experement. Func`s")

    local NeonAVisual = DeletedPage:NewButton("Neon Weapon", function(value)
        CustomGunMaterial()
    end) -- Banned by "not used func"
end

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

if skinAcess == true then
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
else
SkinTab:NewLabel("Skinchanger allowed only Silver +", "left")
end

Notif:Notify("Xeon is loaded! Version "..version, 4, "success")
