---@class KLGodDescentMonsterItemView:UIKmlLuaViewBase
---@field panel1 UIKmlLuaControl
---@field img_info UIKmlLuaControl
---@field img_kill UIKmlLuaControl
---@field txt_Name UIKmlLuaControl
---@field txt_Status UIKmlLuaControl
---@field txt_Status2 UIKmlLuaControl
local KLGodDescentMonsterItemView = {}
setmetatable(KLGodDescentMonsterItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/CrossServer/Item/KLGodDescentMonster/KLGodDescentMonsterItemKml'
---@param parent UIKmlLuaControl
function KLGodDescentMonsterItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLGodDescentMonsterItemView
