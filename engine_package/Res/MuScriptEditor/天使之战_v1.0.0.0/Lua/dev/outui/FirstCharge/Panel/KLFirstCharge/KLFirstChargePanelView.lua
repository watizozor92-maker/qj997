---@class KLFirstChargePanelView:UIKmlLuaViewBase
---@field UIFirstChargePanel UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field btn_Close UIKmlLuaControlHandler
---@field font_ad UIKmlLuaControlHandler
---@field font_ad2 UIKmlLuaControlHandler
---@field font_ad3 UIKmlLuaControlHandler
---@field font_advertising UIKmlLuaControlHandler
---@field bg1 UIKmlLuaControlHandler
---@field Image1 UIKmlLuaControlHandler
---@field RebateText UIKmlLuaControlHandler
---@field model_image UIKmlLuaControlHandler
---@field Model_item UIKmlLuaControlHandler
---@field img_amount UIKmlLuaControlHandler
---@field number UIKmlLuaControlHandler
---@field panel_68 UIKmlLuaControlHandler
---@field img_text1 UIKmlLuaControlHandler
---@field img_text4 UIKmlLuaControlHandler
---@field img_70 UIKmlLuaControlHandler
---@field img_71 UIKmlLuaControlHandler
---@field img_72 UIKmlLuaControlHandler
---@field text_recharge_num UIKmlLuaControlHandler
---@field text_reward_num UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field btn_charge UIKmlLuaControlHandler
---@field GetText UIKmlLuaControlHandler
---@field ChargeText UIKmlLuaControlHandler
---@field hasReceive_text UIKmlLuaControlHandler
---@field btn_tips UIKmlLuaControlHandler
---@field bg_content UIKmlLuaControlHandler
---@field scrollviewItemList UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field list_item UIKmlLuaControlHandler
---@field Viewport UIKmlLuaControlHandler
---@field Text_accumulation UIKmlLuaControlHandler
---@field Text1 UIKmlLuaControlHandler
---@field Text_tips UIKmlLuaControlHandler
---@field Text11 UIKmlLuaControlHandler
---@field Imager11 UIKmlLuaControlHandler
---@field ToggleGroup UIKmlLuaControlHandler
---@field panel_day3 UIKmlLuaControlHandler
---@field panel_day2 UIKmlLuaControlHandler
---@field panel_day1 UIKmlLuaControlHandler
---@field togText_day1 UIKmlLuaControlHandler
---@field red1 UIKmlLuaControlHandler
---@field togText_day2 UIKmlLuaControlHandler
---@field red2 UIKmlLuaControlHandler
---@field togText_day3 UIKmlLuaControlHandler
---@field red3 UIKmlLuaControlHandler
---@field Text3 UIKmlLuaControlHandler
---@field ShowInfoText UIKmlLuaControlHandler
local KLFirstChargePanelView = {}
setmetatable(KLFirstChargePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/FirstCharge/Panel/KLFirstCharge/KLFirstChargePanelKml'
---@param parent UIKmlLuaControlHandler
function KLFirstChargePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end

---@type KLFirstChargePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/FirstCharge/Panel/KLFirstCharge/KLFirstChargePanel']

return KLFirstChargePanelView
