---@class KLUnionBossMainPanelView:UIKmlLuaViewBase
---@field BackGround UIKmlLuaControlHandler
---@field panel1 UIKmlLuaControlHandler
---@field panel3 UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field img_57 UIKmlLuaControlHandler
---@field btn_close UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img_59 UIKmlLuaControlHandler
---@field text_60 UIKmlLuaControlHandler
---@field img_61 UIKmlLuaControlHandler
---@field osa_boss UIKmlLuaControlHandler
---@field datalist_63 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img_72 UIKmlLuaControlHandler
---@field txt_pass_tip UIKmlLuaControlHandler
---@field osa_reward UIKmlLuaControlHandler
---@field datalist_75 UIKmlLuaControlHandler
---@field text_79 UIKmlLuaControlHandler
---@field btn_enter UIKmlLuaControlHandler
local KLUnionBossMainPanelView = {}
setmetatable(KLUnionBossMainPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Union/Panel/KLUnionBossMain/KLUnionBossMainPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUnionBossMainPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUnionBossMainPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Union/Panel/KLUnionBossMain/KLUnionBossMainPanel']

return KLUnionBossMainPanelView
