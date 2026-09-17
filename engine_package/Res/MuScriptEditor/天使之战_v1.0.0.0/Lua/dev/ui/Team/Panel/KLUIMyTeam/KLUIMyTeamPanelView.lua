---@class KLUIMyTeamPanelView:UIKmlLuaViewBase
---@field team_scrollview UIKmlLuaControlHandler
---@field team_gridview UIKmlLuaControlHandler
---@field team_datalist UIKmlLuaControlHandler
---@field closeGridviewButton UIKmlLuaControlHandler
---@field panel_25 UIKmlLuaControlHandler
---@field createteambtn UIKmlLuaControlHandler
---@field leaveteambtn UIKmlLuaControlHandler
---@field Activity_Title UIKmlLuaControlHandler
---@field Activity_Button2 UIKmlLuaControlHandler
---@field Activity_Text UIKmlLuaControlHandler
---@field Activity_Button UIKmlLuaControlHandler
---@field Activity_Gridview UIKmlLuaControlHandler
---@field ActivityDataList UIKmlLuaControlHandler
---@field TeamLv_Title UIKmlLuaControlHandler
---@field TeamLv_Button2 UIKmlLuaControlHandler
---@field TeamLv_Text UIKmlLuaControlHandler
---@field TeamLv_Button UIKmlLuaControlHandler
---@field TeamLv_Gridview UIKmlLuaControlHandler
---@field TeamLvDataList UIKmlLuaControlHandler
---@field ShoutingButton UIKmlLuaControlHandler
---@field des_btn UIKmlLuaControlHandler
---@field des_btn_text UIKmlLuaControlHandler
local KLUIMyTeamPanelView = {}
setmetatable(KLUIMyTeamPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Team/Panel/KLUIMyTeam/KLUIMyTeamPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIMyTeamPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIMyTeamPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Team/Panel/KLUIMyTeam/KLUIMyTeamPanel']

return KLUIMyTeamPanelView
