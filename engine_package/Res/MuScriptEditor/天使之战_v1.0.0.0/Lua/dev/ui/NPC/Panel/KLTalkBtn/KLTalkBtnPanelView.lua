---@class KLTalkBtnPanelView:UIKmlLuaViewBase
---@field TalkPanel UIKmlLuaControl
---@field TalkBtn UIKmlLuaControl
local KLTalkBtnPanelView = {}
setmetatable(KLTalkBtnPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/NPC/Panel/KLTalkBtn/KLTalkBtnPanelKml'
---@param parent UIKmlLuaControl
function KLTalkBtnPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLTalkBtnPanelView
