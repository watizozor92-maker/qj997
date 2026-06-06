---@class KLUISystemLeftPanelView:UIKmlLuaViewBase
---@field move_root UIKmlLuaControlHandler
---@field foldBtn UIKmlLuaControlHandler
---@field bagBtn2 UIKmlLuaControlHandler
---@field maxBagTips UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field maxTipsCloseBtn UIKmlLuaControlHandler
---@field notice UIKmlLuaControlHandler
---@field notice1 UIKmlLuaControlHandler
---@field equipRecycleBtn UIKmlLuaControlHandler
---@field autoRecycleBtn UIKmlLuaControlHandler
---@field notNoticeToggle UIKmlLuaControlHandler
---@field notNoticeToggleText UIKmlLuaControlHandler
---@field arrow UIKmlLuaControlHandler
---@field hookRoot UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field bgmask UIKmlLuaControlHandler
---@field img_new_hook UIKmlLuaControlHandler
---@field autoHookIconContainer_2 UIKmlLuaControlHandler
---@field img_auto_2_close UIKmlLuaControlHandler
---@field autoMaxIcon_2 UIKmlLuaControlHandler
---@field autoMinIcon_2 UIKmlLuaControlHandler
---@field btn_hook_in_icon UIKmlLuaControlHandler
---@field btn_hook_in UIKmlLuaControlHandler
---@field hookBtn UIKmlLuaControlHandler
---@field autoHookIconContainer UIKmlLuaControlHandler
---@field autoMaxIcon UIKmlLuaControlHandler
---@field autoMinIcon UIKmlLuaControlHandler
---@field autoTxtIcon UIKmlLuaControlHandler
---@field btn_hook_out_icon UIKmlLuaControlHandler
---@field btn_hook_out UIKmlLuaControlHandler
---@field expandBtn UIKmlLuaControlHandler
---@field shapeShiftRoot UIKmlLuaControlHandler
---@field img_shift_bg UIKmlLuaControlHandler
---@field layout_37 UIKmlLuaControlHandler
---@field btn_shift_1 UIKmlLuaControlHandler
---@field img_shift_icon_1 UIKmlLuaControlHandler
---@field Img_cdTime_1 UIKmlLuaControlHandler
---@field btn_shift_2 UIKmlLuaControlHandler
---@field img_shift_icon_2 UIKmlLuaControlHandler
---@field Img_cdTime_2 UIKmlLuaControlHandler
---@field btn_shift_3 UIKmlLuaControlHandler
---@field img_shift_icon_3 UIKmlLuaControlHandler
---@field Img_cdTime_3 UIKmlLuaControlHandler
---@field btn_shift UIKmlLuaControlHandler
---@field btn_shift_cancel UIKmlLuaControlHandler
---@field circlebar_cancel UIKmlLuaControlHandler
---@field systemArea UIKmlLuaControlHandler
---@field systemMenu UIKmlLuaControlHandler
local KLUISystemLeftPanelView = {}
setmetatable(KLUISystemLeftPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/MainUI/Panel/KLUISystemLeft/KLUISystemLeftPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUISystemLeftPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUISystemLeftPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/MainUI/Panel/KLUISystemLeft/KLUISystemLeftPanel']

return KLUISystemLeftPanelView
