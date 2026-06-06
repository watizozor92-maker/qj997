-- 每日抽奖
DailyLotteryDraw = {}
local this = {}

DAILY_LOTTERY_DRAW = "T$dailyLotteryDraw"


---@class DailyLotteryDraw.Info 每日抽奖信息
---@field currentCount number 当前已经抽奖次数
---@field lastResetTime number 上一次重置事件
---@field phone number 手机号
---@field dayCount number 当天剩余抽奖次数

-- 抽奖
function DailyLotteryDraw.luckDraw(actor)
    -- 校验是否绑定了手机号
    local dailyLotteryDraw = getplaydef(actor, DAILY_LOTTERY_DRAW)
    if table.isEmpty(dailyLotteryDraw) then
        -- 请先绑定手机号
        noticeTip.noticeinfo(actor, StringIdConst.TEXT467)
        -- tipinfo(actor,"请先绑定手机号")
        return
    end
    local dayCount = dailyLotteryDraw.dayCount
    if dayCount <= 0 then
        -- 当天抽奖次数已经用完，请明天再来
        noticeTip.noticeinfo(actor, StringIdConst.TEXT471)
        -- tipinfo(actor,"当天抽奖次数已经用完，请明天再来")
        return
    end
    local currentCount = dailyLotteryDraw.currentCount
    local value = ConfigDataManager.getTableValue("cfg_global","value","id",19001)
    local valueTable = string.split(value,"#")
    if tonumber(valueTable[1]) <= currentCount then
        -- 全部的抽奖次数已经用完
        noticeTip.noticeinfo(actor, StringIdConst.TEXT469)
        -- tipinfo(actor,"全部的抽奖次数已经用完")
        return
    end

    local dailyPrizes =  ConfigDataManager.getList("cfg_daily_prizes")
    if table.isEmpty(dailyPrizes)  then
        error("每日抽奖配置错误")
        return
    end
    local totalChance = 0
    for index, dailyPrize in pairs(dailyPrizes) do
        totalChance = totalChance + dailyPrize.chance
    end
    local rate = math.random(1, totalChance)
    local rateChance = 0
    local reward = ""
    local rewardId = ""
    for index, dailyPrize in pairs(dailyPrizes) do
        local upChance = rateChance + dailyPrize.chance
        if rateChance < rate and rate <= upChance then
            -- 发送奖励信息
            reward = dailyPrize.reward
            rewardId = dailyPrize.id
        end
        rateChance = upChance
    end
    sendluamsg(actor, LuaMessageIdToClient.RES_LUCK_DRAW, rewardId)
    dailyLotteryDraw.dayCount = dailyLotteryDraw.dayCount - 1
    dailyLotteryDraw.currentCount = dailyLotteryDraw.currentCount + 1
    setplaydef(actor, DAILY_LOTTERY_DRAW,dailyLotteryDraw)
    intervalcalldelay(actor, 7000, 1000, 1,"senddailylotterydrawreward",reward)
end

-- 发送奖励
function senddailylotterydrawreward(actor,reward)
    if not reward or reward == ""  then
        return
    end
    local rewardInfo = string.split(reward,"#")
    additemtobag(actor,rewardInfo[1],rewardInfo[2],0,9999,ItemActionProxy.DAILY_LOTTERY)
end


function DailyLotteryDraw.sendInfo(actor)
    local dailyLotteryDraw = getplaydef(actor, DAILY_LOTTERY_DRAW)
    sendluamsg(actor, LuaMessageIdToClient.RES_LUCK_DRAW_INFO, dailyLotteryDraw)
end


function this.isValidPhoneNumber(phone)
    -- 模式解释：
    -- ^1：手机号必须以1开头
    -- [3-9]：第二位可以是3到9中的任何一个数字
    -- %d{9}：后面必须跟着9个数字
    -- $：结束符，表示字符串结束
    local pattern = "^1[3-9]%d%d%d%d%d%d%d%d%d$"

    return string.match(phone, pattern) ~= nil
end



-- 绑定手机号
function DailyLotteryDraw.bindPhone(actor,msgData)
    local dailyLotteryDraw = getplaydef(actor, DAILY_LOTTERY_DRAW)

    if not table.isEmpty(dailyLotteryDraw) then
        -- 请先输入手机号
        noticeTip.noticeinfo(actor, StringIdConst.TEXT468)
        -- tipinfo(actor,"已经填写过问卷，无需重复填写")
        return
    end
    local phone = msgData.phone
    if not this.isValidPhoneNumber(phone) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT467)
        -- tipinfo(actor,"请输入正确的手机号")
        return
    end

    local value = ConfigDataManager.getTableValue("cfg_global","value","id",19001)
    local valueTable = string.split(value,"#")
    msgData.currentCount = 0
    msgData.lastResetTime = getbaseinfo(actor,"nowsec")
    msgData.dayCount = tonumber(valueTable[2])
    setplaydef(actor, DAILY_LOTTERY_DRAW,msgData)
    sendluamsg(actor, LuaMessageIdToClient.RES_BIND_PHONE, true)
end


-- 定时刷新抽奖信息
function DailyLotteryDraw.flushDailyLotteryDraw(actor)
    local nowSec = getbaseinfo(actor,"nowsec")
    local time = TimeUtil.timeToDate(nowSec)
    if time.hour ~= 9 then
        return
    end
    local dailyLotteryDraw = getplaydef(actor, DAILY_LOTTERY_DRAW)
    if table.isEmpty(dailyLotteryDraw) then
        return
    end
    local value = ConfigDataManager.getTableValue("cfg_global","value","id",19001)
    local valueTable = string.split(value,"#")
    if dailyLotteryDraw.currentCount == tonumber(valueTable[1]) then
        return
    end
    dailyLotteryDraw.lastResetTime = getbaseinfo(actor,"nowsec")
    dailyLotteryDraw.dayCount = tonumber(valueTable[2])
    setplaydef(actor, DAILY_LOTTERY_DRAW,dailyLotteryDraw)
end


-- 登录时检查是否刷新数据
function DailyLotteryDraw.login(actor)
    local dailyLotteryDraw = getplaydef(actor, DAILY_LOTTERY_DRAW)
    if table.isEmpty(dailyLotteryDraw) then
        return
    end
    local lastResetTime = dailyLotteryDraw.lastResetTime
    local nowSec = getbaseinfo(actor,"nowsec")
    local value = ConfigDataManager.getTableValue("cfg_global","value","id",19001)
    local valueTable = string.split(value,"#")
    local flush = TimeUtil.dayFlush(nowSec,lastResetTime,tonumber(valueTable[3]))

    if flush and dailyLotteryDraw.currentCount ~= tonumber(valueTable[1]) then
        dailyLotteryDraw.lastResetTime = nowSec
        dailyLotteryDraw.dayCount = tonumber(valueTable[2])
        setplaydef(actor, DAILY_LOTTERY_DRAW,dailyLotteryDraw)
        return
    end
end

-- 生成验证码
function DailyLotteryDraw.generateVerificationCode(actor,phone)
    if not this.isValidPhoneNumber(phone) then
        tipinfo(actor,"请输入正确的手机号")
        return
    end

    local dailyLotteryDraw = getplaydef(actor, DAILY_LOTTERY_DRAW)
    if not table.isEmpty(dailyLotteryDraw) and dailyLotteryDraw.bind then
        -- 已经绑定过手机号
        tipinfo(actor,"已经绑定过手机号")
        return
    end
    -- 没有申请过验证码
    if table.isEmpty(dailyLotteryDraw) then
        dailyLotteryDraw = {
            phone = phone,
            verificationCode = this.generateCaptcha(4),
            bind = false,
            verificationCodeTime = getbaseinfo(actor,"nowsec")
        }
        setplaydef(actor, DAILY_LOTTERY_DRAW,dailyLotteryDraw)
        sendluamsg(actor, LuaMessageIdToClient.RES_GENERATE_VERIFICATION_CODE, dailyLotteryDraw)
        jprint(dailyLotteryDraw)
        return
    end
    jprint(dailyLotteryDraw)
    local verificationCodeTime = dailyLotteryDraw.verificationCodeTime
    local nowSec = getbaseinfo(actor,"nowsec")
    local diffTime = nowSec - verificationCodeTime
    if diffTime < 60 then
        tipinfo(actor,"验证码还在有效期内，请输入")
        return
    end

    dailyLotteryDraw.verificationCode = this.generateCaptcha(4)
    dailyLotteryDraw.verificationCodeTime = nowSec
    setplaydef(actor, DAILY_LOTTERY_DRAW,dailyLotteryDraw)
    sendluamsg(actor, LuaMessageIdToClient.RES_GENERATE_VERIFICATION_CODE, dailyLotteryDraw)
    jprint(dailyLotteryDraw)
    -- 发送验证码

end


-- 生成验证码
function this.generateCaptcha(length)
    local captcha = ""
    local characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"  -- 可选字符集
    for i = 1, length do
        local randomIndex = math.random(1, #characters)
        local randomChar = characters:sub(randomIndex, randomIndex)
        captcha = captcha .. randomChar
    end

    return captcha
end