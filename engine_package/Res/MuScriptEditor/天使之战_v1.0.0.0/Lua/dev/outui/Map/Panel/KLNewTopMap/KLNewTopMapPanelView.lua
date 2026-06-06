---@class KLNewTopMapPanelView:UIKmlLuaViewBase
---@field move_root UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field layout6 UIKmlLuaControlHandler
---@field Text_playerName UIKmlLuaControlHandler
---@field Text_playerLevel UIKmlLuaControlHandler
---@field Text_MapName UIKmlLuaControlHandler
---@field Btn_SwitchLine UIKmlLuaControlHandler
---@field Btn_Map UIKmlLuaControlHandler
---@field btn_pkMode UIKmlLuaControlHandler
---@field open_transfer2 UIKmlLuaControlHandler
---@field open_transfer UIKmlLuaControlHandler
---@field maptransfer_panel UIKmlLuaControlHandler
---@field close_transfer UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field text6 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field TransferScrollView UIKmlLuaControlHandler
---@field TransferList UIKmlLuaControlHandler
---@field btnBg UIKmlLuaControlHandler
---@field layout3 UIKmlLuaControlHandler
---@field btn_autoFight UIKmlLuaControlHandler
---@field Model_AutoFightEff UIKmlLuaControlHandler
---@field btn_onHook UIKmlLuaControlHandler
---@field btn_changeLine UIKmlLuaControlHandler
---@field btn_openMap UIKmlLuaControlHandler
---@field btn_showBuff UIKmlLuaControlHandler
---@field AtkModePanel UIKmlLuaControlHandler
---@field Img_AtkModeBg UIKmlLuaControlHandler
---@field atkModelMenu UIKmlLuaControlHandler
---@field AtkModeClosePanel UIKmlLuaControlHandler
---@field Btn_AtkModeCloseMask UIKmlLuaControlHandler
local KLNewTopMapPanelView = {}
setmetatable(KLNewTopMapPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Map/Panel/KLNewTopMap/KLNewTopMapPanelKml'
---@param parent UIKmlLuaControlHandler
function KLNewTopMapPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLNewTopMapPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Map/Panel/KLNewTopMap/KLNewTopMapPanel']

return KLNewTopMapPanelView
