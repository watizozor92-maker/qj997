---@class KLTaskFinishPanel:UIKmlLuaPanelBase
---@field view KLTaskFinishPanelView
local KLTaskFinishPanel = class(UIKmlLuaPanelBase)
local this =KLTaskFinishPanel


---创建时调用一次
function this:Init()
    self.finishTaskId = self.args.taskId

    self.retMap = {}
    self.retList = {}
    self:GetRewardMap()
    GUI:DataListInitData( self.view.award_list,function()
        return table.count(self.retList)
    end,function(realIndex)
        
    end,function(realIndex, kmlcontrol)
        return self:DataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)

    end)
end

function this:DataListItemInitFunc(realIndex, kmlcontrol)
    local item = GUI:GetChildControl(self.view.award_list,realIndex,'award_item')
    
    local cfgId = self.retList[realIndex+1]
    local itemCount = self.retMap[cfgId].count
    GUI:Item_UpdataData(item, {
        itemid = cfgId,
        itemcount = itemCount
    })
    
    GUI:AddOnClickEvent(item, self, function()
        SL:OpenTips(nil,cfgId)
    end)
end

function this:GetRewardMap()
    local allTasks = SL:TaskInfo_GetAllTasks()
    local boxItem = allTasks[self.finishTaskId].boxReward
    for _, boxInfo in pairs(boxItem) do
        self.retMap[boxInfo.cfgId] = boxInfo
        table.insert(self.retList, boxInfo.cfgId)
    end
    local rewardList = SL:GetConfig('cfg_task', self.finishTaskId).rewardItem
    for _, boxInfo in pairs(rewardList) do
        local cfgId = boxInfo[1]
        local count = boxInfo[2]
        if self.retMap[cfgId] then
            self.retMap[cfgId]["count"] = self.retMap[cfgId]["count"] + count
        else
            self.retMap[cfgId] = {
                cfgId = cfgId,
                count = SL:GetSimpleNumber(count, 0)
            }
            table.insert(self.retList, cfgId)
        end
    end
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local task_title = SL:GetConfig('cfg_task', self.finishTaskId).title
    GUI:Text_setString(self.view.LabelTask, task_title)
    GUI:Text_setFontSize(self.view.LabelTask, self:GetFontSizeByText(task_title))
    local diaLogDone = SL:GetConfig('cfg_task', self.finishTaskId).diaLogDone
    GUI:Text_setString(self.view.LabelDesc, diaLogDone)
    GUI:DataListUpdateData(self.view.award_list)
    GUI:setContentSize(self.view.LabelTask,160,25)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.BtnClose,self,self.BtnClose)
    GUI:AddOnClickEvent(self.view.BtnGet,self,self.BtnGet)
end

function this:Close()
    SL.ShowMainPanel()
end

function this:BtnClose()
    GUI:UIPanel_Close("dev/ui/Task/Panel/KLTaskFinish/KLTaskFinishPanel")
end

function this:BtnGet()
    SL:ReqSubmitTaskMessage(self.finishTaskId, 1)
    GUI:UIPanel_Close("dev/ui/Task/Panel/KLTaskFinish/KLTaskFinishPanel")
end

---根据文字获取字体大小
---在视图中，字体大小就等于宽度，文本框160的宽度，此时字体大小是20，所以只能容纳8个字
function this:GetFontSizeByText(text)
    local length = self:Utf8len(text)
    if length < 9 then
        return 20
    end
    
    local fontSize = 160 / length
    return fontSize
end

---计算字符串字符个数
function this:Utf8len(str)
    local len = 0
    local i = 1
    local bytes = #str
    while i <= bytes do
        local c = string.byte(str, i)
        if c >= 0 and c <= 127 then
            i = i + 1
        elseif c >= 192 and c <= 223 then
            i = i + 2
        elseif c >= 224 and c <= 239 then
            i = i + 3
        elseif c >= 240 and c <= 247 then
            i = i + 4
        else
            -- 非法 UTF-8 字符，跳过 1 个字节
            i = i + 1
        end
        len = len + 1
    end
    return len
end

return this
