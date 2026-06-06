---@class KLStrengthBagPanelView:UIKmlLuaViewBase
---@field cut_area_up UIKmlLuaControlHandler
---@field cut_area_down UIKmlLuaControlHandler
---@field img_66 UIKmlLuaControlHandler
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field sv_frame UIKmlLuaControlHandler
---@field layout1 UIKmlLuaControlHandler
---@field btn_fix UIKmlLuaControlHandler
---@field btn_arrange UIKmlLuaControlHandler
---@field btn_storage UIKmlLuaControlHandler
---@field btn_sell UIKmlLuaControlHandler
local KLStrengthBagPanelView = {}
setmetatable(KLStrengthBagPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Bag/Panel/KLStrengthBag/KLStrengthBagPanelKml'
---@param parent UIKmlLuaControlHandler
function KLStrengthBagPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLStrengthBagPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Bag/Panel/KLStrengthBag/KLStrengthBagPanel']

return KLStrengthBagPanelView
