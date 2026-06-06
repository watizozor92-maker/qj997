---@class KLUICareerSwitchPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControl
---@field title UIKmlLuaControl
---@field des UIKmlLuaControl
---@field cancelBtn UIKmlLuaControl
---@field okBtn UIKmlLuaControl
---@field closeBtn UIKmlLuaControl
local KLUICareerSwitchPanelView = {}
setmetatable(KLUICareerSwitchPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/CareerSwitch/Panel/KLUICareerSwitch/KLUICareerSwitchPanelKml'
---@param parent UIKmlLuaControl
function KLUICareerSwitchPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLUICareerSwitchPanelView
