---@class KLOffHookInfoItemView:UIKmlLuaViewBase
---@field Bg UIKmlLuaControlHandler
---@field Describe UIKmlLuaControlHandler
---@field offlineTitleTxt UIKmlLuaControlHandler
---@field txtOffline UIKmlLuaControlHandler
---@field fightMonsterTimeTitleTxt UIKmlLuaControlHandler
---@field txtFightMonsterTime UIKmlLuaControlHandler
---@field fightMonsterExpTitleTxt UIKmlLuaControlHandler
---@field txtFightMonsterExp UIKmlLuaControlHandler
---@field bubbleTimeTitleTxt UIKmlLuaControlHandler
---@field txtBubbleTime UIKmlLuaControlHandler
---@field bubbleExpTitleTxt UIKmlLuaControlHandler
---@field txtBubbleExp UIKmlLuaControlHandler
---@field offHookLogs UIKmlLuaControlHandler
---@field logBg UIKmlLuaControlHandler
---@field logInfoTitte UIKmlLuaControlHandler
---@field scrollview UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field logInfoTxt UIKmlLuaControlHandler
---@field btnHelp UIKmlLuaControlHandler
---@field layout UIKmlLuaControlHandler
---@field Exp UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field totleExp UIKmlLuaControlHandler
---@field receiveExpBtn UIKmlLuaControlHandler
---@field redDot UIKmlLuaControlHandler
local KLOffHookInfoItemView = {}
setmetatable(KLOffHookInfoItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Hook/Item/KLOffHookInfo/KLOffHookInfoItemKml'
---@param parent UIKmlLuaControlHandler
function KLOffHookInfoItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLOffHookInfoItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Hook/Item/KLOffHookInfo/KLOffHookInfoItem']

return KLOffHookInfoItemView
