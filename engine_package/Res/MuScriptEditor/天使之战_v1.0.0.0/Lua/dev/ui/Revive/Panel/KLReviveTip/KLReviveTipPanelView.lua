---@class KLReviveTipPanelView:UIKmlLuaViewBase
---@field KLReviveTip_Panel UIKmlLuaControlHandler
---@field img9 UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field LeftBtn UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field RightBtn UIKmlLuaControlHandler
---@field Root_monsterKillInfo UIKmlLuaControlHandler
---@field informationText UIKmlLuaControlHandler
---@field txt_titleMed UIKmlLuaControlHandler
---@field layout_med UIKmlLuaControlHandler
---@field txt_needMed UIKmlLuaControlHandler
---@field btn_med UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field txt_titleDef UIKmlLuaControlHandler
---@field txt_defence UIKmlLuaControlHandler
---@field layout_def UIKmlLuaControlHandler
---@field txt_def UIKmlLuaControlHandler
---@field btn_duanzao UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field btn_buff1 UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field btn_buff2 UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field layout_damage UIKmlLuaControlHandler
---@field text8 UIKmlLuaControlHandler
---@field btn_guard UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field btn_wing UIKmlLuaControlHandler
---@field img8 UIKmlLuaControlHandler
local KLReviveTipPanelView = {}
setmetatable(KLReviveTipPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Revive/Panel/KLReviveTip/KLReviveTipPanelKml'
---@param parent UIKmlLuaControlHandler
function KLReviveTipPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLReviveTipPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Revive/Panel/KLReviveTip/KLReviveTipPanel']

return KLReviveTipPanelView
