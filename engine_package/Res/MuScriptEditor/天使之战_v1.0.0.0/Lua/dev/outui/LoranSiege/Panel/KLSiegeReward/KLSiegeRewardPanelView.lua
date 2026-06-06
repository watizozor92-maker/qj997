---@class KLSiegeRewardPanelView:UIKmlLuaViewBase
---@field img_33 UIKmlLuaControlHandler
---@field title_txt UIKmlLuaControlHandler
---@field btn_close UIKmlLuaControlHandler
---@field img_36 UIKmlLuaControlHandler
---@field img_36 UIKmlLuaControlHandler
---@field line1 UIKmlLuaControlHandler
---@field line2 UIKmlLuaControlHandler
---@field left UIKmlLuaControlHandler
---@field scrollview1 UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field title1 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field LeftInfo1 UIKmlLuaControlHandler
---@field LeftInfoText1 UIKmlLuaControlHandler
---@field title2 UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field text8 UIKmlLuaControlHandler
---@field LeftInfo2 UIKmlLuaControlHandler
---@field LeftInfoText2 UIKmlLuaControlHandler
---@field title3 UIKmlLuaControlHandler
---@field img12 UIKmlLuaControlHandler
---@field text13 UIKmlLuaControlHandler
---@field LeftInfo3 UIKmlLuaControlHandler
---@field LeftInfoText3 UIKmlLuaControlHandler
---@field title4 UIKmlLuaControlHandler
---@field img8 UIKmlLuaControlHandler
---@field text9 UIKmlLuaControlHandler
---@field LeftInfo4 UIKmlLuaControlHandler
---@field LeftInfoText4 UIKmlLuaControlHandler
---@field title_bg_1 UIKmlLuaControlHandler
---@field LeftTitleIcon UIKmlLuaControlHandler
---@field LeftTitleText UIKmlLuaControlHandler
---@field mid UIKmlLuaControlHandler
---@field title_bg_mid UIKmlLuaControlHandler
---@field MidTitleIcon UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
---@field scrollview4 UIKmlLuaControlHandler
---@field layout5 UIKmlLuaControlHandler
---@field panel1 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field layout7 UIKmlLuaControlHandler
---@field text10 UIKmlLuaControlHandler
---@field Reward1 UIKmlLuaControlHandler
---@field Reward1Scrollview UIKmlLuaControlHandler
---@field layout21 UIKmlLuaControlHandler
---@field Reward1DataList UIKmlLuaControlHandler
---@field layout36 UIKmlLuaControlHandler
---@field text37 UIKmlLuaControlHandler
---@field Reward2 UIKmlLuaControlHandler
---@field Reward2Scrollview UIKmlLuaControlHandler
---@field layout40 UIKmlLuaControlHandler
---@field Reward2DataList UIKmlLuaControlHandler
---@field panel11 UIKmlLuaControlHandler
---@field img14 UIKmlLuaControlHandler
---@field text15 UIKmlLuaControlHandler
---@field layout18 UIKmlLuaControlHandler
---@field text19 UIKmlLuaControlHandler
---@field Reward3 UIKmlLuaControlHandler
---@field Reward3Scrollview UIKmlLuaControlHandler
---@field layout46 UIKmlLuaControlHandler
---@field Reward3DataList UIKmlLuaControlHandler
---@field right UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field text5 UIKmlLuaControlHandler
---@field panel9 UIKmlLuaControlHandler
---@field img10 UIKmlLuaControlHandler
---@field text11 UIKmlLuaControlHandler
---@field Reward4Scrollview UIKmlLuaControlHandler
---@field layout41 UIKmlLuaControlHandler
---@field Reward4DataList UIKmlLuaControlHandler
local KLSiegeRewardPanelView = {}
setmetatable(KLSiegeRewardPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/LoranSiege/Panel/KLSiegeReward/KLSiegeRewardPanelKml'
---@param parent UIKmlLuaControlHandler
function KLSiegeRewardPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLSiegeRewardPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/LoranSiege/Panel/KLSiegeReward/KLSiegeRewardPanel']

return KLSiegeRewardPanelView
