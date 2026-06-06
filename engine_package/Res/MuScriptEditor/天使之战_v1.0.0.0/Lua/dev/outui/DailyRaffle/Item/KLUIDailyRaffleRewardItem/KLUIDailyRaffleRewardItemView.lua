---@class KLUIDailyRaffleRewardItemView:UIKmlLuaViewBase
---@field equip_item UIKmlLuaControl
---@field arrow UIKmlLuaControl
---@field btn UIKmlLuaControl
local KLUIDailyRaffleRewardItemView = {}
setmetatable(KLUIDailyRaffleRewardItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/DailyRaffle/Item/KLUIDailyRaffleRewardItem/KLUIDailyRaffleRewardItemKml'
---@param parent UIKmlLuaControl
function KLUIDailyRaffleRewardItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIDailyRaffleRewardItemView
