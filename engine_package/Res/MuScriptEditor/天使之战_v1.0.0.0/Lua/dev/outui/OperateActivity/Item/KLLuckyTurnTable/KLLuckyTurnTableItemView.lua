---@class KLLuckyTurnTableItemView:UIKmlLuaViewBase
---@field BG UIKmlLuaControlHandler
---@field Selected UIKmlLuaControlHandler
---@field Point UIKmlLuaControlHandler
---@field Count UIKmlLuaControlHandler
---@field Flag UIKmlLuaControlHandler
---@field reTimes UIKmlLuaControlHandler
local KLLuckyTurnTableItemView = {}
setmetatable(KLLuckyTurnTableItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/OperateActivity/Item/KLLuckyTurnTable/KLLuckyTurnTableItemKml'
---@param parent UIKmlLuaControlHandler
function KLLuckyTurnTableItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLLuckyTurnTableItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/OperateActivity/Item/KLLuckyTurnTable/KLLuckyTurnTableItem']

return KLLuckyTurnTableItemView
