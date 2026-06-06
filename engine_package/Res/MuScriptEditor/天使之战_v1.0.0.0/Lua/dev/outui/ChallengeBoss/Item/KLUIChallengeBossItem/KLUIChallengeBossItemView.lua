---@class KLUIChallengeBossItemView:UIKmlLuaViewBase
---@field img_select UIKmlLuaControl
---@field img_112 UIKmlLuaControl
---@field name UIKmlLuaControl
---@field monster_root UIKmlLuaControl
---@field monster UIKmlLuaControl
---@field line_root UIKmlLuaControl
---@field scrollview_115 UIKmlLuaControl
---@field line_data_list UIKmlLuaControl
---@field Integral_BG UIKmlLuaControl
---@field Integral_Text UIKmlLuaControl
local KLUIChallengeBossItemView = {}
setmetatable(KLUIChallengeBossItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLUIChallengeBossItem/KLUIChallengeBossItemKml'
---@param parent UIKmlLuaControl
function KLUIChallengeBossItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIChallengeBossItemView
