---@class KLBloodCopyTaskProgressPanel:UIKmlLuaPanelBase
---@field view KLBloodCopyTaskProgressPanel
---@field expItem KLItemItem
local KLBloodCopyTaskProgressPanel = class(UIKmlLuaPanelBase)
local this =KLBloodCopyTaskProgressPanel
---创建时调用一次
function this:Init()
    SL:KeepOpenPanel("KLBloodCopyTaskProgressPanel",true)
    self.reward_all_item = {}
    self.rewardData = {}
    GUI:DataListInitData(self.view.rewardList,function()
        return self:RewardDataListItemCountFunc()
    end,function(realIndex)
        return self:RewardDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:RewardDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:RewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL:onLUAEvent(LUA_EVENT_SWITCH_PKMODE,1)
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLCopyTeam/KLCopyTeamPanel")
    InfoManager.copActivityInfo.bloodTaskState = 0
    self:RefreshPrepareStage(nil,self.args)
    --if InfoManager.copActivityInfo:GetBloodFightMessage() then
    --    local data = InfoManager.copActivityInfo:GetBloodFightMessage()
    --    self:RefreshFightStage(_, data)
    --    InfoManager.copActivityInfo:ClearBloodFightMessage()
    --end
    SL:SetMetaValue(EMetaVarSetKey.SET_ISNOTCHANGEPKMODE,true)
    SL:SetMetaValue(EMetaVarSetKey.SET_PKMODE,EPKMode.Peace)
    SL:CreateSceneItemModel("Streaming/prefab/buildings/1012_mesh25.prefab",function(res)
        if self.doorModel then
            SL:RecycleSceneItemModel(self.doorModel)
            self.doorModel = nil
        end
        self.doorModel = res
        
        if not IsNil(res) then
            res:SetLocalEulerAngles(45, 180, 0)
            res:SetLocalPosition(15,1.9,76)
        end

        if InfoManager.copActivityInfo:GetBloodFightMessage() then
            local data = InfoManager.copActivityInfo:GetBloodFightMessage()
            self:RefreshFightStage(_, data)
            InfoManager.copActivityInfo:ClearBloodFightMessage()
        end
    end)
    self.isPutDownDoor = false
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_BLOODY_CASTLE_STATE_UPDATE,self.RefreshPrepareStage,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_BLOODY_CASTLE_TASK_UPDATE ,self.RefreshFightStage,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_QUIT_DUPLICATE,self.RES_QUIT_SUCCESS,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.BLOODY_CASTLE_SWORD_VIEW ,self.BLOODY_CASTLE_SWORD_VIEW,self)

    SL:RegisterLUAEvent(LUA_EVENT_ME_CREATE_SUCCESS,self.LUA_EVENT_ME_CREATE_SUCCESS,self)
    SL:RegisterLUAEvent(LUA_EVENT_CHANGESCENE,self.LUA_EVENT_CHANGESCENE,self)
    
    GUI:AddOnClickEvent(self.view.openActivityBtn,self,self.OnCliCkOpenActivityBtn)
    GUI:AddOnClickEvent(self.view.desBtn,self,self.OnCliCkDesBtn)
    GUI:AddOnClickEvent(self.view.exitBtn,self,self.OnCliCkExitBtn)

    SL:RegisterLUAEvent(LUA_EVENT_CHANGESCENE, self.LUA_EVENT_CHANGESCENE, self)
end
function this:LUA_EVENT_CHANGESCENE()
    if not SL:Out_IsInCopy() then
        GUI:UIPanel_Close("dev/outui/Activity/Panel/KLBloodCopyTaskProgress/KLBloodCopyTaskProgressPanel")
        InfoManager.copActivityInfo:ClearCopyData()
    end
end

function this:LUA_EVENT_ME_CREATE_SUCCESS()
    if self.stage == 2 then
        self:SetDoorResistancePoint(true)
        self:SetSafeResistancePoint(false)
        self:SetSecondResistancePoint(true)
    end
end

function this:LUA_EVENT_CHANGESCENE(id,message)
    if message and self.repCfgId and SL:HasConfig("cfg_rep",self.repCfgId,"id") then
        ---@type cfg_rep_column
        local tbl = SL:GetConfig("cfg_rep",self.repCfgId,"id")
        if message.cfgId ~= tbl.mapId then
            GUI:UIPanel_Close("dev/outui/Activity/Panel/KLBloodCopyTaskProgress/KLBloodCopyTaskProgressPanel")
            InfoManager.copActivityInfo:ClearCopyData()
        end
    end
end

function this:RefreshPrepareStage(id,message)
    self.stage = message["1"]
    local countdown = tonumber(message["2"])
    self.repCfgId = tonumber(message["3"])
    ---@type cfg_rep_column
    local tbl = SL:GetConfig("cfg_rep",self.repCfgId,"id")
    GUI:Text_setString(self.view.title,"血色城堡第".. tbl.repLevel .."层")
    countdown = countdown-SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
    self.countdown = math.modf(countdown/1000)
    GUI:setVisible(self.view.fightRoot,false)
    GUI:setVisible(self.view.prepareRoot,self.stage == 1)
    GUI:setVisible(self.view.endTime,self.stage == 2)
    if self.stage == 1 then
        GUI:Text_setString(self.view.openDesTxt,"后开启")

        ---@type cfg_repGlobal_column
        local tbl = SL:GetConfig("cfg_repGlobal",10001002,"id")
        local waitTime = tonumber(tbl.value)
        local isChange = false

        if waitTime < self.countdown then
            GUI:Text_setString(self.view.openDes,"当前处于准备阶段")
            GUI:setVisible(self.view.openActivityBtn,false)
        else
            GUI:Text_setString(self.view.openDes,"战斗即将开始做好准备")
            GUI:setVisible(self.view.openActivityBtn,false)
        end
        local str = ""
        self.timer = SL:Schedule(self.timer,0,1,self.countdown,function()
            self.countdown = self.countdown - 1
            if waitTime < self.countdown then
                if not isChange then
                    str = "后开启"
                    GUI:Text_setString(self.view.openDes,"当前处于准备阶段")
                    GUI:setVisible(self.view.openActivityBtn,false)
                    isChange = true
                end
            elseif waitTime == self.countdown then
                str = "秒后开启副本"
                GUI:Text_setString(self.view.openDes,"战斗即将开始做好准备")
                GUI:setVisible(self.view.openActivityBtn,false)
            end
            GUI:Text_setString(self.view.openTime,GUIUtil.FormatTimeMS(self.countdown)..GUIUtil.GetColorText(str,"#00ff00"))
            if self.countdown <=0 then
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CHANGE_DUPLICATE_STATE,EDuplicateType.StartCopy)
            end
        end)
        self:SetSafeResistancePoint(true)
    elseif self.stage == 2 then
        self.timer = SL:Schedule(self.timer,0,0.9,self.countdown,function()
            self.countdown = self.countdown - 1
            GUI:Text_setString(self.view.endTime,GUIUtil.FormatTimeMS(self.countdown))
            if self.countdown <= 0 and self.timer then
                SL:UnSchedule(self.timer)
            end
            if self.countdown <=0 then
                SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_QUIT_DUPLICATE)
            end
        end)
        self:SetDoorResistancePoint(true)
        self:SetSafeResistancePoint(false)
        self:SetSecondResistancePoint(true)
    end
end

function this:SetDoorResistancePoint(isAdd)
    ---@type cfg_repGlobal_column
    local tbl = SL:GetConfig("cfg_repGlobal",11001002,"id")
    local strList = string.split(tbl.value,"|")
    for i, v in pairs(strList) do
        local strs = string.split(v,"#")
        SL:SetResistancePoint(tonumber(strs[1]),tonumber(strs[2]),isAdd)
    end
end

function this:SetSafeResistancePoint(isAdd)
    ---@type cfg_repGlobal_column
    local tbl = SL:GetConfig("cfg_repGlobal",11001007,"id")
    local strList = string.split(tbl.value,"|")
    for i, v in pairs(strList) do
        local strs = string.split(v,"#")
        SL:SetResistancePoint(tonumber(strs[1]),tonumber(strs[2]),isAdd)
    end
end

function this:SetSecondResistancePoint(isAdd)
    ---@type cfg_repGlobal_column
    local tbl = SL:GetConfig("cfg_repGlobal",11001004,"id")
    local strList = string.split(tbl.value,"|")
    for i, v in pairs(strList) do
        local strs = string.split(v,"#")
        SL:SetResistancePoint(tonumber(strs[1]),tonumber(strs[2]),isAdd)
    end
end

function this:RefreshFightStage(id,message)
    ---界面未初始化完成直接调用报错处理
    if not self.doorModel then
        InfoManager.copActivityInfo:RefreshBloodFightStage(id, message)
        return
    end
    
    self.phase = tonumber(message.phase)
    self.taskId = tonumber(message.taskId)

    if self.phase >= 2 and not self.isPutDownDoor then
        self.doorModel:SetLocalEulerAngles(90, 180, 0)
        self.isPutDownDoor = true
    end
    ---@type cfg_repTask_column
    local tbl = SL:GetConfig("cfg_repTask",tonumber(message.taskId),"id")
    if self.stage == 2 then
        self:RefreshReward()
        GUI:Text_setString(self.view.waveNumber,"阶段".. GUIUtil.ToNumberString(message.phase))
        GUI:Text_setString(self.view.taskName,tbl.UItext)
        GUI:Text_setString(self.view.taskCount,"<color=#ff2323>"..message.nowCount .. "</color>/"..message.totalCount)
    end

    if self.phase >= 2 then
        self:SetDoorResistancePoint(false)
    end
    if self.phase >= 3 then
        self:SetSecondResistancePoint(false)
    end
    local rid = SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID)
    rid = tonumber(rid)
    GUI:setVisible(self.view.noPickUpWeaponTip,self.phase >=5 and InfoManager.copActivityInfo.pickUpWeaponRid~=rid)
    
    if self.phase > 4 then
        InfoManager.copActivityInfo.bloodTaskState = 1
    elseif self.phase < 4 then
        InfoManager.copActivityInfo.bloodTaskState = 0
    end

    local state = self.phase >= 5 and message.nowCount >= message.totalCount

    if state then
        InfoManager.copActivityInfo.bloodTaskState = 2
        SL:AttachActivityWeapon(InfoManager.copActivityInfo.pickUpWeaponRid,0)
    end
    
    ---@type cfg_repTask_column[]
    local tblList = SL:GetConfigTable("cfg_repTask")
    ---@param v cfg_repTask_column
    for i, v in pairs(tblList) do
        if v.type == 3 and v.param[2] then
            if InfoManager.copActivityInfo.bloodTaskState == 0 then
                SL:SetNpcIcon(v.param[2], "task_progress")
            elseif InfoManager.copActivityInfo.bloodTaskState > 1 then
                SL:SetNpcIcon(v.param[2], "task_finish")
            end
            break
        end
    end
    GUI:setVisible(self.view.endRoot,state and InfoManager.copActivityInfo.pickUpWeaponRid==rid)
    GUI:setVisible(self.view.fightRoot,not state and not (self.phase >=5 and InfoManager.copActivityInfo.pickUpWeaponRid~=rid))
end

function this:RES_QUIT_SUCCESS(id,message)
    ---@type cfg_rep_column
    local tbl = SL:GetConfig("cfg_rep",message,"id")
    if tbl.type == EActivityType.BloodyCastle then
        GUI:UIPanel_Close("dev/outui/Activity/Panel/KLBloodCopyTaskProgress/KLBloodCopyTaskProgressPanel")
        InfoManager.copActivityInfo:ClearCopyData()
    end
end

function this:BLOODY_CASTLE_SWORD_VIEW(id,message)
    local pickUpWeaponRid = tonumber(message["1"])
    if not pickUpWeaponRid then
        pickUpWeaponRid = tonumber(message[1])
    end
    local rid = SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID)
    rid = tonumber(rid)
    InfoManager.copActivityInfo.pickUpWeaponRid = pickUpWeaponRid
    GUI:setVisible(self.view.noPickUpWeaponTip,self.phase >=5 and pickUpWeaponRid~=rid)
    GUI:setVisible(self.view.fightRoot,not (self.phase >=5 and pickUpWeaponRid~=rid))
end

function  this:RefreshReward()
    ---@type cfg_rep_column
    local tbl = SL:GetConfig("cfg_rep",self.repCfgId,"id")
    self.rewardData = tbl.UIreward
    GUI:DataListUpdateData(self.view.rewardList)
end

function this:RewardDataListItemCountFunc()
    return #self.rewardData
end

function this:RewardDataListItemGetFunc(realIndex)
    local data = self.rewardData[realIndex + 1]
    local message = {cfgId = data[1],count="",width = 55,height=55}
    local item = GUI:UIPanel_Open("dev/outui/Activity/Item/KLItem/KLItemItem",self.view.rewardList,self,message,true)
    self.reward_all_item[item.view.root] = item
    return item.view.root
end

function this:RewardDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:RewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.rewardData[realIndex + 1]
    self.reward_all_item[kmlcontrol]:RefreshItem(data[1],"")
end

function this:OnCliCkOpenActivityBtn()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_CHANGE_DUPLICATE_STATE,EDuplicateType.StartCopy)
end

function this:OnCliCkDesBtn()
    local ruleCfg = SL:GetConfig("cfg_rule_text", 31001)
    if ruleCfg then
        SL:CommonStrTipsMessage({title =ruleCfg.menutxt,str=ruleCfg.location})
    end
end

function this:OnCliCkExitBtn()
    local data = {content="离开副本将丢失进度，是否退出",okFunc=function()
        --请求退出副本
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_QUIT_DUPLICATE)
    end}
    GUI:UIPanel_Open("dev/outui/Activity/Panel/KLSure/KLSurePanel",nil,nil,data)
end

function this:SetVisible(isVisible)
    GUI:setVisible(self.view.root,isVisible)
end

function this:Close()
    if self.timer then
        SL:UnSchedule(self.timer)
        self.timer = nil
    end
    InfoManager.copActivityInfo.hideTask = false
    
    self.stage = 1
    self:SetDoorResistancePoint(false)
    self:SetSafeResistancePoint(false)
    local rid = SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID)
    SL:AttachActivityWeapon(tonumber(rid),0)
    InfoManager.copActivityInfo.bloodTaskState = 0
    ---@type KLUILeftUpPanel
    local panel = GUI:GetUI("dev/ui/MainUI/Panel/KLUILeftUp/KLUILeftUpPanel")
    if panel then
        panel:OnClickTaskToggle(nil,nil,{true})
    end
    if self.doorModel then
        SL:RecycleSceneItemModel(self.doorModel)
    end
    self.doorModel = nil
    self.isPutDownDoor = false
    SL:SetMetaValue(EMetaVarSetKey.SET_ISNOTCHANGEPKMODE,false)
    SL:SetMetaValue(EMetaVarSetKey.SET_PKMODE,EPKMode.Peace)
end

return this
