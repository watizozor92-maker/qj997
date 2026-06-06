---@class KLFirstDropPanelView:UIKmlLuaViewBase
---@field img1 UIKmlLuaControl
---@field img3 UIKmlLuaControl
---@field img7 UIKmlLuaControl
---@field text1 UIKmlLuaControl
---@field txt_desc UIKmlLuaControl
---@field img10 UIKmlLuaControl
---@field content_scroll2 UIKmlLuaControl
---@field content_layout_scroll2 UIKmlLuaControl
---@field contentlist2 UIKmlLuaControl
---@field img2 UIKmlLuaControl
---@field img6 UIKmlLuaControl
---@field togglegroup4 UIKmlLuaControl
---@field layout3 UIKmlLuaControl
---@field toggle1 UIKmlLuaControl
---@field text6 UIKmlLuaControl
---@field toggle2 UIKmlLuaControl
---@field text7 UIKmlLuaControl
---@field toggle3 UIKmlLuaControl
---@field text8 UIKmlLuaControl
---@field img4 UIKmlLuaControl
---@field text5 UIKmlLuaControl
---@field text2 UIKmlLuaControl
---@field text3 UIKmlLuaControl
---@field text4 UIKmlLuaControl
---@field img5 UIKmlLuaControl
---@field loopscrollview2 UIKmlLuaControl
---@field datalist UIKmlLuaControl
---@field close_btn UIKmlLuaControl
local KLFirstDropPanelView = {}
setmetatable(KLFirstDropPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/FirstDrop/Panel/KLFirstDrop/KLFirstDropPanelKml'
---@param parent UIKmlLuaControl
function KLFirstDropPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLFirstDropPanelView
