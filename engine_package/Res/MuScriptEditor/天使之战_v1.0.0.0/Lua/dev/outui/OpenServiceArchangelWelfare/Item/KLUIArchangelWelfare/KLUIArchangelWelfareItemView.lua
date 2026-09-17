---@class KLUIArchangelWelfareItemView:UIKmlLuaViewBase
---@field UIArchangelWelfareTemplate UIKmlLuaControlHandler
---@field DIY_ICON UIKmlLuaControlHandler
---@field giftName UIKmlLuaControlHandler
---@field giftDesc UIKmlLuaControlHandler
---@field remainCount UIKmlLuaControlHandler
---@field taskItemScrollView UIKmlLuaControlHandler
---@field Viewport UIKmlLuaControlHandler
---@field taskItemContent UIKmlLuaControlHandler
---@field loopscrollview UIKmlLuaControlHandler
---@field loopscrolldata UIKmlLuaControlHandler
---@field EffectHighlight UIKmlLuaControlHandler
---@field RawImage UIKmlLuaControlHandler
---@field BtnGo UIKmlLuaControlHandler
---@field Text UIKmlLuaControlHandler
local KLUIArchangelWelfareItemView = {}
setmetatable(KLUIArchangelWelfareItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/OpenServiceArchangelWelfare/Item/KLUIArchangelWelfare/KLUIArchangelWelfareItemKml'
---@param parent UIKmlLuaControlHandler
function KLUIArchangelWelfareItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIArchangelWelfareItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/OpenServiceArchangelWelfare/Item/KLUIArchangelWelfare/KLUIArchangelWelfareItem']

return KLUIArchangelWelfareItemView
