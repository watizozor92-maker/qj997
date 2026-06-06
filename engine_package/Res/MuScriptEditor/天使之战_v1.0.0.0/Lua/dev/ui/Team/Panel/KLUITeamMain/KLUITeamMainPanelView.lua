---@class KLUITeamMainPanelView:UIKmlLuaViewBase
---@field mask UIKmlLuaControlHandler
---@field img_75 UIKmlLuaControlHandler
---@field img_76 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field img_77 UIKmlLuaControlHandler
---@field img_78 UIKmlLuaControlHandler
---@field toggle_team UIKmlLuaControlHandler
---@field layout1 UIKmlLuaControlHandler
---@field my_team UIKmlLuaControlHandler
---@field text_82 UIKmlLuaControlHandler
---@field near_team UIKmlLuaControlHandler
---@field text_84 UIKmlLuaControlHandler
---@field near_player UIKmlLuaControlHandler
---@field text_86 UIKmlLuaControlHandler
---@field my_friend UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field my_union UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field request_list UIKmlLuaControlHandler
---@field text_88 UIKmlLuaControlHandler
---@field FG_line UIKmlLuaControlHandler
---@field HelpButton UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field TipsTxt UIKmlLuaControlHandler
local KLUITeamMainPanelView = {}
setmetatable(KLUITeamMainPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUITeamMainPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUITeamMainPanelView
