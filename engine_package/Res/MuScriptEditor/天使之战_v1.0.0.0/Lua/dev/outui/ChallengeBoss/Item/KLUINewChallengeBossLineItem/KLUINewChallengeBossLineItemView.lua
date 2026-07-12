---@class KLUINewChallengeBossLineItemView:UIKmlLuaViewBase
---@field btn UIKmlLuaControlHandler
---@field name UIKmlLuaControlHandler
---@field num UIKmlLuaControlHandler
---@field level UIKmlLuaControlHandler
---@field end_time UIKmlLuaControlHandler
---@field clickBtnMask UIKmlLuaControlHandler
local KLUINewChallengeBossLineItemView = {}
setmetatable(KLUINewChallengeBossLineItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLUINewChallengeBossLineItem/KLUINewChallengeBossLineItemKml'
---@param parent UIKmlLuaControlHandler
function KLUINewChallengeBossLineItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUINewChallengeBossLineItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ChallengeBoss/Item/KLUINewChallengeBossLineItem/KLUINewChallengeBossLineItem']

return KLUINewChallengeBossLineItemView
