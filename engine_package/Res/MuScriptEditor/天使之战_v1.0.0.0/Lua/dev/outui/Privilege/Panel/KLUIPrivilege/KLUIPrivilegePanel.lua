---@class KLUIPrivilegePanel:UIKmlLuaPanelBase
---@field view KLUIPrivilegePanelView
local KLUIPrivilegePanel = class(UIKmlLuaPanelBase)
local this =KLUIPrivilegePanel
---创建时调用一次
function this:Init()
    ---@type cfg_privilege_column
    self.goldPrivilegeCfg = SL:GetConfig("cfg_privilege", 1)
    local goldTempList = self.goldPrivilegeCfg.PrivilegelList
    self.goldList = table.copy(self.goldPrivilegeCfg.StreamerList)
    for i, v in pairs(goldTempList) do
        if not table.contains(self.goldList, v) then
            self.goldList[#self.goldList + 1] = v
        end
    end
    ---@type cfg_privilege_column
    self.diamondPrivilegeCfg = SL:GetConfig("cfg_privilege", 2)
    local diamondTempList = self.diamondPrivilegeCfg.PrivilegelList
    self.diamondList = table.copy(self.diamondPrivilegeCfg.StreamerList)
    for i, v in pairs(diamondTempList) do
        if not table.contains(self.diamondList, v) then
            self.diamondList[#self.diamondList + 1] = v
        end
    end
    self.privilegeType = {
        [1] = "野外地图开放黄金线",
        [2] = "随身商店",
        [3] = "小怪挂机保护",
        [4] = "背包空间增加",
        [5] = "特权仓库增加",
        [6] = "自动买药",
        [7] = "切换加点方案",
        [8] = "大师天赋免费切换",
        [9] = "掉落提升",
        [10] = "经验提升",
        [11] = "回收收益提升",
        [12] = "巡逻挂机",
        [13] = "远程仓库",
        [14] = "交易行寄售货架数量增加",
        [15] = "掉落经验提升",
    }

    GUI:DataListInitData( self.view.datalist_gold,function()
        return self:GoldListItemCountFunc()
    end,function(realIndex)
        return self:GoldListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:GoldListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:GoldListItemUpdateFunc(realIndex, kmlcontrol)
    end)

    GUI:DataListInitData( self.view.datalist_diamond,function()
        return self:DiamondListItemCountFunc()
    end,function(realIndex)
        return self:DiamondListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:DiamondListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DiamondListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    
    --SL.HideMainPanel()
end

---黄金特权List
function this:GoldListItemCountFunc()
    return #self.goldList
end

function this:GoldListItemGetFunc(realIndex)

end

function this:GoldListItemInitFunc(realIndex, kmlcontrol)

end

function this:GoldListItemUpdateFunc(realIndex, kmlcontrol)
    local index = self.goldList[realIndex + 1]
    local btn = GUI:GetChildControl(self.view.datalist_gold, realIndex, "button_gold")
    self:SetPrivilegeItemText(btn, index, 1)
    GUI:AddOnClickEvent(btn, self, self.ClickDescription, { 1, index })
    local streamerTbl = SL:GetConfig("cfg_privilege", 1).StreamerList
    if table.contains(streamerTbl, index) then
        GUI:Button_loadTextureNormal(btn, "img_gold_bg_1", "Atlas/KLUIPrivilegePanel.spriteatlas")
    else
        GUI:Button_loadTextureNormal(btn, "img_gold_bg_2", "Atlas/KLUIPrivilegePanel.spriteatlas")
    end
end

---钻石特权List
function this:DiamondListItemCountFunc()
    return #self.diamondList
end

function this:DiamondListItemGetFunc(realIndex)

end

function this:DiamondListItemInitFunc(realIndex, kmlcontrol)

end

function this:DiamondListItemUpdateFunc(realIndex, kmlcontrol)
    local index = self.diamondList[realIndex + 1]
    local btn = GUI:GetChildControl(self.view.datalist_diamond, realIndex, "button_diamond")
    self:SetPrivilegeItemText(btn, index, 2)
    GUI:AddOnClickEvent(btn, self, self.ClickDescription, { 2, index })
    ---@type cfg_privilege_column
    local streamerTbl = SL:GetConfig("cfg_privilege", 2).StreamerList
    if table.contains(streamerTbl, index) then
        GUI:Button_loadTextureNormal(btn, "img_diamond_bg_1", "Atlas/KLUIPrivilegePanel.spriteatlas")
    else
        GUI:Button_loadTextureNormal(btn, "img_diamond_bg_2", "Atlas/KLUIPrivilegePanel.spriteatlas")
    end
end

function this:SetPrivilegeItemText(control, index, type)
    local cfg = type == 1 and self.goldPrivilegeCfg or self.diamondPrivilegeCfg
    local text = ""
    if index == 4 then
        text = self.privilegeType[index] .. cfg.backpackUp .. "格"
    elseif index == 5 then
        text = self.privilegeType[index] .. #cfg.DepotUp .. "页"
    elseif index == 9 or index == 15 then
        text = self.privilegeType[index] .. math.floor(cfg.DropsUp[2] / 100) .. "%"
    elseif index == 10 then
        text = self.privilegeType[index] .. cfg.ExperienceUp .. "%"
    elseif index == 11 then 
        text = self.privilegeType[index] .. cfg.reclaimUp .. "%"
    elseif index == 14 then
        text = self.privilegeType[index] .. cfg.TradingGhelvesUp .. "格"
    else
        text = self.privilegeType[index]
    end
    GUI:Button_setTitleText(control, text)
end

function this:ClickDescription(_, eventData)
    GUI:UIPanel_Open("dev/outui/Privilege/Panel/KLUIPrivilegeItemDescription/KLUIPrivilegeItemDescriptionPanel", nil, self, { type = eventData[1], uiType = eventData[2] })
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_close, self, self.CloseSelf)
    GUI:AddOnClickEvent(self.view.btn_introduce, self, self.IntroduceSelf)
    GUI:AddOnClickEvent(self.view.btn_gold_exchange, self, self.ExchangeGoldPrivilege)
    GUI:AddOnClickEvent(self.view.btn_diamond_exchange, self, self.ExchangeDiamondPrivilege)
    
    SL:RegisterLUAEvent(LUA_EVENT_PRIVILEGE_INFO_CHANGE, self.LUA_EVENT_PRIVILEGE_INFO_CHANGE, self)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:DataListUpdateData(self.view.datalist_gold)
    GUI:DataListUpdateData(self.view.datalist_diamond)
    GUI:Model_setSrc(self.view.item_gold, tostring(self.goldPrivilegeCfg.field))
    GUI:Model_setSrc(self.view.item_diamond, tostring(self.diamondPrivilegeCfg.field))
    if PrivilegeCardManager.goldPrivilege then
        GUI:setVisible(self.view.gold_privilege_time, true)
        GUI:Button_setTitleText(self.view.btn_gold_exchange, "续费")
        GUI:SetControl_time(self.view.gold_privilege_time, PrivilegeCardManager.GetPrivilegeRemainTime(1) / 1000)
    else
        GUI:setVisible(self.view.gold_privilege_time, false)
        GUI:Button_setTitleText(self.view.btn_gold_exchange, "兑换")
    end
    if PrivilegeCardManager.diamondPrivilege then
        GUI:setVisible(self.view.diamond_privilege_time, true)
        GUI:Button_setTitleText(self.view.btn_diamond_exchange, "续费")
        GUI:SetControl_time(self.view.diamond_privilege_time, PrivilegeCardManager.GetPrivilegeRemainTime(2) / 1000)
    else
        GUI:setVisible(self.view.diamond_privilege_time, false)
        GUI:Button_setTitleText(self.view.btn_diamond_exchange, "兑换")
    end
end

function this:ExchangeGoldPrivilege()
    local time = 0
    if InfoManager.monthCardInfo.MonthCardTimeTotal then
        time = InfoManager.monthCardInfo.MonthCardTimeTotal - Time.GetServerTime()
    end
    if time and time > 0 then
        local timeStr = SL:TimeFormatToStr(math.floor(time / 1000))
        local day = time / 3600000 / 24
        if day >= self.goldPrivilegeCfg.price then
            --local text = "是否消耗" .. self.goldPrivilegeCfg.price .. "天点卡激活黄金特权\n\n当前月卡剩余时间:" .. timeStr
            SL:CommonTipsMessage({ stringTblID=218,stringTblFormat={tostring(self.goldPrivilegeCfg.price), tostring(timeStr)}, nil, callback = 
            function()
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_EXCHANGE_MONTH_PRIVILEGE, 1)
            end })
        else
            --local text = "兑换黄金特权卡需要" .. self.goldPrivilegeCfg.price .. "天月卡时间,当前月卡时间不足,是否前往充值\n\n当前月卡剩余时间:" .. timeStr
            SL:CommonTipsMessage({ stringTblID=219,stringTblFormat={tostring(self.goldPrivilegeCfg.price), tostring(timeStr)}, nil, callback = 
            function()
                local panel = GUI:GetUI("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel")
                panel:Refresh()
            end })
        end
    else
        --local text = "兑换黄金特权卡需要" .. self.goldPrivilegeCfg.price .. "天月卡时间,当前月卡时间不足,是否前往充值"
        SL:CommonTipsMessage({ stringTblID=220,stringTblFormat={tostring(self.goldPrivilegeCfg.price)}, nil, callback = 
        function()
            ---@class KLUIMonthCardMainPanel
            local panel = GUI:GetUI("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel")
            panel:Refresh()
        end })
    end
end

function this:ExchangeDiamondPrivilege()
    local time = 0
    if InfoManager.monthCardInfo.MonthCardTimeTotal then
        time = InfoManager.monthCardInfo.MonthCardTimeTotal - Time.GetServerTime()
    end
    if time and time > 0 then
        local timeStr = SL:TimeFormatToStr(math.floor(time / 1000))
        local day = time / 3600000 / 24
        if day >= self.diamondPrivilegeCfg.price then
            --local text = "是否消耗" .. self.diamondPrivilegeCfg.price .. "天点卡激活钻石特权\n\n当前月卡剩余时间:" .. timeStr
            SL:CommonTipsMessage({  stringTblID=221,stringTblFormat={tostring(self.diamondPrivilegeCfg.price), tostring(timeStr)}, nil, callback = 
            function()
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_EXCHANGE_MONTH_PRIVILEGE, 2)
            end })
        else
            --local text = "兑换钻石特权卡需要" .. self.diamondPrivilegeCfg.price .. "天月卡时间,当前月卡时间不足,是否前往充值\n\n当前月卡剩余时间:" .. timeStr
            SL:CommonTipsMessage({ stringTblID=222,stringTblFormat={tostring(self.diamondPrivilegeCfg.price), tostring(timeStr)}, nil, callback = 
            function()
                ---@class KLUIMonthCardMainPanel
                local panel = GUI:GetUI("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel")
                panel:Refresh()
            end })
        end
    else
        --local text = "兑换钻石特权卡需要" .. self.diamondPrivilegeCfg.price .. "天月卡时间,当前月卡时间不足,是否前往充值"
        SL:CommonTipsMessage({ stringTblID=223,stringTblFormat={tostring(self.diamondPrivilegeCfg.price)}, nil,  callback = 
        function()
            ---@class KLUIMonthCardMainPanel
            local panel = GUI:GetUI("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel")
            panel:Refresh()
        end }) 
    end
end

function this:LUA_EVENT_PRIVILEGE_INFO_CHANGE(_, eventData)
    GUI:setVisible(self.view.prefab_diamond, false)
    GUI:setVisible(self.view.prefab_gold, false)
    if eventData and eventData ~= 0 then
        if eventData == 1 then
            GUI:setVisible(self.view.prefab_gold, true)
        else
            GUI:setVisible(self.view.prefab_diamond, true)
        end
    end
    self:Refresh()
end

function this:IntroduceSelf()
    --GUI:UIPanel_Open("dev/outui/Privilege/Panel/KLUIPrivilegeIntroduce/KLUIPrivilegeIntroducePanel")
    local helpCfg=SL:GetConfig("cfg_rule_text",7)
    if helpCfg then
        SL:CommonStrTipsMessage({title =helpCfg.menutxt,str=helpCfg.location})
    end
end

function this:CloseSelf()
    GUI:UIPanel_Close("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel")
end

function this:Close()
    --SL.ShowMainPanel()
end

return this
