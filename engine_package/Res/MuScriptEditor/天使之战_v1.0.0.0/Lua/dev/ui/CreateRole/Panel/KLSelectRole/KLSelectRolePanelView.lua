---@class KLSelectRolePanelView:UIKmlLuaViewBase
---@field UICreateRolePanel UIKmlLuaControlHandler
---@field createRolePanel UIKmlLuaControlHandler
---@field BackButton UIKmlLuaControlHandler
---@field PlayerRole UIKmlLuaControlHandler
---@field NewCreateButton UIKmlLuaControlHandler
---@field Tips UIKmlLuaControlHandler
---@field tipsMask UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field tipCanelBtn UIKmlLuaControlHandler
---@field tipSureBtn UIKmlLuaControlHandler
---@field tipCloseBtn UIKmlLuaControlHandler
---@field tipStrTxt UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field GameObject UIKmlLuaControlHandler
---@field CreatButton UIKmlLuaControlHandler
---@field Image UIKmlLuaControlHandler
---@field Right (1) UIKmlLuaControlHandler
---@field Left (1) UIKmlLuaControlHandler
---@field StartButton UIKmlLuaControlHandler
---@field PlayerRole_New UIKmlLuaControlHandler
---@field topImg UIKmlLuaControlHandler
---@field text8 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field goBtn UIKmlLuaControlHandler
---@field delBtn UIKmlLuaControlHandler
---@field createBtn UIKmlLuaControlHandler
---@field backBtn UIKmlLuaControlHandler
---@field rightLayout UIKmlLuaControlHandler
---@field leftLayout UIKmlLuaControlHandler
local KLSelectRolePanelView = {}
setmetatable(KLSelectRolePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/CreateRole/Panel/KLSelectRole/KLSelectRolePanelKml'
---@param parent UIKmlLuaControlHandler
function KLSelectRolePanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLSelectRolePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/CreateRole/Panel/KLSelectRole/KLSelectRolePanel']

return KLSelectRolePanelView
