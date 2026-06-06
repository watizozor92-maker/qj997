---@class KLQuintonInvasionRankItem:UIKmlLuaPanelBase
---@field view KLQuintonInvasionRankItemView
local KLQuintonInvasionRankItem = class(UIKmlLuaPanelBase)
local this =KLQuintonInvasionRankItem

---创建时调用一次
function this:Init()
end

---注册UI事件和服务器消息
function this:RegistEvents()
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    self:RefreshItem(self.args)
end

function this:RefreshItem(data)
    GUI:Text_setString(self.view.name,data.name)
    local integral = SL:GetSimpleNumber(tonumber(data.integral),2)
    local score = "积分:".. integral
    GUI:Text_setString(self.view.pointCount,score)
    GUI:Image_loadTexture(self.view.numberIcon,tostring(data.rank),"Atlas/UIQuintonInvasion.spriteatlas")
end

function this:Close()
end

return this
