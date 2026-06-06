---@class KLSettlementPanel:UIKmlLuaPanelBase
---@field view KLSettlementPanelView
local KLSettlementPanel = class(UIKmlLuaPanelBase)
local this =KLSettlementPanel
---创建时调用一次
function this:Init()
    self.rewardData = {}
    self.reward_all_item = {}
    GUI:DataListInitData(self.view.select_item_list,function()
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
    if SL:GetIsWebGL() then
        GUI:setPositionX(self.view.closeBtn,-232)
    end
    self.maxNumber = self.args.leftCount
    self.curSelectReward = 1
    GUI:Text_setString(self.view.killMonsterCount,tostring(self.args.kill))
    local tbl = SL:GetConfig("cfg_rep",self.args.configId,"id")
    if tbl.type == EActivityType.DevilSquare then
        GUI:Text_setString(self.view.gainExprience,tostring(GUIUtil.FormatNumber(self.args.killExp+self.args.scoreExp,true)))
    else
        GUI:Text_setString(self.view.gainExprience,tostring(GUIUtil.FormatNumber(self.args.exp,true)))
    end
    self:RefreshRewardOption()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLUAEvent(SELECT_REWARD_TYPE,self.SELECT_REWARD_TYPE,self)
    SL:RegisterLUAEvent(LUA_EVENT_BAG_CHANGE_AFTER,self.LUA_EVENT_BAG_CHANGE_AFTER,self)
    GUI:AddOnClickEvent(self.view.bgClose,self,self.OnclickCloseBtn)
    GUI:AddOnClickEvent(self.view.closeBtn,self,self.OnclickCloseBtn)
    GUI:AddOnClickEvent(self.view.okBtn,self,self.OnclickOkBtn)
    GUI:AddOnClickEvent(self.view.addbtn,self,self.OnclickaddBtn)
    GUI:AddOnClickEvent(self.view.itemBg,self,self.OnCliCkTicketBtn)
end

function this:SELECT_REWARD_TYPE(_,data)
    self.curSelectRewardData = data
    self.curSelectReward = data.index
    self.costId = data.costId
    ---@type cfg_rep_column
    local tbl = SL:GetConfig("cfg_rep",self.args.configId,"id")
    if tbl.type == EActivityType.DevilSquare then
        GUI:Text_setString(self.view.gainExprience,tostring(GUIUtil.FormatNumber((self.args.killExp+self.args.scoreExp)*data.index,true)))
    else
        GUI:Text_setString(self.view.gainExprience,tostring(GUIUtil.FormatNumber(self.args.exp*data.index,true)))
    end
    self:RefreshReward(data.costId,data.costItemCount,data.costCount)
end

function this:LUA_EVENT_BAG_CHANGE_AFTER()
    if self.curSelectRewardData then
        self:RefreshReward(self.curSelectRewardData.costId,self.curSelectRewardData.costItemCount,self.curSelectRewardData.costCount)
    end
end

function this:OnclickCloseBtn()
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLSettlement/KLSettlementPanel")
end

function this:OnclickOkBtn()
    if self.tips and self.curSelectReward~=1 then
        SL:TipMessage(self.tips,1,NoticeType.NoticeMid)
        if not self.isMeetItemCount then
            SL:CommonItemGetPath(nil,self.costId)
        end
        return
    end
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLSettlement/KLSettlementPanel")
end

function this:OnclickaddBtn()
    SL:CommonItemGetPath(nil,self.costId)
end

function this:OnCliCkTicketBtn()
    SL:OpenTips(nil, self.costId)
end

function  this:RefreshRewardOption()
    local globalId = 10001005
    if SL:HasConfig("cfg_rep",self.args.configId,"id") then
        ---@type cfg_rep_column
        local tbl = SL:GetConfig("cfg_rep",self.args.configId,"id")
        if tbl.type ~= EActivityType.DevilSquare then
            globalId = 11001006
        end
    end
    ---@type cfg_repGlobal_column
    local tbl = SL:GetConfigMultiKeys("cfg_repGlobal",globalId,"id")
    local data = tbl.value
    data = "1|"..data
    self.rewardData = string.split(data,"|")
    GUI:DataListUpdateData(self.view.select_item_list)
    local w = 118*#self.rewardData
    local count = #self.rewardData - 4
    GUI:setContentSize(self.view.select_layout,w,45)
    GUI:setPositionX(self.view.select_layout,count<=0 and 0 or (count*118/2))
end

function this:RewardDataListItemCountFunc()
    return #self.rewardData
end

function this:RewardDataListItemGetFunc(realIndex)
    local data = self.rewardData[realIndex + 1]
    local message = {index = tonumber(data),costId = 0,costItemCount = 0,costCount = 0}
    if tonumber(data) ~= 1 then
        data = string.split(data,"#")
        message = {index=tonumber(data[1]),costId =tonumber(data[2]),costItemCount = tonumber(data[3]),costCount = tonumber(data[4])}
    end
    local item = GUI:UIPanel_Open("dev/outui/Activity/Item/KLSelectReward/KLSelectRewardItem",self.view.select_item_list,self,message,true)
    self.reward_all_item[item.view.root] = item
    return item.view.root
end

function this:RewardDataListItemInitFunc(realIndex, kml)
end

function this:RewardDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.rewardData[realIndex + 1]
    local message = {index = tonumber(data),costId = 0,costItemCount = 0}
    if tonumber(data) ~= 1 then
        data = string.split(data,"#")
        message = {index=tonumber(data[1]),costId =tonumber(data[2]),costItemCount = tonumber(data[3]),costCount = tonumber(data[4])}
    end
    self.reward_all_item[kmlcontrol]:RefreshItem(message)
end

function this:RefreshReward(costId,costItemCount,costCount)
    self.tips = nil
    self.isMeetItemCount = true
    if self.curSelectReward ~= 1 then
        local isMeet = self.maxNumber >= costCount
        local color = isMeet and "" or "#ff2323"
        local leftCountStr = "消耗血色城堡/恶魔广场活动次数：".. self.maxNumber .."/".. GUIUtil.GetColorText(costCount,color)

        if costCount > self.maxNumber then
            self.tips = "次数不足"
        end
        
        local ownerTicket = SL:GetBagItemCount(costId)
        isMeet = costItemCount <= ownerTicket
        color = isMeet and "#28E529" or "#ff2323"
        GUI:Text_setString(self.view.costItemCountTxt,"("..GUIUtil.GetColorText(ownerTicket,color).."/"..costItemCount..")")
        GUI:Item_setItemId(self.view.costItem,costId)
        GUI:setVisible(self.view.addbtn,self,not isMeet)
        if not self.tips and not isMeet then
            self.tips = "道具不足"
            self.isMeetItemCount = false
        end
        GUI:SetActive(self.view.costEnterCountTxt,false)
        GUI:Text_setString(self.view.costEnterCountTxt,leftCountStr)
        -- GUI:setContentSize(self.view.bg,549,560)
        -- GUI:setPositionY(self.view.okBtn,-137)
    else
        -- GUI:setContentSize(self.view.bg,549,465)
        -- GUI:setPositionY(self.view.okBtn,-45)
    end
    GUI:setVisible(self.view.costContainer,self.curSelectReward ~= 1)
    --GUI:setVisible(self.view.costEnterCountTxt,self.curSelectReward ~= 1)
end

function this:Close()
    if SL:HasConfig("cfg_rep",self.args.configId,"id") then

        if self.tips and self.curSelectReward~=1 then
            SL:TipMessage(self.tips,1,NoticeType.NoticeMid)
            return
        end
        ---@type cfg_rep_column
        local tbl = SL:GetConfig("cfg_rep",self.args.configId,"id")
        if tbl.type == EActivityType.DevilSquare then
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECIVE_DEVIL_SQUARE_REWARD,self.curSelectReward)
        else
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECIVE_BLOODY_CASTLE_SETTLEMENT,self.curSelectReward)
        end
    end
end

return this
