---@class KLUINearPlayerPanelView:UIKmlLuaViewBase
---@field panel_1228 UIKmlLuaControlHandler
---@field img_1229 UIKmlLuaControlHandler
---@field text_1230 UIKmlLuaControlHandler
---@field text_1231 UIKmlLuaControlHandler
---@field text_1232 UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field text_1233 UIKmlLuaControlHandler
---@field near_player_scrollview UIKmlLuaControlHandler
---@field near_player_gridview UIKmlLuaControlHandler
---@field near_player_datalist UIKmlLuaControlHandler
local KLUINearPlayerPanelView = {}
setmetatable(KLUINearPlayerPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Team/Panel/KLUINearPlayer/KLUINearPlayerPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUINearPlayerPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUINearPlayerPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Team/Panel/KLUINearPlayer/KLUINearPlayerPanel']

return KLUINearPlayerPanelView
