---@class KLUIMasterTalentExchangeExpPanelView:UIKmlLuaViewBase
---@field MaskCloseButton UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field Text UIKmlLuaControl
---@field scrollview UIKmlLuaControl
---@field layout4 UIKmlLuaControl
---@field DataList UIKmlLuaControl
---@field CloseButton UIKmlLuaControl
---@field title UIKmlLuaControl
local KLUIMasterTalentExchangeExpPanelView = {}
setmetatable(KLUIMasterTalentExchangeExpPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MasterTalent/Panel/KLUIMasterTalentExchangeExp/KLUIMasterTalentExchangeExpPanelKml'
---@param parent UIKmlLuaControl
function KLUIMasterTalentExchangeExpPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIMasterTalentExchangeExpPanelView
