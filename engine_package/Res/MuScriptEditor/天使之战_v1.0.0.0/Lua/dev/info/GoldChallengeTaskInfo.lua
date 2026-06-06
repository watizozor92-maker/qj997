---@class GoldChallengeTaskInfo @注释
---@field taskInfo {nowtaskpool:table,flushcount:number,nowtask:GoldChallengeTask,firstopen:boolean,dailyrecord:GoldChallengeTask,lastresettime:number,taskPool:{k:number,v:number}}

---@class GoldChallengeTask
---@field taskid number 配置表id
---@field star number 星级
---@field progress number 进度
---@field status GoldChallengeTaskEnum

---@class GoldChallengeTaskEnum
GoldChallengeTaskEnum = {
    ---已领取
    Accept = 1,
    ---已完成
    Finish = 2,
    ---已提交
    submit = 3,
}
GoldChallengeTaskInfo = class()
local this = GoldChallengeTaskInfo

function this:ctor()

end

function this:Init()
    self.taskInfo = {}
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GOLD_TASK_INFO, self.ResGoldTaskInfo, self)
    --SL:RegisterLUAEvent(LUA_EVENT_MAIN_UI_VISIBLE,self.ShowMonsterList,self)
end

--[[function this:ShowMonsterList(_,message)
    if message and message.vis == true then
        if self:IsShowMonsterList(self.taskInfo) then
            GUI:UIPanel_Open("dev/ui/Monster/Panel/KLMonsterMapPoint/KLMonsterMapPointPanel")
        else
            GUI:UIPanel_Close("dev/ui/Monster/Panel/KLMonsterMapPoint/KLMonsterMapPointPanel")
        end
    end
end]]
function this:ResGoldTaskInfo(_, message)
    if message then
        self.taskInfo = message
    end
end

function this:IsShowMonsterList(taskList)
    if taskList and taskList.nowtask and taskList.nowtask.status then
        local status = taskList.nowtask.status
        if status == GoldChallengeTaskEnum.Accept then
            local monsterList = SL:GetConfig("cfg_task_gold", taskList.nowtask.taskid).monlist
            if monsterList and monsterList == 1 then
                return true
            end
        end
    end
    return false
end

function this:IsMapMonsterData()
    local mapMonsterData = {}
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    for i, v in pairs(SL:FindConfigs('cfg_mongen', "mapid", mapId)) do
        if v.monsterShowList == 1 then
            v.reliveTime = 0
            table.insert(mapMonsterData, v)
        end
    end
    local monsterPoints = SL:GetMapMonsterStatus()
    if monsterPoints then
        for i = 1, #mapMonsterData, 1 do
            local monsterid = mapMonsterData[i].monsterid
            local id = mapMonsterData[i].id
            for _, v in pairs(monsterPoints) do
                if v.groupId == id and v.configId == monsterid then
                    if v.reliveTime and v.reliveTime ~= 0 then
                        mapMonsterData[i].reliveTime = v.reliveTime
                    end
                end
            end
        end
    end
    if not next(mapMonsterData) then
        return false
    else
        return true
    end
end

function this:Reset()

end
