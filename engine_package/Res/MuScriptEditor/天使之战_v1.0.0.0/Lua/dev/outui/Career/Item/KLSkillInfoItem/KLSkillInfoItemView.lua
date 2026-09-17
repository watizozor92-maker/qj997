---@class KLSkillInfoItemView:UIKmlLuaViewBase
---@field BG_Templete UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field storeText UIKmlLuaControlHandler
---@field edit_btn UIKmlLuaControlHandler
---@field sv_frame UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field storage_btn UIKmlLuaControlHandler
---@field cut_area_down UIKmlLuaControlHandler
---@field forbid_red_panel UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field PageScrollView UIKmlLuaControlHandler
---@field ItemContent UIKmlLuaControlHandler
---@field cut_area_up UIKmlLuaControlHandler
---@field pageLeft_btn UIKmlLuaControlHandler
---@field pageRight_btn UIKmlLuaControlHandler
---@field add_btn UIKmlLuaControlHandler
---@field tidy_btn UIKmlLuaControlHandler
---@field priv_btn UIKmlLuaControlHandler
---@field edit_panel UIKmlLuaControlHandler
---@field bgImg UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field old_Store_Name UIKmlLuaControlHandler
---@field edit_oldName UIKmlLuaControlHandler
---@field store_Name_Input UIKmlLuaControlHandler
---@field Text_attach UIKmlLuaControlHandler
---@field edit_Enter UIKmlLuaControlHandler
---@field edit_Cancel UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field edit_CloseBtn UIKmlLuaControlHandler
local KLSkillInfoItemView = {}
setmetatable(KLSkillInfoItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Career/Item/KLSkillInfoItem/KLSkillInfoItemKml'
---@param parent UIKmlLuaControlHandler
function KLSkillInfoItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLSkillInfoItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Career/Item/KLSkillInfoItem/KLSkillInfoItem']

return KLSkillInfoItemView
