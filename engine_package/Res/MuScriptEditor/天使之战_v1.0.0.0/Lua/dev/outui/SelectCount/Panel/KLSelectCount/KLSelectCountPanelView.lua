---@class KLSelectCountPanelView:UIKmlLuaViewBase
---@field Select_Mask UIKmlLuaControlHandler
---@field SelcetCount_bg UIKmlLuaControlHandler
---@field showitem UIKmlLuaControlHandler
---@field Count UIKmlLuaControlHandler
---@field subtract UIKmlLuaControlHandler
---@field add UIKmlLuaControlHandler
---@field BtnCancel UIKmlLuaControlHandler
---@field BtnSure UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
local KLSelectCountPanelView = {}
setmetatable(KLSelectCountPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/SelectCount/Panel/KLSelectCount/KLSelectCountPanelKml'
---@param parent UIKmlLuaControlHandler
function KLSelectCountPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLSelectCountPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/SelectCount/Panel/KLSelectCount/KLSelectCountPanel']

return KLSelectCountPanelView
