---@class KLUINearTeamPanelView:UIKmlLuaViewBase
---@field panel_116 UIKmlLuaControl
---@field img_117 UIKmlLuaControl
---@field text_118 UIKmlLuaControl
---@field text_119 UIKmlLuaControl
---@field text_120 UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field near_team_scrollview UIKmlLuaControl
---@field near_team_gridview UIKmlLuaControl
---@field near_team_datalist UIKmlLuaControl
local KLUINearTeamPanelView = {}
setmetatable(KLUINearTeamPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Team/Panel/KLUINearTeam/KLUINearTeamPanelKml'
---@param parent UIKmlLuaControl
function KLUINearTeamPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUINearTeamPanelView
