---@class KLNewVIPMainPanel:UIKmlLuaPanelBase
---@field view KLNewVIPMainPanelView
local KLNewVIPMainPanel = class(UIKmlLuaPanelBase)
local this = KLNewVIPMainPanel
function this:AsyncLoadUI()
end

---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.buffDataList, function()
        return self:BuffDataListItemCountFunc()
    end, function(realIndex)
    end, function(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:BuffDataListItemUpdateFunc(realIndex, kmlcontrol)
    end
    )

    GUI:DataListInitData(self.view.UpRewardDataList, function()
        return self:UpRewardDataListItemCountFunc()
    end, function(realIndex)
    end, function(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:UpRewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)

    GUI:DataListInitData(self.view.DownRewardDataList, function()
        return self:DownRewardDataListItemCountFunc()
    end, function(realIndex)
    end, function(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DownRewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.selectGroup = nil
    self.allVIPTable = {}
    local allTable = SL:GetConfigTable("cfg_VIP");
    for key, value in pairs(allTable) do
        self.allVIPTable[value.grade] = value
    end
    self.maxLevel = #self.allVIPTable
    self.curLevel = InfoManager.newVipInfo.vipLevel
    self.BindCoinId = self:GetBindDiamondId()
end

--获得代币id
function this:GetBindDiamondId()
    local tbl = SL:GetConfigTable("cfg_item")
    for _, v in pairs(tbl) do
        if v.type == 1 and v.subType == 4 then
            return v.id
        end
    end
    return 10040001
end
---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_GetFree, self, self.GetFreeOnClick)
    GUI:AddOnClickEvent(self.view.btn_GetPay, self, self.GetPayOnClick)
    GUI:AddOnClickEvent(self.view.LeftPageBtn, self, self.LeftPageBtnOnClick)
    GUI:AddOnClickEvent(self.view.RightPageBtn, self, self.RightPageBtnOnClick)
    GUI:AddOnClickEvent(self.view.btn_up, self, self.UpOnClick)
    GUI:AddOnClickEvent(self.view.btn_close, self, self.CloseOnClick)
    SL:RegisterLUAEvent(LUA_EVENT_VIP_CHANGE, self.VIPChangCallBack, self)
    SL:RegisterLUAEvent(Event.BagInfo_Change, self.BagInfo_Change, self)
end

function this:BagInfo_Change()
    if self.selectLevel > self.curLevel then
        local vipPackCfg = SL:GetConfig("cfg_VIP_Pack", self.curVipCfg.VIPpack)
        local bagCount = SL:GetBagItemCount(vipPackCfg.Price[1])
        local color = bagCount >= vipPackCfg.Price[2] and EGradColor.green or EGradColor.red
        GUI:Text_setTextColor(self.view.txt_VipPrice, EColor[color])
    end
end

function this:VIPChangCallBack()
    self.curLevel = InfoManager.newVipInfo.vipLevel
    self:RefreshMain()
end

function this:CloseOnClick()
    GUI:UIPanel_Close("dev/outui/VIP/Panel/KLNewVIPMain/KLNewVIPMainPanel")
end

function this:UpOnClick()
    if self.selectLevel <= self.curLevel then
        return
    elseif self.selectLevel ~= self.curLevel + 1 then
        local text = string.format(SL:GetConfig('cfg_string', 472).text, self.selectLevel - 1)
        SL:TipMessage( text, 1, NoticeType.NoticeMid )
        return
    end
    local vipPackCfg = SL:GetConfig("cfg_VIP_Pack", self.curVipCfg.VIPpack)
    if not ConditionManager.Check(vipPackCfg.conditionid) then
        SL:TipMessage( SL:GetConfig('cfg_string', 486).text, 1, NoticeType.NoticeMid )
        return
    end
    local bagCount = SL:GetBagItemCount(vipPackCfg.Price[1]) + SL:GetBagItemCount(self.BindCoinId)
    if bagCount < vipPackCfg.Price[2] then
        SL:TipMessage( SL:GetConfig('cfg_string', 269).text, 1, NoticeType.NoticeMid ) 
        return
    end
    local count, totalCount = InfoManager.countInfo:GetLimitAndTotalCountByKey(vipPackCfg.Limitedid)
    if count <= 0 then
        return
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECHARGE, { count = 1, rechargeId = self.curVipCfg.VIPpack })
end

function this:RightPageBtnOnClick()
    local level = self.selectLevel
    level = Mathf.Clamp(level + 1, 1, self.maxLevel)
    if level ~= self.selectLevel then
        self.selectLevel = level
        self:RefreshMain()
    end
end

function this:LeftPageBtnOnClick()
    local level = self.selectLevel
    level = Mathf.Clamp(level - 1, 1, self.maxLevel)
    if level ~= self.selectLevel then
        self.selectLevel = level
        self:RefreshMain()
    end
end

function this:GetPayOnClick()
    if self.selectLevel > self.curLevel then
        SL:TipMessage( SL:GetConfig('cfg_string', 485).text, 1, NoticeType.NoticeMid )
        return
    end
    local PackCfg = SL:GetConfig("cfg_VIP_Pack", self.curVipCfg.greatpack)
    local bagCount = SL:GetBagItemCount(PackCfg.Price[1])+ SL:GetBagItemCount(self.BindCoinId)
    if bagCount < PackCfg.Price[2] then
        SL:TipMessage( SL:GetConfig('cfg_string', 269).text, 1, NoticeType.NoticeMid )
        return
    end
    local count, totalCount = InfoManager.countInfo:GetLimitAndTotalCountByKey(PackCfg.Limitedid)
    if count <= 0 then
        return
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECHARGE, { count = 1, rechargeId = self.curVipCfg.greatpack })
end

function this:GetFreeOnClick()
    if self.selectLevel > self.curLevel then
        SL:TipMessage( SL:GetConfig('cfg_string', 485).text, 1, NoticeType.NoticeMid ) --"副本中无法传送",
        return
    end
    local PackCfg = SL:GetConfig("cfg_VIP_Pack", self.curVipCfg.expack)
    -- local bagCount = SL:GetBagItemCount(PackCfg.Price[1])
    -- if bagCount< PackCfg.Price[2] then
    --     SL:TipMessage({SL:GetConfig('cfg_string',269).text, 1, NoticeType.NoticeMid })--"副本中无法传送",
    --     return
    -- end
    local count, totalCount = InfoManager.countInfo:GetLimitAndTotalCountByKey(PackCfg.Limitedid)
    if count <= 0 then
        return
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECHARGE, { count = 1, rechargeId = self.curVipCfg.expack })
end

---界面显示时调用一次
function this:Show()
    self.selectLevel = Mathf.Clamp(InfoManager.newVipInfo.vipLevel, 1, self.maxLevel)
    self:RefreshMain()
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:RefreshMain()
    self.buffList = {}
    self.upRewardList = {}
    self.downRewardList = {}
    GUI:setVisible(self.view.LeftPageBtn, self.selectLevel ~= 1)
    GUI:setVisible(self.view.RightPageBtn, self.selectLevel ~= self.maxLevel)
    GUI:setVisible(self.view.button18, false)
    GUI:setVisible(self.view.btn_GetPay, false)
    GUI:setVisible(self.view.button17, false)
    GUI:setVisible(self.view.btn_GetFree, false)
    GUI:setVisible(self.view.freeRedPoint, false)
    GUI:setVisible(self.view.priceRoot, self.selectLevel > self.curLevel)
    GUI:setVisible(self.view.txt_limitBuyCondition, self.selectLevel > self.curLevel)
    GUI:Text_setString(self.view.btn_up, self.selectLevel > self.curLevel and "开通VIP特权" or "特权已开通")
    local levelStr = tostring(self.selectLevel)
    GUI:Text_setString(self.view.vip_level, levelStr)
    GUI:Text_setString(self.view.vipLevel1, levelStr)
    GUI:Text_setString(self.view.VipLevel2, levelStr)
    GUI:Text_setString(self.view.VipLevel3, levelStr)
    GUI:Text_setString(self.view.vipLevelTp, levelStr)
    self.curVipCfg = self.allVIPTable[self.selectLevel]
    if self.curVipCfg then
        -- local count ,totalCount = InfoManager.countInfo:GetLimitAndTotalCountByKey(expackCfg.Limitedid)
        local vipPackCfg = SL:GetConfig("cfg_VIP_Pack", self.curVipCfg.VIPpack)
        local expackCfg = SL:GetConfig("cfg_VIP_Pack", self.curVipCfg.expack)
        local greatpackCfg = SL:GetConfig("cfg_VIP_Pack", self.curVipCfg.greatpack)

        local roleTotalMoney = Mathf.Floor(InfoManager.mainRechargeInfo.roleTotalMoney)
        local curNeedMoney = vipPackCfg.totalcharge
        local color = curNeedMoney <= roleTotalMoney and EGradColor.green or EGradColor.red
        local showMoney = string.format("<color=%s>%s</color>", EColor[color], roleTotalMoney)
        GUI:Text_setString(self.view.txt_limitBuyCondition, string.format("累充%s/%s元可开通", showMoney, curNeedMoney))

        self.upRewardList = self:GetCareerReward(expackCfg.Rewards)
        self.downRewardList = self:GetCareerReward(greatpackCfg.Rewards)
        GUI:Text_setString(self.view.GetPayText, tostring(greatpackCfg.Price[2]))
        if self.selectLevel <= self.curLevel then
            local count, totalCount = InfoManager.countInfo:GetLimitAndTotalCountByKey(expackCfg.Limitedid)
            local count2, totalCount2 = InfoManager.countInfo:GetLimitAndTotalCountByKey(greatpackCfg.Limitedid)
            local haveGreatpack = count2 <= 0
            local haveExpack = count <= 0
            GUI:setVisible(self.view.button17, haveExpack)
            GUI:setVisible(self.view.btn_GetFree, not haveExpack)
            GUI:setVisible(self.view.freeRedPoint, not haveExpack)
            GUI:setVisible(self.view.button18, haveGreatpack)
            GUI:setVisible(self.view.btn_GetPay, not haveGreatpack)
            GUI:Button_setGrey(self.view.btn_GetFree, false)
            GUI:Button_setGrey(self.view.btn_GetPay, false)
            -- GUI:Text_setString(self.view.txt_free, tostring(expackCfg.Price[2]))
        else
            GUI:setVisible(self.view.btn_GetFree, true)
            GUI:setVisible(self.view.btn_GetPay, true)
            GUI:Button_setGrey(self.view.btn_GetFree, true)
            GUI:Button_setGrey(self.view.btn_GetPay, true)
            local bagCount = SL:GetBagItemCount(vipPackCfg.Price[1])+ SL:GetBagItemCount(self.BindCoinId)
            local color = bagCount >= vipPackCfg.Price[2] and EGradColor.green or EGradColor.red
            GUI:Text_setString(self.view.txt_VipPrice, tostring(vipPackCfg.Price[2]))
            GUI:Text_setTextColor(self.view.txt_VipPrice, EColor[color])
        end
        self.buffList = {}
        local allStr = string.split(self.curVipCfg.text, "|")
        for key, value in pairs(allStr) do
            local allStrArr =  string.split(value, "\n")
            table.insert(self.buffList,{mainTxt = allStrArr[1],subTxt = allStrArr[2] })
        end 
    end
    self:RefreshRedPoint()
    GUI:DataListUpdateData(self.view.buffDataList)
    GUI:DataListUpdateData(self.view.UpRewardDataList)
    GUI:DataListUpdateData(self.view.DownRewardDataList)
