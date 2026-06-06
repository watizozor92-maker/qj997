GameTips = {}
local this = {}

GameTips.Type = {
    -- 默认
    default = 0,
    -- 月卡礼包
    month_gift = 1,
}

---@param actor table 玩家对象
---@param reward table 奖励参数[itemid, count]
function GameTips.sendGetRewardMsg(actor, reward)
    this.sendGetRewardMsg(actor, reward)
end

function GameTips.sendGetRewardMsgWithParam(actor, reward, type, param)
    this.sendGetRewardMsgWithParam(actor, reward, type, param)
end

---------------------------------------------------
function this.sendGetRewardMsg(actor, param)
    sendluamsg(actor, LuaMessageIdToClient.RES_SEND_GET_REWARD_MSG, param)
end

function this.sendGetRewardMsgWithParam(actor, reward, type, param)
    if not type then
        GameTips.sendGetRewardMsg(actor, reward)
        return
    end
    local data = { ['type'] = type, ['param'] = param, ['reward'] = reward }
    sendluamsg(actor, LuaMessageIdToClient.RES_COMMON_REWARD_PANEL_WITH_PARAM, data)
end
