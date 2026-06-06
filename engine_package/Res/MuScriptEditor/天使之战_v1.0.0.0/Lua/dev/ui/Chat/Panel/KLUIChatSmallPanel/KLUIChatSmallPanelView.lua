---@class KLUIChatSmallPanelView:UIKmlLuaViewBase
---@field move_root UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field openBtn UIKmlLuaControlHandler
---@field bgSmall UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field chat_small_view UIKmlLuaControlHandler
---@field chat_small_data_list UIKmlLuaControlHandler
---@field templateRoot UIKmlLuaControlHandler
local KLUIChatSmallPanelView = {}
setmetatable(KLUIChatSmallPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Chat/Panel/KLUIChatSmallPanel/KLUIChatSmallPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIChatSmallPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIChatSmallPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Chat/Panel/KLUIChatSmallPanel/KLUIChatSmallPanel']

return KLUIChatSmallPanelView
