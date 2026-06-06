---@class KLUIMasterTalentWashUpPanelView:UIKmlLuaViewBase
---@field MaskCloseButton UIKmlLuaControl
---@field BG UIKmlLuaControl
---@field title UIKmlLuaControl
---@field CloseButton UIKmlLuaControl
---@field Info UIKmlLuaControl
---@field img2 UIKmlLuaControl
---@field Text UIKmlLuaControl
---@field img4 UIKmlLuaControl
---@field Text2 UIKmlLuaControl
---@field CancelButton UIKmlLuaControl
---@field OkButton UIKmlLuaControl
---@field Cost UIKmlLuaControl
---@field CostBG UIKmlLuaControl
---@field CostItem UIKmlLuaControl
---@field textCost UIKmlLuaControl
---@field text14 UIKmlLuaControl
---@field img1 UIKmlLuaControl
local KLUIMasterTalentWashUpPanelView = {}
setmetatable(KLUIMasterTalentWashUpPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MasterTalent/Panel/KLUIMasterTalentWashUp/KLUIMasterTalentWashUpPanelKml'
---@param parent UIKmlLuaControl
function KLUIMasterTalentWashUpPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIMasterTalentWashUpPanelView
