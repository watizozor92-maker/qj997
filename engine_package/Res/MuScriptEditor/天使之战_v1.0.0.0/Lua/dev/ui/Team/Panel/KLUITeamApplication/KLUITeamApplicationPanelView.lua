---@class KLUITeamApplicationPanelView:UIKmlLuaViewBase
---@field panel_1259 UIKmlLuaControl
---@field img_1260 UIKmlLuaControl
---@field text_1261 UIKmlLuaControl
---@field text_1262 UIKmlLuaControl
---@field text_1263 UIKmlLuaControl
---@field text_1264 UIKmlLuaControl
---@field text_1265 UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field application_scrollview UIKmlLuaControl
---@field application_gridview UIKmlLuaControl
---@field application_datalist UIKmlLuaControl
---@field gridview1 UIKmlLuaControl
---@field agreebtn UIKmlLuaControl
---@field clearbtn UIKmlLuaControl
local KLUITeamApplicationPanelView = {}
setmetatable(KLUITeamApplicationPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Team/Panel/KLUITeamApplication/KLUITeamApplicationPanelKml'
---@param parent UIKmlLuaControl
function KLUITeamApplicationPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUITeamApplicationPanelView
