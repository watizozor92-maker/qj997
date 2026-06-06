---@class KLNewNewSynthesisCostSelectItemView:UIKmlLuaViewBase
---@field item UIKmlLuaControl
---@field equipInfo UIKmlLuaControl
---@field xinyun UIKmlLuaControl
---@field strengthLevel UIKmlLuaControl
---@field appendLevel UIKmlLuaControl
---@field quality UIKmlLuaControl
---@field Img_Bind UIKmlLuaControl
---@field icon_Bind UIKmlLuaControl
---@field select UIKmlLuaControl
---@field item_click UIKmlLuaControl
local KLNewNewSynthesisCostSelectItemView = {}
setmetatable(KLNewNewSynthesisCostSelectItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Synthesis/Item/KLNewNewSynthesisCostSelect/KLNewNewSynthesisCostSelectItemKml'
---@param parent UIKmlLuaControl
function KLNewNewSynthesisCostSelectItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLNewNewSynthesisCostSelectItemView
