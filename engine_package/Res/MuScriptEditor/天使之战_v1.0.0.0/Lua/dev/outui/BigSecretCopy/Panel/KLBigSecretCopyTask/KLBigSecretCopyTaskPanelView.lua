---@class KLBigSecretCopyTaskPanelView:UIKmlLuaViewBase
---@field Boss UIKmlLuaControlHandler
---@field ActivityName UIKmlLuaControlHandler
---@field line_1 UIKmlLuaControlHandler
---@field line_2 UIKmlLuaControlHandler
---@field task_root UIKmlLuaControlHandler
---@field pos_root UIKmlLuaControlHandler
---@field btn UIKmlLuaControlHandler
---@field name UIKmlLuaControlHandler
---@field num UIKmlLuaControlHandler
---@field pos_str UIKmlLuaControlHandler
---@field info UIKmlLuaControlHandler
---@field shijian UIKmlLuaControlHandler
---@field pingfen UIKmlLuaControlHandler
---@field start_time UIKmlLuaControlHandler
---@field walkBtn UIKmlLuaControlHandler
---@field end_time UIKmlLuaControlHandler
---@field HelpButton UIKmlLuaControlHandler
---@field begin_root UIKmlLuaControlHandler
---@field openDes UIKmlLuaControlHandler
---@field openDesTxt UIKmlLuaControlHandler
---@field exitBtn UIKmlLuaControlHandler
local KLBigSecretCopyTaskPanelView = {}
setmetatable(KLBigSecretCopyTaskPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/BigSecretCopy/Panel/KLBigSecretCopyTask/KLBigSecretCopyTaskPanelKml'
---@param parent UIKmlLuaControlHandler
function KLBigSecretCopyTaskPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLBigSecretCopyTaskPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/BigSecretCopy/Panel/KLBigSecretCopyTask/KLBigSecretCopyTaskPanel']

return KLBigSecretCopyTaskPanelView
