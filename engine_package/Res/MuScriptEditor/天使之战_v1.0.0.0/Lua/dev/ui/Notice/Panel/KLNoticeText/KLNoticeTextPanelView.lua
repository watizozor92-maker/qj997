---@class KLNoticeTextPanelView:UIKmlLuaViewBase
---@field noticeText UIKmlLuaControl
---@field notice UIKmlLuaControl
---@field tipMidContainer UIKmlLuaControl
---@field noticeMidBg UIKmlLuaControl
---@field tipTxt UIKmlLuaControl
local KLNoticeTextPanelView = {}
setmetatable(KLNoticeTextPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Notice/Panel/KLNoticeText/KLNoticeTextPanelKml'
---@param parent UIKmlLuaControl
function KLNoticeTextPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLNoticeTextPanelView
