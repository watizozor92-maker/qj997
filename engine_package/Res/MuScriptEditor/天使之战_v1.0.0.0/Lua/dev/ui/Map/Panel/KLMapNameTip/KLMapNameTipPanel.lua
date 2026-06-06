---@class KLMapNameTipPanel:UIKmlLuaPanelBase
---@field view KLMapNameTipPanelView
local KLMapNameTipPanel = class(UIKmlLuaPanelBase)
local this =KLMapNameTipPanel
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:RefreshData(mapName)
    GUI:Image_loadTexture(self.view.ImgMapName,mapName,"Atlas/UIMapPanel.spriteatlas")
    if self.fadeAnim then
        --self.fadeAnim:Kill()
        GUI:Image_StopColorFadeInKeepOut(self.fadeAnim)
        self.fadeAnim = nil
    end
    --[[---@type KingML.KmlImage
    local imageControl = self.view.ImgMapName.kmlControl
    self.fadeAnim = imageControl.image:DoColorFadeInKeepOut(1,10,1)]]
    self.fadeAnim = GUI:Image_DoColorFadeInKeepOut(self.view.ImgMapName,1,10,1,function()
        self.fadeAnim = nil
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

function this:Close()
    if self.fadeAnim then
        --self.fadeAnim:Kill()
        GUI:Image_StopColorFadeInKeepOut(self.fadeAnim)
        self.fadeAnim = nil
    end
end

return this
