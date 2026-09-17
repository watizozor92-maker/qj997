---@class KLDepotsPanelView:UIKmlLuaViewBase
---@field BG_Templete UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field edit_btn UIKmlLuaControlHandler
---@field storeText UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field sv_frame UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field storage_btn UIKmlLuaControlHandler
---@field edit_panel UIKmlLuaControlHandler
---@field bgImg UIKmlLuaControlHandler
---@field edit_CloseBtn UIKmlLuaControlHandler
---@field edit_oldName UIKmlLuaControlHandler
---@field old_Store_Name UIKmlLuaControlHandler
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
---@field cut_area_up UIKmlLuaControlHandler
---@field PageScrollView UIKmlLuaControlHandler
---@field ItemContent UIKmlLuaControlHandler
---@field cut_area_down UIKmlLuaControlHandler
local KLDepotsPanelView = {}
setmetatable(KLDepotsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Bag/Panel/KLDepots/KLDepotsPanelKml'
---@param parent UIKmlLuaControlHandler
function KLDepotsPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLDepotsPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Bag/Panel/KLDepots/KLDepotsPanel']

return KLDepotsPanelView
