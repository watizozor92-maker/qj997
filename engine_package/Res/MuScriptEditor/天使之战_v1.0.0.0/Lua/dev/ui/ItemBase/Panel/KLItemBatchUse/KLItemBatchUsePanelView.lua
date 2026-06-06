---@class KLItemBatchUsePanelView:UIKmlLuaViewBase
---@field KmlItemBatchUseUI UIKmlLuaControl
---@field InputFieldNum UIKmlLuaControl
---@field Item UIKmlLuaControl
---@field BtnCancel UIKmlLuaControl
---@field BtnSure UIKmlLuaControl
---@field BtnCountMinus UIKmlLuaControl
---@field BtnCountAdd UIKmlLuaControl
---@field panel1 UIKmlLuaControl
---@field img4 UIKmlLuaControl
---@field img5 UIKmlLuaControl
---@field panel6 UIKmlLuaControl
---@field text7 UIKmlLuaControl
local KLItemBatchUsePanelView = {}
setmetatable(KLItemBatchUsePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/ItemBase/Panel/KLItemBatchUse/KLItemBatchUsePanelKml'
---@param parent UIKmlLuaControl
function KLItemBatchUsePanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLItemBatchUsePanelView
