---@class KLMountCollectPanelView:UIKmlLuaViewBase
---@field Node UIKmlLuaControl
---@field closeBtn UIKmlLuaControl
---@field bg UIKmlLuaControl
---@field att_info_list_container UIKmlLuaControl
---@field mount_info_scrollview UIKmlLuaControl
---@field att_list UIKmlLuaControl
---@field dataList_att UIKmlLuaControl
---@field text1 UIKmlLuaControl
---@field img2 UIKmlLuaControl
---@field img3 UIKmlLuaControl
local KLMountCollectPanelView = {}
setmetatable(KLMountCollectPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Mount/Panel/KLMountCollect/KLMountCollectPanelKml'
---@param parent UIKmlLuaControl
function KLMountCollectPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLMountCollectPanelView
