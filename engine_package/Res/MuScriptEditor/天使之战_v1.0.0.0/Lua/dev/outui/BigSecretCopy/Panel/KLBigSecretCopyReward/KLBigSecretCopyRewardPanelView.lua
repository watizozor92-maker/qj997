---@class KLBigSecretCopyRewardPanelView:UIKmlLuaViewBase
---@field mask_bg UIKmlLuaControlHandler
---@field reward_panel UIKmlLuaControlHandler
---@field trade_bg UIKmlLuaControlHandler
---@field img_185 UIKmlLuaControlHandler
---@field dengji_img UIKmlLuaControlHandler
---@field dengji_title UIKmlLuaControlHandler
---@field level UIKmlLuaControlHandler
---@field shichang_img UIKmlLuaControlHandler
---@field shichang_title UIKmlLuaControlHandler
---@field shichang UIKmlLuaControlHandler
---@field pingfen_img UIKmlLuaControlHandler
---@field pingfen_title UIKmlLuaControlHandler
---@field pingfen UIKmlLuaControlHandler
---@field jiangli_img UIKmlLuaControlHandler
---@field jiangli_title UIKmlLuaControlHandler
---@field jiangli_count UIKmlLuaControlHandler
---@field reward_scrollview UIKmlLuaControlHandler
---@field reward_gridview UIKmlLuaControlHandler
---@field reward_data_list UIKmlLuaControlHandler
---@field tishi UIKmlLuaControlHandler
---@field btn_no UIKmlLuaControlHandler
---@field btn_no_countdown UIKmlLuaControlHandler
---@field btn_yes UIKmlLuaControlHandler
---@field btn_yes_countdown UIKmlLuaControlHandler
---@field level_up_panel UIKmlLuaControlHandler
---@field bgImg UIKmlLuaControlHandler
---@field img_title UIKmlLuaControlHandler
---@field txt_title UIKmlLuaControlHandler
---@field tips_closeBtn UIKmlLuaControlHandler
---@field tipsContent UIKmlLuaControlHandler
---@field btn_cancel UIKmlLuaControlHandler
---@field btn_cancel_countdown UIKmlLuaControlHandler
---@field btn_sure UIKmlLuaControlHandler
---@field btn_sure_countdown UIKmlLuaControlHandler
local KLBigSecretCopyRewardPanelView = {}
setmetatable(KLBigSecretCopyRewardPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/BigSecretCopy/Panel/KLBigSecretCopyReward/KLBigSecretCopyRewardPanelKml'
---@param parent UIKmlLuaControlHandler
function KLBigSecretCopyRewardPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLBigSecretCopyRewardPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/BigSecretCopy/Panel/KLBigSecretCopyReward/KLBigSecretCopyRewardPanel']

return KLBigSecretCopyRewardPanelView
