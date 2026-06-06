---@class KLUIHurtExpPanelView:UIKmlLuaViewBase
---@field move_root UIKmlLuaControlHandler
---@field button UIKmlLuaControlHandler
---@field img_arrow UIKmlLuaControlHandler
---@field infos UIKmlLuaControlHandler
---@field layout1 UIKmlLuaControlHandler
---@field time UIKmlLuaControlHandler
---@field pre_time UIKmlLuaControlHandler
---@field hurt UIKmlLuaControlHandler
---@field pre_hurt UIKmlLuaControlHandler
---@field perKill UIKmlLuaControlHandler
---@field pre_perKill UIKmlLuaControlHandler
---@field totalKill UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field exp UIKmlLuaControlHandler
---@field pre_exp UIKmlLuaControlHandler
local KLUIHurtExpPanelView = {}
setmetatable(KLUIHurtExpPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/MainUI/Panel/KLUIHurtExp/KLUIHurtExpPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIHurtExpPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIHurtExpPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/MainUI/Panel/KLUIHurtExp/KLUIHurtExpPanel']

return KLUIHurtExpPanelView
