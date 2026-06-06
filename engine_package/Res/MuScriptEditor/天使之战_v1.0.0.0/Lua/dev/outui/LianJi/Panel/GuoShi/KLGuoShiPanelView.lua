---@class KLGuoShiPanelView:UIKmlLuaViewBase
---@field panel UIKmlLuaControl
---@field BG UIKmlLuaControl
---@field img2 UIKmlLuaControl
---@field text1 UIKmlLuaControl
---@field close UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field img6 UIKmlLuaControl
---@field item1 UIKmlLuaControl
---@field img4 UIKmlLuaControl
---@field cur_rate UIKmlLuaControl
---@field item2 UIKmlLuaControl
---@field img5 UIKmlLuaControl
---@field cur_sd UIKmlLuaControl
---@field SD_Max UIKmlLuaControl
---@field SD_Max_Value UIKmlLuaControl
---@field LianJiRate_Max UIKmlLuaControl
---@field LianJiRate_Max_Value UIKmlLuaControl
---@field img7 UIKmlLuaControl
---@field text8 UIKmlLuaControl
---@field rate_item UIKmlLuaControl
---@field sd_item UIKmlLuaControl
local KLGuoShiPanelView = {}
setmetatable(KLGuoShiPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/LianJi/Panel/GuoShi/KLGuoShiPanelKml'
---@param parent UIKmlLuaControl
function KLGuoShiPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLGuoShiPanelView
