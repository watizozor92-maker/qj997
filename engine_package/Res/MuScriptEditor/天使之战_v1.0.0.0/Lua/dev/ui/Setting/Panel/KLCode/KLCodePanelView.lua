---@class KLCodePanelView:UIKmlLuaViewBase
---@field prefab_765 UIKmlLuaControlHandler
---@field CodeInput UIKmlLuaControlHandler
---@field exchangeBtn UIKmlLuaControlHandler
local KLCodePanelView = {}
setmetatable(KLCodePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Setting/Panel/KLCode/KLCodePanelKml'
---@param parent UIKmlLuaControlHandler
function KLCodePanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLCodePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Setting/Panel/KLCode/KLCodePanel']

return KLCodePanelView
