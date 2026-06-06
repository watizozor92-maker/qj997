---@class KLNPCPhantomMentorPanelView:UIKmlLuaViewBase
---@field bg1 UIKmlLuaControlHandler
---@field cancelBtn UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field TitleName UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field leftPanel UIKmlLuaControlHandler
---@field leftText1 UIKmlLuaControlHandler
---@field leftText2 UIKmlLuaControlHandler
---@field leftText3 UIKmlLuaControlHandler
---@field leftBtn UIKmlLuaControlHandler
---@field rightPanel UIKmlLuaControlHandler
---@field rightText1 UIKmlLuaControlHandler
---@field rightText2 UIKmlLuaControlHandler
---@field rightText3 UIKmlLuaControlHandler
---@field rightBtn UIKmlLuaControlHandler
---@field rightBtn2 UIKmlLuaControlHandler
---@field rightText4 UIKmlLuaControlHandler
local KLNPCPhantomMentorPanelView = {}
setmetatable(KLNPCPhantomMentorPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/NPC/Panel/KLNPCPhantomMentor/KLNPCPhantomMentorPanelKml'
---@param parent UIKmlLuaControlHandler
function KLNPCPhantomMentorPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLNPCPhantomMentorPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/NPC/Panel/KLNPCPhantomMentor/KLNPCPhantomMentorPanel']

return KLNPCPhantomMentorPanelView
