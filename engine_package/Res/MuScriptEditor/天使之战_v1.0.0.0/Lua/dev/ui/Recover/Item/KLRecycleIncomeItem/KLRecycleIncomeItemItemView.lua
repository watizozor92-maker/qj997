---@class KLRecycleIncomeItemItemView:UIKmlLuaViewBase
---@field KmlRecycleIncomeItemTemplate UIKmlLuaControl
---@field IncomeCount UIKmlLuaControl
---@field IncomeIcon UIKmlLuaControl
local KLRecycleIncomeItemItemView = {}
setmetatable(KLRecycleIncomeItemItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Recover/Item/KLRecycleIncomeItem/KLRecycleIncomeItemItemKml'
---@param parent UIKmlLuaControl
function KLRecycleIncomeItemItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLRecycleIncomeItemItemView
