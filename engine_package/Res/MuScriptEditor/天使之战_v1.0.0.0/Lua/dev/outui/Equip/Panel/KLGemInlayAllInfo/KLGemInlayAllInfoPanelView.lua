---@class KLGemInlayAllInfoPanelView:UIKmlLuaViewBase
---@field closeMaskBg UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field scrollview1 UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field datalist4 UIKmlLuaControlHandler
local KLGemInlayAllInfoPanelView = {}
setmetatable(KLGemInlayAllInfoPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Equip/Panel/KLGemInlayAllInfo/KLGemInlayAllInfoPanelKml'
---@param parent UIKmlLuaControlHandler
function KLGemInlayAllInfoPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLGemInlayAllInfoPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Equip/Panel/KLGemInlayAllInfo/KLGemInlayAllInfoPanel']

return KLGemInlayAllInfoPanelView
