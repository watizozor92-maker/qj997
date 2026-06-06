---@class KLArchangelBreakthroughPanelView:UIKmlLuaViewBase
---@field panel1 UIKmlLuaControl
---@field BG UIKmlLuaControl
---@field noselect UIKmlLuaControl
---@field StrengthCustomScrollView UIKmlLuaControl
---@field gridview15 UIKmlLuaControl
---@field cost_list UIKmlLuaControl
---@field BreakthroughBtn UIKmlLuaControl
---@field failTips UIKmlLuaControl
---@field strengthIcon_1 UIKmlLuaControl
---@field text11 UIKmlLuaControl
---@field hidepanel UIKmlLuaControl
---@field top_level UIKmlLuaControl
---@field bg UIKmlLuaControl
---@field attrName UIKmlLuaControl
---@field preValue UIKmlLuaControl
---@field nextValue UIKmlLuaControl
---@field arrow1 UIKmlLuaControl
---@field strengthIcon UIKmlLuaControl
---@field equipAttribute UIKmlLuaControl
---@field BGInner_2 UIKmlLuaControl
---@field strengthLevelBg UIKmlLuaControl
---@field strengthIntro UIKmlLuaControl
---@field preLevel UIKmlLuaControl
---@field arrow UIKmlLuaControl
---@field nextLevel UIKmlLuaControl
---@field maxLevelTips UIKmlLuaControl
---@field equipName UIKmlLuaControl
---@field item_model UIKmlLuaControl
---@field line_1 UIKmlLuaControl
---@field line_2 UIKmlLuaControl
---@field Title UIKmlLuaControl
---@field noticeText UIKmlLuaControl
---@field CloseButton UIKmlLuaControl
---@field effectfail UIKmlLuaControl
---@field effectSucceed UIKmlLuaControl
---@field noselect_img UIKmlLuaControl
---@field btn_tips UIKmlLuaControl
local KLArchangelBreakthroughPanelView = {}
setmetatable(KLArchangelBreakthroughPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Panel/KLArchangelBreakthrough/KLArchangelBreakthroughPanelKml'
---@param parent UIKmlLuaControl
function KLArchangelBreakthroughPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLArchangelBreakthroughPanelView
