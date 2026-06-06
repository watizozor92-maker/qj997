---@class KLLuckyTurnTableItemView:UIKmlLuaViewBase
---@field BG UIKmlLuaControl
---@field Selected UIKmlLuaControl
---@field Point UIKmlLuaControl
---@field Count UIKmlLuaControl
---@field Flag UIKmlLuaControl
---@field reTimes UIKmlLuaControl
local KLLuckyTurnTableItemView = {}
setmetatable(KLLuckyTurnTableItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/OperateActivity/Item/KLLuckyTurnTable/KLLuckyTurnTableItemKml'
---@param parent UIKmlLuaControl
function KLLuckyTurnTableItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLLuckyTurnTableItemView
