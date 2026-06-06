---@class KLNPCShopPanelView:UIKmlLuaViewBase
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img15 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field img21 UIKmlLuaControlHandler
---@field CloseButton UIKmlLuaControlHandler
---@field Background UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field scrollerBg UIKmlLuaControlHandler
---@field ItemList UIKmlLuaControlHandler
---@field gridview2 UIKmlLuaControlHandler
---@field goods UIKmlLuaControlHandler
---@field desButton UIKmlLuaControlHandler
---@field autoBuyBackground UIKmlLuaControlHandler
---@field autoBuyText UIKmlLuaControlHandler
---@field autoBuyToggleCheck UIKmlLuaControlHandler
---@field MoneyRoot UIKmlLuaControlHandler
---@field btn_gold UIKmlLuaControlHandler
---@field goldIcon UIKmlLuaControlHandler
---@field txt_gold UIKmlLuaControlHandler
---@field btn_diamond UIKmlLuaControlHandler
---@field diamondIcon UIKmlLuaControlHandler
---@field txt_diamond UIKmlLuaControlHandler
---@field Left UIKmlLuaControlHandler
---@field autoBuyLeftBtn UIKmlLuaControlHandler
---@field autoBuyLeftBtnSelectImg UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field autoBuyLeftBtnText UIKmlLuaControlHandler
---@field autoBuyLeftDownBtn UIKmlLuaControlHandler
---@field autoBuyLeftDownBtn11 UIKmlLuaControlHandler
---@field leftDataPanel UIKmlLuaControlHandler
---@field leftMaskBtn UIKmlLuaControlHandler
---@field scrollviewLeft UIKmlLuaControlHandler
---@field layout9 UIKmlLuaControlHandler
---@field datalistLeft UIKmlLuaControlHandler
---@field Right UIKmlLuaControlHandler
---@field autoBuyRightBtn UIKmlLuaControlHandler
---@field autoBuyRightBtnSelectImg UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field autoBuyRightBtnText UIKmlLuaControlHandler
---@field autoBuyRightDownBtn UIKmlLuaControlHandler
---@field autoBuyRightDownBtn11 UIKmlLuaControlHandler
---@field RightDataPanel UIKmlLuaControlHandler
---@field rightMaskBtn UIKmlLuaControlHandler
---@field scrollviewRight UIKmlLuaControlHandler
---@field layout9 UIKmlLuaControlHandler
---@field datalistRight UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
local KLNPCShopPanelView = {}
setmetatable(KLNPCShopPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/NPC/Panel/KLNPCShop/KLNPCShopPanelKml'
---@param parent UIKmlLuaControlHandler
function KLNPCShopPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLNPCShopPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/NPC/Panel/KLNPCShop/KLNPCShopPanel']

return KLNPCShopPanelView
