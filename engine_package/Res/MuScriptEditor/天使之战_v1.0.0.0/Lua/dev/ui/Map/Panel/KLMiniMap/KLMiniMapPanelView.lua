---@class KLMiniMapPanelView:UIKmlLuaViewBase
---@field move_root UIKmlLuaControlHandler
---@field btn_bg UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field txt_title UIKmlLuaControlHandler
---@field txt_server UIKmlLuaControlHandler
---@field panel_14 UIKmlLuaControlHandler
---@field panel_15 UIKmlLuaControlHandler
---@field img_scene UIKmlLuaControlHandler
---@field img_player_icon UIKmlLuaControlHandler
---@field btn_switch_line UIKmlLuaControlHandler
---@field txt_coord UIKmlLuaControlHandler
---@field btn_fightLog UIKmlLuaControlHandler
---@field btn_autoFight UIKmlLuaControlHandler
---@field Model_AutoFightEff UIKmlLuaControlHandler
---@field btn_onHook UIKmlLuaControlHandler
local KLMiniMapPanelView = {}
setmetatable(KLMiniMapPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Map/Panel/KLMiniMap/KLMiniMapPanelKml'
---@param parent UIKmlLuaControlHandler
function KLMiniMapPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLMiniMapPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Map/Panel/KLMiniMap/KLMiniMapPanel']

return KLMiniMapPanelView
