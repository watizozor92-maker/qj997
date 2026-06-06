---@class KLOpenServiceGiftItemView:UIKmlLuaViewBase
---@field bg UIKmlLuaControl
---@field SpLight UIKmlLuaControl
---@field ItemIcon UIKmlLuaControl
---@field ItemTex UIKmlLuaControl
---@field text5 UIKmlLuaControl
---@field redDot UIKmlLuaControl
---@field bg_Btn UIKmlLuaControl
---@field get UIKmlLuaControl
local KLOpenServiceGiftItemView = {}
setmetatable(KLOpenServiceGiftItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/OpenService/Item/KLOpenServiceGift/KLOpenServiceGiftItemKml'
---@param parent UIKmlLuaControl
function KLOpenServiceGiftItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLOpenServiceGiftItemView
