---@class KLRedFortSettlementPanelView:UIKmlLuaViewBase
---@field root UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field text12 UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field textKillScore UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field textRank UIKmlLuaControlHandler
---@field text8 UIKmlLuaControlHandler
---@field btnOK UIKmlLuaControlHandler
---@field text13 UIKmlLuaControlHandler
---@field text14 UIKmlLuaControlHandler
local KLRedFortSettlementPanelView = {}
setmetatable(KLRedFortSettlementPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLRedFortSettlement/KLRedFortSettlementPanelKml'
---@param parent UIKmlLuaControlHandler
function KLRedFortSettlementPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLRedFortSettlementPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLRedFortSettlement/KLRedFortSettlementPanel']

return KLRedFortSettlementPanelView
