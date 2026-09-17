---@class KLWolfSoulFortressSummonItemView:UIKmlLuaViewBase
---@field root UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field rank UIKmlLuaControlHandler
---@field name UIKmlLuaControlHandler
---@field btnSummon UIKmlLuaControlHandler
---@field model UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field specialBg UIKmlLuaControlHandler
---@field textSpecial UIKmlLuaControlHandler
---@field specialBg_2 UIKmlLuaControlHandler
---@field textSpecial_2 UIKmlLuaControlHandler
local KLWolfSoulFortressSummonItemView = {}
setmetatable(KLWolfSoulFortressSummonItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Item/KLWolfSoulFortressSummon/KLWolfSoulFortressSummonItemKml'
---@param parent UIKmlLuaControlHandler
function KLWolfSoulFortressSummonItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLWolfSoulFortressSummonItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Item/KLWolfSoulFortressSummon/KLWolfSoulFortressSummonItem']

return KLWolfSoulFortressSummonItemView
