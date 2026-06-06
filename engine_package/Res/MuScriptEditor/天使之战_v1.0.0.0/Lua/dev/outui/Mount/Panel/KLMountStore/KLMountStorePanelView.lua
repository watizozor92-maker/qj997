---@class KLMountStorePanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControl
---@field txt_title UIKmlLuaControl
---@field closeBtn UIKmlLuaControl
---@field att_info UIKmlLuaControl
---@field titleIcon3 UIKmlLuaControl
---@field text9 UIKmlLuaControl
---@field attInfoRoot UIKmlLuaControl
---@field attBg UIKmlLuaControl
---@field att_info_list_container UIKmlLuaControl
---@field mount_info_scrollview UIKmlLuaControl
---@field att_list UIKmlLuaControl
---@field dataList_att UIKmlLuaControl
---@field mountInfoRoot UIKmlLuaControl
---@field img2 UIKmlLuaControl
---@field togglegroup UIKmlLuaControl
---@field rideBg UIKmlLuaControl
---@field loopscrollview1 UIKmlLuaControl
---@field rideDatalist UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field wujihuo UIKmlLuaControl
---@field wujihuo1 UIKmlLuaControl
local KLMountStorePanelView = {}
setmetatable(KLMountStorePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Mount/Panel/KLMountStore/KLMountStorePanelKml'
---@param parent UIKmlLuaControl
function KLMountStorePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLMountStorePanelView
