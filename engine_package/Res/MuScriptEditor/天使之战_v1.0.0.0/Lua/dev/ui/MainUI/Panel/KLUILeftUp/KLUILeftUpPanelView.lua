---@class KLUILeftUpPanelView:UIKmlLuaViewBase
---@field move_root UIKmlLuaControlHandler
---@field activityRoot UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field palyerInfo UIKmlLuaControlHandler
---@field combat_powerBg UIKmlLuaControlHandler
---@field combat_powerIcon UIKmlLuaControlHandler
---@field combat_power UIKmlLuaControlHandler
---@field defenseIcon UIKmlLuaControlHandler
---@field defense UIKmlLuaControlHandler
---@field toggleGroupTop UIKmlLuaControlHandler
---@field taskToggle UIKmlLuaControlHandler
---@field teamToggle UIKmlLuaControlHandler
---@field tabObjRoot UIKmlLuaControlHandler
---@field kingOfRoadIcon UIKmlLuaControlHandler
---@field effect_tishi UIKmlLuaControlHandler
---@field kingOfRoadItem UIKmlLuaControlHandler
---@field count UIKmlLuaControlHandler
---@field shi_zhuang_ren_wu UIKmlLuaControlHandler
---@field topRoot UIKmlLuaControlHandler
---@field Btn_OnHook UIKmlLuaControlHandler
---@field Btn_AutoFight UIKmlLuaControlHandler
---@field Model_AutoFightEff UIKmlLuaControlHandler
---@field expanfBg UIKmlLuaControlHandler
---@field expandBtn UIKmlLuaControlHandler
---@field foldBtn UIKmlLuaControlHandler
local KLUILeftUpPanelView = {}
setmetatable(KLUILeftUpPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/MainUI/Panel/KLUILeftUp/KLUILeftUpPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUILeftUpPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUILeftUpPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/MainUI/Panel/KLUILeftUp/KLUILeftUpPanel']

return KLUILeftUpPanelView
