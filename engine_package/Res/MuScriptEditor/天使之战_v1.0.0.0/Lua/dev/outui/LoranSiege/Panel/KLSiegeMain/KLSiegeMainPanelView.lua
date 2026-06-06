---@class KLSiegeMainPanelView:UIKmlLuaViewBase
---@field img_33 UIKmlLuaControlHandler
---@field Titletext UIKmlLuaControlHandler
---@field img_34 UIKmlLuaControlHandler
---@field btn_close UIKmlLuaControlHandler
---@field img_36 UIKmlLuaControlHandler
---@field img_37 UIKmlLuaControlHandler
---@field btn_reward UIKmlLuaControlHandler
---@field btn_go UIKmlLuaControlHandler
---@field unionName UIKmlLuaControlHandler
---@field role_mid UIKmlLuaControlHandler
---@field role_left UIKmlLuaControlHandler
---@field role_right UIKmlLuaControlHandler
---@field HelpButton UIKmlLuaControlHandler
---@field roleTitle1 UIKmlLuaControlHandler
---@field roleTitle1_Name UIKmlLuaControlHandler
---@field roleTitle2 UIKmlLuaControlHandler
---@field roleTitle2_Name UIKmlLuaControlHandler
---@field roleTitle3 UIKmlLuaControlHandler
---@field roleTitle3_Name UIKmlLuaControlHandler
---@field noPlayerBG1 UIKmlLuaControlHandler
---@field noPlayerBG2 UIKmlLuaControlHandler
---@field noPlayerBG3 UIKmlLuaControlHandler
---@field img_20 UIKmlLuaControlHandler
---@field TimeTitle UIKmlLuaControlHandler
---@field TimeText UIKmlLuaControlHandler
---@field OpenText UIKmlLuaControlHandler
local KLSiegeMainPanelView = {}
setmetatable(KLSiegeMainPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/LoranSiege/Panel/KLSiegeMain/KLSiegeMainPanelKml'
---@param parent UIKmlLuaControlHandler
function KLSiegeMainPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLSiegeMainPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/LoranSiege/Panel/KLSiegeMain/KLSiegeMainPanel']

return KLSiegeMainPanelView
