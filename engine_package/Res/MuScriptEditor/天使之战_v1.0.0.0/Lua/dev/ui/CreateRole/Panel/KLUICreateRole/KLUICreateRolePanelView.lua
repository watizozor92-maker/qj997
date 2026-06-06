---@class KLUICreateRolePanelView:UIKmlLuaViewBase
---@field create_panel UIKmlLuaControlHandler
---@field mask UIKmlLuaControlHandler
---@field img_274 UIKmlLuaControlHandler
---@field createrole_togglegroup UIKmlLuaControlHandler
---@field createrole_layout UIKmlLuaControlHandler
---@field scrollview3 UIKmlLuaControlHandler
---@field createrole_model UIKmlLuaControlHandler
---@field BgMask UIKmlLuaControlHandler
---@field midNode UIKmlLuaControlHandler
---@field img_278 UIKmlLuaControlHandler
---@field createrole_description UIKmlLuaControlHandler
---@field createrole_input UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field layout1 UIKmlLuaControlHandler
---@field btn_createrole_create UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field Text_attach UIKmlLuaControlHandler
---@field btn_createrole_random UIKmlLuaControlHandler
---@field btn_createrole_unlock UIKmlLuaControlHandler
---@field textbg_createrole_unlock UIKmlLuaControlHandler
---@field text_createrole_unlock UIKmlLuaControlHandler
---@field attrBg UIKmlLuaControlHandler
---@field lualoopscrollview UIKmlLuaControlHandler
---@field att_list UIKmlLuaControlHandler
---@field panel_lockRole UIKmlLuaControlHandler
---@field img11 UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
local KLUICreateRolePanelView = {}
setmetatable(KLUICreateRolePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/CreateRole/Panel/KLUICreateRole/KLUICreateRolePanelKml'
---@param parent UIKmlLuaControlHandler
function KLUICreateRolePanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLUICreateRolePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/CreateRole/Panel/KLUICreateRole/KLUICreateRolePanel']

return KLUICreateRolePanelView
