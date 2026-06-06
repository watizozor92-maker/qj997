---@class TaskLoopInfo
TaskLoopInfo = class()
local this = TaskLoopInfo

function this:Init()
    self:RegistMessages()
    self:Reset()
end

function this:Reset()
    self.currentLoopNum = 0
    local tbl = SL:GetConfigTable('cfg_taskline')
    self.maxLoopCount = #tbl
    self.currentCfgId = 0
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.TaskLoopMessage, self.MsgCallBack, self)
end

function this:MsgCallBack(_, msgData)
    if msgData.type == 1 then
        self.currentLoopNum = msgData.currentLoopNum
        self.currentCfgId = tonumber(msgData.currentCfgId)
        local panel = GUI:GetUI("dev/outui/Task/Panel/KLTaskLoop/KLTaskLoopPanel")
        if panel then
            if self.currentLoopNum >= self.maxLoopCount then
                panel:BtnClose()
                return
            end
            panel:Refresh()
            local audioTable = { 100059, 100060, 100061 }
            self:PlayAudio(audioTable[math.random(1, #audioTable)])
        end
        SL:onLUAEvent(LUA_EVENT_LOOP_TASK_INFO_CHANGE)
    end
end


function this:PlayAudio(audioId)
    if SL:HasConfig("cfg_audio", audioId) then
        return
    end
    local tabl = SL:GetConfig("cfg_audio", audioId) or {}
    SL:PlaySound(1, tabl.name, false, tabl.volume)
end
