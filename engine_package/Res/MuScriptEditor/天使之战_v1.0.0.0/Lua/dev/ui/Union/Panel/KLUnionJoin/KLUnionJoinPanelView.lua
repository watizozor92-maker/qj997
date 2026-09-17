---@class KLUnionJoinPanelView:UIKmlLuaViewBase
---@field img_27 UIKmlLuaControlHandler
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field bottom UIKmlLuaControlHandler
---@field table_title_bg UIKmlLuaControlHandler
---@field title_name UIKmlLuaControlHandler
---@field title_name UIKmlLuaControlHandler
---@field title_name UIKmlLuaControlHandler
---@field title_name UIKmlLuaControlHandler
---@field table_bg UIKmlLuaControlHandler
---@field table_list UIKmlLuaControlHandler
---@field union_list_view UIKmlLuaControlHandler
---@field union_data_list UIKmlLuaControlHandler
---@field one_key_apply_to_join UIKmlLuaControlHandler
---@field btn_text UIKmlLuaControlHandler
local KLUnionJoinPanelView = {}
setmetatable(KLUnionJoinPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Union/Panel/KLUnionJoin/KLUnionJoinPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUnionJoinPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUnionJoinPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Union/Panel/KLUnionJoin/KLUnionJoinPanel']

return KLUnionJoinPanelView
