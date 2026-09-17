---@class KLNPCPhantomMentorPanel:UIKmlLuaPanelBase
---@field view KLNPCPhantomMentorPanelView
local KLNPCPhantomMentorPanel = class(UIKmlLuaPanelBase)
local this = KLNPCPhantomMentorPanel

---创建时调用一次
function this:Init()
    self.huanyingTbl1 = SL:GetConfig("cfg_huanyingdaoshi", 1)
    self.huanyingTbl3 = SL:GetConfig("cfg_huanyingdaoshi", 3)
    self.huanyingTbl2 = SL:GetConfig("cfg_huanyingdaoshi", 2)
    self.IsLeftClick = true
    self.IsRightClick = true
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.cancelBtn, self, self.cancelBtnOnClick)
    GUI:AddOnClickEvent(self.view.leftBtn, self, self.leftBtnOnClick)
    GUI:AddOnClickEvent(self.view.rightBtn, self, self.rightBtnOnClick,1)
    GUI:AddOnClickEvent(self.view.rightBtn2, self, self.rightBtnOnClick,2)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_NPC_BUFF_CD, self.RES_NPC_BUFF_CD, self)
end
function this:RES_NPC_BUFF_CD(_, message)
    if message then
        InfoManager.guardPetInfo.MM_endTime = message.endTime
        self:reTime()
    end
end
function this:leftBtnOnClick()
    if not self.IsLeftClick then
        return
    end
    self.IsLeftClick = false
    self.timer2=SL:ScheduleOnce(1,function()
        self.IsLeftClick = true
    end)
    local huanyingTbl1 = self.huanyingTbl1
    local minLevel1 = self.huanyingTbl1.level[1]
    local maxLevel1 = self.huanyingTbl1.level[2]
    local myLevel = SL:MeData_GetLevel()
    if not (minLevel1 <= myLevel and myLevel <= maxLevel1) then
        --SL:TipMessage("等级不符合", 1, NoticeType.NoticeMid)
        return
    end
    local minLevel3 = self.huanyingTbl3.level[1]
    local maxLevel3 = self.huanyingTbl3.level[2]
    if minLevel3 <= myLevel and myLevel <= maxLevel3 then
        if ConditionManager.Check4D(self.huanyingTbl3.condition) then
            huanyingTbl1 = self.huanyingTbl3
        end
    end
    if table.isNullOrEmpty(self.huanyingTbl1.item) then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_NPC_ADD_BUFF, { id = huanyingTbl1.id })
    else
        local costId2 = huanyingTbl1.item[1][1]
        local cost = huanyingTbl1.item[1][2]
        local myNum = SL:GetBagItemCount(costId2)
        if myNum < cost then
            SL:CommonItemGetPath(nil,costId2)
            SL:TipMessage(string.format("%s不足", SL:GetConfig("cfg_item", costId2).name), 1, NoticeType.NoticeMid)
            return
        else
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_NPC_ADD_BUFF, { id = huanyingTbl1.id })
        end
    end
    self:cancelBtnOnClick()
end
function this:rightBtnOnClick(_,data)
    if not self.IsRightClick then
        return
    end
    self.IsRightClick = false
    self.timer3=SL:ScheduleOnce(1,function()
        self.IsRightClick = true
    end)
    if data ~= 2 then
        local MM_endTime = InfoManager.guardPetInfo.MM_endTime * 1000
        local remainTime = MM_endTime - Time.GetServerTime()
        if remainTime > 0 then
            --SL:TipMessage("精灵MM卡已激活", 1, NoticeType.NoticeMid)
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_NPC_ADD_BUFF, { id = 2 ,type = data })
            return
        end
    end
    local minLevel1 = self.huanyingTbl2.level[1]
    local maxLevel1 = self.huanyingTbl2.level[2]
    local myLevel = SL:MeData_GetLevel()
    if not (minLevel1 <= myLevel and myLevel <= maxLevel1) then
        --SL:TipMessage("等级不符合", 1, NoticeType.NoticeMid)
        return
    end
    if table.isNullOrEmpty(self.huanyingTbl2.item) then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_NPC_ADD_BUFF, { id = 2 ,type = data })
    else
        local costId2 = self.huanyingTbl2.item[1][1]
        local cost = self.huanyingTbl2.item[1][2]
        local myNum = SL:GetBagItemCount(costId2)
        if myNum < cost then
            SL:CommonItemGetPath(nil,costId2)
            SL:TipMessage(string.format("%s不足", SL:GetConfig("cfg_item", costId2).name), 1, NoticeType.NoticeMid)
            return
        else
            SL:CommonTipsMessage({ showTips = string.format("是否消耗%s购买", SL:GetConfig("cfg_item", costId2).name),
                                   ui = self,
                                   sureBtnText = "确定",
                                   cancelBtnText = "取消",
                                   callback = function()
                                       SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_NPC_ADD_BUFF, { id = 2 ,type = data })
                                   end
            })
        end
    end
    --self:cancelBtnOnClick()
