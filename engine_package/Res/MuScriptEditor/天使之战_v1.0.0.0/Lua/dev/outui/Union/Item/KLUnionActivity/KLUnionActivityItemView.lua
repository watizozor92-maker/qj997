---@class KLUnionActivityItemView:UIKmlLuaViewBase
---@field Bg UIKmlLuaControlHandler
---@field OpenTips UIKmlLuaControlHandler
---@field limitText UIKmlLuaControlHandler
---@field timeText UIKmlLuaControlHandler
---@field TxtOpenTime UIKmlLuaControlHandler
---@field TxtLimit UIKmlLuaControlHandler
---@field ImgOpen UIKmlLuaControlHandler
---@field Text_Name UIKmlLuaControlHandler
local KLUnionActivityItemView = {}
setmetatable(KLUnionActivityItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Union/Item/KLUnionActivity/KLUnionActivityItemKml'
---@param parent UIKmlLuaControlHandler
function KLUnionActivityItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUnionActivityItemView
