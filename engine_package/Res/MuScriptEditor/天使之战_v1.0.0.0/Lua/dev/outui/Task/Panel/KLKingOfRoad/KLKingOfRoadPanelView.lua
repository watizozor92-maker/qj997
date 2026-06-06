---@class KLKingOfRoadPanelView:UIKmlLuaViewBase
---@field Image UIKmlLuaControl
---@field Bg UIKmlLuaControl
---@field title_bg UIKmlLuaControl
---@field title UIKmlLuaControl
---@field Btn_Close UIKmlLuaControl
---@field BodyBg UIKmlLuaControl
---@field TaskList UIKmlLuaControl
---@field layout4 UIKmlLuaControl
---@field taskDataList UIKmlLuaControl
---@field GroupList UIKmlLuaControl
---@field layout5 UIKmlLuaControl
---@field groupDataList UIKmlLuaControl
---@field itemIcon UIKmlLuaControl
---@field ObjPos UIKmlLuaControl
---@field BtnGet1 UIKmlLuaControl
---@field Img_Received_1 UIKmlLuaControl
---@field bg_title UIKmlLuaControl
local KLKingOfRoadPanelView = {}
setmetatable(KLKingOfRoadPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Task/Panel/KLKingOfRoad/KLKingOfRoadPanelKml'
---@param parent UIKmlLuaControl
function KLKingOfRoadPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLKingOfRoadPanelView
