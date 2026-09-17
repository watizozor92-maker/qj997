---@class KLUITeamApplicationPanelView:UIKmlLuaViewBase
---@field panel_1259 UIKmlLuaControlHandler
---@field img_1260 UIKmlLuaControlHandler
---@field text_1261 UIKmlLuaControlHandler
---@field text_1262 UIKmlLuaControlHandler
---@field text_1263 UIKmlLuaControlHandler
---@field text_1264 UIKmlLuaControlHandler
---@field text_1265 UIKmlLuaControlHandler
---@field application_scrollview UIKmlLuaControlHandler
---@field application_gridview UIKmlLuaControlHandler
---@field application_datalist UIKmlLuaControlHandler
---@field gridview1 UIKmlLuaControlHandler
---@field agreebtn UIKmlLuaControlHandler
---@field clearbtn UIKmlLuaControlHandler
local KLUITeamApplicationPanelView = {}
setmetatable(KLUITeamApplicationPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Team/Panel/KLUITeamApplication/KLUITeamApplicationPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUITeamApplicationPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUITeamApplicationPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Team/Panel/KLUITeamApplication/KLUITeamApplicationPanel']

return KLUITeamApplicationPanelView
