---@class KLEquipDecomposeUIPanelView:UIKmlLuaViewBase
---@field prefab_299 UIKmlLuaControlHandler
---@field BG UIKmlLuaControlHandler
---@field CloseButton UIKmlLuaControlHandler
---@field HelpButton UIKmlLuaControlHandler
---@field Info UIKmlLuaControlHandler
---@field DecomposeButton UIKmlLuaControlHandler
---@field DecomposeButtonText UIKmlLuaControlHandler
---@field NoInfo UIKmlLuaControlHandler
---@field decoIcon UIKmlLuaControlHandler
---@field decoIconLineR UIKmlLuaControlHandler
---@field decoIconLineL UIKmlLuaControlHandler
---@field decoIcon_1 UIKmlLuaControlHandler
---@field decoIcon_1_Icon UIKmlLuaControlHandler
---@field decoIcon_1_Text UIKmlLuaControlHandler
---@field ChooseTypeScroll UIKmlLuaControlHandler
---@field ChooseTypeCount UIKmlLuaControlHandler
---@field DecomposeGetScrollView UIKmlLuaControlHandler
---@field DecomposeGetCount UIKmlLuaControlHandler
---@field DecomposeGetDataList UIKmlLuaControlHandler
---@field DecomposeCustomScrollView UIKmlLuaControlHandler
---@field DecomposeCustomCount UIKmlLuaControlHandler
---@field DecomposeCustomDataList UIKmlLuaControlHandler
---@field EquipBg UIKmlLuaControlHandler
---@field EquipScrollView UIKmlLuaControlHandler
---@field gridview2 UIKmlLuaControlHandler
---@field EquipList UIKmlLuaControlHandler
local KLEquipDecomposeUIPanelView = {}
setmetatable(KLEquipDecomposeUIPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Equip/Panel/KLEquipDecomposeUI/KLEquipDecomposeUIPanelKml'
---@param parent UIKmlLuaControlHandler
function KLEquipDecomposeUIPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLEquipDecomposeUIPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Equip/Panel/KLEquipDecomposeUI/KLEquipDecomposeUIPanel']

return KLEquipDecomposeUIPanelView
