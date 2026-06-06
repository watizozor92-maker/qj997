---@class KLUIBuffInfoListPanelView:UIKmlLuaViewBase
---@field closeBtn UIKmlLuaControlHandler
---@field buffBg UIKmlLuaControlHandler
---@field buffInfo_list1 UIKmlLuaControlHandler
---@field buffInfo_list UIKmlLuaControlHandler
local KLUIBuffInfoListPanelView = {}
setmetatable(KLUIBuffInfoListPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/MainUI/Panel/KLUIBuffInfoList/KLUIBuffInfoListPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIBuffInfoListPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIBuffInfoListPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/MainUI/Panel/KLUIBuffInfoList/KLUIBuffInfoListPanel']

return KLUIBuffInfoListPanelView
