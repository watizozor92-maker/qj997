---@class KLTurnTableAwardItemView:UIKmlLuaViewBase
---@field Image UIKmlLuaControlHandler
---@field CountText UIKmlLuaControlHandler
---@field Icon UIKmlLuaControlHandler
---@field HaveGet UIKmlLuaControlHandler
---@field effect_tishi UIKmlLuaControlHandler
---@field GetButton UIKmlLuaControlHandler
---@field RedDot UIKmlLuaControlHandler
local KLTurnTableAwardItemView = {}
setmetatable(KLTurnTableAwardItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/OperateActivity/Item/KLTurnTableAward/KLTurnTableAwardItemKml'
---@param parent UIKmlLuaControlHandler
function KLTurnTableAwardItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLTurnTableAwardItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/OperateActivity/Item/KLTurnTableAward/KLTurnTableAwardItem']

return KLTurnTableAwardItemView
