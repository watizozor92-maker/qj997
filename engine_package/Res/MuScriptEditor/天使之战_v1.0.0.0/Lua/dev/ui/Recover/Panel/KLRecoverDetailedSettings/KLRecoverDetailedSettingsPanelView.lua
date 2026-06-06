---@class KLRecoverDetailedSettingsPanelView:UIKmlLuaViewBase
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field img_59 UIKmlLuaControlHandler
---@field view_info UIKmlLuaControlHandler
---@field base_info UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field TextTitle UIKmlLuaControlHandler
---@field tipTxt UIKmlLuaControlHandler
---@field tipTxt2 UIKmlLuaControlHandler
local KLRecoverDetailedSettingsPanelView = {}
setmetatable(KLRecoverDetailedSettingsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Recover/Panel/KLRecoverDetailedSettings/KLRecoverDetailedSettingsPanelKml'
---@param parent UIKmlLuaControlHandlerHandlerHandlerHandlerHandlerHandler
function KLRecoverDetailedSettingsPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLRecoverDetailedSettingsPanelView
