---@class KLUIChallengeBossItemView:UIKmlLuaViewBase
---@field img_select UIKmlLuaControlHandler
---@field img_112 UIKmlLuaControlHandler
---@field name UIKmlLuaControlHandler
---@field monster_root UIKmlLuaControlHandler
---@field monster UIKmlLuaControlHandler
---@field line_root UIKmlLuaControlHandler
---@field scrollview_115 UIKmlLuaControlHandler
---@field line_data_list UIKmlLuaControlHandler
---@field Integral_BG UIKmlLuaControlHandler
---@field Integral_Text UIKmlLuaControlHandler
local KLUIChallengeBossItemView = {}
setmetatable(KLUIChallengeBossItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLUIChallengeBossItem/KLUIChallengeBossItemKml'
---@param parent UIKmlLuaControlHandler
function KLUIChallengeBossItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIChallengeBossItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ChallengeBoss/Item/KLUIChallengeBossItem/KLUIChallengeBossItem']

return KLUIChallengeBossItemView
