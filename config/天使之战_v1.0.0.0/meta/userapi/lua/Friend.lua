
Friend = {}


 -- 获取是否添加仇敌
function Friend.enemyaddbefore(actor,killRid)
    -- error("开始添加仇敌")
    local enemyValue = ConfigDataManager.getTableValue("cfg_global","value","id",1801)
    addenemy(actor,killRid,enemyValue)
    -- error("添加仇敌结束")
end

function frienddegreechange(actor,targetId,friendType,likeLevel)
    local msgData = {targetId = targetId, friendType = friendType, likeLevel = likeLevel}
    sendluamsg(actor,LuaMessageIdToClient.FRIEND_DEGREE_CHANGE,msgData)
end

-- 给好友送花
function Friend.sendflower(actor,msgID,msgData)
    local flowerCfgId = tonumber(msgData[1])
    local flowerTable = {61200001, 61200002, 61200003}
    local isFlower = table.contains(flowerTable,flowerCfgId)
    if not isFlower then
        info(actor, actor:toString() .. "花的配置id不对")
        return
    end
    local haveCount = getbagitemcountbyid(actor,flowerCfgId)
    if haveCount < 1 then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT346)
        return
    end
    local useParam = ConfigDataManager.getTableValue("cfg_item", "useParam", "id", flowerCfgId)
    local useParamTable = string.split(useParam,'#')
    local deleteFlower = removeitemfrombag(actor,flowerCfgId,1,0,9999,'好友')
    if not deleteFlower then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT347)
        return
    end
    local intimacyLevel = tonumber(useParamTable[1])
    local miracleCoinCfgId = tonumber(useParamTable[2])
    local miracleCoinCount = tonumber(useParamTable[3])
    local charmValueCfgId = tonumber(useParamTable[4])
    local charmValueCount = tonumber(useParamTable[5])
    additemtobag(actor,miracleCoinCfgId,miracleCoinCount, 0, 9999, ItemActionProxy.FRIEND)
    additemtootherbag(actor,charmValueCfgId,charmValueCount)
    local degree = setfrienddegree(actor,msgData[2],intimacyLevel)
    sendluamsg(actor,msgID,degree)
end