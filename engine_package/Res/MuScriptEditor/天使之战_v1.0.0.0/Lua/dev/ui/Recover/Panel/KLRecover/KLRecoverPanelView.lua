---@class KLRecoverPanelView:UIKmlLuaViewBase
---@field Mask UIKmlLuaControlHandler
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field img_60 UIKmlLuaControlHandler
---@field RecoverTypeGroup UIKmlLuaControlHandler
---@field RecoverGet UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field text6 UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field moneyBg UIKmlLuaControlHandler
---@field TypeContent UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field title_jifen UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field scoreBg UIKmlLuaControlHandler
---@field ScoreContent UIKmlLuaControlHandler
---@field BtnRecover UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field AutoRecoverToggle UIKmlLuaControlHandler
---@field AutoRecoverToggleText UIKmlLuaControlHandler
---@field scrollview1 UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field loopscrollviewData UIKmlLuaControlHandler
---@field privilege_tip UIKmlLuaControlHandler
local KLRecoverPanelView = {}
setmetatable(KLRecoverPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Recover/Panel/KLRecover/KLRecoverPanelKml'
---@param parent UIKmlLuaControlHandler
function KLRecoverPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLRecoverPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Recover/Panel/KLRecover/KLRecoverPanel']

return KLRecoverPanelView
