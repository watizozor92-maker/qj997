---@class KLMasterTalentTipsPanelView:UIKmlLuaViewBase
---@field mask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field scrollview1 UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field name UIKmlLuaControlHandler
---@field panel1 UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field level UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field currentInfo UIKmlLuaControlHandler
---@field panel6 UIKmlLuaControlHandler
---@field nexttitle UIKmlLuaControlHandler
---@field nextInfo UIKmlLuaControlHandler
---@field UpButton UIKmlLuaControlHandler
local KLMasterTalentTipsPanelView = {}
setmetatable(KLMasterTalentTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MasterTalent/Panel/KLMasterTalentTips/KLMasterTalentTipsPanelKml'
---@param parent UIKmlLuaControlHandler
function KLMasterTalentTipsPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLMasterTalentTipsPanelView
