---@class  KLGodCountryPanellView:UIKmlLuaViewBase
---@field root_panel UIKmlLuaControl
---@field trade_bg UIKmlLuaControl
---@field img_interface UIKmlLuaControl
---@field btn_close UIKmlLuaControl

local  KLGodCountryPanellView = {}
setmetatable( KLGodCountryPanellView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/CrossServer/Panel/KLGodCountry/KLGodCountryPanelKml'
 KLGodCountryPanellView.content = CS.TCFramework.LuaManager.LoadFileText(kmlPath,nil,'.txt')
---@param parent UIKmlLuaControl
function  KLGodCountryPanellView:Init(parent)
    
    self:InitRoot(parent,kmlPath, KLGodCountryPanellView.content)
end
return  KLGodCountryPanellView
