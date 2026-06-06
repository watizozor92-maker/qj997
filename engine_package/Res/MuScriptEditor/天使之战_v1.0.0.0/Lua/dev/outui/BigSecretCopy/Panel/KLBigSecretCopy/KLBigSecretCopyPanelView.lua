---@class KLBigSecretCopyPanelView:UIKmlLuaViewBase
---@field challenge_boss_panel UIKmlLuaControlHandler
---@field btn_exit UIKmlLuaControlHandler
---@field trade_bg UIKmlLuaControlHandler
---@field img_interface UIKmlLuaControlHandler
---@field img_BigSecretCopy UIKmlLuaControlHandler
---@field btn_close UIKmlLuaControlHandler
---@field img_154 UIKmlLuaControlHandler
---@field dengji_img UIKmlLuaControlHandler
---@field dengji_title UIKmlLuaControlHandler
---@field level UIKmlLuaControlHandler
---@field fangyu_img UIKmlLuaControlHandler
---@field fangyu_title UIKmlLuaControlHandler
---@field fangyu UIKmlLuaControlHandler
---@field pingfen_img UIKmlLuaControlHandler
---@field pingfen_title UIKmlLuaControlHandler
---@field pingfen UIKmlLuaControlHandler
---@field pingfen_no UIKmlLuaControlHandler
---@field jiangli_img UIKmlLuaControlHandler
---@field jiangli_title UIKmlLuaControlHandler
---@field reward_scrollview UIKmlLuaControlHandler
---@field reward_gridview UIKmlLuaControlHandler
---@field reward_data_list UIKmlLuaControlHandler
---@field men_piao_img UIKmlLuaControlHandler
---@field men_piao_title UIKmlLuaControlHandler
---@field shengyu UIKmlLuaControlHandler
---@field last_num UIKmlLuaControlHandler
---@field piao_img UIKmlLuaControlHandler
---@field piao_num UIKmlLuaControlHandler
---@field men_piao_item UIKmlLuaControlHandler
---@field costBtn UIKmlLuaControlHandler
---@field reward_toggle UIKmlLuaControlHandler
---@field reward_toggle_text UIKmlLuaControlHandler
---@field btn_join UIKmlLuaControlHandler
---@field btn_sao_dang UIKmlLuaControlHandler
---@field jia_cheng_text UIKmlLuaControlHandler
local KLBigSecretCopyPanelView = {}
setmetatable(KLBigSecretCopyPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/BigSecretCopy/Panel/KLBigSecretCopy/KLBigSecretCopyPanelKml'
---@param parent UIKmlLuaControlHandler
function KLBigSecretCopyPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLBigSecretCopyPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/BigSecretCopy/Panel/KLBigSecretCopy/KLBigSecretCopyPanel']

return KLBigSecretCopyPanelView
