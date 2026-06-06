---@class KLItemGetPathPanelView:UIKmlLuaViewBase
---@field closeBg UIKmlLuaControlHandler
---@field rootBG UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field gainList UIKmlLuaControlHandler
---@field gainGrid UIKmlLuaControlHandler
---@field gainData_list UIKmlLuaControlHandler
local KLItemGetPathPanelView = {}
setmetatable(KLItemGetPathPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Common/Panel/KLItemGetPath/KLItemGetPathPanelKml'
---@param parent UIKmlLuaControlHandler
function KLItemGetPathPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLItemGetPathPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Common/Panel/KLItemGetPath/KLItemGetPathPanel']

return KLItemGetPathPanelView
