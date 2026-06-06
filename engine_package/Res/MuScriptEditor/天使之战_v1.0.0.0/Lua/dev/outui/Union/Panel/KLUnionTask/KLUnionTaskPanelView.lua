---@class KLUnionTaskPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field TitleImg UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field btnClose UIKmlLuaControlHandler
---@field taskScrollView UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field timeCounter UIKmlLuaControlHandler
---@field cut_area_up UIKmlLuaControlHandler
---@field cut_area_down UIKmlLuaControlHandler
local KLUnionTaskPanelView = {}
setmetatable(KLUnionTaskPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Union/Panel/KLUnionTask/KLUnionTaskPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUnionTaskPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUnionTaskPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Union/Panel/KLUnionTask/KLUnionTaskPanel']

return KLUnionTaskPanelView
