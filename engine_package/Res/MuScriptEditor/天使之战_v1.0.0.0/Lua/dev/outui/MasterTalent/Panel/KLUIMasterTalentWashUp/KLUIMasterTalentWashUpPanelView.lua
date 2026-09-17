---@class KLUIMasterTalentWashUpPanelView:UIKmlLuaViewBase
---@field MaskCloseButton UIKmlLuaControlHandler
---@field BG UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field CloseButton UIKmlLuaControlHandler
---@field Info UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field Text UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field Text2 UIKmlLuaControlHandler
---@field CancelButton UIKmlLuaControlHandler
---@field OkButton UIKmlLuaControlHandler
---@field Cost UIKmlLuaControlHandler
---@field CostBG UIKmlLuaControlHandler
---@field CostItem UIKmlLuaControlHandler
---@field textCost UIKmlLuaControlHandler
---@field text14 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
local KLUIMasterTalentWashUpPanelView = {}
setmetatable(KLUIMasterTalentWashUpPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MasterTalent/Panel/KLUIMasterTalentWashUp/KLUIMasterTalentWashUpPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIMasterTalentWashUpPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIMasterTalentWashUpPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/MasterTalent/Panel/KLUIMasterTalentWashUp/KLUIMasterTalentWashUpPanel']

return KLUIMasterTalentWashUpPanelView
