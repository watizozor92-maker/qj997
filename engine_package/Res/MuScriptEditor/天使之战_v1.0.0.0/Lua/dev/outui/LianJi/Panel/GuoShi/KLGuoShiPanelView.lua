---@class KLGuoShiPanelView:UIKmlLuaViewBase
---@field panel UIKmlLuaControlHandler
---@field BG UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field close UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field item1 UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field cur_rate UIKmlLuaControlHandler
---@field item2 UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field cur_sd UIKmlLuaControlHandler
---@field SD_Max UIKmlLuaControlHandler
---@field SD_Max_Value UIKmlLuaControlHandler
---@field LianJiRate_Max UIKmlLuaControlHandler
---@field LianJiRate_Max_Value UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field text8 UIKmlLuaControlHandler
---@field rate_item UIKmlLuaControlHandler
---@field sd_item UIKmlLuaControlHandler
local KLGuoShiPanelView = {}
setmetatable(KLGuoShiPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/LianJi/Panel/GuoShi/KLGuoShiPanelKml'
---@param parent UIKmlLuaControlHandler
function KLGuoShiPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLGuoShiPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/LianJi/Panel/GuoShi/KLGuoShiPanel']

return KLGuoShiPanelView
