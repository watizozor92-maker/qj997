---@class KLMountEquipPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field ownerMountRoot UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field bagItemRoot UIKmlLuaControlHandler
---@field bagScroll UIKmlLuaControlHandler
---@field layout4 UIKmlLuaControlHandler
---@field bagRoot UIKmlLuaControlHandler
---@field datalist9 UIKmlLuaControlHandler
---@field oneKeyTakeOff UIKmlLuaControlHandler
---@field oneKeyPutOn UIKmlLuaControlHandler
---@field btn_recycle UIKmlLuaControlHandler
---@field btn_helment UIKmlLuaControlHandler
---@field selectPic UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field item_helment UIKmlLuaControlHandler
---@field red_helment UIKmlLuaControlHandler
---@field btn_foot UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field item_foot UIKmlLuaControlHandler
---@field red_foot UIKmlLuaControlHandler
---@field btn_saddle UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field item_saddle UIKmlLuaControlHandler
---@field red_saddle UIKmlLuaControlHandler
---@field btn_rein UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field item_rein UIKmlLuaControlHandler
---@field red_rein UIKmlLuaControlHandler
---@field notActive UIKmlLuaControlHandler
---@field img9 UIKmlLuaControlHandler
---@field img_notForever UIKmlLuaControlHandler
---@field img11 UIKmlLuaControlHandler
local KLMountEquipPanelView = {}
setmetatable(KLMountEquipPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Mount/Panel/KLMountEquip/KLMountEquipPanelKml'
---@param parent UIKmlLuaControlHandler
function KLMountEquipPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLMountEquipPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Mount/Panel/KLMountEquip/KLMountEquipPanel']

return KLMountEquipPanelView
