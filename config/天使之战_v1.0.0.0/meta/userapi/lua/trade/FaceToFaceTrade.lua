--- 面对面交易系统
--- 提供玩家间直接交易物品和货币的功能，无手续费
--- 系统通过交易行底层实现，但交易过程独立处理

FaceToFaceTrade = {}
local this = {}

-- ==================== 常量定义 ====================

-- 交易状态
local TRADE_STATE = {
    IDLE = 0,      -- 空闲
    INVITING = 1,  -- 邀请中
    TRADING = 2,   -- 交易中
    LOCKED = 3,    -- 已锁定
    CONFIRMED = 4, -- 已确认
}

-- 全局配置ID
local FACE_TRADE_CONFIG = {
    DISTANCE = 690001,       -- 交易距离配置ID（半径值）
    APPLY_CD = 690003,       -- 申请冷却时间配置ID
    ACCEPT_TIMEOUT = 690002, -- 接受超时时间配置ID
    CURRENCY_ID = 690004,    -- 交易货币配置ID
    TRADE_TIMEOUT = 690005,  -- 交易超时时间配置ID
    TRADE_SLOTS = 690006,    -- 交易栏格子数配置ID, 改为交易行格子数
    OPEN_CONDITION = 690007, -- 开启条件配置ID
    TAX_RATE = 690008,       -- 交易税率配置ID
}

-- 提示文本ID
local STRING_TIP = {
    DISTANCE_TOO_FAR    = 59001,  -- 距离过远,无法进行交易
    PLAYER_APPLY_TRADE  = 59002,  -- 玩家向自己发起交易
    APPLY_IN_CD         = 590003, -- 交易申请冷却中
    IN_DUPLICATE        = 590004, -- 副本中无法交易
    TRADE_SLOTS_FULL    = 590005, -- 交易栏已满
    TRADE_TIMEOUT       = 590006, -- 交易时间过长，已停止
    TARGET_INVITING     = 59009,  -- 对方已经被邀请
    PLAYER_NO_CONDITION = 59010   -- 玩家条件不通过
}

local CALCEL_TYPE = {
    DEFAULT = -1,           -- 交易状态异常
    TARGET_NOT_EXIST = 0,   -- 对方玩家不存在
    PLAYER_DEAD = 1,        -- 交易参与方已死亡
    TIMEOUT = 2,            -- 交易超时
    NO_TRADE_ITEM = 3,      -- 没有可交易的物品
    INVALID_TRADE_ITEM = 4, -- 交易物品异常
    TRADE_FAILED = 5,       -- 交易失败
    CANCELLED = 6,          -- 主动交易取消
    OFFLINE = 7,            -- 对方玩家已下线
    DISTANCE_TOO_FAR = 8,   -- 交易距离过远
}

-- 玩家自定义变量Key
local __PLAYER_TRADE_STATE = "@faceTradeState"            -- 玩家交易状态
local __PLAYER_TRADE_TARGET = "@faceTradeTarget"          -- 交易目标
local __PLAYER_TRADE_ITEMS = "@faceTradeItems"            -- 交易栏道具
local __PLAYER_TRADE_CURRENCY = "@faceTradeCurrency"      -- 交易栏货币
local __PLAYER_APPLY_CD = "@faceTradeApplyCD"             -- 申请CD记录
local __PLAYER_TRADE_START_TIME = "@faceTradeStartTime"   -- 交易开始时间
local __PLAYER_TRADE_INVITE_TIME = "@faceTradeInviteTime" -- 收到邀请时间

-- ==================== 功能开启检查 ====================

-- 检查玩家是否满足交易功能开启条件
function this.checkTradeCondition(actor)
    local condition = ConfigDataManager.getTableValue("cfg_global", "value", "id", FACE_TRADE_CONFIG.OPEN_CONDITION)
    if string.isNullOrEmpty(condition) then
        return true
    end
    return ConditionManager.Check(actor, condition)
end

-- 检查玩家距离是否满足交易条件（半径值）
function this.checkDistance(actor, targetActor)
    local distanceLimit = tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", FACE_TRADE_CONFIG.DISTANCE))
    if not distanceLimit then
        distanceLimit = 12 -- 默认距离半径12格
    end

    -- 获取双方坐标
    local actorX = getbaseinfo(actor, "x")
    local actorY = getbaseinfo(actor, "y")
    local targetX = getbaseinfo(targetActor, "x")
    local targetY = getbaseinfo(targetActor, "y")

    -- 计算距离（使用半径判断）
    local distance = math.sqrt((actorX - targetX) ^ 2 + (actorY - targetY) ^ 2)

    return distance <= distanceLimit
end

-- 获取交易税率
function this.getTaxRate()
    local taxRate = tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", FACE_TRADE_CONFIG.TAX_RATE))
    if not taxRate then
        return 0 -- 默认无税率
    end
    return taxRate / 10000
end

-- 处理交易税
function this.handleTax(taxAmount, currencyId, seller, buyer)
    -- 这里可以扩展税款处理逻辑，例如：
end

-- 检查是否在副本中
function this.isInDuplicate(actor)
    local mapId = getbaseinfo(actor, "mapid")
    local dupInfo = getduplicate(mapId)
    if dupInfo == nil then
        return false
    end
    return true
end

function this.isFighting(actor, targetActor)
    -- 判断交易状态
    local playerState = getfightstate(actor)
    local targetState = getfightstate(targetActor)
    if playerState == 1 or targetState == 1 then
        return true
    end
    return false
end

-- ==================== 申请交易 ====================

-- 发起交易申请
function FaceToFaceTrade.applyTrade(actor, targetRid)
    callonserial(actor, "facetradeapply", targetRid)
end

