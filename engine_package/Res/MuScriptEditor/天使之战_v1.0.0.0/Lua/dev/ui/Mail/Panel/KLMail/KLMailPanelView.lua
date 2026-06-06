---@class KLMailPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControl
---@field img2 UIKmlLuaControl
---@field img_367 UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field img3 UIKmlLuaControl
---@field title UIKmlLuaControl
---@field closeBtn UIKmlLuaControl
---@field left_panel UIKmlLuaControl
---@field received_mail_list_panel UIKmlLuaControl
---@field scrollview_373 UIKmlLuaControl
---@field mail_data_list UIKmlLuaControl
---@field get_all_btn UIKmlLuaControl
---@field del_all_btn UIKmlLuaControl
---@field mail_content_rt UIKmlLuaControl
---@field content_time UIKmlLuaControl
---@field received_mail_detail_panel UIKmlLuaControl
---@field content_title_bg UIKmlLuaControl
---@field content_title UIKmlLuaControl
---@field content_small_title UIKmlLuaControl
---@field detail_desc_scroll UIKmlLuaControl
---@field detail_desc_layout UIKmlLuaControl
---@field content_text UIKmlLuaControl
---@field received_attachment UIKmlLuaControl
---@field text_391 UIKmlLuaControl
---@field scrollview_392 UIKmlLuaControl
---@field items_list UIKmlLuaControl
---@field detail_btn UIKmlLuaControl
---@field del_btn UIKmlLuaControl
---@field null_bg UIKmlLuaControl
---@field des_btn UIKmlLuaControl
local KLMailPanelView = {}
setmetatable(KLMailPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Mail/Panel/KLMail/KLMailPanelKml'
---@param parent UIKmlLuaControl
function KLMailPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLMailPanelView
