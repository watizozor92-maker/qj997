---@class KLInViteFriendPanelView:UIKmlLuaViewBase
---@field prefab_819 UIKmlLuaControlHandler
---@field CodeTxt UIKmlLuaControlHandler
---@field Num UIKmlLuaControlHandler
---@field CopyBtn UIKmlLuaControlHandler
---@field GenerateBtn UIKmlLuaControlHandler
local KLInViteFriendPanelView = {}
setmetatable(KLInViteFriendPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Setting/Panel/KLInViteFriend/KLInViteFriendPanelKml'
---@param parent UIKmlLuaControlHandler
function KLInViteFriendPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLInViteFriendPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Setting/Panel/KLInViteFriend/KLInViteFriendPanel']

return KLInViteFriendPanelView
