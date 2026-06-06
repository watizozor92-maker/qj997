RedPoint = {}
RedPoint.__index = RedPoint

local this = {}

local function sendMsg(actor, data)
    sendluamsg(actor, LuaMessageIdToClient.RES_COMMON_RED_POINT_MESSAGE, data)
end

-- 发送红点通用协议
function RedPoint.SendRedPoint(actor, data)
    sendMsg(actor, data)
end

function RedPoint.sendOneRedPoint(actor, id, is_show)
    local data = { [id] = is_show }
    sendMsg(actor, data)
end

-- 登录时执行
function RedPoint.login(actor)
    this.checkRedPoint(actor)
end

function this.checkRedPoint(actor)
    local red_data = {}

    RedPointEventListerTable:triggerEvent("0", red_data, actor)

    -- 每日目标红点信息
    --red_data[RedPoint.IdConst.DAILY_ACTIVITY] = DailyActivity.hasBoxUnReceived(actor)
    EventListerTable.print("上线触发小红点", actor, red_data)
    sendMsg(actor, red_data)
end

--- 事件注册
LoginEventListerTable:eventLister("0", "红点通用协议登录事件", RedPoint.login)
