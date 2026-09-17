---@class KLKingOfRoadPanelView:UIKmlLuaViewBase
---@field Image UIKmlLuaControlHandler
---@field Bg UIKmlLuaControlHandler
---@field title_bg UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field Btn_Close UIKmlLuaControlHandler
---@field BodyBg UIKmlLuaControlHandler
---@field TaskList UIKmlLuaControlHandler
---@field layout4 UIKmlLuaControlHandler
---@field taskDataList UIKmlLuaControlHandler
---@field GroupList UIKmlLuaControlHandler
---@field layout5 UIKmlLuaControlHandler
---@field groupDataList UIKmlLuaControlHandler
---@field itemIcon UIKmlLuaControlHandler
---@field ObjPos UIKmlLuaControlHandler
---@field BtnGet1 UIKmlLuaControlHandler
---@field Img_Received_1 UIKmlLuaControlHandler
---@field bg_title UIKmlLuaControlHandler
local KLKingOfRoadPanelView = {}
setmetatable(KLKingOfRoadPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Task/Panel/KLKingOfRoad/KLKingOfRoadPanelKml'
---@param parent UIKmlLuaControlHandler
function KLKingOfRoadPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLKingOfRoadPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Task/Panel/KLKingOfRoad/KLKingOfRoadPanel']

return KLKingOfRoadPanelView
