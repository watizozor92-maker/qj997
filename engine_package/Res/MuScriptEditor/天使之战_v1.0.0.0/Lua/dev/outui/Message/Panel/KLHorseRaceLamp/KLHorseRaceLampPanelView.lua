---@class KLHorseRaceLampPanelView:UIKmlLuaViewBase
---@field HorseRaceLampBG UIKmlLuaControlHandler
---@field scroll UIKmlLuaControlHandler
---@field HorseRaceLampLayout UIKmlLuaControlHandler
---@field HorseRaceLamp UIKmlLuaControlHandler
---@field HorseRace UIKmlLuaControlHandler
---@field DamageEXPBG UIKmlLuaControlHandler
---@field DamageEXPText UIKmlLuaControlHandler
---@field BgNode UIKmlLuaControlHandler
---@field stationary UIKmlLuaControlHandler
---@field stationary_img1 UIKmlLuaControlHandler
---@field stationary_text1 UIKmlLuaControlHandler
---@field stationary_mask1 UIKmlLuaControlHandler
---@field stationary_imgBtn1 UIKmlLuaControlHandler
---@field stationary_img2 UIKmlLuaControlHandler
---@field stationary_text2 UIKmlLuaControlHandler
---@field stationary_mask2 UIKmlLuaControlHandler
---@field stationary_imgBtn2 UIKmlLuaControlHandler
---@field stationary_img3 UIKmlLuaControlHandler
---@field stationary_text3 UIKmlLuaControlHandler
---@field stationary_mask3 UIKmlLuaControlHandler
---@field stationary_imgBtn3 UIKmlLuaControlHandler
---@field stationary_img4 UIKmlLuaControlHandler
---@field stationary_text4 UIKmlLuaControlHandler
---@field stationary_mask4 UIKmlLuaControlHandler
---@field stationary_imgBtn4 UIKmlLuaControlHandler
---@field archangelLayout UIKmlLuaControlHandler
---@field archangelExpBG1 UIKmlLuaControlHandler
---@field archangelExp UIKmlLuaControlHandler
---@field archangelExpBG2 UIKmlLuaControlHandler
---@field archangelExp UIKmlLuaControlHandler
---@field archangelExpBG3 UIKmlLuaControlHandler
---@field archangelExp UIKmlLuaControlHandler
---@field archangelExpBG4 UIKmlLuaControlHandler
---@field archangelExp UIKmlLuaControlHandler
---@field archangelExpBG5 UIKmlLuaControlHandler
---@field archangelExp UIKmlLuaControlHandler
---@field archangelExpBG6 UIKmlLuaControlHandler
---@field archangelExp UIKmlLuaControlHandler
---@field archangelExpBG7 UIKmlLuaControlHandler
---@field archangelExp UIKmlLuaControlHandler
local KLHorseRaceLampPanelView = {}
setmetatable(KLHorseRaceLampPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Message/Panel/KLHorseRaceLamp/KLHorseRaceLampPanelKml'
---@param parent UIKmlLuaControlHandler
function KLHorseRaceLampPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLHorseRaceLampPanelView
