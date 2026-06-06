---@class KLMountEquipPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControl
---@field title UIKmlLuaControl
---@field closeBtn UIKmlLuaControl
---@field ownerMountRoot UIKmlLuaControl
---@field img7 UIKmlLuaControl
---@field img6 UIKmlLuaControl
---@field img5 UIKmlLuaControl
---@field bagItemRoot UIKmlLuaControl
---@field bagScroll UIKmlLuaControl
---@field layout4 UIKmlLuaControl
---@field bagRoot UIKmlLuaControl
---@field datalist9 UIKmlLuaControl
---@field oneKeyTakeOff UIKmlLuaControl
---@field oneKeyPutOn UIKmlLuaControl
---@field btn_recycle UIKmlLuaControl
---@field btn_helment UIKmlLuaControl
---@field selectPic UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field item_helment UIKmlLuaControl
---@field red_helment UIKmlLuaControl
---@field btn_foot UIKmlLuaControl
---@field img2 UIKmlLuaControl
---@field item_foot UIKmlLuaControl
---@field red_foot UIKmlLuaControl
---@field btn_saddle UIKmlLuaControl
---@field img3 UIKmlLuaControl
---@field item_saddle UIKmlLuaControl
---@field red_saddle UIKmlLuaControl
---@field btn_rein UIKmlLuaControl
---@field img4 UIKmlLuaControl
---@field item_rein UIKmlLuaControl
---@field red_rein UIKmlLuaControl
---@field notActive UIKmlLuaControl
---@field img9 UIKmlLuaControl
---@field img_notForever UIKmlLuaControl
---@field img11 UIKmlLuaControl
local KLMountEquipPanelView = {}
setmetatable(KLMountEquipPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Mount/Panel/KLMountEquip/KLMountEquipPanelKml'
---@param parent UIKmlLuaControl
function KLMountEquipPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLMountEquipPanelView
