local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local client = game:GetService("Players").LocalPlayer
local mouse = client:GetMouse()
local lastSelectedBox = nil
local selecting = false

local CarSelection = {}
CarSelection._selectedEvent = Instance.new("BindableEvent")
CarSelection.Selected = CarSelection._selectedEvent.Event

function CarSelection:Show()
    for _, car in pairs(workspace.Vehicles:GetChildren()) do
        local box = Instance.new("SelectionBox")
        box.SurfaceTransparency = .75
        box.Name = "Selection"
        box.Parent = car
    end
end

function CarSelection:Hide()
    for _, car in pairs(workspace.Vehicles:GetChildren()) do
        if car:FindFirstChild("Selection") then
            car['Selection']:Destroy()
        end
    end
end

local function GetCarFromPart(part)
    if part.Parent == workspace then return end

    if part.Parent.Name == "Vehicles" then
        return part
    else
        return GetCarFromPart(part.Parent)
    end
end

RunService:BindToRenderStep("CarSelection", Enum.RenderPriority.Last.Value, function()
    local car = GetCarFromPart(mouse.Target)
    if car then
        local box = car:FindFirstChild("Selection")
        if not box then
            box = Instance.new("SelectionBox")
            box.Name = "Selection"
            box.Parent = car
        end

        if lastSelectedBox then
            lastSelectedBox.SurfaceTransparency = .75
        end
        box.SurfaceTransparency = .25
        lastSelectedBox = box
    end
end)

moust.Button1Down:Connect(function()
    if not mouse.Target then return end
    local car = GetCarFromPart(mouse.Target)
    if car then
        CarSelection._selectedEvent:Fire(car)
    end
end)

return CarSelection
