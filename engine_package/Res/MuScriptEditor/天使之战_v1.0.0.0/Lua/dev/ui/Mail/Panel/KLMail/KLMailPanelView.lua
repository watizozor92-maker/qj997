---@class KLMailPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img_367 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field left_panel UIKmlLuaControlHandler
---@field received_mail_list_panel UIKmlLuaControlHandler
---@field scrollview_373 UIKmlLuaControlHandler
---@field mail_data_list UIKmlLuaControlHandler
---@field get_all_btn UIKmlLuaControlHandler
---@field del_all_btn UIKmlLuaControlHandler
---@field mail_content_rt UIKmlLuaControlHandler
---@field content_time UIKmlLuaControlHandler
---@field received_mail_detail_panel UIKmlLuaControlHandler
---@field content_title_bg UIKmlLuaControlHandler
---@field content_title UIKmlLuaControlHandler
---@field content_small_title UIKmlLuaControlHandler
---@field detail_desc_scroll UIKmlLuaControlHandler
---@field detail_desc_layout UIKmlLuaControlHandler
---@field content_text UIKmlLuaControlHandler
---@field received_attachment UIKmlLuaControlHandler
---@field text_391 UIKmlLuaControlHandler
---@field scrollview_392 UIKmlLuaControlHandler
---@field items_list UIKmlLuaControlHandler
---@field detail_btn UIKmlLuaControlHandler
---@field del_btn UIKmlLuaControlHandler
---@field null_bg UIKmlLuaControlHandler
---@field des_btn UIKmlLuaControlHandler
local KLMailPanelView = {}
setmetatable(KLMailPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Mail/Panel/KLMail/KLMailPanelKml'
---@param parent UIKmlLuaControlHandler
function KLMailPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLMailPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Mail/Panel/KLMail/KLMailPanel']

return KLMailPanelView
