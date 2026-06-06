---@class KLUnionBossTaskPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field exitBtn UIKmlLuaControlHandler
---@field text_end_time UIKmlLuaControlHandler
---@field text_125 UIKmlLuaControlHandler
---@field text_level UIKmlLuaControlHandler
---@field text_127 UIKmlLuaControlHandler
---@field text_progress UIKmlLuaControlHandler
---@field btn_next UIKmlLuaControlHandler
---@field txt_pass_tip UIKmlLuaControlHandler
---@field btn_auction UIKmlLuaControlHandler
local KLUnionBossTaskPanelView = {}
setmetatable(KLUnionBossTaskPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Union/Panel/KLUnionBossTask/KLUnionBossTaskPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUnionBossTaskPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUnionBossTaskPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Union/Panel/KLUnionBossTask/KLUnionBossTaskPanel']

return KLUnionBossTaskPanelView
