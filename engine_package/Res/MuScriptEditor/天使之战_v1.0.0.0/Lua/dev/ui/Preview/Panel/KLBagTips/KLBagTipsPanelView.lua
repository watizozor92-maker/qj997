---@class KLBagTipsPanelView:UIKmlLuaViewBase
---@field move_root UIKmlLuaControl
---@field MainPanle UIKmlLuaControl
---@field Image UIKmlLuaControl
---@field scroll_text_template UIKmlLuaControl
---@field KmlScrollTextTemplate UIKmlLuaControl
---@field Text UIKmlLuaControl
---@field AttrImage UIKmlLuaControl
---@field AttrText UIKmlLuaControl
---@field Item UIKmlLuaControl
---@field BtnClose UIKmlLuaControl
---@field equiptag UIKmlLuaControl
---@field bagtag UIKmlLuaControl
---@field BtnUse1 UIKmlLuaControl
---@field UseText UIKmlLuaControl
---@field Light UIKmlLuaControl
---@field TimeCountdown UIKmlLuaControl
---@field strengthLevel UIKmlLuaControl
---@field appendLevel UIKmlLuaControl
---@field xinyun UIKmlLuaControl
---@field buttonUseEx UIKmlLuaControl
---@field buttonUseClose UIKmlLuaControl
local KLBagTipsPanelView = {}
setmetatable(KLBagTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Preview/Panel/KLBagTips/KLBagTipsPanelKml'
---@param parent UIKmlLuaControl
function KLBagTipsPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLBagTipsPanelView
