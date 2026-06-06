---@class KLJoyStickPanelView:UIKmlLuaViewBase
---@field move_root UIKmlLuaControlHandler
---@field JoyStickBg UIKmlLuaControlHandler
---@field JoyStickBgSmall UIKmlLuaControlHandler
---@field JoyStick UIKmlLuaControlHandler
local KLJoyStickPanelView = {}
setmetatable(KLJoyStickPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/MainUI/Panel/KLJoyStick/KLJoyStickPanelKml'
---@param parent UIKmlLuaControlHandler
function KLJoyStickPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLJoyStickPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/MainUI/Panel/KLJoyStick/KLJoyStickPanel']

return KLJoyStickPanelView
