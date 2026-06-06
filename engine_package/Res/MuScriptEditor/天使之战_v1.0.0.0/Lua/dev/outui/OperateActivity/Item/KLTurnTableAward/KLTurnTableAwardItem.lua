---@class KLTurnTableAwardItem:UIKmlLuaPanelBase
---@field view KLTurnTableAwardItemView
local KLTurnTableAwardItem = class(UIKmlLuaPanelBase)
local this = KLTurnTableAwardItem

---创建时调用一次
function this:Init()
    self.ItemList = nil
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.GetButton, self, self.GetButtonOnclick)
end
function this:GetButtonOnclick()
    if self.state and self.state == 2 then-- 可领取
        if self.showType == 1 then
            SL:SendLuaNetMsg(LuaMessageIdToSever. REQ_WEEK_RECEIVE_TURNTABLE_RAFFLE_REWARD,{turntableExtId = self.data.id,id = self.groupId})
        else
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECEIVE_TURNTABLE_RAFFLE_REWARD,{turntableExtId = self.data.id,id = self.groupId})
        end
    end
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
end
function this:UpDataUI(data,index,totalCount,received,groupId,showType)
    self.groupId = groupId
    self.index = index
    self.data = data
    self.showType = showType
    self.state =0
    self.careerId = SL:GetMetaValue(EMetaVarGetKey.JOB)
    if self.data then
        for i, v in pairs(self.data.reward) do
            if v[1] == self.careerId then
                self:ShowCoustIcon(v)
            end
        end
    end
    if self.data.num > totalCount then
        self.state = 1
    else
        self.state = 2
        if next(received) then
            for _,v in pairs(received) do
                if tonumber(v) == self.data.id then
                    self.state = 3 
                end
            end
        end
    end
    if self.state == 1 then---未达到条件
        GUI:SetActive(self.view.GetButton,false)
        GUI:SetActive(self.view.RedDot,false)
        GUI:SetActive(self.view.HaveGet,false)
        GUI:SetActive(self.view.CountText,true)
        GUI:SetActive(self.view.effect_tishi,false)
        GUI:Text_setString(self.view.CountText,"累计".. self.data.num.."抽可领取")
    elseif self.state == 2 then-- 可领取
        GUI:SetActive(self.view.GetButton,false)
        GUI:SetActive(self.view.RedDot,false)
        GUI:SetActive(self.view.HaveGet,false)
        GUI:SetActive(self.view.CountText,true)
        GUI:Text_setString(self.view.CountText,"可领取")
        GUI:SetActive(self.view.effect_tishi,true)
    elseif self.state == 3 then--- 已领取
        GUI:SetActive(self.view.GetButton,false)
        GUI:SetActive(self.view.RedDot,false)
        GUI:SetActive(self.view.HaveGet,false)
        GUI:SetActive(self.view.CountText,true)
        GUI:Text_setString(self.view.CountText,"已领取")
        GUI:SetActive(self.view.effect_tishi,false)
    end
end
---@param v table @例：{1,800502016,1}
function this:ShowCoustIcon(v)
    local data = {
        itemid = v[2],
        mfixsize = "80,80",
        tips = "1",
        width = "80",
        height = "80",
        bgtype = "0"
    }
    if self.ItemList then
        GUI:Item_UpdataData(self.ItemList, data)
    else
        self.ItemList = GUI:Item_Create(self.view.Icon, data)
    end
    GUI:AddOnClickEvent(self.ItemList, self, function()
        SL:OpenTips(nil, data.itemid)
    end)
end
function this:Hide()
end

function this:Close()
end

return this
