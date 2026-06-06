---@class KLRecoverNodeItemView:UIKmlLuaViewBase
---@field layout2 UIKmlLuaControlHandler
---@field togglegroup UIKmlLuaControlHandler
---@field panel1 UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field titleBg UIKmlLuaControlHandler
---@field titleTxt UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field bg_content UIKmlLuaControlHandler
---@field content UIKmlLuaControlHandler
local KLRecoverNodeItemView = {}
setmetatable(KLRecoverNodeItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Recover/Item/KLRecoverNode/KLRecoverNodeItemKml'
---@param parent UIKmlLuaControlHandler
function KLRecoverNodeItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLRecoverNodeItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Recover/Item/KLRecoverNode/KLRecoverNodeItem']

return KLRecoverNodeItemView
