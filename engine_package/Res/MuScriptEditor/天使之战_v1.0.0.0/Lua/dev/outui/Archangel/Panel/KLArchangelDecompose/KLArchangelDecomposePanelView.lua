---@class KLArchangelDecomposePanelView:UIKmlLuaViewBase
---@field BG UIKmlLuaControlHandler
---@field CloseButton UIKmlLuaControlHandler
---@field NoInfo UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field hide_panel UIKmlLuaControlHandler
---@field EquipBg UIKmlLuaControlHandler
---@field EquipScrollView UIKmlLuaControlHandler
---@field gridview2 UIKmlLuaControlHandler
---@field grail_list UIKmlLuaControlHandler
---@field DecomposeCustomScrollView UIKmlLuaControlHandler
---@field DecomposeCustomCount UIKmlLuaControlHandler
---@field DecomposeCustomDataList UIKmlLuaControlHandler
---@field DecomposeGetScrollView UIKmlLuaControlHandler
---@field DecomposeGetCount UIKmlLuaControlHandler
---@field DecomposeGetDataList UIKmlLuaControlHandler
---@field decoIcon_1 UIKmlLuaControlHandler
---@field decoIcon_1_Icon UIKmlLuaControlHandler
---@field decoIcon_1_Text UIKmlLuaControlHandler
---@field decoIconLineL UIKmlLuaControlHandler
---@field decoIconLineR UIKmlLuaControlHandler
---@field decoIcon UIKmlLuaControlHandler
---@field DecomposeButton UIKmlLuaControlHandler
local KLArchangelDecomposePanelView = {}
setmetatable(KLArchangelDecomposePanelView, UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Panel/KLArchangelDecompose/KLArchangelDecomposePanelKml'
KLArchangelDecomposePanelView.content = CS.TCFramework.LuaManager.LoadFileText(kmlPath, nil, '.txt')
---@param parent UIKmlLuaControlHandler
function KLArchangelDecomposePanelView:Init(parent)

    self:InitRoot(parent, kmlPath, KLArchangelDecomposePanelView.content)
end
---@type KLArchangelDecomposePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Archangel/Panel/KLArchangelDecompose/KLArchangelDecomposePanel']

return KLArchangelDecomposePanelView
