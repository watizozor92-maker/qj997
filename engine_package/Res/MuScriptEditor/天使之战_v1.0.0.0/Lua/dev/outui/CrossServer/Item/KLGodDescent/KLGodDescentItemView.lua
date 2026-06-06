---@class KLGodDescentItemView:UIKmlLuaViewBase
---@field panel1 UIKmlLuaControl
---@field Bg UIKmlLuaControl
---@field TitleImg UIKmlLuaControl
---@field TextDesc UIKmlLuaControl
---@field btn_Go UIKmlLuaControl
---@field scroll_Reward UIKmlLuaControl
---@field privilege_reward_list UIKmlLuaControl
---@field dateList_reward UIKmlLuaControl
---@field scroll_Monster UIKmlLuaControl
---@field layout2 UIKmlLuaControl
local KLGodDescentItemView = {}
setmetatable(KLGodDescentItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/CrossServer/Item/KLGodDescent/KLGodDescentItemKml'
---@param parent UIKmlLuaControl
function KLGodDescentItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLGodDescentItemView
