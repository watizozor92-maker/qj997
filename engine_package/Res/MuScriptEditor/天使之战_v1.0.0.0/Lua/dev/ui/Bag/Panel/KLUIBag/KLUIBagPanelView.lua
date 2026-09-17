---@class KLUIBagPanelView:UIKmlLuaViewBase
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field FashionRoot UIKmlLuaControlHandler
---@field scrollview15 UIKmlLuaControlHandler
---@field layout16 UIKmlLuaControlHandler
---@field datalist_suit UIKmlLuaControlHandler
---@field togglegroup2 UIKmlLuaControlHandler
---@field sv_frame UIKmlLuaControlHandler
---@field MoneyRoot UIKmlLuaControlHandler
---@field layout3 UIKmlLuaControlHandler
---@field gridview1 UIKmlLuaControlHandler
---@field btn_ruibi UIKmlLuaControlHandler
---@field ruibiIcon UIKmlLuaControlHandler
---@field txt_ruibi UIKmlLuaControlHandler
---@field btn_gold UIKmlLuaControlHandler
---@field goldIcon UIKmlLuaControlHandler
---@field txt_gold UIKmlLuaControlHandler
---@field btn_diamond UIKmlLuaControlHandler
---@field diamondIcon UIKmlLuaControlHandler
---@field txt_diamond UIKmlLuaControlHandler
---@field AttInfosRoot UIKmlLuaControlHandler
---@field layoutAtts UIKmlLuaControlHandler
---@field datalist_atts UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field EquipRoot UIKmlLuaControlHandler
---@field EquipGrid UIKmlLuaControlHandler
---@field btn_go_model UIKmlLuaControlHandler
---@field btn_attSuits UIKmlLuaControlHandler
---@field btn_strengthenAtts UIKmlLuaControlHandler
---@field btn_attGems UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field btn_emptyBg UIKmlLuaControlHandler
---@field layout1 UIKmlLuaControlHandler
---@field btn_fix_Root UIKmlLuaControlHandler
---@field btn_fix UIKmlLuaControlHandler
---@field obj_highLight UIKmlLuaControlHandler
---@field RawImage UIKmlLuaControlHandler
---@field Effect UIKmlLuaControlHandler
---@field btn_shop_Root UIKmlLuaControlHandler
---@field btn_shop UIKmlLuaControlHandler
---@field btn_storage_Root UIKmlLuaControlHandler
---@field btn_storage UIKmlLuaControlHandler
---@field btn_sell_Root UIKmlLuaControlHandler
---@field btn_sell UIKmlLuaControlHandler
---@field btn_arrange_Root UIKmlLuaControlHandler
---@field btn_arrange UIKmlLuaControlHandler
---@field cut_area_up UIKmlLuaControlHandler
---@field cut_area_down UIKmlLuaControlHandler
local KLUIBagPanelView = {}
setmetatable(KLUIBagPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Bag/Panel/KLUIBag/KLUIBagPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIBagPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLUIBagPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel']

return KLUIBagPanelView
