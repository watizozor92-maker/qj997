---@class KLDepotsPanelView:UIKmlLuaViewBase
---@field cut_area_up UIKmlLuaControlHandler
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field storeText UIKmlLuaControlHandler
---@field edit_btn UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field sv_frame UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field cut_area_down UIKmlLuaControlHandler
---@field storage_btn UIKmlLuaControlHandler
---@field PageScrollView UIKmlLuaControlHandler
---@field ItemContent UIKmlLuaControlHandler
---@field edit_panel UIKmlLuaControlHandler
---@field bgImg UIKmlLuaControlHandler
---@field old_Store_Name UIKmlLuaControlHandler
---@field edit_oldName UIKmlLuaControlHandler
---@field edit_CloseBtn UIKmlLuaControlHandler
---@field store_Name_Input UIKmlLuaControlHandler
---@field Text_attach UIKmlLuaControlHandler
---@field edit_Enter UIKmlLuaControlHandler
---@field edit_Cancel UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field pageLeft_btn UIKmlLuaControlHandler
---@field pageRight_btn UIKmlLuaControlHandler
---@field add_btn UIKmlLuaControlHandler
---@field tidy_btn UIKmlLuaControlHandler
---@field priv_btn UIKmlLuaControlHandler
---@field forbid_red_panel UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
local KLDepotsPanelView = {}
setmetatable(KLDepotsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Bag/Panel/KLDepots/KLDepotsPanelKml'
---@param parent UIKmlLuaControlHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandler
function KLDepotsPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLDepotsPanelView
