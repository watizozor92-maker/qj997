---@class KLReviveTipPanelView:UIKmlLuaViewBase
---@field KLReviveTip_Panel UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field informationText UIKmlLuaControlHandler
---@field LeftBtn UIKmlLuaControlHandler
---@field RightBtn UIKmlLuaControlHandler
local KLReviveTipPanelView = {}
setmetatable(KLReviveTipPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Revive/Panel/KLReviveTip/KLReviveTipPanelKml'
---@param parent UIKmlLuaControlHandler
function KLReviveTipPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLReviveTipPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Revive/Panel/KLReviveTip/KLReviveTipPanel']

return KLReviveTipPanelView
