---@class KLMonsterMapPointPanelView:UIKmlLuaViewBase
---@field move_root UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field bgImg UIKmlLuaControlHandler
---@field closeBtn_3 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field loopscrollview UIKmlLuaControlHandler
---@field loopscrollviewData UIKmlLuaControlHandler
---@field MonsterName UIKmlLuaControlHandler
---@field closeBtn_2 UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
local KLMonsterMapPointPanelView = {}
setmetatable(KLMonsterMapPointPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Monster/Panel/KLMonsterMapPoint/KLMonsterMapPointPanelKml'
---@param parent UIKmlLuaControlHandler
function KLMonsterMapPointPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLMonsterMapPointPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Monster/Panel/KLMonsterMapPoint/KLMonsterMapPointPanel']

return KLMonsterMapPointPanelView
