---@class KLMasterTalentNewPanelView:UIKmlLuaViewBase
---@field panel1 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img_367 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field panel3 UIKmlLuaControlHandler
---@field loopscrollview1 UIKmlLuaControlHandler
---@field content_list UIKmlLuaControlHandler
---@field panel2 UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field talent_count UIKmlLuaControlHandler
---@field layout13 UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field info_count1 UIKmlLuaControlHandler
---@field img9 UIKmlLuaControlHandler
---@field info_count2 UIKmlLuaControlHandler
---@field img11 UIKmlLuaControlHandler
---@field info_count3 UIKmlLuaControlHandler
local KLMasterTalentNewPanelView = {}
setmetatable(KLMasterTalentNewPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MasterTalent/Panel/KLMasterTalentNew/KLMasterTalentNewPanelKml'
---@param parent UIKmlLuaControlHandler
function KLMasterTalentNewPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLMasterTalentNewPanelView
