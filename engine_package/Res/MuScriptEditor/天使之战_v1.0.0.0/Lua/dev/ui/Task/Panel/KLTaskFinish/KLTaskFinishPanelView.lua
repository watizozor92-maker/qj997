---@class KLTaskFinishPanelView:UIKmlLuaViewBase
---@field img_1067 UIKmlLuaControlHandler
---@field task_award_prefab UIKmlLuaControlHandler
---@field BtnClose UIKmlLuaControlHandler
---@field UITaskAwardPanel_old UIKmlLuaControlHandler
---@field LabelTask UIKmlLuaControlHandler
---@field Content UIKmlLuaControlHandler
---@field award_list UIKmlLuaControlHandler
---@field LabelDesc UIKmlLuaControlHandler
---@field BtnGet UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field button3 UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field text6 UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field img8 UIKmlLuaControlHandler
---@field img9 UIKmlLuaControlHandler
---@field img10 UIKmlLuaControlHandler
---@field text11 UIKmlLuaControlHandler
---@field img12 UIKmlLuaControlHandler
local KLTaskFinishPanelView = {}
setmetatable(KLTaskFinishPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Task/Panel/KLTaskFinish/KLTaskFinishPanelKml'
---@param parent UIKmlLuaControlHandler
function KLTaskFinishPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLTaskFinishPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Task/Panel/KLTaskFinish/KLTaskFinishPanel']

return KLTaskFinishPanelView
