---@class KLSystemFunctionPanelView:UIKmlLuaViewBase
---@field closePanel UIKmlLuaControlHandler
---@field btn_close UIKmlLuaControlHandler
---@field BG_Templete UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field scrollview_func UIKmlLuaControlHandler
---@field datalist_func UIKmlLuaControlHandler
local KLSystemFunctionPanelView = {}
setmetatable(KLSystemFunctionPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MainUI/Panel/KLSystemFunction/KLSystemFunctionPanelKml'
---@param parent UIKmlLuaControlHandler
function KLSystemFunctionPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLSystemFunctionPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/MainUI/Panel/KLSystemFunction/KLSystemFunctionPanel']

return KLSystemFunctionPanelView
