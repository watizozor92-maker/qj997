---@class KLUICostMatItemView:UIKmlLuaViewBase
---@field BG UIKmlLuaControlHandler
---@field Model UIKmlLuaControlHandler
---@field TextName UIKmlLuaControlHandler
---@field TextCount UIKmlLuaControlHandler
---@field addButton UIKmlLuaControlHandler
local KLUICostMatItemView = {}
setmetatable(KLUICostMatItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Common/Item/KLUICostMat/KLUICostMatItemKml'
---@param parent UIKmlLuaControlHandler
function KLUICostMatItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUICostMatItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Common/Item/KLUICostMat/KLUICostMatItem']

return KLUICostMatItemView
