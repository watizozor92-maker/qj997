---@class KLTaskLoopPanelView:UIKmlLuaViewBase
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1231 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field maks UIKmlLuaControlHandler
---@field Text_Title UIKmlLuaControlHandler
---@field BtnClose UIKmlLuaControlHandler
---@field desc1 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
---@field scrollview1 UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field desc2 UIKmlLuaControlHandler
---@field img8 UIKmlLuaControlHandler
---@field text9 UIKmlLuaControlHandler
---@field Smelter UIKmlLuaControlHandler
---@field img11 UIKmlLuaControlHandler
---@field text12 UIKmlLuaControlHandler
---@field button5 UIKmlLuaControlHandler
---@field button6 UIKmlLuaControlHandler
---@field textnumber UIKmlLuaControlHandler
---@field scrollview3 UIKmlLuaControlHandler
---@field gridview4 UIKmlLuaControlHandler
---@field datalist1 UIKmlLuaControlHandler
---@field desc3 UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field submit_item UIKmlLuaControlHandler
---@field panel2 UIKmlLuaControlHandler
---@field xinyun UIKmlLuaControlHandler
---@field strengthLevel UIKmlLuaControlHandler
---@field appendLevel UIKmlLuaControlHandler
---@field quality UIKmlLuaControlHandler
---@field img_add UIKmlLuaControlHandler
---@field btn_add UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field submit_item2 UIKmlLuaControlHandler
---@field btn_item2 UIKmlLuaControlHandler
---@field text10 UIKmlLuaControlHandler
---@field select_panel UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field img9 UIKmlLuaControlHandler
---@field select_title_text UIKmlLuaControlHandler
---@field select_desc UIKmlLuaControlHandler
---@field select_title UIKmlLuaControlHandler
---@field sure_item UIKmlLuaControlHandler
---@field EquipScrollView UIKmlLuaControlHandler
---@field gridview2 UIKmlLuaControlHandler
---@field select_item_list UIKmlLuaControlHandler
---@field close_select UIKmlLuaControlHandler
local KLTaskLoopPanelView = {}
setmetatable(KLTaskLoopPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Task/Panel/KLTaskLoop/KLTaskLoopPanelKml'
---@param parent UIKmlLuaControlHandler
function KLTaskLoopPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLTaskLoopPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Task/Panel/KLTaskLoop/KLTaskLoopPanel']

return KLTaskLoopPanelView
