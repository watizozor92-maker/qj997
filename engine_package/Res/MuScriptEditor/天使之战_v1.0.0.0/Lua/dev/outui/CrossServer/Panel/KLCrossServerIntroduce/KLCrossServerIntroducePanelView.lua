---@class  KLCrossServerIntroducePanelView:UIKmlLuaViewBase
---@field root_panel UIKmlLuaControl
---@field trade_bg UIKmlLuaControl
---@field img_interface UIKmlLuaControl
---@field btn_close UIKmlLuaControl

local  KLCrossServerIntroducePanelView = {}
setmetatable( KLCrossServerIntroducePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/CrossServer/Panel/KLCrossServerIntroduce/KLCrossServerIntroducePanelKml'
 ---@param parent UIKmlLuaControl
function  KLCrossServerIntroducePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath, KLCrossServerIntroducePanelView.content)
end
return  KLCrossServerIntroducePanelView
