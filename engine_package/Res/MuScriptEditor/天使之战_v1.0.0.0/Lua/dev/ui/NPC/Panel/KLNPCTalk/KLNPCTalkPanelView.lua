---@class KLNPCTalkPanelView:UIKmlLuaViewBase
---@field bg1 UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field ContentTxt UIKmlLuaControlHandler
---@field cancelBtn UIKmlLuaControlHandler
local KLNPCTalkPanelView = {}
setmetatable(KLNPCTalkPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/NPC/Panel/KLNPCTalk/KLNPCTalkPanelKml'
---@param parent UIKmlLuaControlHandler
function KLNPCTalkPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLNPCTalkPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/NPC/Panel/KLNPCTalk/KLNPCTalkPanel']

return KLNPCTalkPanelView