function facetradeapply(actor, targetRid)
    targetRid = tonumber(targetRid)
    if not targetRid then
        return
    end
    local targetActor = getactor(actor, targetRid)

    if not targetActor then
        tipinfo(actor, "目标玩家不存在")
        return
    end

    if isdead(actor) or isdead(targetActor) then
        tipinfo(actor, "玩家死亡, 无法交易")
        return
    end
    -- 检查自己是否满足交易条件
    if not this.checkTradeCondition(actor) then
        noticeTip.noticeinfo(actor, STRING_TIP.PLAYER_NO_CONDITION)
        return
    end

    -- 检查对方是否满足交易条件
    if not this.checkTradeCondition(targetActor) then
        noticeTip.noticeinfo(actor, STRING_TIP.PLAYER_NO_CONDITION)
        return
    end

    -- 检查是否在副本中
    if this.isInDuplicate(actor) or this.isInDuplicate(targetActor) then
        noticeTip.noticeinfo(actor, STRING_TIP.IN_DUPLICATE)
        return
    end

    -- 检查战斗状态
    if this.isFighting(actor, targetActor) then
        tipinfo(actor, "战斗中无法交易")
        return
    end

    -- 检查申请CD
    if not this.checkApplyCD(actor) then
        noticeTip.noticeinfo(actor, STRING_TIP.APPLY_IN_CD)
        return
    end

    -- 检查距离
    if not this.checkDistance(actor, targetActor) then
        noticeTip.noticeinfo(actor, STRING_TIP.DISTANCE_TOO_FAR)
        return
    end

    -- 检查双方是否已在交易中或邀请中
    if this.isTrading(actor) then
        tipinfo(actor, "交易中,无法申请")
        return
    end
    if this.isTrading(targetActor) then
        tipinfo(actor, "对方正在交易中")
        return
    end

    if this.isInviting(targetActor) then
        noticeTip.noticeinfo(actor, STRING_TIP.TARGET_INVITING)
        return
    end

    -- 设置申请CD
    this.setApplyCD(actor)

    -- 设置对方收到邀请的时间
    setplaydef(targetActor, __PLAYER_TRADE_INVITE_TIME, getbaseinfo(actor, "nowsec"))
    setplaydef(targetActor, __PLAYER_TRADE_TARGET, actor:toString())

    -- 发送交易申请到目标玩家
    local timeout = tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", FACE_TRADE_CONFIG.ACCEPT_TIMEOUT))
    sendluamsg(targetActor, LuaMessageIdToClient.RES_FACE_TRADE_APPLY, {
        rid = actor:toString(),
        name = getbaseinfo(actor, "rolename"),
        timeout = timeout or 40
    })
    noticeTip.noticeinfo(targetActor, STRING_TIP.PLAYER_APPLY_TRADE, getbaseinfo(actor, "rolename"))
    local log = getbaseinfo(actor, "rolename") .. "已向" .. getbaseinfo(targetActor, "rolename") .. "[" .. targetRid .. "]" .. "发起交易申请"
    gameDebug.print(actor, log)
    this.log(actor, log)
end

-- 检查申请CD
function this.checkApplyCD(actor)
    local lastApplyTime = getplaydef(actor, __PLAYER_APPLY_CD) or 0
    local cdTime = tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", FACE_TRADE_CONFIG.APPLY_CD))
    if not cdTime then
        cdTime = 40
    end

    local now = getbaseinfo(actor, "nowsec")
    return (now - lastApplyTime) >= cdTime
end

-- 设置申请CD
function this.setApplyCD(actor)
    setplaydef(actor, __PLAYER_APPLY_CD, getbaseinfo(actor, "nowsec"))
end

-- ==================== 同意/拒绝交易 ====================
-- 同意交易申请
function FaceToFaceTrade.agreeTrade(actor)
    local applyRid = getplaydef(actor, __PLAYER_TRADE_TARGET)
    if not applyRid then
        tipinfo(actor, "您没有收到交易申请")
        return
    end
    local applyActor = getactor(actor, applyRid)

    if not applyActor then
        tipinfo(actor, "申请者不存在")
        return
    end

    -- 超时未响应
    if not this.isInviting(actor) then
        this.cancelTrade(actor, CALCEL_TYPE.TIMEOUT)
        this.cancelTrade(applyActor, CALCEL_TYPE.TIMEOUT)
        return
    end

    -- 再次检查是否在副本中
    if this.isInDuplicate(actor) or this.isInDuplicate(applyActor) then
        noticeTip.noticeinfo(actor, STRING_TIP.IN_DUPLICATE)
        noticeTip.noticeinfo(applyActor, STRING_TIP.IN_DUPLICATE)
        return
    end

    -- 再次检查距离
    if not this.checkDistance(actor, applyActor) then
        noticeTip.noticeinfo(actor, STRING_TIP.DISTANCE_TOO_FAR)
        noticeTip.noticeinfo(applyActor, STRING_TIP.DISTANCE_TOO_FAR)
        return
    end

    -- 检查战斗状态
    if this.isFighting(actor, applyActor) then
        tipinfo(actor, "战斗中无法交易")
        return
    end

    -- 检查双方是否已在交易中
    if this.isTrading(actor) or this.isTrading(applyActor) then
        tipinfo(actor, "您或对方正在交易中")
        return
    end

    -- 开始交易
    this.startTrade(actor, applyActor)
end

-- 拒绝交易申请
function FaceToFaceTrade.rejectTrade(actor)
    local applyRid = getplaydef(actor, __PLAYER_TRADE_TARGET)
    if not applyRid then
        tipinfo(actor, "您没有收到交易申请")
        return
    end
    local applyActor = getactor(actor, applyRid)

    -- 清除邀请记录
    setplaydef(actor, __PLAYER_TRADE_INVITE_TIME, nil)
    setplaydef(actor, __PLAYER_TRADE_TARGET, nil)

    if applyActor then
        tipinfo(applyActor, getbaseinfo(actor, "rolename") .. "拒绝了您的交易请求")
    end
    local log = getbaseinfo(actor, "rolename") .. "拒绝了" .. getbaseinfo(applyActor, "rolename") .. "[" .. applyRid .. "]" .. "的交易请求"
    gameDebug.print(actor, log)
    this.log(actor, log)
end

-- ==================== 交易流程 ====================

-- 开始交易
function this.startTrade(actor1, actor2)
    if isdead(actor1) or isdead(actor2) then
        this.cancelTrade(actor1, CALCEL_TYPE.PLAYER_DEAD)
        this.cancelTrade(actor2, CALCEL_TYPE.PLAYER_DEAD)
        return
    end
    -- 记录交易开始时间
    local now = getbaseinfo(actor1, "nowsec")

    -- 初始化交易状态
    this.initTradeState(actor1, actor2, now)
    this.initTradeState(actor2, actor1, now)

    -- 获取交易栏格子数
    local tradeSlots = tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", FACE_TRADE_CONFIG.TRADE_SLOTS))
    if not tradeSlots then
        tradeSlots = 10
    end
    sendluamsg(actor1, LuaMessageIdToClient.RES_FACE_TRADE_START, {
        targetRid = actor2:toString(),
        tradeSlots = tradeSlots
    })

    sendluamsg(actor2, LuaMessageIdToClient.RES_FACE_TRADE_START, {
        targetRid = actor1:toString(),
        tradeSlots = tradeSlots
    })
    local log = getbaseinfo(actor1, "rolename") .. "已同意" .. getbaseinfo(actor2, "rolename") .. "[" .. actor2:toString() .. "]" .. "发起的交易申请, 开始交易"
    gameDebug.print(actor1, log)
    this.log(actor1, log)
end

-- 初始化交易状态
function this.initTradeState(actor, targetActor, startTime)
    setplaydef(actor, __PLAYER_TRADE_STATE, TRADE_STATE.TRADING)
    setplaydef(actor, __PLAYER_TRADE_TARGET, targetActor:toString())
    setplaydef(actor, __PLAYER_TRADE_ITEMS, {})
    setplaydef(actor, __PLAYER_TRADE_CURRENCY, this.initCurrencyGrid())
    setplaydef(actor, __PLAYER_TRADE_START_TIME, startTime)
end

function this.initCurrencyGrid()
    local currencyIdStr = ConfigDataManager.getTableValue("cfg_global", "value", "id", FACE_TRADE_CONFIG.CURRENCY_ID)
    local currencyGrids = {}
    if not string.isNullOrEmpty(currencyIdStr) then
        local idList = string.splitInt(currencyIdStr, "#")
        if table.isEmpty(idList) then
            gameDebug.error("交易货币ID配置错误")
            return currencyGrids
        end
        for _, cfgId in ipairs(idList) do
            table.insert(currencyGrids, { cfgId = cfgId, amount = 0 })
        end
    end
    return currencyGrids
end

-- 检查是否在交易中
function this.isTrading(actor)
    local state = getplaydef(actor, __PLAYER_TRADE_STATE) or TRADE_STATE.IDLE
    return state ~= TRADE_STATE.IDLE
end

function this.isInviting(actor)
    -- 检查是否在邀请倒计时中（30秒内未拒绝）
    local inviteTime = getplaydef(actor, __PLAYER_TRADE_INVITE_TIME)
    if inviteTime then
        local now = getbaseinfo(actor, "nowsec")
        local timeout = tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", FACE_TRADE_CONFIG.ACCEPT_TIMEOUT))
        if not timeout then
            timeout = 30
        end
        -- 如果还在30秒倒计时中
        if (now - inviteTime) < timeout then
            return true
        end
    end
    return false
end

-- ==================== 放入道具/货币 ====================

-- 放入道具到交易栏
function FaceToFaceTrade.addItemToTrade(actor, msgData)
    -- 检查是否在交易中
    if not this.isTrading(actor) then
        tipinfo(actor, "您未在交易中")
        return
    end

    if isdead(actor) then
        tipinfo(actor, "您已死亡, 无法交易")
        return
    end

    -- 检查交易超时
    if this.checkTradeTimeout(actor) then
        return
    end

    -- 检查是否已锁定
    local state = getplaydef(actor, __PLAYER_TRADE_STATE)
    if state >= TRADE_STATE.LOCKED then
        tipinfo(actor, "交易栏已锁定,无法添加道具")
        return
    end

    -- 检查交易栏格子数
    local tradeItems = getplaydef(actor, __PLAYER_TRADE_ITEMS) or {}
    local tradeSlots = tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", FACE_TRADE_CONFIG.TRADE_SLOTS))
    if not tradeSlots then
        tradeSlots = 10
    end

    if table.count(tradeItems) >= tradeSlots then
        noticeTip.noticeinfo(actor, STRING_TIP.TRADE_SLOTS_FULL)
        return
    end

    local itemId = tonumber(msgData.itemId)
    local index = tonumber(msgData.index)

    if not this.checkTradeSlotsId(actor, itemId) then
        return
    end

    -- 获取道具信息
    local itemInfo = getbagiteminfo(actor, itemId, 1)
    if table.isEmpty(itemInfo) then
        tipinfo(actor, "背包不存在该道具")
        return
    end
    local itemCfgId = itemInfo.cfgid
    local itemCount = itemInfo.count
    local itemCfg = ConfigDataManager.getById("cfg_item", itemCfgId)
    if table.isEmpty(itemCfg) then
        gameDebug.error("道具配置不存在", itemCfgId)
        return
    end

    local lockitem = tonumber(itemCfg.lockitem) or 0
    if lockitem ~= 1 then
        tipinfo(actor, "绑定货币无法交易")
        return
    end

    local tradeFacetoFace = tonumber(itemCfg.tradefacetoface) or 0
    if tradeFacetoFace ~= 0 then
        tipinfo(actor, "该道具不可交易")
        return
    end
    -- 添加到交易栏
    local buildItem = ItemFactory.build(itemInfo)
    buildItem.index = index
    buildItem.type = itemInfo.type
    table.insert(tradeItems, buildItem)
    setplaydef(actor, __PLAYER_TRADE_ITEMS, tradeItems)
    local itemLogs = this.getItemLogs(tradeItems)
    local log = getbaseinfo(actor, "rolename") .. "已添加道具" .. "道具id " .. itemId .. " 配置id " .. itemCfgId .. " x " .. itemCount .. "到交易栏" .. " 当前交易栏道具：" .. itemLogs
    gameDebug.print(actor, log)
    this.log(actor, log)
    -- 通知双方更新交易界面
    this.notifyTradeUpdate(actor)
end

function this.checkTradeSlotsId(actor, itemId)
    -- 检查有没有重复id
    local tradeItems = getplaydef(actor, __PLAYER_TRADE_ITEMS) or {}
    for _, item in ipairs(tradeItems) do
        local id = item.id
        if tonumber(itemId) == tonumber(id) then
            return false
        end
    end
    return true
end

-- 放入货币到交易栏
function FaceToFaceTrade.addCurrencyToTrade(actor, msgData)
    -- 检查是否在交易中
    if not this.isTrading(actor) then
        tipinfo(actor, "您未在交易中")
        return
    end

    if isdead(actor) then
        tipinfo(actor, "您已死亡, 无法交易")
        return
    end

    -- 检查交易超时
    if this.checkTradeTimeout(actor) then
        return
    end

    -- 检查是否已锁定
    local state = getplaydef(actor, __PLAYER_TRADE_STATE)
    if state >= TRADE_STATE.LOCKED then
        tipinfo(actor, "交易栏已锁定,无法添加货币")
        return
    end

    local currencyId = tonumber(msgData.currencyId)
    local amount = tonumber(msgData.amount)

    -- 检查货币数量，如果输入超过持有数量，直接放满
    local haveAmount = getbagitemcountbyid(actor, currencyId, -1, 2)
    if amount > haveAmount then
        amount = haveAmount
    end

    if amount < 0 then
        return
    end

    -- 检查是否为绑定货币
    local itemCfg = ConfigDataManager.getById("cfg_item", currencyId)
    if table.isNullOrEmpty(itemCfg) then
        gameDebug.error("货币配置不存在", currencyId)
        return
    end

    -- 检查绑定属性
    local lockitem = tonumber(itemCfg.lockitem) or 0
    if lockitem ~= 1 then
        tipinfo(actor, "绑定货币无法交易")
        return
    end

    local tradeFacetoFace = tonumber(itemCfg.tradefacetoface) or 0
    if tradeFacetoFace > 0 then
        tipinfo(actor, "该道具不可交易")
        return
    end

    -- 设置交易货币
    local currencyGrids = getplaydef(actor, __PLAYER_TRADE_CURRENCY) or this.initCurrencyGrid()
    for _, grid in ipairs(currencyGrids) do
        if grid.cfgId == currencyId then
            grid.amount = amount
            break
        end
    end
    setplaydef(actor, __PLAYER_TRADE_CURRENCY, currencyGrids)
    local currencyLogs = this.getCurrencyLogs(currencyGrids)
    local log = getbaseinfo(actor, "rolename") .. "已添加货币" .. currencyId .. " x " .. amount .. "到交易栏" .. " 当前交易栏货币：" .. currencyLogs
    gameDebug.print(actor, log)
    this.log(actor, log)
    -- 通知双方更新交易界面
    this.notifyTradeUpdate(actor)
end

-- 移除道具
function FaceToFaceTrade.removeItemFromTrade(actor, itemId)
    if isdead(actor) then
        tipinfo(actor, "您已死亡, 无法交易")
        return
    end
    -- 检查交易超时
    if this.checkTradeTimeout(actor) then
        return
    end

    -- 检查是否已锁定
    local state = getplaydef(actor, __PLAYER_TRADE_STATE)
    if state >= TRADE_STATE.LOCKED then
        tipinfo(actor, "交易栏已锁定,无法移除道具")
        return
    end

    itemId = tonumber(itemId)
    local tradeItems = getplaydef(actor, __PLAYER_TRADE_ITEMS) or {}

    for i, item in ipairs(tradeItems) do
        if item.id == itemId then
            table.remove(tradeItems, i)
            break
        end
    end
    setplaydef(actor, __PLAYER_TRADE_ITEMS, tradeItems)
    local itemLogs = this.getItemLogs(tradeItems)
    local log = getbaseinfo(actor, "rolename") .. "已从交易栏移除道具" .. itemId .. " 当前交易栏道具：" .. itemLogs
    gameDebug.print(actor, log)
    this.log(actor, log)

    -- 通知双方更新交易界面
    this.notifyTradeUpdate(actor)
end

-- ==================== 锁定交易栏 ====================
function FaceToFaceTrade.toggleLock(actor)
    callonserial(actor, "facetradetogglelock")
end

-- 锁定/解锁交易栏
function facetradetogglelock(actor)
    if not this.isTrading(actor) then
        tipinfo(actor, "您未在交易中")
        return
    end

    -- 检查交易超时
    if this.checkTradeTimeout(actor) then
        return
    end

    local targetRid = getplaydef(actor, __PLAYER_TRADE_TARGET)
    if not targetRid then
        this.cancelTrade(actor, CALCEL_TYPE.TARGET_NOT_EXIST)
        return
    end
    local targetActor = getactor(actor, targetRid)
    if not targetActor then
        this.cancelTrade(actor, CALCEL_TYPE.TARGET_NOT_EXIST)
        return
    end
    local state = getplaydef(actor, __PLAYER_TRADE_STATE)
    local targetState = getplaydef(targetActor, __PLAYER_TRADE_STATE)

    if state == TRADE_STATE.CONFIRMED then
        -- 已确认状态下，锁定按钮不可点击解锁
        tipinfo(actor, "已确认状态下无法解锁")
        return
    elseif state == TRADE_STATE.LOCKED then
        -- 解锁
        setplaydef(actor, __PLAYER_TRADE_STATE, TRADE_STATE.TRADING)
        -- 把对方也解锁
        if targetState >= TRADE_STATE.LOCKED then
            tipinfo(targetActor, "对方解除锁定，己方交易栏已解锁")
            setplaydef(targetActor, __PLAYER_TRADE_STATE, TRADE_STATE.TRADING)
        end
    elseif state == TRADE_STATE.TRADING then
        -- 锁定
        setplaydef(actor, __PLAYER_TRADE_STATE, TRADE_STATE.LOCKED)
    end
    local log = getbaseinfo(actor, "rolename") .. "已" .. (state == TRADE_STATE.LOCKED and "解锁" or "锁定") .. "交易栏"
    gameDebug.print(actor, log)
    this.log(actor, log)

    -- 通知双方更新交易界面
    this.notifyTradeUpdate(actor)
end

-- ==================== 确认交易 ====================
function FaceToFaceTrade.toggleConfirm(actor)
    callonserial(actor, "facetradetoggleconfirm")
end

-- 确认/取消确认交易
function facetradetoggleconfirm(actor)
    if not this.isTrading(actor) then
        tipinfo(actor, "您未在交易中")
        return
    end

    -- 检查交易超时
    if this.checkTradeTimeout(actor) then
        return
    end

    local targetRid = getplaydef(actor, __PLAYER_TRADE_TARGET)
    if not targetRid then
        this.cancelTrade(actor, CALCEL_TYPE.TARGET_NOT_EXIST)
        return
    end
    local targetActor = getactor(actor, targetRid)
    if not targetActor then
        this.cancelTrade(actor, CALCEL_TYPE.TARGET_NOT_EXIST)
        return
    end

    local state = getplaydef(actor, __PLAYER_TRADE_STATE)
    local targetState = getplaydef(targetActor, __PLAYER_TRADE_STATE)
    -- 必须先锁定才能确认
    if state < TRADE_STATE.LOCKED then
        tipinfo(actor, "请先锁定交易栏")
        return
    end

    if state == TRADE_STATE.LOCKED then
        -- 检查对方是否也锁定了
        if targetState < TRADE_STATE.LOCKED then
            tipinfo(actor, "对方未锁定交易栏")
            return
        end

        -- 确认交易
        setplaydef(actor, __PLAYER_TRADE_STATE, TRADE_STATE.CONFIRMED)

        if targetState == TRADE_STATE.CONFIRMED then
            -- 双方都确认,执行交易
            this.executeTrade(actor, targetActor)
            return
        end
    elseif state == TRADE_STATE.CONFIRMED then
        -- 取消确认
        setplaydef(actor, __PLAYER_TRADE_STATE, TRADE_STATE.LOCKED)
        -- 把对方也解锁
        if targetState == TRADE_STATE.CONFIRMED then
            setplaydef(targetActor, __PLAYER_TRADE_STATE, TRADE_STATE.LOCKED)
        end
    end
    local log = getbaseinfo(actor, "rolename") .. "已" .. (state == TRADE_STATE.CONFIRMED and "取消确认" or "确认") .. "交易"
    gameDebug.print(actor, log)
    this.log(actor, log)

    -- 通知双方更新交易界面
    this.notifyTradeUpdate(actor)
end

-- ==================== 执行交易 ====================

-- 执行交易(通过交易行底层实现)
function this.executeTrade(actor1, actor2)
    lock(actor1, "face_trade_execute", actor2:toString())
end

function face_trade_execute(actor1, actor2Rid)
    local actor2 = getactor(actor1, actor2Rid)
    if not actor2 then
        this.cancelTrade(actor1, CALCEL_TYPE.TARGET_NOT_EXIST)
        return
    end

    if isdead(actor1) or isdead(actor2) then
        this.cancelTrade(actor1, CALCEL_TYPE.PLAYER_DEAD)
        this.cancelTrade(actor2, CALCEL_TYPE.PLAYER_DEAD)
        return
    end
    -- 获取双方交易物品和货币
    local items1 = getplaydef(actor1, __PLAYER_TRADE_ITEMS) or {}
    local currency1 = getplaydef(actor1, __PLAYER_TRADE_CURRENCY) or this.initCurrencyGrid()

    local items2 = getplaydef(actor2, __PLAYER_TRADE_ITEMS) or {}
    local currency2 = getplaydef(actor2, __PLAYER_TRADE_CURRENCY) or this.initCurrencyGrid()
    if table.isEmpty(items1) and table.isEmpty(items2) and this.checkCurrencyEmpty(currency1) and this.checkCurrencyEmpty(currency2) then
        this.cancelTrade(actor1, CALCEL_TYPE.NO_TRADE_ITEM)
        this.cancelTrade(actor2, CALCEL_TYPE.NO_TRADE_ITEM)
        return
    end
    -- 验证道具和货币是否还存在
    if not this.validateTradeItems(actor1, items1, currency1) then
        this.cancelTrade(actor1, CALCEL_TYPE.INVALID_TRADE_ITEM)
        this.cancelTrade(actor2, CALCEL_TYPE.INVALID_TRADE_ITEM)
        return
    end

    if not this.validateTradeItems(actor2, items2, currency2) then
        this.cancelTrade(actor1, CALCEL_TYPE.INVALID_TRADE_ITEM)
        this.cancelTrade(actor2, CALCEL_TYPE.INVALID_TRADE_ITEM)
        return
    end

    local itemlog1, currencylog1 = this.getItemLogs(items1), this.getCurrencyLogs(currency1)
    local itemlog2, currencylog2 = this.getItemLogs(items2), this.getCurrencyLogs(currency2)

    gameDebug.print(actor1, getbaseinfo(actor1, "rolename"), "开始执行交易", "交易物品1：", itemlog1, "交易货币1：", currencylog1)
    gameDebug.print(actor2, getbaseinfo(actor2, "rolename"), "开始执行交易", "交易物品2：", itemlog2, "交易货币2：", currencylog2)

    this.log(actor1, getbaseinfo(actor1, "rolename") .. "开始执行交易" .. "交易物品：" .. itemlog1 .. "交易货币：" .. currencylog1)
    this.log(actor2, getbaseinfo(actor2, "rolename") .. "开始执行交易" .. "交易物品：" .. itemlog2 .. "交易货币：" .. currencylog2)

    -- 通过交易行上架和购买实现交易
    -- 玩家1上架物品,玩家2购买
    local result1, transferredItems1 = this.tradeItemsViaAuctionHouse(actor1, actor2, items1, currency1)
    if not result1 then
        this.cancelTrade(actor1, CALCEL_TYPE.TRADE_FAILED)
        this.cancelTrade(actor2, CALCEL_TYPE.TRADE_FAILED)
        return
    end

    -- 玩家2上架物品,玩家1购买
    local result2, transferredItems2 = this.tradeItemsViaAuctionHouse(actor2, actor1, items2, currency2)
    if not result2 then
        gameDebug.print(actor1, "玩家", actor2:toString(), "交易失败，开始回滚", actor1:toString(), "的交易")
        this.log(actor1, "玩家" .. actor2:toString() .. "交易失败，开始回滚" .. "我的(" .. actor1:toString() .. ")的交易")
        this.log(actor2, "我的(" .. actor2:toString() .. ")交易失败，开始回滚" .. "玩家(" .. actor1:toString() .. ")的交易")
        -- 回滚玩家1的交易物品
        intervalcalldelay(actor1, 500, 500, 1, "rollbackfacetrade", actor2, transferredItems1)
        -- 回滚玩家2的交易物品
        intervalcalldelay(actor2, 600, 500, 1, "rollbackfacetrade", actor1, transferredItems2)
        this.cancelTrade(actor1, CALCEL_TYPE.TRADE_FAILED)
        this.cancelTrade(actor2, CALCEL_TYPE.TRADE_FAILED)
        return
    end

    -- 交易成功
    this.completeTrade(actor1, actor2)
end

function rollbackfacetrade(seller, buyer, transferredItems)
    this.rollbackTrade(seller, buyer, transferredItems)
end

-- 验证交易物品
function this.validateTradeItems(actor, items, currency)
    -- 验证道具
    for _, item in ipairs(items) do
        local itemInfo = getbagiteminfo(actor, item.id, 1)
        if itemInfo.count < item.count then
            return false
        end
    end

    -- 验证货币
    for i, currencyGrid in pairs(currency) do
        if currencyGrid.amount > 0 then
            local haveAmount = getbagitemcountbyid(actor, currencyGrid.cfgId, -1, 2)
            if haveAmount < currencyGrid.amount then
                return false
            end
        end
    end

    return true
end

function this.checkCurrencyEmpty(currency)
    for i, currencyGrid in pairs(currency) do
        if currencyGrid.amount > 0 then
            return false
        end
    end
    return true
end

-- 通过交易行实现交易
function this.tradeItemsViaAuctionHouse(seller, buyer, items, currency)

    -- 获取税率
    local taxRate = this.getTaxRate()

    -- 创建记录已转移的物品和货币, 用于回滚
    local transferredItems = {
        items = {},
        currency = {}
    }

    for _, item in ipairs(items) do
        -- 上架物品
        local upShelfData = {
            itemcfgid = tostring(item.cfgId),
            count = tostring(item.count),
            bagindex = tostring(item.index),
            ignorebind = tostring(1)
        }

        -- 调用交易行上架(需要修改为面对面交易模式)
        local result = bagtoshell(seller, upShelfData, 1)
        if result.reason ~= 0 then
            return false, nil
        end

        -- 直接转移给买家
        local ret = shelltobag(seller, seller:toString(), item.id, item.count, buyer:toString(), 0, nil, nil, ItemActionProxy.FACE_TRADE)
        if ret.reason ~= 0 then
            return false, nil
        end

        -- 记录已转移的物品
        table.insert(transferredItems.items, {
            cfgId = ret.itemcfgid,
            count = ret.count,
            id = ret.itemid,
            type = item.type
        })
    end

    -- 转移货币
    for i, currencyGrid in pairs(currency) do
        if currencyGrid.amount > 0 then
            -- 计算税款
            local taxAmount = math.floor(currencyGrid.amount * taxRate)
            local netAmount = currencyGrid.amount - taxAmount

            -- 从卖家扣除原始金额
            local res = removeitemfrombag(seller, currencyGrid.cfgId, currencyGrid.amount, 0, 9999)
            if not res or res == 0 then
                return false, nil
            end

            -- 将净额给予买家
            if netAmount > 0 then
                local ids = additemmaptobag(buyer, { [currencyGrid.cfgId] = netAmount }, 0, 9999)
                -- 金币不返回唯一id
                if not ids then
                    return false, nil
                end
            end

            -- 处理税款
            if taxAmount > 0 then
                this.handleTax(taxAmount, currencyGrid.cfgId, seller, buyer)
            end

            -- 记录已转移的货币（仅记录净额部分）
            table.insert(transferredItems.currency, {
                cfgId = currencyGrid.cfgId,
                amount = netAmount
            })
        end
    end
    return true, transferredItems
end

-- 回滚交易
function this.rollbackTrade(seller, buyer, transferredItems)
    if not transferredItems then
        return
    end
    -- 回滚物品
    for _, item in ipairs(transferredItems.items) do
        local type = item.type
        if type == ItemType.EQUIP then
            -- 装备可以直接从买家背包中直接找到, 因为进包的时候id没变
            -- 从买家背包中找到该物品
            local itemInfo = getbagiteminfo(buyer, item.id, 1)
            -- 买家上架物品
            local upShelfData = {
                itemcfgid = tostring(item.cfgId),
                count = tostring(item.count),
                bagindex = tostring(itemInfo.bagindex),
                ignorebind = tostring(1)
            }
            local result = bagtoshell(buyer, upShelfData, 1)
            if result.reason == 0 then
                -- 直接转移回卖家
                local ret = shelltobag(buyer, buyer:toString(), item.id, item.count, seller:toString(), 0, nil, nil, ItemActionProxy.FACE_TRADE)
                if ret.reason == 0 then
                    gameDebug.print(seller, buyer, "回滚装备物品:", item.cfgId, "数量:", item.count)
                    this.log(seller, "回滚给" .. getbaseinfo(seller, "rolename") .. "装备物品" .. item.cfgId .. "数量" .. item.count)
                else
                    gameDebug.error(seller, buyer, "回滚装备失败:", item.cfgId, "数量:", item.count, "reason:", ret.reason)
                end
            else
                gameDebug.error(seller, buyer, "回滚装备失败:", item.cfgId, "数量:", item.count, "reason:", result.reason)
            end
        else
            -- 非装备根据cfgid回滚
            local removed = removeitemfrombag(buyer, item.cfgId, item.count, 0, 9999)
            if removed then
                -- 归还给卖家
                local ids = additemmaptobag(seller, { [item.cfgId] = item.count }, 0, 9999)
                if not ids then
                    gameDebug.error(seller, buyer, "回滚道具失败:", item.cfgId, "数量:", item.count)
                else
                    gameDebug.print(seller, buyer, "回滚道具:", item.cfgId, "数量:", item.count)
                    this.log(seller, "回滚给" .. getbaseinfo(seller, "rolename") .. "道具" .. item.cfgId .. "数量" .. item.count)
                end
            else
                gameDebug.error(seller, buyer, "回滚道具失败:", item.cfgId, "数量:", item.count)
            end
        end
    end

    -- 回滚货币
    for _, currencyItem in ipairs(transferredItems.currency) do
        -- 从买家背包移除货币（净额）
        local removed = removeitemfrombag(buyer, currencyItem.cfgId, currencyItem.amount, 0, 9999)
        if removed then
            -- 归还给卖家（原始金额，包含税款部分）
            local originalAmount = math.floor(currencyItem.amount / (1 - this.getTaxRate()))
            local ids = additemmaptobag(seller, { [currencyItem.cfgId] = originalAmount }, 0, 9999)
            -- 金币不返回唯一id
            if not ids then
                gameDebug.error(seller, buyer, "回滚货币失败:", currencyItem.cfgId, "数量:", originalAmount)
            else
                gameDebug.print(seller, buyer, "回滚货币:", currencyItem.cfgId, "数量:", originalAmount)
                this.log(seller, "回滚给" .. getbaseinfo(seller, "rolename") .. "货币" .. currencyItem.cfgId .. "数量" .. originalAmount)
            end
        else
            gameDebug.error(seller, buyer, "回滚货币失败:", currencyItem.cfgId, "数量:", currencyItem.amount)
        end
    end
end

-- 完成交易
function this.completeTrade(actor1, actor2)
    -- 清理交易状态
    this.clearTradeState(actor1)
    this.clearTradeState(actor2)
    this.log(actor1, "完成交易")
    this.log(actor2, "完成交易")

    -- 通知双方交易成功
    sendluamsg(actor1, LuaMessageIdToClient.RES_FACE_TRADE_SUCCESS, {})
    sendluamsg(actor2, LuaMessageIdToClient.RES_FACE_TRADE_SUCCESS, {})
end

-- ==================== 取消交易 ====================

-- 取消交易
function FaceToFaceTrade.cancelTrade(actor)
    if not this.isTrading(actor) then
        return
    end
    local targetRid = getplaydef(actor, __PLAYER_TRADE_TARGET)
    if targetRid then
        local targetActor = getactor(actor, targetRid)
        this.cancelTrade(targetActor, CALCEL_TYPE.CANCELLED)
        this.log(targetActor, "取消交易")
    end
    this.cancelTrade(actor, CALCEL_TYPE.CANCELLED)
    this.log(actor, "取消交易")
end

-- 取消交易
function this.cancelTrade(actor, reason)
    if not this.isTrading(actor) then
        return
    end

    -- 清理交易状态
    this.clearTradeState(actor)

    -- 通知取消
    sendluamsg(actor, LuaMessageIdToClient.RES_FACE_TRADE_CANCEL, {
        reason = reason or CALCEL_TYPE.DEFAULT
    })
end

-- 清理交易状态
function this.clearTradeState(actor)
    setplaydef(actor, __PLAYER_TRADE_STATE, TRADE_STATE.IDLE)
    setplaydef(actor, __PLAYER_TRADE_TARGET, nil)
    setplaydef(actor, __PLAYER_TRADE_ITEMS, nil)
    setplaydef(actor, __PLAYER_TRADE_CURRENCY, nil)
    setplaydef(actor, __PLAYER_TRADE_START_TIME, nil)
    setplaydef(actor, __PLAYER_TRADE_INVITE_TIME, nil)
end

-- ==================== 通知更新 ====================

-- 通知交易界面更新
function this.notifyTradeUpdate(actor)
    local targetRid = getplaydef(actor, __PLAYER_TRADE_TARGET)
    if not targetRid then
        this.cancelTrade(actor, CALCEL_TYPE.TARGET_NOT_EXIST)
        return
    end
    local targetActor = getactor(actor, targetRid)
    if not targetActor then
        this.cancelTrade(actor, CALCEL_TYPE.TARGET_NOT_EXIST)
        return
    end

    -- 获取自己的交易信息
    local myItems = getplaydef(actor, __PLAYER_TRADE_ITEMS) or {}
    local myCurrency = getplaydef(actor, __PLAYER_TRADE_CURRENCY) or this.initCurrencyGrid()
    local myState = getplaydef(actor, __PLAYER_TRADE_STATE)

    -- 获取对方的交易信息
    local targetItems = getplaydef(targetActor, __PLAYER_TRADE_ITEMS) or {}
    local targetCurrency = getplaydef(targetActor, __PLAYER_TRADE_CURRENCY) or this.initCurrencyGrid()
    local targetState = getplaydef(targetActor, __PLAYER_TRADE_STATE)

    -- 发送给自己
    sendluamsg(actor, LuaMessageIdToClient.RES_FACE_TRADE_UPDATE, {
        myItems = myItems,
        myCurrency = myCurrency,
        myState = myState,
        targetItems = targetItems,
        targetCurrency = targetCurrency,
        targetState = targetState
    })

    -- 发送给对方
    sendluamsg(targetActor, LuaMessageIdToClient.RES_FACE_TRADE_UPDATE, {
        myItems = targetItems,
        myCurrency = targetCurrency,
        myState = targetState,
        targetItems = myItems,
        targetCurrency = myCurrency,
        targetState = myState
    })
end

-- ==================== 其他辅助功能 ====================

-- 玩家下线时自动取消交易
function FaceToFaceTrade.onPlayerLogout(actor)
    if this.isTrading(actor) then
        local targetRid = getplaydef(actor, __PLAYER_TRADE_TARGET)
        if targetRid then
            local targetActor = getactor(actor, targetRid)
            this.cancelTrade(targetActor, CALCEL_TYPE.OFFLINE)
        end
        this.clearTradeState(actor)
    end
end

-- 玩家移动时检查距离（交易中禁止移动）
function FaceToFaceTrade.onPlayerMove(actor)
    if not this.isTrading(actor) then
        return
    end

    local targetRid = getplaydef(actor, __PLAYER_TRADE_TARGET)
    if not targetRid then
        this.cancelTrade(actor, CALCEL_TYPE.TARGET_NOT_EXIST)
        return
    end
    local targetActor = getactor(actor, targetRid)
    -- 检查距离,如果超出范围则取消交易
    if not this.checkDistance(actor, targetActor) then
        this.cancelTrade(actor, CALCEL_TYPE.DISTANCE_TOO_FAR)
        this.cancelTrade(targetActor, CALCEL_TYPE.DISTANCE_TOO_FAR)
    end
end

