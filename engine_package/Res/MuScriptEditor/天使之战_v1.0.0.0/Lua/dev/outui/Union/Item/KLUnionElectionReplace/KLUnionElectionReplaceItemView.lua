---@class KLUnionElectionReplaceItemView:UIKmlLuaViewBase
---@field btnBg UIKmlLuaControlHandler
---@field txtName UIKmlLuaControlHandler
---@field txtLevel UIKmlLuaControlHandler
---@field txtSupports UIKmlLuaControlHandler
local KLUnionElectionReplaceItemView = {}
setmetatable(KLUnionElectionReplaceItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Union/Item/KLUnionElectionReplace/KLUnionElectionReplaceItemKml'
---@param parent UIKmlLuaControlHandler
function KLUnionElectionReplaceItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUnionElectionReplaceItemView
