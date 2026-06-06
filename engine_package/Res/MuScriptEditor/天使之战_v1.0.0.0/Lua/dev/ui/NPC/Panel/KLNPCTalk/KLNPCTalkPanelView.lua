---@class KLNPCTalkPanelView:UIKmlLuaViewBase
---@field bg1 UIKmlLuaControl
---@field bg UIKmlLuaControl
---@field ContentTxt UIKmlLuaControl
---@field cancelBtn UIKmlLuaControl
local KLNPCTalkPanelView = {}
setmetatable(KLNPCTalkPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/NPC/Panel/KLNPCTalk/KLNPCTalkPanelKml'
---@param parent UIKmlLuaControl
function KLNPCTalkPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLNPCTalkPanelView
