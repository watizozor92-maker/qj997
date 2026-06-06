---@class KLEquipEffPreviewPanelView:UIKmlLuaViewBase
---@field content UIKmlLuaControlHandler
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field bg1 UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field Btn_Close UIKmlLuaControlHandler
---@field scrollview2 UIKmlLuaControlHandler
---@field gridview3 UIKmlLuaControlHandler
---@field tabDataList UIKmlLuaControlHandler
---@field tabToggleGroup UIKmlLuaControlHandler
---@field Text_Des UIKmlLuaControlHandler
---@field roleParent UIKmlLuaControlHandler
local KLEquipEffPreviewPanelView = {}
setmetatable(KLEquipEffPreviewPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Equip/Panel/KLEquipEffPreview/KLEquipEffPreviewPanelKml'
---@param parent UIKmlLuaControlHandler
function KLEquipEffPreviewPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLEquipEffPreviewPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Equip/Panel/KLEquipEffPreview/KLEquipEffPreviewPanel']

return KLEquipEffPreviewPanelView
