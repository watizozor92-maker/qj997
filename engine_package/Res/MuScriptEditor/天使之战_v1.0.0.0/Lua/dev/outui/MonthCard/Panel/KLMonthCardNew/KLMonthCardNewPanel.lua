---@class KLMonthCardNewPanel:UIKmlLuaPanelBase
---@field view KLMonthCardNewPanelView
local KLMonthCardNewPanel = class(UIKmlLuaPanelBase)
local this = KLMonthCardNewPanel

---创建时调用一次
function this:Init()
    SL.HideMainPanel()
    local tbl_l = SL:GetConfig("cfg_monthcard", 2)
    local strList = tbl_l.showtext
    local tbl_r = SL:GetConfig("cfg_monthcard", 1)
    
    self.dataListText1 =string.split(strList,"#")
    self.dataListText2 =string.split(tbl_r.showtext,"#")
    GUI:DataListInitData(self.view.contentlist, function()
        return table.count(self.dataListText1)
    end, function()
    end, function()
    end, function(realIndex)
        local dataInfo = self.dataListText1[realIndex + 1]
        local preview_tittle = GUI:GetChildControl(self.view.contentlist, realIndex, 'preview_tittle')
        GUI:Text_setText(preview_tittle,dataInfo)
    end)

    GUI:DataListUpdateData(self.view.contentlist,true)

    GUI:DataListInitData(self.view.contentlist2, function()
        return table.count(self.dataListText2)
    end, function()
    end, function()
    end, function(realIndex)
        local dataInfo = self.dataListText2[realIndex + 1]
        local preview_tittle = GUI:GetChildControl(self.view.contentlist2, realIndex, 'preview_tittle2')
        GUI:Text_setText(preview_tittle,dataInfo)
    end)

    GUI:DataListUpdateData(self.view.contentlist2,true)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_leftBuy, self, self.LeftBuyOnClick)
    GUI:AddOnClickEvent(self.view.btn_rightBuy1, self, self.Right1BuyOnClick)
    GUI:AddOnClickEvent(self.view.btn_rightBuy2, self, self.Right2BuyOnClick)

    GUI:AddOnClickEvent(self.view.btn_close, self, self.CloseSelf)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RECHARGE_ACTION, self.ResRecharge, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_COMMON_REWARD_PANEL_WITH_PARAM, self.ResTipMessage, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GET_MONTH_PRIVILEGE_DATA, this.RES_GET_MONTH_PRIVILEGE_DATA, self)
    SL:RegisterLUAEvent(LUA_EVENT_PRIVILEGE_INFO_CHANGE, self.RES_GET_MONTH_PRIVILEGE_DATA, self)
end
function this:RES_GET_MONTH_PRIVILEGE_DATA(_, message)
    if message then

    end
    self:Refresh()
end

function this:LeftBuyOnClick()
    ---@type cfg_monthcard_column
    local tbl_l = SL:GetConfig("cfg_monthcard", 1)
    local tab = SL:GetConfig("cfg_recharge", tbl_l.price)
    GUIUtil.SDKPay(tab, 1)
end

function this:Right1BuyOnClick()
    ---@type cfg_monthcard_column
    local tbl = SL:GetConfig("cfg_monthcard", 2)
    local tab = SL:GetConfig("cfg_recharge", tbl.price)
    GUIUtil.SDKPay(tab, 1)
end

function this:Right2BuyOnClick()
    ---@type cfg_monthcard_column
    local tbl = SL:GetConfig("cfg_monthcard", 3)
    local tab = SL:GetConfig("cfg_recharge", tbl.price)
    GUIUtil.SDKPay(tab, 1)
end


function this:CloseSelf()
    SL.ShowMainPanel()
    GUI:UIPanel_Close(self.filePath)
end

function this:ResRecharge(_, message)
--[[    if message.type ~= tostring(ERechargeType.NewMonthCard) then
        return
    end]]
    GUI:setVisible(self.view.effect1, false)
    GUI:setVisible(self.view.effect2, false)
    if  message.type == "22" then
        SL:ScheduleOnce(Time.deltaTime, function()
            GUI:setVisible(self.view.effect1, true)
        end)
    end
    if  message.type == "21" then
        SL:ScheduleOnce(Time.deltaTime, function()
            GUI:setVisible(self.view.effect2, true)
        end)
    end
    
end

function this:ResTipMessage(_, message)
    if message.param then

    end
end

---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    local tbl_l = SL:GetConfig("cfg_monthcard", 1)
    local tbl_r1 = SL:GetConfig("cfg_monthcard", 2)
    local tbl_r2 = SL:GetConfig("cfg_monthcard", 3)

    GUI:Text_setString(self.view.txt_leftPrice, "")
    GUI:Text_setString(self.view.btn_leftBuy, "￥" .. tbl_l.cost)
    local leftItem = SL:GetConfig("cfg_privilege", 72)
    GUI:Text_setString(self.view.LeftTimeText, "持续："..GUIUtil.FormatTimeD(leftItem.time*60))
    GUI:Text_setString(self.view.txt_rightPrice, "")
    GUI:Text_setString(self.view.btn_rightBuy1, "￥" .. tbl_r1.cost)
    GUI:Text_setString(self.view.btn_rightBuy2, "￥" .. tbl_r2.cost)
    local right1Item = SL:GetConfig("cfg_privilege", 73)
    GUI:Text_setString(self.view.RightTimeText1,"持续：".. GUIUtil.FormatTimeD(right1Item.time*60))
    local right2Item = SL:GetConfig("cfg_privilege", 74)
    GUI:Text_setString(self.view.RightTimeText2,"持续：".. GUIUtil.FormatTimeD(right2Item.time*60))
    
    --GUI:Text_setString(self.view.txt_rightContent, tbl_r.showtext)

    if PrivilegeCardManager.goldFGPrivilege then
        -- GUI:setVisible(self.view.btn_leftBuy, false)
        if PrivilegeCardManager.GetPrivilegeFGRemainTime(1) >= 0 then
            GUI:setVisible(self.view.bg_leftPrice, true)
            GUI:Text_setString(self.view.txt_leftPrice, GUIUtil.FormatTimeDHM(PrivilegeCardManager.GetPrivilegeFGRemainTime(1) // 1000))
        else
            GUI:Text_setString(self.view.txt_leftPrice, "")
            GUI:setVisible(self.view.bg_leftPrice, false)
        end
    else
        GUI:setVisible(self.view.bg_leftPrice, false)
    end
    if PrivilegeCardManager.diamondFGPrivilege then
        -- GUI:setVisible(self.view.btn_rightBuy, false)
        if PrivilegeCardManager.GetPrivilegeFGRemainTime(2) >= 0 then
            GUI:setVisible(self.view.bg_rightPrice, true)
            GUI:Text_setString(self.view.txt_rightPrice, GUIUtil.FormatTimeDHM(PrivilegeCardManager.GetPrivilegeFGRemainTime(2) // 1000))
        else
            -- GUI:Text_setString(self.view.txt_rightPrice, "")
            GUI:setVisible(self.view.bg_rightPrice, false)
        end
    else
        GUI:setVisible(self.view.bg_rightPrice, false)
    end
end

function this:Hide()
end

function this:Close()
end

return this
