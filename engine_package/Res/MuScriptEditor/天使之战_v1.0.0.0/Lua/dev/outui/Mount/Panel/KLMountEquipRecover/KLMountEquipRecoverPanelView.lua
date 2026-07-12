---@class KLMountEquipRecoverPanelView:UIKmlLuaViewBase
---@field info UIKmlLuaControlHandler
---@field RecoverGet UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field BtnRecover UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field scrollview1 UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field loopscrollviewData UIKmlLuaControlHandler
---@field TextTitle UIKmlLuaControlHandler
---@field bag UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field sv_frame UIKmlLuaControlHandler
---@field prefab1 UIKmlLuaControlHandler
---@field prefab2 UIKmlLuaControlHandler
local KLMountEquipRecoverPanelView = {}
setmetatable(KLMountEquipRecoverPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Mount/Panel/KLMountEquipRecover/KLMountEquipRecoverPanelKml'
---@param parent UIKmlLuaControlHandler
function KLMountEquipRecoverPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLMountEquipRecoverPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Mount/Panel/KLMountEquipRecover/KLMountEquipRecoverPanel']

return KLMountEquipRecoverPanelView
