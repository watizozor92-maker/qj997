---@class KLBasicPanelView:UIKmlLuaViewBase
---@field img1 UIKmlLuaControlHandler
---@field bgSliderImg UIKmlLuaControlHandler
---@field soundSliderImg UIKmlLuaControlHandler
---@field prefab_751 UIKmlLuaControlHandler
---@field KmlBasicSettingUI UIKmlLuaControlHandler
---@field joyStickSetting UIKmlLuaControlHandler
---@field tog_autoFix UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field icon_autoFix UIKmlLuaControlHandler
---@field tile1 UIKmlLuaControlHandler
---@field fixedJoyStick UIKmlLuaControlHandler
---@field fixedJoyStickTxt UIKmlLuaControlHandler
---@field bgSlider UIKmlLuaControlHandler
---@field Background1 UIKmlLuaControlHandler
---@field bgBarPointer UIKmlLuaControlHandler
---@field moveJoyStick UIKmlLuaControlHandler
---@field moveJoyStickTxt UIKmlLuaControlHandler
---@field soundSlider UIKmlLuaControlHandler
---@field Background2 UIKmlLuaControlHandler
---@field soundBarPointer UIKmlLuaControlHandler
---@field tile2 UIKmlLuaControlHandler
---@field clickFloor UIKmlLuaControlHandler
---@field clickFloorTxt UIKmlLuaControlHandler
---@field BtnRoleChose UIKmlLuaControlHandler
---@field TitleLockImage UIKmlLuaControlHandler
---@field TitleLock UIKmlLuaControlHandler
---@field BtnLock UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field BtnExitGame UIKmlLuaControlHandler
---@field BtnReDefault2 UIKmlLuaControlHandler
---@field BtnReDefault UIKmlLuaControlHandler
---@field TitleSetImage UIKmlLuaControlHandler
---@field TitleSetText UIKmlLuaControlHandler
---@field TitleSet UIKmlLuaControlHandler
---@field TitleFirstImage UIKmlLuaControlHandler
---@field TitleFirstText UIKmlLuaControlHandler
---@field TitleFirst UIKmlLuaControlHandler
---@field TitleLockText UIKmlLuaControlHandler
---@field LockText UIKmlLuaControlHandler
local KLBasicPanelView = {}
setmetatable(KLBasicPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Setting/Panel/KLBasic/KLBasicPanelKml'
---@param parent UIKmlLuaControlHandler
function KLBasicPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLBasicPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Setting/Panel/KLBasic/KLBasicPanel']

return KLBasicPanelView
