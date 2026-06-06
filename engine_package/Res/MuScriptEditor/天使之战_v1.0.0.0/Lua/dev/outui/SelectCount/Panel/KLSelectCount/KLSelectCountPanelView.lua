---@class KLSelectCountPanelView:UIKmlLuaViewBase
---@field Select_Mask UIKmlLuaControl
---@field SelcetCount_bg UIKmlLuaControl
---@field showitem UIKmlLuaControl
---@field Count UIKmlLuaControl
---@field subtract UIKmlLuaControl
---@field add UIKmlLuaControl
---@field BtnCancel UIKmlLuaControl
---@field BtnSure UIKmlLuaControl
---@field title UIKmlLuaControl
local KLSelectCountPanelView = {}
setmetatable(KLSelectCountPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/SelectCount/Panel/KLSelectCount/KLSelectCountPanelKml'
---@param parent UIKmlLuaControl
function KLSelectCountPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLSelectCountPanelView
