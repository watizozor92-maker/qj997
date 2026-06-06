---@class KLMountSkinsPanelView:UIKmlLuaViewBase
---@field img1 UIKmlLuaControl
---@field title UIKmlLuaControl
---@field img3 UIKmlLuaControl
---@field text1 UIKmlLuaControl
---@field scrollview2 UIKmlLuaControl
---@field layout3 UIKmlLuaControl
---@field skinDatas UIKmlLuaControl
---@field rideLock UIKmlLuaControl
---@field btn_useSkin UIKmlLuaControl
local KLMountSkinsPanelView = {}
setmetatable(KLMountSkinsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Mount/Panel/KLMountSkins/KLMountSkinsPanelKml'
---@param parent UIKmlLuaControl
function KLMountSkinsPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLMountSkinsPanelView
