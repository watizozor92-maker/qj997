---@class KLUnionInfoPanel:UIKmlLuaPanelBase
---@field view KLUnionInfoPanelView
local KLUnionInfoPanel = class(UIKmlLuaPanelBase)
local this =KLUnionInfoPanel
---创建时调用一次
function this:Init()
    GUI:SetAsFirstSibling(self.view.info_panel)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL:ReqViewUnionMessage()
    SL:ReqUnionMemberDynamicMessage()
    GUI:setVisible(self.view.btn_Impeach, false)
    GUI:setVisible(self.view.btn_Replace, false)
    ---放到KLUnionToggleListPanel界面请求，如果没有数据(网络延时等等)，重新请求一次
    local info = InfoManager.unionElectionInfo.MyUnionInfo
    if InfoManager.unionElectionInfo.MyUnionInfo then
        self:RES_GET_UNION_INFO(_, info)
    else
        self.timer = SL:ScheduleOnce(Time.deltaTime,function()
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_UNION_INFO)
        end)
    end
end

function this:StopTimer()
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_VIEW_UNION,self.ResViewUnionMessage, self)
    SL:RegisterLUAEvent(LUA_EVENT_UNION_MEMBER_DYNAMIC,self.ResUnionMemberDynamicMessage, self)
    SL:RegisterLUAEvent(LUA_EVENT_UNION_NAME_VIEW,self.ResUnionNameViewMessage, self)
    SL:RegisterLUAEvent(LUA_EVENT_QUIT_UNION,self.ResQuitUnionMessage, self)
    SL:RegisterLUAEvent(LUA_EVENT_UNION_MEMBER_CHANGE,self.ResUnionMemberChangeMessage, self)
    SL:RegisterLUAEvent(LUA_EVENT_VIEW_UNION_CHANGE,self.ResViewUnionChangeMessage, self)
    GUI:AddOnClickEvent(self.view.exitButton, self, self.exitButton)
    GUI:AddOnClickEvent(self.view.changeUnionNameBtn, self, self.changeUnionNameBtn)
    GUI:AddOnClickEvent(self.view.btn_panel_name_no, self, self.btn_panel_name_no)
    GUI:AddOnClickEvent(self.view.btn_panel_name_yes, self, self.btn_panel_name_yes)
    GUI:AddOnClickEvent(self.view.btn_3DItem, self, self.btn_3DItem)
    GUI:AddOnClickEvent(self.view.CloseButton, self, self.CloseButton)
    GUI:AddOnClickEvent(self.view.changeFlagBtn, self, self.changeFlagBtn)
    GUI:AddOnClickEvent(self.view.changeAnnoyBtn, self, self.changeAnnoyBtn)
    GUI:AddOnClickEvent(self.view.btn_panel_report_yes, self, self.btn_panel_report_yes)
    GUI:AddOnClickEvent(self.view.btn_panel_report_no, self, self.btn_panel_report_no)
    GUI:AddOnClickEvent(self.view.Btn_ReportClose, self, self.btn_panel_report_no)
    GUI:AddOnClickEvent(self.view.reportMask, self, self.reportMask)
    GUI:AddOnClickEvent(self.view.nameMask, self, self.nameMask)
    GUI:AddOnClickEvent(self.view.inexpAddButton, self, self.inexpAddButton)
    
    GUI:AddOnClickEvent(self.view.btn_Impeach, self, self.OnClickBtnImpeach)
    GUI:AddOnClickEvent(self.view.btn_Election, self, self.OnClickBtnElection)
    GUI:AddOnClickEvent(self.view.btn_Replace, self, self.OnClickBtnReplace)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GET_UNION_INFO, self.RES_GET_UNION_INFO, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_UNION_LEADER_ON_LINE_STATE, self.RES_GET_UNION_INFO, self)
end

function this:RES_GET_UNION_INFO(id, message)
    self.outUnionInfo = message
    self:StopCountDownReqUnionInfo()
    local info = InfoManager.unionElectionInfo:GetSelfPermissionCfg()
    if info and info.post == 1 then
        GUI:setVisible(self.view.changeAnnoyBtn,true)
    
    else
        GUI:setVisible(self.view.changeAnnoyBtn,false)
    end
    
    if info and info.changeName == 1 then
        GUI:setVisible(self.view.changeUnionNameBtn,true)
        --GUI:setVisible(self.view.changeFlagBtn,true)
    else
        GUI:setVisible(self.view.changeUnionNameBtn,false)
        GUI:setVisible(self.view.changeFlagBtn,false)
    end
    
    if tostring(message.leaderid) ~= "0" then
        GUI:setVisible(self.view.btn_Election, false)
        local myId = SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID)
        if tonumber(myId) == tonumber(message.leaderid) then
            --盟主是自己的时候不显示取代和弹劾
            GUI:setVisible(self.view.btn_Replace, false)
            GUI:setVisible(self.view.btn_Impeach, false)
            return
        end
        --有盟主显示 弹劾或者取代
        ---@type cfg_unionLevel_column
        local cfg = SL:GetConfig("cfg_unionLevel", tonumber(message.unionlevel), "unionLevel")
        local leaderInfo = message.memberinfos[tostring(message.leaderid)]
        local now =  tonumber(SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME))
        local deltaTime = now - tonumber(leaderInfo.quitlinetime)
        if deltaTime > cfg.continuousOfflineTime  * 60000 and tostring( leaderInfo.online) ~= "true" then
            --盟主离线cfg.continuousOfflineTime分钟后，显示取代
            GUI:setVisible(self.view.btn_Replace, true)
            GUI:setVisible(self.view.btn_Impeach, false)
            local endTime = InfoManager.unionElectionInfo:GetReplaceEndTime()
            if endTime then
                if tonumber(endTime) <= now then
                    GUI:setVisible(self.view.btn_Replace, false)
                end
            end
        else
            GUI:setVisible(self.view.btn_Replace, false)
            GUI:setVisible(self.view.btn_Impeach, true)
            local delta = cfg.continuousOfflineTime  * 60000 - deltaTime
            if delta > 0 and tostring(leaderInfo.online) ~= "true"  then
                --计算盟主的离线时间 当打到取代条件时刷新界面显示取代按钮
                self.countDownReq = SL:ScheduleOnce((delta)/1000 + 1, function()
                    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_UNION_INFO)
                end) 
            end
        end
    else
        --无盟主状态下显示竞选
        GUI:setVisible(self.view.btn_Election, true)
        local endTime = InfoManager.unionElectionInfo:GetElectionEndTime()
        if endTime then
            local now = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
            if tonumber(endTime) <= tonumber(now) then
                GUI:setVisible(self.view.btn_Election, false)
            end
        end
        GUI:setVisible(self.view.btn_Replace, false)
        GUI:setVisible(self.view.btn_Impeach, false)
    end
    

end

function this:StopCountDownReqUnionInfo()
    if self.countDownReq then
        SL:UnSchedule(self.countDownReq)
    end
    self.countDownReq = nil
end

--弹劾盟主 
function this:OnClickBtnImpeach()
    local data = InfoManager.unionElectionInfo:GetCampaignData()
    if table.isNullOrEmpty(data) then
        if not self.outUnionInfo then
            return
        end
        local onTime = tonumber(self.outUnionInfo.leaderontime)
        local nowTime = tonumber(SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME))
        local deltaTime = nowTime - onTime
        ---@type cfg_unionLevel_column
        local cfg = SL:GetConfig("cfg_unionLevel", self.unionInfo.unionLevel, "unionLevel")
        if deltaTime < cfg.abdicationTime * 60 * 1000 then
            SL:MessageTip({id=298})---盟主在位没有超过3天，不能弹劾
            return
        end
        GUI:UIPanel_Open("dev/outui/Union/Panel/KLUnionLeaderOperate/KLUnionLeaderOperatePanel",
                _, _, {type = 2, unionLevel = self.unionInfo.unionLevel})
    else
        SL:onLUAEvent(LUA_EVENT_CHANGE_UNION_FUNCTION, "campaignToggle")
    end
end
--竞选盟主
function this:OnClickBtnElection()
    local data = InfoManager.unionElectionInfo:GetElectionDataList()
    if table.count(data) > 0 then
        SL:onLUAEvent(LUA_EVENT_CHANGE_UNION_FUNCTION, "electionToggle")
    else
        GUI:UIPanel_Open("dev/outui/Union/Panel/KLUnionLeaderOperate/KLUnionLeaderOperatePanel",
                _, _, {type = 1, unionLevel = self.unionInfo.unionLevel})
        
    end
end
--取代盟主
function this:OnClickBtnReplace()
    local data = InfoManager.unionElectionInfo:GetReplaceDataList()
    if table.count(data) > 0 then
        SL:onLUAEvent(LUA_EVENT_CHANGE_UNION_FUNCTION, "replaceToggle")
    else
        if not self.outUnionInfo then
            return
        end
        local onTime = tonumber(self.outUnionInfo.leaderontime)
        local nowTime = tonumber(SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME))
        local deltaTime = nowTime - onTime
        ---@type cfg_unionLevel_column
        local cfg = SL:GetConfig("cfg_unionLevel", self.unionInfo.unionLevel, "unionLevel")
        if deltaTime < cfg.abdicationTime * 60 * 1000 then
            SL:TipMessage(SL:GetConfig('cfg_string',298).text, 1, NoticeType.NoticeLeftBottom)--,"盟主在位没有超过3天，不能取代",
            return
        end
        GUI:UIPanel_Open("dev/outui/Union/Panel/KLUnionLeaderOperate/KLUnionLeaderOperatePanel",
                _, _, {type = 3, unionLevel = self.unionInfo.unionLevel})
    end
end
function this:inexpAddButton()
    SL:CommonItemGetPath(nil, 10090001)
end

---@param message UnionProto.ViewUnionRes
function this:ResViewUnionChangeMessage(_, message)
    SL:ReqUnionMemberDynamicMessage()
    self:ResViewUnionMessage(_, message)
end

function this:nameMask()
    --GUI:setVisible(self.view.unionNameModify, false)
    self:btn_panel_name_no()
end

function this:reportMask()
    --GUI:setVisible(self.view.panel_report, false)
    self:btn_panel_report_no()
end

---@param message UnionProto.UnionMemberChangeRes
function this:ResUnionMemberChangeMessage(_, message)
    --
    --local isBoss = false
    --for _, memberInfo in pairs(message.unionMemberInfo) do
    --    if memberInfo.memberId == SL:GetMetaValue(EMetaVarGetKey.UID) and memberInfo.position == 1 then
    --        isBoss = true
    --    end
    --end
    --if isBoss then
    --    GUI:setVisible(self.view.changeUnionNameBtn,true)
    --    GUI:setVisible(self.view.changeAnnoyBtn,true)
    --    GUI:setVisible(self.view.changeFlagBtn,true)
    --else
    --    GUI:setVisible(self.view.changeUnionNameBtn,false)
    --    GUI:setVisible(self.view.changeAnnoyBtn,false)
    --    GUI:setVisible(self.view.changeFlagBtn,false)
    --end
end

function this:ResQuitUnionMessage()
    self:CloseButton()
end

function this:btn_panel_report_yes()
    SL:ReqChangeAnnouncementMessage(GUI:Button_getTitleText(self.view.noticeInput))
    GUI:setVisible(self.view.panel_report, false)
end

function this:btn_panel_report_no()
    GUI:setVisible(self.view.panel_report, false)
end

function this:changeAnnoyBtn()
    GUI:setVisible(self.view.panel_report, true)    
    GUI:Button_setTitleText(self.view.noticeInput, "")
end

function this:changeFlagBtn()
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionMemberList/KLUnionMemberListPanel")
    GUI:UIPanel_Open("dev/ui/Union/Panel/KLUnionModifyFlag/KLUnionModifyFlagPanel", nil, nil, {unionInfo=self.unionInfo})
end

function this:CloseButton()
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionMemberList/KLUnionMemberListPanel")
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionToggleList/KLUnionToggleListPanel")
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionInfo/KLUnionInfoPanel")
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionModifyFlag/KLUnionModifyFlagPanel")
end

function this:changeUnionNameBtn()
    if InfoManager.loranSiegeInfo:GetIsOpen() then
        SL:TipMessage(SL:GetConfig("cfg_string",16009).text ,1, NoticeType.NoticeMid)
        return
    end

    --GUI:setVisible(self.view.unionNameModify, true)
    GUI:UIPanel_Open("dev/outui/ReName/Panel/KLRoleReName/KLRoleReNamePanel", nil, nil, {title="rename",des="请输入新的战盟名称：",cfgId=60090003})
