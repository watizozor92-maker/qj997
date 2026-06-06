---@class KLOnHookPanelView:UIKmlLuaViewBase
---@field mask UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img_367 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field text12 UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field btnSetting UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field TempRoot UIKmlLuaControlHandler
---@field root_hookPoints UIKmlLuaControlHandler
---@field root_hookInfos UIKmlLuaControlHandler
---@field toggleGroupTop UIKmlLuaControlHandler
---@field HookPointToggle UIKmlLuaControlHandler
---@field txt2 UIKmlLuaControlHandler
---@field HookInfoToggle UIKmlLuaControlHandler
---@field txt3 UIKmlLuaControlHandler
---@field txt_monthCard UIKmlLuaControlHandler
---@field btn_monthCard UIKmlLuaControlHandler
---@field img_red UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field img_green UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
local KLOnHookPanelView = {}
setmetatable(KLOnHookPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Hook/Panel/KLOnHook/KLOnHookPanelKml'
---@param parent UIKmlLuaControlHandler
function KLOnHookPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLOnHookPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel']

return KLOnHookPanelView
