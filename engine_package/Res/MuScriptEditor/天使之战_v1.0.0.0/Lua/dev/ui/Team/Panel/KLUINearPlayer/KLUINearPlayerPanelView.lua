---@class KLUINearPlayerPanelView:UIKmlLuaViewBase
---@field panel_1228 UIKmlLuaControl
---@field img_1229 UIKmlLuaControl
---@field text_1230 UIKmlLuaControl
---@field text_1231 UIKmlLuaControl
---@field text_1232 UIKmlLuaControl
---@field text1 UIKmlLuaControl
---@field text_1233 UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field near_player_scrollview UIKmlLuaControl
---@field near_player_gridview UIKmlLuaControl
---@field near_player_datalist UIKmlLuaControl
local KLUINearPlayerPanelView = {}
setmetatable(KLUINearPlayerPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Team/Panel/KLUINearPlayer/KLUINearPlayerPanelKml'
---@param parent UIKmlLuaControl
function KLUINearPlayerPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUINearPlayerPanelView
