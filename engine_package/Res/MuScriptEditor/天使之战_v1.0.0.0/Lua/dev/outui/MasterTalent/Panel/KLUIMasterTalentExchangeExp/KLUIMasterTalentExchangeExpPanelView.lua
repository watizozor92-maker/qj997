---@class KLUIMasterTalentExchangeExpPanelView:UIKmlLuaViewBase
---@field MaskCloseButton UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field Text UIKmlLuaControlHandler
---@field scrollview UIKmlLuaControlHandler
---@field layout4 UIKmlLuaControlHandler
---@field DataList UIKmlLuaControlHandler
---@field CloseButton UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
local KLUIMasterTalentExchangeExpPanelView = {}
setmetatable(KLUIMasterTalentExchangeExpPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MasterTalent/Panel/KLUIMasterTalentExchangeExp/KLUIMasterTalentExchangeExpPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIMasterTalentExchangeExpPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIMasterTalentExchangeExpPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/MasterTalent/Panel/KLUIMasterTalentExchangeExp/KLUIMasterTalentExchangeExpPanel']

return KLUIMasterTalentExchangeExpPanelView
