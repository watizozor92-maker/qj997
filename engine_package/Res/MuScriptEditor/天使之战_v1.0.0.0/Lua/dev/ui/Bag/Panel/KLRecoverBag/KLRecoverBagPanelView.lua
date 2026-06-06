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
---@param parent UIKmlLuaControlHandlerHandlerHandlerHandlerHandlerHandlerHandler
function KLRecoverBagPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLRecoverBagPanelView
