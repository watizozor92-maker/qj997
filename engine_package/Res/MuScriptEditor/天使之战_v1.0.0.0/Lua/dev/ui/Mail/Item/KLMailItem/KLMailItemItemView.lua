---@class KLMailItemItemView:UIKmlLuaViewBase
---@field mail_btn_ UIKmlLuaControlHandler
---@field selected UIKmlLuaControlHandler
---@field mail_icon_ UIKmlLuaControlHandler
---@field mail_title_ UIKmlLuaControlHandler
---@field mail_time_ UIKmlLuaControlHandler
---@field redpoint UIKmlLuaControlHandler
local KLMailItemItemView = {}
setmetatable(KLMailItemItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Mail/Item/KLMailItem/KLMailItemItemKml'
---@param parent UIKmlLuaControlHandler
function KLMailItemItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLMailItemItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Mail/Item/KLMailItem/KLMailItemItem']

return KLMailItemItemView
