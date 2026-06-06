---@class KLSettingTogglePanelView:UIKmlLuaViewBase
---@field root UIKmlLuaControlHandler
---@field panel1 UIKmlLuaControlHandler
---@field panel3 UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field toggleGroupTop UIKmlLuaControlHandler
---@field basicSettingToggle UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field showSettingToggle UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field hookSettingToggle UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field codeToggle UIKmlLuaControlHandler
---@field inviteFriendToggle UIKmlLuaControlHandler
---@field btn_changeRole UIKmlLuaControlHandler
---@field btn_exitGame UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
local KLSettingTogglePanelView = {}
setmetatable(KLSettingTogglePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Setting/Panel/KLSettingToggle/KLSettingTogglePanelKml'
---@param parent UIKmlLuaControlHandler
function KLSettingTogglePanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLSettingTogglePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Setting/Panel/KLSettingToggle/KLSettingTogglePanel']

return KLSettingTogglePanelView
