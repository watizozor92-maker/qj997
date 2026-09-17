---@class KLUINearTeamPanelView:UIKmlLuaViewBase
---@field panel_116 UIKmlLuaControlHandler
---@field img_117 UIKmlLuaControlHandler
---@field text_118 UIKmlLuaControlHandler
---@field text_119 UIKmlLuaControlHandler
---@field text_120 UIKmlLuaControlHandler
---@field near_team_scrollview UIKmlLuaControlHandler
---@field near_team_gridview UIKmlLuaControlHandler
---@field near_team_datalist UIKmlLuaControlHandler
local KLUINearTeamPanelView = {}
setmetatable(KLUINearTeamPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Team/Panel/KLUINearTeam/KLUINearTeamPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUINearTeamPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUINearTeamPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Team/Panel/KLUINearTeam/KLUINearTeamPanel']

return KLUINearTeamPanelView
