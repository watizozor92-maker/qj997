---@class KLBossHpItemView:UIKmlLuaViewBase
---@field equip_item UIKmlLuaControlHandler
---@field btn UIKmlLuaControlHandler
local KLBossHpItemView = {}
setmetatable(KLBossHpItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/MainUI/Item/KLBossHp/KLBossHpItemKml'
---@param parent UIKmlLuaControlHandler
function KLBossHpItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLBossHpItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/MainUI/Item/KLBossHp/KLBossHpItem']

return KLBossHpItemView
