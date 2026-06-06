---@class KLArchangelDecomposePanelView:UIKmlLuaViewBase
---@field BG UIKmlLuaControl
---@field CloseButton UIKmlLuaControl
---@field NoInfo UIKmlLuaControl
---@field title UIKmlLuaControl
---@field hide_panel UIKmlLuaControl
---@field EquipBg UIKmlLuaControl
---@field EquipScrollView UIKmlLuaControl
---@field gridview2 UIKmlLuaControl
---@field grail_list UIKmlLuaControl
---@field DecomposeCustomScrollView UIKmlLuaControl
---@field DecomposeCustomCount UIKmlLuaControl
---@field DecomposeCustomDataList UIKmlLuaControl
---@field DecomposeGetScrollView UIKmlLuaControl
---@field DecomposeGetCount UIKmlLuaControl
---@field DecomposeGetDataList UIKmlLuaControl
---@field decoIcon_1 UIKmlLuaControl
---@field decoIcon_1_Icon UIKmlLuaControl
---@field decoIcon_1_Text UIKmlLuaControl
---@field decoIconLineL UIKmlLuaControl
---@field decoIconLineR UIKmlLuaControl
---@field decoIcon UIKmlLuaControl
---@field DecomposeButton UIKmlLuaControl
local KLArchangelDecomposePanelView = {}
setmetatable(KLArchangelDecomposePanelView, UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Panel/KLArchangelDecompose/KLArchangelDecomposePanelKml'
KLArchangelDecomposePanelView.content = CS.TCFramework.LuaManager.LoadFileText(kmlPath, nil, '.txt')
---@param parent UIKmlLuaControl
function KLArchangelDecomposePanelView:Init(parent)

    self:InitRoot(parent, kmlPath, KLArchangelDecomposePanelView.content)
end
return KLArchangelDecomposePanelView
