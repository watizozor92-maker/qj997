---@class KLPrivilegeBossOpenPanelView:UIKmlLuaViewBase
local KLPrivilegeBossOpenPanelView = {}
setmetatable(KLPrivilegeBossOpenPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Panel/KLPrivilegeBossOpen/KLPrivilegeBossOpenPanelKml'
---@param parent UIKmlLuaControlHandler
function KLPrivilegeBossOpenPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLPrivilegeBossOpenPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ChallengeBoss/Panel/KLPrivilegeBossOpen/KLPrivilegeBossOpenPanel']

return KLPrivilegeBossOpenPanelView
