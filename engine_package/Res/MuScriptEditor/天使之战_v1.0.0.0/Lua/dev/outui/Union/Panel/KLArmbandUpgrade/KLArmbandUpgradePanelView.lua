---@class KLArmbandUpgradePanelView:UIKmlLuaViewBase
---@field bottomArmbandBg UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field CloseButton UIKmlLuaControlHandler
---@field UpgradeBtn UIKmlLuaControlHandler
---@field StrengthenBtn UIKmlLuaControlHandler
---@field armbandBg UIKmlLuaControlHandler
---@field armbandicon UIKmlLuaControlHandler
---@field armbandname UIKmlLuaControlHandler
---@field layout_armbandstar UIKmlLuaControlHandler
---@field datalist_armbandstar UIKmlLuaControlHandler
---@field KmlEquipReborn UIKmlLuaControlHandler
---@field equipbg UIKmlLuaControlHandler
---@field strengthIntro UIKmlLuaControlHandler
---@field preLevel UIKmlLuaControlHandler
---@field arrow UIKmlLuaControlHandler
---@field nextLevel UIKmlLuaControlHandler
---@field resultAnim UIKmlLuaControlHandler
---@field resultLv UIKmlLuaControlHandler
---@field resultAnimText UIKmlLuaControlHandler
---@field title_di UIKmlLuaControlHandler
---@field arr_title UIKmlLuaControlHandler
---@field armbandArrview UIKmlLuaControlHandler
---@field armbandlayout UIKmlLuaControlHandler
---@field arrData_list UIKmlLuaControlHandler
---@field fulllevelCost UIKmlLuaControlHandler
---@field armbandtip UIKmlLuaControlHandler
---@field costBg UIKmlLuaControlHandler
---@field costItem UIKmlLuaControlHandler
---@field costName UIKmlLuaControlHandler
---@field costNum UIKmlLuaControlHandler
---@field costAdd UIKmlLuaControlHandler
---@field OperateBtn UIKmlLuaControlHandler
---@field btntip UIKmlLuaControlHandler
---@field fulllevel UIKmlLuaControlHandler
---@field Text_Strengthen UIKmlLuaControlHandler
---@field btnarmtip UIKmlLuaControlHandler
local KLArmbandUpgradePanelView = {}
setmetatable(KLArmbandUpgradePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Union/Panel/KLArmbandUpgrade/KLArmbandUpgradePanelKml'
---@param parent UIKmlLuaControlHandler
function KLArmbandUpgradePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLArmbandUpgradePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Union/Panel/KLArmbandUpgrade/KLArmbandUpgradePanel']

return KLArmbandUpgradePanelView
