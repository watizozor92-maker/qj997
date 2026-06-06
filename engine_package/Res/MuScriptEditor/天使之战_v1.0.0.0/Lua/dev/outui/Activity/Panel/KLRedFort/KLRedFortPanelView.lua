---@class KLRedFortPanelView:UIKmlLuaViewBase
---@field root UIKmlLuaControlHandler
---@field img2_2 UIKmlLuaControlHandler
---@field img_367 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img3_2 UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field btnClose UIKmlLuaControlHandler
---@field panel6 UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field text5 UIKmlLuaControlHandler
---@field itemRoot UIKmlLuaControlHandler
---@field panel16 UIKmlLuaControlHandler
---@field img17 UIKmlLuaControlHandler
---@field text18 UIKmlLuaControlHandler
---@field textLevel UIKmlLuaControlHandler
---@field panel19 UIKmlLuaControlHandler
---@field img20 UIKmlLuaControlHandler
---@field text21 UIKmlLuaControlHandler
---@field textOpenTime UIKmlLuaControlHandler
---@field panel22 UIKmlLuaControlHandler
---@field img23 UIKmlLuaControlHandler
---@field textActivityTime UIKmlLuaControlHandler
---@field text24 UIKmlLuaControlHandler
---@field panel28 UIKmlLuaControlHandler
---@field img29 UIKmlLuaControlHandler
---@field text30 UIKmlLuaControlHandler
---@field textRule UIKmlLuaControlHandler
---@field btnEnter UIKmlLuaControlHandler
local KLRedFortPanelView = {}
setmetatable(KLRedFortPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLRedFort/KLRedFortPanelKml'
---@param parent UIKmlLuaControlHandler
function KLRedFortPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLRedFortPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLRedFort/KLRedFortPanel']

return KLRedFortPanelView
