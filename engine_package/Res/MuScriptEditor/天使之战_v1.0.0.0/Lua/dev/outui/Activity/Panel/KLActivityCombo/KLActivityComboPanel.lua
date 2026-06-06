---@class KLActivityComboPanel:UIKmlLuaPanelBase
---@field view KLActivityComboPanelView
local KLActivityComboPanel = class(UIKmlLuaPanelBase)
local this =KLActivityComboPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    self.activityType = 25001
    self.activityCfg = {}
    self.levelData_all_item = {}
    self.player_challenge_time = 0
    self.sweepTime = 0
    self.careerId = SL:GetMetaValue(EMetaVarGetKey.JOB)
    GUI:DataListInitData(self.view.levelList, function()
        return self:LevelDataListItemCountFunc()
    end, function(realIndex)
        return self:LevelDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlCtrl)
        return self:LevelDataListItemInitFunc(realIndex, kmlCtrl)
    end, function(realIndex, kmlCtrl)
        return self:LevelDataListItemUpdateFunc(realIndex, kmlCtrl)
    end)

    self.reward_all_item = {}
    GUI:DataListInitData(self.view.datalist_reward, function()
        return self:RewardDataListItemCountFunc()
    end, function(realIndex)
        return self:RewardDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlCtrl)
        return self:RewardDataListItemInitFunc(realIndex, kmlCtrl)
    end, function(realIndex, kmlCtrl)
        return self:RewardDataListItemUpdateFunc(realIndex, kmlCtrl)
    end)

    --SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_BLOODY_CASTLE_PANEL, tbl.id)
end

--region levelList

function this:LevelDataListItemCountFunc()
    return #self.levelData
end

function this:LevelDataListItemGetFunc(realIndex)

end

function this:LevelDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:LevelDataListItemUpdateFunc(realIndex, kmlCtrl)
    ---@type cfg_rep_column
    local data = self.levelData[realIndex + 1]
    local KLLevel = GUI:GetChildControl(self.view.levelList, realIndex, "KLLevel")
    local noClick = GUI:GetChildControl(self.view.levelList, realIndex, "noClick")
    local levelName = GUI:GetChildControl(self.view.levelList, realIndex, "levelName")

    if #data.skill == 0 then
        local cost = SL:GetBagItemCount(data.itemId[1])
        local text
        if data.itemId[1] and cost >= data.itemId[2] then
            text = "<color=#1ADD1F>" .. data.name[1] .. "</color>"
        else
            text = "<color=#FF2323>" .. data.name[1] .. "</color>"
        end
        GUI:Text_setString(levelName, text)
        --GUI:Text_setString(levelName, data.name[1])
        GUI:setVisible(noClick, false)
        GUI:setSwallowTouches(KLLevel,false)
    elseif self.comboSkillLevel >= data.skill[1][3] then
        GUI:Text_setString(levelName, data.name[1] .. " 连击技Lv." .. data.skill[1][3])
        GUI:setVisible(noClick, false)
        GUI:setSwallowTouches(KLLevel,false)
    else
        GUI:Text_setString(levelName, "连击技Lv." .. data.skill[1][3] .. "开启")
        GUI:setVisible(noClick, true)
        GUI:setSwallowTouches(KLLevel,true)
    end
    GUI:SetIsOnWithoutNotify(KLLevel, data.id == self.nowSelectLevelId)
    GUI:SetToggleOnValueChange(KLLevel, self, self.LevelOnToggleValueChange, data.id)

end

function this:LevelOnToggleValueChange(_, data, eventData)
    self:RefreshLevelMainInfo(data)
end

--endregion

--region rewardList

function this:RewardDataListItemCountFunc()
    return #self.rewardData
end

function this:RewardDataListItemGetFunc(realIndex)

end

function this:RewardDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:RewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    local reward = self.rewardData[realIndex + 1]
    local cfgId = reward[1]
    local count = reward[2]
    local args = {cfgId = cfgId, count = count}
    local pass_reward = GUI:GetChildControl(self.view.datalist_reward, realIndex, 'pass_reward')
    local img_pass_reward_click = GUI:GetChildControl(self.view.datalist_reward, realIndex, 'img_pass_reward_click')
    local img_quality = GUI:GetChildControl(self.view.datalist_reward, realIndex, 'img_quality')
    local img_arrow = GUI:GetChildControl(self.view.datalist_reward, realIndex, 'img_arrow')
    GUI:Item_setItemId(pass_reward, cfgId)
    if count and count > 1 then
        GUI:Item_setItemCount(pass_reward, count)
    end
    GUI:AddOnClickEvent(img_pass_reward_click, self, self.ShowItemTips, cfgId)
    local tab = SL:GetConfig('cfg_item', cfgId)
    if not tab or (tab and tab.type ~= EItemType.Equip) then
        GUI:setVisible(img_arrow, false)
    else
        if SL:CheckEquipBaseCareer(args) and SL:CompareInitGrage(args) == 1 then
            GUI:setVisible(img_arrow, true)
        else
            GUI:setVisible(img_arrow, false)
        end
        local entryLib = nil
        if SL:HasConfig('cfg_equip_entryLib', cfgId) then
            entryLib = SL:GetConfig('cfg_equip_entryLib', cfgId)
        end
        GUI:setVisible(img_quality, false)
        if entryLib then
            local qualityTbl = SL:GetConfigTable("cfg_equip_quality")
            ---@param v cfg_equip_quality_column
            for _, v in pairs(qualityTbl) do
                if not string.isNullOrEmpty(v.logo) and entryLib.initialRating >= v.stage[1] and entryLib.initialRating <= v.stage[2] then
                    GUI:setVisible(img_quality, true)
                    GUI:Image_loadTexture(img_quality, v.logo, "Atlas/UIBagPanel.spriteatlas")
                    break
                end
            end
        end
    end
end

function this:ShowItemTips(_, id)
    SL:OpenTips(nil, id)
end

--endregion

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.addCountBtn, self, self.OnClickAddCountBtn)
    GUI:AddOnClickEvent(self.view.enterBtn, self, self.OnClickEnterBtn)
    GUI:AddOnClickEvent(self.view.sweepBtn, self, self.OnClickSweepBtn)
    GUI:AddOnClickEvent(self.view.desBtn, self, self.OnClickDesBtn)
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.OnClickCloseBtn)
    GUI:AddOnClickEvent(self.view.bgClose, self, self.OnClickCloseBtn)
    GUI:AddOnClickEvent(self.view.ticketBtn, self, self.OnClickTicketBtn)

    GUI:AddOnClickEvent(self.view.ClickMask, self, self.ClickMaskOnClick)
    GUI:AddOnClickEvent(self.view.BtnBuy, self, self.BtnBuyOnClick)
    GUI:Input_SetOnEndEdit(self.view.InputFieldLevel, self, self.InputFieldLevelOnEndEdit)
    GUI:AddOnClickEvent(self.view.BtnLevelAdd, self, self.BtnLevelAddOnClick)
    GUI:AddOnClickEvent(self.view.BtnLevelMinus, self, self.BtnLevelMinusOnClick)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GET_ACTIVITY_COUNT, self.RES_GET_ACTIVITY_COUNT, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_KALIMA_TEMP_PANEL_INFO, self.RES_COMBO_TEST_PANEL_INFO, self)

    SL:RegisterLUAEvent(LUA_EVENT_MONEYCHANGE, self.LUA_EVENT_BAG_CHANGE_AFTER, self)
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    SL.HideMainPanel()
    GUI:setVisible(self.view.TextTotalPrice, false)
    GUI:setVisible(self.view.TotalPrice, false)
    GUI:Text_setString(self.view.BtnText, "扫荡")
    GUI:setVisible(self.view.sweep_panel, false)
    self.comboSkillLevel = InfoManager.dragonSoulSkillInfo.comboSkillLevel and InfoManager.dragonSoulSkillInfo.comboSkillLevel or 0
    self:RefreshLevelList()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_ACTIVITY_COUNT, self.activityType)
    SL:SendLuaNetMsg(LuaMessageIdToSever.KALIMA_TEMP_PANEL_INFO)
end

function this:RefreshLevelList()
    local tblList = SL:GetConfigTable("cfg_rep")
    self.levelData = {}
    ---@param v cfg_rep_column
    for i, v in pairs(tblList) do
        if self.activityType == v.type then
            self.activityCfg[v.id] = v
            self.levelData[v.repLevel] = v
        end
    end
    GUI:setContentSize(self.view.levelLayout,165,53 * #self.levelData)
end

function this:RefreshLevelMainInfo(id)
    self.nowSelectLevelId = id
    ---@type cfg_rep_column
    local data = self.activityCfg[id]
    self.nowSelectLevel = data.repLevel
    --[[    if #data.skill > 0 then
            GUI:Text_setString(self.view.level, data.repLevel .. "级(连击技能Lv." .. data.skill[1][3] .. ")")
        end]]
    GUI:Text_setString(self.view.level, data.repLevel .. "级")
    if data.level then
        if data.level[1] then
            GUI:Text_setString(self.view.level, data.level[1] .. "级")
        end
        if data.level[1] and data.level[2] then
            GUI:Text_setString(self.view.level, data.level[1] .."~"..data.level[2].. "级")
        end
    end
    self:RefreshItemCount()
    self.rewardData = {}
    for index, value in ipairs(data.UIJobReward) do
        if value[1] == 0 or value[1] == SL:MeData_GetCareer().baseCareer then--基础职业
            table.insert(self.rewardData,{[1] = value[2]})
        end
    end
    for index, value in ipairs(data.UIreward) do
        table.insert(self.rewardData,value)
    end
    GUI:DataListUpdateData(self.view.datalist_reward)
    GUI:setVisible(self.view.text_btnTips, false)
    GUI:setVisible(self.view.sweepBtn, true)
    if self.nowSelectLevelId <= self.nowMaxLevelId then
        GUI:setGrey(self.view.sweepBtn, false)
    else
        GUI:setGrey(self.view.sweepBtn, true)
    end
end

function this:RefreshItemCount()
    local data = self.activityCfg[self.nowSelectLevelId]
    local cost = SL:GetBagItemCount(data.itemId[1])
    local text
    if not data.itemId[1] then
        return
    end
    if cost >= data.itemId[2] then
        text = "<color=#1ADD1F>" .. cost .. "</color>"
    else
        text = "<color=#FF2323>" .. cost .. "</color>"
    end
    GUI:Text_setString(self.view.ticketCount, text .. "/" .. data.itemId[2])
    GUI:Item_setItemId(self.view.ticketItem, data.itemId[1])
end

function this:OnClickAddCountBtn()
    ---@type cfg_rep_column
    local tbl = SL:GetConfigMultiKeys("cfg_rep", self.activityType, self.nowSelectLevel, "type", "repLevel")
    SL:CommonItemGetPath(nil, tbl.itemId[1])
end

function this:OnClickEnterBtn()
    local isInTeam = SL:GetMetaValue(EMetaVarGetKey.TEAM_IS_IN)
    if isInTeam then
        SL:TipMessage( SL:GetConfig('cfg_string',34001).text,1, NoticeType.NoticeMid )
        return
    end

    ---@type cfg_rep_column
    local tbl = self.activityCfg[self.nowSelectLevelId]
    if not tbl then
        return
    end
    local ownerTicket = SL:GetBagItemCount(tbl.itemId[1])
    local tip
    if not tbl.itemId[1] then
        tip = "缺少门票"
    elseif ownerTicket < tbl.itemId[2] then
        tip = "门票不足"
        ---@type cfg_rep_column
        SL:CommonItemGetPath(nil, tbl.itemId[1])
    end
    if not tip then
        ---进入副本
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ENTER_DUPLICATE, tbl.id)
        self:OnClickCloseBtn()
    else
        SL:TipMessage(tip, 1, NoticeType.NoticeMid)
    end
end

function this:OnClickSweepBtn()
    if self.nowSelectLevelId > self.nowMaxLevelId then
        SL:TipMessage("通过本层后，解锁扫荡功能", 1, NoticeType.NoticeMid )
        return
    end
    local repSweepTbl = SL:GetConfig("cfg_rep_QuestSweep",self.nowSelectLevelId,'repid')
    local SweepData=
    {
        sweepTime = self.sweepTime,
        level = repSweepTbl.layer,
        deplete = repSweepTbl.deplete,
        extra = repSweepTbl.extra,
        drop = repSweepTbl.drop,
        nowSelectLevelId = self.nowSelectLevelId
    }
    GUI:UIPanel_Open("dev/outui/Activity/Panel/KLKaLiMaSweep/KLKaLiMaSweepPanel",nil,nil,SweepData )
    --if self.player_challenge_time > 0 then
    --else
    --    SL:TipMessage( "剩余次数不足", 1, NoticeType.NoticeMid )
    --end

end

function this:OpenFirsh()
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLActivityCombo/KLActivityComboPanel")
    SL:GoRechargePanle()
end

