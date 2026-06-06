---@class KLUIRankListPanelView:UIKmlLuaViewBase
---@field mask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field CloseButton UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field LeftList UIKmlLuaControlHandler
---@field layout15 UIKmlLuaControlHandler
---@field LeftDataList UIKmlLuaControlHandler
---@field TitleToggleGroup UIKmlLuaControlHandler
---@field TitleToggleList UIKmlLuaControlHandler
---@field gridview26 UIKmlLuaControlHandler
---@field TitleDatalist UIKmlLuaControlHandler
---@field NoRankListImg UIKmlLuaControlHandler
---@field RankList_Panel UIKmlLuaControlHandler
---@field PlayerList UIKmlLuaControlHandler
---@field PlayerDataList UIKmlLuaControlHandler
---@field TimeBg UIKmlLuaControlHandler
---@field TimeText UIKmlLuaControlHandler
---@field RewardText UIKmlLuaControlHandler
---@field WorshipText UIKmlLuaControlHandler
---@field LockButton UIKmlLuaControlHandler
---@field WorshipButton UIKmlLuaControlHandler
---@field Role UIKmlLuaControlHandler
---@field mountModel UIKmlLuaControlHandler
---@field grailItem UIKmlLuaControlHandler
---@field MyRank UIKmlLuaControlHandler
---@field MyRank_BG UIKmlLuaControlHandler
---@field MyRank_RankText UIKmlLuaControlHandler
---@field MyRank_RankIconBG UIKmlLuaControlHandler
---@field MyRank_RankIcon UIKmlLuaControlHandler
---@field MyRank_NoRank UIKmlLuaControlHandler
---@field MyRank_HeadIcon UIKmlLuaControlHandler
---@field MyRank_Name UIKmlLuaControlHandler
---@field MyRank_UnionName UIKmlLuaControlHandler
---@field MyRank_LV UIKmlLuaControlHandler
---@field cut_area_up UIKmlLuaControlHandler
---@field closeEquipUIButton UIKmlLuaControlHandler
local KLUIRankListPanelView = {}
setmetatable(KLUIRankListPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/UIRankList/Panel/KLUIRankList/KLUIRankListPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIRankListPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIRankListPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/UIRankList/Panel/KLUIRankList/KLUIRankListPanel']

return KLUIRankListPanelView
