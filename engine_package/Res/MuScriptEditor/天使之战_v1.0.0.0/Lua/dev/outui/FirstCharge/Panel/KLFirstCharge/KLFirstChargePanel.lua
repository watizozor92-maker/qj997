---@class KLFirstChargePanel:UIKmlLuaPanelBase
---@field view KLFirstChargePanelView
local KLFirstChargePanel = class(UIKmlLuaPanelBase)
local this = KLFirstChargePanel

---创建时调用一次
function this:Init()
    self.ChargeList = {}
    local ChargeTbl = SL:GetConfigTable("cfg_recharge")
    for _, v in pairs(ChargeTbl) do
        if v.type == ERechargeType.FirstChargeGift then
            table.insert(self.ChargeList, v)
        end
    end
    self.CoinRate = 10 --货币转换率
    SL:KeepOpenPanel("FirstCharge",true)
end
---界面显示时调用一次
function this:Show()
    self.message = nil
    self.needCount = 0
    self.rechargeTbl = nil
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECHARGE_ACTION, { type = 3, action = "panel" })
    self.ItemList = {}
    self.selectIndex = 1---当前页数
    if self.args and self.args.PanelType then
        self.selectIndex = self.args.PanelType
    end

    self:ShowBtnToggle(self.selectIndex)--默认展示
    SL:HideMainPanel()
    
    GUI:UIPanel_Close("dev/outui/FirstCharge/Panel/KLFirstChargeAD/KLFirstChargeADPanel")
end
---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_Close, self, self.btn_CloseOnClick)
    GUI:SetToggleOnValueChange(self.view.panel_day1, self, self.ChangeDay1Page)
    GUI:SetToggleOnValueChange(self.view.panel_day2, self, self.ChangeDay2Page)
    GUI:SetToggleOnValueChange(self.view.panel_day3, self, self.ChangeDay3Page)
    GUI:AddOnClickEvent(self.view.btn_tips, self, self.btn_tipsOnClick)
    GUI:AddOnClickEvent(self.view.btn_charge, self, self.btn_chargeOnClick)
    SL:RegisterLUAEvent(LUA_EVENT_RES_FIRST_CHARGE_GIFT_INFO, self.RES_FirstChargeGift_Info, self)
    SL:RegisterLUAEvent(LUA_EVENT_Open_MainButtonList, self.LUA_EVENT_Open_MainButtonList, self)
end

function this:LUA_EVENT_Open_MainButtonList()
    SL:HideMainPanel()
end

function this:RES_FirstChargeGift_Info(_, message)
    if message then
        self.message = message
        --self:SetBtnShow(message)
        self:SetBtnShow(message)
        --self:UpdateUIData(message)
    end
end
function this:UpdateUIData(message)
    if message then
        GUI:SetScrollView_scrollpos(self.view.scrollviewItemList, 0)
        local countTbl = SL:GetConfig("cfg_recharge", self:GetIdByIndex(self.selectIndex))
        self.needCount, self.rechargeTbl = self:SetNeedCount(countTbl, message)
        ----UI
        GUI:Text_setString(self.view.Text_tips, tostring(self.needCount*self.CoinRate))
        GUI:SetActive(self.view.Text_accumulation, true)
        if self.needCount <= 0 then
            GUI:SetActive(self.view.Text_tips, false)
            -- GUI:Text_setString(self.view.charge_Text, "领取")
            GUI:SetActive(self.view.GetText, true)
            GUI:SetActive(self.view.ChargeText, false)
            GUI:Text_setString(self.view.Text_accumulation, Misc.ReturnRichTextByColorAndText(EColor[EGradColor.red], "0元"))
            GUI:SetActive(self.view.Text_accumulation, false)
        else
            GUI:Text_setString(self.view.Text_accumulation, Misc.ReturnRichTextByColorAndText(EColor[EGradColor.red], self.needCount .. "元"))
            GUI:SetActive(self.view.Text_tips, false)
            --GUI:SetActive(self.view.panel_68, false)
            --GUI:SetActive(self.view.bg1, false)
            for _, v in pairs(self.ChargeList) do
                if v.amount == self.needCount then  
                    if  v.gain and v.gain[1] and v.gain[1][2] then
                        GUI:Text_setString(self.view.Text_tips, tostring(v.gain[1][2]))
--[[                        local numStr = tostring(v.gain[1][2])
                        local num = #numStr - 3
                        GUI:setAnchorPoint(self.view.Text_tips, 312 - 5 * num, -109)]]
                        GUI:SetActive(self.view.Text_tips, true)
                        --GUI:SetActive(self.view.panel_68, true)
                        --GUI:SetActive(self.view.bg1, true)
                    else
                        GUI:Text_setString(self.view.Text_tips, tostring(self.needCount * self.CoinRate))
                    end
                end
            end
            GUI:SetActive(self.view.ChargeText, true)
            -- GUI:Text_setString(self.view.charge_Text, "充值")
            GUI:SetActive(self.view.GetText, false)
        end
        GUI:SetActive(self.view.red1, false)
        GUI:SetActive(self.view.red2, false)
        GUI:SetActive(self.view.red3, false)

        GUI:SetActive(self.view.btn_charge, true)
        GUI:SetActive(self.view.hasReceive_text, false)
        self.IsGet = false

        for id, state in pairs(message.data.rewards) do
            if countTbl.id == tonumber(id) then
                if state ~= 2 then
                    GUI:SetActive(self.view.btn_charge, true)
                    GUI:SetActive(self.view.hasReceive_text, false)
                    self.IsGet = false
                else
                    GUI:SetActive(self.view.btn_charge, false)
                    GUI:SetActive(self.view.hasReceive_text, true)
                    self.IsGet = true
                end
            end
            if tonumber(id) == EFirstRechargeLevel.one and state == 1 then
                GUI:SetActive(self.view.red1, true)
            end
            if tonumber(id) == EFirstRechargeLevel.two and state == 1 then
                GUI:SetActive(self.view.red2, true)
            end
            if tonumber(id) == EFirstRechargeLevel.three and state == 1 then
                GUI:SetActive(self.view.red3, true)
            end
        end
    end
end

function this:SetNeedCount(countTbl, message)
    local needCount = 0
    local rechargeTbl = nil
    if message then
        ---先计算获得金额
        local count = 0
        local reward1 = false
        local reward2 = false
        local reward3 = false
        for id, state in pairs(message.data.rewards) do
            if state == 1 or state == 2 then
                --已领取和充值的的
                if self:GetIndexByID(tonumber(id)) == 1 then
                    reward1 = true
                elseif self:GetIndexByID(tonumber(id)) == 2 then
                    reward2 = true
                elseif self:GetIndexByID(tonumber(id)) == 3 then
                    reward3 = true
                end
                count = count + SL:GetConfig("cfg_recharge", tonumber(id)).amount
            end
        end
        --6情况列举
        if self.selectIndex == 1 then
            --第一个界面
            if reward1 then
                needCount = 0
                rechargeTbl = SL:GetConfig("cfg_recharge", EFirstRechargeLevel.one)
                return needCount, rechargeTbl
            end
            rechargeTbl = SL:GetConfig("cfg_recharge", EFirstRechargeLevel.one)
            needCount = rechargeTbl.amount
        end
        if self.selectIndex == 2 then
            --第2个界面
            if reward2 then
                needCount = 0
                rechargeTbl = SL:GetConfig("cfg_recharge", EFirstRechargeLevel.two)
                return needCount, rechargeTbl
            end
            rechargeTbl = SL:GetConfig("cfg_recharge", EFirstRechargeLevel.two)
            if reward1 then
                rechargeTbl = SL:GetConfig("cfg_recharge", EFirstRechargeLevel.four)
            end
            needCount = rechargeTbl.amount
        end
        if self.selectIndex == 3 then
            --第3个界面
            if reward3 then
                needCount = 0
                rechargeTbl = SL:GetConfig("cfg_recharge", EFirstRechargeLevel.three)
                return needCount, rechargeTbl
            end
            rechargeTbl = SL:GetConfig("cfg_recharge", EFirstRechargeLevel.three)
            if reward1 then
                rechargeTbl = SL:GetConfig("cfg_recharge", EFirstRechargeLevel.six)
            end
            if reward2 then
                rechargeTbl = SL:GetConfig("cfg_recharge", EFirstRechargeLevel.five)
            end
            needCount = rechargeTbl.amount
        end
    end
    return needCount, rechargeTbl
end
function this:SetBtnShow(message)
    if message then
        if message.data.rewards then
            --默认跳转页面
            local sortIndex = {}
            local allGot = true
            for i = 1, 3 do
                local state = message.data.rewards[tostring(i + 300)]
                allGot = allGot and state == 2
                table.insert(sortIndex,{id = i + 300, state = state})
            end
            if allGot then
                self:ShowBtnToggle(3)
            else
                table.sort(sortIndex, function(a,b)
                    local wa = a.state == 2 and 100 or 0
                    local wb = b.state == 2 and 100 or 0
                    return wa + a.id < wb + b.id
                end)
                self:ShowBtnToggle(sortIndex[1].id - 300)
            end
            
        end
    end
end

function this:ShowBtnToggle(index)
    if index == 1 then
        self.selectIndex = 1
        GUI:Toggle_setIsOn(self.view.panel_day1, true)
        self:UpdatePanelData(1)
    elseif index == 2 then
        self.selectIndex = 2
        GUI:Toggle_setIsOn(self.view.panel_day2, true)
        self:UpdatePanelData(2)
    else
        self.selectIndex = 3
        GUI:Toggle_setIsOn(self.view.panel_day3, true)
        self:UpdatePanelData(3)
    end

end
function this:btn_chargeOnClick()
    if self.rechargeTbl then
        if self.needCount <= 0 then
            if not self.IsGet then
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECHARGE_ACTION, { type = 3, action = "reward", id = self.rechargeTbl.id })
            end
        else
            GUIUtil.SDKPay(self.rechargeTbl, 1)
        end
    end
end

function this:btn_tipsOnClick()
    SL:CommonStrTipsMessage({ title = "提示", str = SL:GetConfig("cfg_rule_text", 105).location, ui = self })
end
--第一天  
function this:ChangeDay1Page(control, eventData)
    if GUI:Toggle_getIsOn(control) == "1" then
        self.selectIndex = 1
        self:ShowAdImage(1)
        self:UpdatePanelData(1)
    end
end

--第二天  
function this:ChangeDay2Page(control, eventData)
    if GUI:Toggle_getIsOn(control) == "1" then
        self.selectIndex = 2
        self:ShowAdImage(2)
        self:UpdatePanelData(2)
    end
end

--第三天  
function this:ChangeDay3Page(control, eventData)
    if GUI:Toggle_getIsOn(control) == "1" then
        self.selectIndex = 3
        self:ShowAdImage(3)
        self:UpdatePanelData(3)
    end
end
function this:GetIdByIndex(index)
    return index + 300
end
function this:GetIndexByID(cfgId)
    return cfgId - 300
