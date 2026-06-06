---@class KLUIArchangelWelfareItemView:UIKmlLuaViewBase
---@field UIArchangelWelfareTemplate UIKmlLuaControl
---@field DIY_ICON UIKmlLuaControl
---@field giftName UIKmlLuaControl
---@field giftDesc UIKmlLuaControl
---@field remainCount UIKmlLuaControl
---@field taskItemScrollView UIKmlLuaControl
---@field Viewport UIKmlLuaControl
---@field taskItemContent UIKmlLuaControl
---@field loopscrollview UIKmlLuaControl
---@field loopscrolldata UIKmlLuaControl
---@field EffectHighlight UIKmlLuaControl
---@field RawImage UIKmlLuaControl
---@field BtnGo UIKmlLuaControl
---@field Text UIKmlLuaControl
local KLUIArchangelWelfareItemView = {}
setmetatable(KLUIArchangelWelfareItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/OpenServiceArchangelWelfare/Item/KLUIArchangelWelfare/KLUIArchangelWelfareItemKml'
---@param parent UIKmlLuaControl
function KLUIArchangelWelfareItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIArchangelWelfareItemView
