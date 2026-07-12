---@class KLUIPrivilegeBossPosItemView:UIKmlLuaViewBase
---@field btn UIKmlLuaControlHandler
---@field name UIKmlLuaControlHandler
---@field num UIKmlLuaControlHandler
---@field pos_str UIKmlLuaControlHandler
---@field info UIKmlLuaControlHandler
---@field revive_time UIKmlLuaControlHandler
local KLUIPrivilegeBossPosItemView = {}
setmetatable(KLUIPrivilegeBossPosItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLUIPrivilegeBossPosItem/KLUIPrivilegeBossPosItemKml'
---@param parent UIKmlLuaControlHandler
function KLUIPrivilegeBossPosItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIPrivilegeBossPosItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ChallengeBoss/Item/KLUIPrivilegeBossPosItem/KLUIPrivilegeBossPosItem']

return KLUIPrivilegeBossPosItemView