-- 玩家死亡时取消交易
function FaceToFaceTrade.onPlayerDie(actor)
    if not this.isTrading(actor) then
        return
    end

    local targetRid = getplaydef(actor, __PLAYER_TRADE_TARGET)
    if targetRid then
        local targetActor = getactor(actor, targetRid)
        this.cancelTrade(targetActor, CALCEL_TYPE.PLAYER_DEAD)
    end
    this.cancelTrade(actor, CALCEL_TYPE.PLAYER_DEAD)
end

-- 检查交易超时（15分钟）
function this.checkTradeTimeout(actor)
    local startTime = getplaydef(actor, __PLAYER_TRADE_START_TIME)
    if not startTime then
        return false
    end

    local now = getbaseinfo(actor, "nowsec")
    local timeout = tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", FACE_TRADE_CONFIG.TRADE_TIMEOUT))
    if not timeout then
        timeout = 15 -- 默认15分钟
    end
    timeout = timeout * 60

    if (now - startTime) >= timeout then
        -- 超时，取消交易
        local targetRid = getplaydef(actor, __PLAYER_TRADE_TARGET)
        if not targetRid then
            this.cancelTrade(actor, CALCEL_TYPE.TARGET_NOT_EXIST)
            return true
        end
        local targetActor = getactor(actor, targetRid)
        if not targetActor then
            this.cancelTrade(actor, CALCEL_TYPE.TARGET_NOT_EXIST)
            return true
        end
        this.cancelTrade(actor, CALCEL_TYPE.TIMEOUT)
        noticeTip.noticeinfo(actor, STRING_TIP.TRADE_TIMEOUT)

        if targetActor then
            this.cancelTrade(targetActor, CALCEL_TYPE.TIMEOUT)
            noticeTip.noticeinfo(targetActor, STRING_TIP.TRADE_TIMEOUT)
        end

        return true
    end
    return false
end

function this.getCurrencyLogs(currency)
    local logs = ""
    for _, ite in ipairs(currency) do
        local cfgId = ite.cfgId
        local amount = ite.amount
        local currentLog = "| 货币id " .. cfgId .. " 数量 " .. amount .. "\n"
        logs = logs .. " " .. currentLog
    end
    return logs
end

function this.getItemLogs(items)
    local logs = ""
    for _, ite in ipairs(items) do
        local itemLog = this.getItemLog(ite)
        logs = logs .. " " .. itemLog .. "\n"
    end
    return logs
end

function this.getItemLog(item)
    local id = item.id
    local cfgId = item.cfgId
    local count = item.count
    return " | 道具id " .. id .. " 配置id " .. cfgId .. " 数量 " .. count
end

function this.log(actor, content)
    local mapid = getbaseinfo(actor, "mapid")
    local line = getbaseinfo(actor, "line")
    local prefix = "[地图 " .. mapid .. " : " .. line .. "] "
    gameDebug.debug(LogManager.log, actor, LogRecordType.faceToFaceTrade, prefix .. content)
end

MessageRouter:register(LuaMessageIdToSever.REQ_FACE_TRADE_APPLY, FaceToFaceTrade.applyTrade)
MessageRouter:register(LuaMessageIdToSever.REQ_FACE_TRADE_AGREE, FaceToFaceTrade.agreeTrade)
MessageRouter:register(LuaMessageIdToSever.REQ_FACE_TRADE_REJECT, FaceToFaceTrade.rejectTrade)
MessageRouter:register(LuaMessageIdToSever.REQ_FACE_TRADE_ADD_ITEM, FaceToFaceTrade.addItemToTrade)
MessageRouter:register(LuaMessageIdToSever.REQ_FACE_TRADE_ADD_CURRENCY, FaceToFaceTrade.addCurrencyToTrade)
MessageRouter:register(LuaMessageIdToSever.REQ_FACE_TRADE_REMOVE_ITEM, FaceToFaceTrade.removeItemFromTrade)
MessageRouter:register(LuaMessageIdToSever.REQ_FACE_TRADE_TOGGLE_LOCK, FaceToFaceTrade.toggleLock)
MessageRouter:register(LuaMessageIdToSever.REQ_FACE_TRADE_TOGGLE_CONFIRM, FaceToFaceTrade.toggleConfirm)
MessageRouter:register(LuaMessageIdToSever.REQ_FACE_TRADE_CANCEL, FaceToFaceTrade.cancelTrade)


-- ====================================测试========================================
function testfacetofacetrade(actor, ...)
    local args = { ... }
    local opt = tonumber(args[1])
    if opt == 1 then
        -- @lua testfacetofacetrade 1 24701009897445376
        FaceToFaceTrade.applyTrade(actor, args[2])
    elseif opt == 2 then
        -- @lua testfacetofacetrade 2
        FaceToFaceTrade.agreeTrade(actor)
    elseif opt == 3 then
        -- @lua testfacetofacetrade 3
        FaceToFaceTrade.rejectTrade(actor)
    elseif opt == 4 then
        -- @lua testfacetofacetrade 4 {itemId=24701010056288258,index=10101}
        local func = load("return " .. args[2])
        local table1 = func()
        FaceToFaceTrade.addItemToTrade(actor, table1)
    elseif opt == 5 then
        -- @lua testfacetofacetrade 5 {currencyId=10010001,amount=1000000}
        local func = load("return " .. args[2])
        local table1 = func()
        FaceToFaceTrade.addCurrencyToTrade(actor, table1)
    elseif opt == 6 then
        -- @lua testfacetofacetrade 6 10000
        FaceToFaceTrade.removeItemFromTrade(actor, args[2])
    elseif opt == 7 then
        -- @lua testfacetofacetrade 7
        FaceToFaceTrade.toggleLock(actor)
    elseif opt == 8 then
        -- @lua testfacetofacetrade 8
        FaceToFaceTrade.toggleConfirm(actor)
    elseif opt == 9 then
        -- @lua testfacetofacetrade 9
        FaceToFaceTrade.cancelTrade(actor)
    elseif opt == 10 then
        this.clearTradeState(actor)
    elseif opt == 11 then
        local taxRate = this.getTaxRate()
        tipinfo(actor, "当前交易税率: " .. (taxRate * 100) .. "%")
    end
end
