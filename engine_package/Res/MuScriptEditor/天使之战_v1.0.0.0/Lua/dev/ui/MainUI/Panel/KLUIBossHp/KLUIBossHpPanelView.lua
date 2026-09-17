---@class KLUIBossHpPanelView:UIKmlLuaViewBase
---@field move_root UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field bg33 UIKmlLuaControlHandler
---@field bg_boss2 UIKmlLuaControlHandler
---@field bg44 UIKmlLuaControlHandler
---@field sliderHp UIKmlLuaControlHandler
---@field sliderHp2 UIKmlLuaControlHandler
---@field sliderHp3 UIKmlLuaControlHandler
---@field guishu UIKmlLuaControlHandler
---@field KLUIBossHpButton UIKmlLuaControlHandler
---@field bg22 UIKmlLuaControlHandler
---@field item_layout UIKmlLuaControlHandler
---@field drop_data_list UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field icon UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field name UIKmlLuaControlHandler
---@field club_name UIKmlLuaControlHandler
---@field snatchBtn UIKmlLuaControlHandler
local KLUIBossHpPanelView = {}
setmetatable(KLUIBossHpPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/MainUI/Panel/KLUIBossHp/KLUIBossHpPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIBossHpPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIBossHpPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/MainUI/Panel/KLUIBossHp/KLUIBossHpPanel']

return KLUIBossHpPanelView
