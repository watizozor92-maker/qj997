---@class KLNewNewSynthesisCostItemView:UIKmlLuaViewBase
---@field Content UIKmlLuaControl
---@field item UIKmlLuaControl
---@field equipInfo UIKmlLuaControl
---@field xinyun UIKmlLuaControl
---@field strengthLevel UIKmlLuaControl
---@field appendLevel UIKmlLuaControl
---@field quality UIKmlLuaControl
---@field Img_Bind UIKmlLuaControl
---@field icon_Bind UIKmlLuaControl
---@field Btn_Add UIKmlLuaControl
---@field Img_Add UIKmlLuaControl
---@field Img_Unknown UIKmlLuaControl
---@field Count UIKmlLuaControl
---@field Text_Count UIKmlLuaControl
local KLNewNewSynthesisCostItemView = {}
setmetatable(KLNewNewSynthesisCostItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Synthesis/Item/KLNewNewSynthesisCost/KLNewNewSynthesisCostItemKml'
---@param parent UIKmlLuaControl
function KLNewNewSynthesisCostItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLNewNewSynthesisCostItemView
