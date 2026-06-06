-- 提示公告功能
noticeTip = {}

local this = {}

---提示公告通用方法
---@param actor 玩家对象
---@param stringId cfg_string表id
---@param ... 替换的参数
function noticeTip.noticeinfo(actor, stringId, ...)
    noticeTip.noticeinfo0(actor, stringId, nil, ...)
end

function noticeTip.noticeinfo0(actor, stringId, itemList, ...)
    local text = ConfigDataManager.getTableValue("cfg_string", "text", "id", stringId)
    if string.isNullOrEmpty(text) then
        gameDebug.print("noticeinfo ConfigDataManager.getTableValue text is nil")
        return
    end
    local receiver = ConfigDataManager.getTableValue("cfg_string", "receiver", "id", stringId)
    if string.isNullOrEmpty(receiver) then
        gameDebug.print("noticeinfo ConfigDataManager.getTableValue receiver is nil")
        return
    end
    local messageType = ConfigDataManager.getTableValue("cfg_string", "messageType", "id", stringId)
    if string.isNullOrEmpty(messageType) then
        gameDebug.print("noticeinfo ConfigDataManager.getTableValue messageType error")
        return
    end
    local condition = ConfigDataManager.getTableValue("cfg_string", "condition", "id", stringId)
    if string.isNullOrEmpty(condition) then
        gameDebug.print("noticeinfo ConfigDataManager.getTableValue condition error")
        return
    end
    local splitStr = string.split(condition, "|")
    local levelLimit = 0
    local mapLimit = 0
    for i = 1, #splitStr do
        local split = string.split(splitStr[i], "#")
        if tonumber(split[1]) == 1 then
            levelLimit = tonumber(split[2])
        else
            mapLimit = tonumber(split[2])
        end
    end
    if string.find(text, "%%") then
        local content = noticeTip.strreplace(text)
        local args = { ... }
        if #args <= 0 then
            gameDebug.print("noticeinfo params error", stringId, args)
            return
        end
        text = string.format(content, ...)
    end
    -- 敏感词替换成星号
    --text = replacesensitiveword(actor, text)
    this.sendNoticeInfo(actor, tonumber(messageType), stringId, text, receiver, levelLimit, mapLimit, itemList)
end

--- 发送提示公告
---@param actor 玩家对象
---@param messageType 消息类型
---@param stringId cfg_string表id
---@param text 消息内容
---@param receiver 接收者类型
---@param levelLimit 等级限制
---@param mapLimit 地图限制
function this.sendNoticeInfo(actor, messageType, stringId, text, receiver, levelLimit, mapLimit, itemList)
    if StringReceiverType.SYSTEM_SELF == tonumber(receiver) then
        if this.checkCondition(actor, levelLimit, mapLimit) then
            noticeTip.sendMessage(actor, messageType, stringId, text, NoticeChannel.SYSTEM, itemList)
        end
    elseif StringReceiverType.SYSTEM_CURRENT_MAP == tonumber(receiver) then
        local playerIds = getmapplayerids(actor)
        for i = 1, #playerIds do
            local player = getactor(actor, playerIds[i])
            if this.checkCondition(player, levelLimit, 0) then
                noticeTip.sendMessage(player, messageType, stringId, text, NoticeChannel.SYSTEM, itemList)
            end
        end
    elseif StringReceiverType.SYSTEM_SAME_UNION == tonumber(receiver) then
        local unionInfo = getunioninfo(actor)
        if not table.isNullOrEmpty(unionInfo) then
            local members = unionInfo.memberinfos
            if not table.isNullOrEmpty(members) then
                for key, _ in pairs(members) do
                    local player = getactor(actor, key)
                    if this.checkCondition(player, levelLimit, mapLimit) then
                        noticeTip.sendMessage(player, messageType, stringId, text, NoticeChannel.SYSTEM, itemList)
                    end
                end
            end
        end
    elseif StringReceiverType.UNION_SELF == tonumber(receiver) then
        if this.checkCondition(actor, levelLimit, mapLimit) then
            noticeTip.sendMessage(actor, messageType, stringId, text, NoticeChannel.UNION, itemList)
        end
    elseif StringReceiverType.UNION_ALL == tonumber(receiver) then
        local unionInfo = getunioninfo(actor)
        if not table.isNullOrEmpty(unionInfo) then
            local members = unionInfo.memberinfos
            if not table.isNullOrEmpty(members) then
                for key, _ in pairs(members) do
                    local player = getactor(actor, key)
                    if this.checkCondition(player, levelLimit, mapLimit) then
                        noticeTip.sendMessage(player, messageType, stringId, text, NoticeChannel.UNION, itemList)
                    end
                end
            end
        end
    else
        local allPlayer = getallplayer(actor)
        if allPlayer ~= nil then
            for i = 1, #allPlayer do
                local player = getactor(actor, allPlayer[i])
                if this.checkCondition(player, levelLimit, mapLimit) then
                    noticeTip.sendMessage(player, messageType, stringId, text, NoticeChannel.SYSTEM, itemList)
                end
            end
        end
    end
