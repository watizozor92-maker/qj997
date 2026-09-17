---@class KLArchangelBreakthroughPanelView:UIKmlLuaViewBase
---@field panel1 UIKmlLuaControlHandler
---@field BG UIKmlLuaControlHandler
---@field noselect UIKmlLuaControlHandler
---@field StrengthCustomScrollView UIKmlLuaControlHandler
---@field gridview15 UIKmlLuaControlHandler
---@field cost_list UIKmlLuaControlHandler
---@field BreakthroughBtn UIKmlLuaControlHandler
---@field failTips UIKmlLuaControlHandler
---@field strengthIcon_1 UIKmlLuaControlHandler
---@field text11 UIKmlLuaControlHandler
---@field hidepanel UIKmlLuaControlHandler
---@field top_level UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field attrName UIKmlLuaControlHandler
---@field preValue UIKmlLuaControlHandler
---@field nextValue UIKmlLuaControlHandler
---@field arrow1 UIKmlLuaControlHandler
---@field strengthIcon UIKmlLuaControlHandler
---@field equipAttribute UIKmlLuaControlHandler
---@field BGInner_2 UIKmlLuaControlHandler
---@field strengthLevelBg UIKmlLuaControlHandler
---@field strengthIntro UIKmlLuaControlHandler
---@field preLevel UIKmlLuaControlHandler
---@field arrow UIKmlLuaControlHandler
---@field nextLevel UIKmlLuaControlHandler
---@field maxLevelTips UIKmlLuaControlHandler
---@field equipName UIKmlLuaControlHandler
---@field item_model UIKmlLuaControlHandler
---@field line_1 UIKmlLuaControlHandler
---@field line_2 UIKmlLuaControlHandler
---@field Title UIKmlLuaControlHandler
---@field noticeText UIKmlLuaControlHandler
---@field CloseButton UIKmlLuaControlHandler
---@field effectfail UIKmlLuaControlHandler
---@field effectSucceed UIKmlLuaControlHandler
---@field noselect_img UIKmlLuaControlHandler
---@field btn_tips UIKmlLuaControlHandler
local KLArchangelBreakthroughPanelView = {}
setmetatable(KLArchangelBreakthroughPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Panel/KLArchangelBreakthrough/KLArchangelBreakthroughPanelKml'
---@param parent UIKmlLuaControlHandler
function KLArchangelBreakthroughPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLArchangelBreakthroughPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Archangel/Panel/KLArchangelBreakthrough/KLArchangelBreakthroughPanel']

return KLArchangelBreakthroughPanelView
