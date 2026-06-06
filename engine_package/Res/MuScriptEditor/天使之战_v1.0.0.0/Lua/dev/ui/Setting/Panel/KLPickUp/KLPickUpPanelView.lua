---@class KLPickUpPanelView:UIKmlLuaViewBase
---@field titleBg UIKmlLuaControlHandler
---@field point UIKmlLuaControlHandler
---@field titleTxt UIKmlLuaControlHandler
---@field pickItemList UIKmlLuaControlHandler
---@field BtnReDefault UIKmlLuaControlHandler
---@field BtnReDefaultTxt UIKmlLuaControlHandler
local KLPickUpPanelView = {}
setmetatable(KLPickUpPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Setting/Panel/KLPickUp/KLPickUpPanelKml'
---@param parent UIKmlLuaControlHandler
function KLPickUpPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLPickUpPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Setting/Panel/KLPickUp/KLPickUpPanel']

return KLPickUpPanelView
