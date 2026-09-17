---@class KLRecycleIncomeItemItemView:UIKmlLuaViewBase
---@field KmlRecycleIncomeItemTemplate UIKmlLuaControlHandler
---@field IncomeCount UIKmlLuaControlHandler
---@field IncomeIcon UIKmlLuaControlHandler
local KLRecycleIncomeItemItemView = {}
setmetatable(KLRecycleIncomeItemItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Recover/Item/KLRecycleIncomeItem/KLRecycleIncomeItemItemKml'
---@param parent UIKmlLuaControlHandler
function KLRecycleIncomeItemItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLRecycleIncomeItemItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Recover/Item/KLRecycleIncomeItem/KLRecycleIncomeItemItem']

return KLRecycleIncomeItemItemView
