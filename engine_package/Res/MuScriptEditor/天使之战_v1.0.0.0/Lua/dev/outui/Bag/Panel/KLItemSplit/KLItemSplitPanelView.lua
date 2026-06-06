---@class KLItemSplitPanelView:UIKmlLuaViewBase
---@field img4 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field text6 UIKmlLuaControlHandler
---@field current_num UIKmlLuaControlHandler
---@field text10 UIKmlLuaControlHandler
---@field input_num UIKmlLuaControlHandler
---@field sureBtn UIKmlLuaControlHandler
---@field cancelBtn UIKmlLuaControlHandler
---@field slider UIKmlLuaControlHandler
---@field fillArea_attach UIKmlLuaControlHandler
---@field fill_attach UIKmlLuaControlHandler
---@field fillArea_attach UIKmlLuaControlHandler
---@field handle_attach UIKmlLuaControlHandler
---@field close_btn UIKmlLuaControlHandler
---@field text7 UIKmlLuaControlHandler
local KLItemSplitPanelView = {}
setmetatable(KLItemSplitPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Bag/Panel/KLItemSplit/KLItemSplitPanelKml'
---@param parent UIKmlLuaControlHandler
function KLItemSplitPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLItemSplitPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Bag/Panel/KLItemSplit/KLItemSplitPanel']

return KLItemSplitPanelView
