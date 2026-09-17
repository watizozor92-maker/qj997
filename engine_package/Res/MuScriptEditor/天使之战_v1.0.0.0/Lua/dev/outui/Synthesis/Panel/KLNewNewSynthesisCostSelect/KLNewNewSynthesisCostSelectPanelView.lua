---@class KLNewNewSynthesisCostSelectPanelView:UIKmlLuaViewBase
---@field Content UIKmlLuaControlHandler
---@field Btn_MaskClose UIKmlLuaControlHandler
---@field Mask UIKmlLuaControlHandler
---@field Btn_Close UIKmlLuaControlHandler
---@field Text_Title UIKmlLuaControlHandler
---@field scrollview4 UIKmlLuaControlHandler
---@field gridview5 UIKmlLuaControlHandler
---@field DataList_Select UIKmlLuaControlHandler
---@field Btn_Confirm UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field Text_Tips UIKmlLuaControlHandler
local KLNewNewSynthesisCostSelectPanelView = {}
setmetatable(KLNewNewSynthesisCostSelectPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Synthesis/Panel/KLNewNewSynthesisCostSelect/KLNewNewSynthesisCostSelectPanelKml'
---@param parent UIKmlLuaControlHandler
function KLNewNewSynthesisCostSelectPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLNewNewSynthesisCostSelectPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Synthesis/Panel/KLNewNewSynthesisCostSelect/KLNewNewSynthesisCostSelectPanel']

return KLNewNewSynthesisCostSelectPanelView