end
function this:UpdatePanelData(index)
    --显示奖励  
    ---@type cfg_recharge_column
    local firstTbl = SL:GetConfig("cfg_recharge", self:GetIdByIndex(index))
    local firstChargeTbl = SL:GetConfig("cfg_first_charge", self:GetIdByIndex(index))
    self:SetTextShow(index)
    GUI:Text_setString(self.view.number, firstTbl.amount)
    if firstChargeTbl.font then
        GUI:Text_setString(self.view.ShowInfoText, firstChargeTbl.font)
    else
        GUI:Text_setString(self.view.ShowInfoText, "")
    end
    local careerId = SL:GetMetaValue(EMetaVarGetKey.JOB)
    local index = 1
    for _,v in pairs(self.ItemList) do
        if v then
            GUI:SetActive(v,false)
        end
    end
    for i, award in pairs(firstChargeTbl.firstReward) do
        --首充道具
        if award[1] == nil or (careerId ~= nil and careerId == award[1]) then
            index = index + 1
            local itemId = award[2]
            local count = award[3]
            local data = {
                width = "100",
                height = "100",
                itemid = itemId,
                mfixsize = "100,100",
                tips = "1",
                itemcustomcount = count
            }
            if self.ItemList[index] then
                GUI:Item_UpdataData(self.ItemList[index], data)
                GUI:SetActive(self.ItemList[index],true)
            else
                local item = GUI:Item_Create(self.view.layout2, data)
                self.ItemList[index] = item
            end
            GUI:AddOnClickEvent(self.ItemList[index], self, function()
                SL:OpenTips(nil, itemId,nil,nil,nil,{firstCharge=true})
            end)
        end
    end
    self:ShowMountModel(firstChargeTbl,careerId)
    GUI:SetActive(self.view.Imager11, true)

    self:UpdateUIData(self.message)
end

function this:SetTextShow(index)
    ---@type cfg_recharge_column
    local firstTbl1 = SL:GetConfig("cfg_recharge", self:GetIdByIndex(1))
    ---@type cfg_recharge_column
    local firstTbl2 = SL:GetConfig("cfg_recharge", self:GetIdByIndex(2))
    ---@type cfg_recharge_column
    local firstTbl3 = SL:GetConfig("cfg_recharge", self:GetIdByIndex(3))
    ---@type cfg_first_charge_column
    local firstTbl11 = SL:GetConfig("cfg_first_charge", self:GetIdByIndex(1))
    ---@type cfg_first_charge_column
    local firstTbl22 = SL:GetConfig("cfg_first_charge", self:GetIdByIndex(2))
    ---@type cfg_first_charge_column
    local firstTbl33 = SL:GetConfig("cfg_first_charge", self:GetIdByIndex(3))
    local curGainId = 0
    if index == 1 then
        curGainId = (firstTbl1.gain[1] and firstTbl1.gain[1][1]) or 0
        GUI:Text_setString(self.view.text_recharge_num,tostring(firstTbl1.amount))
        GUI:Text_setString(self.view.text_reward_num,tostring(firstTbl11.count))
        GUI:Text_setString(self.view.Text_tips, tostring(firstTbl1.amount * self.CoinRate))
        GUI:Text_setString(self.view.RebateText, tostring(firstTbl11.count2) .. "%")
        GUI:Text_setString(self.view.togText_day1, "<color=#FFFDDA>" .. "累充" .. firstTbl1.amount .. "元" .. "</color>")
    else
        GUI:Text_setString(self.view.togText_day1, "<color=#D6AA8F>" .. "累充" .. firstTbl1.amount .. "元" .. "</color>")
    end
    if index == 2 then
        curGainId = (firstTbl2.gain[1] and firstTbl2.gain[1][1]) or 0
        GUI:Text_setString(self.view.text_recharge_num,tostring(firstTbl2.amount))
        GUI:Text_setString(self.view.text_reward_num,tostring(firstTbl22.count))
        GUI:Text_setString(self.view.Text_tips, tostring(firstTbl2.amount * self.CoinRate))
        GUI:Text_setString(self.view.RebateText, tostring(firstTbl22.count2) .. "%")
        GUI:Text_setString(self.view.togText_day2, "<color=#FFFDDA>" .. "累充" .. firstTbl2.amount .. "元" .. "</color>")
    else
        GUI:Text_setString(self.view.togText_day2, "<color=#D6AA8F>" .. "累充" .. firstTbl2.amount .. "元" .. "</color>")
    end
    if index == 3 then
        curGainId = (firstTbl3.gain[1] and firstTbl3.gain[1][1]) or 0
        GUI:Text_setString(self.view.text_recharge_num,tostring(firstTbl3.amount))
        GUI:Text_setString(self.view.text_reward_num,tostring(firstTbl33.count))
        GUI:Text_setString(self.view.Text_tips, tostring(firstTbl3.amount * self.CoinRate))
        GUI:Text_setString(self.view.RebateText, tostring(firstTbl33.count2) .. "%")
        GUI:Text_setString(self.view.togText_day3, "<color=#FFFDDA>" .. "累充" .. firstTbl3.amount .. "元" .. "</color>")
    else
        GUI:Text_setString(self.view.togText_day3, "<color=#D6AA8F>" .. "累充" .. firstTbl3.amount .. "元" .. "</color>")
    end
    local isGainDiamond = curGainId == 10040001
    GUI:setVisible(self.view.img_70,isGainDiamond)
    GUI:setVisible(self.view.img_72,isGainDiamond)
    GUI:setVisible(self.view.text_reward_num,isGainDiamond)
    GUI:setVisible(self.view.img_text1,isGainDiamond)
    GUI:setVisible(self.view.img_text4,not isGainDiamond)
    
