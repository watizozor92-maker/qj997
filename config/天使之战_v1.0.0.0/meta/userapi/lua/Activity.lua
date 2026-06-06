Activity = {}

local this = {}

function Activity.LogIn(actor)
    this.ResAllActivityInfo(actor)
end

-- @description 活动改变回包
-- @param 玩家对象；活动id；1-开启，0-关闭
-- @return
function Activity.ActivityChange(actor, activityId, action)
    local open = tonumber(ConfigDataManager.getTableValue("cfg_activity_rule", "open", "id", activityId))
    if open == nil or open == 0 then
        return
    end
    if activityId == DuplicateType.ROLAND_SEIGE then
        if not RolandSeige.CanOpenActivity() then
            -- 罗兰峡谷未达到首次开启要求
            return
        end
    end

    if activityId == DuplicateType.BING_FENG_BAO then
        BingFengBao.openZhanLingButton(actor)
    end

    local changeAct = getactivityinfo(activityId)
    local result = this.ActivityToMsg(changeAct)
    sendluamsg(actor, LuaMessageIdToClient.RES_ACTIVITY_CHANGE, result)
end

-- @description 发给客户端响应
-- @param 玩家对象
-- @return
function this.ResAllActivityInfo(actor)
    local result = {}
    local allActivity = getallactivities()
    for index, value in ipairs(allActivity) do
        local innerData = this.ActivityToMsg(value)
        table.insert(result, innerData)
    end
    sendluamsg(actor, LuaMessageIdToClient.RES_ACTIVITY_LIST, result)
end

function this.ActivityToMsg(activityInfo)
    local result = {}
    result["id"] = activityInfo["activityid"]
    result["open"] = activityInfo["open"]
    local leftTime
    if activityInfo["open"] then
        leftTime = activityInfo["closetime"]
    else
        leftTime = activityInfo["nextopentime"]
    end
    result["leftTime"] = tostring(leftTime)
    return result
end
