---@class KLUnionTaskItemView:UIKmlLuaViewBase
---@field ItemBg UIKmlLuaControlHandler
---@field taskTarget UIKmlLuaControlHandler
---@field AwardList UIKmlLuaControlHandler
---@field layout3 UIKmlLuaControlHandler
---@field getList UIKmlLuaControlHandler
---@field TextProgress UIKmlLuaControlHandler
---@field taskButton UIKmlLuaControlHandler
---@field Img_Received_1 UIKmlLuaControlHandler
local KLUnionTaskItemView = {}
setmetatable(KLUnionTaskItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Union/Item/KLUnionTask/KLUnionTaskItemKml'
---@param parent UIKmlLuaControlHandler
function KLUnionTaskItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUnionTaskItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Union/Item/KLUnionTask/KLUnionTaskItem']

return KLUnionTaskItemView
