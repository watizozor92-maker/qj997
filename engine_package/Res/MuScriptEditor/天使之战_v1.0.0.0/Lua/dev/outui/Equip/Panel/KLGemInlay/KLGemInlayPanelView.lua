---@class KLGemInlayPanelView:UIKmlLuaViewBase
---@field panel1 UIKmlLuaControlHandler
---@field BG UIKmlLuaControlHandler
---@field gemAddIcon UIKmlLuaControlHandler
---@field arrContent UIKmlLuaControlHandler
---@field gridview3 UIKmlLuaControlHandler
---@field datalist_gemAttrs UIKmlLuaControlHandler
---@field NoAttribute UIKmlLuaControlHandler
---@field gemAddParentTitle UIKmlLuaControlHandler
---@field scrollview15 UIKmlLuaControlHandler
---@field datalist_AllGemAttrs UIKmlLuaControlHandler
---@field Title UIKmlLuaControlHandler
---@field togglegroup3 UIKmlLuaControlHandler
---@field BGInner_2 UIKmlLuaControlHandler
---@field schemeToggle1 UIKmlLuaControlHandler
---@field schemeTxt1 UIKmlLuaControlHandler
---@field redPointImg1 UIKmlLuaControlHandler
---@field schemeToggle2 UIKmlLuaControlHandler
---@field schemeTxt2 UIKmlLuaControlHandler
---@field redPointImg2 UIKmlLuaControlHandler
---@field CloseButton UIKmlLuaControlHandler
---@field SlateCellParentImg UIKmlLuaControlHandler
---@field panel5 UIKmlLuaControlHandler
---@field SlateAddImg UIKmlLuaControlHandler
---@field SlateCell UIKmlLuaControlHandler
---@field SlateImg UIKmlLuaControlHandler
---@field slateLevelTxt UIKmlLuaControlHandler
---@field ToggleGroupSource UIKmlLuaControlHandler
---@field gemBtn UIKmlLuaControlHandler
---@field GemCellParentImg UIKmlLuaControlHandler
---@field GemCell1Parent UIKmlLuaControlHandler
---@field SelectImg1 UIKmlLuaControlHandler
---@field AddImg1 UIKmlLuaControlHandler
---@field GemCell1 UIKmlLuaControlHandler
---@field GemCellImg1 UIKmlLuaControlHandler
---@field gemLevelTxt1 UIKmlLuaControlHandler
---@field GemCell2Parent UIKmlLuaControlHandler
---@field SelectImg2 UIKmlLuaControlHandler
---@field AddImg2 UIKmlLuaControlHandler
---@field GemCell2 UIKmlLuaControlHandler
---@field GemCellImg2 UIKmlLuaControlHandler
---@field gemLevelTxt2 UIKmlLuaControlHandler
---@field GemCell3Parent UIKmlLuaControlHandler
---@field SelectImg3 UIKmlLuaControlHandler
---@field AddImg3 UIKmlLuaControlHandler
---@field GemCell3 UIKmlLuaControlHandler
---@field GemCellImg3 UIKmlLuaControlHandler
---@field gemLevelTxt3 UIKmlLuaControlHandler
---@field panel3 UIKmlLuaControlHandler
---@field equipbg UIKmlLuaControlHandler
---@field scroll_text_template UIKmlLuaControlHandler
---@field KmlScrollTextTemplate UIKmlLuaControlHandler
---@field equipName UIKmlLuaControlHandler
---@field zhu_item UIKmlLuaControlHandler
---@field zhu_add UIKmlLuaControlHandler
---@field zhu_click UIKmlLuaControlHandler
---@field AllGemAddParent_1 UIKmlLuaControlHandler
---@field AllGemAddTxtTitle UIKmlLuaControlHandler
---@field HelpBtn UIKmlLuaControlHandler
local KLGemInlayPanelView = {}
setmetatable(KLGemInlayPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Equip/Panel/KLGemInlay/KLGemInlayPanelKml'
---@param parent UIKmlLuaControlHandler
function KLGemInlayPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLGemInlayPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Equip/Panel/KLGemInlay/KLGemInlayPanel']

return KLGemInlayPanelView