end
function this:ShowAdImage(index)
    GUI:SetActive(self.view.font_ad, index == 1)
    GUI:SetActive(self.view.font_ad2, index == 1)
    GUI:SetActive(self.view.font_ad3, index == 1)
end
function this:btn_CloseOnClick()
    GUI:UIPanel_Close("dev/outui/FirstCharge/Panel/KLFirstCharge/KLFirstChargePanel")
end

function this:ShowMountModel(FirstChargeTbl,careerId)
    if not FirstChargeTbl then
        return
    end
    local scale =1/10
    local mrotate = "0,0,0"
    local x = "0"
    local y = "0"
    local z="0"
    local path = ""
    local ani = ""
    local rX=1
    local rY=0
    local rZ=0
    for _, model1 in pairs(FirstChargeTbl.model) do
        if tonumber(model1[3]) == careerId then
            path = model1[1]
            GUI:Text_setString(self.view.ShowInfoText, tostring(model1[2]))
        end
    end
    for _, model2 in pairs(FirstChargeTbl.modelCondition) do
        if tonumber(model2[5]) == careerId then
            x=model2[1]
            y =model2[2]
            z = model2[3]
            scale = tonumber(model2[4])
        end
    end
    for _, model3 in pairs(FirstChargeTbl.modelRevolve) do
        if tonumber(model3[4]) == careerId then
            --mrotate = model3[1].. "," .. model3[2] .. "," .. model3[3]
            rX = tonumber(model3[1])
            rY = tonumber(model3[2])
            rZ = tonumber(model3[3])
        end
    end
    for _, model4 in pairs(FirstChargeTbl.modelBehavior) do
        if tonumber(model4[2]) == careerId then
            ani=model4[1]
        end
    end

    local data = {
        mscale = 1 .. "," .. 1 .. "," .. 1,
        mrotate = "0,0,0",
        x = x,
        y = y,
        z = z,
        a = "00",
        src = path,
        ani = ani,
    }
    if self.cur_mount_model then
        GUI:Item_UpdataData(self.cur_mount_model, data)
    else
        self.cur_mount_model = GUI:Model_Create(self.view.Model_item, data)
    end
    GUI:setScale(self.cur_mount_model, scale/10)
    --GUI:setAllRotation(self.cur_mount_model,{rX,rY,rZ})
    GUI:setRotationSkewX(self.cur_mount_model,rX)
    GUI:setRotationSkewY(self.cur_mount_model,rY)
    GUI:setRotation(self.cur_mount_model,rZ)
end
--[[function this:ShowUIModel(itemId)
    local data = {
        itemid = itemId,
    }
    GUI:Item_UpdataData(self.view.Model_item, data)
end]]
---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:Close()
    SL:ShowMainPanel()
end

return this
