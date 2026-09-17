---@class KLUITeamHeadItemView:UIKmlLuaViewBase
---@field Content UIKmlLuaControlHandler
---@field Bg UIKmlLuaControlHandler
---@field img_selectionEffect UIKmlLuaControlHandler
---@field img_56 UIKmlLuaControlHandler
---@field sp_careerIcon UIKmlLuaControlHandler
---@field lab_name UIKmlLuaControlHandler
---@field lab_level UIKmlLuaControlHandler
---@field sp_captain UIKmlLuaControlHandler
---@field img_far UIKmlLuaControlHandler
---@field sl_hp UIKmlLuaControlHandler
---@field img_offLineBg UIKmlLuaControlHandler
---@field img_64 UIKmlLuaControlHandler
---@field KLUITeamHeadButton UIKmlLuaControlHandler
local KLUITeamHeadItemView = {}
setmetatable(KLUITeamHeadItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Team/Item/KLUITeamHead/KLUITeamHeadItemKml'
---@param parent UIKmlLuaControlHandler
function KLUITeamHeadItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLUITeamHeadItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Team/Item/KLUITeamHead/KLUITeamHeadItem']

return KLUITeamHeadItemView
