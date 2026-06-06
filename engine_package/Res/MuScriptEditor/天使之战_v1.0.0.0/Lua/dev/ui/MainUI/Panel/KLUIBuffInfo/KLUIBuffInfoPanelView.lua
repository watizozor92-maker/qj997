---@class KLUIBuffInfoPanelView:UIKmlLuaViewBase
---@field maskBtn UIKmlLuaControlHandler
---@field buffBg UIKmlLuaControlHandler
---@field des UIKmlLuaControlHandler
local KLUIBuffInfoPanelView = {}
setmetatable(KLUIBuffInfoPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/MainUI/Panel/KLUIBuffInfo/KLUIBuffInfoPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIBuffInfoPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIBuffInfoPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/MainUI/Panel/KLUIBuffInfo/KLUIBuffInfoPanel']

return KLUIBuffInfoPanelView
