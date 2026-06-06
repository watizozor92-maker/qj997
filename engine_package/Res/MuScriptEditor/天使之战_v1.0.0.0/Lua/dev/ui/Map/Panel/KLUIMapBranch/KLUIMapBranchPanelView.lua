---@class KLUIMapBranchPanelView:UIKmlLuaViewBase
---@field img2 UIKmlLuaControlHandler
---@field img_522 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field currentLine_txt UIKmlLuaControlHandler
---@field allLine_txt UIKmlLuaControlHandler
---@field img_523 UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field redName_btn UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field switch_branch_togglegroup UIKmlLuaControlHandler
---@field scrollview1 UIKmlLuaControlHandler
---@field branch_layout UIKmlLuaControlHandler
---@field topBtnGroup UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field normal_toggle UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
---@field gold_toggle UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
local KLUIMapBranchPanelView = {}
setmetatable(KLUIMapBranchPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Map/Panel/KLUIMapBranch/KLUIMapBranchPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIMapBranchPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIMapBranchPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Map/Panel/KLUIMapBranch/KLUIMapBranchPanel']

return KLUIMapBranchPanelView