end

function this:GetCareerReward(reward)
    local rewards = {}
    for key, value in ipairs(reward) do
        if value[1] == SL:MeData_GetCareer().baseCareer then
            table.insert(rewards, { value[2], value[3] })
        end
    end
    return rewards
end

function this:RefreshRedPoint()
    GUI:setVisible(self.view.LeftDot, false)
    GUI:setVisible(self.view.RightDot, false)
    for index, value in pairs(InfoManager.newVipInfo.allVIPRedPoint) do
        if index < self.selectLevel and value then
            GUI:setVisible(self.view.LeftDot, true)
        end
        if index > self.selectLevel and value then
            GUI:setVisible(self.view.RightDot, true)
        end
    end
end

function this:Close()
    SL.ShowMainPanel()
end

function this:BuffDataListItemCountFunc()
    -- SL:LogError("BuffDataListItemCountFunc", #self.leftCfgDataList)
    return #self.buffList
end

function this:BuffDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.buffList[realIndex + 1]
    local buffRoot = GUI:GetChildControl(self.view.buffDataList, realIndex, 'UINewVipPerTxtPointTemplate')
    local buffTxt = GUI:GetChildControl(self.view.buffDataList, realIndex, 'buffTxt')
    local buffTxtTip = GUI:GetChildControl(self.view.buffDataList, realIndex, 'buffTxtTip')
    GUI:Text_setString(buffTxt, data.mainTxt)
    GUI:setVisible(buffTxtTip, data.subTxt)
    
    if data.subTxt then
        GUI:Text_setString(buffTxtTip, data.subTxt)
        GUI:setContentSize(buffRoot,440,50)
    else
        GUI:setContentSize(buffRoot,440,25)
    end
end
 
 


function this:UpRewardDataListItemCountFunc()
    return #self.upRewardList
end

function this:UpRewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.upRewardList[realIndex + 1]
    local item = GUI:GetChildControl(self.view.UpRewardDataList, realIndex, 'upItem')
    GUI:Item_setItemId(item, data[1])
    GUI:Item_setItemCount(item, SL:GetSimpleNumber(data[2], 2))
    GUI:AddOnClickEvent(item, self, function()
        SL:OpenTips(nil, data[1])
    end)
end

function this:DownRewardDataListItemCountFunc()
    return #self.downRewardList
end

function this:DownRewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.downRewardList[realIndex + 1]
    local item = GUI:GetChildControl(self.view.DownRewardDataList, realIndex, 'downItem')
    GUI:Item_setItemId(item, data[1])
    GUI:Item_setItemCount(item, SL:GetSimpleNumber(data[2], 2))
    GUI:AddOnClickEvent(item, self, function()
        SL:OpenTips(nil, data[1])
    end)
end

return this
