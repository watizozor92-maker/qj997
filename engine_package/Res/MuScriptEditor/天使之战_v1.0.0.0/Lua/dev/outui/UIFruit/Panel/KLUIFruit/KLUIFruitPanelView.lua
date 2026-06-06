---@class KLUIFruitPanelView:UIKmlLuaViewBase
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1231 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field closeButton UIKmlLuaControlHandler
---@field HelpButton UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field Fruit UIKmlLuaControlHandler
---@field FruitBG UIKmlLuaControlHandler
---@field TextPintInfo UIKmlLuaControlHandler
---@field FruitAtt UIKmlLuaControlHandler
---@field FruitAttDataList UIKmlLuaControlHandler
---@field BtnReset UIKmlLuaControlHandler
---@field Bag UIKmlLuaControlHandler
---@field IconTitle UIKmlLuaControlHandler
---@field TextTitle UIKmlLuaControlHandler
---@field FruitList UIKmlLuaControlHandler
---@field gridview16 UIKmlLuaControlHandler
---@field FruitDataList UIKmlLuaControlHandler
---@field ResetPanel UIKmlLuaControlHandler
---@field ClickMask UIKmlLuaControlHandler
---@field ResetPanel_BG UIKmlLuaControlHandler
---@field CloseResetPanelBtn UIKmlLuaControlHandler
---@field ResetPanel_TextTitle1 UIKmlLuaControlHandler
---@field ResetPanel_TextTip UIKmlLuaControlHandler
---@field ResetPanel_TextTitle2 UIKmlLuaControlHandler
---@field ResetPanel_TextTip UIKmlLuaControlHandler
---@field ResetPanel_TextPoint UIKmlLuaControlHandler
---@field ResetPanel_Consum UIKmlLuaControlHandler
---@field text30 UIKmlLuaControlHandler
---@field img31 UIKmlLuaControlHandler
---@field Model UIKmlLuaControlHandler
---@field ConsumCount UIKmlLuaControlHandler
---@field ResetPanel_BtnCancel UIKmlLuaControlHandler
---@field ResetPanel_BtnReset UIKmlLuaControlHandler
---@field ResetPanel_TextResetTimes UIKmlLuaControlHandler
---@field ResetPanel_AttScrollview UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field AttDataList UIKmlLuaControlHandler
---@field IsOpenCalcUI UIKmlLuaControlHandler
---@field FeedBackImg UIKmlLuaControlHandler
local KLUIFruitPanelView = {}
setmetatable(KLUIFruitPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/UIFruit/Panel/KLUIFruit/KLUIFruitPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIFruitPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIFruitPanelView
