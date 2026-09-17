---@class KLTurnTableGetAwardItemView:UIKmlLuaViewBase
---@field img1 UIKmlLuaControlHandler
---@field CountText UIKmlLuaControlHandler
---@field Icon UIKmlLuaControlHandler
---@field HaveGet UIKmlLuaControlHandler
---@field GetButton UIKmlLuaControlHandler
---@field RedDot UIKmlLuaControlHandler
local KLTurnTableGetAwardItemView = {}
setmetatable(KLTurnTableGetAwardItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/OperateActivity/Item/KLTurnTableGetAward/KLTurnTableGetAwardItemKml'
---@param parent UIKmlLuaControlHandler
function KLTurnTableGetAwardItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLTurnTableGetAwardItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/OperateActivity/Item/KLTurnTableGetAward/KLTurnTableGetAwardItem']

return KLTurnTableGetAwardItemView
