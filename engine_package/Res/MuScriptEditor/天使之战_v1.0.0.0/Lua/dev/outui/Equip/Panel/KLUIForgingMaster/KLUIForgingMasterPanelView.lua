---@class KLUIForgingMasterPanelView:UIKmlLuaViewBase
---@field Content UIKmlLuaControlHandler
---@field Bg_Template UIKmlLuaControlHandler
---@field panel3 UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field text_title UIKmlLuaControlHandler
---@field btn_close UIKmlLuaControlHandler
---@field text_part_name UIKmlLuaControlHandler
---@field text_tips UIKmlLuaControlHandler
---@field scrollview1 UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field DataList_Condition UIKmlLuaControlHandler
local KLUIForgingMasterPanelView = {}
setmetatable(KLUIForgingMasterPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Equip/Panel/KLUIForgingMaster/KLUIForgingMasterPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIForgingMasterPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIForgingMasterPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Equip/Panel/KLUIForgingMaster/KLUIForgingMasterPanel']

return KLUIForgingMasterPanelView
