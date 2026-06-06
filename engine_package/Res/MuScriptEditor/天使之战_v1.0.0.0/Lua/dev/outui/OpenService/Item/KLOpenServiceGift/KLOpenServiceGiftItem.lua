---@class KLOpenServiceGiftItem:UIKmlLuaPanelBase
---@field view KLOpenServiceGiftItemView
local KLOpenServiceGiftItem = class(UIKmlLuaPanelBase)
local this = KLOpenServiceGiftItem

---创建时调用一次
function this:Init()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.bg_Btn, self, self.bg_BtnOnClick)
end

function this:bg_BtnOnClick()
    if not self.data then
        return
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECEIVE_LOGIN_REWARD, { id = self.data.id})
end

---界面显示时调用一次
function this:Show()
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:RefreshItem(data)
    self.data = data
    GUI:setVisible(self.view.get, false)
    GUI:setVisible(self.view.bg_Btn, false)
    GUI:setVisible(self.view.redDot, false)
    GUI:setVisible(self.view.SpLight, false)
    GUI:Item_setItemId(self.view.ItemIcon, data.reward[1])
    GUI:Item_setItemCount(self.view.ItemIcon, data.reward[2])
    GUI:AddOnClickEvent(self.view.ItemIcon, self, function()
        SL:OpenTips(nil, data.reward[1])
    end)
    local itemCfg = SL:GetConfig("cfg_item", data.reward[1])
    GUI:Text_setString(self.view.ItemTex, itemCfg.name)
    GUI:Text_setString(self.view.text5, string.format("第%s天", data.accumulateDay))
    if data.accumulateDay == 7 then
        GUI:setContentSize(self.view.bg, 350, 204)
        GUI:setContentSize(self.view.SpLight, 350, 204)
        GUI:setContentSize(self.view.bg_Btn, 350, 204)
    end
    if data.accumulateDay <= InfoManager.openServiceGiftInfo.countDay then
        if table.contains(InfoManager.openServiceGiftInfo.hadReceiveReward, data.id) then
            GUI:setVisible(self.view.get, true)
            GUI:Image_loadTexture(self.view.bg, "img_kaifu2", "Atlas/QJ5_UIOpenServiceGiftInner.spriteatlas")
        else
            GUI:setVisible(self.view.bg_Btn, true)
            GUI:setVisible(self.view.redDot, true)
            GUI:setVisible(self.view.SpLight, true)
            GUI:Image_loadTexture(self.view.bg, "img_kaifu1g", "Atlas/QJ5_UIOpenServiceGiftInner.spriteatlas")
        end
    else
        GUI:Image_loadTexture(self.view.bg, "img_kaifu1", "Atlas/QJ5_UIOpenServiceGiftInner.spriteatlas")
    end
end

function this:Close()
end

return this
