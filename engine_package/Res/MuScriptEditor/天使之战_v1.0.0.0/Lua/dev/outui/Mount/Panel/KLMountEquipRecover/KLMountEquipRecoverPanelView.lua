---@class KLMountEquipRecoverPanelView:UIKmlLuaViewBase
---@field info UIKmlLuaControl
---@field RecoverGet UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field img2 UIKmlLuaControl
---@field BtnRecover UIKmlLuaControl
---@field closeBtn UIKmlLuaControl
---@field scrollview1 UIKmlLuaControl
---@field layout2 UIKmlLuaControl
---@field loopscrollviewData UIKmlLuaControl
---@field TextTitle UIKmlLuaControl
---@field bag UIKmlLuaControl
---@field title UIKmlLuaControl
---@field sv_frame UIKmlLuaControl
---@field prefab1 UIKmlLuaControl
---@field prefab2 UIKmlLuaControl
local KLMountEquipRecoverPanelView = {}
setmetatable(KLMountEquipRecoverPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Mount/Panel/KLMountEquipRecover/KLMountEquipRecoverPanelKml'
---@param parent UIKmlLuaControl
function KLMountEquipRecoverPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLMountEquipRecoverPanelView
