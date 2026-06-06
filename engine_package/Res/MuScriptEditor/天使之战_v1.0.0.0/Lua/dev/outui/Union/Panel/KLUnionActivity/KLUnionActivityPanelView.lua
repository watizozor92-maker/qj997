---@class KLUnionActivityPanelView:UIKmlLuaViewBase
---@field BackGround UIKmlLuaControlHandler
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field Text1 UIKmlLuaControlHandler
---@field BtnClose UIKmlLuaControlHandler
---@field scrollview UIKmlLuaControlHandler
---@field layout3 UIKmlLuaControlHandler
---@field TitleImg UIKmlLuaControlHandler
local KLUnionActivityPanelView = {}
setmetatable(KLUnionActivityPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Union/Panel/KLUnionActivity/KLUnionActivityPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUnionActivityPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUnionActivityPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Union/Panel/KLUnionActivity/KLUnionActivityPanel']

return KLUnionActivityPanelView