end

function this:btn_3DItem()
    local needItemInfo = string.split(SL:GetConfig('cfg_global', 1600).value,'|')[1]
    local needItemInfo1 = string.split(needItemInfo, '#')
    local itemId = tonumber(needItemInfo1[1])
    SL:OpenTips(nil, itemId)    
end

---@param message UnionProto.ChangeUnionNameViewRes
function this:ResUnionNameViewMessage(_, message)
    local isChange = message.isChange
    GUI:setVisible(self.view.unionNameModify, true)
    local needItemInfo = string.split(SL:GetConfig('cfg_global', 1600).value,'|')[1]
    local needItemInfo1 = string.split(needItemInfo, '#')
    local itemId = tonumber(needItemInfo1[1])
    local needCount = tonumber(needItemInfo1[2])
    GUI:Item_setItemId(self.view.cost_item, itemId)
    GUI:setVisible(self.view.cost_item, true)
    
    if isChange then
        GUI:Text_setString(self.view.cost_txt_count, tostring(needCount))
        if needCount <= SL:GetBagItemCount(itemId) then
            GUI:Text_setTextColor(self.view.cost_txt_count, "#FFFFFF")
        else
            GUI:Text_setTextColor(self.view.cost_txt_count, "#FF0000")
        end
    else
        GUI:Text_setString(self.view.cost_txt_count, "免费改名")
    end
end

function this:btn_panel_name_no()
    GUI:setVisible(self.view.unionNameModify, false)
    GUI:setVisible(self.view.cost_item, false)
    GUI:Button_setTitleText(self.view.warAllianceNameInput, "")
end

function this:btn_panel_name_yes()
    SL:ReqChangeUnionNameMessage(GUI:Button_getTitleText(self.view.warAllianceNameInput))
    GUI:setVisible(self.view.unionNameModify, false)
    GUI:setVisible(self.view.cost_item, false)
end

function this:exitButton()
    if InfoManager.loranSiegeInfo:GetIsOpen() then
        SL:TipMessage(SL:GetConfig("cfg_string",16007).text ,1, NoticeType.NoticeMid)
        return
    end
    if SL:UnionInfo_IsBoos() then
        if SL:UnionInfo_GetAllNum() == 1 then
            SL:CommonTipsMessage({stringTblID=239,
                showTips = "退出后，该战盟将被解散，所有战盟资源，成长都将被清除！",
                callback = function()
                    SL:ReqQuitUnionMessage()
                end,
            })
        else
            SL:ReqQuitUnionMessage()
        end
    else
        SL:CommonTipsMessage({stringTblID=240,
            showTips = "是否确定退出战盟",
            callback = function()
                SL:ReqQuitUnionMessage()
            end,
            --cancelCallBack = function()
            --    
            --end
        })
    end

    
end

function this:Close()
    self:StopCountDownReqUnionInfo()
    self:StopTimer()
end

---@param message UnionProto.ViewUnionRes
function this:ResViewUnionMessage(_, message)
    local unionInfo = message.unionInfo
    self.unionInfo = unionInfo
    GUI:Text_setString(self.view.unionName, unionInfo.unionName)
    GUI:Text_setString(self.view.levelValue, tostring(unionInfo.unionLevel))

    if SL:HasConfig('cfg_unionLevel', unionInfo.unionLevel+1, 'unionLevel') then
        local nextExp = SL:GetConfig('cfg_unionLevel', unionInfo.unionLevel, 'unionLevel').unionExp
        GUI:Text_setString(self.view.inexpValue, unionInfo.unionExp .. "/" .. nextExp)
    else
        GUI:Text_setString(self.view.inexpValue, tostring(unionInfo.unionExp))
    end
    --local nextExp = SL:GetConfig('cfg_unionLevel', unionInfo.unionLevel, 'unionLevel').unionExp
    --GUI:Text_setString(self.view.inexpValue, unionInfo.unionExp .. "/" .. nextExp)

    local maxPeople = SL:GetConfig('cfg_unionLevel', unionInfo.unionLevel, 'unionLevel').playerNumber
    GUI:Text_setString(self.view.peopleCountValue, table.count(unionInfo.unionMemberInfo) .. "/" .. maxPeople)
    
    GUI:Text_setString(self.view.inMoneyValue, tostring(unionInfo.unionCapital))
    local bossName =  this.GetBossName(unionInfo.unionMemberInfo)
    GUI:Text_setString(self.view.bossValue, bossName)
    GUI:Image_loadTexture(self.view.flag_img, string.format("Texture/log%s.png",unionInfo.unionArmband), "")
    GUI:Text_setString(self.view.inUnionAnnoy, unionInfo.announcement)
end

---@param message UnionProto.UnionMemberDynamic
function this:ResUnionMemberDynamicMessage(_, message)
    GUI:Text_setString(self.view.inMemberState, this.GetMemberDynamicText(message.memberDynamic))
end

function this.GetBossName(unionMemberList)
    for _, memberInfo in pairs(unionMemberList) do
        -- 是盟主或副盟主
        if memberInfo.position == 1 then
            return memberInfo.name
        end
    end
    return "无"
end

---@param unionMemberList UnionProto.UnionMemberInfo[]
function this.GetIsPowerMan(unionMemberList)
    for _, memberInfo in pairs(unionMemberList) do
        -- 是盟主或副盟主
        if memberInfo.memberId == SL:GetMetaValue(EMetaVarGetKey.UID) and (memberInfo.position == 1 or memberInfo.position == 2) then
            return true
        end
    end
    return false
end

-- 拼接成员动态相关
function this.GetMemberDynamicText(dynamicList)
    local ret = ""
    for _, dynamicInfo in pairs(dynamicList) do
        local time = dynamicInfo.time

        -- 时间戳转时间
        ret = ret .. os.date("%Y-%m-%d<color=#00000000>.</color>%H:%M:%S", time) .. "<color=#00000000>..</color>"

        -- 修改职位
        if dynamicInfo.type == 1 then

            local preColor = EUnionPositionToColor[dynamicInfo.memberPosition]
            local nowColor = EUnionPositionToColor[dynamicInfo.changePosition]
            -- 之前职位文本
            ret = ret .. string.format("<color=%s>%s</color>", Misc.TransUnityColorToTableColor(preColor), EUnionPositionToName[dynamicInfo.memberPosition])

            -- 名字文本
            ret = ret .. string.format("<color=#00ff00ff>%s</color>", dynamicInfo.memberName) .. '成为了'

            -- 改变后的职位文本
            ret = ret .. string.format("<color=%s>%s</color>", Misc.TransUnityColorToTableColor(nowColor), EUnionPositionToName[dynamicInfo.changePosition]) .. "\n"

        elseif dynamicInfo.type == 2 then
            ret = ret .. string.format("<color=#00ff00ff>%s</color>", dynamicInfo.memberName) .. '加入了战盟' .. "\n"

        elseif dynamicInfo.type == 3 then

            local color = EUnionPositionToColor[dynamicInfo.memberPosition]
            -- 被踢的人的文本
            ret = ret .. string.format("<color=#00ff00ff>%s</color>", dynamicInfo.memberName) .. '被'

            -- 踢的人的职位
            ret = ret .. string.format("<color=%s>%s</color>", Misc.TransUnityColorToTableColor(color), EUnionPositionToName[dynamicInfo.masterPosition])

            ret = ret .. string.format("<color=#00ff00ff>%s</color>", dynamicInfo.masterName) .. '踢出了战盟' .. "\n"

            -- 退出战盟
        elseif dynamicInfo.type == 4 then

            -- 盟主或副盟主和成员的退出发的字段不一样
            if dynamicInfo.memberName ~= nil then
                ret = ret .. string.format("<color=#00ff00ff>%s</color>", dynamicInfo.memberName) .. '退出了战盟' .. "\n"
            else
                ret = ret .. string.format("<color=#00ff00ff>%s</color>", dynamicInfo.masterName) .. '退出了战盟' .. "\n"
            end

            -- 宣战
        elseif dynamicInfo.type == 5 then
            ret = ret .. string.format("<color=#00ff00ff>%s</color>", dynamicInfo.masterName) .. '对'

            ret = ret .. string.format("<color=#00ff00ff>%s</color>", dynamicInfo.enemyName) .. '正式发起宣战！' .. "\n"
        end

    end

    return ret
end

return this
