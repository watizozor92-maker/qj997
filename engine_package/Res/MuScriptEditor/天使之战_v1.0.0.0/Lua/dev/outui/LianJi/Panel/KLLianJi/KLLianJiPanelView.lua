---@class KLLianJiPanelView:UIKmlLuaViewBase
---@field panel UIKmlLuaControl
---@field BG UIKmlLuaControl
---@field text1 UIKmlLuaControl
---@field img2 UIKmlLuaControl
---@field close UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field ShowTypes UIKmlLuaControl
---@field fangan1 UIKmlLuaControl
---@field fangan_text1 UIKmlLuaControl
---@field fangan2 UIKmlLuaControl
---@field fangan_text2 UIKmlLuaControl
---@field use_fangan UIKmlLuaControl
---@field use_text UIKmlLuaControl
---@field scrollview2 UIKmlLuaControl
---@field gridview3 UIKmlLuaControl
---@field datalist4 UIKmlLuaControl
---@field can_change UIKmlLuaControl
---@field scrollview3 UIKmlLuaControl
---@field layout4 UIKmlLuaControl
---@field datalist5 UIKmlLuaControl
---@field close_change UIKmlLuaControl
local KLLianJiPanelView = {}
setmetatable(KLLianJiPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/LianJi/Panel/KLLianJi/KLLianJiPanelKml'
---@param parent UIKmlLuaControl
function KLLianJiPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLLianJiPanelView
