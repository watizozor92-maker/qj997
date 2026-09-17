---@class KLNoticeTextPanelView:UIKmlLuaViewBase
---@field noticeText UIKmlLuaControlHandler
---@field notice UIKmlLuaControlHandler
---@field tipMidContainer UIKmlLuaControlHandler
---@field noticeMidBg UIKmlLuaControlHandler
---@field tipTxt UIKmlLuaControlHandler
local KLNoticeTextPanelView = {}
setmetatable(KLNoticeTextPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Notice/Panel/KLNoticeText/KLNoticeTextPanelKml'
---@param parent UIKmlLuaControlHandler
function KLNoticeTextPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLNoticeTextPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Notice/Panel/KLNoticeText/KLNoticeTextPanel']

return KLNoticeTextPanelView
