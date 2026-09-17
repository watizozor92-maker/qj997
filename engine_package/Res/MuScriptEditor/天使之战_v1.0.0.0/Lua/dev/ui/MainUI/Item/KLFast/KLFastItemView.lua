---@class KLFastItemView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field shortcut_item UIKmlLuaControlHandler
---@field count_attach1 UIKmlLuaControlHandler
---@field noItem UIKmlLuaControlHandler
---@field fastItemTip UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field btnTips UIKmlLuaControlHandler
---@field useBtn UIKmlLuaControlHandler
---@field panel1 UIKmlLuaControlHandler
---@field add_img_0 UIKmlLuaControlHandler
---@field light1 UIKmlLuaControlHandler
---@field add_img UIKmlLuaControlHandler
---@field control_circlebar UIKmlLuaControlHandler
local KLFastItemView = {}
setmetatable(KLFastItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/MainUI/Item/KLFast/KLFastItemKml'
---@param parent UIKmlLuaControlHandler
function KLFastItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLFastItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/MainUI/Item/KLFast/KLFastItem']

return KLFastItemView
