---@class KLUnionTaskItem:UIKmlLuaPanelBase
---@field view KLUnionTaskItemView
local KLUnionTaskItem = class(UIKmlLuaPanelBase)
local this =KLUnionTaskItem
---1、击杀某种类型的怪物
---2、击杀指定怪物
---3、完成指定副本
---4、击杀敌方玩家
EUnionTaskType = 
{
    MonsterType = 1,
    Monster = 2,
    Activity = 3,
    Enemy = 4,
}
---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.getList, function()
        local taskId = self.args.info.taskid
        local taskCfg = SL:GetConfig('cfg_gard_task', taskId)
        return table.count(taskCfg.rewardItem) + table.count(taskCfg.rewardSpecial)
    end,function()

    end,function(realIndex)
        local taskId = self.args.info.taskid
        local taskCfg = SL:GetConfig('cfg_gard_task', taskId)
        local rewardItemCount = table.count(taskCfg.rewardItem)
        local itemControl =  GUI:GetChildControl(self.view.getList,realIndex,'item12')
        local count_attach1 =  GUI:GetChildControl(self.view.getList,realIndex,'count_attach1')
        local itemId
        local itemCount
        if realIndex+1<=rewardItemCount then
            itemId = taskCfg.rewardItem[realIndex+1][1]
            itemCount = taskCfg.rewardItem[realIndex+1][2]
        else
            itemId = taskCfg.rewardSpecial[realIndex+1-rewardItemCount][1]
            itemCount = taskCfg.rewardSpecial[realIndex+1-rewardItemCount][2]
        end
        GUI:Item_UpdataData(itemControl,{
            itemid = itemId,
            itemcount = itemCount,
        } )
        GUI:AddOnClickEvent(itemControl,self,function()
            SL:OpenTips(nil, itemId)
        end)
        GUI:SetZIndex(count_attach1,201)

    end,function(realIndex)
    end)
    
    GUI:DataListUpdateData(self.view.getList)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_SUBMIT_UNION_TASK, self.ResSubmitUnionTask, self)
end

function this:ResSubmitUnionTask(_, finishTaskId)
    if self.args.info.taskid == finishTaskId then
        GUI:setVisible(self.view.Img_Received_1, true)
        GUI:setVisible(self.view.taskButton, false)
        local taskCfg = SL:GetConfig('cfg_gard_task', finishTaskId)
        local reward = {}
        for _, v in pairs(taskCfg.rewardItem) do
            reward[tonumber(v[1])] = tonumber(v[2])
        end
        SL:OpenRewardTips(reward)
    end
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local taskInfo = self.args.info
    local finish = self.args.finish
    if taskInfo then
        local taskId = taskInfo.taskid
        local taskCfg = SL:GetConfig('cfg_gard_task', taskId)
        GUI:Text_setString(self.view.taskTarget, taskCfg.taskName)

        GUI:setGrey(self.view.taskButton, false)
        local haveCount = taskInfo.taskcount
        local totalCount = taskCfg.taskContent[2] and taskCfg.taskContent[2] or taskCfg.taskContent[1]
        if taskCfg.taskType == EUnionTaskType.Monster then 
            totalCount =  taskCfg.taskContent[#taskCfg.taskContent] 
        end

        if haveCount < totalCount then
            GUI:Text_setString(self.view.TextProgress, string.format('<color="#00ff00">%d</color>/%d', haveCount, totalCount))
            GUI:Button_setTitleText(self.view.taskButton, "前往")
            if string.isNullOrEmpty(taskCfg.panel[1]) then
                GUI:setGrey(self.view.taskButton, true)
                GUI:Button_setBright(self.view.taskButton, false)
            else
                GUI:setGrey(self.view.taskButton, false)
                GUI:Button_setBright(self.view.taskButton, true)
            end

            GUI:AddOnClickEvent(self.view.taskButton, self, function()
                local isMapTransfer,isMeetCost,costId = SL:CheckMapTransferInstructCost(taskCfg.panel)
                if isMapTransfer and not isMeetCost then
                    if costId then
                        SL:CommonItemGetPath(nil, costId)
                    end
                    return
                end

            if taskCfg.panel[2] and string.contains( taskCfg.panel[2], 'KLUnionActivityPanel') then
                    local panel = GUI:GetUI("dev/ui/Union/Panel/KLUnionToggleList/KLUnionToggleListPanel")
                    if panel then
                        GUI:SetTogDefaultThis(panel.view.activityToggle)
                    end
                else
                    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionToggleList/KLUnionToggleListPanel")
                    GUI:UIPanel_Close("dev/outui/Union/Panel/KLUnionTask/KLUnionTaskPanel")
                end
                shortcutOutMgr.DO(taskCfg.panel)
            end)
        else
            GUI:Text_setString(self.view.TextProgress, string.format('<color="#00ff00">%d/%d</color>', haveCount, totalCount))
            if finish then
                GUI:setVisible(self.view.taskButton, false)
                GUI:setVisible(self.view.Img_Received_1, true)
            else
                GUI:Button_setTitleText(self.view.taskButton, "领取")
                GUI:AddOnClickEvent(self.view.taskButton, self, function()
                    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_SUBMIT_UNION_TASK, taskId)
                end)
            end

        end
    end
end

function this:Close()
end

return this
