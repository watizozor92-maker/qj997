---@class KLCommonImageItem:UIKmlLuaPanelBase
---@field view KLCommonImageItemView
local KLCommonImageItem = class(UIKmlLuaPanelBase)
local this =KLCommonImageItem
---创建时调用一次
function this:Init()
    GUI:setVisible(self.view.img,true)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:Image_loadTexture(self.view.img, self.args.sprite, self.args.altas)
end

function this:SetSize(x, y)
    GUI:setContentSize(self.view.img, x, y)
end

function this:SetPosition(x, y)
    GUI:setPosition(self.view.img, x, y)
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

function this:Close()
end

return this
