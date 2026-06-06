---@class KLDailyBoxRewardItem:UIKmlLuaPanelBase
---@field view KLDailyBoxRewardItemView
local KLDailyBoxRewardItem = class(UIKmlLuaPanelBase)
local this =KLDailyBoxRewardItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local itemId = self.args["id"]
    local count = self.args["count"]
    GUI:Item_setItemId(self.view.item, itemId)
    if count > 0 then
        GUI:setVisible(self.view.txt_count,false)
    else
        GUI:Text_setString(self.view.txt_count,"随机获得")
        GUI:setVisible(self.view.txt_count,true)
    end
    GUI:Item_UpdataData(self.view.item,{itemcount = count,textcolor="#fbd994"})
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_item,self,self.OnClickItem)
end

function this:OnClickItem()
    SL:OpenTips(nil,tonumber(self.args["id"]))
end

function this:Close()
end

return this
