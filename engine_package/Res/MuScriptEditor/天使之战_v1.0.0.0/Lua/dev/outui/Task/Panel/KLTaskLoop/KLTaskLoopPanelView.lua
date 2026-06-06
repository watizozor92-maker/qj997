---@class KLTaskLoopPanelView:UIKmlLuaViewBase
---@field BG_Templete UIKmlLuaControl
---@field ReMask UIKmlLuaControl
---@field img1231 UIKmlLuaControl
---@field Frame UIKmlLuaControl
---@field img5 UIKmlLuaControl
---@field maks UIKmlLuaControl
---@field Text_Title UIKmlLuaControl
---@field BtnClose UIKmlLuaControl
---@field desc1 UIKmlLuaControl
---@field img2 UIKmlLuaControl
---@field text3 UIKmlLuaControl
---@field scrollview1 UIKmlLuaControl
---@field layout2 UIKmlLuaControl
---@field desc2 UIKmlLuaControl
---@field img8 UIKmlLuaControl
---@field text9 UIKmlLuaControl
---@field Smelter UIKmlLuaControl
---@field img11 UIKmlLuaControl
---@field text12 UIKmlLuaControl
---@field button5 UIKmlLuaControl
---@field button6 UIKmlLuaControl
---@field textnumber UIKmlLuaControl
---@field scrollview3 UIKmlLuaControl
---@field gridview4 UIKmlLuaControl
---@field datalist1 UIKmlLuaControl
---@field desc3 UIKmlLuaControl
---@field img4 UIKmlLuaControl
---@field submit_item UIKmlLuaControl
---@field panel2 UIKmlLuaControl
---@field xinyun UIKmlLuaControl
---@field strengthLevel UIKmlLuaControl
---@field appendLevel UIKmlLuaControl
---@field quality UIKmlLuaControl
---@field img_add UIKmlLuaControl
---@field btn_add UIKmlLuaControl
---@field img6 UIKmlLuaControl
---@field submit_item2 UIKmlLuaControl
---@field btn_item2 UIKmlLuaControl
---@field text10 UIKmlLuaControl
---@field select_panel UIKmlLuaControl
---@field img7 UIKmlLuaControl
---@field img9 UIKmlLuaControl
---@field select_title_text UIKmlLuaControl
---@field select_desc UIKmlLuaControl
---@field select_title UIKmlLuaControl
---@field sure_item UIKmlLuaControl
---@field EquipScrollView UIKmlLuaControl
---@field gridview2 UIKmlLuaControl
---@field select_item_list UIKmlLuaControl
---@field close_select UIKmlLuaControl
local KLTaskLoopPanelView = {}
setmetatable(KLTaskLoopPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Task/Panel/KLTaskLoop/KLTaskLoopPanelKml'
---@param parent UIKmlLuaControl
function KLTaskLoopPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLTaskLoopPanelView
