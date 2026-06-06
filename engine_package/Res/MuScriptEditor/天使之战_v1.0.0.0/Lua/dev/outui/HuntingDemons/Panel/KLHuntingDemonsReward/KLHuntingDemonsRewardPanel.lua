---@class KLHuntingDemonsRewardPanel:UIKmlLuaPanelBase
---@field view KLHuntingDemonsRewardPanelView
---@field Reward4DataList table<number,{rank:number,rewardList:table<number,{id:number,count:number}>}>
---@field playerSeverDataList table<number,{roleInfo:{career:number, name:string, online:number, serverid:number},integral:number, rank:number, rid:number, medal:number}> @所有排行榜数据
local KLHuntingDemonsRewardPanel = class(UIKmlLuaPanelBase)
local this =KLHuntingDemonsRewardPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
    self.maxRankShowNum = 100
    ---跳转路径
    self.jumpPath = {"openUIPanel","dev/outui/ChallengeBoss/Panel/KLChallengeBoss/KLChallengeBossPanel","1","monsterType=1"}
    self:InitMyRankInfo()
    self:RefreshJackpot()
    self:GetRewardData()

    GUI:DataListInitData(self.view.Reward4DataList,function()
        return self:GetReward4DataListItemCountFunc()
    end,function(realIndex)
        return self:GetReward4DataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:GetReward4DataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:GetReward4DataListItemUpdateFunc(realIndex, kmlcontrol)
    end)

    GUI:DataListInitData(self.view.PlayerDataList,function()
        return self:PlayerDataListItemCountFunc()
    end,function(realIndex)
        return self:PlayerDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:PlayerDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:PlayerDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)


end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.button_go,self,self.OnClickGo)
    GUI:AddOnClickEvent(self.view.HelpButton,self,self.OnClickHelp)
    SL:RegisterLUAEvent(LUA_EVENT_HUNTING_DEMONS_RANK_DATA_CHANGE, self.LUA_EVENT_HUNTING_DEMONS_RANK_DATA_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_HUNTING_DEMONS_INFO_CHANGE, self.LUA_EVENT_HUNTING_DEMONS_INFO_CHANGE, self)

end

---猎魔信息变动
function this:LUA_EVENT_HUNTING_DEMONS_INFO_CHANGE()
    self.isRest = true
    local time = InfoManager.uiHuntingDemonsInfo.resetSec * 1000
    if time > InfoManager.uiHuntingDemonsInfo.settleSec * 1000 then
        time = InfoManager.uiHuntingDemonsInfo.settleSec * 1000
        self.isRest = false
    end
    GUI:Button_setGrey(self.view.button_go,self.isRest)
    GUI:Button_setTitleText(self.view.button_go,self.isRest and "等待下次开启" or "前往挑战")
    local count = (time - tonumber(SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME))) * 0.001 + 1
    local func = function()
        local now = tonumber(SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME))
        local deltaTime = time - now
        GUI:Text_setString(self.view.TimeText, self.isRest
                and "离重置的剩余时间：".. self:FormatTimeHMS(deltaTime) or "离结算的剩余时间："..self:FormatTimeHMS(deltaTime))
        if deltaTime <= 0 then
            if time > 0 then
                self.isRest = not self.isRest
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MONSTER_HUNT_INFO)
            end
            GUI:Text_setString(self.view.TimeText, "活动未开启")
            GUI:Button_setGrey(self.view.button_go,self.isRest)
            GUI:Button_setTitleText(self.view.button_go,self.isRest and "等待下次开启" or "前往挑战")
            self:UnScheduleTimer()
        end
    end
    func()
    self.countDown = SL:Schedule(self.countDown, 0, 1, count, func)
end

--单位毫秒
function this:FormatTimeHMS(time)
    time = time // 1000
    local s = time % 60
    local m = time // 60 % 60
    local h = time // 3600 % 24
    return string.format("%02s:%02s:%02s", h, m, s);
end

function this:UnScheduleTimer()
    if self.countDown then
        SL:UnSchedule(self.countDown)
    end
    self.countDown = nil
end

---点击打开帮助页面
function this:OnClickHelp()
    local helpCfg=SL:GetConfig("cfg_rule_text",27002)
    if helpCfg then
        SL:CommonStrTipsMessage({title =helpCfg.menutxt,str=helpCfg.location})
    end
end

---猎魔排行榜数据变动
function this:LUA_EVENT_HUNTING_DEMONS_RANK_DATA_CHANGE()
    local allRankList = InfoManager.uiHuntingDemonsInfo.AllRankDataList
    self.playerSeverDataList = {}
    for i, v in ipairs(allRankList) do
        local data = v
        if i <= self.maxRankShowNum then
            table.insert(self.playerSeverDataList,data)
        end
        if data.rid == SL:GetMetaValue(EMetaVarGetKey.UID) then
            self:InitMyRankInfo(data,i)
        end
    end
    GUI:DataListUpdateData(self.view.PlayerDataList)
    self:GetRewardData()
    self:RefreshJackpot()
end

---显示猎魔道具tips
function this:OnClickShowTips()
    SL:OpenTips("",InfoManager.uiHuntingDemonsInfo.itemID)
end

---点击前往猎魔
function this:OnClickGo()
    if self.isRest then
        return
    end
    SL:ShortcutDO(self.jumpPath)
    self.args.mainPanel:OnClickClose()

end

---界面显示时调用一次
function this:Show()
    self:LUA_EVENT_HUNTING_DEMONS_RANK_DATA_CHANGE()
    self:LUA_EVENT_HUNTING_DEMONS_INFO_CHANGE()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MONSTER_HUNT_RANK)
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_MONSTER_HUNT_INFO)
    if InfoManager.uiHuntingDemonsInfo.seasonTimeList  then
        GUI:Text_setString(self.view.SeasonTimeText,"<color=#fe5047>" .. "活动未开启".."</color>")
        for _,v in pairs(InfoManager.uiHuntingDemonsInfo.seasonTimeList) do
            local stringListOpen = string.split(v.openTime,'#')
            local OpenServerTimeSamp = GUIUtil.DateToServerTime({year = tonumber(stringListOpen[1]), month = tonumber(stringListOpen[2]), day = tonumber(stringListOpen[3]), hour = tonumber(stringListOpen[4]),min = 0, sec = 0})
            local stringListEnd = string.split(v.endTime,'#')
            local EndServerTimeSamp = GUIUtil.DateToServerTime({year = tonumber(stringListEnd[1]), month = tonumber(stringListEnd[2]), day = tonumber(stringListEnd[3]), hour = tonumber(stringListOpen[4]),min = 0, sec = 0})
            local serverTime = Time.GetServerTime()
            if serverTime >= OpenServerTimeSamp and serverTime <= EndServerTimeSamp then
                GUI:Text_setString(self.view.SeasonTimeText,"<color=#5DE367>" .. "赛季结束时间："..stringListEnd[1].."年"..stringListEnd[2].."月"..stringListEnd[3].."日".."</color>")
            end
        end
    end
end

function this:Hide()
end

function this:Close()
    self:UnScheduleTimer()
end

---刷新奖池
function this:RefreshJackpot()
    local nowRate = Mathf.Ceil((InfoManager.uiHuntingDemonsInfo:GetNowConversionRateRange() / 10000) * 100)
    local nextRate,nextDifferIntegral = InfoManager.uiHuntingDemonsInfo:GetNextConversionRateRange()
    GUI:Text_setString(self.view.IntegralText,tostring(InfoManager.uiHuntingDemonsInfo.AllPlayerIntegral))
    GUI:setVisible(self.view.NextIntegral,nextRate)
    if nextRate then
        nextRate = Mathf.Ceil((nextRate.value / 10000) * 100)
        GUI:Text_setString(self.view.NextIntegralText,nextRate.."%")
        GUI:Text_setString(self.view.NextItemCountText,"离目标差<color=#D9001CFF>"..tostring(nextDifferIntegral).."</color>积分")
    end
    GUI:Text_setString(self.view.conversionText,nowRate.."%")
    self:SetNowAllItemCount(Mathf.Floor(InfoManager.uiHuntingDemonsInfo.AllItemCount))
end

-------------------个人奖励预览---------------------------

---获取个人奖励信息
function this:GetRewardData()
    self.Reward4DataList = {}
    local cfgList = SL:GetConfigTable("cfg_monsterHuntReward")
    ---@param v cfg_monsterHuntReward_column
    for i, v in ipairs(cfgList) do
        local rank = ""
        --名次相同显示一个
        if v.rank[1] == v.rank[2] then
            rank = "第"..v.rank[1].."名"
        else
            rank = "第"..v.rank[1].."名~".."第"..v.rank[2].."名"
        end
        local rewardList = {}
        local itemCount = InfoManager.uiHuntingDemonsInfo:GetRankingIntervalWeightItemCount(i)
        local rankData = InfoManager.uiHuntingDemonsInfo:GetRankDataIndex(v.rank[1])
        local countStr = ""
        if rankData then
            countStr = itemCount + v.extra
        end
        table.insert(rewardList,{id = InfoManager.uiHuntingDemonsInfo.itemID,count = countStr})
        for z, a in ipairs(v.item) do
            table.insert(rewardList,{id = a[1],count = a[2]})
        end
        table.insert(self.Reward4DataList,{rank = rank,rewardList = rewardList})
    end
    GUI:DataListUpdateData(self.view.Reward4DataList)

end

function this:GetReward4DataListItemCountFunc()
    return #self.Reward4DataList
end

function this:GetReward4DataListItemGetFunc(realIndex)
    ---@type KLHuntingDemonsRewardItem
    local item = GUI:UIPanel_Open("dev/outui/HuntingDemons/Item/KLHuntingDemonsReward/KLHuntingDemonsRewardItem", self.view.Reward4DataList, self, nil, true,function(item)
        local data = self.Reward4DataList[realIndex + 1]
        item:SetRankTextAndReward(data)
    end)
    if not self.Reward4ItemsList then
        ---@type table<KingML.KmlControl,KLHuntingDemonsRewardItem>
        self.Reward4ItemsList = {}
    end
    local kmlCtrl = item.view.root
    self.Reward4ItemsList[kmlCtrl] = item
    return kmlCtrl
end

function this:GetReward4DataListItemInitFunc(realIndex, kmlcontrol)

end

function this:GetReward4DataListItemUpdateFunc(realIndex, kmlcontrol)
    if not GUI:IsUILoading(self.Reward4ItemsList[kmlcontrol]) then
        local data = self.Reward4DataList[realIndex + 1]
        local item = self.Reward4ItemsList[kmlcontrol]
        item:SetRankTextAndReward(data)
    end

end
--------------------------------------------

--------------------------------排行榜玩家信息-------------------------------------------------------
function this:PlayerDataListItemCountFunc()
    return #self.playerSeverDataList
end

function this:PlayerDataListItemGetFunc(realIndex)
end

function this:PlayerDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:PlayerDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.playerSeverDataList[realIndex + 1]
    --local _button = GUI:GetChildControl(self.view.PlayerDataList,realIndex,'PlayerItem_Button',kmlcontrol)
    local _bg = GUI:GetChildControl(self.view.PlayerDataList,realIndex,'PlayerItem_BG',kmlcontrol)
    local _headIcon = GUI:GetChildControl(self.view.PlayerDataList,realIndex,'PlayerItem_HeadIcon',kmlcontrol)
    local _rankText = GUI:GetChildControl(self.view.PlayerDataList,realIndex,'PlayerItem_RankText',kmlcontrol)
    local _rankIcon = GUI:GetChildControl(self.view.PlayerDataList,realIndex,'PlayerItem_RankIcon',kmlcontrol)
    local _name = GUI:GetChildControl(self.view.PlayerDataList,realIndex,'PlayerItem_Name',kmlcontrol)
    local _unionName = GUI:GetChildControl(self.view.PlayerDataList,realIndex,'PlayerItem_UnionName',kmlcontrol)
    --local _lv = GUI:GetChildControl(self.view.PlayerDataList,realIndex,'PlayerItem_LV',kmlcontrol)
    local rankNo = realIndex + 1
    self:SetRankBG(_bg,rankNo)
    self:SetPlayerHead(_headIcon,{baseCareer = data.roleInfo.career})
    self:SetRankValueIconOrText(_rankText,_rankIcon,nil,rankNo)
    local serverName = ""
    if data.roleInfo.serverid then
        serverName = "S"..data.roleInfo.serverid.."."
    end
    self:SetPlayerName(_name,serverName..data.roleInfo.name)
    self:SetRankShowInfo(_unionName, data.integral)
    
end

function this:SetRankShowInfo(control, value)
    GUI:Text_setString(control, "杀怪积分：" .. value)
end

---设置玩家名字
function this:SetPlayerName(Control,name)
    GUI:Text_setString(Control,name)
end

---设置玩家头像
---@param career CommonProtos.Career @职业数据
function this:SetPlayerHead(Control,career)
    GUI:Image_loadTexture(Control,"1"..career.baseCareer,"Atlas/MUIcon.spriteatlas")
end

---根据排名显示图片或文字
function this:SetRankValueIconOrText(Control_Text,Control_Image,Control_Image2,rankValue)
    rankValue = tonumber(rankValue)
    GUI:SetActive(Control_Text,false)
    GUI:SetActive(Control_Image,false)
    if Control_Image2 then
        GUI:SetActive(Control_Image2,false)
    end
    if rankValue == -1 then
        if Control_Image2 then
            GUI:SetActive(Control_Image2,true)
        end
        return
    end
    if rankValue > 0 and rankValue < 4 then
        GUI:SetActive(Control_Image,true)
        GUI:Image_loadTexture(Control_Image,"S_icon"..rankValue,"Atlas/UIRankListPanel.spriteatlas")
        return
    end
    GUI:SetActive(Control_Text,true)
    GUI:Text_setString(Control_Text,tostring(rankValue))
end

---根据排名显示背景图
function this:SetRankBG(Control,rankValue)
    rankValue = tonumber(rankValue)
    if rankValue == -1 then
        GUI:Image_loadTexture(Control,"Pic_My","Atlas/UIRankListPanel.spriteatlas")
        return
    end
    if rankValue > 0 and rankValue < 4 then
        GUI:Image_loadTexture(Control,"Pic_"..rankValue,"Atlas/UIRankListPanel.spriteatlas")
        return
    end
    GUI:Image_loadTexture(Control,"Pic_4","Atlas/UIRankListPanel.spriteatlas")
end

---初始化个人排名信息
---@param info {roleInfo:{career:number, name:string, online:number, serverid:number},integral:number, rank:number, rid:number, medal:number} @排行榜数据
---@param rankNo number @排名
function this:InitMyRankInfo(info,rankNo)
    local rankValue = -1
    if rankNo and rankNo <= self.maxRankShowNum then
        rankValue = rankNo
    end
    local name = SL:GetMetaValue(EMetaVarGetKey.USER_NAME)
    self:SetPlayerName(self.view.MyRank_Name,name)
    if info and info.integral then--排行榜有值的情况下
        self:SetRankShowInfo(self.view.MyRank_UnionName, info.integral)
    else--排行榜没有值的情况下为0
        local myValue = "0"
        self:SetRankShowInfo(self.view.MyRank_UnionName, myValue)
    end
    self:SetRankValueIconOrText(self.view.MyRank_RankText,self.view.MyRank_RankIcon,self.view.MyRank_NoRank,rankValue)
    self:SetPlayerHead(self.view.MyRank_HeadIcon,SL:MeData_GetCareer())
    self:SetRankBG(self.view.MyRank_BG,rankValue)
end
--------------------------------------------------------------------------------------------

---设置当前所有猎魔勋章数量
function this:SetNowAllItemCount(index)
    GUI:Text_setString(self.view.item5Text,tostring(index))
end

return this
