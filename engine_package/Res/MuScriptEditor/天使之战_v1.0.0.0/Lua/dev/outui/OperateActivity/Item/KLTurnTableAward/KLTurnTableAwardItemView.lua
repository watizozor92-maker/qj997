---@class KLTurnTableAwardItemView:UIKmlLuaViewBase
---@field Image UIKmlLuaControl
---@field CountText UIKmlLuaControl
---@field Icon UIKmlLuaControl
---@field HaveGet UIKmlLuaControl
---@field GetButton UIKmlLuaControl
---@field RedDot UIKmlLuaControl
---@field effect_tishi UIKmlLuaControl
local KLTurnTableAwardItemView = {}
setmetatable(KLTurnTableAwardItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/OperateActivity/Item/KLTurnTableAward/KLTurnTableAwardItemKml'
---@param parent UIKmlLuaControl
function KLTurnTableAwardItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLTurnTableAwardItemView
