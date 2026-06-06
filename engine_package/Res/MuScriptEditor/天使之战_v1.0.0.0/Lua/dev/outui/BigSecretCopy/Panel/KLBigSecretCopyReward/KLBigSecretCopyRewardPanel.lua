---@class KLBigSecretCopyRewardPanel:UIKmlLuaPanelBase
---@field view KLBigSecretCopyRewardPanelView
local KLBigSecretCopyRewardPanel = class(UIKmlLuaPanelBase)
local this = KLBigSecretCopyRewardPanel
---创建时调用一次
function this:Init()
    SL.HideMainPanel()
   

    GUI:DataListInitData(self.view.reward_data_list,function()
        return self:SecretRewardDataListItemCountFunc()
    end,function(realIndex)
        return self:SecretRewardDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:SecretRewardDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:SecretRewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.reward_all_item = {}
    self.data = self.args
    GUI:Text_setString(self.view.level,tostring(self.data.keyLevel))
    self.rep_data = SL:GetConfigMultiKeys('cfg_rep', 19001, self.data.keyLevel, 'type', 'repLevel')

    local passedTime = math.floor( self.data.passedTime/1000 )
    local time_tab = SL:SecondToHMS(passedTime)
    local time_str = ""
    if time_tab.d and time_tab.d >0 then
        time_str = time_str ..time_tab.d .. "天"
    end
    if time_tab.h and time_tab.h >0 then
        time_str = time_str ..time_tab.h .. "小时"
    end
    if time_tab.m and time_tab.m >0 then
        time_str = time_str..time_tab.m .. "分"
    end
    time_str = time_str ..time_tab.s .. "秒"
    GUI:Text_setString(self.view.shichang,time_str)
    GUI:Text_setTextColor(self.view.shichang,"#ff2323")
    if not self.data.score or string.isNullOrEmpty(self.data.score) then
        GUI:Image_loadTexture(self.view.pingfen,"icon_wei", "Atlas/UIBigSecretCopy.spriteatlas")
        --GUI:setPositionX(self.view.pingfen,20)
    else
        --GUI:setPositionX(self.view.pingfen,0)
        if self.data.score == "B" then
            GUI:Image_loadTexture(self.view.pingfen,"icon_b", "Atlas/UIBigSecretCopy.spriteatlas")
        elseif self.data.score == "S" then
            GUI:Image_loadTexture(self.view.pingfen,"icon_s", "Atlas/UIBigSecretCopy.spriteatlas")
        elseif self.data.score == "SS" then
            GUI:Image_loadTexture(self.view.pingfen,"icon_ss", "Atlas/UIBigSecretCopy.spriteatlas")
        elseif self.data.score == "SSS" then
            GUI:Image_loadTexture(self.view.pingfen,"icon_sss", "Atlas/UIBigSecretCopy.spriteatlas")
        end
    end
    local reward_count_str = "剩余奖励次数:" .. self.data.rewardCount
    GUI:Text_setString(self.view.jiangli_count,reward_count_str)
    self.AllRwward = {}
    if self.data.rewardItems then
        for _cfg_id, _count in pairs(self.data.rewardItems) do
            table.insert(self.AllRwward ,{cfgId = tonumber(_cfg_id),count=tonumber(_count)})
        end
    end
    GUI:DataListUpdateData(self.view.reward_data_list)

    
    --提示钥匙等级
    if tonumber(self.data.resLevelUp) >= 0  then
        GUI:setVisible(self.view.reward_panel,false)
        GUI:setVisible(self.view.level_up_panel,true)
        self:TipLevelUp()
    else
        GUI:setVisible(self.view.reward_panel,true)
        GUI:setVisible(self.view.level_up_panel,false)
        self:beginRewardCountDown()
    end
end

---创建或者刷新界面数据时调用
function this:Refresh()

end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_yes,self,self.YesOnclick)
    GUI:AddOnClickEvent(self.view.btn_no,self,self.CloseOnclick)
    GUI:AddOnClickEvent(self.view.btn_sure,self,self.btn_sure_Onclick)
    GUI:AddOnClickEvent(self.view.btn_cancel,self,self.btn_cancel_Onclick)
    GUI:AddOnClickEvent(self.view.tips_closeBtn,self,self.btn_cancel_Onclick)
    
end

function this:UnRegistEvents()
end

function this:CloseOnclick()
    self:StopTime1()
    GUI:UIPanel_Close("dev/outui/BigSecretCopy/Panel/KLBigSecretCopyReward/KLBigSecretCopyRewardPanel")
    --GUI:UIPanel_Open("dev/outui/BigSecretCopy/Panel/KLBigSecretCopy/KLBigSecretCopyRewardPanel")
    SL.ShowMainPanel()
    local task_ui = GUI:GetUI("dev/outui/BigSecretCopy/Panel/KLBigSecretCopyTask/KLBigSecretCopyTaskPanel")
    if task_ui then
        task_ui:DelayExitSure()
    end
end



function this:SecretRewardDataListItemCountFunc()
    return #self.AllRwward
end

function this:SecretRewardDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/outui/ChallengeBoss/Item/KLUIChallengeBossRewardItem/KLUIChallengeBossRewardItem",self.view.reward_data_list,self,{},true)
    
    self.reward_all_item[item.view.root] = item
    return item.view.root
end

function this:SecretRewardDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:SecretRewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.AllRwward[realIndex + 1]
    self.reward_all_item[kmlcontrol]:RefreshItem(data,self.select_Secret_level,self)
end

function this:Close()
    self.is_timer_open = false
    self.is_timer_open2 = false
    self:UnRegistEvents()
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
    if self.timer2 then
        SL:UnSchedule(self.timer2)
        self.timer2 = nil
    end
end

function this:ShowRewardPanel()
    GUI:setVisible(self.view.reward_panel,true)
    GUI:setVisible(self.view.level_up_panel,false)
    self:beginRewardCountDown()
end

function this:beginRewardCountDown()
    local last_time = SL:GetConfig("cfg_repGlobal",19001004).value
    self.last_time = tonumber(last_time)
    self.all_time = tonumber(last_time)
    self.is_timer_open = true
    if self.data.rewardCount > 0 then
        GUI:setVisible(self.view.btn_no,true)
        GUI:Text_setString(self.view.tishi,"是否进行奖励领取")
        GUI:setPositionX(self.view.btn_yes,100)
    else
        GUI:setVisible(self.view.btn_no,false)
        GUI:Text_setString(self.view.tishi,"奖励次数不足，无法领取奖励")
        GUI:setPositionX(self.view.btn_yes,0)
    end
    GUI:setVisible(self.view.btn_yes,true)
    self.timer = SL:Schedule(self.timer,0,1,self.all_time,function()
        if not self.is_timer_open then
            return
        end
        if self.data.rewardCount <= 0  then
            local time_str = "确定(".. self.last_time ..")"
            GUI:Text_setString(self.view.btn_yes_countdown,time_str)
        elseif self.data.isReceiveReward then
            local time_str = "使用(".. self.last_time ..")"
            GUI:Text_setString(self.view.btn_yes_countdown,time_str)
        else
            local time_str = "否(".. self.last_time ..")"
            GUI:Text_setString(self.view.btn_no_countdown,time_str)
        end
        if self.last_time <= 0 then
            self.is_timer_open = false
            if self.data.rewardCount <= 0  then
                self:CloseOnclick()
            elseif self.data.isReceiveReward then
                self:YesOnclick()
            else
                self:CloseOnclick()
            end
        end
        self.last_time = self.last_time - 1
    end)
end

function this:YesOnclick()
    self:StopTime1()
    local task_ui = GUI:GetUI("dev/outui/BigSecretCopy/Panel/KLBigSecretCopyTask/KLBigSecretCopyTaskPanel")
    local configId = task_ui.configId
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_BIG_SECRET_REALM_RECEIVE_REWARD,configId)
    self:CloseOnclick()
end
--tonumber(self.data.resLevelUp) > self.data.keyLevel
function this:TipLevelUp()
    local string1 = SL:GetConfig("cfg_string",19001).text
    local tip_str = string.format(string1,self:AddColor(self.data.keyLevel),self:AddColor(self.data.score),self:AddColor(self.data.resLevelUp))
   GUI:Text_setString(self.view.tipsContent,tip_str)

   local l_time = SL:GetConfig("cfg_repGlobal",19001002).value
    self.last_time2 = tonumber(l_time)
    self.all_time2 = tonumber(l_time)
    self.is_timer_open2 = true
    self.timer2 = SL:Schedule(self.timer2,0,1,self.all_time2,function()
        if not self.is_timer_open2 then
            return
        end
        local time_str = "是(".. self.last_time2 ..")"
        GUI:Text_setString(self.view.btn_sure_countdown,time_str)
        if self.last_time2 <= 0 then
            self.is_timer_open2 = false
            self:btn_sure_Onclick()
        end
        self.last_time2 = self.last_time2 - 1
    end)
end

function this:StopTime1()
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
end

function this:StopTime2()
    if self.timer2 then
        SL:UnSchedule(self.timer2)
        self.timer2 = nil
    end
end

function this:AddColor(aaa)
    return "<color=#00ff00>" .. aaa .. "</color>"
end

function this:btn_sure_Onclick()
    self:StopTime2()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_BIG_SECRET_REALM_KEY_LEVEL_UP, tonumber(self.data.resLevelUp))
    self:ShowRewardPanel()
end

function this:btn_cancel_Onclick()
    self:StopTime2()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_BIG_SECRET_REALM_KEY_LEVEL_UP, 0)
    self:ShowRewardPanel()
end

return this
