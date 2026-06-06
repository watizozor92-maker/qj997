---@class KLCalcPanelView:UIKmlLuaViewBase
---@field img1 UIKmlLuaControlHandler
---@field UICalcPanel UIKmlLuaControlHandler
---@field gridLayout UIKmlLuaControlHandler
---@field CloseBtn UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field panel1 UIKmlLuaControlHandler
---@field numBg UIKmlLuaControlHandler
---@field num UIKmlLuaControlHandler
---@field intro UIKmlLuaControlHandler
---@field sureButton UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field undoButton UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
---@field zeroButton UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field nineButton UIKmlLuaControlHandler
---@field text5 UIKmlLuaControlHandler
---@field sevenButton UIKmlLuaControlHandler
---@field text6 UIKmlLuaControlHandler
---@field sixButton UIKmlLuaControlHandler
---@field text7 UIKmlLuaControlHandler
---@field fiveButton UIKmlLuaControlHandler
---@field text8 UIKmlLuaControlHandler
---@field fourButton UIKmlLuaControlHandler
---@field text9 UIKmlLuaControlHandler
---@field threeButton UIKmlLuaControlHandler
---@field text10 UIKmlLuaControlHandler
---@field twoButton UIKmlLuaControlHandler
---@field text11 UIKmlLuaControlHandler
---@field firstButton UIKmlLuaControlHandler
---@field text12 UIKmlLuaControlHandler
---@field eightButton UIKmlLuaControlHandler
---@field text13 UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
local KLCalcPanelView = {}
setmetatable(KLCalcPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Common/Panel/KLCalc/KLCalcPanelKml'
---@param parent UIKmlLuaControlHandler
function KLCalcPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLCalcPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Common/Panel/KLCalc/KLCalcPanel']

return KLCalcPanelView
