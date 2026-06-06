---@class KLCrossServerPanelView:UIKmlLuaViewBase
---@field root_panel UIKmlLuaControl
---@field mask UIKmlLuaControl
---@field trade_bg UIKmlLuaControl
---@field btn_close UIKmlLuaControl
---@field img_16 UIKmlLuaControl
---@field boss_type_toggle_group UIKmlLuaControl
---@field butten_layout UIKmlLuaControl
---@field type_1 UIKmlLuaControl
---@field type_1_toggle UIKmlLuaControl
---@field text_21 UIKmlLuaControl
---@field activity_panel UIKmlLuaControl
---@field activity_panel_select UIKmlLuaControl
---@field activity_panel_layout UIKmlLuaControl
---@field activity_panel_dl UIKmlLuaControl
---@field desBtn UIKmlLuaControl
local  KLCrossServerPanellView = {}
setmetatable( KLCrossServerPanellView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/CrossServer/Panel/KLCrossServerMain/KLCrossServerPanelKml'
 KLCrossServerPanellView.content = CS.TCFramework.LuaManager.LoadFileText(kmlPath,nil,'.txt')
---@param parent UIKmlLuaControl
function  KLCrossServerPanellView:Init(parent)
    
    self:InitRoot(parent,kmlPath, KLCrossServerPanellView.content)
end
return  KLCrossServerPanellView
