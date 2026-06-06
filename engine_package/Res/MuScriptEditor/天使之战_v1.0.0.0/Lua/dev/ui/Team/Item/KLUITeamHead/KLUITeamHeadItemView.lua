---@class KLUITeamHeadItemView:UIKmlLuaViewBase
---@field Content UIKmlLuaControl
---@field Bg UIKmlLuaControl
---@field img_selectionEffect UIKmlLuaControl
---@field img_56 UIKmlLuaControl
---@field sp_careerIcon UIKmlLuaControl
---@field lab_name UIKmlLuaControl
---@field lab_level UIKmlLuaControl
---@field sp_captain UIKmlLuaControl
---@field img_far UIKmlLuaControl
---@field sl_hp UIKmlLuaControl
---@field img_offLineBg UIKmlLuaControl
---@field img_64 UIKmlLuaControl
---@field KLUITeamHeadButton UIKmlLuaControl
local KLUITeamHeadItemView = {}
setmetatable(KLUITeamHeadItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Team/Item/KLUITeamHead/KLUITeamHeadItemKml'
---@param parent UIKmlLuaControl
function KLUITeamHeadItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLUITeamHeadItemView
