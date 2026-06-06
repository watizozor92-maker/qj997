---@class KLUnionMemberInfoPanelView:UIKmlLuaViewBase
---@field prefab_95 UIKmlLuaControlHandler
---@field Bg1 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field btn_PanelClose UIKmlLuaControlHandler
---@field HeadPortrait UIKmlLuaControlHandler
---@field grey UIKmlLuaControlHandler
---@field MemberNameText UIKmlLuaControlHandler
---@field MemberLevel UIKmlLuaControlHandler
---@field MemberLevelText UIKmlLuaControlHandler
---@field panel_manager UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field MemberSetType UIKmlLuaControlHandler
---@field tog_SetType1 UIKmlLuaControlHandler
---@field text UIKmlLuaControlHandler
---@field tog_SetType2 UIKmlLuaControlHandler
---@field text UIKmlLuaControlHandler
---@field tog_SetType3 UIKmlLuaControlHandler
---@field text UIKmlLuaControlHandler
---@field tog_SetType4 UIKmlLuaControlHandler
---@field text UIKmlLuaControlHandler
---@field tog_SetType5 UIKmlLuaControlHandler
---@field text UIKmlLuaControlHandler
---@field tog_SetType6 UIKmlLuaControlHandler
---@field text UIKmlLuaControlHandler
---@field PlayerDetailBtn UIKmlLuaControlHandler
---@field AddFriendBtn UIKmlLuaControlHandler
---@field PrivateChatBtn UIKmlLuaControlHandler
---@field CancelManageBtn UIKmlLuaControlHandler
---@field Text UIKmlLuaControlHandler
---@field ConfirmManageBtn UIKmlLuaControlHandler
---@field Text UIKmlLuaControlHandler
---@field DIY_Image UIKmlLuaControlHandler
local KLUnionMemberInfoPanelView = {}
setmetatable(KLUnionMemberInfoPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Union/Panel/KLUnionMemberInfo/KLUnionMemberInfoPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUnionMemberInfoPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUnionMemberInfoPanelView
