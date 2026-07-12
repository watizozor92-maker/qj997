---@class KLMasterTalentContentItemView:UIKmlLuaViewBase
---@field layout1 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field line1 UIKmlLuaControlHandler
---@field line2 UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field tier UIKmlLuaControlHandler
---@field tierInfo UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field gridview1 UIKmlLuaControlHandler
---@field serieslist1 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field gridview6 UIKmlLuaControlHandler
---@field serieslist2 UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field gridview9 UIKmlLuaControlHandler
---@field serieslist3 UIKmlLuaControlHandler
local KLMasterTalentContentItemView = {}
setmetatable(KLMasterTalentContentItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MasterTalent/Item/KLMasterTalentContent/KLMasterTalentContentItemKml'
---@param parent UIKmlLuaControlHandler
function KLMasterTalentContentItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLMasterTalentContentItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/MasterTalent/Item/KLMasterTalentContent/KLMasterTalentContentItem']

return KLMasterTalentContentItemView
