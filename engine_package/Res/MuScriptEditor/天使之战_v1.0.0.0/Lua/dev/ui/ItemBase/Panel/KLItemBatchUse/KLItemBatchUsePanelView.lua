---@class KLItemBatchUsePanelView:UIKmlLuaViewBase
---@field KmlItemBatchUseUI UIKmlLuaControlHandler
---@field InputFieldNum UIKmlLuaControlHandler
---@field Item UIKmlLuaControlHandler
---@field BtnCancel UIKmlLuaControlHandler
---@field BtnSure UIKmlLuaControlHandler
---@field BtnCountMinus UIKmlLuaControlHandler
---@field BtnCountAdd UIKmlLuaControlHandler
---@field panel1 UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field panel6 UIKmlLuaControlHandler
---@field text7 UIKmlLuaControlHandler
local KLItemBatchUsePanelView = {}
setmetatable(KLItemBatchUsePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/ItemBase/Panel/KLItemBatchUse/KLItemBatchUsePanelKml'
---@param parent UIKmlLuaControlHandler
function KLItemBatchUsePanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLItemBatchUsePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/ItemBase/Panel/KLItemBatchUse/KLItemBatchUsePanel']

return KLItemBatchUsePanelView
