--[[
    Xeon by EKid (discord: tinytosha)
    Please dont fork whithout credit me
    Sorry bungie#0001 i am just moded lib!
]]
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Eternal-Kids/Xeon/refs/heads/main/src/xsxlib.lua"))() -- Ps by EKid: This is saved version of lib!
local version = "1.252"
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
local HttpService = game:GetService("HttpService")

--config
local config_beta = {
    Aim = {
        enabled = false,
    },
    Visual = {
        esp = false,
        night = false,
    },
    Skins = {
        Assault_Rifle = "none",
        Sniper = "none",
        Crossbow = "none",
        Handgun = "none",
        Revolver = "none",
        Knife = "none",
        Katana = "none",
    },
    Other = {
        ver = 2,
        gamever = version,
        
    },
}

makefolder("Xeon")
if isfile("Xeon/config.json") then
    local Config = HttpService:JSONDecode(readfile("Xeon/config.json"))
    if Config.Other.ver == config_beta.Other.ver then
    else
        local jsonString = HttpService:JSONEncode(config_beta)
        local Config = writefile("Xeon/config.json", jsonString)
        Notif:Notify("You config is old", 4, "error")
    end
else
    local jsonString = HttpService:JSONEncode(config_beta)
    local Config = writefile("Xeon/config.json", jsonString)
    
end

local rankdatabase = {
    Developer = {"pickmeshowel2501"},
    Premium = {"tochnolox2501"},
    Banned = {}
}


function checkPlayerRank(playerName)
    for role, players in pairs(rankdatabase) do
        for _, name in ipairs(players) do
            if name == playerName then
                library.rank = role

                if role == "Banned" then LocalPlayer:Kick("You banned") end
                return
            end
        end
    end
end

checkPlayerRank(LocalPlayer.name)

local skinAcess = false
if library.rank == "Developer" then
    skinAcess = true
elseif library.rank == "Premium" then
    skinAcess = true
end


local silentAimActive = false
local esp = loadstring(game:HttpGet('https://raw.githubusercontent.com/Eternal-Kids/Xeon/refs/heads/main/src/esp.lua'))()
esp.enabled = false

if true then
    local Config = HttpService:JSONDecode(readfile("Xeon/config.json"))
    
    silentAimActive = Config.Aim.enabled
    esp.enabled = Config.Visual.esp
end

 
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

function MakeNight()
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
    while wait(0.25) do
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

if skinAcess == true then
    local Config = HttpService:JSONDecode(readfile("Xeon/config.json"))
    if Config.Skins.Sniper == "none" then else skinlib:change("Sniper", Config.Skins.Sniper) end
    if Config.Skins.Assault_Rifle == "none" then else skinlib:change("Assault Rifle", Config.Skins.Assault_Rifle) end
    if Config.Skins.Crossbow == "none" then else skinlib:change("Crossbow", Config.Skins.Crossbow) end
    if Config.Skins.Handgun == "none" then else skinlib:change("Handgun", Config.Skins.Handgun) end
    if Config.Skins.Revolver == "none" then else skinlib:change("Revolver", Config.Skins.Revolver) end
    if Config.Skins.Knife == "none" then else skinlib:change("Knife", Config.Skins.Knife) end
    if Config.Skins.Katana == "none" then else skinlib:change("Katana", Config.Skins.Katana) end
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

if library.rank == "Developer" then
    local DeletedPage = Init:NewTab("Deleted Tab")
    local ExpFunctions = Init:NewTab("Experement. Func`s")

    local NeonAVisual = DeletedPage:NewButton("Neon Weapon", function(value)
        CustomGunMaterial()
    end) -- Banned by "not used func"
end

AimTab:NewLabel("Aim", "center")
local SilentAimToggle = AimTab:NewToggle("Enable", false, function(value)
    silentAimActive = value
    local read = HttpService:JSONDecode(readfile("Xeon/config.json"))
    read.Aim.enabled = value
    local jsonString = HttpService:JSONEncode(read)
    writefile("Xeon/config.json", jsonString)
end)

VisualTab:NewLabel("ESP", "center")
local ESPToggle = VisualTab:NewToggle("Enable", false, function(value)
    esp.enabled = value
    local read = HttpService:JSONDecode(readfile("Xeon/config.json"))
    read.Visual.esp = value
    local jsonString = HttpService:JSONEncode(read)
    writefile("Xeon/config.json", jsonString)
end)
local ESP_ArrowsToggle = VisualTab:NewToggle("Arrows", false, function(value)
    esp.team_arrow = {value, Color3.new(255,255,255), 0.5}
end)
VisualTab:NewLabel("Fun", "center")
local SkyboxA = VisualTab:NewToggle("Meme Skybox", false, function(value)
    Notif:Notify("Skybox in dev", 4, "error")
end)
local NightVisual = VisualTab:NewToggle("Night (Rejoin to disible)", false, function(value)
    local read = HttpService:JSONDecode(readfile("Xeon/config.json")) read.Visual.night = value local jsonString = HttpService:JSONEncode(read) writefile("Xeon/config.json", jsonString)

    MakeNight()
end)
PlayerTab:NewLabel("Player", "center")
PlayerTab:NewLabel("Press X to activate fly!", "left")
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
    local read = HttpService:JSONDecode(readfile("Xeon/config.json")) read.Skins.Assault_Rifle = skin local jsonString = HttpService:JSONEncode(read) writefile("Xeon/config.json", jsonString)
end)
local SniperSkin = SkinTab:NewSelector("Sniper", "None", {"Pixel Sniper", "Keyper", "Gingerbread Sniper", "Hyper Sniper", "Sniper"}, function(skin)
    skinlib:change("Sniper", skin)
    local read = HttpService:JSONDecode(readfile("Xeon/config.json")) read.Skins.Sniper = skin local jsonString = HttpService:JSONEncode(read) writefile("Xeon/config.json", jsonString)
end)
local CrossbowSkin = SkinTab:NewSelector("Crossbow", "None", {"Pixel Crossbow", "Frostbite Crossbow"}, function(skin)
    skinlib:change("Crossbow", skin)
    local read = HttpService:JSONDecode(readfile("Xeon/config.json")) read.Skins.Crossbow = skin local jsonString = HttpService:JSONEncode(read) writefile("Xeon/config.json", jsonString)
end)
SkinTab:NewLabel("Secondary", "center")
local HandGunSkin = SkinTab:NewSelector("Handgun", "None", {"Pixel Handgun", "Blaster", "Gingerbread Handgun", "Pumpkin Handgun", "Chainsaw"}, function(skin)
    skinlib:change("Handgun", skin)
    local read = HttpService:JSONDecode(readfile("Xeon/config.json")) read.Skins.Handgun = skin local jsonString = HttpService:JSONEncode(read) writefile("Xeon/config.json", jsonString)
end)
local RevolverSkin = SkinTab:NewSelector("Revolver", "None", {"Boneclaw Revolver", ""}, function(skin)
    skinlib:change("Revolver", skin)
    local read = HttpService:JSONDecode(readfile("Xeon/config.json")) read.Skins.Revolver = skin local jsonString = HttpService:JSONEncode(read) writefile("Xeon/config.json", jsonString)
end)
SkinTab:NewLabel("Melee", "center")
local KatanaSkin = SkinTab:NewSelector("Katana", "None", {"Pixel Katana", "Saber", "2025 Katana"}, function(skin)
    skinlib:change("Katana", skin)
    local read = HttpService:JSONDecode(readfile("Xeon/config.json")) read.Skins.Katana = skin local jsonString = HttpService:JSONEncode(read) writefile("Xeon/config.json", jsonString)
end)
local KnifeSkin = SkinTab:NewSelector("Knife", "None", {"Candy Cane", "Karambit", "Chancla", "Machete", "Invisible"}, function(skin)
    skinlib:change("Knife", skin)
    local read = HttpService:JSONDecode(readfile("Xeon/config.json")) read.Skins.Knife = skin local jsonString = HttpService:JSONEncode(read) writefile("Xeon/config.json", jsonString)
end)
SkinTab:NewLabel("Utility", "center")
SkinTab:NewLabel("Skinchanger by ??? moded by EKid01", "left")
SkinTab:NewLabel("Use skinlib by EKid01", "left")
else
SkinTab:NewLabel("Skinchanger allowed only premium users", "left")
end

Notif:Notify("Xeon is loaded! Version "..version, 4, "success")

if true then local Config = HttpService:JSONDecode(readfile("Xeon/config.json"))
    if Config.Visual.night == true then
        MakeNight()
    end
end
