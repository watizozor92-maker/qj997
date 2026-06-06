---@class KLRookieGuidePanelView:UIKmlLuaViewBase
---@field MaskContainer UIKmlLuaControl
---@field CircleMask UIKmlLuaControl
---@field RectMask UIKmlLuaControl
---@field RectMask_Real UIKmlLuaControl
---@field MaskGo UIKmlLuaControl
---@field CloneGo UIKmlLuaControl
---@field TipsGo UIKmlLuaControl
---@field GuideBG UIKmlLuaControl
---@field Desc UIKmlLuaControl
---@field TopArrow UIKmlLuaControl
---@field RightArrow UIKmlLuaControl
---@field DownArrow UIKmlLuaControl
---@field LeftArrow UIKmlLuaControl
---@field Left_People UIKmlLuaControl
---@field Right_People UIKmlLuaControl
---@field HighlightGo UIKmlLuaControl
---@field RawImage UIKmlLuaControl
---@field Effect UIKmlLuaControl
---@field CircleGo UIKmlLuaControl
local KLRookieGuidePanelView = {}
setmetatable(KLRookieGuidePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Guide/Panel/KLRookieGuide/KLRookieGuidePanelKml'
---@param parent UIKmlLuaControl
function KLRookieGuidePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLRookieGuidePanelView
