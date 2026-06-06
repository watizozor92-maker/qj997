---@class KLHookPointMonsterItemView:UIKmlLuaViewBase
---@field Bg UIKmlLuaControlHandler
---@field HighlightGo UIKmlLuaControlHandler
---@field RawImage UIKmlLuaControlHandler
---@field Effect UIKmlLuaControlHandler
---@field headBG UIKmlLuaControlHandler
---@field imgHead UIKmlLuaControlHandler
---@field txtName UIKmlLuaControlHandler
---@field txtLevel UIKmlLuaControlHandler
---@field txtExp UIKmlLuaControlHandler
---@field btnGo UIKmlLuaControlHandler
---@field imgArrow UIKmlLuaControlHandler
---@field txt_suggestion UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field btn_tips UIKmlLuaControlHandler
local KLHookPointMonsterItemView = {}
setmetatable(KLHookPointMonsterItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Hook/Item/KLHookPointMonster/KLHookPointMonsterItemKml'
---@param parent UIKmlLuaControlHandler
function KLHookPointMonsterItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLHookPointMonsterItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Hook/Item/KLHookPointMonster/KLHookPointMonsterItem']

return KLHookPointMonsterItemView
