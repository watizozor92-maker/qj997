---@class KLMountStorePanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field txt_title UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field att_info UIKmlLuaControlHandler
---@field titleIcon3 UIKmlLuaControlHandler
---@field text9 UIKmlLuaControlHandler
---@field attInfoRoot UIKmlLuaControlHandler
---@field attBg UIKmlLuaControlHandler
---@field att_info_list_container UIKmlLuaControlHandler
---@field mount_info_scrollview UIKmlLuaControlHandler
---@field att_list UIKmlLuaControlHandler
---@field dataList_att UIKmlLuaControlHandler
---@field mountInfoRoot UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field togglegroup UIKmlLuaControlHandler
---@field rideBg UIKmlLuaControlHandler
---@field loopscrollview1 UIKmlLuaControlHandler
---@field rideDatalist UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field wujihuo UIKmlLuaControlHandler
---@field wujihuo1 UIKmlLuaControlHandler
local KLMountStorePanelView = {}
setmetatable(KLMountStorePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Mount/Panel/KLMountStore/KLMountStorePanelKml'
---@param parent UIKmlLuaControlHandler
function KLMountStorePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLMountStorePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Mount/Panel/KLMountStore/KLMountStorePanel']

return KLMountStorePanelView
