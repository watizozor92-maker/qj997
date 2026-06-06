---@class KLHuntingDemonsRewardPanelView:UIKmlLuaViewBase
---@field img_36 UIKmlLuaControl
---@field RankList_Panel UIKmlLuaControl
---@field PlayerList UIKmlLuaControl
---@field PlayerDataList UIKmlLuaControl
---@field TimeBg UIKmlLuaControl
---@field TimeText UIKmlLuaControl
---@field MyRank UIKmlLuaControl
---@field MyRank_BG UIKmlLuaControl
---@field MyRank_RankIconBG UIKmlLuaControl
---@field MyRank_RankIcon UIKmlLuaControl
---@field MyRank_NoRank UIKmlLuaControl
---@field MyRank_HeadIcon UIKmlLuaControl
---@field MyRank_Name UIKmlLuaControl
---@field MyRank_UnionName UIKmlLuaControl
---@field MyRank_LV UIKmlLuaControl
---@field MyRank_RankText UIKmlLuaControl
---@field mid UIKmlLuaControl
---@field img2 UIKmlLuaControl
---@field text2 UIKmlLuaControl
---@field IntegralText UIKmlLuaControl
---@field tipsText UIKmlLuaControl
---@field text5 UIKmlLuaControl
---@field conversionText UIKmlLuaControl
---@field layout44 UIKmlLuaControl
---@field item5Img UIKmlLuaControl
---@field item5Text UIKmlLuaControl
---@field button_go UIKmlLuaControl
---@field NextIntegral UIKmlLuaControl
---@field img4 UIKmlLuaControl
---@field text6 UIKmlLuaControl
---@field NextIntegralText UIKmlLuaControl
---@field NextItemCountText UIKmlLuaControl
---@field img9 UIKmlLuaControl
---@field text10 UIKmlLuaControl
---@field HelpButton UIKmlLuaControl
---@field SeasonTimeText UIKmlLuaControl
---@field left UIKmlLuaControl
---@field img3 UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field Reward4Scrollview UIKmlLuaControl
---@field layout41 UIKmlLuaControl
---@field Reward4DataList UIKmlLuaControl
local KLHuntingDemonsRewardPanelView = {}
setmetatable(KLHuntingDemonsRewardPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/HuntingDemons/Panel/KLHuntingDemonsReward/KLHuntingDemonsRewardPanelKml'
---@param parent UIKmlLuaControl
function KLHuntingDemonsRewardPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLHuntingDemonsRewardPanelView
