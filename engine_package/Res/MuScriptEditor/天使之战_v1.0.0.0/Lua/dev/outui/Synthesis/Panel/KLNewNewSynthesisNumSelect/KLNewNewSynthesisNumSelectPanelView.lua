---@class KLNewNewSynthesisNumSelectPanelView:UIKmlLuaViewBase
---@field Btn_Close UIKmlLuaControlHandler
---@field Content UIKmlLuaControlHandler
---@field Bg UIKmlLuaControlHandler
---@field layout6 UIKmlLuaControlHandler
---@field costNode UIKmlLuaControlHandler
---@field text_18 UIKmlLuaControlHandler
---@field txt_number UIKmlLuaControlHandler
---@field number_minus UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field number_add UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field panel1 UIKmlLuaControlHandler
---@field price_slider UIKmlLuaControlHandler
---@field fillArea_attach UIKmlLuaControlHandler
---@field fill_attach UIKmlLuaControlHandler
---@field fillArea_attach UIKmlLuaControlHandler
---@field handle_attach UIKmlLuaControlHandler
---@field Btn_Confirm UIKmlLuaControlHandler
local KLNewNewSynthesisNumSelectPanelView = {}
setmetatable(KLNewNewSynthesisNumSelectPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Synthesis/Panel/KLNewNewSynthesisNumSelect/KLNewNewSynthesisNumSelectPanelKml'
---@param parent UIKmlLuaControlHandler
function KLNewNewSynthesisNumSelectPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLNewNewSynthesisNumSelectPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Synthesis/Panel/KLNewNewSynthesisNumSelect/KLNewNewSynthesisNumSelectPanel']

return KLNewNewSynthesisNumSelectPanelView
