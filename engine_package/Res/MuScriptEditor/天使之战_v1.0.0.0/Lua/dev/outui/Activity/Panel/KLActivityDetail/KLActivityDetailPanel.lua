---@class KLActivityDetailPanel:UIKmlLuaPanelBase
---@field view KLActivityDetailPanelView
local KLActivityDetailPanel = class(UIKmlLuaPanelBase)
local this =KLActivityDetailPanel
---创建时调用一次
function this:Init()
    self.timer2 = nil
    self.IsOnClick = true
    self.levelData_all_item = {}
    GUI:DataListInitData(self.view.levelList,function()
        return self:LevelDataListItemCountFunc()
    end,function(realIndex)
        return self:LevelDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:LevelDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:LevelDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    
    self.reward_all_item = {}
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
--[[    if SL:GetIsWebGL() then
        GUI:setPositionX(self.view.closeBtn,-287)
    end]]
    self.args = tonumber(self.args)
    SL.HideMainPanel()
    self.isShow = false
    GUI:setVisible(self.view.changeRoot, false)
    self:RefreshLevelList()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_DEVIL_SQUARE_PANEL,self.RES_DEVIL_SQUARE_PANEL,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_BLOODY_CASTLE_PANEL,self.RES_BLOODY_CASTLE_PANEL,self)
    
    SL:RegisterLUAEvent(SELECT_LEVEL_STAGE,self.SELECT_LEVEL_STAGE,self)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER,self.LUA_EVENT_BAG_CHANGE_AFTER,self)
    GUI:AddOnClickEvent(self.view.addCountBtn,self,self.OnCliCkAddCountBtn)
    GUI:AddOnClickEvent(self.view.addCountBtn2,self,self.OnCliCkAddCountBtn2)
    GUI:AddOnClickEvent(self.view.enterBtn,self,self.OnCliCkEnterBtn)
    GUI:AddOnClickEvent(self.view.desBtn,self,self.OnCliCkDesBtn)
    GUI:AddOnClickEvent(self.view.closeBtn,self,self.OnCliCkCloseBtn)
    GUI:AddOnClickEvent(self.view.bgClose,self,self.OnCliCkCloseBtn)
    GUI:AddOnClickEvent(self.view.ticketBtn,self,self.OnCliCkTicketBtn)
    --GUI:AddOnClickEvent(self.view.ticketBtn2, self, self.OnCliCkTicketBtn2)
    GUI:AddOnClickEvent(self.view.ticketBtn3, self, self.OnCliCkAddCountBtn2)
    --GUI:AddOnClickEvent(self.view.changeTicketButton, self, self.OnClickChangeBtn)
end

function this:RefreshLevelList()
    GUI:setVisible(self.view.bloodTitle,self.args == EActivityType.BloodyCastle)
    GUI:setVisible(self.view.devilTitle,self.args == EActivityType.DevilSquare)
    GUI:setVisible(self.view.bloodTitleicon,self.args == EActivityType.BloodyCastle)
    GUI:setVisible(self.view.devilTitleicon,self.args == EActivityType.DevilSquare)
    local scale = self.args == EActivityType.BloodyCastle and 0.6 or 1
    local y = self.args == EActivityType.BloodyCastle and -11 or 0
--[[    GUI:setScale(self.view.ticketModel,scale)
    GUI:setScale(self.view.ticketModel,scale)
    GUI:setPositionY(self.view.ticketModel,y)]]
    
    local tblList = SL:GetConfigTable("cfg_rep")
    self.levelData = {}
    self.curSelectLevelStage = 1
    local index  = 0
    local level = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    ---@param v cfg_rep_column
    for i, v in pairs(tblList) do
        if self.args == v.type then
            local isMeet = level >= v.level[1] and level <= v.level[2]
            if isMeet and self.curSelectLevelStage < v.repLevel then
                self.curSelectLevelStage = v.repLevel
                index = #self.levelData + 1
            end
            table.insert(self.levelData,v)
        end
    end
    local h = #self.levelData*53
    GUI:setContentSize(self.view.levelLayout,165,h)
    ---@type cfg_rep_column
    local tbl = SL:GetConfigMultiKeys("cfg_rep",self.args,self.curSelectLevelStage,"type","repLevel")
    if self.args == EActivityType.DevilSquare then
        SL:SendLuaNetMsg(LuaMessageIdToSever.GET_DEVIL_SQUARE_PANEL,tbl.id)
    else
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_BLOODY_CASTLE_PANEL,tbl.id)
    end
    GUI:DataListUpdateData(self.view.levelList)
    GUI:setPositionY(self.view.levelLayout,index>7 and -67+ (index-8)*53+25 or -67)
end

function this:LevelDataListItemCountFunc()
    return #self.levelData
end

function this:LevelDataListItemGetFunc(realIndex)
    local data = self.levelData[realIndex + 1]
    local item = GUI:UIPanel_Open("dev/outui/Activity/Item/KLLevel/KLLevelItem",self.view.levelList,self,data,true)
    self.levelData_all_item[item.view.root] = item
    return item.view.root
end

function this:LevelDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:LevelDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.levelData[realIndex + 1]
    self.levelData_all_item[kmlcontrol]:RefreshItem(data)
end

function this:RES_BLOODY_CASTLE_PANEL(id,message)
    self:RefreshCopyInfo(self.curSelectLevelStage,message["2"],message["3"],tonumber(message["4"]))
end
function this:RES_DEVIL_SQUARE_PANEL(id,message)
    self:RefreshCopyInfo(self.curSelectLevelStage,message["2"],message["3"],tonumber(message["4"]))
end
---@param data cfg_rep_column
function this:SELECT_LEVEL_STAGE(_,data)
    if self.curSelectLevelStage ~= data.repLevel then
        self.curSelectLevelStage = data.repLevel
        ---@type cfg_rep_column
        local tbl = SL:GetConfigMultiKeys("cfg_rep",self.args,self.curSelectLevelStage,"type","repLevel")
        SL:SendLuaNetMsg(LuaMessageIdToSever.GET_DEVIL_SQUARE_PANEL,tbl.id)
    end
end

function this:LUA_EVENT_BAG_CHANGE_AFTER()
    self:RefreshCostItem()
end

function this:RefreshCopyInfo(levelStage,leftCount,isOpen,time)
    self.leftCount = leftCount
    self.isOpen = isOpen
    if SL:HasConfigTwoKeys("cfg_rep",self.args,levelStage,"type","repLevel") then
        ---@type cfg_rep_column
        local tbl = SL:GetConfigMultiKeys("cfg_rep",self.args,levelStage,"type","repLevel")
        local levelStr = string.split(tbl.name[1]," ")
        GUI:Text_setString(self.view.level,levelStage.."级(".. levelStr[2] ..")")

        if not table.isNullOrEmpty(tbl.recommend) then
            local definse = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", tbl.recommend[1])
            local isMeet = definse >= tbl.recommend[2]
            local color = isMeet and "#00ff00" or "#ff2323"
            local recommend = isMeet and tbl.recommend[2] or tbl.recommend[2] .. "（您的防御值低于推荐值）"
            recommend = GUIUtil.GetColorText(recommend,color)
            GUI:Text_setString(self.view.defense,recommend)
        else
            
            GUI:Text_setString(self.view.defense,GUIUtil.GetColorText("无","#00ff00"))
        end
        local definse = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.armor)
        if tbl.repDef < definse then
             GUI:Text_setString(self.view.defense,"<color=#00ff00>"..tbl.repDef.."</color>")
        else
            GUI:Text_setString(self.view.defense,"<color=#ff2323>"..tbl.repDef.."</color>")
        end
        ---@type cfg_activity_rule_column
        local activityTbl = SL:GetConfigMultiKeys("cfg_activity_rule",self.args,"id")
        if not isOpen then
            local countdown = time-SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
            countdown = math.floor(countdown/1000)
            GUI:SetControl_time(self.view.nextOpenTime,countdown)
        end
        GUI:Text_setString(self.view.openTime,activityTbl.timeText)
        GUI:setVisible(self.view.nextOpenTime,not isOpen)
        GUI:setVisible(self.view.openTxt,isOpen)
        GUI:setVisible(self.view.changeRoot, false)
        self.isOtherId = false
        self:RefreshCostItem()
        self:RefreshReward()
        
        local isMeet = leftCount > 0
        local color = isMeet and "#28E529" or "#ff2323"
        if leftCount <= 10000 then
            GUI:Text_setString(self.view.leftcount,GUIUtil.GetColorText(leftCount.."次",color))
        else
            GUI:Text_setString(self.view.leftcount,GUIUtil.GetColorText("无限".."",color))
        end

    end
end

function this:RefreshCostItem()
    ---@type cfg_rep_column
    local tbl = SL:GetConfigMultiKeys("cfg_rep",self.args,self.curSelectLevelStage,"type","repLevel")
    local cfgId , needCount = self:GetCfgIdAndNeed()
    local ownerTicket = SL:GetBagItemCount(cfgId)
    local isMeet = needCount <= ownerTicket
    local color = isMeet and "#28E529" or "#ff2323"
    GUI:Text_setString(self.view.ticketCount,"("..GUIUtil.GetColorText(ownerTicket,color).."/"..needCount..")")
    ---@type cfg_item_column
    local itemTbl = SL:GetConfig("cfg_item",cfgId,"id")
    ---@type cfg_model_charactor_column
    local modelTbl = SL:GetConfig("cfg_model_charactor",itemTbl.shape[1],"id") 
    GUI:Model_setSrc(self.view.ticketModel,modelTbl.path)


    local cfgId2 = tbl.otherItemId[1]
    local needCount2 = tbl.otherItemId[2]
    local ownerTicket2 = SL:GetBagItemCount(cfgId2)
    local isMeet2 = needCount2 <= ownerTicket2
    local color2 = isMeet2 and "#28E529" or "#ff2323"
    -- local itemTbl2 = SL:GetConfig("cfg_item",cfgId2,"id")
    -- local modelTbl2 = SL:GetConfig("cfg_model_charactor",itemTbl2.shape[1],"id")
    -- GUI:Model_setSrc(self.view.ticketModel3,modelTbl2.path)
    GUI:Item_setItemId(self.view.ticketItem, cfgId2)
    GUI:Text_setString(self.view.ticketCount3,"("..GUIUtil.GetColorText(ownerTicket2,color2).."/"..needCount2..")")
end

function  this:RefreshReward()
    ---@type cfg_rep_column
    local tbl = SL:GetConfigMultiKeys("cfg_rep",self.args,self.curSelectLevelStage,"type","repLevel")
    self.rewardData = tbl.UIreward
    GUI:DataListUpdateData(self.view.rewardList)
end

function this:RewardDataListItemCountFunc()
    return #self.rewardData
end

function this:RewardDataListItemGetFunc(realIndex)
    local data = self.rewardData[realIndex + 1]
    local message = {cfgId = data[1],count="",width = 50,height=50}
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

function this:OnCliCkAddCountBtn()
    ---@type cfg_rep_column
    local tbl = SL:GetConfigMultiKeys("cfg_rep",self.args,self.curSelectLevelStage,"type","repLevel")
    local cfgId = self:GetCfgIdAndNeed()
    SL:CommonItemGetPath(nil, cfgId)
end
function this:OnCliCkAddCountBtn2()
    ---@type cfg_rep_column
    local tbl = SL:GetConfigMultiKeys("cfg_rep",self.args,self.curSelectLevelStage,"type","repLevel")
    local cfgId = tbl.otherItemId[1]
    --local need = tbl.otherItemId[2]
    --local cfgId = self:GetCfgIdAndNeed()
    SL:CommonItemGetPath(nil, cfgId)
end
function this:OnCliCkEnterBtn()

    if not self.IsOnClick then
        SL:TipMessage("点击过于频繁，请稍候", 1, NoticeType.NoticeMid)
        return
    end
    self.IsOnClick = false
    self.timer2=SL:ScheduleOnce(3,function()
        self.IsOnClick = true
    end)
    
    local isInTeam = SL:GetMetaValue(EMetaVarGetKey.TEAM_IS_IN)
    if isInTeam then
        local isNoLeader = SL:GetMetaValue(EMetaVarGetKey.TEAM_IS_TEAM_LEADER)
        if not isNoLeader then
            SL:TipMessage("您不是队长",1,NoticeType.NoticeMid)
            return
        end
    end

    ---@type cfg_rep_column
    local tbl = SL:GetConfigMultiKeys("cfg_rep",self.args,self.curSelectLevelStage,"type","repLevel")
    
    local cfgId, needCount = self:GetCfgIdAndNeed()
    local ownerTicket = SL:GetBagItemCount(cfgId)
    
    local cfgId2 = tbl.otherItemId[1]
    local needCount2 = tbl.otherItemId[2]
    local ownerTicket2 = SL:GetBagItemCount(cfgId2)
    local isMeet1 = needCount <= ownerTicket
    local isMeet2 = needCount2 <= ownerTicket2
    
    local tip
    if not (isMeet1 or isMeet2) then
        tip = "门票不足"
        ---@type cfg_rep_column
        SL:CommonItemGetPath(nil,tbl.itemId[1])
    end
    if not self.isOpen then
        tip = "副本未开启"
    elseif self.leftCount <=  0 then
        tip = "今日次数不足"
    end
    local isCopy = SL:Out_IsInCopy()
    if isCopy then
        tip = "已在副本内"
    end
    if not tip then
        ---进入副本
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ENTER_DUPLICATE,tbl.id)
    else
        SL:TipMessage(tip,1,NoticeType.NoticeMid)
    end
end

function this:OnCliCkDesBtn()
    local des = ""
    local title = ""
    if self.args == EActivityType.DevilSquare then
        local ruleCfg = SL:GetConfig("cfg_rule_text", 32001)
        if ruleCfg then
            SL:CommonStrTipsMessage({title =ruleCfg.menutxt,str=ruleCfg.location})
        end
    elseif self.args == EActivityType.BloodyCastle then
        local ruleCfg = SL:GetConfig("cfg_rule_text", 31001)
        if ruleCfg then
            SL:CommonStrTipsMessage({title =ruleCfg.menutxt,str=ruleCfg.location})
        end
    end
end

function this:OnCliCkCloseBtn()
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLActivityDetail/KLActivityDetailPanel")
    SL.ShowMainPanel()
end

function this:OnCliCkTicketBtn()
    ---@type cfg_rep_column
    local tbl = SL:GetConfigMultiKeys("cfg_rep",self.args,self.curSelectLevelStage,"type","repLevel")
    local cfgId = self:GetCfgIdAndNeed()
    SL:OpenTips(nil, cfgId)
end

function this:OnCliCkTicketBtn2()
    self.isOtherId = not self.isOtherId
    self:OnClickChangeBtn()
    self:RefreshCostItem()
end

function this:OnClickChangeBtn()
    ---@type cfg_rep_column
    local tbl = SL:GetConfigMultiKeys("cfg_rep",self.args,self.curSelectLevelStage,"type","repLevel")
    if not tbl or not tbl.otherItemId[1] then
        return
    end
    self.isShow = not self.isShow
    GUI:setVisible(self.view.changeRoot, self.isShow)
    if self.isShow then
        local cfgId, need
        if self.isOtherId then
            cfgId = tbl.itemId[1]
            need = tbl.itemId[2]
        else
            cfgId = tbl.otherItemId[1]
            need = tbl.otherItemId[2]
        end
        local isMeetReplace = false
        local ownReplaceTicket = SL:GetBagItemCount(cfgId)
        isMeetReplace = tbl.otherItemId[2] <= ownReplaceTicket
        local color2 = isMeetReplace and "#28E529" or "#ff2323"
        GUI:Text_setString(self.view.ticketCount2, GUIUtil.GetColorText(ownReplaceTicket.."/"..need, color2))
        ---@type cfg_item_column
        local itemTbl = SL:GetConfig("cfg_item", cfgId,"id")
        ---@type cfg_model_charactor_column
        local modelTbl = SL:GetConfig("cfg_model_charactor",itemTbl.shape[1],"id")
        GUI:Model_setSrc(self.view.ticketModel2,modelTbl.path)
    end
end

function this:GetCfgIdAndNeed()
    ---@type cfg_rep_column
    local tbl = SL:GetConfigMultiKeys("cfg_rep",self.args,self.curSelectLevelStage,"type","repLevel")
    local cfgId
    local need
    cfgId = tbl.itemId[1]
    need = tbl.itemId[2]
    
--[[    if not self.isOtherId then
        cfgId = tbl.itemId[1]
        need = tbl.itemId[2]
    else
        cfgId = tbl.otherItemId[1]
        need = tbl.otherItemId[2]
    end]]
    return cfgId, need
end

function this:Close()
    if self.timer2 then
        SL:UnSchedule(self.timer2)
    end
    self.timer2 = nil
    SL.ShowMainPanel()
end

return this
