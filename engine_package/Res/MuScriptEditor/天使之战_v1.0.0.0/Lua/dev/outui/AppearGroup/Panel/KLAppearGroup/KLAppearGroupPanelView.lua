---@class KLAppearGroupPanelView:UIKmlLuaViewBase
---@field TogGroup UIKmlLuaControlHandler
---@field TogList UIKmlLuaControlHandler
---@field TogAppear UIKmlLuaControlHandler
---@field TogTitle UIKmlLuaControlHandler
---@field TogBox UIKmlLuaControlHandler
---@field TogChange UIKmlLuaControlHandler
---@field TogRender UIKmlLuaControlHandler
---@field panel1 UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field TopPanel UIKmlLuaControlHandler
---@field Text_Title UIKmlLuaControlHandler
---@field Btn_Close UIKmlLuaControlHandler
local KLAppearGroupPanelView = {}
setmetatable(KLAppearGroupPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/AppearGroup/Panel/KLAppearGroup/KLAppearGroupPanelKml'
---@param parent UIKmlLuaControlHandler
function KLAppearGroupPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLAppearGroupPanelView
