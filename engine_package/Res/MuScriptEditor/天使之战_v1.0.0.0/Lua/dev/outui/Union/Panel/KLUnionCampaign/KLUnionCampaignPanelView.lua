---@class KLUnionCampaignPanelView:UIKmlLuaViewBase
---@field Bg UIKmlLuaControlHandler
---@field TitleImage UIKmlLuaControlHandler
---@field Bg_Templete UIKmlLuaControlHandler
---@field panel3 UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field btnClose UIKmlLuaControlHandler
---@field txtCountDown UIKmlLuaControlHandler
---@field txtName UIKmlLuaControlHandler
---@field btnAgree UIKmlLuaControlHandler
---@field text5 UIKmlLuaControlHandler
---@field itemAgree UIKmlLuaControlHandler
---@field txtAgree UIKmlLuaControlHandler
---@field txtAgreeNum UIKmlLuaControlHandler
---@field btnRefuse UIKmlLuaControlHandler
---@field text12 UIKmlLuaControlHandler
---@field itemRefuse UIKmlLuaControlHandler
---@field txtRefuse UIKmlLuaControlHandler
---@field txtDisagreeNum UIKmlLuaControlHandler
---@field txtDesc UIKmlLuaControlHandler
local KLUnionCampaignPanelView = {}
setmetatable(KLUnionCampaignPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Union/Panel/KLUnionCampaign/KLUnionCampaignPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUnionCampaignPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUnionCampaignPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Union/Panel/KLUnionCampaign/KLUnionCampaignPanel']

return KLUnionCampaignPanelView
