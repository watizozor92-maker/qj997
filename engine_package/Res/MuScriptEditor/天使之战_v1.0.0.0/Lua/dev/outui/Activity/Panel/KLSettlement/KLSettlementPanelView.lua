---@class KLSettlementPanelView:UIKmlLuaViewBase
---@field bgClose UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field bg1 UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field gainExprienceBg UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field killMonsterCountBg UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field gainExprienceBg1 UIKmlLuaControlHandler
---@field killMonsterCountBg1 UIKmlLuaControlHandler
---@field togglegroup UIKmlLuaControlHandler
---@field scrollviewList UIKmlLuaControlHandler
---@field select_layout UIKmlLuaControlHandler
---@field select_item_list UIKmlLuaControlHandler
---@field gainExprience UIKmlLuaControlHandler
---@field killMonsterCount UIKmlLuaControlHandler
---@field costContainer UIKmlLuaControlHandler
---@field itemBg UIKmlLuaControlHandler
---@field costItem UIKmlLuaControlHandler
---@field costItemCountTxt UIKmlLuaControlHandler
---@field addbtn UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field costEnterCountTxt UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field okBtn UIKmlLuaControlHandler
local KLSettlementPanelView = {}
setmetatable(KLSettlementPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLSettlement/KLSettlementPanelKml'
---@param parent UIKmlLuaControlHandler
function KLSettlementPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLSettlementPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLSettlement/KLSettlementPanel']

return KLSettlementPanelView
