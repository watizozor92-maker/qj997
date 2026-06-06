---@class KLTurnTableGetAwardItemView:UIKmlLuaViewBase
---@field img1 UIKmlLuaControl
---@field CountText UIKmlLuaControl
---@field Icon UIKmlLuaControl
---@field HaveGet UIKmlLuaControl
---@field GetButton UIKmlLuaControl
---@field RedDot UIKmlLuaControl
local KLTurnTableGetAwardItemView = {}
setmetatable(KLTurnTableGetAwardItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/OperateActivity/Item/KLTurnTableGetAward/KLTurnTableGetAwardItemKml'
---@param parent UIKmlLuaControl
function KLTurnTableGetAwardItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLTurnTableGetAwardItemView
