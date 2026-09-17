---@class KLSkillBagPanelView:UIKmlLuaViewBase
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1231 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field cut_area_up UIKmlLuaControlHandler
---@field cut_area_down UIKmlLuaControlHandler
---@field img_66 UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field sv_frame UIKmlLuaControlHandler
---@field layout1 UIKmlLuaControlHandler
---@field btn_fix UIKmlLuaControlHandler
---@field btn_arrange UIKmlLuaControlHandler
---@field btn_storage UIKmlLuaControlHandler
---@field btn_sell UIKmlLuaControlHandler
---@field bgGridRoot UIKmlLuaControlHandler
---@field fastItemTip UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
local KLSkillBagPanelView = {}
setmetatable(KLSkillBagPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Bag/Panel/KLSkillBag/KLSkillBagPanelKml'
---@param parent UIKmlLuaControlHandler
function KLSkillBagPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLSkillBagPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Bag/Panel/KLSkillBag/KLSkillBagPanel']

return KLSkillBagPanelView
