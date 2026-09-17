---@class KLBagTipsPanelView:UIKmlLuaViewBase
---@field move_root UIKmlLuaControlHandler
---@field MainPanle UIKmlLuaControlHandler
---@field Image UIKmlLuaControlHandler
---@field BtnClose UIKmlLuaControlHandler
---@field scroll_text_template UIKmlLuaControlHandler
---@field KmlScrollTextTemplate UIKmlLuaControlHandler
---@field Text UIKmlLuaControlHandler
---@field bagtag UIKmlLuaControlHandler
---@field BtnUse1 UIKmlLuaControlHandler
---@field UseText UIKmlLuaControlHandler
---@field Light UIKmlLuaControlHandler
---@field AttrImage UIKmlLuaControlHandler
---@field AttrText UIKmlLuaControlHandler
---@field Item UIKmlLuaControlHandler
---@field equiptag UIKmlLuaControlHandler
---@field TimeCountdown UIKmlLuaControlHandler
---@field strengthLevel UIKmlLuaControlHandler
---@field appendLevel UIKmlLuaControlHandler
---@field xinyun UIKmlLuaControlHandler
---@field buttonUseEx UIKmlLuaControlHandler
---@field buttonUseClose UIKmlLuaControlHandler
local KLBagTipsPanelView = {}
setmetatable(KLBagTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Preview/Panel/KLBagTips/KLBagTipsPanelKml'
---@param parent UIKmlLuaControlHandler
function KLBagTipsPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLBagTipsPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Preview/Panel/KLBagTips/KLBagTipsPanel']

return KLBagTipsPanelView
