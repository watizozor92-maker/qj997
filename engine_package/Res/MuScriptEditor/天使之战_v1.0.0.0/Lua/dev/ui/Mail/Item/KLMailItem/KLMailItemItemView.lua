---@class KLMailItemItemView:UIKmlLuaViewBase
---@field mail_btn_ UIKmlLuaControl
---@field selected UIKmlLuaControl
---@field mail_icon_ UIKmlLuaControl
---@field mail_title_ UIKmlLuaControl
---@field mail_time_ UIKmlLuaControl
---@field redpoint UIKmlLuaControl
local KLMailItemItemView = {}
setmetatable(KLMailItemItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Mail/Item/KLMailItem/KLMailItemItemKml'
---@param parent UIKmlLuaControl
function KLMailItemItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLMailItemItemView
