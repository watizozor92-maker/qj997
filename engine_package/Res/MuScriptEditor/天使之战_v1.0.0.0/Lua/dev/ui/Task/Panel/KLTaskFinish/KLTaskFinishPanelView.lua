---@class KLTaskFinishPanelView:UIKmlLuaViewBase
---@field img_1067 UIKmlLuaControl
---@field task_award_prefab UIKmlLuaControl
---@field BtnClose UIKmlLuaControl
---@field img10 UIKmlLuaControl
---@field img9 UIKmlLuaControl
---@field img8 UIKmlLuaControl
---@field img7 UIKmlLuaControl
---@field text6 UIKmlLuaControl
---@field img5 UIKmlLuaControl
---@field text4 UIKmlLuaControl
---@field button3 UIKmlLuaControl
---@field img2 UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field BtnGet UIKmlLuaControl
---@field LabelDesc UIKmlLuaControl
---@field Content UIKmlLuaControl
---@field award_list UIKmlLuaControl
---@field LabelTask UIKmlLuaControl
---@field UITaskAwardPanel_old UIKmlLuaControl
---@field text11 UIKmlLuaControl
---@field img12 UIKmlLuaControl
local KLTaskFinishPanelView = {}
setmetatable(KLTaskFinishPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Task/Panel/KLTaskFinish/KLTaskFinishPanelKml'
---@param parent UIKmlLuaControl
function KLTaskFinishPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLTaskFinishPanelView
