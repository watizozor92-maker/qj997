---@class KLFashionEquipMapPanelView:UIKmlLuaViewBase
---@field BG_Templete UIKmlLuaControl
---@field ReMask UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field Frame UIKmlLuaControl
---@field bg UIKmlLuaControl
---@field text2 UIKmlLuaControl
---@field img2 UIKmlLuaControl
---@field icon UIKmlLuaControl
---@field txt_name UIKmlLuaControl
---@field btn_close UIKmlLuaControl
---@field img_fillBg UIKmlLuaControl
---@field img_fill UIKmlLuaControl
---@field txt_progress UIKmlLuaControl
---@field scrollview5 UIKmlLuaControl
---@field layout6 UIKmlLuaControl
---@field DataList_Attr UIKmlLuaControl
local KLFashionEquipMapPanelView = {}
setmetatable(KLFashionEquipMapPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/FashionEquip/Panel/KLFashionEquipMap/KLFashionEquipMapPanelKml'
---@param parent UIKmlLuaControl
function KLFashionEquipMapPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLFashionEquipMapPanelView
