---@class WingTaskInfo 开服翅膀任务
---@field curChapter number
---@field wingChapterState table
---@field wingTaskMap table

WingTaskInfo = class()
local this = WingTaskInfo
 
this.curChapter = 1
this.wingChapterState = {}
this.wingTaskMap = {}
function this:Init()
    self:RegistMessages()
    self:Reset()
end
function this:Reset() 
    self.curChapter = 1
    self.wingChapterState = {}
    self.wingTaskMap = {}
end

function this:RegistMessages() 
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_WINGS_TASK_INFO, self.InfoCallBack, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_WINGS_TASK_CHANGE, self.InfoChangeCallBack, self)

end

function this:InfoCallBack(_, message)
    self.curChapter = message.now_chapter
    self.wingChapterState = {}
    self.wingTaskMap = {}
    for key, value in pairs(message.chapter_task_info) do
        local id  = tonumber(key)
        self.wingChapterState[id] = value.state
        self.wingTaskMap[id] = value.task_info
    end
    self:RefreshRedPoint() 
    SL:onLUAEvent(LUA_EVENT_WING_CHAPTER_CHANGE)
end
function this:InfoChangeCallBack(_, message) 
    self.wingChapterState[message.now_chapter] = message.chapter_state
    local curTaskMap  = self.wingTaskMap[message.now_chapter] or {}
    for key, value in pairs(message.change_task) do
        curTaskMap[key] = value
    end
    self:RefreshRedPoint() 
    SL:onLUAEvent(LUA_EVENT_WING_TASK_CHANGE)
end

function this:EnterGame()
end

function this:RefreshRedPoint()
    local isShow = false
    for key, curTaskMap in pairs(self.wingTaskMap) do
        for key, value in pairs(curTaskMap) do
            if value.state == E_ChapterState.FINISH then
                isShow = true
                break
            end
        end
    end
    if not isShow then
        for key, state in pairs(self.wingChapterState) do
            if state == E_ChapterState.FINISH then
                isShow = true
                break
            end
        end
    end
    InfoManager.mainActivityInfo:RefreshMainActivityRedPoint("tog_WingTaskActivity",isShow)
end




