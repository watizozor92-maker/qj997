---@class KLPrivilegeBossEndPanelView:UIKmlLuaViewBase
---@field img_107 UIKmlLuaControlHandler
---@field end_time UIKmlLuaControlHandler
local KLPrivilegeBossEndPanelView = {}
setmetatable(KLPrivilegeBossEndPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Panel/KLPrivilegeBossEnd/KLPrivilegeBossEndPanelKml'
---@param parent UIKmlLuaControlHandler
function KLPrivilegeBossEndPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLPrivilegeBossEndPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ChallengeBoss/Panel/KLPrivilegeBossEnd/KLPrivilegeBossEndPanel']

return KLPrivilegeBossEndPanelView