function this:OnClickDesBtn()
    local helpCfg = SL:GetConfig("cfg_rule_text", 401)
    if helpCfg then
        SL:CommonStrTipsMessage({ title = helpCfg.menutxt, str = helpCfg.location })
    end
end

function this:OnClickCloseBtn()
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLActivityCombo/KLActivityComboPanel")
end

function this:OnClickTicketBtn()
    ---@type cfg_rep_column
    local tbl = SL:GetConfigMultiKeys("cfg_rep", self.activityType, self.nowSelectLevel, "type", "repLevel")
    SL:OpenTips(nil, tbl.itemId[1])
end

function this:BtnBuyOnClick()
    local count = tonumber(GUI:Text_getString(self.view.InputFieldLevel))
    if self.player_challenge_time > 0 and count > 0 then
        ---@type cfg_rep_column
        local tbl = self.activityCfg[self.nowSelectLevelId]
        local ownerTicket = SL:GetBagItemCount(tbl.itemId[1])
        if ownerTicket < tbl.itemId[2] * count then
            SL:TipMessage("门票不足", 1, NoticeType.NoticeMid)
        else
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SWEEP_THROUGH_DUNGEONS, { self.nowSelectLevelId, count })
            GUI:setVisible(self.view.sweep_panel, false)
        end
    end
end

function this:InputFieldLevelOnEndEdit(_, _, eventData)
    local text = eventData[1]
    GUI:Text_setString(self.view.InputFieldLevel, tostring(text))
    self:CheckInput()
end

function this:BtnLevelAddOnClick()
    local inputNum = tonumber(GUI:Text_getString(self.view.InputFieldLevel))
    GUI:Text_setString(self.view.InputFieldLevel, tostring(inputNum + 1))
    self:CheckInput()
end

function this:BtnLevelMinusOnClick()
    local inputNum = tonumber(GUI:Text_getString(self.view.InputFieldLevel))
    inputNum = inputNum - 1
    GUI:Text_setString(self.view.InputFieldLevel, tostring(inputNum))
    self:CheckInput()
end

function this:CheckInput()
    local inputStr = GUI:Text_getString(self.view.InputFieldLevel)
    local inputNum = tonumber(inputStr)
    if not inputNum then
        GUI:Text_setString(self.view.InputFieldLevel, "1")
        return
    end
    if inputNum >= self.player_challenge_time then
        GUI:Text_setString(self.view.InputFieldLevel, tostring(self.player_challenge_time))
        return
    end
    if inputNum <= 0 then
        GUI:Text_setString(self.view.InputFieldLevel, "0")
        return
    end
end

function this:ClickMaskOnClick()
    GUI:setVisible(self.view.sweep_panel, false)
end

function this:RES_GET_ACTIVITY_COUNT(_, message)
    if tonumber(message["1"]) == self.activityType then
        self.player_challenge_time = message["2"]
        if self.maxCount then
            self:RefreshChallengeTime()
        end
    end
end

function this:RES_COMBO_TEST_PANEL_INFO(_, message)
    self.nowMaxLevelId = message.id
    self.nowMaxLevel = message.level
    self.maxCount = message.count
    self.player_challenge_time = message.count
    self.sweepTime = message.leftSweepCount
    self:GetNowCanChallengeLevel()
    self:RefreshLevelMainInfo(self.nowSelectLevelId)
    GUI:DataListUpdateData(self.view.levelList)

    if self.player_challenge_time then
        self:RefreshChallengeTime()
    end
end

function this:GetNowCanChallengeLevel()
    self.nowSelectLevelId = self.levelData[1].id
end

function this:LUA_EVENT_BAG_CHANGE_AFTER()
    if self.timer then
        SL:UnSchedule(self.timer)
    end
    self.timer = SL:ScheduleOnce(0.1, function()
        self:RefreshItemCount()
    end)
end

function this:RefreshChallengeTime()
    local text
    if self.player_challenge_time <= 0 then
        text = "<color=#FF2323>" .. 0 .. "</color>"
    else
        text = self.player_challenge_time
    end
    --GUI:Text_setString(self.view.countTxt, text .. "/" .. self.maxCount .. "次")
    GUI:Text_setString(self.view.countTxt, tostring(text))
end

function this:Hide()
end

function this:Close()
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
    GUI:setVisible(self.view.TextTotalPrice, true)
    GUI:setVisible(self.view.TotalPrice, true)
    GUI:Text_setString(self.view.BtnText, "购买")
    SL.ShowMainPanel()
end

return this