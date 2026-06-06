---@class KLDisplayPanelView:UIKmlLuaViewBase
---@field Content UIKmlLuaControlHandler
---@field scrollview28 UIKmlLuaControlHandler
---@field layout29 UIKmlLuaControlHandler
---@field panel31 UIKmlLuaControlHandler
---@field tog_limitPlayeNum UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field slider_playerNum UIKmlLuaControlHandler
---@field playerCount UIKmlLuaControlHandler
---@field barPointer UIKmlLuaControlHandler
---@field AutoSettingTitle UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field text6 UIKmlLuaControlHandler
---@field AutoSetting1 UIKmlLuaControlHandler
---@field layout UIKmlLuaControlHandler
---@field tog_powerSaving1 UIKmlLuaControlHandler
---@field text9 UIKmlLuaControlHandler
---@field tog_powerSaving2 UIKmlLuaControlHandler
---@field text11 UIKmlLuaControlHandler
---@field tog_powerSaving3 UIKmlLuaControlHandler
---@field text13 UIKmlLuaControlHandler
---@field SceneAudio UIKmlLuaControlHandler
---@field panel19 UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field hidePlayerModelToggle UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field hidePlayerModelTxt UIKmlLuaControlHandler
---@field panel20 UIKmlLuaControlHandler
---@field text8 UIKmlLuaControlHandler
---@field hidePlayerSkillEffectToggle UIKmlLuaControlHandler
---@field img9 UIKmlLuaControlHandler
---@field hidePlayerSkillEffectTxt UIKmlLuaControlHandler
---@field panel21 UIKmlLuaControlHandler
---@field text12 UIKmlLuaControlHandler
---@field hidePlayerWingToggle UIKmlLuaControlHandler
---@field img13 UIKmlLuaControlHandler
---@field hidePlayerWingTxt UIKmlLuaControlHandler
---@field panel26 UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
---@field hideMonsterSkillEffect UIKmlLuaControlHandler
---@field panel22 UIKmlLuaControlHandler
---@field text16 UIKmlLuaControlHandler
---@field hideMeWingToggle UIKmlLuaControlHandler
---@field img17 UIKmlLuaControlHandler
---@field hideMeWingTxt UIKmlLuaControlHandler
---@field panel23 UIKmlLuaControlHandler
---@field text20 UIKmlLuaControlHandler
---@field hidePlayerFootprintToggle UIKmlLuaControlHandler
---@field img21 UIKmlLuaControlHandler
---@field hidePlayerFootprintTxt UIKmlLuaControlHandler
---@field panel24 UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field hidePetModel UIKmlLuaControlHandler
---@field panel25 UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
---@field hideMonsterModel UIKmlLuaControlHandler
---@field SceneAudioTitle UIKmlLuaControlHandler
---@field img15 UIKmlLuaControlHandler
---@field text17 UIKmlLuaControlHandler
---@field PlayerShowTitle UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field text5 UIKmlLuaControlHandler
---@field selectMenu UIKmlLuaControlHandler
---@field layout4 UIKmlLuaControlHandler
---@field noHideBtn UIKmlLuaControlHandler
---@field hideAllBtn UIKmlLuaControlHandler
---@field hideUnioBtn UIKmlLuaControlHandler
---@field hideEnemyBtn UIKmlLuaControlHandler
---@field panel1 UIKmlLuaControlHandler
---@field text7 UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field slider_camera UIKmlLuaControlHandler
---@field txtCamera UIKmlLuaControlHandler
---@field barCamera UIKmlLuaControlHandler
---@field BtnReDefaultDispaly UIKmlLuaControlHandler
local KLDisplayPanelView = {}
setmetatable(KLDisplayPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Setting/Panel/KLDisplay/KLDisplayPanelKml'
---@param parent UIKmlLuaControlHandler
function KLDisplayPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLDisplayPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Setting/Panel/KLDisplay/KLDisplayPanel']

return KLDisplayPanelView
