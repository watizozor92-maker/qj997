---@class KLRecoverBagPanelView:UIKmlLuaViewBase
---@field cut_area_up UIKmlLuaControlHandler
---@field cut_area_down UIKmlLuaControlHandler
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field sv_frame UIKmlLuaControlHandler
---@field layout1 UIKmlLuaControlHandler
---@field btn_fix UIKmlLuaControlHandler
---@field btn_arrange UIKmlLuaControlHandler
---@field btn_storage UIKmlLuaControlHandler
---@field btn_sell UIKmlLuaControlHandler
local KLRecoverBagPanelView = {}
setmetatable(KLRecoverBagPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Bag/Panel/KLRecoverBag/KLRecoverBagPanelKml'
---@param parent UIKmlLuaControlHandler
function KLRecoverBagPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLRecoverBagPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Bag/Panel/KLRecoverBag/KLRecoverBagPanel']

return KLRecoverBagPanelView