end

function this:cancelBtnOnClick()
    GUI:UIPanel_Close("dev/outui/NPC/Panel/KLNPCPhantomMentor/KLNPCPhantomMentorPanel")
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()

    GUI:Text_setText(self.view.leftText3, self.huanyingTbl1.text)
    GUI:Text_setText(self.view.rightText3, self.huanyingTbl2.text)
    local minLevel1 = self.huanyingTbl1.level[1]
    local maxLevel1 = self.huanyingTbl1.level[2]

    local minLevel2 = self.huanyingTbl2.level[1]
    local maxLevel2 = self.huanyingTbl2.level[2]

    local myLevel = SL:MeData_GetLevel()
    if minLevel1 <= myLevel and myLevel <= maxLevel1 then
        GUI:setColor(self.view.leftText1, "#00ff00")
        GUI:Button_setGrey(self.view.leftBtn, false)
        GUI:Button_loadTextureNormal(self.view.leftBtn, "btn_cebian1", "Atlas/FG_Common.spriteatlas")
    else
        GUI:setColor(self.view.leftText1, "#FF2323")
        GUI:Button_setGrey(self.view.leftBtn, true)
        GUI:Button_loadTextureNormal(self.view.leftBtn, "btn_cebian2", "Atlas/FG_Common.spriteatlas")
    end
    if minLevel2 <= myLevel and myLevel <= maxLevel2 then
        GUI:setColor(self.view.rightText1, "#00ff00")
        GUI:Button_setGrey(self.view.rightBtn, false)
        GUI:Button_loadTextureNormal(self.view.rightBtn, "btn_cebian1", "Atlas/FG_Common.spriteatlas")
    else
        GUI:setColor(self.view.rightText1, "#FF2323")
        GUI:Button_setGrey(self.view.rightBtn, true)
        GUI:Button_loadTextureNormal(self.view.rightBtn, "btn_cebian2", "Atlas/FG_Common.spriteatlas")
    end
    self:reTime()

end
function this:reTime()
    local MM_endTime = InfoManager.guardPetInfo.MM_endTime * 1000
    if MM_endTime ~= 0 then
        self.timer = SL:Schedule(self.timer, 0, 1, -1, function()
            local remainTime = MM_endTime - Time.GetServerTime()
            if remainTime > 0 then
                GUI:SetActive(self.view.rightBtn2, true)
                GUI:Text_setText(self.view.rightText4, "剩余时间："..GUIUtil.FormatTimeDHM(remainTime/1000))
            else
                GUI:Text_setText(self.view.rightText4, "")
                GUI:SetActive(self.view.rightBtn2, false)
                if  self.timer then
                    SL:UnSchedule(self.timer)
                end
            end
        end)
    else
        GUI:Text_setText(self.view.rightText4, "")
        GUI:SetActive(self.view.rightBtn2, false)
    end
end
function this:Hide()
end

function this:Close()
    if self.timer then
        SL:UnSchedule(self.timer)
    end
    self.timer = nil
    if self.timer2 then
        SL:UnSchedule(self.time2)
    end
    self.timer2 = nil
    if self.timer3 then
        SL:UnSchedule(self.time3)
    end
    self.timer3 = nil
    SL:ShowMainPanel()
end

return this
