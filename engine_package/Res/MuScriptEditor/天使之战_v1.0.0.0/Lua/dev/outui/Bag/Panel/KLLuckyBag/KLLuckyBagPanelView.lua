---@class KLLuckyBagPanelView:UIKmlLuaViewBase
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
local KLLuckyBagPanelView = {}
setmetatable(KLLuckyBagPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Bag/Panel/KLLuckyBag/KLLuckyBagPanelKml'
---@param parent UIKmlLuaControlHandler
function KLLuckyBagPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLLuckyBagPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Bag/Panel/KLLuckyBag/KLLuckyBagPanel']

return KLLuckyBagPanelView