end

--- 根据条件发送对应的lua消息给客户端
---@param actor 玩家对象
---@param messageType 消息类型
---@param stringId cfg_string表id
---@param content 消息内容
---@param channel 聊天通道类型
function noticeTip.sendMessage(actor, messageType, stringId, content, channel, itemList)
    if messageType >= 1 and messageType <= 5 then
        -- 发送聊天消息与跑马灯
        sendluamsg(actor, LuaMessageIdToClient.CHAT, {
            channel = channel,
            content = content,
            itemList = itemList
        })
        sendluamsg(actor, LuaMessageIdToClient.HORSE_LAMP, {
            cfgId = stringId,
            content = content
        })
    elseif messageType == 7 then
        -- 发送聊天消息
        sendluamsg(actor, LuaMessageIdToClient.CHAT, {
            channel = channel,
            content = content,
            itemList = itemList
        })
    elseif messageType == 17 or messageType == 18 then
        -- 发送跑马灯
        sendluamsg(actor, LuaMessageIdToClient.HORSE_LAMP, {
            cfgId = stringId,
            content = content
        })
    else
        -- 发送其他类型的消息
        sendluamsg(actor, LuaMessageIdToClient.OTHER_NOTICE, {
            messageType = messageType,
            cfgId = stringId,
            content = content
        })
        if messageType == 15 then
            -- 发送聊天消息
            sendluamsg(actor, LuaMessageIdToClient.CHAT, {
                channel = channel,
                content = content,
                itemList = itemList
            })
        end
    end
end

--- 替换字符串中的占位符
---@param str 目标字符串
function noticeTip.strreplace(str)
    -- %s：玩家名
    -- %p：充值人民币数
    -- %i：道具名
    -- %g：工会名
    -- %m：地图名
    -- %x：x坐标
    -- %y：y坐标
    -- %d：替换数字
    -- %a：伙伴名称
    -- %b：boss名称
    -- %c：战阶名称
    -- %e：转职名称
    -- %w：翅膀名称
    -- %f ：翅膀品质
    str = string.gsub(str, "%%p", "%%s")
    str = string.gsub(str, "%%i", "%%s")
    str = string.gsub(str, "%%g", "%%s")
    str = string.gsub(str, "%%m", "%%s")
    str = string.gsub(str, "%%x", "%%s")
    str = string.gsub(str, "%%y", "%%s")
    str = string.gsub(str, "%%d", "%%s")
    str = string.gsub(str, "%%a", "%%s")
    str = string.gsub(str, "%%b", "%%s")
    str = string.gsub(str, "%%c", "%%s")
    str = string.gsub(str, "%%e", "%%s")
    str = string.gsub(str, "%%w", "%%s")
    str = string.gsub(str, "%%f", "%%s")
    return str
end

--- 检查等级与地图条件是否满足
---@param player 玩家对象
---@param levelLimit 等级限制
---@param mapLimit 地图限制
function this.checkCondition(player, levelLimit, mapLimit)
    local actorLevel = getbaseinfo(player, "level")
    if levelLimit > 0 and mapLimit > 0 then
        return actorLevel >= levelLimit and isonmap(player, mapLimit)
    end
    if levelLimit > 0 then
        return actorLevel >= levelLimit
    end
    if mapLimit > 0 then
        return isonmap(player, mapLimit)
    end
end


--- 测试公告信息
function testnotice(actor, stringId, ...)
    noticeTip.noticeinfo(actor, stringId, ...)
end
