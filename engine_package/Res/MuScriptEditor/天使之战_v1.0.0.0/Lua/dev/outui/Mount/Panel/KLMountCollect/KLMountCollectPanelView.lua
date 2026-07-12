---@class KLMountCollectPanelView:UIKmlLuaViewBase
---@field Node UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field att_info_list_container UIKmlLuaControlHandler
---@field mount_info_scrollview UIKmlLuaControlHandler
---@field att_list UIKmlLuaControlHandler
---@field dataList_att UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
local KLMountCollectPanelView = {}
setmetatable(KLMountCollectPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Mount/Panel/KLMountCollect/KLMountCollectPanelKml'
---@param parent UIKmlLuaControlHandler
function KLMountCollectPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLMountCollectPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Mount/Panel/KLMountCollect/KLMountCollectPanel']

return KLMountCollectPanelView
