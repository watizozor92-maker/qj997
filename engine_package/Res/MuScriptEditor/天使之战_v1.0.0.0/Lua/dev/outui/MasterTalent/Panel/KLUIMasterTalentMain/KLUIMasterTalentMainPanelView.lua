---@class KLUIMasterTalentMainPanelView:UIKmlLuaViewBase
---@field Mask UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field TalentBG UIKmlLuaControlHandler
---@field CloseButton UIKmlLuaControlHandler
---@field Title UIKmlLuaControlHandler
---@field ToggleGroup UIKmlLuaControlHandler
---@field TitleToggleList UIKmlLuaControlHandler
---@field gridview26 UIKmlLuaControlHandler
---@field TitleDatalist UIKmlLuaControlHandler
local KLUIMasterTalentMainPanelView = {}
setmetatable(KLUIMasterTalentMainPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MasterTalent/Panel/KLUIMasterTalentMain/KLUIMasterTalentMainPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIMasterTalentMainPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIMasterTalentMainPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/MasterTalent/Panel/KLUIMasterTalentMain/KLUIMasterTalentMainPanel']

return KLUIMasterTalentMainPanelView
