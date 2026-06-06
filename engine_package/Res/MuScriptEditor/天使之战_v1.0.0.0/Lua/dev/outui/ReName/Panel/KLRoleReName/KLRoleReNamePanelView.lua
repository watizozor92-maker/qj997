---@class KLRoleReNamePanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field input UIKmlLuaControlHandler
---@field des UIKmlLuaControlHandler
---@field cancelBtn UIKmlLuaControlHandler
---@field okBtn UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field costRoot UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field costCount UIKmlLuaControlHandler
---@field costItem UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
local KLRoleReNamePanelView = {}
setmetatable(KLRoleReNamePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ReName/Panel/KLRoleReName/KLRoleReNamePanelKml'
---@param parent UIKmlLuaControlHandler
function KLRoleReNamePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLRoleReNamePanelView
