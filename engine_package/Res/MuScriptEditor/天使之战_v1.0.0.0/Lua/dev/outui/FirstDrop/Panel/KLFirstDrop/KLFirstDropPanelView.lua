---@class KLFirstDropPanelView:UIKmlLuaViewBase
---@field img1 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field txt_desc UIKmlLuaControlHandler
---@field img10 UIKmlLuaControlHandler
---@field content_scroll2 UIKmlLuaControlHandler
---@field content_layout_scroll2 UIKmlLuaControlHandler
---@field contentlist2 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field togglegroup4 UIKmlLuaControlHandler
---@field layout3 UIKmlLuaControlHandler
---@field toggle1 UIKmlLuaControlHandler
---@field text6 UIKmlLuaControlHandler
---@field toggle2 UIKmlLuaControlHandler
---@field text7 UIKmlLuaControlHandler
---@field toggle3 UIKmlLuaControlHandler
---@field text8 UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field text5 UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field loopscrollview2 UIKmlLuaControlHandler
---@field datalist UIKmlLuaControlHandler
---@field close_btn UIKmlLuaControlHandler
local KLFirstDropPanelView = {}
setmetatable(KLFirstDropPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/FirstDrop/Panel/KLFirstDrop/KLFirstDropPanelKml'
---@param parent UIKmlLuaControlHandler
function KLFirstDropPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLFirstDropPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/FirstDrop/Panel/KLFirstDrop/KLFirstDropPanel']

return KLFirstDropPanelView
