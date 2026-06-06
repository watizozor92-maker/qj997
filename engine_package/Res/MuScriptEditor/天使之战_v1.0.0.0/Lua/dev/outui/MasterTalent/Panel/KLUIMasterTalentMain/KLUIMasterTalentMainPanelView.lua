---@class KLUIMasterTalentMainPanelView:UIKmlLuaViewBase
---@field Mask UIKmlLuaControl
---@field img2 UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field img3 UIKmlLuaControl
---@field TalentBG UIKmlLuaControl
---@field CloseButton UIKmlLuaControl
---@field Title UIKmlLuaControl
---@field ToggleGroup UIKmlLuaControl
---@field TitleToggleList UIKmlLuaControl
---@field gridview26 UIKmlLuaControl
---@field TitleDatalist UIKmlLuaControl
local KLUIMasterTalentMainPanelView = {}
setmetatable(KLUIMasterTalentMainPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MasterTalent/Panel/KLUIMasterTalentMain/KLUIMasterTalentMainPanelKml'
---@param parent UIKmlLuaControl
function KLUIMasterTalentMainPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIMasterTalentMainPanelView
