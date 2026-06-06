---@class KLWolfSoulFortressSummonItemView:UIKmlLuaViewBase
---@field root UIKmlLuaControl
---@field img3 UIKmlLuaControl
---@field rank UIKmlLuaControl
---@field name UIKmlLuaControl
---@field btnSummon UIKmlLuaControl
---@field model UIKmlLuaControl
---@field layout2 UIKmlLuaControl
---@field specialBg UIKmlLuaControl
---@field textSpecial UIKmlLuaControl
---@field specialBg_2 UIKmlLuaControl
---@field textSpecial_2 UIKmlLuaControl
local KLWolfSoulFortressSummonItemView = {}
setmetatable(KLWolfSoulFortressSummonItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Item/KLWolfSoulFortressSummon/KLWolfSoulFortressSummonItemKml'
---@param parent UIKmlLuaControl
function KLWolfSoulFortressSummonItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLWolfSoulFortressSummonItemView
