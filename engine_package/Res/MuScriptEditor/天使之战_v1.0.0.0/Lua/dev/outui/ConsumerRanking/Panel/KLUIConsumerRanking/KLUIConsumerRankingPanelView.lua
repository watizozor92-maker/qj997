---@class KLUIConsumerRankingPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field NoRankListImg UIKmlLuaControlHandler
---@field RankList_Panel UIKmlLuaControlHandler
---@field PlayerList UIKmlLuaControlHandler
---@field PlayerDataList UIKmlLuaControlHandler
---@field TimeBg UIKmlLuaControlHandler
---@field refreshTime UIKmlLuaControlHandler
---@field RewardText UIKmlLuaControlHandler
---@field Role UIKmlLuaControlHandler
---@field mountModel UIKmlLuaControlHandler
---@field LockButton UIKmlLuaControlHandler
---@field left_root UIKmlLuaControlHandler
---@field player_block UIKmlLuaControlHandler
---@field player_title UIKmlLuaControlHandler
---@field user_name UIKmlLuaControlHandler
---@field xuwei UIKmlLuaControlHandler
---@field player_block UIKmlLuaControlHandler
---@field MyRank UIKmlLuaControlHandler
---@field MyRank_BG UIKmlLuaControlHandler
---@field MyRank_no UIKmlLuaControlHandler
---@field MyRank_Rank_title UIKmlLuaControlHandler
---@field MyRank_RankText UIKmlLuaControlHandler
---@field MyRank_money UIKmlLuaControlHandler
---@field closeEquipUIButton UIKmlLuaControlHandler
local KLUIConsumerRankingPanelView = {}
setmetatable(KLUIConsumerRankingPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ConsumerRanking/Panel/KLUIConsumerRanking/KLUIConsumerRankingPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIConsumerRankingPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIConsumerRankingPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ConsumerRanking/Panel/KLUIConsumerRanking/KLUIConsumerRankingPanel']

return KLUIConsumerRankingPanelView
