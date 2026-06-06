---@class KLFaceTradePanelView:UIKmlLuaViewBase
---@field RaycastBg UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field BgBag UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field btn_close UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field scrollview1 UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field bg_bagScroll UIKmlLuaControlHandler
---@field btn_ownGold1 UIKmlLuaControlHandler
---@field icon_ownGold1 UIKmlLuaControlHandler
---@field txt_ownGold1 UIKmlLuaControlHandler
---@field btn_ownGold2 UIKmlLuaControlHandler
---@field icon_ownGold2 UIKmlLuaControlHandler
---@field txt_ownGold2 UIKmlLuaControlHandler
---@field btn_tips UIKmlLuaControlHandler
---@field prefab1 UIKmlLuaControlHandler
---@field prefab2 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img13 UIKmlLuaControlHandler
---@field Target UIKmlLuaControlHandler
---@field img12 UIKmlLuaControlHandler
---@field txt_targetName UIKmlLuaControlHandler
---@field btn_targetGold1 UIKmlLuaControlHandler
---@field icon_targetGold1 UIKmlLuaControlHandler
---@field txt_targetGold1 UIKmlLuaControlHandler
---@field btn_targetGold2 UIKmlLuaControlHandler
---@field icon_targetGold2 UIKmlLuaControlHandler
---@field txt_targetGold2 UIKmlLuaControlHandler
---@field bg_targetScroll UIKmlLuaControlHandler
---@field mask_target UIKmlLuaControlHandler
---@field mask_targetItem UIKmlLuaControlHandler
---@field txt_targetState UIKmlLuaControlHandler
---@field mask_targetMoney UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field img14 UIKmlLuaControlHandler
---@field Me UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field btn_closeMe UIKmlLuaControlHandler
---@field txt_titleMe UIKmlLuaControlHandler
---@field btn_lock UIKmlLuaControlHandler
---@field btn_confirm UIKmlLuaControlHandler
---@field btn_meGold1 UIKmlLuaControlHandler
---@field icon_meGold1 UIKmlLuaControlHandler
---@field input_meGold1 UIKmlLuaControlHandler
---@field btn_meGold2 UIKmlLuaControlHandler
---@field icon_meGold2 UIKmlLuaControlHandler
---@field input_meGold2 UIKmlLuaControlHandler
---@field mask_me UIKmlLuaControlHandler
---@field img8 UIKmlLuaControlHandler
---@field txt_myState UIKmlLuaControlHandler
---@field img9 UIKmlLuaControlHandler
---@field img10 UIKmlLuaControlHandler
---@field bg_meScroll UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
local KLFaceTradePanelView = {}
setmetatable(KLFaceTradePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/FaceTrade/Panel/KLFaceTrade/KLFaceTradePanelKml'
---@param parent UIKmlLuaControlHandler
function KLFaceTradePanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLFaceTradePanelView
