---@class KLMountSkinsPanelView:UIKmlLuaViewBase
---@field img1 UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field scrollview2 UIKmlLuaControlHandler
---@field layout3 UIKmlLuaControlHandler
---@field skinDatas UIKmlLuaControlHandler
---@field rideLock UIKmlLuaControlHandler
---@field btn_useSkin UIKmlLuaControlHandler
local KLMountSkinsPanelView = {}
setmetatable(KLMountSkinsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Mount/Panel/KLMountSkins/KLMountSkinsPanelKml'
---@param parent UIKmlLuaControlHandler
function KLMountSkinsPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLMountSkinsPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Mount/Panel/KLMountSkins/KLMountSkinsPanel']

return KLMountSkinsPanelView
