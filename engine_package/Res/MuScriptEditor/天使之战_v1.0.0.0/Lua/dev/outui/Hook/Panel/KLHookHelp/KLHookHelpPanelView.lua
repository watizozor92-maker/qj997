---@class KLHookHelpPanelView:UIKmlLuaViewBase
---@field mask UIKmlLuaControlHandler
---@field maskReckNode UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img_367 UIKmlLuaControlHandler
---@field img12 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field Bg UIKmlLuaControlHandler
---@field btn_save UIKmlLuaControlHandler
---@field btn_cancel UIKmlLuaControlHandler
---@field frame UIKmlLuaControlHandler
---@field TempRoot UIKmlLuaControlHandler
---@field toggleGroupTop UIKmlLuaControlHandler
---@field layout1 UIKmlLuaControlHandler
---@field KillMonsterToggle UIKmlLuaControlHandler
---@field txt2 UIKmlLuaControlHandler
---@field PickUpToggle UIKmlLuaControlHandler
---@field txt3 UIKmlLuaControlHandler
local KLHookHelpPanelView = {}
setmetatable(KLHookHelpPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Hook/Panel/KLHookHelp/KLHookHelpPanelKml'
---@param parent UIKmlLuaControlHandler
function KLHookHelpPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLHookHelpPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Hook/Panel/KLHookHelp/KLHookHelpPanel']

return KLHookHelpPanelView
